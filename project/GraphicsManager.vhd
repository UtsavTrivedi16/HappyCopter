LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;

entity GraphicsManager is 
	PORT(
		clk, text_input, copter_on, pipe_on, background_on, bomb_on: in std_logic;
		pipe_rgb, bomb_rgb : in std_logic_vector(2 downto 0);
		copter_rgb, background_rgb						: in std_logic_vector(11 downto 0);
		  --Signal pixel_row, pixel_column : in std_logic_vector(9 downto 0);
		red_out, green_out, blue_out : out std_logic_vector(3 downto 0)
		);
end entity;


architecture behaviour of GraphicsManager is 

begin

Render : process(clk)
begin
-- for now out put colors will be on for each bits in that particular group
if rising_edge(clk) then
		--each if statement determines whether any of the objects are rendered black or not
		if copter_on = '1' then --output copter first
				red_out <=  copter_rgb(11 downto 8);
				green_out <= copter_rgb(7 downto 4);
				blue_out <= copter_rgb(3 downto 0);
				
		elsif text_input = '1' then --output text second
				red_out <= (others => '0');
				green_out <= (others => '1');
				blue_out <= (others => '0');
				
		elsif bomb_on = '1' then --output pipe pic third
				red_out <= (others => bomb_rgb(2));
				green_out <= (others => bomb_rgb(1));
				blue_out <= (others => bomb_rgb(0));
				
		elsif pipe_on = '1' then --output pipe pic third
				red_out <= (others => pipe_rgb(2));
				green_out <= (others => pipe_rgb(1));
				blue_out <= (others => pipe_rgb(0));
				
		elsif background_on = '1' then --output background last presumably
				red_out <= background_rgb(11 downto 8);
				green_out <= background_rgb(7 downto 4);
				blue_out <= background_rgb(3 downto 0);
				--red_out <= (others => '1');
				--green_out <= (others => '1'); --WHite
				--blue_out <= (others => '1');
		else
				red_out <= (others => '0');
				green_out <= (others => '0');
				blue_out <= (others => '0');
		end if;
		

end if;

end process;

end architecture behaviour;
				
		
		



