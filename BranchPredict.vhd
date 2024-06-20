----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2024 05:02:05 PM
-- Design Name: 
-- Module Name: BranchPredict - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BranchPredict is
    Port ( 
        BPD_PCip1_I : in STD_LOGIC_VECTOR(15 downto 0);
        BPD_Opcode_I : in STD_LOGIC_VECTOR(6 downto 0);
        BPD_Disp_I : in STD_LOGIC_VECTOR(15 downto 0);
        BPD_DA_I : in STD_LOGIC_VECTOR(16 downto 0);
        BPD_BranchAddr_O : out STD_LOGIC_VECTOR(15 downto 0);
        BPD_OverrideEn_O : out STD_LOGIC);
end BranchPredict;

architecture Behavioral of BranchPredict is
    signal BranchAddr : STD_LOGIC_VECTOR(15 downto 0);
    signal PCi : STD_LOGIC_VECTOR(15 downto 0);
    signal BranchTrue : STD_LOGIC;

begin

    -- calculate PCi
    PCi <= std_logic_vector(unsigned(BPD_PCip1_I)-"0000000000000010");
    
    -- determine whether a branch is occuring, or some other instruction we don't care about
    with BPD_Opcode_I select
        BranchTrue <=   '1' when "1000000"|"1000001"|"1000010"|"1000011"|"1000100"|"1000101"|"1000110"|"1000111",
                        '0' when others;
    
    -- calculate branch address based on opcode -- for reference: result <= std_logic_vector(shift_left(signed(ex1),to_integer(signed(ex2))));
process (BPD_Opcode_I, PCi, BPD_Disp_I, BPD_DA_I)
begin
    --a<=a
    case(BPD_Opcode_I) is
    when "1000000"|"1000001"|"1000010"|"1001000" =>
        -- B1   PC <= PC + 2*disp.l
        BranchAddr <= std_logic_vector(signed(PCi) + shift_left(signed(BPD_Disp_I),1));
    
    when "1000011"|"1000100"|"1000101"|"1000110"|"1001001" =>
        -- B2   PC <= R[ra]{word aligned} + 2*disp.l
        BranchAddr <= std_logic_vector(signed(BPD_DA_I(15 downto 1)&'0') + shift_left(signed(BPD_Disp_I),1));
    
    when "1000111" =>
        -- RETURN   PC <= R[r7]{word aligned}
        BranchAddr <= BPD_DA_I(15 downto 1)&'0';
           
    when others =>
        -- do nothing (output zeros)
        BranchAddr <= "0000000000000000";
    end case;
end process;
    
    -- determine whether assume branch taken or not taken
process (PCi, BranchAddr, BranchTrue)
begin
    if (unsigned(PCi) > unsigned(BranchAddr)) and (BranchTrue='1') then
        BPD_OverrideEn_O <= '1';
    else
        BPD_OverrideEn_O <= '0';
    end if;
end process;

BPD_BranchAddr_O <= BranchAddr;

end Behavioral;
