library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity palavra04 is
    Port (
        enable : in STD_LOGIC;   -- Sinal de habilitação
        clock  : in STD_LOGIC;   -- Clock de 50 MHz
        reset  : in STD_LOGIC;   -- Reset síncrono
        Q0 : out STD_LOGIC;
        Q1 : out STD_LOGIC;
        Q2 : out STD_LOGIC;
        Q3 : out STD_LOGIC;
        Q4 : out STD_LOGIC;
        Q5 : out STD_LOGIC;
        Q6 : out STD_LOGIC;
        Q7 : out STD_LOGIC;
        Q8 : out STD_LOGIC;
        Q9 : out STD_LOGIC;
        Q10 : out STD_LOGIC;
        Q11 : out STD_LOGIC;
        Q12 : out STD_LOGIC;
        Q13 : out STD_LOGIC;
        Q14 : out STD_LOGIC;
        Q15 : out STD_LOGIC
    );
end palavra04;

architecture Behavioral of palavra04 is
    signal ff: STD_LOGIC_VECTOR(15 downto 0);        -- Flip-flops
    signal contador_interno : unsigned(25 downto 0); -- Contador para controlar o tempo
begin

    process(clock, reset)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                -- Inicializa o contador e os flip-flops
                contador_interno <= (others => '0');
                ff <= "1111110111100000"; -- Valores iniciais dos flip-flops
            elsif enable = '1' then
                -- Conta até 50.000.000 ciclos para obter 1 segundo (50 MHz clock)
                if contador_interno = 50000000 then
                    contador_interno <= (others => '0');
                    -- Realiza o shift circular entre os flip-flops
                    ff(15 downto 12) <= ff(11 downto 8); 
                    ff(11 downto 8)  <= ff(7 downto 4);
                    ff(7 downto 4)   <= ff(3 downto 0);
                    ff(3 downto 0)   <= ff(15 downto 12);
                else
                    contador_interno <= contador_interno + 1;
                end if;
            end if;
        end if;
    end process;

    -- Atribuir o valor dos flip-flops à saída
    Q0  <= ff(0);
    Q1  <= ff(1);
    Q2  <= ff(2);
    Q3  <= ff(3);
    Q4  <= ff(4);
    Q5  <= ff(5);
    Q6  <= ff(6);
    Q7  <= ff(7);
    Q8  <= ff(8);
    Q9  <= ff(9);
    Q10 <= ff(10);
    Q11 <= ff(11);
    Q12 <= ff(12);
    Q13 <= ff(13);
    Q14 <= ff(14);
    Q15 <= ff(15);

end Behavioral;
