----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2024 12:09:25 AM
-- Design Name: 
-- Module Name: DipSwitches - Behavioral
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

entity DipSwitches is
    Port ( 
        DP_MemoryData_I : in STD_LOGIC_VECTOR (15 downto 0);
        DP_Switches_I : in STD_LOGIC_VECTOR (15 downto 0);
        DP_SwitchesEn_I : in STD_LOGIC;
        DP_Switches_O : out STD_LOGIC_VECTOR (15 downto 0)
        );
end DipSwitches;

architecture Behavioral of DipSwitches is

begin
    with DP_SwitchesEn_I select
    DP_Switches_O   <=  DP_Switches_I when '1',
                        DP_MemoryData_I when '0';      

end Behavioral;
