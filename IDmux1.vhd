----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2024 03:28:34 PM
-- Design Name: 
-- Module Name: IDmux1 - Behavioral
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

entity IDmux1 is
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
end IDmux1;

architecture Behavioral of IDmux1 is

signal DR2S: STD_LOGIC_VECTOR (16 downto 0);

begin
process(IDM1_DR1R_I,IDM1_INport_I,IDM1_PCip1_I,IDM1_DR1sel_I,IDM1_DR2R_I,IDM1_DR2C_I,IDM1_DR2sel_I,DR2S,IDM1_MEMopr_I)
    begin
        case IDM1_DR1sel_I is
            when "01"=>
                IDM1_DR1_O <= '0'&IDM1_INport_I;
            when "10"=>
                IDM1_DR1_O <= '0'&IDM1_PCip1_I;
            when others =>
                IDM1_DR1_O <= IDM1_DR1R_I;
        end case;
        
        case IDM1_DR2sel_I is
            when '1'=>
                DR2S <= IDM1_DR2C_I;
            when others =>
                DR2S <= IDM1_DR2R_I;
                
        end case;
        
        case IDM1_MEMopr_I(1) is
            when '1'=>
                IDM1_MEMadr_O <= DR2S;
                IDM1_DR2_O <= (16 downto 0 => '0');
            when others =>
                IDM1_MEMadr_O <= (16 downto 0 => '0');
                IDM1_DR2_O <= DR2S;
        end case;
    end process;    
end Behavioral;
