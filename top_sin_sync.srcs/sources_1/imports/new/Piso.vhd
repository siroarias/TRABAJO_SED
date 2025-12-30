library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity Piso is
    PORT(
        displays_piso: in std_logic_vector(2 downto 0);
        CLK: in std_logic;
        piso_out: out std_logic_vector(6 downto 0)
    );
end Piso;
 
architecture Behavioral of Piso is
    -- Señal para almacenar el último piso
    signal ultimo_piso : integer range 1 to 5 := 1; -- Representa el último piso mostrado (en número)
    signal nuevo_piso : integer range 1 to 5 := 1; -- Representa el nuevo piso deseado
    signal contador : integer := 0; -- Contador para dividir la frecuencia del reloj
    signal mostrar_piso : std_logic_vector(6 downto 0) := "1111110"; -- Salida actual del display
    constant CLK_DIVISOR : integer := 100000000; -- Divisor para un reloj de 100 MHz, generando 1 Hz
 
    -- Tabla de conversión de pisos (en número) a segmentos del display
    function piso_to_display(piso : integer) return std_logic_vector is
    begin
        case piso is
            when 1 => return "1001111"; -- Piso 1
            when 2 => return "0010010"; -- Piso 2
            when 3 => return "0000110"; -- Piso 3
            when 4 => return "1001100"; -- Piso 4
            when 5 => return "0100100"; -- Piso 5
            when others => return "1111110"; -- Valor por defecto
        end case;
    end function;
 
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            -- Divisor de frecuencia
            if contador < CLK_DIVISOR - 1 then
                contador <= contador + 1;
            else
                contador <= 0;
 
                -- Determinar el nuevo piso basado en la entrada
                case displays_piso is
                    when "001" => nuevo_piso <= 1;
                    when "010" => nuevo_piso <= 2;
                    when "011" => nuevo_piso <= 3;
                    when "100" => nuevo_piso <= 4;
                    when "101" => nuevo_piso <= 5;
                    when others => null; -- No actualizar si la entrada no es válida
                end case;
 
                -- Control de transición entre pisos
                if ultimo_piso /= nuevo_piso then
                    if ultimo_piso < nuevo_piso then
                        mostrar_piso <= piso_to_display(ultimo_piso + 1);
                        ultimo_piso <= ultimo_piso + 1;
                    elsif ultimo_piso > nuevo_piso then
                        mostrar_piso <= piso_to_display(ultimo_piso - 1);
                        ultimo_piso <= ultimo_piso - 1;
                    end if;
                end if;
 
                -- Actualizar la salida del display
                piso_out <= mostrar_piso;
            end if;
        end if;
    end process;
end Behavioral;
