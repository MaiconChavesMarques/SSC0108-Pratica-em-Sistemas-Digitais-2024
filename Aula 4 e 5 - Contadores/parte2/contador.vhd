library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador is
	port(
		enable : in std_logic;
		clock : in std_logic;
		reset : in std_logic;
		Q0 : out std_logic;
		Q1 : out std_logic;
		Q2 : out std_logic;
		Q3 : out std_logic;
		Q4 : out std_logic;
		Q5 : out std_logic;
		Q6 : out std_logic;
		Q7 : out std_logic;
		Q8 : out std_logic;
		Q9 : out std_logic;
		Q10 : out std_logic;
		Q11 : out std_logic;
		Q12 : out std_logic;
		Q13 : out std_logic;
		Q14 : out std_logic;
		Q15 : out std_logic
	);
end contador;

architecture behavioral of contador is
	 signal contador_interno : unsigned (15 downto 0);
begin
	 
	process(clock, reset, enable)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				contador_interno <= (others => '0');
			elsif enable = '1' then
				contador_interno <= contador_interno + 1;
			else
				contador_interno <= contador_interno;
			end if;
		end if;
	end process;

	Q0 <= contador_interno(0);
	Q1 <= contador_interno(1);
	Q2 <= contador_interno(2);
	Q3 <= contador_interno(3);
	Q4 <= contador_interno(4);
	Q5 <= contador_interno(5);
	Q6 <= contador_interno(6);
	Q7 <= contador_interno(7);
	Q8 <= contador_interno(8);
	Q9 <= contador_interno(9);
	Q10 <= contador_interno(10);
	Q11 <= contador_interno(11);
	Q12 <= contador_interno(12);
	Q13 <= contador_interno(13);
	Q14 <= contador_interno(14);
	Q15 <= contador_interno(15);

end behavioral;
