library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top is
end tb_top;

architecture tb of tb_top is
    -- Componente bajo prueba
    component top
        port (
            B1             : in std_logic;
            B2             : in std_logic;
            B3             : in std_logic;
            B4             : in std_logic;
            B5             : in std_logic;
            CLK            : in std_logic;
            EMER           : in std_logic;
            sensor_pos     : in std_logic;
            sensor_puertas : in std_logic;
            act_motor      : out std_logic_vector (3 downto 0);
            accion: out std_logic_vector(7 downto 0);
            digsel         : in std_logic_vector (7 downto 0);
            digctrl        : out std_logic_vector (7 downto 0);
            piso_out       : out std_logic_vector (6 downto 0)
        );
    end component;

    -- Señales
    signal B1             : std_logic := '0';
    signal B2             : std_logic := '0';
    signal B3             : std_logic := '0';
    signal B4             : std_logic := '0';
    signal B5             : std_logic := '0';
    signal CLK            : std_logic := '0';
    signal EMER           : std_logic := '0';
    signal sensor_pos     : std_logic := '0';
    signal sensor_puertas : std_logic := '0';
    signal act_motor      : std_logic_vector (3 downto 0);
    signal accion:  std_logic_vector(7 downto 0);
    signal digsel         : std_logic_vector (7 downto 0) := (others => '0');
    signal digctrl        : std_logic_vector (7 downto 0);
    signal piso_out      : std_logic_vector (6 downto 0) := "0000000";
    signal TbSimEnded     : std_logic := '0';

    -- Periodo del reloj
    constant TbPeriod : time := 1000000 us;  

begin
    -- Instancia del diseño bajo prueba
    dut : top
    port map (
        B1             => B1,
        B2             => B2,
        B3             => B3,
        B4             => B4,
        B5             => B5,
        CLK            => CLK,
        EMER           => EMER,
        sensor_pos     => sensor_pos,
        sensor_puertas => sensor_puertas,
        act_motor      => act_motor,
        accion         => accion,
        digsel         => digsel,
        digctrl        => digctrl,
        piso_out       => piso_out
    );

    -- Generación de reloj simétrico
    process
    begin
        while TbSimEnded /= '1' loop
            CLK <= '1';
            wait for 3 * TbPeriod;
            CLK <= '0';
            wait for 3 * TbPeriod;
        end loop;
        wait;
    end process;

    -- Proceso de estímulos
    stimuli : process
    begin
        -- Esperar la inicialización
        wait for 10 * TbPeriod;

        -- Test 1: Pulsar botón B1 y combinación de sensores
        B1 <= '1'; sensor_pos <= '1'; sensor_puertas <= '1'; wait for 100 * TbPeriod; B1 <= '0';

        -- Test 2: Pulsar B2 y activar otro piso
        B2 <= '1'; sensor_pos <= '1'; wait for 200 * TbPeriod; sensor_pos <= '1'; B2 <= '0';

        -- Test 3: Pulsar B3 y activar emergencia
        B3 <= '1'; EMER <= '1'; wait for 200 * TbPeriod; B3 <= '0'; EMER <= '0';

        -- Finalización de la simulación
        TbSimEnded <= '1';
        wait;
    end process;

end tb;