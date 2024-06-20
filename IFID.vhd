----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2024 02:37:22 PM
-- Design Name: 
-- Module Name: IFID - Behavioral
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

entity IFID is
    Port ( 
        IFID_InstrROM_I,IFID_InstrRAM_I : in STD_LOGIC_VECTOR(15 downto 0);
        IFID_InstrSEL_I: in STD_LOGIC;
        IFID_Instr_O : out STD_LOGIC_VECTOR(15 downto 0);
        IFID_INport_I : in STD_LOGIC_VECTOR(15 downto 0);
        IFID_INport_O : out STD_LOGIC_VECTOR(15 downto 0);
        --IFID_PCip1_I : in STD_LOGIC_VECTOR(15 downto 0);
        --IFID_PCip1_O : out STD_LOGIC_VECTOR(15 downto 0);
        IFID_CLR_I,IFID_CLK_I,IFID_RST_I : in STD_LOGIC);
end IFID;

architecture Behavioral of IFID is

begin

process(IFID_CLK_I)
    begin
        if(IFID_CLK_I='1' and IFID_CLK_I'event) then 
            if((IFID_RST_I='1') or (IFID_CLR_I='1')) then
                IFID_Instr_O <= (15 downto 0 => '0');
                IFID_INport_O <= (15 downto 0 => '0');
            else
                IFID_INport_O<=IFID_INport_I;
                case IFID_InstrSEL_I is
                    when '1' =>
                        IFID_Instr_O <= IFID_InstrRAM_I;
                    when others =>
                        IFID_Instr_O <= IFID_InstrROM_I;
                    end case;
                --IFID_PCip1_O <= IFID_PCip1_I;
            end if;
        end if;
    end process;

end Behavioral;
