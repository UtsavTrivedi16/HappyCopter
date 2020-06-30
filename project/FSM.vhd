-- Mealy Synchronous FSM
-- THIS IS INCOMPLETE
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity FSM is
	port
	(
		clk, reset_state : in std_logic;
		left_click, pause, dead: in std_logic;
		game_start, game_init, dead_out  : out std_logic
	);
end entity;
architecture rtl of FSM is
	-- Build an enumerated type for the state machine
	type state_type is (s_init, s_game, s_pause, s_dead);
	-- Register (and signal) to hold the current (and next) state
	signal state, next_state : state_type := s_init;
	signal reset : std_logic := '0';
begin
	state_reg: process (clk,reset_state)
	begin
		if reset_state = '1' then -- reset_game logic
			state <= s_init;
		elsif (rising_edge(clk)) then -- next state register:
			state <= next_state;
		end if;
	end process;
	-- Determine the next state based only on the current state
	-- and the input (do not wait for a clock edge).
	next_state_fn: process(state, left_click, clk)
	begin
		if rising_edge(clk) then
			case state is
				when s_init =>
					if left_click = '1' then
						next_state <= s_game;
					else
						next_state <= s_init;
					end if;
					
				when s_game =>
					if pause = '1' then  	
						next_state <= s_pause;
					elsif dead = '1' then
						next_state <= s_dead;
					else
						next_state <= s_game;
					end if;
						
				when s_pause =>
					if pause = '0' then
						next_state <= s_game;
					else
						next_state <= s_pause;
					end if;
						
				when s_dead =>
--					if left_click = '1' then 
--						next_state <= s_init;
					if pause = '1' then--use pause as return to menu command
						next_state <= s_init;
					else
						next_state <= s_dead;
					end if;
			end case;
		end if;
	end process;

	-- Determine the output based only on the current state
	-- and the input ( wait for a clock edge).
	output_fn: process (state, clk) -- output logic
	begin
		
		if rising_edge(clk) then
			Case state is
				When s_init =>
					game_start <= '0';
					game_init <= '1';
					dead_out <= '0';
				When s_game =>
					dead_out <= '0';
					game_start <= '1';
					game_init <= '0';
				
				When s_pause =>
					game_start <= '0';
					game_init <= '0';
					dead_out <= '0';
				When s_dead =>
					game_start <= '0';
					game_init <= '0';
					dead_out <= '1';
			end case;
				
		end if;
	end process;
end rtl;