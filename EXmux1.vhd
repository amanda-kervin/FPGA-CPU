----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2024 03:28:34 PM
-- Design Name: 
-- Module Name: EXmux1 - Behavioral
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

entity EXmux1 is
    Port ( 
        EXM1_DR1_I : in STD_LOGIC_VECTOR( 16 downto 0);   --from IDEX
        EXM1_DR2_I : in STD_LOGIC_VECTOR( 16 downto 0);
        EXM1_MEMdata_I : in STD_LOGIC_VECTOR( 16 downto 0);   --From EXMEM
        EXM1_WBdata_I : in STD_LOGIC_VECTOR( 16 downto 0);   --From MEMWB
        EXM1_DR1sel_I : in STD_LOGIC_VECTOR( 1 downto 0);
        EXM1_DR2sel_I : in STD_LOGIC_VECTOR( 1 downto 0);
        EXM1_DR1_O : out STD_LOGIC_VECTOR( 16 downto 0);
        EXM1_DR2_O : out STD_LOGIC_VECTOR( 16 downto 0));
end EXmux1;

architecture Behavioral of EXmux1 is

begin

process(EXM1_DR1_I,EXM1_DR2_I,EXM1_MEMdata_I,EXM1_WBdata_I,EXM1_DR1sel_I,EXM1_DR2sel_I)
    begin
        case EXM1_DR1sel_I is
            when "01"=>
                EXM1_DR1_O <= EXM1_MEMdata_I;
            when "10"=>
                EXM1_DR1_O <= EXM1_WBdata_I;            
            when others => --when "00"=>
                EXM1_DR1_O <= EXM1_DR1_I;
        end case;
        
        case EXM1_DR2sel_I is
            when "01"=>
                EXM1_DR2_O <= EXM1_MEMdata_I;
            when "10"=>
                EXM1_DR2_O <= EXM1_WBdata_I;            
            when others => --when "00"=>
                EXM1_DR2_O <= EXM1_DR2_I;
        end case;
    end process;    
end Behavioral;
