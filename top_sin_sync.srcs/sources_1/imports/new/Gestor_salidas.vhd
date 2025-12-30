library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Gestor_salidas is
PORT(
    situacion_motor: in std_logic_vector(1 downto 0);
    puertas_in: in std_logic;
    displays_piso: in std_logic_vector( 2 downto 0);
    digsel: in std_logic_vector(7 downto 0);
    act_motor: out std_logic_vector(3 downto 0);
    CLK: in std_logic;
    digctrl: out std_logic_vector (7 downto 0);
    accion: out std_logic_vector(7 downto 0);
    piso_out: out std_logic_vector(6 downto 0)
);
end Gestor_salidas;

architecture Behavioral of Gestor_salidas is
COMPONENT Motor
PORT(
    situacion_motor: in std_logic_vector (1 downto 0);
    CLK: in std_logic;
    act_motor: out std_logic_vector(3 downto 0)
);
END COMPONENT;
COMPONENT Puertas
PORT(
    puertas_in: in std_logic;
    CLK: in std_logic;
   accion: out std_logic_vector(7 downto 0)
    
);
END COMPONENT;
COMPONENT Piso
PORT(
    displays_piso: in std_logic_vector(2 downto 0);
    CLK: in std_logic;
    piso_out: out std_logic_vector(6 downto 0)
);
END COMPONENT;
begin

digctrl<= NOT (digsel); 

Inst_Motor: Motor
PORT MAP(
    situacion_motor => situacion_motor,
    CLK => CLK,
    act_motor => act_motor
);
Inst_Puertas: Puertas
PORT MAP(
    puertas_in=> puertas_in,
    CLK => CLK,
    accion => accion
);
Inst_Piso: Piso
PORT MAP(
    displays_piso => displays_piso,
    CLK => CLK,
    piso_out => piso_out
);
end Behavioral;
