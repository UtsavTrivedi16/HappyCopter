LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

ENTITY ball_test IS
	Generic(ADDR_WIDTH: integer := 12; DATA_WIDTH: integer := 1);

   PORT(SIGNAL PB1, game_start, Clock, vert_sync_int, game_init : IN std_logic;
			-- use "red(3 downto 0) & green(3 downto 0) & blue(3 downto 0)"
        SIGNAL Color 			: OUT std_logic_vector(11 downto 0);
		  SIGNAL pixel_row, pixel_column : IN std_logic_vector(9 downto 0);
		  SIGNAL ball_collide, move_left : in std_logic;
		  Signal ball_enable, ball_out_of_screen	: out std_logic	
		);
END ENTITY;

architecture behavior of ball_test is


		-- Video Display Signals   
SIGNAL reset, Ball_on, Direction		: std_logic;
CONSTANT Size 					: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(8,10);
SIGNAL Ball_Y_motion 		: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(0,10);
Signal Ball_X_motion 		: std_logic_vector(9 DOWNTO 0);
SIGNAL Ball_Y_pos          : std_logic_vector(9 DOWNTO 0);
SIGNAL Ball_X_pos				: std_logic_vector(9 DOWNTO 0);
signal rgb_data            : std_logic_vector(8 downto 0);
signal ball_current_address : std_logic_vector(5 downto 0);
signal blue_data, red_data, green_data : std_logic_vector(3 downto 0) := "0000";

constant ball_vertical_init_pos : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(320,10);
constant ball_horizontal_init_pos : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(316,10);
constant Screen_Up : std_logic_vector(9 downto 0) := conV_STD_LOGIC_VECTOR(0, 10);
constant Screen_Down : std_logic_vector(9 downto 0) := conV_STD_LOGIC_VECTOR(479, 10);
constant Screen_Left : std_logic_vector(9 downto 0) := conV_STD_LOGIC_VECTOR(0, 10); --- Screen dimensions
constant Screen_Right : std_logic_vector(9 downto 0) := conV_STD_LOGIC_VECTOR(639, 10);

component copter
	PORT(
		address		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (8 DOWNTO 0));
end component;

BEGIN
-- Concurrent Assignments for Outside Block
ball_enable <= ball_on;

Ball_address_determinant: process(Ball_X_pos, Ball_Y_pos, pixel_column, pixel_row)
begin
	if ((pixel_column - ball_x_pos < size) and (pixel_row - ball_y_pos < size)) and 
	((pixel_column - ball_x_pos >= screen_up) and (pixel_row - ball_y_pos >= screen_up)) then
		ball_current_address <= conv_std_logic_vector(conv_integer(pixel_column - ball_x_pos) + conv_integer(pixel_row - ball_y_pos) * 8, 6);
	elsE
		ball_current_address <= (others => '0');
	end if;

		case rgb_data(2 downto 0) is
			when "001" => blue_data <= "0001";
			when "011" => blue_data <= "0011";
			when "101" => blue_data <= "0111";
			when "111" => blue_data <= "1111";
			when others => blue_data <= "0000";
		end case;

	

		case rgb_data(5 downto 3) is
			when "001" => green_data <= "0001";
			when "011" => green_data <= "0011";
			when "101" => green_data <= "0111";
			when "111" => green_data <= "1111";
			when others => green_data <= "0000";
		end case;

	

		case rgb_data(8 downto 6) is
			when "001" => red_data <= "0001";
			when "011" => red_data <= "0011";
			when "101" => red_data <= "0111";
			when "111" => red_data <= "1111";
			when others => red_data <= "0000";
		end case;

end process;

ball_render: copter 
port map(
	address => ball_current_address,
	clock => clock,
	q => rgb_data
);
			
Ball_Display: Process (Ball_X_pos, Ball_Y_pos, pixel_column, pixel_row)
BEGIN
			-- Set Ball_on ='1' to display ball
 IF ('0' & Ball_X_pos <= pixel_column + Size) AND
 			-- compare positive numbers only
 	(Ball_X_pos + Size >= '0' & pixel_column) AND
 	('0' & Ball_Y_pos <= pixel_row + Size) AND
 	(Ball_Y_pos + Size >= '0' & pixel_row ) THEN
		if rgb_data = "000000000" then
			ball_on <= '0';
		else
			Ball_on <= '1';
		end if;
		
 ELSE
	Ball_on <= '0';
 END IF;
	color <= red_data & green_data & blue_data;
END process Ball_Display;


Move_Ball_Vertical: process(clock, vert_sync_int, move_left)
VARIABLE time_something : integer range 0 to 95 := 0;
VARIABLE time_something2 : integer range 0 to 81 := 0;
--variable delay_pos_update : std_logic_vector(counter_size downto 0) := (Others => '0'); 

	
BEGIN
			-- Move ball once every vertical sync
	
	
	IF game_init = '1' then --- Initialise Ball at this position
		ball_out_of_screen <= '0';
		time_something2 := 0;
		Ball_Y_pos <= ball_vertical_init_pos;
		Ball_X_pos <= ball_horizontal_init_pos;
	ELSIF game_start = '1' then
		
		if rising_edge(vert_sync_int) then
			
			
			-- Out of Screen Check
			if (('0' & Ball_Y_pos < Screen_Down - Size) and ('0' & Ball_Y_pos > Screen_Up + Size)) or -- Changing to AND gate makes it die immediately for some reason
				
				
				(('0' & Ball_X_Pos > Screen_Left + Size) and ('0' & Ball_X_Pos < Screen_Right - Size)) then
				
				ball_out_of_screen <= '0';
			else
			
				ball_out_of_screen <= '1';
				
			end if;
	
			-- Y motion Calculations below. A timer changes speed after a mouse click
				
			IF PB1 = '1' THEN
				time_something := 95; --set to time that ball can start flying upwards
			END IF;
			IF Move_left = '1' and time_something2 = 0 then
				time_something2 := 81;
			end if;
		
			IF time_something > 0 THEN --Updates position irrespective of mouse click i.e alive/dead
				time_something := time_something - 1;
			END IF;
			IF time_something2 > 0 THEN
				time_something2 := time_something2 - 1;
			end if;
			
			--To make a horizontal 'bounce'
			IF time_something2 > 80 then
				ball_x_motion <= CONV_STD_LOGIC_VECTOR(0,10);
			ELSIF time_something2 > 70 then
				ball_x_motion <= - CONV_STD_LOGIC_VECTOR(3,10);
			ELSIF time_something2 > 65 then
				ball_x_motion <= - CONV_STD_LOGIC_VECTOR(2,10);
			ELSIF time_something2 > 60 then
				ball_x_motion <= - CONV_STD_LOGIC_VECTOR(1,10);
			ELSIF time_something2 > 55 then
				ball_x_motion <= CONV_STD_LOGIC_VECTOR(0,10);
			ELSIF time_something2 > 50 then
				ball_x_motion <= CONV_STD_LOGIC_VECTOR(1,10);
			ELSIF time_something2 > 45 then
				ball_x_motion <= CONV_STD_LOGIC_VECTOR(2,10);
			ELSIF time_something2 > 35 then
				ball_x_motion <= CONV_STD_LOGIC_VECTOR(3,10);
			ELSE
				ball_x_motion <= CONV_STD_LOGIC_VECTOR(0,10);
			end if;
			
			--To achieve free fall
			IF time_something > 90 THEN
				Ball_Y_motion <= -CONV_STD_LOGIC_VECTOR(4,10);	
			ELSIF time_something > 85 THEN
				Ball_Y_motion <= -CONV_STD_LOGIC_VECTOR(3,10);	
			ELSIF time_something > 80 THEN
				Ball_Y_motion <= -CONV_STD_LOGIC_VECTOR(2,10);
			ELSIF time_something > 75 THEN
				Ball_Y_motion <= -CONV_STD_LOGIC_VECTOR(1,10);
			ELSIF time_something > 70 THEN
				Ball_Y_motion <=  CONV_STD_LOGIC_VECTOR(0,10);
			ELSIF time_something > 65 THEN
				Ball_Y_motion <=  CONV_STD_LOGIC_VECTOR(1,10);
		
			ELSIF time_something > 60 THEN
				Ball_Y_motion <=  CONV_STD_LOGIC_VECTOR(2,10);
			
			ELSIF time_something > 55 THEN
				Ball_Y_motion <=  CONV_STD_LOGIC_VECTOR(3,10);
			
			ELSIF time_something > 50 THEN
				Ball_Y_motion <=  CONV_STD_LOGIC_VECTOR(4,10);
			
			ELSIF time_something > 45 THEN
				Ball_Y_motion <=  CONV_STD_LOGIC_VECTOR(5,10);
			
			ELSIF time_something > 40 THEN
				Ball_Y_motion <=  CONV_STD_LOGIC_VECTOR(6,10);
			
			ELSE
				Ball_Y_motion <=  CONV_STD_LOGIC_VECTOR(7,10);
			END IF;
			
			-- Compute next ball X and Y position
			Ball_Y_pos <= Ball_Y_pos + Ball_Y_motion;	
			Ball_X_pos <= Ball_X_pos + Ball_X_motion;
		
		END IF;
			
	END IF;
	
	
	
END process Move_Ball_Vertical;

End Architecture behavior;