LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY bomb IS
	Generic(ADDR_WIDTH: integer := 12; DATA_WIDTH: integer := 1);

   PORT(
		  SIGNAL clk, vert_sync_int	 : IN std_LOGIC;
		  SIGNAL pixel_row, pixel_column : IN std_logic_vector(9 downto 0);
		  SIGNAL game_start, game_init	: in std_logic;
		  SIGNAL level : in std_logic_vector(2 downto 0);
		  SIGNAL random_placer	: in std_logic_vector(8 downto 0);
		  SIGNAL RGB	:	OUT std_logic_vector(2 downto 0); --RGB(2) for red, RGB(1) for green, RGB(0) for red
		  SIGNAL bomb_enable : out std_logic
		);
END ENTITY;

architecture behavior of bomb is


		-- Video Display Signals
Constant gap_size 	: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(85,10); -- Gap size
constant Screen_Left : std_logic_vector(9 downto 0) := conV_STD_LOGIC_VECTOR(0, 10); --- Screen dimensions
constant Screen_Right : std_logic_vector(9 downto 0) := conV_STD_LOGIC_VECTOR(659, 10);
constant Screen_Up : std_logic_vector(9 downto 0) := conV_STD_LOGIC_VECTOR(0, 10);
CONSTANT bomb_size 	: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(8,10);  
constant Screen_Down : std_logic_vector(9 downto 0) := conV_STD_LOGIC_VECTOR(479, 10);		
constant bomb_x_init_pos : std_logic_vector (9 downto 0)	:= CONV_STD_LOGIC_VECTOR(316,10);

SIGNAL Red_Data, Green_Data, Blue_Data,
		reset, bomb_on, Direction		: std_logic;
signal bomb_speed 		: std_logic_vector(9 DOWNTO 0) := ConV_STD_LOGIC_VECTOR(0, 10); -- Speed
SIGNAL bomb_Y_pos          : std_logic_vector(9 DOWNTO 0);
constant bomb_X_pos				: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(316,10);

BEGIN
-- Concurrent assignments sent to Collision Manager
bomb_enable <= bomb_on;
bomb_Display: Process (pixel_column, pixel_row)


--VARIABLE DELAY_SECOND_bomb : INTEGER RANGE 0 TO 310 := 310;
BEGIN
			-- Set bomb_on ='1' to display bomb
			--- CHeck Pixel_column and Width first
	IF ('0' & bomb_X_pos <= pixel_column + Bomb_size) AND
				-- compare positive numbers only
		(bomb_X_pos + Bomb_Size >= '0' & pixel_column) AND
		('0' & Bomb_Y_pos <= pixel_row + Bomb_Size) AND
		(bomb_Y_pos + Bomb_Size >= '0' & pixel_row ) THEN
			bomb_on <= '1';
	ELSE
		bomb_on <= '0';
	END IF;
		RGB <= '0' & bomb_on & bomb_on; --Mix
END process bomb_Display;


Move_bomb: process(clk, vert_sync_int)
constant counter_size : integer := 29;
variable random_adder	: integer range 0 to 85400 := 0; -->= 0.5s
variable ball_drop : integer range 0 to 60:= 0; -- Timer
BEGIN

if game_init = '1' then
	bomb_Y_pos <= screen_down + gap_size;
	random_adder := 0;
elsif game_start = '1' then
	IF rising_edge(vert_sync_int) then
		if random_adder > 85000 and '0' & bomb_Y_pos >= screen_down + bomb_Size then
			random_adder := 0;
			bomb_Y_pos <= screen_up;
			ball_drop := 60;
		elsE
			random_adder := random_adder + CONV_INTEGER('0' & RANdom_placer);
			if ball_drop > 0 then
				ball_drop := ball_drop - 1;
			end if;
			bomb_Y_pos <= bomb_Y_pos + bomb_speed;
		end if;
		
		
		--freefall from 0
		if '0' & bomb_Y_pos <= screen_down + bomb_Size then
			if ball_drop > 55 then
				bomb_speed <= CONV_STD_LOGIC_VECTOR(0,10);
			ELSif ball_drop > 50 then
				bomb_speed <= CONV_STD_LOGIC_VECTOR(1,10);
			ELSif ball_drop > 45 then
				bomb_speed <= CONV_STD_LOGIC_VECTOR(2,10);
			ELSif ball_drop > 40 then
				bomb_speed <= CONV_STD_LOGIC_VECTOR(3,10);
			ELSif ball_drop > 35 then
				bomb_speed <= CONV_STD_LOGIC_VECTOR(4,10);
			ELSif ball_drop > 30 then
				bomb_speed <= CONV_STD_LOGIC_VECTOR(5,10);
			ELSif ball_drop > 25 then
				bomb_speed <= CONV_STD_LOGIC_VECTOR(6,10);
			ELSE
				bomb_speed <= CONV_STD_LOGIC_VECTOR(7,10);
			END IF;
		elsE
			bomb_speed <= CONV_STD_LOGIC_VECTOR(0,10);
		end if;
		
		
		
	end if;
END IF;
	
	
END process Move_bomb;

End Architecture behavior;