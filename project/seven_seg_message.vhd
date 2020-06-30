LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY seven_seg_message IS
	PORT(
		switch : in std_logic;
		seg0, seg1, seg2, seg3 : out std_logic_vector(6 downto 0)
	);
END ENTITY;
	
ARCHITECTURE DISP OF seven_seg_message IS
BEGIN
	PROCESS(switch)
	BEGIN
		IF SWITCH = '1' THEN
			seg3 <= "0001100"; --P
			seg2 <= "0101111"; --r
			seg0 <= "1000110"; --C
		ELSE
			seg3 <= "0101111"; --r
			seg2 <= "0000110"; --E
			seg0 <= "1000111"; --L
		END IF;
		seg1 <= "0001000"; --A
	END PROCESS;

END ARCHITECTURE DISP;