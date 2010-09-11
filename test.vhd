LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

entity test is
end test;

architecture behavior of test is

  -- Component Declaration for the Unit Under Test (UUT)
  component bdc port(DQ   : inout std_logic_vector(7 downto 0);
                     RXFi : in    std_logic;
                     RDi  : out   std_logic;
                     WR   : out   std_logic;
                     BDC  : inout std_logic;
                     IO   : inout std_logic_vector(2 downto 0);
                     Clk  : in    std_logic);
  end component;

  subtype byte_t is std_logic_vector(7 downto 0);
  type command_t is array(1 to 10) of byte_t;

  constant commands : command_t := (
    x"45", x"43", x"31", x"32", x"34", x"38", x"6a", x"23", x"23", x"21");

  subtype nibble_t is std_logic_vector(3 downto 0);
  type data_t is array(1 to 10) of nibble_t;

  constant data : data_t := (
    x"0",  x"0",  x"0",  x"0",  x"0",  x"0",  x"0",  x"8",  x"A",  x"0");

  --Inputs
  signal RXFi : std_logic := '1';
  signal Clk : std_logic := '0';

  --BiDirs
  signal DQ : std_logic_vector(7 downto 0);
  signal Z  : std_logic := 'H';
  signal IO : std_logic_vector(2 downto 0);

  --Outputs
  signal RDi : std_logic;
  signal WR : std_logic;

  signal get_nibble : boolean := false;
  signal nibble: nibble_t;

  signal jj : integer;

begin

  uut: bdc port map (DQ   => DQ,
                     RXFi => RXFi,
                     RDi  => RDi,
                     WR   => WR,
                     BDC  => Z,
                     IO   => IO,
                     Clk  => Clk);

  -- Clock process definitions
  process
  begin
    Clk <= '0';
    wait for 67.5ns;
    Clk <= '1';
    wait for 67.5ns;
  end process;

  -- Stimulus process
  stim_proc: process
  begin
    wait for 101ns;
    for i in 1 to 10 loop
      RXFi <= '0';
      wait until RDi = '0';
      wait for 10ns;
      DQ <= commands(i);
      wait until RDi = '1';
      if commands(i) = x"23" then
        nibble <= data(i);
        get_nibble <= true;
      end if;
      wait for 10ns;
      get_nibble <= false;
      RXFi <= '1';
      DQ <= "ZZZZZZZZ";
      wait for 50ns;
    end loop;
    wait;
  end process;

  -- Respond with data.
  respond: process
  begin
    while true loop
      wait until get_nibble;
      for j in 3 downto 0 loop
        jj <= j;
        wait until Z = '0';
        wait for 4 * 67.5 ns;
        Z <= 'L';
        if nibble(j) = '1' then
--          Z <= 'L';
          wait for 3 * 67.5 ns;
          Z <= '1';
          wait for 67.5 ns;
          Z <= 'H';
        else
--          Z <= 'L';
          wait for 9 * 67.5 ns;
          Z <= '1';
          wait for 67.5 ns;
          Z <= 'H';
        end if;
      end loop;
      jj <= 4;
--      wait until not get_nibble;
    end loop;
  end process;

end;
