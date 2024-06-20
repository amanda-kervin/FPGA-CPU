----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2024 05:15:18 PM
-- Design Name: 
-- Module Name: MemorySelect - Behavioral
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

entity MemorySelect is
    Port ( 
        IF_Pointer_I : in STD_LOGIC_VECTOR(15 downto 0);
        IF_ROMen_O : out STD_LOGIC;
        IF_RAMen_O : out STD_LOGIC
        );
end MemorySelect;

architecture Behavioral of MemorySelect is

begin
process(IF_Pointer_I)
    begin
    case IF_Pointer_I(15 downto 11) is
        when "00001"=>
            IF_ROMen_O <= '0';
            IF_RAMen_O <= '1';
        when "00000"=>
            IF_ROMen_O <= '1';
            IF_RAMen_O <= '0';    
        when others =>
            IF_ROMen_O <= '0';
            IF_RAMen_O <= '0';  
    end case;
    end process;    
end Behavioral;