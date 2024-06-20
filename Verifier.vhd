----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2024 05:02:05 PM
-- Design Name: 
-- Module Name: Verifier - Behavioral
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

entity Verifier is
    Port ( 
        VER_PCip1_I : in STD_LOGIC_VECTOR(15 downto 0);
        VER_BrAddr_I : in STD_LOGIC_VECTOR(15 downto 0);
        VER_Opcode_I : in STD_LOGIC_VECTOR(6 downto 0);
        VER_OverrideEn_I : in STD_LOGIC;
        VER_SRZ_I : in STD_LOGIC;
        VER_SRN_I : in STD_LOGIC;
        VER_SRV_I : in STD_LOGIC;
        VER_CorrectAddr_O : out STD_LOGIC_VECTOR(15 downto 0);
        VER_CorrectEn_O : out STD_LOGIC);
end Verifier;

architecture Behavioral of Verifier is
signal TakenTrue : std_logic;

begin

    -- check appropriate status bits based on opcode to determine whether the branch should be taken or not
process (VER_SRZ_I, VER_SRN_I, VER_SRV_I, VER_Opcode_I)
begin
    case VER_Opcode_I is 
    when "1000000"|"1000011"|"1000110"|"1000111" =>
        -- unconditional (64, 67, 70, 71)
        TakenTrue <= '1';

    when "1000010"|"1000101" =>
        -- zero (66, 69)
        TakenTrue <= VER_SRZ_I;

    when "1000001"|"1000100" =>
        -- negative (65, 68)
        TakenTrue <= VER_SRN_I;

    when "1001000"|"1001001" =>
        -- overflow (72, 73)
        TakenTrue <= VER_SRV_I;

    when others =>
        -- do nothing (output zeros)
        TakenTrue <= '0';
    end case;
end process;

    -- determine whether initial assumption needs correcting or not
    VER_CorrectEn_O <= TakenTrue XOR VER_OverrideEn_I;

    -- determine address for prediction correction
    with TakenTrue select
        VER_CorrectAddr_O   <= 
            VER_BrAddr_I     when '1', 
            VER_PCip1_I      when others;
    
end Behavioral;
