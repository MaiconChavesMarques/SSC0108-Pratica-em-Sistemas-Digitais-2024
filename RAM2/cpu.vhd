-- Processador Versao: 04/11/2024

libraRY ieee;
use ieee.std_LOGIC_1164.all;
use ieee.std_LOGIC_ARITH.all;
use ieee.std_LOGIC_unsigned.all;

entity cpu is
	port( clk			: in	std_LOGIC;
			reset			: in	std_LOGIC;
		);
end cpu;
	
	ENTITY ram256x8 IS
		PORT
		(
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			rdaddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			wraddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			wren		: IN STD_LOGIC  := '0';
			q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END ram256x8;

ARCHITECTURE main of cpu is

	TYPE STATES				is (fetch, fetch2, decode, exec, exec2);						-- Estados da Maquina de Controle do Processador
	
	signal RA : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal RB : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal RR : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal PC : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal IR : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	
	CONSTANT ADD       : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	CONSTANT SUB       : STD_LOGIC_VECTOR(3 downto 0) := "0001";
	CONSTANT AND1      : STD_LOGIC_VECTOR(3 downto 0) := "0010";
	CONSTANT OR1       : STD_LOGIC_VECTOR(3 downto 0) := "0011";
	CONSTANT NOT1      : STD_LOGIC_VECTOR(3 downto 0) := "0100";
	CONSTANT CMP       : STD_LOGIC_VECTOR(3 downto 0) := "0101";
	CONSTANT JMP       : STD_LOGIC_VECTOR(3 downto 0) := "0110";
	CONSTANT JEQ       : STD_LOGIC_VECTOR(3 downto 0) := "0111";
	CONSTANT JGR       : STD_LOGIC_VECTOR(3 downto 0) := "1000";
	CONSTANT LOAD      : STD_LOGIC_VECTOR(3 downto 0) := "1001";
	CONSTANT STORE     : STD_LOGIC_VECTOR(3 downto 0) := "1010";
	CONSTANT MOV       : STD_LOGIC_VECTOR(3 downto 0) := "1011";
	CONSTANT IN1       : STD_LOGIC_VECTOR(3 downto 0) := "1100";
	CONSTANT OUT1      : STD_LOGIC_VECTOR(3 downto 0) := "1101";
	CONSTANT WAIT1     : STD_LOGIC_VECTOR(3 downto 0) := "1110";
	CONSTANT MY        : STD_LOGIC_VECTOR(3 downto 0) := "1111";
	
	signal X : STD_LOGIC_VECTOR (7 downto 0) := (others => '0'); --Operadores da ULA
	signal Y : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal RESULT : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal INIT_ULA : STD_LOGIC := '0';
	signal FRzero : STD_LOGIC;
	signal FRmaior : STD_LOGIC;
	signal FRover : STD_LOGIC;
	                  
	signal data_in    : std_logic_vector(7 downto 0) := (others => '0');
	signal raddress  : std_logic_vector(7 downto 0);
	signal waddress  : std_logic_vector(7 downto 0) := (others => '0');
	signal write1     : std_logic := '0';                   
	signal data_out   : std_logic_vector(7 downto 0);


begin
	    ram_instance: ram256x8
        port map (
            clock     => clock,
            data      => data_in,      
            rdaddress => raddress,     
            wraddress => waddress,     
            wren      => write1,     
            q         => data_out
        );

-- Maquina de Controle
process(clk, reset)
	
begin

		case state is
--************************************************************************
-- FETCH STATE
--************************************************************************		
		
		when fetch =>
		
			-- Inicio das acoes do ciclo de Busca !!       
			raddress <= PC;
			STATE := fetch2;
			
-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

--************************************************************************
-- FETCH2 STATE
--************************************************************************		
		
		when fetch2 =>
		
			-- Inicio das acoes do ciclo de Busca !!       
			IR <= data_out;
			PC <= STD_LOGIC_VECTOR(unsigned(PC) + 1);

			STATE := decode;
			
-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  
        			

--************************************************************************
-- DECODE STATE
--************************************************************************
		when decode =>

--========================================================================
-- ADD ou SUB ou AND ou OR ou CMP
--========================================================================			
			IF(IR(7 DOWNTO 4) = ADD or (IR(7 DOWNTO 4) = "0001") or (IR(7 DOWNTO 4) = "0010")
				 or (IR(7 DOWNTO 4) = "0011") or (IR(7 DOWNTO 4) = "0101")) THEN
				 
				 IF((IR(3 DOWNTO 0) = "0000")) THEN  -- A A
					  X <= RA;
					  Y <= RA;
					  INIT_ULA <= '1';
				 ELSIF(IR(3 DOWNTO 0) = "0001") THEN  -- A B
					  X <= RA;
					  Y <= RB;
					  INIT_ULA <= '1';
				 ELSIF(IR(3 DOWNTO 0) = "0011") THEN  -- A i
					  X <= RA;
					  raddress <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
				 ELSIF(IR(3 DOWNTO 0) = "0010") THEN  -- A R
					  X <= RA;
					  Y <= RR;
					  INIT_ULA <= '1';
				 ELSIF(IR(3 DOWNTO 0) = "0100") THEN  -- B A
					  X <= RB;
					  Y <= RA;
					  INIT_ULA <= '1';
				 ELSIF(IR(3 DOWNTO 0) = "0101") THEN  -- B B
					  X <= RB;
					  Y <= RB;
					  INIT_ULA <= '1';
				 ELSIF(IR(3 DOWNTO 0) = "0111") THEN  -- B i
					  X <= RB;
					  raddress <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
				 ELSIF(IR(3 DOWNTO 0) = "0110") THEN  -- B R
					  X <= RB;
					  Y <= RR;
					  INIT_ULA <= '1';
				 ELSIF(IR(3 DOWNTO 0) = "1100") THEN  -- i A
					  raddress <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
					  Y <= RA;
				 ELSIF(IR(3 DOWNTO 0) = "1101") THEN  -- i B
					  raddress <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
					  Y <= RB;
				 ELSIF(IR(3 DOWNTO 0) = "1110") THEN  -- i R
					  raddress <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
					  Y <= RR;
				 ELSIF(IR(3 DOWNTO 0) = "1000") THEN  -- R A
					  X <= RR;
					  Y <= RA;
					  INIT_ULA <= '1';
				 ELSIF(IR(3 DOWNTO 0) = "1001") THEN  -- R B
					  X <= RR;
					  Y <= RB;
					  INIT_ULA <= '1';
				 ELSIF(IR(3 DOWNTO 0) = "1011") THEN  -- R i
					  X <= RR;
					  raddress <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
				 ELSIF(IR(3 DOWNTO 0) = "1010") THEN  -- R R
					  X <= RR;
					  Y <= RR;
					  INIT_ULA <= '1';
				 END IF;
				 state := exec;
			END IF;

--========================================================================
-- NOT
--========================================================================			
			IF(IR(7 DOWNTO 4) = '0100') THEN
				IF(IR(3 DOWNTO 0) = '0000') THEN
					X = RA
				ELSIF(IR(3 DOWNTO 0) = '0001') THEN
					X = RB
				ELSIF(IR(3 DOWNTO 0) = '0010') THEN
					X = RR
				END IF;
				INIT_ULA <= '1';
				state := fetch;
			END IF;

--========================================================================
-- JMP
--========================================================================		
			IF(IR(7 DOWNTO 4) = JMP) THEN
				raddress <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
				state := exec;
			END IF;
			
--========================================================================
-- JEQ
--========================================================================			
			IF(IR(7 DOWNTO 4) = JEQ) THEN
				IF(FRzero = '1') THEN
					raddress <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
				END IF;
				state := exec;
			END IF;
			

--========================================================================
-- JGR
--========================================================================			
			IF(IR(7 DOWNTO 4) = JGR) THEN
				IF(FRzero = '0' and FRmaior ='1') THEN
					raddress <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
				END IF;
				state := exec;
			END IF;
			
--========================================================================
-- LOAD
--========================================================================            
			IF (IR(7 DOWNTO 4) = LOAD) THEN

				 IF (IR(3 DOWNTO 0) = "0000") THEN  -- A A: Carrega para o registrador RA o conteúdo do endereço em RA
					  raddress <= RA;

				 ELSIF (IR(3 DOWNTO 0) = "0001") THEN  -- A B: Carrega para o registrador RA o conteúdo do endereço em RB
					  raddress <= RB;

				 ELSIF (IR(3 DOWNTO 0) = "0011") THEN  -- A i: Carrega para o registrador RA o conteúdo do endereço imediato
					  raddress <= STD_LOGIC_VECTOR(unsigned(PC) + 1);

				 ELSIF (IR(3 DOWNTO 0) = "0010") THEN  -- A R: Carrega para o registrador RA o valor do endereço em RR
					  raddress <= RR;

				 ELSIF (IR(3 DOWNTO 0) = "0100") THEN  -- B A: Carrega para o registrador RB o conteúdo do endereço em RA
					  raddress <= RA;

				 ELSIF (IR(3 DOWNTO 0) = "0101") THEN  -- B B: Carrega para o registrador RB o conteúdo do endereço em RB
					  raddress <= RB;

				 ELSIF (IR(3 DOWNTO 0) = "0111") THEN  -- B i: Carrega para o registrador RB o conteúdo do endereço imediato
					  raddress <= STD_LOGIC_VECTOR(unsigned(PC) + 1);

				 ELSIF (IR(3 DOWNTO 0) = "0110") THEN  -- B R: Carrega para o registrador RB o valor do endereço em RR
					  raddress <= RR;

				 ELSIF (IR(3 DOWNTO 0) = "1000") THEN  -- R A: Carrega para o registrador RR o conteúdo do endereço em RA
					  raddress <= RA;

				 ELSIF (IR(3 DOWNTO 0) = "1001") THEN  -- R B: Carrega para o registrador RR o conteúdo do endereço em RB
					  raddress <= RB;

				 ELSIF (IR(3 DOWNTO 0) = "1011") THEN  -- R i: Carrega para o registrador RR o conteúdo do endereço imediato
					  raddress <= STD_LOGIC_VECTOR(unsigned(PC) + 1);

				 ELSIF (IR(3 DOWNTO 0) = "1010") THEN  -- R R: Carrega para o registrador RR o valor do endereço em RR
					  raddress <= RR;

				 END IF;
				 state := exec;
			END IF;

--========================================================================
-- STORE
--========================================================================            
			IF (IR(7 DOWNTO 4) = STORE) THEN

				 IF (IR(3 DOWNTO 0) = "0000") THEN  -- A A: 
					  waddress <= RA;
					  data_in <= RA;
					  write1 <= '1';

				 ELSIF (IR(3 DOWNTO 0) = "0001") THEN  -- A B: 
					  waddress <= RB;
					  data_in <= RA;
					  write1 <= '1';

				 ELSIF (IR(3 DOWNTO 0) = "0010") THEN  -- A R:
					  waddress <= RR;
					  data_in <= RA;
					  write1 <= '1';

				 ELSIF (IR(3 DOWNTO 0) = "0011") THEN  -- A i:
					  raddress <= STD_LOGIC_VECTOR(unsigned(PC) + 1);

				 ELSIF (IR(3 DOWNTO 0) = "0100") THEN  -- B A: 
					  waddress <= RA;
					  data_in <= RB;
					  write1 <= '1';

				 ELSIF (IR(3 DOWNTO 0) = "0101") THEN  -- B B: 
					  waddress <= RB;
					  data_in <= RB;
					  write1 <= '1';

				 ELSIF (IR(3 DOWNTO 0) = "0110") THEN  -- B R:
					  waddress <= RR;
					  data_in <= RB;
					  write1 <= '1';

				 ELSIF (IR(3 DOWNTO 0) = "0111") THEN  -- B i:
					  raddress <= STD_LOGIC_VECTOR(unsigned(PC) + 1);

				 ELSIF (IR(3 DOWNTO 0) = "1000") THEN  -- R A:
					  waddress <= RA;
					  data_in <= RR;
					  write1 <= '1';

				 ELSIF (IR(3 DOWNTO 0) = "1001") THEN  -- R B:
					  waddress <= RB;
					  data_in <= RR;
					  write1 <= '1';

				 ELSIF (IR(3 DOWNTO 0) = "1010") THEN  -- R R:
					  waddress <= RR;
					  data_in <= RR;
					  write1 <= '1';

				 ELSIF (IR(3 DOWNTO 0) = "1011") THEN  -- R i:
					  raddress <= STD_LOGIC_VECTOR(unsigned(PC) + 1);

				 END IF;

				 state := exec;

			END IF;

			

--========================================================================
-- MOV
--========================================================================            
			IF (IR(7 DOWNTO 4) = MOV) THEN

				 IF (IR(3 DOWNTO 0) = "0001") THEN  -- A B: Move o valor de RB para RA
					  RA <= RB;

				 ELSIF (IR(3 DOWNTO 0) = "0010") THEN  -- A R: Move o valor de RR para RA
					  RA <= RR;

				 ELSIF (IR(3 DOWNTO 0) = "0100") THEN  -- B A: Move o valor de RA para RB
					  RB <= RA;

				 ELSIF (IR(3 DOWNTO 0) = "0110") THEN  -- B R: Move o valor de RR para RB
					  RB <= RR;

				 ELSIF (IR(3 DOWNTO 0) = "1000") THEN  -- R A: Move o valor de RA para RR
					  RR <= RA;

				 ELSIF (IR(3 DOWNTO 0) = "1001") THEN  -- R B: Move o valor de RB para RR
					  RR <= RB;

				 END IF;
					state := fetch;
			END IF;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX		

					
							
		
								
							
								

--************************************************************************
-- EXECUTE STATE
--************************************************************************								
					
			when exec =>

--========================================================================
-- EXEC ADD ou SUB ou AND ou OR ou CMP
--========================================================================			
			IF (IR(7 DOWNTO 4) = ADD OR (IR(7 DOWNTO 4) = "0001") OR (IR(7 DOWNTO 4) = "0010") OR 
				 (IR(7 DOWNTO 4) = "0011") OR (IR(7 DOWNTO 4) = "0101")) THEN

				 IF (IR(3 DOWNTO 0) = "0011") THEN  -- A i
					  Y <= data_out;
					  INIT_ULA <= '1';
					  
				 ELSIF (IR(3 DOWNTO 0) = "0111") THEN  -- B i
					  Y <= data_out;
					  INIT_ULA <= '1';
					  
				 ELSIF (IR(3 DOWNTO 0) = "1100") THEN  -- i A
					  X <= data_out;
					  INIT_ULA <= '1';
					  
				 ELSIF (IR(3 DOWNTO 0) = "1101") THEN  -- i B
					  X <= data_out;
					  INIT_ULA <= '1';
					  
				 ELSIF (IR(3 DOWNTO 0) = "1110") THEN  -- i R
					  Y <= data_out;
					  INIT_ULA <= '1';
					  
				 ELSIF (IR(3 DOWNTO 0) = "1011") THEN  -- R i
					  Y <= data_out;
					  INIT_ULA <= '1';
					  
				 END IF;

				 state := fetch;

			END IF;

--========================================================================
-- JMP
--========================================================================		
			IF(IR(7 DOWNTO 4) = JMP) THEN
				PC <= data_out;
				state := fetch;
			END IF;

--========================================================================
-- JEQ
--========================================================================			
			IF(IR(7 DOWNTO 4) = JEQ) THEN
				IF(FRzero = '1') THEN
					PC <= data_out;
				END IF;
				state := fetch;
			END IF;
			
--========================================================================
-- JGR
--========================================================================			
			IF(IR(7 DOWNTO 4) = JGR) THEN
				IF(FRzero = '0' and FRmaior ='1') THEN
					PC <= data_out;
				END IF;
				state := fetch;
			END IF;
			
--========================================================================
-- LOAD
--========================================================================            
			IF (IR(7 DOWNTO 4) = LOAD) THEN

				 IF (IR(3 DOWNTO 0) = "0000") THEN  -- A A: Carrega para o registrador RA o conteúdo do endereço em RA
					  RA <= data_out;

				 ELSIF (IR(3 DOWNTO 0) = "0001") THEN  -- A B: Carrega para o registrador RA o conteúdo do endereço em RB
					  RA <= data_out;

				 ELSIF (IR(3 DOWNTO 0) = "0011") THEN  -- A i: Carrega para o registrador RA o valor imediato
					  RA <= data_out;

				 ELSIF (IR(3 DOWNTO 0) = "0010") THEN  -- A R: Carrega para o registrador RA o conteúdo do endereço em RR
					  RA <= data_out;

				 ELSIF (IR(3 DOWNTO 0) = "0100") THEN  -- B A: Carrega para o registrador RB o conteúdo do endereço em RA
					  RB <= data_out;

				 ELSIF (IR(3 DOWNTO 0) = "0101") THEN  -- B B: Carrega para o registrador RB o conteúdo do endereço em RB
					  RB <= data_out;

				 ELSIF (IR(3 DOWNTO 0) = "0111") THEN  -- B i: Carrega para o registrador RB o valor imediato
					  RB <= data_out;

				 ELSIF (IR(3 DOWNTO 0) = "0110") THEN  -- B R: Carrega para o registrador RB o conteúdo do endereço em RR
					  RB <= data_out;

				 ELSIF (IR(3 DOWNTO 0) = "1000") THEN  -- R A: Carrega para o registrador RR o conteúdo do endereço em RA
					  RR <= data_out;

				 ELSIF (IR(3 DOWNTO 0) = "1001") THEN  -- R B: Carrega para o registrador RR o conteúdo do endereço em RB
					  RR <= data_out;

				 ELSIF (IR(3 DOWNTO 0) = "1011") THEN  -- R i: Carrega para o registrador RR o valor imediato
					  RR <= data_out;

				 ELSIF (IR(3 DOWNTO 0) = "1010") THEN  -- R R: Carrega para o registrador RR o conteúdo do endereço em RR
					  RR <= data_out;

				 END IF;
				 state := exec2;
			END IF;
		
--========================================================================
-- STORE
--========================================================================            
			IF (IR(7 DOWNTO 4) = STORE) THEN
				 

				 IF (IR(3 DOWNTO 0) = "0011") THEN  -- A i:
					  waddress <= data_out;
					  data_in <= RA;
					  write1 <= '1';

				 ELSIF (IR(3 DOWNTO 0) = "0111") THEN  -- B i:
					  waddress <= data_out;
					  data_in <= RB;
					  write1 <= '1';

				 ELSIF (IR(3 DOWNTO 0) = "1011") THEN  -- R i:
					  waddress <= data_out;
					  data_in <= RR;
					  write1 <= '1';

				 END IF;
				state := exec2;
			END IF;
			
-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
			
		
	


	
--************************************************************************
-- EXECUTE2 STATE
--************************************************************************								
					
			when exec2 =>			
--========================================================================
-- LOAD
--========================================================================            
			IF (IR(7 DOWNTO 4) = LOAD) THEN
				  
				 IF (IR(3 DOWNTO 0) = "0011") THEN  -- A i: Carrega para o registrador RA o valor do endereço imediato
					  RA <= data_out;

				 ELSIF (IR(3 DOWNTO 0) = "0111") THEN  -- B i: Carrega para o registrador RB o valor do endereço imediato
					  RB <= data_out;

				 ELSIF (IR(3 DOWNTO 0) = "1011") THEN  -- R i: Carrega para o registrador RR o valor do endereço imediato
					  RR <= data_out;

				 END IF;
				state := fetch;
			END IF;

--========================================================================
-- STORE
--========================================================================            
			IF (IR(7 DOWNTO 4) = STORE) THEN
				write1 <= '0';
				state := fetch;
			END IF;
			
-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX



	
	
--************************************************************************
-- ULA 
--************************************************************************
		PROCESS (X, Y, reset)
			
			VARIABLE AUX : STD_LOGIC_VECTOR(7 downto 0);
			VARIABLE RESULT15 : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
			
		BEGIN

			FRover <= '0';

--========================================================================
-- ARITH 
--========================================================================
			IF(INIT_ULA = '1') THEN
				IF(IR(7 DOWNTO 4) = ADD) THEN
					-- Usando signed para permitir operações com números negativos
					AUX <= STD_LOGIC_VECTOR(signed(X) + signed(Y));  
					RESULT15 <= STD_LOGIC_VECTOR(signed(X) + signed(Y)); 

					-- Verificação de overflow usando comparação
					if (signed(RESULT15) > signed("0000 0000 0111 1111")) THEN  -- Limite máximo
						FRover <= '1';  -- Overflow: resultado maior que o maior valor positivo
					elsif (signed(RESULT15) < signed("1111 1111 1000 0000")) THEN  -- Limite mínimo
						FRover <= '1';  -- Overflow: resultado menor que o maior valor negativo
					else
						FRover <= '0';  -- Sem overflow
					end if;
					
					RR <= AUX;
					
				ELSIF(IR(7 DOWNTO 4) = SUB) THEN
					-- Usando signed para permitir operações com números negativos
					AUX <= STD_LOGIC_VECTOR(signed(X) - signed(Y));  
					RESULT15 <= STD_LOGIC_VECTOR(signed(X) - signed(Y)); 

					-- Verificação de overflow usando comparação
					if (signed(RESULT15) > signed("0000 0000 0111 1111")) THEN  -- Limite máximo
						FRover <= '1';  -- Overflow: resultado maior que o maior valor positivo
					elsif (signed(RESULT15) < signed("1111 1111 1000 0000")) THEN  -- Limite mínimo
						FRover <= '1';  -- Overflow: resultado menor que o maior valor negativo
					else
						FRover <= '0';  -- Sem overflow
					end if;
					
					RR <= AUX;
					
				ELSIF(IR(7 DOWNTO 4) = AND1) THEN
				
					RR <= X AND Y;
					
				ELSIF(IR(7 DOWNTO 4) = OR1) THEN
				
					RR <= X OR Y;
				
				ELSIF(IR(7 DOWNTO 4) = NOT1) THEN
				
					RR <= NOT X;
				
				ELSIF(IR(7 DOWNTO 4) = CMP) THEN
					-- Usando signed para permitir operações com números negativos
					AUX <= STD_LOGIC_VECTOR(signed(X) - signed(Y));  
					RESULT15 <= STD_LOGIC_VECTOR(signed(X) - signed(Y)); 

					-- Verificação de overflow usando comparação
					if (signed(RESULT15) > signed("0000 0000 0111 1111")) THEN  -- Limite máximo
						FRover <= '1';  -- Overflow: resultado maior que o maior valor positivo
					elsif (signed(RESULT15) < signed("1111 1111 1000 0000")) THEN  -- Limite mínimo
						FRover <= '1';  -- Overflow: resultado menor que o maior valor negativo
					else
						FRover <= '0';  -- Sem overflow
					end if;
					
					if (AUX = "00000000") then
						FRzero <= '1';
						FRmaior <= '0';
					elsif signed(AUX) > 0 then
						FRzero <= '0';
						FRmaior <= '1';
					else
						FRzero <= '0';
						FRmaior <= '0';
					end if;
					
				END IF;
				INIT_ULA <= '0';
			END IF;
END PROCESS;


end main;