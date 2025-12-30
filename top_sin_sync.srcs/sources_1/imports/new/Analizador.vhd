library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Analizador is
PORT(
    ED_1: in std_logic;
    ED_2: in std_logic;
    ED_3: in std_logic;
    ED_4: in std_logic;
    ED_5: in std_logic;
    CLK: in std_logic;
    subir_bajar: out std_logic_vector(1 downto 0);
    piso: out std_logic_vector(2 downto 0)
    );
end Analizador;

architecture Behavioral of Analizador is
    signal P: std_logic_vector(2 downto 0) := "000";
    signal piso_1: std_logic_vector(2 downto 0);
    signal piso_2: std_logic_vector(2 downto 0);
    signal piso_3: std_logic_vector(2 downto 0);
    signal piso_4: std_logic_vector(2 downto 0);
    signal piso_5: std_logic_vector(2 downto 0);
    signal vector_almacenar: std_logic_vector(14 downto 0);
begin

    process (CLK, ED_1, ED_2, ED_3, ED_4, ED_5)
        variable max_dist: integer := 6; --distancia maxima
        variable distancia: integer; --para analizar los `pisos del vector
        variable piso_cercano: std_logic_vector(2 downto 0) := "000";
        variable temp_vector: std_logic_vector(14 downto 0) := (others => '0'); --donde almacenamos los pisos (vector temporal)
        variable contador_piso: integer := 0;
    begin
        if rising_edge(CLK) then
            -- Inicialización
            contador_piso := 0;
            temp_vector := (others => '0');

            -- Determinar valores para cada piso
            if ED_1 = '1' then
                piso_1 <= "001";
                temp_vector(2 downto 0) := "001";
                contador_piso := contador_piso + 1;
            else
                piso_1 <= "000";
            end if;

            if ED_2 = '1' then
                piso_2 <= "010";
                temp_vector(5 downto 3) := "010";
                contador_piso := contador_piso + 1;
            else
                piso_2 <= "000";
            end if;

            if ED_3 = '1' then
                piso_3 <= "011";
                temp_vector(8 downto 6) := "011";
                contador_piso := contador_piso + 1;
            else
                piso_3 <= "000";
            end if;

            if ED_4 = '1' then
                piso_4 <= "100";
                temp_vector(11 downto 9) := "100";
                contador_piso := contador_piso + 1;
            else
                piso_4 <= "000";
            end if;

            if ED_5 = '1' then
                piso_5 <= "101";
                temp_vector(14 downto 12) := "101";
                contador_piso := contador_piso + 1;
            else
                piso_5 <= "000";
            end if;

            -- Buscar el piso más cercano
            max_dist := 7;
            piso_cercano := "000";

            if contador_piso > 0 then --significa que hay minimo un piso llamado
                for i in 0 to 4 loop -- Número máximo de pisos es 5
                    if temp_vector(i*3+2 downto i*3) /= "000" then --aqui recorremos cada posicion del vector
                        distancia := abs(to_integer(unsigned(temp_vector(i*3+2 downto i*3))) - to_integer(unsigned(P))); --
                        if distancia < max_dist then
                            max_dist := distancia;
                            piso_cercano := temp_vector(i*3+2 downto i*3);
                        end if;
                    end if;
                end loop;

                
                P <= piso_cercano; -- Actualizamos el piso

                --Una vez q se manda al ascensor a un piso, este sale de la lista de pisos pendientes
                for i in 0 to 4 loop
                    if temp_vector(i*3+2 downto i*3) = piso_cercano then
                        temp_vector(i*3+2 downto i*3) := "000";
                    end if;
                end loop;

                vector_almacenar <= temp_vector;
            end if;

            
            piso <= piso_cercano;-- Asignamos valor

            if piso_cercano = "000" then --no me llaman
                subir_bajar <= "00"; -- Sin movimiento
            elsif to_integer(unsigned(piso_cercano)) < to_integer(unsigned(P)) then
                subir_bajar <= "01"; -- Baja
            elsif to_integer(unsigned(piso_cercano)) > to_integer(unsigned(P)) then
                subir_bajar <= "10"; -- Sube
            else
                subir_bajar <= "00"; -- Reposo
            end if;
        end if;
    end process;

end Behavioral;


