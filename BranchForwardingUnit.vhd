----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2024 02:44:50 PM
-- Design Name: 
-- Module Name: BranchForwardingUnit - Behavioral
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

entity BranchForwardingUnit is
    Port (
        FU_Read1_I : in STD_LOGIC_VECTOR(2 downto 0); 
        FUB_ExRA_I : in STD_LOGIC_VECTOR(2 downto 0);
        FUB_ExWBen_I : in STD_LOGIC;
        FUB_ExData_I : in STD_LOGIC_VECTOR(16 downto 0);
        FUB_MemRA_I : in STD_LOGIC_VECTOR(2 downto 0);
        FUB_MemWBen_I : in STD_LOGIC;
        FUB_MemData_I : in STD_LOGIC_VECTOR(16 downto 0);
        FUB_Data_O : out STD_LOGIC_VECTOR(16 downto 0);
        FUB_SEL_O : out STD_LOGIC
    );
end BranchForwardingUnit;

architecture Behavioral of BranchForwardingUnit is

begin
process(FU_Read1_I,FUB_ExRA_I,FUB_ExWBen_I,FUB_ExData_I,FUB_MemRA_I,FUB_MemWBen_I,FUB_MemData_I)
    begin
    if ((FU_Read1_I = FUB_ExRA_I) and (FUB_ExWBen_I = '1')) then
        FUB_Data_O<=FUB_ExData_I;
        FUB_SEL_O<='1';
    elsif ((FU_Read1_I = FUB_MemRA_I) and (FUB_MemWBen_I = '1')) then
        FUB_Data_O<=FUB_MemData_I;
        FUB_SEL_O<='1';
    else
        FUB_Data_O<= (16 downto 0 => '0');
        FUB_SEL_O<='0';
    end if;
    
    end process;
end Behavioral;
