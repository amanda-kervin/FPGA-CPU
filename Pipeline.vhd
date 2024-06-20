----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2024 05:06:58 PM
-- Design Name: 
-- Module Name: Pipeline - Behavioral
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

entity Pipeline is
  Port (
         INport_I : in STD_LOGIC_VECTOR(15 downto 0);
         OUTport_O : out STD_LOGIC_VECTOR(15 downto 0);
         --Pointer_O: out STD_LOGIC_VECTOR(15 downto 0);
         CLK : in STD_LOGIC;
         RST : in STD_LOGIC
  );
end Pipeline;

architecture Behavioral of Pipeline is

component Controller is
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
end component;

component PC is
    Port ( 
           IF_OverrideEn_I : in STD_LOGIC;
           IF_PointerOverride_I : in STD_LOGIC_VECTOR(15 downto 0);
           IF_Pointer_O : out STD_LOGIC_VECTOR(15 downto 0);
           IF_CLK_I,IF_RST_I : in STD_LOGIC);
end component;

component ROM is
Port (
    -- Common module ports
    --sleep : in STD_LOGIC;                             --UNUSED
    
    -- Port A module ports
    clka : in STD_LOGIC;
    rsta : in STD_LOGIC;
    ena  : in STD_LOGIC;                                --UNUSED
    --regcea : in STD_LOGIC;                            --UNUSED
    addra  : in STD_LOGIC_VECTOR(9 downto 0);
    --injectsbiterra : in STD_LOGIC;   --do not change  --UNUSED
    --injectdbiterra : in STD_LOGIC;   --do not change  --UNUSED
    douta  : out STD_LOGIC_VECTOR(15 downto 0)
    --sbiterra : out STD_LOGIC;  --do not change        --UNUSED
    --dbiterra : out STD_LOGIC  --do not change         --UNUSED

);
end component;

component IOPORT is
    Port ( 
           IOPORT_IN_I : in STD_LOGIC_VECTOR (15 downto 0);
           IOPORT_OUT_I : in STD_LOGIC_VECTOR (16 downto 0);
           IOPORT_IN_O : out STD_LOGIC_VECTOR (15 downto 0);
           IOPORT_OUT_O : out STD_LOGIC_VECTOR (15 downto 0);
           IOPORT_OUTen_I : in STD_LOGIC);
end component;

component IFID is
    Port ( 
        IFID_InstrROM_I,IFID_InstrRAM_I : in STD_LOGIC_VECTOR(15 downto 0);
        IFID_InstrSEL_I: in STD_LOGIC;
        IFID_Instr_O : out STD_LOGIC_VECTOR(15 downto 0);
        IFID_INport_I : in STD_LOGIC_VECTOR(15 downto 0);
        IFID_INport_O : out STD_LOGIC_VECTOR(15 downto 0);
        --IFID_PCip1_I : in STD_LOGIC_VECTOR(15 downto 0);
        --IFID_PCip1_O : out STD_LOGIC_VECTOR(15 downto 0);
        IFID_CLR_I,IFID_CLK_I,IFID_RST_I : in STD_LOGIC);
end component;

component Decoder is
    Port ( 
        IDC_Instr_I : in STD_LOGIC_VECTOR(15 downto 0);
        IDC_IXread1_O : out STD_LOGIC_VECTOR(2 downto 0);
        IDC_IXread2_O : out STD_LOGIC_VECTOR(2 downto 0);
        IDC_ALUmode_O : out STD_LOGIC_VECTOR(3 downto 0);
        IDC_DR1sel_O : out STD_LOGIC_VECTOR(1 downto 0);
        IDC_DR2C_O : out STD_LOGIC_VECTOR(16 downto 0);
        IDC_DR2sel_O: out STD_LOGIC;
        IDC_RA_O : out STD_LOGIC_VECTOR(2 downto 0);
        IDC_WBenable_O : out STD_LOGIC;
        IDC_OUTen_O : out STD_LOGIC;
        
        IDC_Opcode_O : out STD_LOGIC_VECTOR(6 downto 0);
        IDC_DISP_O : out STD_LOGIC_VECTOR(15 downto 0);
        IDC_MEMopr_O : out STD_LOGIC_VECTOR(1 downto 0)
    );
end component;

component RegisterFile is
    Port ( 
        IDR_RA_I : in STD_LOGIC_VECTOR(2 downto 0);
        IDR_WBdata_I : in STD_LOGIC_VECTOR(16 downto 0);
        IDR_WBenable_I : in STD_LOGIC;
        IDR_IXread1_I : in STD_LOGIC_VECTOR(2 downto 0);
        IDR_IXread2_I : in STD_LOGIC_VECTOR(2 downto 0);
        IDR_CLK_I : in STD_LOGIC;
        IDR_RST_I : in STD_LOGIC;
        IDR_DR1R_O : out STD_LOGIC_VECTOR(16 downto 0);
        IDR_DR2R_O : out STD_LOGIC_VECTOR(16 downto 0));
end component;


component IDmux1 is
    Port ( 
        IDM1_DR1R_I: in STD_LOGIC_VECTOR(16 downto 0);
        IDM1_INport_I: in STD_LOGIC_VECTOR(15 downto 0);
        IDM1_PCip1_I: in STD_LOGIC_VECTOR(15 downto 0);
        IDM1_DR1sel_I: in STD_LOGIC_VECTOR(1 downto 0);
        
        IDM1_DR1_O: out STD_LOGIC_VECTOR(16 downto 0);
        
        IDM1_DR2R_I: in STD_LOGIC_VECTOR(16 downto 0); 
        IDM1_DR2C_I: in STD_LOGIC_VECTOR(16 downto 0);
        IDM1_DR2sel_I: in STD_LOGIC;
        
        IDM1_MEMopr_I : in STD_LOGIC_VECTOR(1 downto 0);
        IDM1_DR2_O: out STD_LOGIC_VECTOR(16 downto 0);
        IDM1_MEMadr_O: out STD_LOGIC_VECTOR(16 downto 0));
end component;

component IDEX is
    Port ( 
        IDEX_DR1_I: in STD_LOGIC_VECTOR(16 downto 0);
        IDEX_DR2_I: in STD_LOGIC_VECTOR(16 downto 0);
        IDEX_ALUmode_I : in STD_LOGIC_VECTOR(3 downto 0);
        IDEX_MEMadr_I : in STD_LOGIC_VECTOR(16 downto 0);
        IDEX_MEMopr_I : in STD_LOGIC_VECTOR(1 downto 0);
        IDEX_WBenable_I : in STD_LOGIC;
        IDEX_RA_I : in STD_LOGIC_VECTOR(2 downto 0);
        IDEX_DR1_O,IDEX_DR2_O: out STD_LOGIC_VECTOR(16 downto 0);
        IDEX_ALUmode_O : out STD_LOGIC_VECTOR(3 downto 0);
        IDEX_MEMadr_O : out STD_LOGIC_VECTOR(16 downto 0);
        IDEX_MEMopr_O : out STD_LOGIC_VECTOR(1 downto 0);
        IDEX_WBenable_O : out STD_LOGIC;
        IDEX_RA_O : out STD_LOGIC_VECTOR(2 downto 0);
        IDEX_CLR_I,IDEX_CLK_I,IDEX_RST_I : in STD_LOGIC);
end component;

component EXmux1 is
    Port ( 
        EXM1_DR1_I : in STD_LOGIC_VECTOR( 16 downto 0);   --from IDEX
        EXM1_DR2_I : in STD_LOGIC_VECTOR( 16 downto 0);
        EXM1_MEMdata_I : in STD_LOGIC_VECTOR( 16 downto 0);   --From EXMEM
        EXM1_WBdata_I : in STD_LOGIC_VECTOR( 16 downto 0);   --From MEMWB
        EXM1_DR1sel_I : in STD_LOGIC_VECTOR( 1 downto 0);
        EXM1_DR2sel_I : in STD_LOGIC_VECTOR( 1 downto 0);
        EXM1_DR1_O : out STD_LOGIC_VECTOR( 16 downto 0);
        EXM1_DR2_O : out STD_LOGIC_VECTOR( 16 downto 0));
end component;

component ALU is
    Port ( 
        EX_DR1_I : in STD_LOGIC_VECTOR(16 downto 0);
        EX_DR2_I : in STD_LOGIC_VECTOR(16 downto 0);
        EX_ALUmode_I : in STD_LOGIC_VECTOR(3 downto 0);
        EX_ALUresult_O : out STD_LOGIC_VECTOR(16 downto 0);
        EX_Z_O,EX_N_O,EX_V_O : out STD_LOGIC);
end component;

component StatusRegister is
    Port (
        SR_Z_I : in STD_LOGIC; 
        SR_N_I : in STD_LOGIC;
        SR_V_I : in STD_LOGIC;
        SR_Z_O : out STD_LOGIC;
        SR_N_O : out STD_LOGIC;
        SR_V_O : out STD_LOGIC;
        SR_CLK_I,SR_RST_I : in STD_LOGIC);
           
end component;

component EXMEM is
    Port ( 
        EXMEM_ALUresult_I : in STD_LOGIC_VECTOR(16 downto 0);
        EXMEM_RA_I : in STD_LOGIC_VECTOR(2 downto 0);
        EXMEM_MEMadr_I: in STD_LOGIC_VECTOR(16 downto 0);
        EXMEM_MEMopr_I : in STD_LOGIC_VECTOR(1 downto 0);
        EXMEM_WBenable_I : in STD_LOGIC;
        
        EXMEM_ALUresult_O : out STD_LOGIC_VECTOR(16 downto 0);
        EXMEM_RA_O : out STD_LOGIC_VECTOR(2 downto 0);
        EXMEM_MEMopr_O : out STD_LOGIC_VECTOR(1 downto 0);
        EXMEM_WBenable_O : out STD_LOGIC;
        EXMEM_MEMadr_O : out STD_LOGIC_VECTOR(16 downto 0);
        EXMEM_CLR_I : in STD_LOGIC;
        EXMEM_CLK_I,EXMEM_RST_I : in STD_LOGIC);
end component;

component RAM is
    Port (
        -- Port A module ports
        RAM_EnA_I : in STD_LOGIC;                           --ena : in STD_LOGIC; 
        RAM_WenA_I : in STD_LOGIC_VECTOR(0 downto 0);       --wea : in STD_LOGIC_VECTOR(0 downto 0); 
        RAM_AddrA_I : in STD_LOGIC_VECTOR(9 downto 0);      --addra : in STD_LOGIC_VECTOR(9 downto 0);
        RAM_DataA_I : in STD_LOGIC_VECTOR(15 downto 0);     --dina  : in STD_LOGIC_VECTOR(15 downto 0);
        RAM_DataA_O : out STD_LOGIC_VECTOR(15 downto 0);    --douta  : out STD_LOGIC_VECTOR(15 downto 0);
        
        -- Port B module ports
        RAM_EnB : in STD_LOGIC;                             --enb : in STD_LOGIC;
        RAM_AddrB_I : in STD_LOGIC_VECTOR(9 downto 0);      --addrb : in STD_LOGIC_VECTOR(9 downto 0);
        RAM_DataB_O : out STD_LOGIC_VECTOR(15 downto 0);    --doutb  : out STD_LOGIC_VECTOR(15 downto 0);
    
        --USED FOR BOTH PORTS
        RAM_CLK_I: in STD_LOGIC;                            --clk : in STD_LOGIC;
        RAM_RST_I: in STD_LOGIC                            --rst : in STD_LOGIC
    );
end component;

component MEMWB is
    Port ( 
        MEMWB_ALUresult_I : in STD_LOGIC_VECTOR(16 downto 0);
        MEMWB_LOADdata_I : in STD_LOGIC_VECTOR(15 downto 0); -- implement with memory load/store
        MEMWB_RA_I : in STD_LOGIC_VECTOR(2 downto 0);
        MEMWB_WBenable_I : in STD_LOGIC;
        MEMWB_MEMopr_I: in STD_LOGIC_VECTOR(1 downto 0);
        MEMWB_RA_O : out STD_LOGIC_VECTOR(2 downto 0);
        MEMWB_WBdata_O : out STD_LOGIC_VECTOR(16 downto 0);
        MEMWB_WBenable_O : out STD_LOGIC;
        
        MEMWB_CLK_I,MEMWB_RST_I : in STD_LOGIC);
end component;
--Controller
    signal CTRL_CLRfd_S,CTRL_CLRde_S,CTRL_CLRem_S : STD_LOGIC;

--PC
    signal IF_PointerOverride_S, IF_Pointer_S : STD_LOGIC_VECTOR (15 downto 0);
    signal IF_OverrideEn_S : STD_LOGIC;
    
--ROM
    signal InstrROM_S : STD_LOGIC_VECTOR (15 downto 0);
    signal ROMen_S : STD_LOGIC;
--RAMb
    signal InstrRAM_S : STD_LOGIC_VECTOR (15 downto 0);
        
-- IO PORT
    signal IOPORT_IN_S : STD_LOGIC_VECTOR (15 downto 0);

--ID STAGE
    --IFIDlatch
    signal ID_Instr_S, ID_INport_S : STD_LOGIC_VECTOR (15 downto 0);
    --Decoder
    signal ID_DR2C_S:STD_LOGIC_VECTOR (16 downto 0);
    signal ID_ALUmode_S: STD_LOGIC_VECTOR(3 downto 0);
    signal ID_IXread1_S, ID_IXread2_S, ID_RA_S: STD_LOGIC_VECTOR(2 downto 0);
    signal ID_DR1sel_S: STD_LOGIC_VECTOR(1 downto 0);
    signal ID_DR2sel_S,ID_WBenable_S,ID_OUTen_S: STD_LOGIC;
    signal ID_MEMopr_S: STD_LOGIC_VECTOR(1 downto 0);
    signal ID_Opcode_S : STD_LOGIC_VECTOR(6 downto 0);
    signal ID_DISP_S : STD_LOGIC_VECTOR(15 downto 0);
    --register file
    signal ID_DR1R_S, ID_DR2R_S :STD_LOGIC_VECTOR (16 downto 0);
    --Mux
    signal ID_DR1_S,ID_DR2_S,ID_MEMadr_S :STD_LOGIC_VECTOR (16 downto 0);
    
--EX STAGE
    --IDEXlatch
    signal EX_DR1M_S,EX_DR2M_S: STD_LOGIC_VECTOR (16 downto 0);--EX_MEMadr_S
    signal EX_ALUmode_S: STD_LOGIC_VECTOR (3 downto 0);
    signal EX_RA_S: STD_LOGIC_VECTOR (2 downto 0);
    signal EX_MEMadr_S: STD_LOGIC_VECTOR(16 downto 0);
    signal EX_MEMopr_S: STD_LOGIC_VECTOR(1 downto 0);
    signal EX_WBenable_S: STD_LOGIC;
    --EXmul1
    signal EX_DR1_S,EX_DR2_S : STD_LOGIC_VECTOR (16 downto 0);
    signal EX_DR1sel_S,EX_DR2sel_S : STD_LOGIC_VECTOR (1 downto 0);
    --ALU
    signal EX_ALUresult_S: STD_LOGIC_VECTOR (16 downto 0);
    signal EX_Z_S,EX_N_S,EX_V_S : STD_LOGIC;
    --SR
    signal CTRL_Z_S, CTRL_N_S, CTRL_V_S : STD_LOGIC;
    
--MEM STAGE
    --EXMEM LATCH
    signal MEM_ALUresult_S: STD_LOGIC_VECTOR(16 downto 0);
    signal MEM_RA_S: STD_LOGIC_VECTOR(2 downto 0);
    signal MEM_WBenable_S: STD_LOGIC;
    
    signal MEM_MEMopr_S: STD_LOGIC_VECTOR(1 downto 0);
    signal MEM_MEMadr_S: STD_LOGIC_VECTOR(16 downto 0);
    --MEMORY
    signal MEM_LOADdata_S: STD_LOGIC_VECTOR(15 downto 0);
--WB STAGE
    --MEMWB LATCH
    signal WB_WBdata_S: STD_LOGIC_VECTOR(16 downto 0);
    signal WB_RA_S: STD_LOGIC_VECTOR(2 downto 0);
    signal WB_WBenable_S: STD_LOGIC;

begin

    Map_Controller: Controller port map( 
        CTRL_PCip1_I            => IF_Pointer_S,
        CTRL_Opcode_I           => ID_Opcode_S,
        CTRL_DISP_I             => ID_DISP_S,
        CTRL_DA_I               => ID_DR1R_S,
        CTRL_SRZ_I              => CTRL_Z_S,
        CTRL_SRN_I              => CTRL_N_S,
        CTRL_SRV_I              => CTRL_V_S,
        CTRL_PointerOverride_O  => IF_PointerOverride_S,
        CTRL_OverrideEn_O       => IF_OverrideEn_S,
        CTRL_CLRfd_O            => CTRL_CLRfd_S,
        CTRL_CLRde_O            => CTRL_CLRde_S,
        CTRL_CLRem_O            => CTRL_CLRem_S,
        -----------
        CTRL_Read1_I            => ID_IXread1_S,
        CTRL_Read2_I            => ID_IXread2_S,
        CTRL_ExRA_I             => EX_RA_S,
        CTRL_ExWBen_I           => EX_WBenable_S,
        CTRL_MemRA_I            => MEM_RA_S,
        CTRL_MemWBen_I          => MEM_WBenable_S,
        CTRL_IDmux1sel_I        => ID_DR1sel_S,
        CTRL_DR1sel_O           => EX_DR1sel_S,
        CTRL_DR2sel_O           => EX_DR2sel_S,
        -----------
        CTRL_CLK_I              => CLK,
        CTRL_RST_I              => RST
        );
    
    Map_PC: PC port map(
        IF_OverrideEn_I         => IF_OverrideEn_S,
        IF_PointerOverride_I    => IF_PointerOverride_S,
        IF_Pointer_O            => IF_Pointer_S,
        IF_CLK_I                => CLK,
        IF_RST_I                => RST
    );
    
    ROMen_S<=not(IF_Pointer_S(11));
    Map_ROM: ROM port map(
            clka                    => CLK,
            rsta                    => RST,
            ena                     => ROMen_S,                     
            addra                   => IF_Pointer_S(10 downto 1),--(9 downto 0),
            douta                   => InstrROM_S  
        );
    --Pointer_O<=IF_Pointer_S;

    Map_IOPORT: IOPORT port map(
        IOPORT_IN_I     => INport_I,
        IOPORT_OUT_I    => ID_DR1R_S,
        IOPORT_IN_O     => IOPORT_IN_S,
        IOPORT_OUT_O    => OUTport_O,
        IOPORT_OUTen_I => ID_OUTen_S
    );
    
    Map_IFID: IFID port map(
        IFID_InstrROM_I => InstrROM_S,
        IFID_InstrRAM_I => InstrRAM_S,
        IFID_InstrSEL_I => IF_Pointer_S(11),
        IFID_Instr_O    => ID_Instr_S,
        IFID_INport_I   => IOPORT_IN_S,
        IFID_INport_O   => ID_INport_S,
        --IFID_PCip1_I        => IF_Pointer_S,
        --IFID_PCip1_O        => IF_Pointer_S,
        IFID_CLR_I      => CTRL_CLRfd_S,
        IFID_CLK_I      => CLK,
        IFID_RST_I      => RST
    );
    
    
    Map_Decoder: Decoder port map (
        IDC_Instr_I     => ID_Instr_S,
        IDC_IXread1_O   => ID_IXread1_S,
        IDC_IXread2_O   => ID_IXread2_S,
        IDC_ALUmode_O   => ID_ALUmode_S,
        IDC_DR1sel_O    => ID_DR1sel_S,
        IDC_DR2C_O      => ID_DR2C_S,
        IDC_DR2sel_O    => ID_DR2sel_S,
        IDC_RA_O        => ID_RA_S,
        IDC_WBenable_O  => ID_WBenable_S,
        IDC_OUTen_O     => ID_OUTen_S,
        IDC_MEMopr_O    => ID_MEMopr_S,
        IDC_Opcode_O    => ID_Opcode_S,
        IDC_DISP_O      => ID_DISP_S
    );
               
               
               
    Map_RegisterFile: RegisterFile port map (
        IDR_RA_I        => WB_RA_S,
        IDR_WBdata_I    => WB_WBdata_S,
        IDR_WBenable_I  => WB_WBenable_S,
        IDR_IXread1_I   => ID_IXread1_S,
        IDR_IXread2_I   => ID_IXread2_S,
        IDR_CLK_I       => CLK,
        IDR_RST_I       => RST,
        IDR_DR1R_O       => ID_DR1R_S,
        IDR_DR2R_O      => ID_DR2R_S
    );
    
    map_IDmux1: IDmux1 port map(
        IDM1_DR1R_I         => ID_DR1R_S,
        IDM1_INport_I       => ID_INport_S,
        IDM1_PCip1_I        => IF_Pointer_S,
        IDM1_DR1sel_I       => ID_DR1sel_S,
        IDM1_DR1_O          => ID_DR1_S,
        IDM1_DR2R_I         => ID_DR2R_S,
        IDM1_DR2C_I         => ID_DR2C_S,
        IDM1_DR2sel_I       => ID_DR2sel_S,
        IDM1_MEMopr_I       => ID_MEMopr_S,
        IDM1_DR2_O          => ID_DR2_S,
        IDM1_MEMadr_O       => ID_MEMadr_S
    );
     
    Map_IDEX: IDEX port map (
        IDEX_DR1_I      => ID_DR1_S,
        IDEX_DR2_I      => ID_DR2_S,
        IDEX_ALUmode_I  => ID_ALUmode_S,
        IDEX_MEMopr_I   => ID_MEMopr_S,
        IDEX_MEMadr_I   => ID_MEMadr_S,
        IDEX_WBenable_I => ID_WBenable_S,
        IDEX_RA_I       => ID_RA_S,
        IDEX_DR1_O      => EX_DR1M_S,
        IDEX_DR2_O      => EX_DR2M_S,
        IDEX_ALUmode_O  => EX_ALUmode_S,
        IDEX_MEMopr_O   => EX_MEMopr_S,
        IDEX_WBenable_O => EX_WBenable_S,
        IDEX_MEMadr_O   => EX_MEMadr_S,
        IDEX_RA_O       => EX_RA_S,
        IDEX_CLR_I      => CTRL_CLRde_S,
        IDEX_CLK_I      => CLK,
        IDEX_RST_I      => RST
    );
    
    Map_EXmux1 : EXmux1 Port map( 
            EXM1_DR1_I      => EX_DR1M_S,
            EXM1_DR2_I      => EX_DR2M_S,
            EXM1_MEMdata_I  => MEM_ALUresult_S,
            EXM1_WBdata_I   => WB_WBdata_S,
            EXM1_DR1sel_I   => EX_DR1sel_S,
            EXM1_DR2sel_I   => EX_DR2sel_S,
            EXM1_DR1_O      => EX_DR1_S,
            EXM1_DR2_O      => EX_DR2_S
    );
    
    Map_ALU: ALU port map(
        EX_DR1_I        => EX_DR1_S,
        EX_DR2_I        => EX_DR2_S,
        EX_ALUmode_I    => EX_ALUmode_S,
        EX_ALUresult_O  => EX_ALUresult_S,
        EX_Z_O          => EX_Z_S,
        EX_N_O          => EX_N_S,
        EX_V_O          => EX_V_S
    );
    
    Map_StatusRegister: StatusRegister port map(
        SR_Z_I          => EX_Z_S,
        SR_N_I          => EX_N_S,
        SR_V_I          => EX_V_S,
        SR_Z_O          => CTRL_Z_S,
        SR_N_O          => CTRL_N_S,
        SR_V_O          => CTRL_V_S,
        SR_CLK_I        => CLK,
        SR_RST_I        => RST
    );
    
    Map_EXMEM: EXMEM port map(
        EXMEM_ALUresult_I   => EX_ALUresult_S,
        EXMEM_RA_I          => EX_RA_S,
        EXMEM_MEMadr_I      => EX_MEMadr_S,
        EXMEM_MEMopr_I      => EX_MEMopr_S,
        EXMEM_WBenable_I    => EX_WBenable_S,
        EXMEM_ALUresult_O   => MEM_ALUresult_S,
        EXMEM_RA_O          => MEM_RA_S,
        EXMEM_MEMopr_O      => MEM_MEMopr_S,
        EXMEM_WBenable_O    => MEM_WBenable_S,
        EXMEM_MEMadr_O      => MEM_MEMadr_S,
        EXMEM_CLR_I         => CTRL_CLRem_S,
        EXMEM_CLK_I         => CLK,
        EXMEM_RST_I         => RST
    );
    
    map_RAM: RAM port map(
        
        -- Port A module ports
        RAM_EnA_I   => MEM_MEMopr_S(1),
        RAM_WenA_I  => MEM_MEMopr_S(0 downto 0),
        RAM_AddrA_I => MEM_MEMadr_S(9 downto 0),
        RAM_DataA_I => MEM_ALUresult_S(15 downto 0),
        RAM_DataA_O => MEM_LOADdata_S,
        
        -- Port B module ports
        RAM_EnB     => IF_Pointer_S(11),
        RAM_AddrB_I => IF_Pointer_S(10 downto 1),
        RAM_DataB_O => InstrRAM_S,
    
        --USED FOR BOTH PORTS
        RAM_CLK_I   => CLK,
        RAM_RST_I   => RST
    );
    
    Map_MEMWB: MEMWB port map(
        MEMWB_ALUresult_I   => MEM_ALUresult_S,
        MEMWB_LOADdata_I    => MEM_LOADdata_S,
        MEMWB_RA_I          => MEM_RA_S,
        MEMWB_WBenable_I    => MEM_WBenable_S,
        MEMWB_MEMopr_I      => MEM_MEMopr_S,
        MEMWB_RA_O          => WB_RA_S,
        MEMWB_WBdata_O      => WB_WBdata_S,
        MEMWB_WBenable_O    => WB_WBenable_S,
        MEMWB_CLK_I         => CLK,
        MEMWB_RST_I         => RST
    );
    
end Behavioral;
