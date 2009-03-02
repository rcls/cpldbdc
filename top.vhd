library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port (Data : inout  std_logic_vector (7 downto 0);
           RXFinv : in  std_logic;
           RDinv : out  std_logic;
           WR : out  std_logic;
           BDC_pin : inout  std_logic;
           Clk : in std_logic);
end top;

architecture Behavioral of top is
  component bdc is
    Port (Din : in  std_logic_vector (7 downto 0);
          Dout : out  std_logic_vector (7 downto 0);
          RXFinv : in  std_logic;
          RDinv : out  std_logic;
          WR : out  std_logic;
          BDCout : out  std_logic;
          BDCoe : out  std_logic;
          BDCin : in  std_logic;
          Clk : in std_logic);
  end component;
  signal BDCout : std_logic;
  signal BDCoe : std_logic;
  signal BDCin : std_logic;
  signal Din : std_logic_vector (7 downto 0);
  signal Dout : std_logic_vector (7 downto 0);
  signal WRpos : std_logic;

  -- attribute COOL_CLK : string;
  -- attribute COOL_CLK of Clk : signal is "TRUE";

begin
  bdc_impl : bdc port map (Din => Din,
                             Dout => Dout,
                             RXFinv => RXFinv,
                             RDinv => RDinv,
                             WR => WRpos,
                             BDCout => BDCout,
                             BDCin => BDCin,
                             BDCoe => BDCoe,
                             Clk => Clk);
  BDC_pin <= BDCout when BDCoe = '1' else 'Z';
  BDCin <= BDC_pin;
  WR <= WRpos;
  
  Data <= Dout when WRpos = '1' else "ZZZZZZZZ";
  Din <= Data;
  
end Behavioral;

