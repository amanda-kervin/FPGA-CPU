----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2024 09:20:05 PM
-- Design Name: 
-- Module Name: ForwardingUnit - Behavioral
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

entity ForwardingUnit is
    Port ( 
        FU_Read1_I : in STD_LOGIC_VECTOR(2 downto 0);
        FU_Read2_I : in STD_LOGIC_VECTOR(2 downto 0);
        FU_ExRA_I : in STD_LOGIC_VECTOR(2 downto 0);
        FU_ExWBen_I : in STD_LOGIC;
        FU_MemRA_I : in STD_LOGIC_VECTOR(2 downto 0);
        FU_MemWBen_I : in STD_LOGIC;
        FU_IDmux1sel_I : in STD_LOGIC_VECTOR(2 downto 0); --DR2SEL & DR1SEL(1) & DR1SEL(0)
        FU_IDmemOpr_I : in STD_LOGIC_VECTOR(1 downto 0); --YAEL HANDLE!
        FU_DR1sel_O : out STD_LOGIC_VECTOR(1 downto 0);
        FU_DR2sel_O : out STD_LOGIC_VECTOR(1 downto 0);
        FU_ADRsel_O : out STD_LOGIC_VECTOR(1 downto 0);  --YAEL HANDLE!
        FU_CLK_I,FU_RST_I,FU_CLR_I : in STD_LOGIC);
end ForwardingUnit;

architecture Behavioral of ForwardingUnit is
    
    signal ExMatch1_S,MemMatch1_S,ExMatch2_S,MemMatch2_S,ExMatchAdr_S,MemMatchAdr_S : STD_LOGIC;
    signal DR1sel_S,DR2sel_S,ADRsel_S : STD_LOGIC_VECTOR(1 downto 0);
begin

process(FU_CLK_I)
    begin
        if(FU_CLK_I='1' and FU_CLK_I'event) then 
            if((FU_RST_I='1') or (FU_CLR_I='1')) then
                FU_DR1sel_O<="00";
                FU_DR2sel_O<="00";
                FU_ADRsel_O<="00";
            else
                FU_DR1sel_O<=DR1sel_S;
                FU_DR2sel_O<=DR2sel_S;
                FU_ADRsel_O<=ADRsel_S;
            end if;
        end if;
end process;

process(FU_Read1_I,FU_Read2_I,FU_ExRA_I,FU_ExWBen_I,FU_MemRA_I,FU_MemWBen_I,FU_IDmux1sel_I,FU_IDmemOpr_I,ExMatch1_S, MemMatch1_S,ExMatch2_S, MemMatch2_S)
    begin

        -- Test for DR1 match with EX
        if ((FU_ExWBen_I='1') and (FU_IDmux1sel_I(1 downto 0)="00") and (FU_Read1_I=FU_ExRA_I)) then
            ExMatch1_S<='1';
        else
            ExMatch1_S<='0';   
        end if;

        -- Test for DR2 or ADR match with EX
        if ((FU_ExWBen_I='1') and (FU_IDmux1sel_I(2)='0') and (FU_Read2_I=FU_ExRA_I)) then
            case FU_IDmemOpr_I(1) is
                when '1' =>
                    ExMatch2_S <= '0';
                    ExMatchAdr_S <= '1';
                when others =>
                    ExMatch2_S <= '1';
                    ExMatchAdr_S <= '0'; 
            end case;
        else
            ExMatch2_S<='0';
            ExMatchAdr_S<='0';
        end if;
        
        -- Test for DR1 match with MEM
        if ((FU_MemWBen_I='1') and (FU_IDmux1sel_I(1 downto 0)="00") and (FU_Read1_I=FU_MemRA_I)) then
            MemMatch1_S<='1';
        else
            MemMatch1_S<='0';   
        end if;

        -- Test for DR2 or ADR match with MEM
        if ((FU_MemWBen_I='1') and (FU_IDmux1sel_I(2)='0') and (FU_Read2_I=FU_MemRA_I)) then
            case FU_IDmemOpr_I(1) is
                when '1' =>
                    MemMatch2_S <= '0';
                    MemMatchAdr_S <= '1';
                when others =>
                    MemMatch2_S <= '1';
                    MemMatchAdr_S <= '0'; 
            end case;
        else
            MemMatch2_S<='0';
            MemMatchAdr_S<='0';
        end if;
        
    end process;

    DR1sel_S <= ((MemMatch1_S and ExMatch1_S) xor MemMatch1_S) & ExMatch1_S;
    DR2sel_S <= ((MemMatch2_S and ExMatch2_S) xor MemMatch2_S) & ExMatch2_S;
    ADRsel_S <= ((MemMatchAdr_S and ExMatchAdr_S) xor MemMatchAdr_S) & ExMatchAdr_S;    
    
end Behavioral;