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
		Q3 : out std_logic
	);
end contador;

architecture behavioral of contador is
	signal contador_interno : unsigned (25 downto 0);
	signal contador_externo : unsigned (3 downto 0);
	
begin
	process(clock, reset, enable)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				contador_interno <= (others => '0');
				contador_externo <= (others => '0');
			elsif enable = '1' then
				if contador_interno = 50000000 then
					contador_interno <= (others => '0');
					if contador_externo = 9 then
						contador_externo <= (others => '0');
					else
						contador_externo <= contador_externo + 1;
					end if;
				else
					contador_interno <= contador_interno + 1;
				end if;
			end if;
		end if;
	end process;

	Q0 <= contador_externo(0);
	Q1 <= contador_externo(1);
	Q2 <= contador_externo(2);
	Q3 <= contador_externo(3);

end behavioral;
