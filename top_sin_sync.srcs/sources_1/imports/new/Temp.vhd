library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Temporizador is
    PORT(
        abrir_cerrar: in std_logic;
        CLK: in std_logic;
        temp_out: out std_logic
    );
end Temporizador;

architecture Behavioral of Temporizador is

    signal contador: unsigned(27 downto 0) := (others => '0'); -- Contador de 28 bits
    signal temp_signal: std_logic := '0'; -- Señal interna para temp_out

begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            if abrir_cerrar = '1' then
                if contador < 300000000 then
                    contador <= contador + 1; -- Incrementa el contador
                    temp_signal <= '0'; -- Salida inactiva durante el conteo
                else
                    temp_signal <= '1'; -- Activar salida después de alcanzar el límite
                end if;
            else
                contador <= (others => '0'); -- Reinicia el contador cuando abrir_cerrar es '0'
                temp_signal <= '0'; -- Reinicia la salida
            end if;
        end if;
    end process;

    temp_out <= temp_signal; -- Asignación de la señal interna a la salida

end Behavioral;
