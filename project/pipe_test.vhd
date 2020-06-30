LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY pipe_test IS
	Generic(ADDR_WIDTH: integer := 12; DATA_WIDTH: integer := 1);

   PORT(
		  SIGNAL vert_sync_int: IN std_LOGIC;
		  SIGNAL pixel_row, pixel_column : IN std_logic_vector(9 downto 0);
		  SIGNAL game_start, game_init	: in std_logic;
		  SIGNAL level : in std_logic_vector(2 downto 0);
		  SIGNAL random_placer	: in std_logic_vector(8 downto 0);
		  SIGNAL RGB	:	OUT std_logic_vector(2 downto 0); --RGB(2) for red, RGB(1) for green, RGB(0) for red
		  SIGNAL pipe_enable : out std_logic
		);
END ENTITY;

architecture behavior of pipe_test is


		-- Video Display Signals
Constant gap_size 	: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(150,10); -- Gap size
constant Screen_Left : std_logic_vector(9 downto 0) := conV_STD_LOGIC_VECTOR(0, 10); --- Screen dimensions
constant Screen_Right : std_logic_vector(9 downto 0) := conV_STD_LOGIC_VECTOR(660, 10);
constant Screen_Up : std_logic_vector(9 downto 0) := conV_STD_LOGIC_VECTOR(0, 10);
CONSTANT Pipe_wid 					: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(20,10);  
constant Screen_Down : std_logic_vector(9 downto 0) := conV_STD_LOGIC_VECTOR(479, 10);		
constant change_pipe_length_pos : std_logic_vector(9 downto 0) := conV_STD_LOGIC_VECTOR(800, 10);		
Constant Pipe_displacement : std_logic_vector(9 DOWNTO 0) := ConV_STD_LOGIC_VECTOR(341, 10);

SIGNAL Red_Data, Green_Data, Blue_Data,
		reset, pipe_on, Direction		: std_logic;
SIGNAL Pipe_length 					: std_logic_vector(8 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(75,9);
SIGNAL Second_Pipe_length 					: std_logic_vector(8 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(100,9);
SIGNAL Third_Pipe_length 					: std_logic_vector(8 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(150,9);
signal pipe_X_motion 		: std_logic_vector(3 DOWNTO 0); -- Speed
SIGNAL pipe_X_pos				: std_logic_vector(9 DOWNTO 0) := Screen_Right; -- RightEND start pipe

Signal Second_Pipe_X_Pos	: std_logic_vector(9 DOWNTO 0) := Pipe_X_pos + Pipe_displacement;
Signal Third_Pipe_X_Pos	: std_logic_vector(9 DOWNTO 0) := Second_Pipe_X_pos + Pipe_displacement;
--SIGNAL pixel_row, pixel_column				: std_logic_vector(9 DOWNTO 0); 
BEGIN
-- Concurrent assignments sent to Collision Manager
pipe_enable <= pipe_on;

--pipe_on <= '1' When game_init = '0' and 
					--(pipe_X_pos < pixel_column + pipe_wid and pipe_X_pos + pipe_wid > pixel_column) and not (pixel_row >= pipe_length and pixel_row < pipe_length + gap_size) else '0';
--RGB <= "00" & pipe_on; --Blue
pipe_Display: Process (pixel_column, pixel_row, vert_sync_int, pipe_X_pos, second_Pipe_X_Pos)
VARIABLE DELAY_SECOND_PIPE : INTEGER RANGE 0 TO 610 := 310;
BEGIN

	--If level = "000" then
		IF rising_edge(vert_sync_int) then 
			if DELAY_SECOND_PIPE > 0 AND GAME_start = '1' THEN
				DELAY_SECOND_PIPE := DELAY_SECOND_PIPE - 1;
			ELSIF GAMe_init = '1' THEN
				DELAY_SECOND_PIPE := 610;
			END IF;
		end if;
				-- Set pipe_on ='1' to display pipe
				--- CHeck Pixel_column and Width first
		IF ('0' & pipe_X_pos < pixel_column +  pipe_wid) AND ('0' & pipe_X_pos + pipe_wid >= '0' & pixel_column)  THEN
					-- compare positive numbers only				
				IF pixel_row >= '0' & pipe_length nand ('0' & pixel_row < pipe_length + gap_size) then
					pipe_on <= '1';
				else 
					pipe_on <= '0';
				end if;
			
		ELSIF ('0' & Second_Pipe_X_Pos < pixel_column + pipe_wid) AND (Second_pipe_X_pos + pipe_wid >= '0' & pixel_column) AND delay_second_pipe < 310 THEN
				IF pixel_row >= '0' & Second_pipe_length nand ('0' & pixel_row < Second_pipe_length + gap_size) then
					pipe_on <= '1';
				else
					pipe_on <= '0';
				end if;
		ELSIF ('0' & Third_Pipe_X_Pos < pixel_column + pipe_wid) AND (Third_pipe_X_pos + pipe_wid >= '0' & pixel_column) AND delay_second_pipe < 10 THEN
				IF pixel_row >= '0' & Third_pipe_length nand ('0' & pixel_row < Third_pipe_length + gap_size) then
					pipe_on <= '1';
				else
					pipe_on <= '0';
				end if;	
		else
			pipe_on <= '0';
		END IF;
		RGB <= "00" & pipe_on; --Blue
	--end if;
END process pipe_Display;


Move_pipe: process(vert_sync_int)

BEGIN
IF rising_edge(vert_sync_int) then
		-- Move pipe once every vertical sync. Increase randomness by not doing below logic in a state
	If pipe_X_pos >= screen_right and pipe_X_pos < change_pipe_length_pos and 
	random_placer < '0' & (screen_Down - gap_size) and random_placer > pipe_wid then
		Pipe_length <=  random_placer;
	else
		pipe_length <= pipe_length;
	end if;

	if Second_pipe_X_pos >= screen_right and Second_pipe_X_pos < change_pipe_length_pos and 
	random_placer < '0' & (screen_Down - gap_size) and random_placer > pipe_wid then
		Second_Pipe_length <=  random_placer;
	else
		Second_pipe_length <= Second_pipe_length;
	end if;

	if Third_pipe_X_pos >= screen_right and Third_pipe_X_pos < change_pipe_length_pos and 
	random_placer < '0' & (screen_Down - gap_size) and random_placer > pipe_wid then
		Third_Pipe_length <=  random_placer;
	else
		Third_pipe_length <= Third_pipe_length;
	end if;

pipe_X_motion <= CONV_STD_LOGIC_VECTOR(1, 4) +  ('0' & level);

	IF game_init = '1' then -- Initialise pipe at this position
			Pipe_X_pos <= screen_right;
			Second_Pipe_X_Pos <= screen_right + Pipe_displacement;	
			Third_Pipe_X_Pos <= Second_Pipe_X_Pos + Pipe_displacement;
	ELSIF game_start = '1' then
		
		
			-- Compute next pipe X position
			pipe_X_pos <= pipe_X_pos - pipe_X_motion;
			Second_Pipe_X_Pos <= Second_Pipe_X_Pos - pipe_X_motion;
			Third_Pipe_X_pos <= Third_Pipe_X_Pos - pipe_X_motion;
	END IF;
		

END IF;
	
	
END process Move_pipe;

End Architecture behavior;