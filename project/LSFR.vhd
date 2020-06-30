library ieee;
use ieee.std_logic_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity lsfr is
	port(
		clk : in std_logic;
		Q : out std_logic_vector(8 downto 0)
		--Q : out std_logic_vector(3 downto 0)
	);
end entity;

architecture reg of lsfr is
	signal v_Q : std_logic_vector(8 downto 0) := "100000000";
	constant max_V_Q : std_logic_vector(8 downto 0) := conv_std_logic_vector(330,9);
	
begin
	process(clk)
	
	begin
	
		if clk'event and clk = '1' then
			v_Q(0) <= v_Q(8);
			v_Q(1) <= v_Q(0);
			v_Q(2) <= v_Q(1);
			v_Q(3) <= v_Q(2);
			v_Q(4) <= v_Q(3) xor v_Q(8);
			v_Q(5) <= v_Q(4);
			v_Q(6) <= v_Q(5);
			v_Q(7) <= v_Q(6);
			v_Q(8) <= v_Q(7);
		end if;
		if v_Q > max_V_Q then
			Q <= v_Q - max_V_Q;
		else
			Q <= v_Q;
		end if;
	
	end process;
end architecture reg;