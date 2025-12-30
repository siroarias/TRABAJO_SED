library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detector is
 port ( 
   CLK : in std_logic;
   SYNC_IN : in std_logic;
   EDGE_OUT : out std_logic
 );
end edge_detector;

architecture BEHAVIORAL of edge_detector is
 signal sreg : std_logic_vector(2 downto 0);
 signal counter : integer := 0; -- Contador inicializado en 0
begin
 process (CLK)
 begin
   if rising_edge(CLK) then
     if counter = 100000000 then
       sreg <= sreg(1 downto 0) & SYNC_IN; -- Asignación cuando el contador llega a 100
       counter <= 0; -- Reiniciar el contador
     else
       counter <= counter + 1; -- Incrementar el contador en cada flanco de reloj
     end if;
   end if; 
 end process;

 with sreg select
   EDGE_OUT <= '1' when "100",
               '0' when others;
end BEHAVIORAL;
