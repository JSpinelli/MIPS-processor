library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_SIGNED.all;
use ieee.numeric_std.all;

--COSAS PARA HACER
--Implementar Flush de JUMP
--Completar instruccion LUI VERIFICAR
--Agregar algun componente Extra
--EL NOP Va todo en x?
--VERIFICAR QUE SE EJECUTEN BIEN LAS ULTIMAS 6 Instrucciones

entity processor is
port(
	Clk         : in  std_logic;
	Reset       : in  std_logic;
	-- Instruction memory
	I_Addr      : out std_logic_vector(31 downto 0);
	I_RdStb     : out std_logic;
	I_WrStb     : out std_logic;
	I_DataOut   : out std_logic_vector(31 downto 0);
	I_DataIn    : in  std_logic_vector(31 downto 0);
	-- Data memory
	D_Addr      : out std_logic_vector(31 downto 0);
	D_RdStb     : out std_logic;
	D_WrStb     : out std_logic;
	D_DataOut   : out std_logic_vector(31 downto 0);
	D_DataIn    : in  std_logic_vector(31 downto 0)
);
end processor;



architecture processor_arq of processor is 


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
         End component;

--Entre Secciones
signal Pc_Jump:std_logic_Vector(31 downto 0);
signal Cond_Jump:Std_logic;

--Auxiliares
signal z:std_logic_vector(31 downto 0);

--Seccion IF
signal Pc_In: std_logic_vector(31 downto 0);
signal Pc_Out:std_logic_vector(31 downto 0);
signal Pc_Mas_4:std_logic_vector(31 downto 0);

--Seccion IF/ID
signal Reg_IF_ID_Out:std_logic_vector (31 downto 0);
signal Reg_IF_ID_Pc_out:std_logic_vector(31 downto 0);

--Seccion ID
signal Dato_Extended:std_logic_vector(31 downto 0);
signal Dato1_BR:std_logic_vector(31 downto 0);
signal Dato2_BR:std_logic_vector(31 downto 0);
signal Control_Reg_Dest:std_logic;
signal Control_FuenteAlu:std_logic;
signal Control_MemReg:std_logic;
signal Control_EscrReg:std_logic;
signal Control_LeerMem:std_logic;
signal Control_EscrMem:std_logic;
signal Control_SaltoCond:std_logic;
signal Control_CodAlu:std_logic_vector(1 downto 0);

--Seccion ID/EX
signal Reg_ID_EX_Int_20_16:std_logic_vector(4 downto 0);
signal Reg_ID_EX_Int_15_11:std_logic_vector(4 downto 0);
signal Reg_ID_EX_Dato_Extended:std_logic_vector(31 downto 0);
signal Reg_ID_EX_Data1:std_logic_vector(31 downto 0);
signal Reg_ID_EX_Data2:std_logic_vector(31 downto 0);
signal Reg_ID_EX_PC:std_logic_vector(31 downto 0);
signal Reg_ID_EX_Control_Reg_Dest:std_logic;
signal Reg_ID_EX_Control_FuenteAlu:std_logic;
signal Reg_ID_EX_Control_MemReg:std_logic;
signal Reg_ID_EX_Control_EscrReg:std_logic;
signal Reg_ID_EX_Control_LeerMem:std_logic;
signal Reg_ID_EX_Control_EscrMem:std_logic;
signal Reg_ID_EX_Control_SaltoCond:std_logic;
signal Reg_ID_EX_Control_CodAlu:std_logic_vector(1 downto 0);

--Seccion EX
signal ALU_Control_Out:std_logic_vector(3 downto 0);
signal Registro_Destino:std_logic_vector(4 downto 0);
signal ALU_Data_1:std_logic_vector(31 downto 0);
signal ALU_Data_2:std_logic_vector(31 downto 0);
signal Jump_Direccion:std_logic_vector(31 downto 0);
signal Dato_Extended_Shift:std_logic_vector(31 downto 0);
signal ALU_Result:std_logic_vector(31 downto 0);
signal Flag_Zero:std_logic;
signal Control_Shift:std_logic;

--Seccion EX/MEM
signal Reg_EX_MEM_MemReg:std_logic;
signal Reg_EX_MEM_Control_EscrReg:std_logic;
signal Reg_EX_MEM_Control_LeerMem:std_logic;
signal Reg_EX_MEM_Control_EscrMem:std_logic;
signal Reg_EX_MEM_Control_SaltoCond:std_logic;
signal Reg_EX_MEM_Registro_Destino:std_logic_vector(4 downto 0);
signal Reg_EX_MEM_Write_Data:std_logic_vector(31 downto 0);
signal Reg_EX_MEM_ALU_Result:std_logic_vector(31 downto 0);
signal Reg_EX_MEM_Flag_Zero:std_logic;
signal Reg_EX_MEM_Direccion_Jump:std_logic_vector(31 downto 0);
--Seccion MEM

--Seccion MEM/WB
signal Reg_MEM_WB_Read_Data:std_logic_vector(31 downto 0);
signal Reg_MEM_WB_EscrReg:std_logic;
signal Reg_MEM_WB_Registro_Destino:std_logic_vector(4 downto 0);
signal Reg_MEM_WB_Adress:std_logic_vector(31 downto 0);
signal Reg_MEM_WB_MemReg:std_logic;

--Seccion WB
signal Enable_Write_BR:Std_logic;
signal Reg_Destino_WR:std_logic_vector(4 downto 0);
signal Reg_Destino_WR_Dato:std_logic_vector(31 downto 0);

begin 	

--Sección IF

I_Addr<=Pc_Out;
Pc_Mas_4<=Pc_Out+4;
I_RdStb<='1';
I_WrStb<='0';
I_DataOut<=x"00000000";

Pc:process(Clk)
--PROGRAM COUNTER
begin
if (Reset='1') then
    Pc_Out<=x"00000000";
    else
    if (rising_edge(clk)) then
        Pc_out<=Pc_In;
        end if;
    end if;
end process Pc;

Mux_PC:process(Cond_Jump,Pc_Mas_4,Pc_Jump)
--SELECCION ENTRE LA DIRECCION DE JUMP Y LA ACTUAL
begin
if (Cond_Jump='0') then
    Pc_In<=Pc_Mas_4;
    else
    Pc_In<=Pc_Jump;
end if;
end process Mux_PC;

Reg_IF_ID:process(Clk,Reset)
--REGISTRO DE SEGMENTACION ENTRE ETAPA IF Y ID
begin
if (Reset='1') then
    Reg_IF_ID_Out<=x"00000000";
    Reg_IF_ID_PC_out<=x"00000000";
    else
    if (rising_edge(clk)) then
         Reg_IF_ID_Out<=I_DataIn;
        Reg_IF_ID_Pc_out<=PC_Mas_4;
        end if;
    end if;
end process Reg_IF_ID;

--Seccion ID

BR:BancoRegistros
    port map(
    clk => Clk,
    reset => Reset,
    wr =>Enable_Write_BR,
    reg1_rd =>Reg_IF_ID_Out(25 downto 21),
    reg2_rd =>Reg_IF_ID_Out(20 downto 16),
    reg_wr => Reg_Destino_WR,
    data_wr => Reg_Destino_WR_Dato,
    data1_rd => Dato1_BR,
    data2_rd => Dato2_BR
    );
   
Reg_ID_EX:process(Clk,Reset)
--REGISTRO DE SEGMENTACION ENTRE SECCION ID Y EX
    begin
    if (Reset='1') then
        Reg_ID_EX_Int_20_16<="00000";
        Reg_ID_EX_Int_15_11<="00000";
        Reg_ID_EX_Dato_Extended<=x"00000000";
        Reg_ID_EX_Data1<=x"00000000";
        Reg_ID_EX_Data2<=x"00000000";
        Reg_ID_EX_PC<=x"00000000";
        Reg_ID_EX_Control_Reg_Dest<='0';
        Reg_ID_EX_Control_FuenteAlu<='0';
        Reg_ID_EX_Control_MemReg<='0';
        Reg_ID_EX_Control_EscrReg<='0';
        Reg_ID_EX_Control_LeerMem<='0';
        Reg_ID_EX_Control_EscrMem<='0';
        Reg_ID_EX_Control_SaltoCond<='0';
        Reg_ID_EX_Control_CodAlu<="00";
        else
        if (rising_edge(clk)) then
            Reg_ID_EX_Int_20_16<=Reg_IF_ID_Out(20 downto 16);
            Reg_ID_EX_Int_15_11<=Reg_IF_ID_Out(15 downto 11);
            Reg_ID_EX_Dato_Extended<=Dato_Extended;
            Reg_ID_EX_Data1<=Dato1_BR;
            Reg_ID_EX_Data2<=Dato2_BR;
            Reg_ID_EX_PC<=Reg_IF_ID_PC_out;
            Reg_ID_EX_Control_Reg_Dest<= Control_Reg_Dest;
            Reg_ID_EX_Control_FuenteAlu<=Control_FuenteAlu;
            Reg_ID_EX_Control_MemReg<=Control_MemReg;
            Reg_ID_EX_Control_EscrReg<=Control_EscrReg;
            Reg_ID_EX_Control_LeerMem<=Control_LeerMem;
            Reg_ID_EX_Control_EscrMem<=Control_EscrMem;
            Reg_ID_EX_Control_SaltoCond<=Control_SaltoCond;
            Reg_ID_EX_Control_CodAlu<=Control_CodAlu;
            end if;
        end if;
end process Reg_ID_EX;

ID_Control:process(Reg_IF_ID_Out)
--DISPOSITIVO QUE DECODIFICA LAS SEÑALES DE CONTROL DEPENDIENDO DE LA INSTRUCCION
begin
case Reg_IF_ID_Out(31 downto 26) is
        when "000000"=>     --Tipo R
            Control_Reg_Dest<='1';
            Control_FuenteAlu<='0';
            Control_MemReg<='0';
            Control_EscrReg<='1';
            Control_LeerMem<='0';
            Control_EscrMem<='0';
            Control_SaltoCond<='0';
            Control_CodAlu<="10";
        when "100011"=>     --LOAD
            Control_Reg_Dest<='0';
            Control_FuenteAlu<='1';
            Control_MemReg<='1';
            Control_EscrReg<='1';
            Control_LeerMem<='1';
            Control_EscrMem<='0';
            Control_SaltoCond<='0';
            Control_CodAlu<="00";
        when "101011" =>    --STORE
            Control_Reg_Dest<='0';
            Control_FuenteAlu<='1';
            Control_MemReg<='0';
            Control_EscrReg<='0';
            Control_LeerMem<='0';
            Control_EscrMem<='1';
            Control_SaltoCond<='0';
            Control_CodAlu<="00";
        when "001111" =>    --LUI
            Control_Reg_Dest<='0';
            Control_FuenteAlu<='1';
            Control_MemReg<='0';
            Control_EscrReg<='1';
            Control_LeerMem<='0';
            Control_EscrMem<='0';
            Control_SaltoCond<='0';
            Control_CodAlu<="11";
        when "000100" =>    --BEQ
            Control_Reg_Dest<='0';
            Control_FuenteAlu<='0';
            Control_MemReg<='0';
            Control_EscrReg<='0';
            Control_LeerMem<='0';
            Control_EscrMem<='0';
            Control_SaltoCond<='1';
            Control_CodAlu<="01";
        when others=>     --NOP
            Control_Reg_Dest<='0';
            Control_FuenteAlu<='0';
            Control_MemReg<='0';
            Control_EscrReg<='0';
            Control_LeerMem<='0';
            Control_EscrMem<='0';
            Control_SaltoCond<='0';
            Control_CodAlu<="00";
    end case;
end process ID_Control;

ID_Extend_Sign:process(Reg_IF_ID_Out(15 downto 0))
--EXTIENDE EL SIGNO DE LA SECCION OFFSET
begin
--Rellena con 1 si extiende un neg, rellena con 0 si extiende un pos (es complemento a la base)
if (Reg_IF_ID_Out(15)='1') then
    Dato_Extended(31 downto 16)<="1111111111111111";
    Dato_Extended(15 downto 0)<=Reg_IF_ID_Out(15 downto 0);
    else
    Dato_Extended(31 downto 16)<="0000000000000000";
    Dato_Extended(15 downto 0)<=Reg_IF_ID_Out(15 downto 0);
    end if;
end process ID_Extend_Sign;

--Seccion EX

--SUMA DIRECCION JUMP
Dato_Extended_Shift<=Reg_ID_EX_Dato_Extended(29 downto 0) & "00";
Jump_Direccion<=Dato_Extended_Shift + Reg_ID_EX_PC;

Mux_EX_Reg_Dest:process(Reg_ID_EX_Control_Reg_Dest, Reg_ID_EX_Int_20_16, Reg_ID_EX_Int_15_11)
--SELECCIONA EL REGISTRO DESTINO A GUARDAR LA INFORMACION
begin
if Reg_ID_EX_Control_Reg_Dest='1' then
    Registro_Destino<=Reg_ID_EX_Int_15_11;
    else 
    Registro_Destino<=Reg_ID_EX_Int_20_16;
end if;
end process;

Mux_ALU_sourceA:process(Reg_ID_EX_Dato_Extended, Reg_ID_EX_Data1, Control_Shift)
--SELECCIONA LA ENTRADA 1 de la ALU (DEPENDE DE LA INSTRUCCION SRL/SRR)
begin
if Control_Shift='0' then
    ALU_Data_1<=Reg_ID_EX_Data1;
    else
    ALU_Data_1<="000000000000000000000000000" & Reg_ID_EX_Dato_Extended(10 downto 6);
    end if;
end process Mux_ALU_sourceA;

Mux_ALU_sourceB:Process(Reg_ID_EX_Control_FuenteAlu, Reg_ID_EX_Dato_Extended, Reg_ID_EX_Data2)
--SELECCIONA LA ENTRADA 2 DE LA ALU (DEPENDE DE LAS INSTRUCCIONES QUE USAN EL OFFSET)
begin
if Reg_ID_EX_Control_FuenteAlu='0' then
    ALU_Data_2<=Reg_ID_EX_Data2;
    else
    ALU_Data_2<=Reg_ID_EX_Dato_Extended;
    end if;
end process Mux_ALU_sourceB;

ALU_Control:process(Reg_ID_EX_Control_CodAlu, Reg_ID_EX_Dato_Extended)--arreglar señales
--A PARTIR DE LA SEÑAL ALU OP Y LA SECCION DE LAS TIPO R DECIDE SEÑALES DE ALU, SOURCE A y SHIFT_AMOUNT_CALC
begin
case Reg_ID_EX_Control_CodAlu is
    when "10" => --TIPO R
        case Reg_ID_EX_Dato_Extended(5 downto 0) is
        when "100000" => --ADD
        ALU_Control_Out<="1000";
        Control_Shift<='0';
        when "100010"=> --SUB
        ALU_Control_Out<="1010";
        Control_Shift<='0';
        when "100100"=> --AND
        ALU_Control_Out<="0110";
        Control_Shift<='0';
        when "100101"=> --OR
        ALU_Control_Out<="0010";
        Control_Shift<='0';
        when "101010" =>--slt
        ALU_Control_Out<="0100";
        Control_Shift<='0';
        when "000010" =>--Shift Right
        ALU_Control_Out<="1110";
        Control_Shift<='1';
        when "000000"=>--Shift Left
        ALU_Control_Out<="0000";
        Control_Shift<='1';
        when others=>--señales no definidas
        ALU_Control_Out<="0000";
        Control_Shift<='0';
        end case;
    when "00"=> --LOAD/Store
       ALU_Control_Out<="1000"; --SUMA
       Control_Shift<='0';
    when "01"=>--BEQ
       ALU_Control_Out<="1010"; --Resta
       Control_Shift<='0';
    when "11"=> --LUI
       ALU_Control_Out<="1111";
       Control_Shift<='0';
    when others => --señales no definidas
       ALU_Control_Out<="1000";
       Control_Shift<='0';
end case;
end process ALU_Control;

z<=x"00000000";

ALU:process(ALU_Control_Out,AlU_Data_1,ALU_Data_2)
--UNIDAD ARITMETICO LOGICA
begin
    case ALU_Control_Out is
        when "1000" =>--ADD
           ALU_Result<= AlU_Data_1 + ALU_Data_2;
        when "1010" =>--SUB
           ALU_Result<=AlU_Data_1 - ALU_Data_2;
        when "0110" =>--AND
           ALU_Result<=AlU_Data_1 and ALU_Data_2;
        when "0010" =>--OR
           ALU_Result<=AlU_Data_1 or ALU_Data_2;
        when "0100" =>--slt
            if AlU_Data_1 < ALU_Data_2 then
                ALU_Result<=x"ffffffff";
                else
                ALU_Result<=x"00000000";
                end if;
        when "1110" => --Shift Right
          ALU_Result<= z(conv_integer(ALU_Data_1)-1 downto 0) & Alu_Data_2(31 downto conv_integer(ALU_Data_1));
        when "0000" => --Shift Left
          ALU_Result<=Alu_Data_2(31-conv_integer(ALU_Data_1) downto 0) & z(conv_integer(ALU_Data_1)-1 downto 0);
        when "1111"=> --LUI
          ALU_Result<=Alu_Data_2(15 downto 0) & x"0000";
        when others =>--señales no definidas
         ALU_Result<=x"00000000";
    end case;

end process ALU;

Set_Flag:process(ALU_Result)
--SETEA EL FLAG DEPENDIENDO DEL RESULTADO
begin
if ALU_Result=x"00000000" then
    Flag_Zero<='1';
    else
    Flag_Zero<='0';
end if;
end process Set_Flag;

Reg_EX_MEM:process(Clk,Reset)
--REGISTRO DE SEGMENTACION ENTRE LA SECCION EX Y MEM
begin
if Reset='1' then
    Reg_EX_MEM_MemReg<='0';
    Reg_EX_MEM_Control_EscrReg<='0';
    Reg_EX_MEM_Control_LeerMem<='0';
    Reg_EX_MEM_Control_EscrMem<='0';
    Reg_EX_MEM_Control_SaltoCond<='0';
    Reg_EX_MEM_Registro_Destino<="00000";
    Reg_EX_MEM_Write_Data<=x"00000000";
    Reg_EX_MEM_ALU_Result<=x"00000000";
    Reg_EX_MEM_Flag_Zero<='0';
    Reg_EX_MEM_Direccion_Jump<=x"00000000";
    else
    if rising_edge(Clk) then
        Reg_EX_MEM_MemReg<=Reg_ID_EX_Control_MemReg;
        Reg_EX_MEM_Control_EscrReg<=Reg_ID_EX_Control_EscrReg;
        Reg_EX_MEM_Control_LeerMem<=Reg_ID_EX_Control_LeerMem;
        Reg_EX_MEM_Control_EscrMem<=Reg_ID_EX_Control_EscrMem;
        Reg_EX_MEM_Control_SaltoCond<=Reg_ID_EX_Control_SaltoCond;
        Reg_EX_MEM_Registro_Destino<=Registro_Destino;
        Reg_EX_MEM_Write_Data<=Reg_ID_EX_Data2;
        Reg_EX_MEM_ALU_Result<=ALU_Result;
        Reg_EX_MEM_Flag_Zero<=Flag_Zero;
        Reg_EX_MEM_Direccion_Jump<=Jump_Direccion;
    end if;
end if;
end process Reg_EX_MEM;

--Seccion MEM

    Pc_Jump<=Reg_EX_MEM_Direccion_Jump;
    Cond_Jump<=Reg_EX_MEM_Flag_Zero and Reg_EX_MEM_Control_SaltoCond;
    D_Addr<=Reg_EX_MEM_ALU_Result;
    D_RdStb<=Reg_EX_MEM_Control_LeerMem;
    D_WrStb<=Reg_EX_MEM_Control_EscrMem;
    D_DataOut<=Reg_EX_MEM_Write_Data;
  
Reg_MEM_WB:process(Clk,Reset)
--REGISTRO DE SEGMENTACION ENTRE SECCION MEM Y WB
begin
if Reset='1' then
    Reg_MEM_WB_Read_Data<=x"00000000";
    Reg_MEM_WB_EscrReg<='0';
    Reg_MEM_WB_Registro_Destino<="00000";
    Reg_MEM_WB_Adress<=x"00000000";
    Reg_MEM_WB_MemReg<='0';
    else
    if rising_edge(Clk) then
        Reg_MEM_WB_Read_Data<=D_DataIn;
        Reg_MEM_WB_EscrReg<=Reg_EX_MEM_Control_EscrReg;
        Reg_MEM_WB_Registro_Destino<=Reg_EX_MEM_Registro_Destino;
        Reg_MEM_WB_Adress<=Reg_EX_MEM_ALU_Result;
        Reg_MEM_WB_MemReg<=Reg_EX_MEM_MemReg;
    end if;
end if;
end process Reg_MEM_WB;

--Seccion WB

Reg_Destino_WR<=Reg_MEM_WB_Registro_Destino;
Enable_Write_BR<=Reg_MEM_WB_EscrReg;

Mux_Select_Reg:process(Reg_MEM_WB_Adress, Reg_MEM_WB_Read_Data ,Reg_MEM_WB_MemReg)
--MULTIPLEXOR QUE SELECCIONA DATOS A ALMACENAR en el Banco de Registros (DE LA ALU O DE LA DATA MEMORY)
begin
if Reg_MEM_WB_MemReg='0' then
    Reg_Destino_WR_Dato<=Reg_MEM_WB_Adress;
    else
    Reg_Destino_WR_Dato<=Reg_MEM_WB_Read_Data;
end if;
end process Mux_Select_Reg;

end processor_arq;
