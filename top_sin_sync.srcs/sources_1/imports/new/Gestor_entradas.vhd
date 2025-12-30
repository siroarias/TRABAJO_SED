

--EL COMPONENTE VA ENCIMA DEL BEGIN Y LA INSTANCIACIÓN DEBAJO!!
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Gestor_entradas is
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
end Gestor_entradas;

architecture Behavioral of Gestor_entradas is
signal sync_1 : std_logic;
signal sync_2 : std_logic;
signal sync_3 : std_logic;
signal sync_4 : std_logic;
signal sync_5 : std_logic;
COMPONENT sync
PORT(
    CLK : in std_logic;
    ASYNC_IN : in std_logic;
    SYNC_OUT : out std_logic
);
END COMPONENT;
COMPONENT edge_detector
PORT(
    CLK : in std_logic;
    SYNC_IN : in std_logic;
    EDGE_OUT : out std_logic
);
END COMPONENT;

begin

Inst_sync1: sync 
PORT MAP(
    ASYNC_IN => B1,
    SYNC_OUT => sync_1,
    CLK => CLK
);
Inst_sync2: sync 
PORT MAP(
    ASYNC_IN => B2,
    SYNC_OUT => sync_2,
    CLK => CLK
);
Inst_sync3: sync 
PORT MAP(
    ASYNC_IN => B3,
    SYNC_OUT => sync_3,
    CLK => CLK
);
Inst_sync4: sync 
PORT MAP(
    ASYNC_IN => B4,
    SYNC_OUT => sync_4,
    CLK => CLK
);
Inst_sync5: sync 
PORT MAP(
    ASYNC_IN => B5,
    SYNC_OUT => sync_5,
    CLK => CLK
);
Inst_edge1: edge_detector
PORT MAP(
    SYNC_IN=> sync_1,
    EDGE_OUT => ED_1,
    CLK => CLK
);
Inst_edge2: edge_detector
PORT MAP(
    SYNC_IN=> sync_2,
    EDGE_OUT => ED_2,
    CLK => CLK
);
Inst_edge3: edge_detector
PORT MAP(
    SYNC_IN=> sync_3,
    EDGE_OUT => ED_3,
    CLK => CLK
);
Inst_edge4: edge_detector
PORT MAP(
    SYNC_IN=> sync_4,
    EDGE_OUT => ED_4,
    CLK => CLK
);
Inst_edge5: edge_detector
PORT MAP(
    SYNC_IN=> sync_5,
    EDGE_OUT => ED_5,
    CLK => CLK
);
end Behavioral;
