----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2024 05:13:34 PM
-- Design Name: 
-- Module Name: ROM - Behavioral
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


--********************************************************************************************************


-- XPM_MEMORY instantiation template for single port ROM configurations
-- Refer to the targeted device family architecture libraries guide for XPM_MEMORY documentation
-- =======================================================================================================================
--
-- Generic usage table, organized as follows:
-- +---------------------------------------------------------------------------------------------------------------------+
-- | Generic name         | Data type          | Restrictions, if applicable                                             |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Description                                                                                                         |
-- +---------------------------------------------------------------------------------------------------------------------+
-- +---------------------------------------------------------------------------------------------------------------------+
-- | MEMORY_SIZE          | Integer            | Must be integer multiple of READ_DATA_WIDTH_A                           |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify the total memory array size, in bits.                                                                       |
-- | For example, enter 65536 for a 2kx32 ROM.                                                                           |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | MEMORY_PRIMITIVE     | String             | Must be "auto", "distributed", or "block"                               |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Designate the memory primitive (resource type) to use:                                                              |
-- |   "auto": Allow Vivado Synthesis to choose                                                                          |
-- |   "distributed": Distributed memory                                                                                 |
-- |   "block": Block memory                                                                                             |
-- |   "ultra": Ultra RAM memory                                                                                         |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | MEMORY_INIT_FILE     | String             | Must be exactly "none" or the name of the file (in quotes)              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify "none" (including quotes) for no memory initialization, or specify the name of a memory initialization file:|
-- |   Enter only the name of the file with .mem extension, including quotes but without path (e.g. "my_file.mem").      |
-- |   File format must be ASCII and consist of only hexadecimal values organized into the specified depth by            |
-- |   narrowest data width generic value of the memory.  See the Memory File (MEM) section for more                     |
-- |   information on the syntax. Initialization of memory happens through the file name specified only when generic     |
-- |   MEMORY_INIT_PARAM value is equal to "".                                                                           |
-- |   When using XPM_MEMORY in a project, add the specified file to the Vivado project as a design source.              |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | MEMORY_INIT_PARAM    | String             | Must be exactly "" or the string of hex characters (in quotes)          |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify "" or "0" (including quotes) for no memory initialization through parameter, or specify the string          |
-- | containing the hex characters.Enter only hex characters and each location separated by delimiter(,).                |
-- | Parameter format must be ASCII and consist of only hexadecimal values organized into the specified depth by         |
-- | narrowest data width generic value of the memory.  For example, if the narrowest data width is 8, and the depth of  |
-- | memory is 8 locations, then the parameter value should be passed as shown below.                                    |
-- |   parameter MEMORY_INIT_PARAM = "AB,CD,EF,1,2,34,56,78"                                                             |
-- |                                  |                   |                                                              |
-- |                                  0th                7th                                                             |
-- |                                location            location                                                         |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | USE_MEM_INIT         | Integer            | Must be 0 or 1                                                          |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify 1 to enable the generation of below message and 0 to disable the generation of below message completely.    |
-- | Note: This message gets generated only when there is no Memory Initialization specified either through file or      |
-- | Parameter.                                                                                                          |
-- |    INFO : MEMORY_INIT_FILE and MEMORY_INIT_PARAM together specifies no memory initialization.                       |
-- |    Initial memory contents will be all 0's                                                                          |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | WAKEUP_TIME          | String             | Must be "disable_sleep" or "use_sleep_pin"                              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify "disable_sleep" to disable dynamic power saving option, and specify "use_sleep_pin" to enable the           |
-- | dynamic power saving option                                                                                         |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | ECC_MODE             | String              | Must be "no_ecc", "encode_only", "decode_only"                         |
-- |                                            | or "both_encode_and_decode".                                           |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify ECC mode on all ports of the memory primitive(ECC with initialization is not currently supported)           |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | AUTO_SLEEP_TIME      | Integer             | Must be 0 or 3-15                                                      |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Must be set to 0                                                                                                    |
-- |   0 : Disable auto-sleep feature                                                                                    |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | MEMORY_OPTIMIZATION     | String             | Must be "true" or "false"                                            |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify "false" to disable the optimization of unused memory or bits in the memory structure                        |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | MESSAGE_CONTROL      | Integer            | Must be 0 or 1                                                          |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify 1 to enable the dynamic message reporting such as collision warnings, and 0 to disable the message reporting|
-- +---------------------------------------------------------------------------------------------------------------------+
-- | READ_DATA_WIDTH_A    | Integer            | Must be > 0                                                             |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify the width of the port A read data output port douta, in bits.                                               |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | ADDR_WIDTH_A         | Integer            | Must be >= ceiling of log2(MEMORY_SIZE/READ_DATA_WIDTH_A)               |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify the width of the port A address port addra, in bits.                                                        |
-- | Must be large enough to access the entire memory from port A, i.e. >= $clog2(MEMORY_SIZE/READ_DATA_WIDTH_A).        |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | READ_RESET_VALUE_A   | String             |                                                                         |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify the reset value of the port A final output register stage in response to rsta input port is assertion.      |
-- | As this parameter is a string, please specify the hex values inside double quotes. As an example,                   |
-- | If the read data width is 8, then specify READ_RESET_VALUE_A = "EA";                                                |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | READ_LATENCY_A       | Integer            | Must be >= 0 for distributed memory, or >= 1 for block memory           |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify the number of register stages in the port A read data pipeline. Read data output to port douta takes this   |
-- | number of clka cycles.                                                                                              |
-- | To target block memory, a value of 1 or larger is required: 1 causes use of memory latch only; 2 causes use of      |
-- | output register. To target distributed memory, a value of 0 or larger is required: 0 indicates combinatorial output.|
-- | Values larger than 2 synthesize additional flip-flops that are not retimed into memory primitives.                  |
-- +---------------------------------------------------------------------------------------------------------------------+
--
-- Port usage table, organized as follows:
-- +---------------------------------------------------------------------------------------------------------------------+
-- | Port name      | Direction | Size, in bits                         | Domain | Sense       | Handling if unused      |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Description                                                                                                         |
-- +---------------------------------------------------------------------------------------------------------------------+
-- +---------------------------------------------------------------------------------------------------------------------+
-- | sleep          | Input     | 1                                     |        | Active-high | Tie to '0'              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | sleep signal to enable the dynamic power saving feature.                                                            |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | clka           | Input     | 1                                     |        | Rising edge | Tie to '0'              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Clock signal for port A.                                                                                            |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | rsta           | Input     | 1                                     | clka   | Active-high | Tie to '0'              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Reset signal for the final port A output register stage.                                                            |
-- | Synchronously resets output port douta to the value specified by generic READ_RESET_VALUE_A.                        |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | ena            | Input     | 1                                     | clka   | Active-high | Tie to '1'              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Memory enable signal for port A.                                                                                    |
-- | Must be high on clock cycles when read operations are initiated. Pipelined internally.                              |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | regcea         | Input     | 1                                     | clka   | Active-high | Tie to '1'              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Clock Enable for the last register stage on the output data path.                                                   |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | addra          | Input     | ADDR_WIDTH_A                          | clka   |             | Required                |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Address for port A read operations.                                                                                 |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | injectsbiterra | Input     | 1                                     | clka   | Active-high | Tie to '0'              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Do not change from the provided value.                                                                              |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | injectdbiterra | Input     | 1                                     | clka   | Active-high | Tie to '0'              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Do not change from the provided value.                                                                              |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | douta          | Output   | READ_DATA_WIDTH_A                      | clka   |             | Required                |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Data output for port A read operations.                                                                             |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | sbiterra       | Output   | 1                                      | clka   | Active-high | Leave open              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Leave open.                                                                                                         |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | dbiterra       | Output   | 1                                      | clka   | Active-high | Leave open              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Leave open.                                                                                                         |
-- +---------------------------------------------------------------------------------------------------------------------+
--
-- Set generic values and connect ports to instantiate an XPM_MEMORY single port ROM configuration

--   xpm_memory_sprom   : In order to incorporate this function into the design, the following instance declaration
--         VHDL         : needs to be placed in the architecture body of the design code.  The default values for the
--       instance       : generics may be changed to meet design requirements.  The instance name (xpm_memory_sprom_inst)
--      declaration     : and/or the port declarations after the "=>" declaration may be changed to properly reference
--         code         : and connect this function to the design.  All inputs and outputs must be connected.

--         Library      :
--       declaration    : In addition to adding the instance declaration, a use statement for the XPM.vcomponents
--           for        : library needs to be added before the entity declaration.  This library contains the
--         Xilinx       : component declarations for all Xilinx XPMs.
--          XPMs        :

--  Copy the following two statements and paste them before the Entity declaration, unless they already exist.

Library xpm;
use xpm.vcomponents.all;

--********************************************************************************************************


entity ROM is
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
end ROM;

architecture Behavioral of ROM is

begin


--********************************************************************************************************

-- <--Cut the following instance declaration and paste it into the architecture statement part of the design-->

-- xpm_memory_sprom: Single Port ROM
-- Xilinx Parameterized Macro, Version 2017.4
xpm_memory_sprom_inst : xpm_memory_sprom
  generic map (

    -- Common module generics
    MEMORY_SIZE             => 16384,--8192,            --positive integer
    MEMORY_PRIMITIVE        => "auto",          --string; "auto", "distributed", or "block";
    MEMORY_INIT_FILE        => "BootMe3O.mem",--"SimBooter.mem",--"YOLOS.mem",--"l_0O.mem",--"BootME.mem",--          --string; "none" or "<filename>.mem" 
    MEMORY_INIT_PARAM       => "",              --string;
    USE_MEM_INIT            => 1,               --integer; 0,1
    WAKEUP_TIME             => "disable_sleep", --string; "disable_sleep" or "use_sleep_pin" 
    MESSAGE_CONTROL         => 0,               --integer; 0,1
    ECC_MODE                => "no_ecc",        --string; "no_ecc", "encode_only", "decode_only" or "both_encode_and_decode" 
    AUTO_SLEEP_TIME         => 0,               --Do not ChangewF
    MEMORY_OPTIMIZATION     => "true",          --string; "true", "false" 

    -- Port A module generics
    READ_DATA_WIDTH_A       => 16,              --positive integer
    ADDR_WIDTH_A            => 10,               --positive integer
    READ_RESET_VALUE_A      => "0",             --string
    READ_LATENCY_A          => 0                --non-negative integer
  )
  port map (

    -- Common module ports
    sleep                   => '0',

    -- Port A module ports
    clka                    => clka,
    rsta                    => rsta,
    ena                     => ena,
    regcea                  => '1',--regcea,
    addra                   => addra,
    injectsbiterra          => '0',   --do not change
    injectdbiterra          => '0',   --do not change
    douta                   => douta,
    sbiterra                => open,  --do not change
    dbiterra                => open   --do not change
  );

-- End of xpm_memory_sprom_inst instance declaration


--********************************************************************************************************



end Behavioral;
