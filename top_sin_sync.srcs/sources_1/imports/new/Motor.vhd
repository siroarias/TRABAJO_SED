library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Motor is
    PORT(
        situacion_motor: in std_logic_vector(1 downto 0);
        CLK: in std_logic;
        act_motor: out std_logic_vector(3 downto 0)
    );
end Motor;

architecture Behavioral of Motor is
begin
    process(CLK)
    begin
       if rising_edge(CLK) then
            case situacion_motor is
                when "00" => act_motor <= "0001";  -- se para
                when "01" => act_motor <= "0010";  -- baja
                when "10" => act_motor <= "0100";  -- sube
                when "11" => act_motor <= "1000";  -- emer
                when others => act_motor <= "0000"; 
            end case;
        end if;
    end process;
end Behavioral;

