----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2024 07:04:05 PM
-- Design Name: 
-- Module Name: MemoryWriteSelect - Behavioral
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

entity MemoryWriteSelect is
    Port ( 
        MEM_MEMadr_I : in STD_LOGIC_VECTOR(16 downto 0);
        MEM_MEMopr_I : in STD_LOGIC_VECTOR(1 downto 0);
        MEM_RAMenA_O : out STD_LOGIC;
        MEM_RAMweA_O : out STD_LOGIC_VECTOR(0 downto 0);
        MEM_LEDen_O : out STD_LOGIC;
        MEM_CNSLen_O : out STD_LOGIC;
        MEM_DIPen_O : out STD_LOGIC
    );
end MemoryWriteSelect;

architecture Behavioral of MemoryWriteSelect is

begin
process(MEM_MEMadr_I,MEM_MEMopr_I)
    begin
    
    if (MEM_MEMadr_I(15 downto 11))="00001" then--(not(MEM_MEMadr_I(15 downto 11) and "11110")="00000") then--)
        MEM_RAMenA_O <= MEM_MEMopr_I(1);
        MEM_RAMweA_O <= MEM_MEMopr_I(0 downto 0);
        MEM_LEDen_O <= '0';
        MEM_CNSLen_O <= '0';
        MEM_DIPen_O  <= '0';
    elsif(MEM_MEMadr_I(15 downto 9)="1111110") then --Display
        MEM_RAMenA_O <= '0';
        MEM_RAMweA_O <= "0";
        MEM_LEDen_O <= '0';
        MEM_CNSLen_O <= '1';
        MEM_DIPen_O  <= '0';
    elsif(MEM_MEMadr_I(15 downto 0)="1111111111110010") then--SEVEN SEGMENT
        MEM_RAMenA_O <= '0';
        MEM_RAMweA_O <= "0";
        MEM_LEDen_O <= '1';
        MEM_CNSLen_O <= '0';
        MEM_DIPen_O  <= '0';
    elsif(MEM_MEMadr_I(15 downto 0)="1111111111110000") then--Dip switches
        MEM_RAMenA_O <= '0';
        MEM_RAMweA_O <= "0";
        MEM_LEDen_O <= '0';
        MEM_CNSLen_O <= '0';
        MEM_DIPen_O  <= '1';
    else
        MEM_RAMenA_O <= '0';
        MEM_RAMweA_O <= "0";
        MEM_LEDen_O <= '0';
        MEM_CNSLen_O <= '0';
        MEM_DIPen_O  <= '0';     
    end if;
    
    end process;    
end Behavioral;
