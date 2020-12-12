----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.04.2016 12:22:42
-- Design Name: 
-- Module Name: BancoRegistros - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BancoRegistros is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           wr : in STD_LOGIC;
           reg1_rd : in STD_LOGIC_VECTOR(4 downto 0);
           reg2_rd : in STD_LOGIC_VECTOR(4 downto 0);
           reg_wr : in STD_LOGIC_VECTOR(4 downto 0);
           data_wr : in STD_LOGIC_VECTOR(31 downto 0);
           data1_rd : out STD_LOGIC_VECTOR(31 downto 0);
           data2_rd : out STD_LOGIC_VECTOR(31 downto 0));
end BancoRegistros;

architecture Behavioral of BancoRegistros is

type mem_reg is array (0 to 31) of std_logic_vector (31 downto 0);

signal regs: mem_reg;
begin
process (reset,clk,wr,data_wr,reg_wr)
    begin 
        if reset='1' then
        regs <= (others =>(others => '0'));
        else
            if falling_edge(clk) then
                   if wr='1' then
                    regs(conv_integer(reg_wr))<= data_wr;
                    end if;
                    end if;
                   end if;
     end process;
     
process(reg1_rd,regs)
    begin
    if (reg1_rd /= "00000") then
    data1_rd<=regs(conv_integer(reg1_rd));
    else
    data1_rd<=x"00000000";
    end if;
    end process;
    
process(reg2_rd,regs)
    begin
    if (reg2_rd /= "00000") then
    data2_rd<=regs(conv_integer(reg2_rd));
    else
    data2_rd<=x"00000000";
    end if;
    end process;
    
end Behavioral;
