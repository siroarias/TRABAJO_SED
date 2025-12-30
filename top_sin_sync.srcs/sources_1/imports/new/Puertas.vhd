library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Puertas is
    PORT(
        puertas_in: in std_logic;  
        CLK: in std_logic;       
        accion: out std_logic_vector(7 downto 0)   
    );
end Puertas;

architecture Behavioral of Puertas is
    signal counter : integer := 0;  -- Contador de 32 bits para manejar hasta 400,000,000.
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if puertas_in = '1' then
                counter <= counter + 1;
                if counter < 10000000 then
                    accion <= "00011000";  -- Valor 1
                elsif counter < 15000000 then
                    accion <= "00100100";  -- Valor 2
                elsif counter < 20000000 then
                    accion <= "01000010";  -- Valor 3
                elsif counter < 25000000 then
                    accion <= "10000001";  -- Valor 4
                else
                    counter <= 0;          -- Reiniciar contador después de 4 ciclos completos
                    accion <= "00000000";  -- Reseteo de accion a valor por defecto
                end if;
            else
                accion <= "00000000"; -- Si puertas_in = '0', restablecer a "00000000"
            end if;
        end if;
    end process;
end Behavioral;

