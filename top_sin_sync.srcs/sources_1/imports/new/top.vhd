library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
PORT(
    B1: in std_logic;
    B2: in std_logic;
    B3: in std_logic;
    B4: in std_logic;
    B5: in std_logic;
    CLK: in std_logic;
    EMER: in std_logic;
    sensor_pos: in std_logic;
    sensor_puertas: in std_logic;
    act_motor: out std_logic_vector (3 downto 0);
    accion: out std_logic_vector(7 downto 0);
    digsel: in std_logic_vector(7 downto 0);
    digctrl: out std_logic_vector (7 downto 0);
    piso_out: out std_logic_vector(6 downto 0)
    );
end top;

architecture Behavioral of top is
signal ED_1 : std_logic;
signal ED_2 : std_logic;
signal ED_3 : std_logic;
signal ED_4 : std_logic;
signal ED_5 : std_logic;
signal situacion_motor: std_logic_vector(1 downto 0);
signal displays_piso: std_logic_vector(2 downto 0);
signal puertas_in: std_logic;

COMPONENT Gestor_entradas
PORT(
    B1: in std_logic;
    B2: in std_logic;
    B3: in std_logic;
    B4: in std_logic;
    B5: in std_logic;
    CLK: in std_logic;
    ED_1: out std_logic;
    ED_2: out std_logic;
    ED_3: out std_logic;
    ED_4: out std_logic;
    ED_5: out std_logic
);
END COMPONENT;
COMPONENT Gestor_ascensor
PORT(
    CLK: in std_logic;
    EMER:in std_logic;
    ED_1: in std_logic;
    ED_2: in std_logic;
    ED_3: in std_logic;
    ED_4: in std_logic;
    ED_5: in std_logic;
    sensor_pos: in std_logic;
    sensor_puertas: in std_logic;
    situacion_motor: out std_logic_vector (1 downto 0);
    puertas_in: out std_logic;
    displays_piso: out std_logic_vector(2 downto 0)
);
END COMPONENT;
COMPONENT Gestor_salidas
PORT(
    situacion_motor: in std_logic_vector(1 downto 0);
    puertas_in: in std_logic;
    displays_piso: in std_logic_vector( 2 downto 0);
    digsel: in std_logic_vector(7 downto 0);
    act_motor: out std_logic_vector (3 downto 0);
    CLK: in std_logic;
    digctrl: out std_logic_vector (7 downto 0);
    accion: out std_logic_vector(7 downto 0);
    piso_out: out std_logic_vector(6 downto 0)
);
END COMPONENT;
begin

Inst_Gestor_entradas: Gestor_entradas 
PORT MAP(
    B1 => B1,
    B2 => B2,
    B3 => B3,
    B4 => B4,
    B5 => B5,
    ED_1 => ED_1,
    ED_2 => ED_2,
    ED_3 => ED_3,
    ED_4 => ED_4,
    ED_5 => ED_5,
    CLK => CLK
);
Inst_Gestor_ascensor: Gestor_ascensor
PORT MAP(
    ED_1 => ED_1,
    ED_2 => ED_2,
    ED_3 => ED_3,
    ED_4 => ED_4,
    ED_5 => ED_5,
    CLK => CLK,
    EMER => EMER,
    sensor_pos => sensor_pos,
    sensor_puertas => sensor_puertas,
    situacion_motor => situacion_motor,
    puertas_in => puertas_in,
    displays_piso => displays_piso
    
);
Inst_Gestor_salidas: Gestor_salidas 
PORT MAP(
    situacion_motor => situacion_motor,
    displays_piso => displays_piso,
    puertas_in => puertas_in,
    act_motor => act_motor,
    piso_out => piso_out,
    accion => accion,
    CLK => CLK,
    digsel => digsel,
    digctrl => digctrl 
);


end Behavioral;
