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
        FU_IDmux1sel_I : in STD_LOGIC_VECTOR(1 downto 0);
        FU_DR1sel_O : out STD_LOGIC_VECTOR(1 downto 0);
        FU_DR2sel_O : out STD_LOGIC_VECTOR(1 downto 0);
        FU_CLK_I,FU_RST_I,FU_CLR_I : in STD_LOGIC);
end ForwardingUnit;

architecture Behavioral of ForwardingUnit is
    
    signal ExMatch1_S, MemMatch1_S,ExMatch2_S, MemMatch2_S : STD_LOGIC;
    signal DR1sel_S,DR2sel_S : STD_LOGIC_VECTOR(1 downto 0);
begin

process(FU_CLK_I)
    begin
        if(FU_CLK_I='1' and FU_CLK_I'event) then 
            if((FU_RST_I='1') or (FU_CLR_I='1')) then
                FU_DR1sel_O<="00";
                FU_DR2sel_O<="00";
            else
                FU_DR1sel_O<=DR1sel_S;
                FU_DR2sel_O<=DR2sel_S;
            end if;
        end if;
end process;

process(FU_Read1_I,FU_Read2_I,FU_ExRA_I,FU_ExWBen_I,FU_MemRA_I,FU_MemWBen_I,FU_IDmux1sel_I,ExMatch1_S, MemMatch1_S,ExMatch2_S, MemMatch2_S)
    begin
        if ((FU_ExWBen_I='1') and (FU_IDmux1sel_I="00")) then
            if (FU_Read1_I=FU_ExRA_I) then
                ExMatch1_S<='1';
            else
                ExMatch1_S<='0';
            end if;
        
            if (FU_Read2_I=FU_ExRA_I) then
                ExMatch2_S<='1';
            else
                ExMatch2_S<='0';
            end if;
        else
            ExMatch1_S<='0';
            ExMatch2_S<='0';    
        end if;
        
        if ((FU_MemWBen_I='1') and (FU_IDmux1sel_I="00")) then
            if (FU_Read1_I=FU_MemRA_I) then
                MemMatch1_S<='1';
            else
                MemMatch1_S<='0';
            end if;
        
            if (FU_Read2_I=FU_MemRA_I) then
                MemMatch2_S<='1';
            else
                MemMatch2_S<='0';
            end if;    
        else
            MemMatch1_S<='0';
            MemMatch2_S<='0';
        end if;
        
    end process;

    DR1sel_S <= ((MemMatch1_S and ExMatch1_S) xor MemMatch1_S) & ExMatch1_S;
    DR2sel_S <= ((MemMatch2_S and ExMatch2_S) xor MemMatch2_S) & ExMatch2_S;
    
    
    
end Behavioral;
