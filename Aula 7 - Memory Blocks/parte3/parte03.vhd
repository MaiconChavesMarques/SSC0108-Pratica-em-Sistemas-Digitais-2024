library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity parte03 is
    port(
        address   : in  std_logic_vector(4 downto 0); -- 5 bits para o endereço
        data_in   : in  std_logic_vector(3 downto 0); -- 4 bits para o dado de entrada
        write1     : in  std_logic;                    -- sinal de escrita (write enable)
        clock     : in  std_logic;                    -- sinal de clock
        data_out  : out std_logic_vector(3 downto 0)  -- 4 bits de saída
    );
end parte03;

architecture behavior of parte03 is
    -- Definindo uma memória de 32 palavras (2^5 = 32), cada uma com 4 bits
    type memory_array is array (31 downto 0) of std_logic_vector(3 downto 0);
    signal memory : memory_array := (others => (others => '0')); -- inicializa a memória
begin

    process(clock)
    begin
        if rising_edge(clock) then
            if write1 = '1' then
                -- Escreve o dado de entrada na posição de memória selecionada pelo endereço
                memory(to_integer(unsigned(address))) <= data_in;
            end if;
            -- Sempre lê o dado armazenado na posição de memória selecionada pelo endereço
            data_out <= memory(to_integer(unsigned(address)));
        end if;
    end process;

end behavior;
