library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity t_flip_flop is
    Port ( clock : in STD_LOGIC;
           clear : in STD_LOGIC; 
           enable : in STD_LOGIC;     
           Q : out STD_LOGIC;
			  nQ : out STD_LOGIC 		  
         );
end t_flip_flop;

architecture Behavioral of t_flip_flop is
    signal Q_internal : STD_LOGIC := '0';
	 signal nQ_internal : STD_LOGIC := '1';
begin
    process(clock, clear)
    begin
        if clear = '1' then
            Q_internal <= '0';  
        elsif rising_edge(clock) then
            if enable = '1' then
                Q_internal <= not Q_internal;
					 nQ_internal <= not nQ_internal;
            end if;
        end if;
    end process;

    Q <= Q_internal;
	nQ <= nQ_internal; 
end Behavioral;
