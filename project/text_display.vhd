LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY Text_DISPLAY IS
	PORT(
		clk, add, reset, game_init, game_start, pause, dead, s_mode : IN STD_LOGIC;
		level : IN STD_LOGIC_VECTOR(2 downto 0);
		pixel_row, pixel_column : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		character_address	:	OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
		font_row, font_col:	OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE STAT OF Text_DISPLAY IS
	SIGNAL ROW_NUMBER : INTEGER RANGE 0 TO 480;
	SIGNAL COL_NUMBER : INTEGER RANGE 0 TO 640;
	SIGNAL H_SCORE_ONES, H_SCORE_TENS, H_SCORE_HUNDS, H_SCORE_THOUS : INTEGER RANGE 0 to 9 := 0;
	SIGNAL SCORE_ONES, SCORE_TENS, SCORE_HUNDS, SCORE_THOUS : INTEGER RANGE 0 to 9 := 0;
	CONSTANT A_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(1,6); -- A
	CONSTANT B_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(2,6); -- B
	CONSTANT C_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(3,6); -- C
	CONSTANT D_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(4,6); -- D
	CONSTANT E_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(5,6); -- E
	CONSTANT F_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(6,6); -- F
	CONSTANT G_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(7,6); -- G
	CONSTANT H_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(8,6);  -- H
	CONSTANT I_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(9,6);  -- I
	CONSTANT K_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(11,6); -- K
	CONSTANT L_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(12,6); -- L
	CONSTANT M_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(13,6); -- M
	CONSTANT N_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(14,6); -- N
	CONSTANT O_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(15,6); -- O
	CONSTANT P_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(16,6); -- P
	CONSTANT S_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(19,6); -- S
	CONSTANT R_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(18,6); -- R
	CONSTANT T_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(20,6); -- T
	CONSTANT U_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(21,6); -- U
	CONSTANT V_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(22,6); -- V
	CONSTANT W_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(23,6); -- W
	CONSTANT Y_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(25,6); -- Y
	CONSTANT LB_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(27,6); -- [
	CONSTANT RB_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(29,6); -- ]
	CONSTANT Space_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(32,6); -- Space_Bar
	CONSTANT Exclamation_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(33,6); -- !
	CONSTANT DASH_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(45,6); -- -
	CONSTANT COLON_SIG : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(58,6); -- ;
	
BEGIN
	ROW_NUMBER <= CONV_INTEGER(pixel_row);
	COL_NUMBER <= CONV_INTEGER(pixel_column);
	
	Display_Score: PROCESS(clk,reset)
		
		constant char_address_size : integer range 0 to 7 := 6;
		-- Each row is offset by multiples of 2 to get the correct Character from Mif file. This is due to spaces between each row/character
	BEGIN
	
		
	
		IF ROW_NUMBER >= 96 AND ROW_NUMBER < 160 THEN
			font_col <= pixel_column(4 downto 2);
			font_row <= pixel_row(4 DOWNTO 2);
		ELSE
			font_col <= pixel_column(3 downto 1);
			font_row <= pixel_row(3 DOWNTO 1);
		END IF;
	
		--display text in initial state
		IF game_init = '1' THEN		
			--PRINT WELCOME TO
			IF ROW_NUMBER < 16 THEN
				IF  COL_NUMBER < 16 THEN 
					character_address <= H_SIG;--print H
				ELSIF COL_NUMBER >= 16 and COL_NUMBER < 32 THEN
					character_address <= I_SIG;--print I
				ELSIF COL_NUMBER >= 32 and COL_NUMBER < 48 THEN
					character_address <= DASH_SIG;--print -
				ELSIF COL_NUMBER >= 48 and COL_NUMBER < 64 THEN
					character_address <= S_SIG;--print S
				ELSIF COL_NUMBER >= 64 and COL_NUMBER < 80 THEN
					character_address <= C_SIG;--print C
				ELSIF COL_NUMBER >= 80 and COL_NUMBER < 96 THEN
					character_address <= O_SIG;--print O
				ELSIF COL_NUMBER >= 96 and COL_NUMBER < 112 THEN
					character_address <= R_SIG;--print R
				ELSIF COL_NUMBER >= 112 and COL_NUMBER < 128 THEN
					character_address <= E_SIG;--print E
				ELSIF COL_NUMBER >= 128 and COL_NUMBER < 144 THEN
					character_address <= COLON_SIG;--print :
				ELSIF  COL_NUMBER >= 144 and COL_NUMBER < 160 THEN 
					character_address <= CONV_STD_LOGIC_VECTOR(48+H_SCORE_THOUS,6);					  
				ELSIF COL_NUMBER >= 160 and COL_NUMBER < 176 THEN
					character_address <= CONV_STD_LOGIC_VECTOR(48+H_SCORE_HUNDS,6);
				ELSIF COL_NUMBER >= 176 and COL_NUMBER < 192 THEN
					character_address <= CONV_STD_LOGIC_VECTOR(48+H_SCORE_TENS,6);
				ELSIF COL_NUMBER >= 192 and COL_NUMBER < 208 THEN
					character_address <= CONV_STD_LOGIC_VECTOR(48+H_SCORE_ONES,6);
				ELSE
					character_address <= Space_SIG;
				END IF;
			ELSIF ROW_NUMBER >= 96 AND ROW_NUMBER < 128 THEN--first row
				IF COL_NUMBER >= 160 AND COL_NUMBER < 192 THEN--print W
					character_address <= W_sIG; 
				ELSIF COL_NUMBER >= 192 and COL_NUMBER < 224 THEN --print E
					character_address <= E_sIG;
				ELSIF COL_NUMBER >= 224 and COL_NUMBER < 256 THEN--print L
					character_address <= L_SiG;
				ELSIF COL_NUMBER >= 256 and COL_NUMBER < 288 THEN--print C
					character_address <= C_SIG;
				ELSIF COL_NUMBER >= 288 and COL_NUMBER < 320 THEN--print O
					character_address <= O_SIG;
				ELSIF COL_NUMBER >= 320 and COL_NUMBER < 352 THEN--print M
					character_address <= M_SIG;
				ELSIF COL_NUMBER >= 352 and COL_NUMBER < 384 THEN--print E
					character_address <= E_SIG;
				ELSIF COL_NUMBER >= 416 and COL_NUMBER < 448 THEN--print (space in between) T
					character_address <= T_SIG;
				ELSIF COL_NUMBER >= 448 and COL_NUMBER < 480 THEN--print O
					character_address <= O_SIG;
				ELSE
					character_address <= Space_SIG;
				END IF;
			--PRINT HAPPYCOPTER!
			ELSIF ROW_NUMBER >= 128 AND ROW_NUMBER < 160 THEN--second row
				IF COL_NUMBER >= 128 and COL_NUMBER < 160 THEN--print H
					character_address <= H_SIG;
				ELSIF COL_NUMBER >= 160 and COL_NUMBER < 192 THEN--print A
					character_address <= A_SIG;
				ELSIF COL_NUMBER >= 192 and COL_NUMBER < 224 THEN--print P
					character_address <= P_SIG;
				ELSIF COL_NUMBER >= 224 and COL_NUMBER < 256 THEN--print P
					character_address <= P_SIG;
				ELSIF COL_NUMBER >= 256 and COL_NUMBER < 288 THEN--print Y
					character_address <= Y_SIG;
				ELSIF COL_NUMBER >= 288 and COL_NUMBER < 320 THEN--print C
					character_address <= C_SIG;
				ELSIF COL_NUMBER >= 320 and COL_NUMBER < 352 THEN--print O
					character_address <= O_SIG;
				ELSIF COL_NUMBER >= 352 and COL_NUMBER < 384 THEN--print P
					character_address <= P_SIG;
				ELSIF COL_NUMBER >= 384 and COL_NUMBER < 416 THEN--print T
					character_address <= T_SIG;
				ELSIF COL_NUMBER >= 416 and COL_NUMBER < 448 THEN--print E
					character_address <= E_SIG;
				ELSIF COL_NUMBER >= 448 and COL_NUMBER < 480 THEN--print R
					character_address <= R_SIG;
				ELSIF COL_NUMBER >= 480 and COL_NUMBER < 512 THEN--print !
					character_address <= Exclamation_SIG;
				ELSE
					character_address <= Space_SIG;
				END IF;
			--PRINT PRACTICE WITH BRACKETS AS HIGHLIGHTS
			ELSIF ROW_NUMBER >= 176 AND ROW_NUMBER < 192 THEN
				IF COL_NUMBER >= 160 AND COL_NUMBER < 176 AND S_MODE = '1' THEN
					character_address <= LB_SIG; --[
				ELSIF COL_NUMBER >= 176 AND COL_NUMBER < 192 THEN
					character_address <= P_SIG; --P
				ELSIF COL_NUMBER >= 192 AND COL_NUMBER < 208 THEN
					character_address <= R_SIG; --R
				ELSIF COL_NUMBER >= 208 AND COL_NUMBER < 224 THEN
					character_address <= A_SIG; --A
				ELSIF COL_NUMBER >= 224 AND COL_NUMBER < 240 THEN
					character_address <= c_SIG; --C
				ELSIF COL_NUMBER >= 240 AND COL_NUMBER < 256 THEN
					character_address <= T_SIG; --T
				ELSIF COL_NUMBER >= 256 AND COL_NUMBER < 272 THEN
					character_address <= I_SIG; --I
				ELSIF COL_NUMBER >= 272 AND COL_NUMBER < 288 THEN
					character_address <= C_SIG; --C
				ELSIF COL_NUMBER >= 288 AND COL_NUMBER < 304 THEN
					character_address <= E_SIG; --E
				ELSIF COL_NUMBER >= 304 AND COL_NUMBER < 320 AND S_MODE = '1' THEN
					character_address <= RB_SIG; --]
				ELSE
					character_address <= Space_SIG;
				END IF;
			--PRINTS SINGLE-PLAYER WITH BRACKETS FOR HIGHLIGHTS
			ELSIF ROW_NUMBER >= 192 AND ROW_NUMBER < 208 THEN
				IF COL_NUMBER >= 160 AND COL_NUMBER < 176 AND S_MODE = '0' THEN
					character_address <= LB_SIG; --[
				ELSIF COL_NUMBER >= 176 AND COL_NUMBER < 192 THEN
					character_address <= S_SIG; --s
				ELSIF COL_NUMBER >= 192 AND COL_NUMBER < 208 THEN
					character_address <= I_SIG; --I
				ELSIF COL_NUMBER >= 208 AND COL_NUMBER < 224 THEN
					character_address <= N_SIG; --N
				ELSIF COL_NUMBER >= 224 AND COL_NUMBER < 240 THEN
					character_address <= G_SIG; --G
				ELSIF COL_NUMBER >= 240 AND COL_NUMBER < 256 THEN
					character_address <= L_SIG; --L
				ELSIF COL_NUMBER >= 256 AND COL_NUMBER < 272 THEN
					character_address <= E_SIG; --E
				ELSIF COL_NUMBER >= 272 AND COL_NUMBER < 288 THEN
					character_address <= DASH_SIG; --  -
				ELSIF COL_NUMBER >= 288 AND COL_NUMBER < 304 THEN
					character_address <= P_SIG; --P
				ELSIF COL_NUMBER >= 304 AND COL_NUMBER < 320 THEN
					character_address <= L_SIG; --L
				ELSIF COL_NUMBER >= 320 AND COL_NUMBER < 336 THEN
					character_address <= A_SIG; --A
				ELSIF COL_NUMBER >= 336 AND COL_NUMBER < 352 THEN
					character_address <= Y_SIG; --Y
				ELSIF COL_NUMBER >= 352 AND COL_NUMBER < 368 THEN
					character_address <= E_SIG; --E
				ELSIF COL_NUMBER >= 368 AND COL_NUMBER < 384 THEN
					character_address <= R_SIG; --R
				ELSIF COL_NUMBER >= 384 AND COL_NUMBER < 400 AND S_MODE = '0' THEN
					character_address <= RB_SIG; --]
				ELSE
					character_address <= Space_SIG;
				END IF;
			ELSIF ROW_NUMBER  >= 224 AND ROW_NUMBER < 240 THEN
				IF COL_NUMBER >= 160 AND COL_NUMBER < 176 THEN
					character_address <= L_SIG; --L
				ELSIF COL_NUMBER >= 176 AND COL_NUMBER < 192 THEN
					character_address <= E_SIG; --E
				ELSIF COL_NUMBER >= 192 AND COL_NUMBER < 208 THEN
					character_address <= F_SIG; --F
				ELSIF COL_NUMBER >= 208 AND COL_NUMBER < 224 THEN
					character_address <= T_SIG; --T
				ELSIF COL_NUMBER >= 224 AND COL_NUMBER < 240 THEN
					character_address <= DASH_SIG; -- -
				ELSIF COL_NUMBER >= 240 AND COL_NUMBER < 256 THEN
					character_address <= C_SIG; --C
				ELSIF COL_NUMBER >= 256 AND COL_NUMBER < 272 THEN
					character_address <= L_SIG; --L
				ELSIF COL_NUMBER >= 272 AND COL_NUMBER < 288 THEN
					character_address <= I_SIG; --  I
				ELSIF COL_NUMBER >= 288 AND COL_NUMBER < 304 THEN
					character_address <= C_SIG; --C
				ELSIF COL_NUMBER >= 304 AND COL_NUMBER < 320 THEN
					character_address <= K_SIG; --K
				ELSIF COL_NUMBER >= 320 AND COL_NUMBER < 336 THEN
					character_address <= COLON_SIG; --:
				ELSIF COL_NUMBER >= 336 AND COL_NUMBER < 352 THEN
					character_address <= G_SIG; --G
				ELSIF COL_NUMBER >= 352 AND COL_NUMBER < 368 THEN
					character_address <= O_SIG; --O
				ELSIF COL_NUMBER >= 384 AND COL_NUMBER < 400 THEN
					character_address <= U_SIG; --U
				ELSIF COL_NUMBER >= 400 AND COL_NUMBER < 416 THEN
					character_address <= P_SIG; --P
				ELSE
					character_address <= space_sig;
				END IF;
			ELSIF ROW_NUMBER  >= 224 AND ROW_NUMBER < 240 THEN
				IF COL_NUMBER >= 160 AND COL_NUMBER < 176 THEN
					character_address <= L_SIG; --L
				ELSIF COL_NUMBER >= 176 AND COL_NUMBER < 192 THEN
					character_address <= E_SIG; --E
				ELSIF COL_NUMBER >= 192 AND COL_NUMBER < 208 THEN
					character_address <= F_SIG; --F
				ELSIF COL_NUMBER >= 208 AND COL_NUMBER < 224 THEN
					character_address <= T_SIG; --T
				ELSIF COL_NUMBER >= 224 AND COL_NUMBER < 240 THEN
					character_address <= DASH_SIG; -- -
				ELSIF COL_NUMBER >= 240 AND COL_NUMBER < 256 THEN
					character_address <= C_SIG; --C
				ELSIF COL_NUMBER >= 256 AND COL_NUMBER < 272 THEN
					character_address <= L_SIG; --L
				ELSIF COL_NUMBER >= 272 AND COL_NUMBER < 288 THEN
					character_address <= I_SIG; --I
				ELSIF COL_NUMBER >= 288 AND COL_NUMBER < 304 THEN
					character_address <= C_SIG; --C
				ELSIF COL_NUMBER >= 304 AND COL_NUMBER < 320 THEN
					character_address <= K_SIG; --K
				ELSIF COL_NUMBER >= 320 AND COL_NUMBER < 336 THEN
					character_address <= COLON_SIG; --:
				ELSIF COL_NUMBER >= 336 AND COL_NUMBER < 352 THEN
					character_address <= G_SIG; --G
				ELSIF COL_NUMBER >= 352 AND COL_NUMBER < 368 THEN
					character_address <= O_SIG; --O
				ELSIF COL_NUMBER >= 384 AND COL_NUMBER < 400 THEN
					character_address <= U_SIG; --U
				ELSIF COL_NUMBER >= 400 AND COL_NUMBER < 416 THEN
					character_address <= P_SIG; --P
				ELSE
					character_address <= space_sig;
				END IF;
			ELSIF ROW_NUMBER  >= 240 AND ROW_NUMBER < 256 THEN
				IF COL_NUMBER >= 160 AND COL_NUMBER < 176 THEN
					character_address <= M_SIG; --M
				ELSIF COL_NUMBER >= 176 AND COL_NUMBER < 192 THEN
					character_address <= I_SIG; --I
				ELSIF COL_NUMBER >= 192 AND COL_NUMBER < 208 THEN
					character_address <= D_SIG; --D
				ELSIF COL_NUMBER >= 208 AND COL_NUMBER < 224 THEN
					character_address <= DASH_SIG; -- -
				ELSIF COL_NUMBER >= 224 AND COL_NUMBER < 240 THEN
					character_address <= C_SIG; -- C
				ELSIF COL_NUMBER >= 240 AND COL_NUMBER < 256 THEN
					character_address <= L_SIG; --L
				ELSIF COL_NUMBER >= 256 AND COL_NUMBER < 272 THEN
					character_address <= I_SIG; --I
				ELSIF COL_NUMBER >= 272 AND COL_NUMBER < 288 THEN
					character_address <= C_SIG; --C
				ELSIF COL_NUMBER >= 288 AND COL_NUMBER < 304 THEN
					character_address <= K_SIG; --K
				ELSIF COL_NUMBER >= 304 AND COL_NUMBER < 320 THEN
					character_address <= COLON_SIG; --:
				ELSIF COL_NUMBER >= 320 AND COL_NUMBER < 336 THEN
					character_address <= P_SIG; --P
				ELSIF COL_NUMBER >= 336 AND COL_NUMBER < 352 THEN
					character_address <= A_SIG; --A
				ELSIF COL_NUMBER >= 352 AND COL_NUMBER < 368 THEN
					character_address <= U_SIG; --U
				ELSIF COL_NUMBER >= 368 AND COL_NUMBER < 384 THEN
					character_address <= S_SIG; --S
				ELSIF COL_NUMBER >= 384 AND COL_NUMBER < 400 THEN
					character_address <= E_SIG; --E
				ELSE
					character_address <= space_sig;
				END IF;
			ELSIF ROW_NUMBER  >= 256 AND ROW_NUMBER < 272 THEN
				IF COL_NUMBER >= 160 AND COL_NUMBER < 176 THEN
					character_address <= R_SIG; --R
				ELSIF COL_NUMBER >= 176 AND COL_NUMBER < 192 THEN
					character_address <= I_SIG; --I
				ELSIF COL_NUMBER >= 192 AND COL_NUMBER < 208 THEN
					character_address <= G_SIG; --G
				ELSIF COL_NUMBER >= 208 AND COL_NUMBER < 224 THEN
					character_address <= H_SIG; --H
				ELSIF COL_NUMBER >= 224 AND COL_NUMBER < 240 THEN
					character_address <= T_SIG; --T
				ELSIF COL_NUMBER >= 240 AND COL_NUMBER < 256 THEN
					character_address <= DASH_SIG; -- -
				ELSIF COL_NUMBER >= 256 AND COL_NUMBER < 272 THEN
					character_address <= C_SIG; --C
				ELSIF COL_NUMBER >= 272 AND COL_NUMBER < 288 THEN
					character_address <= L_SIG; --L
				ELSIF COL_NUMBER >= 288 AND COL_NUMBER < 304 THEN
					character_address <= I_SIG; --I
				ELSIF COL_NUMBER >= 304 AND COL_NUMBER < 320 THEN
					character_address <= C_SIG; --C
				ELSIF COL_NUMBER >= 320 AND COL_NUMBER < 336 THEN
					character_address <= K_SIG; --K
				ELSIF COL_NUMBER >= 336 AND COL_NUMBER < 352 THEN
					character_address <= COLON_SIG; -- :
				ELSIF COL_NUMBER >= 352 AND COL_NUMBER < 368 THEN
					character_address <= D_SIG; --D
				ELSIF COL_NUMBER >= 368 AND COL_NUMBER < 384 THEN
					character_address <= O_SIG; --O
				ELSIF COL_NUMBER >= 384 AND COL_NUMBER < 400 THEN
					character_address <= D_SIG; --D
				ELSIF COL_NUMBER >= 400 AND COL_NUMBER < 416 THEN
					character_address <= G_SIG; --G
				ELSIF COL_NUMBER >= 416 AND COL_NUMBER < 432 THEN
					character_address <= E_SIG; --E
				ELSE
					character_address <= space_sig;
				END IF;
			ELSE
				character_address <= Space_SIG;
			END IF;
		--display text in game mode
		ELSIF game_start = '1' or pause = '1' THEN

			IF ROW_NUMBER < 16 THEN
				IF  COL_NUMBER < 16 THEN 
					character_address <= H_SIG;--print H
				ELSIF COL_NUMBER >= 16 and COL_NUMBER < 32 THEN
					character_address <= I_SIG;--print I
				ELSIF COL_NUMBER >= 32 and COL_NUMBER < 48 THEN
					character_address <= DASH_SIG;--print -
				ELSIF COL_NUMBER >= 48 and COL_NUMBER < 64 THEN
					character_address <= S_SIG;--print S
				ELSIF COL_NUMBER >= 64 and COL_NUMBER < 80 THEN
					character_address <= C_SIG;--print C
				ELSIF COL_NUMBER >= 80 and COL_NUMBER < 96 THEN
					character_address <= O_SIG;--print O
				ELSIF COL_NUMBER >= 96 and COL_NUMBER < 112 THEN
					character_address <= R_SIG;--print R
				ELSIF COL_NUMBER >= 112 and COL_NUMBER < 128 THEN
					character_address <= E_SIG;--print E
				ELSIF COL_NUMBER >= 128 and COL_NUMBER < 144 THEN
					character_address <= COLON_SIG;--print :
				ELSIF  COL_NUMBER >= 144 and COL_NUMBER < 160 THEN 
					character_address <= CONV_STD_LOGIC_VECTOR(48+H_SCORE_THOUS,6);					  
				ELSIF COL_NUMBER >= 160 and COL_NUMBER < 176 THEN
					character_address <= CONV_STD_LOGIC_VECTOR(48+H_SCORE_HUNDS,6);
				ELSIF COL_NUMBER >= 176 and COL_NUMBER < 192 THEN
					character_address <= CONV_STD_LOGIC_VECTOR(48+H_SCORE_TENS,6);
				ELSIF COL_NUMBER >= 192 and COL_NUMBER < 208 THEN
					character_address <= CONV_STD_LOGIC_VECTOR(48+H_SCORE_ONES,6);
				ElSIF COL_NUMBER >= 528 and COL_NUMBER < 544 THEN 
					character_address <= L_SIG;--print L
				ELSIF COL_NUMBER >= 544 and COL_NUMBER < 560 THEN
					character_address <= E_SIG;--print E
				ELSIF COL_NUMBER >= 560 and COL_NUMBER < 576 THEN
					character_address <= V_SIG;--print V
				ELSIF COL_NUMBER >= 576 and COL_NUMBER < 592 THEN
					character_address <= E_SIG;--print E
				ELSIF COL_NUMBER >= 592 and COL_NUMBER < 608 THEN
					character_address <= L_SIG;--print L
				ELSIF COL_NUMBER >= 608 and COL_NUMBER < 624 THEN
					character_address <= COLON_SIG;--print :
				ELSIF  COL_NUMBER >= 624 and COL_NUMBER < 640 THEN 
					character_address <= CONV_STD_LOGIC_VECTOR(49+CONV_INTEGER(LEVEL),6);
				ELSE
					character_address <= Space_SIG;
				END IF;	
			ELSIF ROW_NUMBER >= 16 AND ROW_NUMBER < 32 THEN
				IF  COL_NUMBER < 16 THEN 
					character_address <= S_SIG;--print S
				ELSIF COL_NUMBER >= 16 and COL_NUMBER < 32 THEN
					character_address <= C_SIG;--print C
				ELSIF COL_NUMBER >= 32 and COL_NUMBER < 48 THEN
					character_address <= O_SIG;--print O
				ELSIF COL_NUMBER >= 48 and COL_NUMBER < 64 THEN
					character_address <= R_SIG;--print R
				ELSIF COL_NUMBER >= 64 and COL_NUMBER < 80 THEN
					character_address <= E_SIG;--print E
				ELSIF COL_NUMBER >= 80 and COL_NUMBER < 96 THEN
					character_address <= COLON_SIG;--print :
				ELSIF  COL_NUMBER >= 96 and COL_NUMBER < 112 THEN 
					character_address <= CONV_STD_LOGIC_VECTOR(48+SCORE_THOUS,6);					  
				ELSIF COL_NUMBER >= 112 and COL_NUMBER < 128 THEN
					character_address <= CONV_STD_LOGIC_VECTOR(48+SCORE_HUNDS,6);
				ELSIF COL_NUMBER >= 128 and COL_NUMBER < 144 THEN
					character_address <= CONV_STD_LOGIC_VECTOR(48+SCORE_TENS,6);
				ELSIF COL_NUMBER >= 144 and COL_NUMBER < 160 THEN
					character_address <= CONV_STD_LOGIC_VECTOR(48+SCORE_ONES,6);
				ELSE
					character_address <= Space_SIG;
				END IF;
			ELSIF ROW_NUMBER >= 96 AND ROW_NUMBER < 128 and PAUSE = '1' THEN
				IF COL_NUMBER >= 160 AND COL_NUMBER < 192 THEN--print P
					character_address <= P_sIG; 
				ELSIF COL_NUMBER >= 192 and COL_NUMBER < 224 THEN --print A
					character_address <= A_sIG;
				ELSIF COL_NUMBER >= 224 and COL_NUMBER < 256 THEN--print U
					character_address <= U_SiG;
				ELSIF COL_NUMBER >= 256 and COL_NUMBER < 288 THEN--print S
					character_address <= S_SIG;
				ELSIF COL_NUMBER >= 288 and COL_NUMBER < 320 THEN--print E
					character_address <= E_SIG;
				ELSIF COL_NUMBER >= 320 and COL_NUMBER < 352 THEN--print D
					character_address <= D_SIG;
				ELSIF COL_NUMBER >= 352 and COL_NUMBER < 384 THEN--print !
					character_address <= Exclamation_SIG;
				ELSE
					character_address <= Space_SIG;
				END IF;
			ELSE
				character_address <= Space_SIG;
			END IF;
		ELSIF DEAD = '1' THEN
			--PRINT HI-SCORES
			IF ROW_NUMBER < 16 THEN
				IF  COL_NUMBER < 16 THEN 
					character_address <= H_SIG;--print H
				ELSIF COL_NUMBER >= 16 and COL_NUMBER < 32 THEN
					character_address <= I_SIG;--print I
				ELSIF COL_NUMBER >= 32 and COL_NUMBER < 48 THEN
					character_address <= DASH_SIG;--print -
				ELSIF COL_NUMBER >= 48 and COL_NUMBER < 64 THEN
					character_address <= S_SIG;--print S
				ELSIF COL_NUMBER >= 64 and COL_NUMBER < 80 THEN
					character_address <= C_SIG;--print C
				ELSIF COL_NUMBER >= 80 and COL_NUMBER < 96 THEN
					character_address <= O_SIG;--print O
				ELSIF COL_NUMBER >= 96 and COL_NUMBER < 112 THEN
					character_address <= R_SIG;--print R
				ELSIF COL_NUMBER >= 112 and COL_NUMBER < 128 THEN
					character_address <= E_SIG;--print E
				ELSIF COL_NUMBER >= 128 and COL_NUMBER < 144 THEN
					character_address <= COLON_SIG;--print :
				ELSIF  COL_NUMBER >= 144 and COL_NUMBER < 160 THEN 
					character_address <= CONV_STD_LOGIC_VECTOR(48+H_SCORE_THOUS,6);					  
				ELSIF COL_NUMBER >= 160 and COL_NUMBER < 176 THEN
					character_address <= CONV_STD_LOGIC_VECTOR(48+H_SCORE_HUNDS,6);
				ELSIF COL_NUMBER >= 176 and COL_NUMBER < 192 THEN
					character_address <= CONV_STD_LOGIC_VECTOR(48+H_SCORE_TENS,6);
				ELSIF COL_NUMBER >= 192 and COL_NUMBER < 208 THEN
					character_address <= CONV_STD_LOGIC_VECTOR(48+H_SCORE_ONES,6);
				ELSE
					character_address <= Space_SIG;
				END IF;
			ELSIF ROW_NUMBER >= 96 AND ROW_NUMBER < 128 THEN--first row
				IF COL_NUMBER >= 160 AND COL_NUMBER < 192 THEN--print G
					character_address <= G_sIG; 
				ELSIF COL_NUMBER >= 192 and COL_NUMBER < 224 THEN --print A
					character_address <= A_sIG;
				ELSIF COL_NUMBER >= 224 and COL_NUMBER < 256 THEN--print M
					character_address <= M_SiG;
				ELSIF COL_NUMBER >= 256 and COL_NUMBER < 288 THEN--print E
					character_address <= E_SIG;
				ELSIF COL_NUMBER >= 320 and COL_NUMBER < 352 THEN--print O
					character_address <= O_SIG;
				ELSIF COL_NUMBER >= 352 and COL_NUMBER < 384 THEN--print V
					character_address <= V_SIG;
				ELSIF COL_NUMBER >= 384 and COL_NUMBER < 416 THEN--print E
					character_address <= E_SIG;
				ELSIF COL_NUMBER >= 416 and COL_NUMBER < 448 THEN--print R
					character_address <= R_SIG;
				ELSIF COL_NUMBER >= 448 and COL_NUMBER < 480 THEN--print !
					character_address <= EXCLAMATION_SIG;
				ELSE
					character_address <= Space_SIG;
				END IF;
			ELSIF ROW_NUMBER >= 128 AND ROW_NUMBER < 160 THEN--first row
				IF COL_NUMBER >= 160 AND COL_NUMBER < 192 THEN--print S
					character_address <= S_sIG; 
				ELSIF COL_NUMBER >= 192 and COL_NUMBER < 224 THEN --print C
					character_address <= C_sIG;
				ELSIF COL_NUMBER >= 224 and COL_NUMBER < 256 THEN--print O
					character_address <= O_SiG;
				ELSIF COL_NUMBER >= 256 and COL_NUMBER < 288 THEN--print R
					character_address <= R_SIG;
				ELSIF COL_NUMBER >= 288 and COL_NUMBER < 320 THEN--print E
					character_address <= E_SIG;
				ELSIF COL_NUMBER >= 320 and COL_NUMBER < 352 THEN--print :
					character_address <= COLON_SIG;
					
				--CURRENT SCORE PRINTED
				ELSIF COL_NUMBER >= 352 and COL_NUMBER < 384 THEN
					character_address <= CONV_STD_LOGIC_VECTOR(48 + SCORE_THOUS, 6);
				ELSIF COL_NUMBER >= 384 and COL_NUMBER < 416 THEN
					character_address <= CONV_STD_LOGIC_VECTOR(48 + SCORE_HUNDS, 6);
				ELSIF COL_NUMBER >= 416 and COL_NUMBER < 448 THEN
					character_address <= CONV_STD_LOGIC_VECTOR(48 + SCORE_TENS, 6);
				ELSIF COL_NUMBER >= 448 and COL_NUMBER < 480 THEN
					character_address <= CONV_STD_LOGIC_VECTOR(48 + SCORE_ONES, 6);
				ELSE
					character_address <= Space_SIG;
				END IF;
			ELSE
				character_address <= SPAce_SIG;
			END IF;
		ELSE
			character_address <= Space_SIG;
			font_col <= pixel_column(3 downto 1);
			font_row <= pixel_row(3 DOWNTO 1);
		END IF;
		
		
	END PROCESS;
	
	Determine_Score: Process(clk, add, reset)
		VARIABLE ADD_DELAY : INTEGER RANGE 0 to 3 := 0; --used to delay function from continously adding
	begin
		if reset = '1' then
			score_thous <= 0;
			scoRE_HUNDS <= 0;
			score_tens <= 0;
			score_ones <= 0;
		elsif clk'event and clk = '1' then
			if add = '1' then
			--increment delay so that the adding score only happens at one clock cycle regardless
			--of how long add has been on '1' for
				if add_delay < 3 then 
					add_delay := add_delay + 1;
					if add_delay = 1 then -- at delay equal to one
						--incrementing function begins here
						if score_ones < 9 then
							score_ones <= score_ones + 1;
						elsE
							SCORE_ONES <= 0;
							if score_tens < 9 then
								score_tens <= score_tens + 1;
							elsE
								SCORE_tens <= 0;
								if score_hunds < 9 then
									score_hunds <= score_hunds + 1;
								elsE
									SCORE_hunds <= 0;
									if score_thous < 9 then
										score_thous <= score_thous + 1;
									elsE
										SCORE_thous <= 0;
									end if;
								end if;
							end if;
						--incrementing function ends here
						end if;
					end if;
				end if;
				
				--Update high score
				if h_score_thous < score_thous then
					h_score_thous <= score_thous;
					h_score_hunds <= score_hunds;
					h_score_tens <= score_tens;
					h_score_ones <= score_ones;
				elsif h_score_thous = score_thous then
					if h_score_hunds < score_hunds then
						h_score_hunds <= score_hunds;
						h_score_tens <= score_tens;
						h_score_ones <= score_ones;
					elsif h_score_hunds = score_hunds then
						if h_score_tens < score_tens then
							h_score_tens <= score_tens;
							h_score_ones <= score_ones;
						elsif h_score_tens = score_tens then
							if h_score_ones < score_ones then
								h_score_ones <= score_ones;
							ELSE
								h_score_ones <= h_score_ones;
							end if;
						ELSE
							h_score_tens <= h_score_tens;
						end if;
					ELSE
						h_score_hunds <= h_score_hunds;
					end if;
				ELSE
					h_score_thous <= h_score_thous;
				end if;
			elsE
				add_delay := 0;
			end if;
		end if;
		
		
		
	end process;
END ARCHITECTURE STAT;