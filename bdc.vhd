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
        RXFinv : in  STD_LOGIC;
        RDinv : out  STD_LOGIC;
        WR : out STD_LOGIC;
        BDC : inout  STD_LOGIC := 'Z';
        Clk : in std_logic);
end bdc;

architecture Behavioral of bdc is
  signal count : std_logic_vector (3 downto 0) := "0000";
  signal data : std_logic_vector (4 downto 0) := "00000";

  type state_t is (send_bits, read_bits, long_break, idle);

  signal state : state_t := idle;

  signal RDinvInt : std_logic := '1';
  signal WRint : std_logic := '0';

  signal BDCprev : std_logic;
  -- 0,1,2,3 - send start pulse.
  -- 4 - drive high for 1.
  -- 10 - sample.
  -- 13 - drive high for zero, write result.
  -- 14 - start read.
  -- 15 - read next command.

begin
  RDinv <= RDinvInt;
  WR <= WRint;

  DQ <= "000" & data when WRint = '1' else "ZZZZZZZZ";

  process (Clk)
    variable finish : boolean;
  begin
    if Clk'event and Clk = '1'
    then
      WRint <= '0';
--      DQ <= "ZZZZZZZZ";
      RDinvInt <= '1';
      BDC <= 'Z';
      BDCprev <= BDC;
      count <= count + x"1";

      case count is
        when x"0" | x"1" | x"2" | x"3" =>
          if state = send_bits or state = read_bits then
            BDC <= '0';
          end if;
        when x"4" | x"5" | x"6" | x"7" | x"8" | x"9" | x"A" | x"B" | x"C" =>
          if state = send_bits then
            BDC <= data(4);
          end if;
        when others =>
          if state = send_bits then
            BDC <= '1';
          end if;
      end case;

      if state = long_break then
        if count = x"F" and data = "10000" then
          BDC <= '1';
        else
          BDC <= '0';
      end if;

      if count = x"A" then
        case state is
          when read_bits  =>  data <= data(3 downto 0) & BDC;
          when send_bits  =>  data <= data(3 downto 0) & '0';
          when long_break =>  data <= data(3 downto 0) & (data(4) xor data(2));
          when others     =>  data <= "XXXXX";
        end case;
      end if;

      if count = x"C" and state = read_bits and data(4) = '1' then
        WRint <= '1';
--        DQ <= x"4" & data(3 downto 0);
      end if;

      finish :=
        (state = send_bits and data = "10000")
        or (state = read_bits and data(4) = '1')
        or (state = long_break and data = "10000")
        or state = idle;

      if count = x"E" and finish and RXFinv = '0' then
        RDinvInt <= '0';
      end if;

      if count = x"F" then
        if RDinvInt /= '0' then
          state <= idle;
          data <= "XXXXX";
        elsif DQ(7 downto 4) = x"4" then
          state <= send_bits;
          data <= DQ(3 downto 0) & '1';
        elsif DQ(7 downto 4) = x"6" then
          state <= read_bits;
          data <= "00001";
        elsif DQ(7 downto 0) = x"21" then
          state <= long_break;
          data <= "10000";
        else
          state <= idle;
          data <= "XXXXX";
        end if;
      end if;
    end if;
  end process;
end Behavioral;
