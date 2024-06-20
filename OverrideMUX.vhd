----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2024 05:02:05 PM
-- Design Name: 
-- Module Name: OverrideMUX - Behavioral
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

entity OverrideMUX is
    Port ( 
        MUX_BranchAddr_I : in STD_LOGIC_VECTOR(15 downto 0);
        MUX_CorrectAddr_I : in STD_LOGIC_VECTOR(15 downto 0);
        MUX_CorrectEn_I : in STD_LOGIC;
        MUX_OverrideEn_I : in STD_LOGIC;
        MUX_PointerOverride_O : out STD_LOGIC_VECTOR(15 downto 0);
        MUX_OverrideEn_O : out STD_LOGIC);
end OverrideMUX;

architecture Behavioral of OverrideMUX is

begin

    with MUX_CorrectEn_I select
        MUX_PointerOverride_O   <= 
            MUX_CorrectAddr_I    when '1',
            MUX_BranchAddr_I     when others;
    
    MUX_OverrideEn_O <= MUX_CorrectEn_I OR MUX_OverrideEn_I;

end Behavioral;
