----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2024 03:15:56 PM
-- Design Name: 
-- Module Name: EXMEM - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EXMEM is
    Port ( 
        EXMEM_ALUresult_I : in STD_LOGIC_VECTOR(16 downto 0);
        EXMEM_RA_I : in STD_LOGIC_VECTOR(2 downto 0);
        EXMEM_MEMadr_I: in STD_LOGIC_VECTOR(16 downto 0);
        EXMEM_MEMopr_I : in STD_LOGIC_VECTOR(1 downto 0);
        EXMEM_WBenable_I : in STD_LOGIC;
        
        EXMEM_ALUresult_O : out STD_LOGIC_VECTOR(16 downto 0);
        EXMEM_RA_O : out STD_LOGIC_VECTOR(2 downto 0);
        EXMEM_MEMopr_O : out STD_LOGIC_VECTOR(1 downto 0);
        EXMEM_WBenable_O : out STD_LOGIC;
        EXMEM_MEMadr_O : out STD_LOGIC_VECTOR(16 downto 0);
        EXMEM_CLR_I : in STD_LOGIC;
        EXMEM_CLK_I,EXMEM_RST_I : in STD_LOGIC);
               
end EXMEM;

architecture Behavioral of EXMEM is

begin

process(EXMEM_CLK_I)
    begin
        if(EXMEM_CLK_I='1' and EXMEM_CLK_I'event) then 
            if((EXMEM_RST_I='1') or (EXMEM_CLR_I='1')) then
                EXMEM_ALUresult_O <= (16 downto 0 => '0');
                EXMEM_WBenable_O<='0';
                EXMEM_RA_O<=(2 downto 0 => '0');
            else
                EXMEM_ALUresult_O <= EXMEM_ALUresult_I;
                EXMEM_RA_O <= EXMEM_RA_I;
                EXMEM_WBenable_O <= EXMEM_WBenable_I;
                EXMEM_MEMadr_O <= EXMEM_MEMadr_I;
                EXMEM_MEMopr_O <= EXMEM_MEMopr_I;
            end if;
        end if;
    end process;

end Behavioral;
