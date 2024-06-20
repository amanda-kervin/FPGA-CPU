----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2024 03:25:20 PM
-- Design Name: 
-- Module Name: MEMWB - Behavioral
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

entity MEMWB is
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
end MEMWB;

architecture Behavioral of MEMWB is

begin

process(MEMWB_CLK_I)
    begin
        if(MEMWB_CLK_I='1' and MEMWB_CLK_I'event) then 
            if(MEMWB_RST_I='1') then
                MEMWB_WBdata_O <= (16 downto 0 => '0');
                MEMWB_WBenable_O <= '0';
                MEMWB_RA_O <= (2 downto 0 => '0');
            else
                if MEMWB_MEMopr_I="10" then
                    MEMWB_WBdata_O <= '0' & MEMWB_LOADdata_I;
                else
                    MEMWB_WBdata_O <= MEMWB_ALUresult_I;
                end if;
                MEMWB_RA_O <= MEMWB_RA_I;
                MEMWB_WBenable_O <= MEMWB_WBenable_I;
            end if;
        end if;
    end process;

end Behavioral;
