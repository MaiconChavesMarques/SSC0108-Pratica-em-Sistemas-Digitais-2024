library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Entidade principal que instanciará a RAM
entity aula07 is
    port(
        address   : in  std_logic_vector(4 downto 0); -- 5 bits para o endereço
        clock     : in  std_logic;                    -- sinal de clock
        data_in   : in  std_logic_vector(3 downto 0); -- 4 bits de entrada de dados
        write1     : in  std_logic;                    -- sinal de escrita
        data_out  : out std_logic_vector(3 downto 0)  -- 4 bits de saída de dados
    );
end aula07;

architecture behavior of aula07 is

    -- Instanciando o componente ram32x4
    component ram32x4
        port(
            address  : in  std_logic_vector(4 downto 0);
            clock    : in  std_logic;
            data     : in  std_logic_vector(3 downto 0);
            wren     : in  std_logic;
            q        : out std_logic_vector(3 downto 0)
        );
    end component;

begin

    -- Instância da RAM com os sinais conectados
    ram_instance: ram32x4
        port map (
            address  => address,
            clock    => clock,
            data     => data_in,
            wren     => write1,
            q        => data_out
        );

end behavior;
