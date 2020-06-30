-- Collision Manager
LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity CollisionManager is

port(	clk, copter_on, pipe_on, bomb_on, dead : in std_logic;
		copter_collide : out std_logic
		
	  );
end entity;

architecture beh of CollisionManager is 
signal copter_touchy_pipe : std_logic := '0';
begin 

Collision : process(clk)
				begin

		copter_touchy_pipe <= copter_on and (pipe_on or bomb_on);
		copter_collide <= copter_touchy_pipe or dead;

end process Collision;

end architecture beh;