library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bdc is
  Port (DQ : inout STD_LOGIC_VECTOR (7 downto 0);
        RXFi : in  STD_LOGIC;
        RDi : out  STD_LOGIC;
        WR : out STD_LOGIC;
        BDC : inout  STD_LOGIC := 'Z';
        IO : inout std_logic_vector(2 downto 0) := "ZZZ";
        Clk : in std_logic);
end bdc;

architecture Behavioral of bdc is
  signal count : std_logic_vector (3 downto 0) := x"0";
  signal counthi : std_logic_vector (4 downto 0);
  signal data : std_logic_vector (3 downto 0);

  type state_t is (ack, idle, send_bits, read_bits, sync_init, sync_low,
                   read_command, write_result);

  signal state : state_t := idle;

  signal clkspeed : std_logic_vector(1 downto 0) := "10";

  signal clkdiv : std_logic_vector(1 downto 0);
  signal Clk_main : std_logic;

  constant STOP : std_logic_vector(4 downto 0) := "10011";
  -- 0,1,2,3 - send start pulse.
  -- 4 - drive high for 1.
  -- 10 - sample.
  -- 12 - write result (could do 10,11!).
  -- 13 - drive high for zero.
  -- 14 - start read (could do 13,14!).
  -- 15 - read next command.

begin

  RDi <= '0' when state = read_command else '1';

  WR <= '1' when state = write_result else '0';
  DQ <= counthi(3 downto 0) & data when state = write_result else "ZZZZZZZZ";

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
  begin
    if Clk_main'event then
      BDC <= 'Z';
      count <= count + x"1";

      do_bits := state = send_bits or state = read_bits;

      -- During a data cycle, do the BDC data.
      case count is
        when x"0" | x"1" | x"2" | x"3" =>
          if do_bits then
            BDC <= '0';
          end if;
        when x"4" | x"5" | x"6" | x"7" | x"8" | x"9" | x"A" | x"B" | x"C" =>
          if state = send_bits then
            BDC <= data(3);
          end if;
        when others =>
          if state = send_bits then
            BDC <= '1';
          end if;
      end case;

      -- Maintain the bit number.  Doing this on count=0 means counthi is
      -- correct if we finish a sync on the same clock as counthi increments.
      if count = x"0" and state /= ack and state /= idle then
        counthi <= counthi + '1';
      end if;

      -- Send sync, with a one-clock speedup.
      if state = sync_init and counthi(4) = '0' then
        if counthi(3 downto 0) = "1111" and count = x"F" then
          BDC <= '1';
        else
          BDC <= '0';
        end if;
      end if;

      -- In read sync, we're waiting for a BDC 0-to-1 transition.
      if state = sync_init and counthi(4) = '1' and BDC = '0' then
        state <= sync_low;
      end if;
      if (state = sync_low and BDC = '1')
        or ((state = sync_low or state = sync_init)
            and counthi = "11111" and count = "1111") then
        data <= count;
        state <= ack;
--        state <= sync_init;
      end if;

      -- BDC sampling cycle.
      if count = x"A" and do_bits then
        data <= data(2 downto 0) & BDC;
      end if;

      -- Send data at the end of the do_bits and ack commands.
      if count = x"C" and ((counthi = STOP and do_bits) or state = ack) then
        state <= write_result;
      end if;

      -- Ask for next command if we want data and its available.
      if count = x"E" and state = idle and RXFi = '0' then
        state <= read_command;
      end if;

      -- Process command, or stay in idle if no command.
      if state = write_result then
        state <= idle;
        data <= "XXXX";
        counthi <= "XXXXX";
      end if;
      if state = read_command then
        state <= idle;
        data <= "XXXX";
        counthi <= "XXXXX";
        if DQ(7 downto 4) = x"4" then
          state <= send_bits;
          data <= DQ(3 downto 0);
          counthi <= STOP - 4;
        elsif DQ(7 downto 4) = x"5" then
          state <= read_bits;
          counthi <= STOP - 4;
        elsif DQ(7 downto 0) = x"21" then -- '!'
          state <= sync_init;
          data <= "1111";
          counthi <= "11111";
        elsif DQ(7 downto 2) = "001100" then
          clkspeed <= DQ(1 downto 0);
        elsif DQ(7 downto 0) = x"3C" then -- '<'
          state <= ack;
          data <= '0' & IO;
        elsif DQ(7 downto 6) = "01" then
          if DQ(3) = '1' then IO(0) <= DQ(0); else IO(0) <= 'Z'; end if;
          if DQ(4) = '1' then IO(1) <= DQ(1); else IO(1) <= 'Z'; end if;
          if DQ(5) = '1' then IO(2) <= DQ(2); else IO(2) <= 'Z'; end if;
        end if;
      end if;
    end if;
  end process;
end Behavioral;
