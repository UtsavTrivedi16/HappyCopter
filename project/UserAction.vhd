-- Updates Status Signals of FSM Based on UserInput. Button Presses on the FPGA
LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;
entity UserAction is
		port(
			clk, mid_click , left_click, game_init: in std_logic;
			pause   : out std_logic
		);
end UserAction;

architecture rtl of UserAction is
Signal mid_click_event : std_logic := '0';
Signal click : std_logic := '0';
begin
		-- Concurrent assignments
		pause <= mid_click_event;
		-- Active low buttons
			-- Yet to add reset logic
--		game_mode <= '1' when left_click = '1' else '0';
--		
		
Check_rightClick:process(clk)
			Variable delay : integer range 0 to 50 := 0; -- 2 us delay for 25 Mhz clock
			
			begin
			if rising_edge(clk) then
				
				
				if mid_click = '1' then
					delay := 0; -- Reset on debounce
					click <= '1';
				end if;
				
				if (left_click = '1' and mid_click_event = '1') or game_init = '1' then -- Unpauses on left and right click
					mid_click_event <= '0';
				elsif delay > 48 and click = '1' then
					delay := 0;
					click <= '0';
					mid_click_event <= not mid_click_event;
				end if;
				
				delay := delay + 1;
			end if;
end process;

end architecture rtl;
