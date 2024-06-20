----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/12/2024 03:35:00 PM
-- Design Name: 
-- Module Name: IDEX_latch - Behavioral
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

entity IDEX is
    Port(
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
end IDEX;

architecture Behavioral of IDEX is

begin
process(IDEX_CLK_I)
    begin
        if(IDEX_CLK_I='1' and IDEX_CLK_I'event) then 
            if((IDEX_RST_I='1') or (IDEX_CLR_I='1')) then
                IDEX_DR1_O <= (16 downto 0 => '0');
                IDEX_DR2_O <= (16 downto 0 => '0');
                IDEX_ALUmode_O <= (3 downto 0 => '0');
                --IDEX_MEMopr_O<= '0';
                IDEX_WBenable_O<='0';
                IDEX_RA_O<=(2 downto 0 => '0');
            else
                IDEX_DR1_O <= IDEX_DR1_I;
                IDEX_DR2_O <= IDEX_DR2_I;
                IDEX_ALUmode_O <= IDEX_ALUmode_I;
                IDEX_MEMadr_O <= IDEX_MEMadr_I;
                IDEX_MEMopr_O <= IDEX_MEMopr_I;
                IDEX_WBenable_O<=IDEX_WBenable_I;
                IDEX_RA_O<=IDEX_RA_I;
            end if;
        end if;
    end process;
end Behavioral;
