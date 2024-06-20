----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2024 05:22:34 PM
-- Design Name: 
-- Module Name: ControllerLatch - Behavioral
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

entity ControllerLatch is
    Port ( 
        LAT_PCip1_I : in STD_LOGIC_VECTOR(15 downto 0);
        LAT_BrAddr_I : in STD_LOGIC_VECTOR(15 downto 0);
        LAT_Opcode_I : in STD_LOGIC_VECTOR(6 downto 0);
        LAT_OverrideEn_I : in STD_LOGIC;
        LAT_CLR_I : in STD_LOGIC;
        LAT_CLK_I : in STD_LOGIC;
        LAT_RST_I : in STD_LOGIC;
        LAT_PCip1_O : out STD_LOGIC_VECTOR(15 downto 0);
        LAT_BrAddr_O : out STD_LOGIC_VECTOR(15 downto 0);
        LAT_Opcode_O : out STD_LOGIC_VECTOR(6 downto 0);
        LAT_OverrideEn_O : out STD_LOGIC);
end ControllerLatch;

architecture Behavioral of ControllerLatch is

begin
Process(LAT_CLK_I) is
    begin
        if(LAT_CLK_I='1' and LAT_CLK_I'event) then
            if(LAT_CLR_I='1') then
                LAT_PCip1_O <= (15 downto 0=>'0');
                LAT_BrAddr_O <= (15 downto 0=>'0');
                LAT_Opcode_O <= (6 downto 0=>'0');
                LAT_OverrideEn_O <= '0';
            else
                LAT_PCip1_O <= LAT_PCip1_I;
                LAT_BrAddr_O <= LAT_BrAddr_I;
                LAT_Opcode_O <= LAT_Opcode_I;
                LAT_OverrideEn_O <= LAT_OverrideEn_I;
            end if;
        end if;
    end process;
end Behavioral;
