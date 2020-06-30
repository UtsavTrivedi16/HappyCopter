library ieee;
use ieee.std_logic_1164.all;

entity reg is
	port(
		enable : in std_logic;
		Q_in : in std_logic_vector(9 downto 0);
		Q_out : out std_logic_vector(9 downto 0)
	);
end entity;

architecture ray of reg is
	signal v_Q : std_logic_vector(9 downto 0) := Q_in;
begin
	process(enable)
	begin
		if enable'event and enable = '0' then
			v_Q <= Q_in;
		end if;
		Q_out <= v_Q;
	end process;
end architecture ray;