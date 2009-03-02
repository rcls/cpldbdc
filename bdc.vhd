library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bdc is
  Port (Din : in  STD_LOGIC_VECTOR (7 downto 0);
        Dout : out  STD_LOGIC_VECTOR (7 downto 0);
        RXFinv : in  STD_LOGIC;
        RDinv : out  STD_LOGIC;
        WR : out  STD_LOGIC;
        BDCout : out  STD_LOGIC;
        BDCoe : out  STD_LOGIC;
        BDCin : in  STD_LOGIC;
        Clk : in std_logic);
end bdc;

architecture Behavioral of bdc is
  signal countwide : std_logic_vector (15 downto 0);
  --signal command : std_logic_vector (3 downto 0);
  signal data : std_logic_vector (4 downto 0);
  signal result : std_logic_vector (7 downto 0);

  type state_t is (idle, readcommand, speedA, speedB, speedC,
                   send_nibble, read_byte);

  signal state : state_t := idle;
  constant writeresult : state_t := idle;
  
  alias speed : std_logic_vector (7 downto 0) is countwide (11 downto 4);
  alias speedcount : std_logic_vector (10 downto 0) is countwide (11 downto 1);
  alias cycle : std_logic_vector (3 downto 0) is countwide (15 downto 12);
  alias divide : std_logic_vector (3 downto 0) is countwide (3 downto 0);

  signal cyclerev : std_logic_vector (3 downto 0);
  signal divideinit : std_logic_vector (3 downto 0);
  
begin
  Dout <= result;

  cyclerev <= cycle(0) & cycle(1) & cycle(2) & cycle(3);
  divideinit <= "0000" when cyclerev < speed(3 downto 0) else "0001";
  
  process (Clk)
  begin
    if Clk'event and Clk = '1'
    then
      result <= "XXXXXXXX";
      RDinv <= '1';
      WR <= '0';
      BDCout <= 'X';
      BDCoe <= '0';
      case state is
        when idle =>
          if RXFinv = '0' then
            RDinv <= '0';
            state <= readcommand;
          end if;
        when readcommand =>
          Data <= Din(3 downto 0) & '1';
          case Din(7 downto 4) is
            when "0000" => -- sync
              state <= speedA;
              speedcount <= "00000000000";
              BDCout <= '0';
              BDCoe <= '1';
            when "0001" => -- read speed.
              state <= writeresult;
              result <= speed;
              WR <= '1';
            when "0010" => -- write speed low.
              state <= idle;
              speed(3 downto 0) <= Din(3 downto 0);
            when "0011" => -- write speed high.
              state <= idle;
              speed(3 downto 0) <= Din(7 downto 4);
            when "0100" => -- data nibble.
              cycle <= "0000"; -- FIXME - these will already be set up?
              divide <= divideinit; -- FIXME - should always be short.
              state <= send_nibble;
            when "0101" =>
              if Din(3 downto 0) = "0000" then
                state <= read_byte;
              end if;
            when others =>
              state <= idle;
          end case;
        when speedA =>
          -- Drive low for at least 128 cycles of slowest possible clock.  We
          -- actually allow
          -- make that 128 * 16.
          speedcount <= speedcount + 1;
          if speedcount = "11111111111" then
            state <= speedB;
            BDCout <= '1';
            BDCoe <= '1';
          else
            BDCout <= '0';
            BDCoe <= '1';
          end if;
        when speedB =>
          -- Wait for low.
          speedcount <= speedcount + "00000000001";
          if speedcount = "11111111111" or BDCin = '0' then
            -- Time it.
            speedcount <= "00010000100";
            state <= speedC;
          end if;
        when speedC =>
          speedcount <= speedcount + "00000000001";
          if speedcount = "11111111111" or BDCin = '1' then
            -- timeout or got it.
            result <= speed; --fixme, really want the +1...
            WR <= '1';
            state <= writeresult;
          end if;
        when send_nibble =>
          -- FIXME - do short drives.
          BDCoe <= '1';
          case cycle(3 downto 2) is
            when "00" =>
              BDCout <= '0';
            when "01"|"10" =>
              BDCout <= data(4);
            when "11" =>
              BDCout <= '1';
            when others => -- wtf?
          end case;
          divide <= divide + 1;
          if divide = speed (7 downto 4) then
            divide <= divideinit;
            cycle <= cycle + 1;
            if cycle = "1111" then
              data <= data(3 downto 0) & '0';
              if data(3 downto 0) = "1000" then
                state <= idle;
              end if;
            end if;
          end if;
        when read_byte =>
          if cycle(3 downto 2) = "00" then
            BDCoe <= '1';
            BDCout <= '0';
          end if;
          divide <= divide + 1;
          if divide = speed (7 downto 4) then
            divide <= divideinit;
            cycle <= cycle + 1;
            if cycle = "1001" then
              result <= result(6 downto 0) & BDCin;
            end if;
            if cycle = "1111" then
              data <= data(3 downto 0) & not data(4);
              if data(3) = '1' and data(2) = '0' then
                state <= writeresult;
                WR <= '1';
              end if;
            end if;
          end if;
      end case;
    end if;
  end process;
end Behavioral;
