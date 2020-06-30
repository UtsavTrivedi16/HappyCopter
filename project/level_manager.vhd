LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity level_manager is
	port(
		clk, game_start, game_init, mode : in std_logic;
		level  : out std_logic_vector(2 downto 0);
		time_score : out std_logic
	);
end entity;

architecture level of level_manager is
signal s_mode : std_logic; --1 for practice mode, 0 for real mode

constant counter_size : integer := 30;
begin
	--change game mode only when not in game mode
	
	s_mode <= mode when game_init = '1';
	process(clk)
	variable v_level : integer range 0 to 7 := 0;
	variable timer	: STD_logic_vector(counter_size downto 0) := (Others => '0'); -->= 2s
	begin
	
	if game_init = '1' then
		v_level := 0;
	elsif v_level < 6 and timer(counter_size) = '1' and rising_edge(clk) then
		v_level := v_level + 1;
	else 
		v_level := v_level;
	end if;
	
	if game_init  = '1' then
		timer := (OTHERS => '0');
	else
		if game_start = '1' then
		
			if rising_edge(clk) then
				if timer(counter_size) = '0' then
					timer := timer + '1';
				else
					timer := (OTHERS => '0');
				end if;
				
				
				
				
			end if;
				
			
		end if;
		
	end if;
	if s_mode = '0' then
		level <= conv_std_logic_vector(v_level, 3); 
	else
		level <= "000";
	end if;
	
	time_score <= timer(counter_size - 4) and not s_mode and game_start;
	end process;
end architecture level;
