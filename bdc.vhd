library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bdc is
  Port (DQ   : inout std_logic_vector (7 downto 0);
        RXFi : in    std_logic;
        RDi  :   out std_logic;
        WR   :   out std_logic;
        BDC  : inout std_logic;
        IO   : inout std_logic_vector(2 downto 0) := "ZZZ";
        LED  :   out std_logic_vector(1 downto 0);
        Clk  : in    std_logic);
end bdc;

architecture Behavioral of bdc is
  signal count  : std_logic_vector(7 downto 0) := x"00";
  signal data   : std_logic_vector(3 downto 0) := x"0";

  alias countlo : std_logic_vector(3 downto 0) is count(3 downto 0);
  alias counthi : std_logic_vector(3 downto 0) is count(7 downto 4);

  type state_t is (idle, ack, send_bits, read_bits,
                   sync_wait, sync_gap, sync_init);

  signal state : state_t := idle;

  attribute fsm_encoding : string;
  attribute fsm_encoding of state : signal is "compact";

  signal clkspeed : std_logic_vector(1 downto 0) := "10";

  signal clkdiv : std_logic_vector(1 downto 0) := "00";
  signal Clk_main : std_logic := '0';

  attribute bufg : string;
  attribute bufg of Clk_main : signal is "CLK";

  signal BDCdata : std_logic := '0';
  signal BDCout : boolean := true;
  signal BDCsync : std_logic;

  signal WRint : std_logic := '0';
  signal RDiint : std_logic := '1';

  signal LEDval : std_logic_vector(1 downto 0) := "10";

  constant STOP : std_logic_vector(3 downto 0) := "0011";

  -- 0,1,2,3 - send start pulse.
  -- 4 - drive high for 1.
  -- 10 - sample.
  -- 12 - write result (could do 10,11!).
  -- 13 - drive high for zero.
  -- 14 - start command read (could do 13,14!).
  -- 15 - read next command.

  signal hex_in : boolean;

  constant ACTlen : integer := 13;
  signal ACTcnt : std_logic_vector(ACTlen - 1 downto 0);
  signal ACTidle : boolean;

begin

  RDi <= RDiint;

  WR <= WRint;
  DQ <= counthi & data when WRint = '1' else "ZZZZZZZZ";

  BDC <= BDCdata when BDCout else 'Z';

  LED <= LEDval;

  hex_in <= DQ(7 downto 4) = x"6" or DQ(7 downto 4) = x"3";

  -- The 8MHz input clock gets divided by 1, 2, 3 or 4 to generate Clk_main.
  process (Clk)
  begin
    if Clk'event then
      Clk_main <= Clk_main xor (clkdiv(1) and clkdiv(0));
      if clkdiv = "11" then
        clkdiv <= clkspeed;
      else
        clkdiv <= clkdiv + "01";
      end if;
    end if;
  end process;

  process (Clk_main)
    variable do_bits : boolean;
    variable index : integer;
  begin
    if Clk_main'event then

      -- Maintain the bit and sub-bit number.  Don't modify counthi during ack
      -- because we want to send counthi in the response...
      if state /= ack and state /= idle then
        count <= count + 1;
      else
        countlo <= countlo + 1;
      end if;

      do_bits := state = send_bits or state = read_bits;
      index := conv_integer(STOP(1 downto 0) - counthi(1 downto 0));

      -- During a data cycle, do the BDC data.  During sync, drive low
      -- with one cycle speed up.
      if countlo = x"0" then
        BDCdata <= '0';
      elsif countlo = x"4" and state = send_bits and data(index) = '1' then
        BDCdata <= '1';
      elsif countlo = x"D" and state = send_bits then
        BDCdata <= '1';
      end if;

      -- BDC out enable.
      if countlo = x"0" then
        BDCout <= do_bits or state = sync_init or LEDval(0) = '0';
      end if;
      if countlo = x"4" and state = read_bits then
        BDCout <= false;
      end if;

      -- BDC sampling cycle.
      if countlo = x"A" and state = read_bits then
        data(index) <= data(index) xor BDC;
      end if;

      -- At the end of sync_init, transfer to sync_gap, do the BDC speed-up.
      if state = sync_init and count = x"FF" then
        state <= sync_gap;
        BDCdata <= '1';
      end if;

      -- We need a synchroniser bit on the BDC for the sync stuff.  Gate with
      -- the state so we don't assassinate sync_gap.
      if BDC = '0' and (state = sync_gap or state = sync_wait) then
        BDCsync <= '0';
      else
        BDCsync <= '1';
      end if;

      -- It's cheaper to maintain data to shadow countlo rather than to transfer
      -- countlo to data later on.
      if state = sync_wait then
        data <= data + x"1";
      end if;

      -- In read sync, we're waiting for a BDC 0-to-1 transition & we also
      -- time out.
      if BDCsync = '0' and state = sync_gap then
        state <= sync_wait;
        count <= x"00";
      end if;
      if ((state = sync_gap or state = sync_wait) and count = x"FF")
        or (state = sync_wait and BDCsync = '1') then
        state <= ack;
      end if;

      -- Send data at the end of the read_bits and ack commands.
      if countlo = x"C" and ((counthi = STOP and state = read_bits)
                             or state = ack) then
        state <= idle;
        WRint <= '1';
      else
        WRint <= '0';
      end if;

      -- Convert the nibble we've just read to hex.
      if count = STOP & x"C" and state = read_bits
        and (data(3) and (data(2) or data(1))) = '1' then
        data(0) <= not data(0);
        data(1) <= data(1) xor not data(0);
        data(2) <= data(2) xor (not data(1) and not data(0));
        data(3) <= not data(3);
        -- 3 -> 6:
        counthi(0) <= '0';
        counthi(2) <= not counthi(2);
      end if;

      -- Exit send bits at the right moment...
      if countlo = x"D" and counthi = STOP and state = send_bits then
        state <= idle;
      end if;

      -- Ask for next command if we want data and it's available.
      if countlo = x"E" and state = idle and RXFi = '0' then
        RDiint <= '0';
      else
        RDiint <= '1';
      end if;

      -- Reset data before reading a command.  This simplifies setting of data
      -- while reading a command.
      if state = idle and RDiint = '1' then
        data <= x"0";
      end if;

      -- Process command, or stay in idle if no command.  The 'state=idle'
      -- is formally redundant but helps XST simplify things.
      if state = idle and RDiint = '0' then
        counthi <= x"F";

        if DQ(7 downto 4) = x"3" then -- 0...9 & extras
          data <= data xor DQ(3 downto 0);
        elsif DQ(7 downto 4) = x"6" then -- a...f & extras
          data(0) <= data(0) xor not DQ(0);
          data(1) <= data(1) xor DQ(0) xor DQ(1);
          data(2) <= data(2) xor (DQ(2) or (DQ(1) and DQ(0)));
          data(3) <= not data(3);
        elsif DQ = x"23" then -- '#'
          state <= read_bits;
        elsif DQ = x"21" then -- '!'
          state <= sync_init;
        elsif DQ(7 downto 2) = "010000" then -- @,A,B,C
          clkspeed <= DQ(1 downto 0);
        elsif DQ(7 downto 1) = "0100010" then -- D,E
          LEDval(0) <= DQ(0);
        elsif DQ(7 downto 0) = x"22" then -- '"'
          state <= ack;
          data(2 downto 0) <= data(2 downto 0) xor IO;
        elsif DQ(7 downto 6) = "10" then
          if DQ(3) = '1' then IO(0) <= DQ(0); else IO(0) <= 'Z'; end if;
          if DQ(4) = '1' then IO(1) <= DQ(1); else IO(1) <= 'Z'; end if;
          if DQ(5) = '1' then IO(2) <= DQ(2); else IO(2) <= 'Z'; end if;
        end if;

        if hex_in then
          state <= send_bits;
        end if;

      end if;
    end if;
  end process;

  ACTidle <= ACTcnt = 0;
  LEDval(1) <= '1' when ACTidle else '0';

  -- The 8MHz clock gives a 16MHz edge rate; this is divided by 256 by count
  -- to 64KHz and then by 8192 to give aprox 1/8 second activity pulse.
  process (Clk)
  begin
    if Clk'event then
      if count = x"00" and not ACTidle then
        ACTcnt <= ACTcnt + 1;
      end if;
      if RDiint = '0' and ACTidle then
        ACTcnt(0) <= '1';
      end if;
    end if;
  end process;
end Behavioral;
