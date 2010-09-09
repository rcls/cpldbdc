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
        BDC  : inout std_logic := 'Z';
        IO   : inout std_logic_vector(2 downto 0) := "ZZZ";
        LED  : out   std_logic_vector(1 downto 0);
        Clk  : in    std_logic);
end bdc;

architecture Behavioral of bdc is
  signal count   : std_logic_vector (3 downto 0) := x"0";
  signal counthi : std_logic_vector (3 downto 0) := x"0";
  signal data    : std_logic_vector (3 downto 0) := x"0";

  type state_t is (ack, idle, send_bits, read_bits,
                   sync_init, sync_gap, sync_wait);

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

  signal hex_alpha : boolean;
  signal hex_in : boolean;

  attribute keep : string;
  attribute keep of hex_alpha : signal is "TRUE";

begin

  RDi <= RDiint;

  WR <= WRint;
  DQ <= counthi & data when WRint = '1' else "ZZZZZZZZ";

  BDC <= BDCdata when BDCout else 'Z';

  LED <= LEDval;

  hex_alpha <= counthi = STOP
               and (data(3) and (data(2) or data(1))) = '1';
  hex_in <= DQ(7 downto 4) = x"6" or DQ(7 downto 4) = x"3";

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
    variable sync_done : boolean;
    variable index : integer;
  begin
    if Clk_main'event then
      count <= count + x"1";

      do_bits := state = send_bits or state = read_bits;
      index := conv_integer(STOP(1 downto 0) - counthi(1 downto 0));

      -- During a data cycle, do the BDC data.  During sync, drive low
      -- with one cycle speed up.
      if count = x"0" then
        BDCdata <= '0';
      elsif count = x"4" and state = send_bits and data(index) = '1' then
        BDCdata <= '1';
      elsif count = x"D" and state = send_bits then
        BDCdata <= '1';
      end if;

      -- BDC out enable.
      if count = x"0" then
        BDCout <= do_bits or state = sync_init or LEDval(0) = '0';
      end if;
      if count = x"4" and state = read_bits then
        BDCout <= false;
      end if;

      -- BDC sampling cycle.
      if count = x"A" and state = read_bits then
        data(index) <= data(index) xor BDC;
      end if;

      -- Maintain the bit number.  Doing this on count=0 means counthi is
      -- correct if we finish a sync on the same clock as counthi increments.
      if count = x"0" and state /= ack and state /= idle then
        counthi <= counthi + '1';
      end if;

      -- At the end of sync_init, transfer to sync_gap, do the BDC speed-up.
      if state = sync_init and counthi = x"F" and count = x"F" then
        state <= sync_gap;
        BDCdata <= '1';
      end if;

      -- In read sync, we're waiting for a BDC 0-to-1 transition & we also
      -- time out.
      sync_done := ((state = sync_gap or state = sync_wait)
                    and counthi = x"F" and count = x"F")
                   or (state = sync_wait and BDC = '1');

      if sync_done then
        data <= data xor count;
        state <= ack;
      end if;
      if BDC = '0' and state = sync_gap then
        state <= sync_wait;
        counthi <= x"f";
        count <= x"0";
      end if;

      -- Send data at the end of the read_bits and ack commands.
      if count = x"C" and ((counthi = STOP and state = read_bits)
                           or state = ack) then
        state <= idle;
        WRint <= '1';
      else
        WRint <= '0';
      end if;

      if count = x"C" and state = read_bits and hex_alpha then
        data(0) <= not data(0);
        data(1) <= data(1) xor not data(0);
        data(2) <= data(2) xor (not data(1) and not data(0));
        data(3) <= not data(3);
        -- 3 -> 6:
        counthi(0) <= '0';
        counthi(2) <= '1';
      end if;

      -- Exit send bits at the right moment...
      if count = x"D" and counthi = STOP and state = send_bits then
        state <= idle;
      end if;

      -- Ask for next command if we want data and it's available.
      if count = x"E" and state = idle and RXFi = '0' then
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
        counthi <= "1111";

        if DQ(7 downto 4) = x"3" then -- 0...9 & extras
          data <= data xor DQ(3 downto 0);
        elsif DQ(7 downto 4) = x"6" then -- a...f & extras
          data(0) <= data(0) xor not DQ(0);
          data(1) <= data(1) xor DQ(0) xor DQ(1);
          data(2) <= data(2) xor (DQ(2) or (DQ(1) and DQ(0)));
          data(3) <= '1';
        elsif DQ = x"23" then -- '#'
          state <= read_bits;
        elsif DQ = x"21" then -- '!'
          state <= sync_init;
        elsif DQ(7 downto 2) = "010000" then -- @,A,B,C
          clkspeed <= DQ(1 downto 0);
        elsif DQ(7 downto 2) = "010001" then -- D,E,F,G
          LEDval <= DQ(1 downto 0);
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
end Behavioral;
