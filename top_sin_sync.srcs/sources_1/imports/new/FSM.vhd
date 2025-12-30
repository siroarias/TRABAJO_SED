library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM is
    PORT(
        temp_out      : in std_logic;
        sensor_pos    : in std_logic;
        sensor_puertas: in std_logic;
        EMER          : in std_logic;
        piso          : in std_logic_vector(2 downto 0);
        CLK           : in std_logic;
        subir_bajar   : in std_logic_vector(1 downto 0);
        abrir_cerrar  : out std_logic;
        situacion_motor: out std_logic_vector(1 downto 0);
        puertas_in    : out std_logic;
        displays_piso : out std_logic_vector(2 downto 0)
    );
end FSM;

architecture Behavioral of FSM is

    -- Estados de la máquina
    type state_type is (REPOSO, SUBIR, LLEGAR, ABRIR, CERRAR, BAJAR);
    signal current_state, next_state: state_type;

    -- Declarar el contador como señal
    signal abrir_timer: unsigned(26 downto 0) := (others => '0'); -- 27 bits para contar hasta 100,000,000 (2^27 > 100M)

begin

    -- Proceso para calcular el siguiente estado sincronizado con el reloj
    process (CLK)
    begin
        if rising_edge(CLK) then
            if EMER = '1' then
                -- Estado de emergencia: Forzar motor a reposo
                situacion_motor <= "11"; -- Motor apagado
                abrir_cerrar <= '0';
                puertas_in <= '0';
                displays_piso <= piso;
                current_state <= REPOSO;

            else
                case current_state is
                    when REPOSO =>
                        situacion_motor <= "00"; -- Motor en reposo
                        abrir_cerrar <= '0';
                        puertas_in <= '0';
                        displays_piso <= piso;
                        abrir_timer <= (others => '0'); -- Reinicia el temporizador

                        if subir_bajar = "10" then
                            current_state <= SUBIR;
                        elsif subir_bajar = "01" then
                            current_state <= BAJAR;
                        end if;

                    when SUBIR =>
                        situacion_motor <= "10"; -- Motor subiendo
                        abrir_cerrar <= '0';
                        puertas_in <= '0';
                        displays_piso <= piso;
                        if sensor_pos = '1' then
                            current_state <= LLEGAR;
                        end if;

                    when BAJAR =>
                        situacion_motor <= "01"; -- Motor bajando
                        abrir_cerrar <= '0';
                        puertas_in <= '0';
                        displays_piso <= piso;
                        if sensor_pos = '1' then
                            current_state <= LLEGAR;
                        end if;

                    when LLEGAR =>
                        situacion_motor <= "00"; -- Motor detenido
                        abrir_cerrar <= '0';
                        puertas_in <= '0';
                        displays_piso <= piso;
                        if sensor_puertas = '1' then
                            current_state <= ABRIR;
                        end if;

                    when ABRIR =>
                        situacion_motor <= "00";
                        abrir_cerrar <= '1';
                        puertas_in <= '1';
                        displays_piso <= piso;

                        -- Incrementar el temporizador mientras esté en ABRIR
                        if abrir_timer < 100_000_000 - 1 then
                            abrir_timer <= abrir_timer + 1;
                        else
                            current_state <= CERRAR; -- Cambia al estado CERRAR tras 100M ciclos
                        end if;

                        -- También cambia al estado CERRAR si temp_out está activo
                        if temp_out = '1' then
                            current_state <= CERRAR;
                        end if;

                    when CERRAR =>
                        situacion_motor <= "00";
                        abrir_cerrar <= '0';
                        puertas_in <= '0';
                        displays_piso <= piso;
                        abrir_timer <= (others => '0'); -- Reinicia el temporizador
                        if subir_bajar = "10" then
                            current_state <= SUBIR;
                        elsif subir_bajar = "01" then
                            current_state <= BAJAR;
                        elsif subir_bajar = "00" then
                            current_state <= CERRAR;
                        end if;

                    when others =>
                        -- Estado por defecto
                        situacion_motor <= "00";
                        current_state <= CERRAR;
                end case;
            end if;
        end if;
    end process;

    -- Salida para el piso actual
    displays_piso <= piso;

end Behavioral;



