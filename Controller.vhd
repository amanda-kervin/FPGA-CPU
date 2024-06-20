----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2024 08:38:03 PM
-- Design Name: 
-- Module Name: Controller - Behavioral
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

entity Controller is
    Port ( 
        CTRL_PCip1_I : in STD_LOGIC_VECTOR(15 downto 0);
        CTRL_Opcode_I : in STD_LOGIC_VECTOR(6 downto 0);
        CTRL_DISP_I : in STD_LOGIC_VECTOR(15 downto 0);
        CTRL_DA_I : in STD_LOGIC_VECTOR(16 downto 0);

        CTRL_SRZ_I : in STD_LOGIC;
        CTRL_SRN_I : in STD_LOGIC;
        CTRL_SRV_I : in STD_LOGIC;
        
        CTRL_PointerOverride_O : out STD_LOGIC_VECTOR(15 downto 0);
        CTRL_OverrideEn_O : out STD_LOGIC;
        CTRL_CLRfd_O : out STD_LOGIC;
        CTRL_CLRde_O : out STD_LOGIC;
        CTRL_CLRem_O : out STD_LOGIC;
        
        -----------
        CTRL_Read1_I : in STD_LOGIC_VECTOR(2 downto 0);
        CTRL_Read2_I : in STD_LOGIC_VECTOR(2 downto 0);
        CTRL_ExRA_I : in STD_LOGIC_VECTOR(2 downto 0);
        CTRL_ExWBen_I : in STD_LOGIC;
        CTRL_MemRA_I : in STD_LOGIC_VECTOR(2 downto 0);
        CTRL_MemWBen_I : in STD_LOGIC;
        CTRL_IDmux1sel_I : in STD_LOGIC_VECTOR(1 downto 0);
        CTRL_DR1sel_O : out STD_LOGIC_VECTOR(1 downto 0);
        CTRL_DR2sel_O : out STD_LOGIC_VECTOR(1 downto 0);
        -----------
        
        CTRL_CLK_I : in STD_LOGIC;
        CTRL_RST_I : in STD_LOGIC);
end Controller;


architecture Behavioral of Controller is

----------------------------------------------BRANCH PREDICTION START----------------------------------------------

component BranchPredict is
    Port ( 
        BPD_PCip1_I : in STD_LOGIC_VECTOR(15 downto 0);
        BPD_Opcode_I : in STD_LOGIC_VECTOR(6 downto 0);
        BPD_Disp_I : in STD_LOGIC_VECTOR(15 downto 0);
        BPD_DA_I : in STD_LOGIC_VECTOR(16 downto 0);
        BPD_BranchAddr_O : out STD_LOGIC_VECTOR(15 downto 0);
        BPD_OverrideEn_O : out STD_LOGIC);
end component;

component OverrideMUX is
    Port ( 
        MUX_BranchAddr_I : in STD_LOGIC_VECTOR(15 downto 0);
        MUX_CorrectAddr_I : in STD_LOGIC_VECTOR(15 downto 0);
        MUX_CorrectEn_I : in STD_LOGIC;
        MUX_OverrideEn_I : in STD_LOGIC;
        MUX_PointerOverride_O : out STD_LOGIC_VECTOR(15 downto 0);
        MUX_OverrideEn_O : out STD_LOGIC);
end component;

component ControllerLatch is
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
end component;

component Verifier is
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
end component;
    
    --BPD out
    signal P_BranchAddr_S : STD_LOGIC_VECTOR(15 downto 0);
    signal P_OverrideEn_S : STD_LOGIC;
    
    --latch
    signal V_PCip1_S : STD_LOGIC_VECTOR(15 downto 0);
    signal V_BrAddr_S : STD_LOGIC_VECTOR(15 downto 0);
    signal V_Opcode_S : STD_LOGIC_VECTOR(6 downto 0);
    signal V_OverrideEn_S : STD_LOGIC;
    
    --VER
    signal V_CorrectAddr_S : STD_LOGIC_VECTOR(15 downto 0);
    signal V_CorrectEn_S : STD_LOGIC;
    
----------------------------------------------BRANCH PREDICTION END----------------------------------------------
    
----------------------------------------------FORWARDING UNIT START----------------------------------------------

    component ForwardingUnit is
    Port ( 
        FU_Read1_I : in STD_LOGIC_VECTOR(2 downto 0);
        FU_Read2_I : in STD_LOGIC_VECTOR(2 downto 0);
        FU_ExRA_I : in STD_LOGIC_VECTOR(2 downto 0);
        FU_ExWBen_I : in STD_LOGIC;
        FU_MemRA_I : in STD_LOGIC_VECTOR(2 downto 0);
        FU_MemWBen_I : in STD_LOGIC;
        FU_IDmux1sel_I : in STD_LOGIC_VECTOR(1 downto 0);
        FU_DR1sel_O : out STD_LOGIC_VECTOR(1 downto 0);
        FU_DR2sel_O : out STD_LOGIC_VECTOR(1 downto 0);
        FU_CLK_I,FU_RST_I,FU_CLR_I : in STD_LOGIC);
    end component;
    
    --signal FU_DR1sel_S,FU_DR2sel_S : STD_LOGIC_VECTOR(1 downto 0);
----------------------------------------------FORWARDING UNIT END----------------------------------------------
    
begin

----------------------------------------------BRANCH PREDICTION START----------------------------------------------

    Map_BranchPredict: BranchPredict port map(
        BPD_PCip1_I         => CTRL_PCip1_I,
        BPD_Opcode_I        => CTRL_Opcode_I,
        BPD_Disp_I          => CTRL_DISP_I,
        BPD_DA_I            => CTRL_DA_I,
        BPD_BranchAddr_O    => P_BranchAddr_S,
        BPD_OverrideEn_O    => P_OverrideEn_S
    );
    
    Map_OverrideMUX: OverrideMUX port map(
        MUX_BranchAddr_I        => P_BranchAddr_S,
        MUX_CorrectAddr_I       => V_CorrectAddr_S,
        MUX_CorrectEn_I         => V_CorrectEn_S,
        MUX_OverrideEn_I        => P_OverrideEn_S,
        MUX_PointerOverride_O   => CTRL_PointerOverride_O,
        MUX_OverrideEn_O        => CTRL_OverrideEn_O
    );
    
    Map_ControllerLatch: ControllerLatch port map(
        LAT_PCip1_I         => CTRL_PCip1_I,
        LAT_BrAddr_I        => P_BranchAddr_S,
        LAT_Opcode_I        => CTRL_Opcode_I,
        LAT_OverrideEn_I    => P_OverrideEn_S,
        LAT_CLR_I           => V_CorrectEn_S, -- if correct enable, clear the latchV_Clr_S,
        LAT_CLK_I           => CTRL_CLK_I,
        LAT_RST_I           => CTRL_RST_I,
        LAT_PCip1_O         => V_PCip1_S,
        LAT_BrAddr_O        => V_BrAddr_S,
        LAT_Opcode_O        => V_Opcode_S,
        LAT_OverrideEn_O    => V_OverrideEn_S
    );    
   
    Map_Verifier: Verifier port map(
        VER_PCip1_I         => V_PCip1_S,
        VER_BrAddr_I        => V_BrAddr_S,
        VER_Opcode_I        => V_Opcode_S,
        VER_OverrideEn_I    => V_OverrideEn_S,
        VER_SRZ_I           => CTRL_SRZ_I,
        VER_SRN_I           => CTRL_SRN_I,
        VER_SRV_I           => CTRL_SRV_I,
        VER_CorrectAddr_O   => V_CorrectAddr_S,
        VER_CorrectEn_O     => V_CorrectEn_S
    );
    
CTRL_CLRfd_O <= P_OverrideEn_S or V_CorrectEn_S;
CTRL_CLRde_O <= V_CorrectEn_S;
CTRL_CLRem_O <= '0';--CTRL_CLRem_O <= V_CorrectEn_S;
----------------------------------------------BRANCH PREDICTION END----------------------------------------------

----------------------------------------------FORWARDING UNIT START----------------------------------------------

    Map_ForwardingUnit: ForwardingUnit Port map( 
        FU_Read1_I      => CTRL_Read1_I,
        FU_Read2_I      => CTRL_Read2_I,
        FU_ExRA_I       => CTRL_ExRA_I,
        FU_ExWBen_I     => CTRL_ExWBen_I,
        FU_MemRA_I      => CTRL_MemRA_I,
        FU_MemWBen_I    => CTRL_MemWBen_I,
        FU_IDmux1sel_I  => CTRL_IDmux1sel_I,
        FU_DR1sel_O     => CTRL_DR1sel_O,--FU_DR1sel_S,
        FU_DR2sel_O     => CTRL_DR2sel_O,--FU_DR2sel_S,
        FU_CLK_I        => CTRL_CLK_I,
        FU_RST_I        => CTRL_RST_I,
        FU_CLR_I        => V_CorrectEn_S
    );
    
    --CTRL_DR1sel_O <= FU_DR1sel_S;
    --CTRL_DR2sel_O <= FU_DR2sel_S;
----------------------------------------------FORWARDING UNIT END----------------------------------------------
end Behavioral;
