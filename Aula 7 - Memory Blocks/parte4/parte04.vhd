library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity parte04 is
    port(
        clock      : in  std_logic;                    -- sinal de clock
        reset      : in  std_logic;                   
        data_in    : in  std_logic_vector(3 downto 0); -- 4 bits de entrada de dados (novo valor a ser escrito)
        rdaddress  : in  std_logic_vector(4 downto 0); -- endereço de leitura de 5 bits
        wraddress  : in  std_logic_vector(4 downto 0); -- endereço de escrita de 5 bits
        write1     : in  std_logic;                    -- sinal de escrita (write enable)
        data_out   : out std_logic_vector(3 downto 0);  -- 4 bits de saída de dados
		  rdata_out  : out std_logic_vector(4 downto 0)  -- 4 bits de saída de dados
    );
end parte04;

architecture behavior of parte04 is

    signal counter          : integer := 0;
    signal display_address  : std_logic_vector(4 downto 0) := (others => '0');
    constant MAX_COUNT      : integer := 50000000;

    -- Instanciando o componente ram32x42
    component ram32x42
        port(
            clock     : in  std_logic;
            data      : in  std_logic_vector(3 downto 0);
            rdaddress : in  std_logic_vector(4 downto 0);
            wraddress : in  std_logic_vector(4 downto 0);
            wren      : in  std_logic;
            q         : out std_logic_vector(3 downto 0)
        );
    end component;

    -- Sinal de saída da RAM
    signal ram_output : std_logic_vector(3 downto 0);

begin

    -- Instância da RAM com os sinais conectados
    ram_instance: ram32x42
        port map (
            clock     => clock,
            data      => data_in,           -- Dados capturados (agora vindo de data_in)
            rdaddress => display_address,         -- Endereço de exibição do contador
            wraddress => wraddress,        -- Endereço capturado no botão
            wren      => write1,          -- Controle de escrita
            q         => ram_output               -- Saída da RAM
        );



    -- Processo que percorre os endereços de exibição e exibe por 1 segundo cada
    process(clock, reset)
	 
	 variable state : STATES;
	 
    begin
        if reset = '0' then
            -- Resetar o contador e o endereço a ser exibido
            counter <= 0;
            display_address <= (others => '0');
        elsif rising_edge(clock) then
            if counter = MAX_COUNT then
                -- Quando o contador atingir 50 milhões (1 segundo)
                counter <= 0;
                if display_address = "11111" then
                    -- Se já passou pelos 32 endereços, reinicia
                    display_address <= (others => '0');
                else
                    -- Incrementa o endereço
                    display_address <= display_address + 1;
                end if;
            else
                -- Incrementa o contador a cada ciclo de clock
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Saída dos dados: sempre o conteúdo lido da RAM baseado no display_address
    data_out <= ram_output;
	 rdata_out <= display_address;

end behavior;
