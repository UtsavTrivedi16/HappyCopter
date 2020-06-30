

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY background_display IS
	PORT
	(
		pixel_row, pixel_col	:	IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock				: 	IN STD_LOGIC ;
		background_rgb		:	OUT STD_LOGIC_VECTOR(11 DowNTO 0)
	);
END background_display;


ARCHITECTURE SYN OF background_display IS

	SIGNAL rom_data		: STD_LOGIC_VECTOR (11 DOWNTO 0);
	SIGNAL rom_address	: STD_LOGIC_VECTOR (14 DOWNTO 0);

	COMPONENT background_gen
	
	PORT (
		clock		: IN STD_LOGIC ;
		address	: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	--rom_mux_output	<= sub_wire0(7 DOWNTO 0);

	background_component : background_gen

	PORT MAP (
		clock => clock,
		address => rom_address,
		q => rom_data
	);
	-- Scaling pixel row stuff to get 
	rom_address <= pixel_col(9 Downto 2) + Conv_Std_logic_vector((Conv_Integer(pixel_row(9 Downto 2)) * 160), 15);
	background_rgb <= rom_data;
END SYN;