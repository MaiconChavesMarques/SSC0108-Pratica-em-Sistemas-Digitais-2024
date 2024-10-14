library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity parte1 is
    Port ( 
        w : in STD_LOGIC;
        clock : in STD_LOGIC;       -- Sinal de clock
        clear : in STD_LOGIC;       -- Sinal de clear assíncrono
        data_out : out std_logic_vector(8 downto 0);  -- 9 bits de saída de dados
        z : out STD_LOGIC
    );
end parte1;

architecture Behavioral of parte1 is
    -- Sinais intermediários para conectar os flip-flops
    signal Q_internal : STD_LOGIC_VECTOR (8 downto 0); -- Estados internos dos flip-flops
    signal Not_Q_internal : STD_LOGIC_VECTOR (8 downto 0); -- Inversos dos estados
    signal Q_entrada_internal : STD_LOGIC_VECTOR (8 downto 0); -- Saídas internas dos flip-flops
    signal Not_Q_entrada_internal : STD_LOGIC_VECTOR (8 downto 0); -- Inversos das saídas internas
    signal Not_w : STD_LOGIC;
	 signal z_in : STD_LOGIC;
    
    component flipflop is
        port ( 
            D :  IN  STD_LOGIC;
            CLK :  IN  STD_LOGIC;
            QA :  OUT  STD_LOGIC;
            QB :  OUT  STD_LOGIC		  
        );
    end component;

begin


process(clock, clear)
    begin
        if clear = '1' then
            -- Se o reset for ativado, zera todos os sinais internos
              Q_entrada_internal(8 downto 0) <= (others => '0');
				  Not_Q_entrada_internal(8 downto 0) <= (others => '1'); -- Inversos dos bits de 0 a 7
				  z<= '0';
        elsif falling_edge(clock) then
            -- Atualiza os estados dos flip-flops com base na lógica desejada
            Q_entrada_internal(8) <= (w AND Q_internal(8)) OR (w AND Q_internal(7));
            Q_entrada_internal(7) <= (w AND Q_internal(6));
            Q_entrada_internal(6) <= (w AND Q_internal(5));
            Q_entrada_internal(5) <= (w AND (Not_Q_internal(0) OR Q_internal(1) OR Q_internal(2) OR Q_internal(3) OR Q_internal(4)));
            Q_entrada_internal(4) <= (Not_w AND Q_internal(4)) OR (Not_w AND Q_internal(3));
            Q_entrada_internal(3) <= (Not_w AND Q_internal(2));
            Q_entrada_internal(2) <= (Not_w AND Q_internal(1));
            Q_entrada_internal(1) <= (Not_w AND (Not_Q_internal(0) OR Q_internal(5) OR Q_internal(6) OR Q_internal(7) OR Q_internal(8)));
            Q_entrada_internal(0) <= '1';
				
            -- Atualiza os inversos
				Not_Q_entrada_internal <= NOT Q_entrada_internal;
			elsif rising_edge(clock) then
				z <= (Q_entrada_internal(4) OR Q_entrada_internal(8));
        end if;
    end process;
		  
		  Not_w <= NOT w;
            -- Instanciando os flip-flops
			dff1: flipflop
				 port map (
					  D => Q_entrada_internal(0),
					  CLK => clock,
					  QA => Q_internal(0),
					  QB => Not_Q_internal(0)
				 );

			dff2: flipflop
				 port map (
					  D => Q_entrada_internal(1),
					  CLK => clock,
					  QA => Q_internal(1),
					  QB => Not_Q_internal(1)
				 );

			dff3: flipflop
				 port map (
					  D => Q_entrada_internal(2),
					  CLK => clock,
					  QA => Q_internal(2),
					  QB => Not_Q_internal(2)
				 );

			dff4: flipflop
				 port map (
					  D => Q_entrada_internal(3),
					  CLK => clock,
					  QA => Q_internal(3),
					  QB => Not_Q_internal(3)
				 );

			dff5: flipflop
				 port map (
					  D => Q_entrada_internal(4),
					  CLK => clock,
					  QA => Q_internal(4),
					  QB => Not_Q_internal(4)
				 );

			dff6: flipflop
				 port map (
					  D => Q_entrada_internal(5),
					  CLK => clock,
					  QA => Q_internal(5),
					  QB => Not_Q_internal(5)
				 );

			dff7: flipflop
				 port map (
					  D => Q_entrada_internal(6),
					  CLK => clock,
					  QA => Q_internal(6),
					  QB => Not_Q_internal(6)
				 );

			dff8: flipflop
				 port map (
					  D => Q_entrada_internal(7),
					  CLK => clock,
					  QA => Q_internal(7),
					  QB => Not_Q_internal(7)
				 );

			dff9: flipflop
				 port map (
					  D => Q_entrada_internal(8),
					  CLK => clock,
					  QA => Q_internal(8),
					  QB => Not_Q_internal(8)
				 );

			 data_out <= Q_internal;

    -- Atribuindo a saída dos flip-flops à saída do contad

end Behavioral;
