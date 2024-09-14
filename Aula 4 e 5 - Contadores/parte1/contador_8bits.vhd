library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contador_8bits is
    Port ( enable1 : in STD_LOGIC;       -- Sinal de clock
			  clock : in STD_LOGIC;       -- Sinal de clock
           clear : in STD_LOGIC;     -- Sinal de clear assíncrono
			  Q0 : out STD_LOGIC;
			  Q1 : out STD_LOGIC;
			  Q2 : out STD_LOGIC;
			  Q3 : out STD_LOGIC;
			  Q4 : out STD_LOGIC;
			  Q5 : out STD_LOGIC;
			  Q6 : out STD_LOGIC;
			  Q7 : out STD_LOGIC
         );
end contador_8bits;

architecture Behavioral of contador_8bits is
    -- Sinais intermediários para conectar os flip-flops
	 signal enable_signals : STD_LOGIC_VECTOR (7 downto 0); -- Estados internos dos flip-flops
    signal Q_internal : STD_LOGIC_VECTOR (7 downto 0); -- Estados internos dos flip-flops
	 signal and_signals : STD_LOGIC_VECTOR (7 downto 0); -- Estados internos dos flip-flops
	 
	 	component t_flip_flop is
		port ( 
			  clock : in STD_LOGIC;
           clear : in STD_LOGIC; 
           enable : in STD_LOGIC;     
           Q : out STD_LOGIC;
			  nQ : out STD_LOGIC 		  
         );
	end component;
	 
begin
    -- Instanciando o primeiro flip-flop T (bit menos significativo)
    tff0: t_flip_flop
        port map (clock => clock,
                  clear => clear,
                  enable => enable1,           -- Flip-flop T sempre habilitado
                  Q => Q_internal(0)  -- Saída do primeiro flip-flop
                  );

    -- Geração dos sinais AND entre os flip-flops
    and_signals(1) <= Q_internal(0) AND enable1;  -- O primeiro flip-flop não precisa de AND

    tff1: t_flip_flop
        port map (clock => clock,
                  clear => clear,
                  enable => and_signals(1), -- O segundo flip-flop alterna quando o primeiro estiver em '1'
                  Q => Q_internal(1)
                  );

    -- AND para o próximo flip-flop
    and_signals(2) <= and_signals(1) AND Q_internal(1);

    tff2: t_flip_flop
        port map (clock => clock,
                  clear => clear,
                  enable => and_signals(2), -- O terceiro flip-flop alterna quando os dois anteriores estiverem em '1'
                  Q => Q_internal(2)
                  );

    -- AND para o próximo flip-flop
    and_signals(3) <= and_signals(2) AND Q_internal(2);

    tff3: t_flip_flop
        port map (clock => clock,
                  clear => clear,
                  enable => and_signals(3),
                  Q => Q_internal(3)
                  );

    and_signals(4) <= and_signals(3) AND Q_internal(3);

    tff4: t_flip_flop
        port map (clock => clock,
                  clear => clear,
                  enable => and_signals(4),
                  Q => Q_internal(4)
                  );

    and_signals(5) <= and_signals(4) AND Q_internal(4);

    tff5: t_flip_flop
        port map (clock => clock,
                  clear => clear,
                  enable => and_signals(5),
                  Q => Q_internal(5)
                  );

    and_signals(6) <= and_signals(5) AND Q_internal(5);

    tff6: t_flip_flop
        port map (clock => clock,
                  clear => clear,
                  enable => and_signals(6),
                  Q => Q_internal(6)
                  );

    and_signals(7) <= and_signals(6) AND Q_internal(6);

    tff7: t_flip_flop
        port map (clock => clock,
                  clear => clear,
                  enable => and_signals(7),
                  Q => Q_internal(7)
                  );

    -- Atribuindo a saída dos flip-flops à saída do contador
    Q0 <= Q_internal(0);
	 Q1 <= Q_internal(1);
	 Q2 <= Q_internal(2);
	 Q3 <= Q_internal(3);
	 Q4 <= Q_internal(4);
	 Q5 <= Q_internal(5);
	 Q6 <= Q_internal(6);
	 Q7 <= Q_internal(7);

end Behavioral;
