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
        Clk : in std_logic);
end bdc;

architecture Behavioral of bdc is
  signal count : std_logic_vector (3 downto 0) := x"0";
  signal counthi : std_logic_vector (7 downto 0) := x"00";
  signal data : std_logic_vector (3 downto 0) := x"0";

  type state_t is (send_bits, read_bits, long_break,
                   read_break, acknowledge, idle);

  signal state : state_t := idle;

  signal RDiInt : std_logic := '1';
  signal WRint : std_logic := '0';

  -- 0,1,2,3 - send start pulse.
  -- 4 - drive high for 1.
  -- 10 - sample.
  -- 13 - drive high for zero, write result.
  -- 14 - start read.
  -- 15 - read next command.

begin
  RDi <= RDiInt;
  WR <= WRint;

  DQ <= "0011" & data when WRint = '1' else "ZZZZZZZZ";

  process (Clk)
    variable finish : boolean;
    variable do_bits : boolean;
  begin
    if Clk'event and Clk = '1'
    then
      WRint <= '0';
--      DQ <= "ZZZZZZZZ";
      RDiInt <= '1';
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
      -- correct if we stop a break on the same cycle as counthi increments.
      if do_bits or state = long_break or state = read_break then
        if count = x"0" then
          counthi <= counthi + x"01";
        end if;
      end if;

      -- During a break, maintain the 6 bit counter, BDC data, and switch
      -- to waiting for break reply.
      if state = long_break then
        if count = x"F" and counthi(5 downto 0) = "011111" then
          BDC <= '1';
        elsif counthi(5) = '0' then
          BDC <= '0';
        else
          BDC <= 'Z';
        end if;

        if counthi(5) = '1' and BDC = '0' then
          count <= x"0";
          counthi <= x"FF";
          state <= read_break;
        end if;
      end if;

      -- In read break, we're waiting for a BDC=1; also breaks time out.
      if (state = read_break and BDC = '1')
        or ((state = long_break or state = read_break)
            and count = x"F" and counthi(5 downto 0) = "111111") then
        data <= count;
        state <= acknowledge;
      end if;

      -- BDC sampling cycle.
      if count = x"A" and do_bits then
        data <= data(2 downto 0) & BDC;
      end if;

      -- Check if we are finishing this command & can read another.
      finish :=
        (do_bits and counthi(2 downto 0) = "11")
        or state = acknowledge
        or state = idle;

      -- Send data in at the end of each command.
      if count = x"C" and finish and state /= idle then
        WRint <= '1';
--        DQ <= x"4" & data(3 downto 0);
      end if;

      -- Ask for next command if we want data and its available.
      if count = x"E" and finish and RXFi = '0' then
        RDiInt <= '0';
      end if;

      -- Process command, or go to idle if no command.
      if count = x"F" and finish then
        if RDiInt /= '0' then
          state <= idle;
          data <= data;
        elsif DQ(7 downto 4) = x"4" then
          state <= send_bits;
          counthi <= x"FF";
          data <= DQ(3 downto 0);
        elsif DQ(7 downto 4) = x"6" then
          state <= read_bits;
          counthi <= x"FF";
          data <= "XXXX";
        elsif DQ(7 downto 0) = x"21" then
          state <= long_break;
          counthi <= x"FF";
        elsif DQ(7 downto 0) = x"30" then
          state <= acknowledge;
          data <= counthi(3 downto 0);
        elsif DQ(7 downto 0) = x"21" then
          state <= long_break;
          data <= counthi(7 downto 4);
        else
          state <= idle;
          data <= "XXXX";
        end if;
      end if;
    end if;
  end process;
end Behavioral;
