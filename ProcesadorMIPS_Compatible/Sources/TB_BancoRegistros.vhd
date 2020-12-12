LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity BancoRegistros_TB_vhd IS
END BancoRegistros_TB_vhd;

ARCHITECTURE behavior OF BancoRegistros_TB_vhd IS 

    component  BancoRegistros
        PORT
            ( clk : in STD_LOGIC;
                   reset : in STD_LOGIC;
                   wr : in STD_LOGIC;
                   reg1_rd : in STD_LOGIC_VECTOR(4 downto 0);
                   reg2_rd : in STD_LOGIC_VECTOR(4 downto 0);
                   reg_wr : in STD_LOGIC_VECTOR(4 downto 0);
                   data_wr : in STD_LOGIC_VECTOR(31 downto 0);
                   data1_rd : out STD_LOGIC_VECTOR(31 downto 0);
                   data2_rd : out STD_LOGIC_VECTOR(31 downto 0));
         End COMPONENT;
      --SEÑALES
       signal clk :STD_LOGIC;
       signal reset :STD_LOGIC;
       signal wr : STD_LOGIC;
       signal reg1_rd :STD_LOGIC_VECTOR(4 downto 0);
       signal reg2_rd :STD_LOGIC_VECTOR(4 downto 0);
       signal reg_wr :STD_LOGIC_VECTOR(4 downto 0);
       signal data_wr :STD_LOGIC_VECTOR(31 downto 0);
       signal data1_rd :STD_LOGIC_VECTOR(31 downto 0);
       signal data2_rd :STD_LOGIC_VECTOR(31 downto 0);
       --SEÑALES ADICIONALES
       signal end_sim : boolean := false;
       constant clk_period: time := 10 ns;     
 begin
 UUT:BancoRegistros
    port map(
    clk => clk,
    reset => reset,
    wr => wr ,
    reg1_rd => reg1_rd,
    reg2_rd => reg2_rd,
    reg_wr => reg_wr,
    data_wr => data_wr,
    data1_rd => data1_rd,
    data2_rd => data2_rd
    );
    --CLOCK
    process begin
            while not end_sim loop
                clk <= '0';
                wait for clk_period/2;
                clk <= '1';
                wait for clk_period/2;
            end loop;
            
            wait;
     end process;                  
     --Simulacion
     process
         begin
            report "PRUEBA REGISTRO";
            reset<='1';
            wr<='0';
            wait for clk_period;
            reg1_rd<= '0' & x"3";
            wait for 0.1ns; --PREGUNTAR (Sino no funciona bien el assert)
            assert data1_rd=x"00000000" report "No anda el RESET";
            
            report"PRUEBA ESCRITURA y LECTURA REG 2 (DATA 1)";
            reset<='0';
            wr<= '1';
            reg_wr<= '0' & x"2";
            data_wr<=x"FAFAFA01";
            wait for clk_period;
            reg1_rd<='0' & x"2";
            wait for 0.1ns;
            assert data1_rd = x"FAFAFA01" report "No anda la carga REGISTRO 2 en DATA 1";
            
            report"PRUEBA RESET";
            wr<='0';
            reset<='1';
            wait for clk_period;
            reg2_rd<= '0' & x"2";
            wait for 0.1ns;
            assert data2_rd=x"00000000" report "No anda el RESET en DATA 2";
            
            report "Prueba ESCRITURA y LECTURA REG 10 en DATA 2";
            reset<='0';
            wr<= '1';
            reg_wr<='0'& x"A";
            data_wr<=x"bAbAbA01";
            wait for clk_period;
            reg2_rd<= '0' & x"A";
            wait for 0.1ns;
            assert data2_rd= x"bAbAbA01" report "No anda la carga REGISTRO 10 en DATA 2";
            wait for clk_period;
            assert false report "Simulacion Terminada" severity failure;
      end process;
 END behavior;