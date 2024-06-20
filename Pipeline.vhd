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
         INport_I : in STD_LOGIC_VECTOR(15 downto 6);
         OUTport_O : out STD_LOGIC_VECTOR(15 downto 0);
         RST_LD,RST_EX:  in STD_LOGIC;
         --Pointer_O: out STD_LOGIC_VECTOR(15 downto 0);
         AN_O: out std_logic_vector(3 downto 0);
         Sseg_O: out std_logic_vector(6 downto 0);
         CLK : in STD_LOGIC;
         CLKbrd: in STD_LOGIC;
         DIPdata: in STD_LOGIC_VECTOR(15 downto 0);
         
         
--** BRENTS

--+
--
-- Top module entity signal declaration. You will need to add the following signals to your entity state.
--
--+

-- cut from here

        debug_console : in STD_LOGIC;
        --board_clock: in std_logic;
        
        vga_red : out std_logic_vector( 3 downto 0 );
        vga_green : out std_logic_vector( 3 downto 0 );
        vga_blue : out std_logic_vector( 3 downto 0 );
        
        h_sync_signal : out std_logic;
        v_sync_signal : out std_logic

-- to here
         
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
    CTRL_IDmux1sel_I : in STD_LOGIC_VECTOR(2 downto 0);
    CTRL_IDmemOpr_I : in STD_LOGIC_VECTOR(1 downto 0);
    CTRL_DR1sel_O : out STD_LOGIC_VECTOR(1 downto 0);
    CTRL_DR2sel_O : out STD_LOGIC_VECTOR(1 downto 0);
    CTRL_ADRsel_O : out STD_LOGIC_VECTOR(1 downto 0);
    -----------
    
    -----------
    CTRL_BUBBLE_I : in STD_LOGIC;
    CTRL_ExData_I : in STD_LOGIC_VECTOR(16 downto 0);
    CTRL_MemData_I : in STD_LOGIC_VECTOR(16 downto 0);
    CTRL_CLKen_O : out STD_LOGIC;
    -----------
    
    -----------
    CTRL_OutportData_O : out STD_LOGIC_VECTOR(16 downto 0);
    -----------
    
    CTRL_CLK_I : in STD_LOGIC;
    CTRL_RST_I : in STD_LOGIC);
end component;

component PC is
    Port ( 
           IF_OverrideEn_I : in STD_LOGIC;
           IF_PointerOverride_I : in STD_LOGIC_VECTOR(15 downto 0);
           IF_CLKen_I : in STD_LOGIC;
           IF_Pointer_O : out STD_LOGIC_VECTOR(15 downto 0);
           IF_CLK_I,IF_RSTld_I,IF_RSTex_I : in STD_LOGIC);
end component;

component MemorySelect is
    Port ( 
        IF_Pointer_I : in STD_LOGIC_VECTOR(15 downto 0);
        IF_ROMen_O : out STD_LOGIC;
        IF_RAMen_O : out STD_LOGIC
        );
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
           IOPORT_OUTen_I : in STD_LOGIC;
           IOPORT_RST_I : in STD_LOGIC;
           IOPORT_CLK_I : in STD_LOGIC
           );
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
        IDC_MEMopr_O : out STD_LOGIC_VECTOR(1 downto 0);
        IDC_BUBBLE_O : out STD_LOGIC
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
        IDR_DR2R_O : out STD_LOGIC_VECTOR(16 downto 0);
        IDR_TestReg0_O : out STD_LOGIC_VECTOR(16 downto 0);
        IDR_TestReg1_O : out STD_LOGIC_VECTOR(16 downto 0);
        IDR_TestReg2_O : out STD_LOGIC_VECTOR(16 downto 0);
        IDR_TestReg3_O : out STD_LOGIC_VECTOR(16 downto 0);
        IDR_TestReg4_O : out STD_LOGIC_VECTOR(16 downto 0);
        IDR_TestReg5_O : out STD_LOGIC_VECTOR(16 downto 0);
        IDR_TestReg6_O : out STD_LOGIC_VECTOR(16 downto 0);
        IDR_TestReg7_O : out STD_LOGIC_VECTOR(16 downto 0)
        );
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
        EXM1_MEMadr_I : in STD_LOGIC_VECTOR( 16 downto 0);
        EXM1_MEMdata_I : in STD_LOGIC_VECTOR( 16 downto 0);   --From EXMEM
        EXM1_WBdata_I : in STD_LOGIC_VECTOR( 16 downto 0);   --From MEMWB
        EXM1_DR1sel_I : in STD_LOGIC_VECTOR( 1 downto 0);
        EXM1_DR2sel_I : in STD_LOGIC_VECTOR( 1 downto 0);
        EXM1_ADRsel_I : in STD_LOGIC_VECTOR( 1 downto 0);
        EXM1_DR1_O : out STD_LOGIC_VECTOR( 16 downto 0);
        EXM1_DR2_O : out STD_LOGIC_VECTOR( 16 downto 0);
        EXM1_ADR_O : out STD_LOGIC_VECTOR( 16 downto 0));        
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

component MemoryWriteSelect is
    Port ( 
        MEM_MEMadr_I : in STD_LOGIC_VECTOR(16 downto 0);
        MEM_MEMopr_I : in STD_LOGIC_VECTOR(1 downto 0);
        MEM_RAMenA_O : out STD_LOGIC;
        MEM_RAMweA_O : out STD_LOGIC_VECTOR(0 downto 0);
        MEM_LEDen_O : out STD_LOGIC;
        MEM_CNSLen_O : out STD_LOGIC;
        MEM_DIPen_O : out STD_LOGIC
    );
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

component DipSwitches is
    Port ( 
        DP_MemoryData_I : in STD_LOGIC_VECTOR (15 downto 0);
        DP_Switches_I : in STD_LOGIC_VECTOR (15 downto 0);
        DP_SwitchesEn_I : in STD_LOGIC;
        DP_Switches_O : out STD_LOGIC_VECTOR (15 downto 0)
        );
end component;

component led_display is
    Port (

        addr_write : in  STD_LOGIC_VECTOR (15 downto 0);
        clk : in  STD_LOGIC;
        data_in : in  STD_LOGIC_VECTOR (15 downto 0);
        en_write : in  STD_LOGIC;

        board_clock : in STD_LOGIC;
        led_segments : out STD_LOGIC_VECTOR( 6 downto 0 );
        led_digits : out STD_LOGIC_VECTOR( 3 downto 0 )
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


----*************************************************************BRENTS DISPLAY CODE*************************************************************

--+
--
-- component declaration insert this code block into your CPU's code top module. To remove the extra comments select the text and press control /
--
--+

-- Cut from here

component console is
    port (

--
-- Stage 1 Fetch
--
        s1_pc : in STD_LOGIC_VECTOR ( 15 downto 0 );
        s1_inst : in STD_LOGIC_VECTOR ( 15 downto 0 );


--
-- Stage 2 Decode
--
        s2_pc : in STD_LOGIC_VECTOR ( 15 downto 0 );
        s2_inst : in STD_LOGIC_VECTOR ( 15 downto 0 );

        s2_reg_a : in STD_LOGIC_VECTOR( 2 downto 0 );
        s2_reg_b : in STD_LOGIC_VECTOR( 2 downto 0 );
        s2_reg_c : in STD_LOGIC_VECTOR( 2 downto 0 );

        s2_reg_a_data : in STD_LOGIC_VECTOR( 15 downto 0 );
        s2_reg_b_data : in STD_LOGIC_VECTOR( 15 downto 0 );
        s2_reg_c_data : in STD_LOGIC_VECTOR( 15 downto 0 );

        s2_immediate : in STD_LOGIC_VECTOR( 15 downto 0 );


--
-- Stage 3 Execute
--
        s3_pc : in STD_LOGIC_VECTOR ( 15 downto 0 );
        s3_inst : in STD_LOGIC_VECTOR ( 15 downto 0 );

        s3_reg_a : in STD_LOGIC_VECTOR( 2 downto 0 );
        s3_reg_b : in STD_LOGIC_VECTOR( 2 downto 0 );
        s3_reg_c : in STD_LOGIC_VECTOR( 2 downto 0 );

        s3_reg_a_data : in STD_LOGIC_VECTOR( 15 downto 0 );
        s3_reg_b_data : in STD_LOGIC_VECTOR( 15 downto 0 );
        s3_reg_c_data : in STD_LOGIC_VECTOR( 15 downto 0 );

        s3_immediate : in STD_LOGIC_VECTOR( 15 downto 0 );

--
-- Branch and memory operation
--
        s3_r_wb : in STD_LOGIC;
        s3_r_wb_data : in STD_LOGIC_VECTOR( 15 downto 0 );

        s3_br_wb : in STD_LOGIC;
        s3_br_wb_address : in STD_LOGIC_VECTOR( 15 downto 0 );

        s3_mr_wr : in STD_LOGIC;
        s3_mr_wr_address : in STD_LOGIC_VECTOR( 15 downto 0 );
        s3_mr_wr_data : in STD_LOGIC_VECTOR( 15 downto 0 );

        s3_mr_rd : in STD_LOGIC;
        s3_mr_rd_address : in STD_LOGIC_VECTOR( 15 downto 0 );

--
-- Stage 4 Memory
--
        s4_pc : in STD_LOGIC_VECTOR( 15 downto 0 );
        s4_inst : in STD_LOGIC_VECTOR( 15 downto 0 );

        s4_reg_a : in STD_LOGIC_VECTOR( 2 downto 0 );

        s4_r_wb : in STD_LOGIC;
        s4_r_wb_data : in STD_LOGIC_VECTOR( 15 downto 0 );

--
-- CPU registers
--

        register_0 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_1 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_2 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_3 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_4 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_5 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_6 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_7 : in STD_LOGIC_VECTOR ( 15 downto 0 );

--
-- CPU registers overflow flags
--
        register_0_of : in STD_LOGIC;
        register_1_of : in STD_LOGIC;
        register_2_of : in STD_LOGIC;
        register_3_of : in STD_LOGIC;
        register_4_of : in STD_LOGIC;
        register_5_of : in STD_LOGIC;
        register_6_of : in STD_LOGIC;
        register_7_of : in STD_LOGIC;

--
-- CPU Flags
--
        zero_flag : in STD_LOGIC;
        negative_flag : in STD_LOGIC;
        overflow_flag : in STD_LOGIC;

--
-- Debug screen enable
--
        debug : in STD_LOGIC;

--
-- Text console display memory access signals ( clk is the processor clock )
--
        addr_write : in  STD_LOGIC_VECTOR (15 downto 0);
        clk : in  STD_LOGIC;
        data_in : in  STD_LOGIC_VECTOR (15 downto 0);
        en_write : in  STD_LOGIC;

--
-- Video related signals
--
        board_clock : in STD_LOGIC;
        v_sync_signal : out STD_LOGIC;
        h_sync_signal : out STD_LOGIC;
        vga_red : out STD_LOGIC_VECTOR( 3 downto 0 );
        vga_green : out STD_LOGIC_VECTOR( 3 downto 0 );
        vga_blue : out STD_LOGIC_VECTOR( 3 downto 0 )

    );
end component;

-- to here






--RST
    signal RST : STD_LOGIC;
--Controller
    signal CTRL_CLRfd_S,CTRL_CLRde_S,CTRL_CLRem_S : STD_LOGIC;
    signal ID_DRsel_S : STD_LOGIC_VECTOR(2 downto 0);
    signal IF_CLKen_S : STD_LOGIC;
    signal CTRL_OutportData_S : STD_LOGIC_VECTOR (16 downto 0);
--PC
    signal IF_PointerOverride_S, IF_Pointer_S : STD_LOGIC_VECTOR (15 downto 0);
    signal IF_OverrideEn_S : STD_LOGIC;
    
--ROM
    signal InstrROM_S : STD_LOGIC_VECTOR (15 downto 0);
    signal ROMen_S : STD_LOGIC;
--RAMb
    signal InstrRAM_S : STD_LOGIC_VECTOR (15 downto 0);
    signal RAMen_S : STD_LOGIC;
        
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
    signal ID_BUBBLE_S : STD_LOGIC;
    --register file
    signal ID_DR1R_S, ID_DR2R_S :STD_LOGIC_VECTOR (16 downto 0);
    signal IDR_TestReg0_S : STD_LOGIC_VECTOR(16 downto 0);
    signal IDR_TestReg1_S : STD_LOGIC_VECTOR(16 downto 0);
    signal IDR_TestReg2_S : STD_LOGIC_VECTOR(16 downto 0);
    signal IDR_TestReg3_S : STD_LOGIC_VECTOR(16 downto 0);
    signal IDR_TestReg4_S : STD_LOGIC_VECTOR(16 downto 0);
    signal IDR_TestReg5_S : STD_LOGIC_VECTOR(16 downto 0);
    signal IDR_TestReg6_S : STD_LOGIC_VECTOR(16 downto 0);
    signal IDR_TestReg7_S : STD_LOGIC_VECTOR(16 downto 0);
    --Mux
    signal ID_DR1_S,ID_DR2_S,ID_MEMadr_S :STD_LOGIC_VECTOR (16 downto 0);
    
--EX STAGE
    --IDEXlatch
    signal EX_DR1M_S,EX_DR2M_S,EX_MEMadrM_S: STD_LOGIC_VECTOR (16 downto 0);--EX_MEMadr_S
    signal EX_ALUmode_S: STD_LOGIC_VECTOR (3 downto 0);
    signal EX_RA_S: STD_LOGIC_VECTOR (2 downto 0);
    signal EX_MEMopr_S: STD_LOGIC_VECTOR(1 downto 0);
    signal EX_WBenable_S: STD_LOGIC;
    --EXmul1
    signal EX_DR1_S,EX_DR2_S,EX_MEMadr_S : STD_LOGIC_VECTOR (16 downto 0);
    signal EX_DR1sel_S,EX_DR2sel_S,EX_ADRsel_S : STD_LOGIC_VECTOR (1 downto 0);
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
    
    --MEMORY WRITE SELECT
    signal MEM_RAMenA_S : STD_LOGIC;
    signal MEM_RAMweA_S : STD_LOGIC_VECTOR(0 downto 0);
    signal MEM_LEDen_S : STD_LOGIC;
    signal MEM_CNSLen_S : STD_LOGIC;
    --MEMORY
    signal MEM_RAMdata_S: STD_LOGIC_VECTOR(15 downto 0);--, MEM_DIPdata_S
    signal MEM_SwitchesEn_S : STD_LOGIC;
    signal MEM_LOADdata_S: STD_LOGIC_VECTOR(15 downto 0);
    
    --signal MEM_AN_S: std_logic_vector(3 downto 0);
    --signal MEM_Sseg_S: std_logic_vector(6 downto 0);
--WB STAGE
    --MEMWB LATCH
    signal WB_WBdata_S: STD_LOGIC_VECTOR(16 downto 0);
    signal WB_RA_S: STD_LOGIC_VECTOR(2 downto 0);
    signal WB_WBenable_S: STD_LOGIC;
    
    
--brents a punt
    signal s4_weA_S : STD_LOGIC_VECTOR(2 downto 0);
    signal OUTPORT : STD_LOGIC_VECTOR(15 downto 0);
    signal INPORT : STD_LOGIC_VECTOR(15 downto 0);
    signal IOportL_I : STD_LOGIC_VECTOR(15 downto 0);
begin
    IOPORT_IN_S<=INport_I&"000000";
    RST<=RST_EX or RST_LD;
    ID_DRsel_S<=ID_DR2sel_S&ID_DR1sel_S;
    
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
        CTRL_IDmux1sel_I        => ID_DRsel_S,
        CTRL_IDmemOpr_I         => ID_MEMopr_S,
        CTRL_DR1sel_O           => EX_DR1sel_S,
        CTRL_DR2sel_O           => EX_DR2sel_S,
        CTRL_ADRsel_O           => EX_ADRsel_S,
        -----------
        -----------
        CTRL_BUBBLE_I           => ID_BUBBLE_S,
        CTRL_ExData_I           => EX_ALUresult_S,
        CTRL_MemData_I          => MEM_ALUresult_S,
        CTRL_CLKen_O            => IF_CLKen_S,
        -----------
        -----------
        CTRL_OutportData_O      => CTRL_OutportData_S,
        -----------
        CTRL_CLK_I              => CLK,
        CTRL_RST_I              => RST
        );
    
    Map_PC: PC port map(
        IF_OverrideEn_I         => IF_OverrideEn_S,
        IF_PointerOverride_I    => IF_PointerOverride_S,
        IF_CLKen_I              => IF_CLKen_S,
        IF_Pointer_O            => IF_Pointer_S,
        IF_CLK_I                => CLK,
        IF_RSTld_I              => RST_LD,
        IF_RSTex_I              => RST_EX
    );
    Map_MemorySelect: MemorySelect port map(
        IF_Pointer_I  => IF_Pointer_S,
        IF_ROMen_O  => ROMen_S,
        IF_RAMen_O  => RAMen_S
    );

    --ROMen_S<=not(IF_Pointer_S(11));--(10));--
    Map_ROM: ROM port map(
        clka                    => CLK,
        rsta                    => RST,
        ena                     => ROMen_S,                     
        addra                   => IF_Pointer_S(10 downto 1),--(9 downto 0),--
        douta                   => InstrROM_S  
    );
    --Pointer_O<=IF_Pointer_S;
    --IOPORT_IN_S<=INportL_I;
    Map_IOPORT: IOPORT port map(
        IOPORT_IN_I     => (15 downto 0 => '0'),--INport_I,--
        IOPORT_OUT_I    => CTRL_OutportData_S,--ID_DR1R_S,
        --IOPORT_IN_O     => ,--IOPORT_IN_S,--
        IOPORT_OUT_O    => OUTPORT,
        IOPORT_OUTen_I  => ID_OUTen_S,
        IOPORT_RST_I    => RST,
        IOPORT_CLK_I    => CLK
    );
    
    Map_IFID: IFID port map(
        IFID_InstrROM_I => InstrROM_S,
        IFID_InstrRAM_I => InstrRAM_S,
        IFID_InstrSEL_I => RAMen_S,
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
        IDC_DISP_O      => ID_DISP_S,
        IDC_BUBBLE_O    => ID_BUBBLE_S
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
        IDR_DR2R_O      => ID_DR2R_S,
        IDR_TestReg0_O  => IDR_TestReg0_S,
        IDR_TestReg1_O  => IDR_TestReg1_S,
        IDR_TestReg2_O  => IDR_TestReg2_S,
        IDR_TestReg3_O  => IDR_TestReg3_S,
        IDR_TestReg4_O  => IDR_TestReg4_S,
        IDR_TestReg5_O  => IDR_TestReg5_S,
        IDR_TestReg6_O  => IDR_TestReg6_S,
        IDR_TestReg7_O  => IDR_TestReg7_S
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
        IDEX_MEMadr_O   => EX_MEMadrM_S,
        IDEX_RA_O       => EX_RA_S,
        IDEX_CLR_I      => CTRL_CLRde_S,
        IDEX_CLK_I      => CLK,
        IDEX_RST_I      => RST
    );
    
    Map_EXmux1 : EXmux1 Port map( 
            EXM1_DR1_I      => EX_DR1M_S,
            EXM1_DR2_I      => EX_DR2M_S,
            EXM1_MEMadr_I  => EX_MEMadrM_S,
            EXM1_MEMdata_I  => MEM_ALUresult_S,
            EXM1_WBdata_I   => WB_WBdata_S,
            EXM1_DR1sel_I   => EX_DR1sel_S,
            EXM1_DR2sel_I   => EX_DR2sel_S,
            EXM1_ADRsel_I   => EX_ADRsel_S,
            EXM1_DR1_O      => EX_DR1_S,
            EXM1_DR2_O      => EX_DR2_S,
            EXM1_ADR_O      => EX_MEMadr_S
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
    
    
    Map_MemoryWriteSelect: MemoryWriteSelect Port map ( 
        MEM_MEMadr_I    => MEM_MEMadr_S,
        MEM_MEMopr_I    => MEM_MEMopr_S,
        MEM_RAMenA_O    => MEM_RAMenA_S,
        MEM_RAMweA_O    => MEM_RAMweA_S,
        MEM_LEDen_O     => MEM_LEDen_S,
        MEM_CNSLen_O    => MEM_CNSLen_S,
        MEM_DIPen_O     => MEM_SwitchesEn_S
    );
    
    map_RAM: RAM port map(
        
        -- Port A module ports
        RAM_EnA_I   => MEM_RAMenA_S,
        RAM_WenA_I  => MEM_RAMweA_S,
        RAM_AddrA_I => MEM_MEMadr_S(10 downto 1),
        RAM_DataA_I => MEM_ALUresult_S(15 downto 0),
        RAM_DataA_O => MEM_RAMdata_S,
        
        -- Port B module ports
        RAM_EnB     => RAMen_S,--IF_Pointer_S(11),
        RAM_AddrB_I => IF_Pointer_S(10 downto 1),
        RAM_DataB_O => InstrRAM_S,
    
        --USED FOR BOTH PORTS
        RAM_CLK_I   => CLK,
        RAM_RST_I   => RST
    );
    
    map_DipSwitches : DipSwitches Port map(
            DP_MemoryData_I => MEM_RAMdata_S, 
            DP_Switches_I   => DIPdata,
            DP_SwitchesEn_I => MEM_SwitchesEn_S,
            DP_Switches_O   =>MEM_LOADdata_S 
    );
        
    
    
    
--    map_SegDisplay: SegDisplay port map(
--            CLKbrd         => CLKbrd,
--            RST         => RST,
--            MEM_Hex3_I  => MEM_ALUresult_S(15 downto 12),
--            MEM_Hex2_I  => MEM_ALUresult_S(11 downto 8),
--            MEM_Hex1_I  => MEM_ALUresult_S(7 downto 4),
--            MEM_Hex0_I  => MEM_ALUresult_S(3 downto 0),
--            MEM_AN_O    => AN_O,
--            MEM_Sseg_O  => Sseg_O
--    );
    
    map_SegDisplay : led_display
    port map (
            addr_write      => MEM_MEMadr_S(15 downto 0),--s2_memory_write_address,
            clk             => CLK, --cpu_clock,
            data_in         => MEM_ALUresult_S(15 downto 0),--s2_memory_write_data,
            en_write        => MEM_LEDen_S,--s2_memory_write_enable,
    
            board_clock     => CLKbrd,--board_clock,
            led_segments    => Sseg_O,--led_segments,
            led_digits      => AN_O--led_digits
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
    
    
    
--+
--
-- Creation of console. Add the following code to add the component to your system. You will need to map the signal that you wish to display
--
--+

-- Cut from here
s4_weA_S<="00"&MEM_RAMweA_S;
OUTport_O<=OUTPORT;
--INPORT<=INport_I;
INPORT<=IOPORT_IN_S;
console_display : console
port map
(
--
-- Stage 1 Fetch
--
    s1_pc => IF_Pointer_S,
    s1_inst => x"0000",

--
-- Stage 2 Decode
--

    s2_pc => x"0000",
    s2_inst => ID_Instr_S,

    s2_reg_a => ID_IXread1_S,
    s2_reg_b => ID_IXread2_S,
    s2_reg_c => "000",

    s2_reg_a_data => ID_DR1R_S(15 downto 0),
    s2_reg_b_data => ID_DR2R_S(15 downto 0),
    s2_reg_c_data => x"0000",--INPORT(15 downto 0),
    s2_immediate => OUTPORT,--ID_INport_S

--
-- Stage 3 Execute
--

    s3_pc => x"0000",
    s3_inst => x"0000",

    s3_reg_a => "000",
    s3_reg_b => "000",
    s3_reg_c => "000",

    s3_reg_a_data => EX_DR1_S(15 downto 0),
    s3_reg_b_data => EX_DR2_S(15 downto 0),
    s3_reg_c_data => EX_ALUresult_S(15 downto 0),
    s3_immediate => x"0000",

    s3_r_wb => '0',
    s3_r_wb_data => x"0000",

    s3_br_wb => '0',
    s3_br_wb_address => x"0000",

    s3_mr_wr => '0',
    s3_mr_wr_address => x"0000",
    s3_mr_wr_data => x"0000",

    s3_mr_rd => '0',
    s3_mr_rd_address => x"0000",

--
-- Stage 4 Memory
--
    s4_pc => MEM_MEMadr_S(15 downto 0),--MEM_MEMadr_S(15 downto 0)
    s4_inst => MEM_ALUresult_S(15 downto 0),
    s4_reg_a => s4_weA_S,
    s4_r_wb => MEM_WBenable_S,
    s4_r_wb_data => MEM_LOADdata_S(15 downto 0),

--
-- CPU registers
--

    register_0 => x"0000",--IDR_TestReg0_S(15 downto 0),--OUTPORT,
    register_1 => x"0000",--IDR_TestReg1_S(15 downto 0),
    register_2 => x"0000",--IDR_TestReg2_S(15 downto 0),
    register_3 => x"0000",--IDR_TestReg3_S(15 downto 0),
    register_4 => x"0000",--IDR_TestReg4_S(15 downto 0),--INPORT(15 downto 0),
    register_5 => x"0000",--IDR_TestReg5_S(15 downto 0),
    register_6 => x"0000",--IDR_TestReg6_S(15 downto 0),
    register_7 => x"0000",--IDR_TestReg7_S(15 downto 0),

    register_0_of => '0',--IDR_TestReg0_S(16),
    register_1_of => '0',--IDR_TestReg1_S(16),
    register_2_of => '0',--IDR_TestReg2_S(16),
    register_3_of => '0',--IDR_TestReg3_S(16),
    register_4_of => '0',--IDR_TestReg4_S(16),
    register_5_of => '0',--IDR_TestReg5_S(16),
    register_6_of => '0',--IDR_TestReg6_S(16),
    register_7_of => '0',--IDR_TestReg7_S(16),

--
-- CPU Flags
--
    zero_flag => CTRL_Z_S,
    negative_flag => CTRL_N_S,
    overflow_flag => CTRL_V_S,

--
-- Debug screen enable
--
    debug => debug_console,

--
-- Text console display memory access signals ( clk is the processor clock )
--

    clk => CLK,
    addr_write => MEM_MEMadr_S(15 downto 0),
    data_in => MEM_ALUresult_S(15 downto 0),
    en_write => MEM_CNSLen_S,

--
-- Video related signals
--

    board_clock => CLKbrd,--board_clock,
    h_sync_signal => h_sync_signal,
    v_sync_signal => v_sync_signal,
    vga_red => vga_red,
    vga_green => vga_green,
    vga_blue => vga_blue
);

-- to here
    
    
    
    
    
    
    
    
    
    
    
end Behavioral;
