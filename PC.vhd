----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2024 11:11:32 AM
-- Design Name: 
-- Module Name: PC - Behavioral
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

use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
    Port ( 
           IF_OverrideEn_I : in STD_LOGIC;
           IF_PointerOverride_I : in STD_LOGIC_VECTOR(15 downto 0);
           IF_Pointer_O : out STD_LOGIC_VECTOR(15 downto 0);
           IF_CLK_I,IF_RST_I : in STD_LOGIC);
end PC;

architecture Behavioral of PC is

signal Pointer: STD_LOGIC_VECTOR(15 downto 0);

begin

process(IF_CLK_I)
    begin
        if(IF_CLK_I='1' and IF_CLK_I'event) then
            if (IF_RST_I='1') then
                Pointer <= (15 downto 0 => '0');
            elsif (IF_OverrideEn_I='1') then
                Pointer <= IF_PointerOverride_I;
            else
                Pointer <=  std_logic_vector(unsigned(Pointer)+"0000000000000010");
            end if;
        end if;    
    end process;
IF_Pointer_O <= Pointer;
end Behavioral;
