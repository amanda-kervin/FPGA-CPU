----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2024 05:56:16 PM
-- Design Name: 
-- Module Name: Decoder - Behavioral
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

entity Decoder is
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
end Decoder;

architecture Behavioral of Decoder is
    --signal ALUmode: STD_LOGIC_VECTOR (3 downto 0);
    --signal IXread1: STD_LOGIC_VECTOR (2 downto 0);
    --signal IXread2: STD_LOGIC_VECTOR (2 downto 0);
    --signal DR2C: STD_LOGIC_VECTOR (16 downto 0);
    --signal RA: STD_LOGIC_VECTOR (2 downto 0);
    --signal MEMopr,WBopr: STD_LOGIC;
begin

process(IDC_Instr_I)--, MEMopr,WBopr)
begin
        --setting every output to zero so that each case only updates required signals away from 0
    case(IDC_Instr_I(15 downto 9)) is 
    --NULL
    when "0000000" =>
        IDC_IXread1_O <= "000";
        IDC_IXread2_O <= "000";
        IDC_ALUmode_O <= '0'&IDC_Instr_I(11 downto 9);
        IDC_DR1sel_O <= "00";
        IDC_DR2C_O <= (16 downto 0 => '0');
        IDC_DR2sel_O <= '0';
        IDC_RA_O <= "000";
        IDC_WBenable_O <= '0';
        IDC_OUTen_O <= '0';
        IDC_Opcode_O <= (6 downto 0 => '0');
        IDC_DISP_O <= (15 downto 0 => '0');
        IDC_MEMopr_O <= "00";
        IDC_BUBBLE_O <= '0';
        --RB <= (16 downto 0 => '00000000000000000');
    --A1    
    when "0000001" | "0000010" | "0000011" | "0000100" =>
        IDC_IXread1_O <= IDC_Instr_I(5 downto 3);   --******
        IDC_IXread2_O <= IDC_Instr_I(2 downto 0);   --******
        IDC_ALUmode_O <= '0'&IDC_Instr_I(11 downto 9);
        IDC_DR1sel_O <= "00";
        IDC_DR2C_O <= (16 downto 0 => '0');
        IDC_DR2sel_O <= '0';
        IDC_RA_O <= IDC_Instr_I(8 downto 6);        --******
        IDC_WBenable_O <= '1';                      --******
        IDC_OUTen_O <= '0';
        IDC_Opcode_O <= (6 downto 0 => '0');
        IDC_DISP_O <= (15 downto 0 => '0');
        IDC_MEMopr_O <= "00";
        IDC_BUBBLE_O <= '0';
        
     --A2
     when "0000101" | "0000110" =>
        IDC_IXread1_O <= IDC_Instr_I(8 downto 6);               --******
        IDC_IXread2_O <= "000";
        IDC_ALUmode_O <= '0'&IDC_Instr_I(11 downto 9);
        IDC_DR1sel_O <= "00";
        IDC_DR2C_O <= "0000000000000" & IDC_Instr_I(3 downto 0);--******
        IDC_DR2sel_O <= '1';                                    --******     
        IDC_RA_O <= IDC_Instr_I(8 downto 6);                    --******
        IDC_WBenable_O <= '1';                                  --******
        IDC_OUTen_O <= '0';
        IDC_Opcode_O <= (6 downto 0 => '0');
        IDC_DISP_O <= (15 downto 0 => '0');
        IDC_MEMopr_O <= "00";
        IDC_BUBBLE_O <= '0';
        
     --A3 
        --(TEST)
     when "0000111"=>
        IDC_IXread1_O <= IDC_Instr_I(8 downto 6);   --******
        IDC_IXread2_O <= "000";
        IDC_ALUmode_O <= '0'&IDC_Instr_I(11 downto 9);
        IDC_DR1sel_O <= "00";
        IDC_DR2C_O <= (16 downto 0 => '0');
        IDC_DR2sel_O <= '0';
        IDC_RA_O <= "000";
        IDC_WBenable_O <= '0';
        IDC_OUTen_O <= '0';
        IDC_Opcode_O <= (6 downto 0 => '0');
        IDC_DISP_O <= (15 downto 0 => '0');
        IDC_MEMopr_O <= "00";
        IDC_BUBBLE_O <= '0';
        
        --(OUT)
     when "0100000"=>    
        IDC_IXread1_O <= IDC_Instr_I(8 downto 6);   --******                  
        IDC_IXread2_O <= "000";
        IDC_ALUmode_O <= "1000";                    --******
        IDC_DR1sel_O <= "00";
        IDC_DR2C_O <= (16 downto 0 => '0');
        IDC_DR2sel_O <= '0';
        IDC_RA_O <= "000";
        IDC_WBenable_O <= '0';
        IDC_OUTen_O <= '1';                         --******
        IDC_Opcode_O <= (6 downto 0 => '0');
        IDC_DISP_O <= (15 downto 0 => '0');
        IDC_MEMopr_O <= "00";
        IDC_BUBBLE_O <= '0';
        
        --(IN)
     when "0100001"=> 
        IDC_IXread1_O <= "000";
        IDC_IXread2_O <= "000";
        IDC_ALUmode_O <= "1000";             
        IDC_DR1sel_O <= "01";                --******
        IDC_DR2C_O <= (16 downto 0 => '0');
        IDC_DR2sel_O <= '0';
        IDC_RA_O <= IDC_Instr_I(8 downto 6);--******
        IDC_WBenable_O <= '1';              --******
        IDC_OUTen_O <= '0';
        IDC_Opcode_O <= (6 downto 0 => '0');
        IDC_DISP_O <= (15 downto 0 => '0');   
        IDC_MEMopr_O <= "00";
        IDC_BUBBLE_O <= '0';
     
     --Branch 
        --B1
     when "1000000"|"1000001"|"1000010"|"1001000"=>
        IDC_IXread1_O <= "000";
        IDC_IXread2_O <= "000";
        IDC_ALUmode_O <= "0000";                    --******
        IDC_DR1sel_O <= "00";
        IDC_DR2C_O <= (16 downto 0 => '0');
        IDC_DR2sel_O <= '0';
        IDC_RA_O <= "000";
        IDC_WBenable_O <= '0';
        IDC_OUTen_O <= '0';
        IDC_Opcode_O <= IDC_Instr_I(15 downto 9);   --******
        IDC_DISP_O <= (15 downto 9 => IDC_Instr_I(8))&IDC_Instr_I(8 downto 0);      --******
        IDC_MEMopr_O <= "00";
        IDC_BUBBLE_O <= '0';
        
        --B2
     when "1000011"|"1000100"|"1000101"|"1001001"=>
        IDC_IXread1_O <= IDC_Instr_I(8 downto 6);   --******
        IDC_IXread2_O <= "000";
        IDC_ALUmode_O <= "0000";                    --******
        IDC_DR1sel_O <= "00";
        IDC_DR2C_O <= (16 downto 0 => '0');
        IDC_DR2sel_O <= '0';
        IDC_RA_O <= "000";
        IDC_WBenable_O <= '0';
        IDC_OUTen_O <= '0';
        IDC_Opcode_O <= IDC_Instr_I(15 downto 9);   --******
        IDC_DISP_O <= (15 downto 6 => IDC_Instr_I(5))&IDC_Instr_I(5 downto 0);      --******
        IDC_MEMopr_O <= "00";
        IDC_BUBBLE_O <= '0';
        
        --B2 SUB
    when "1000110" =>
        IDC_IXread1_O <= IDC_Instr_I(8 downto 6);   --******
        IDC_IXread2_O <= "000";
        IDC_ALUmode_O <= "1000";                    --******
        IDC_DR1sel_O <= "10";                       --******
        IDC_DR2C_O <= (16 downto 0 => '0');
        IDC_DR2sel_O <= '0';
        IDC_RA_O <= "111";                          --******
        IDC_WBenable_O <= '1';                      --******
        IDC_OUTen_O <= '0';
        IDC_Opcode_O <= IDC_Instr_I(15 downto 9);   --******
        IDC_DISP_O <= (15 downto 6 => IDC_Instr_I(5))&IDC_Instr_I(5 downto 0);      --******
        IDC_MEMopr_O <= "00";
        IDC_BUBBLE_O <= '0';
        
        --Return
    when "1000111"=>
        IDC_IXread1_O <= "111";                     --******
        IDC_IXread2_O <= "000";
        IDC_ALUmode_O <= "1000";                    --******
        IDC_DR1sel_O <= "00";
        IDC_DR2C_O <= (16 downto 0 => '0');
        IDC_DR2sel_O <= '0';
        IDC_RA_O <= "000";
        IDC_WBenable_O <= '0';
        IDC_OUTen_O <= '0';
        IDC_Opcode_O <= IDC_Instr_I(15 downto 9);   --******
        IDC_DISP_O <= (15 downto 0 => '0');   
        IDC_MEMopr_O <= "00";
        IDC_BUBBLE_O <= '0';
     
     --LOAD   
     when "0010000"=>
        IDC_IXread1_O <= "000";
        IDC_IXread2_O <= IDC_Instr_I(5 downto 3);   --******
        IDC_ALUmode_O <= "0000";
        IDC_DR1sel_O <= "00";
        IDC_DR2C_O <= (16 downto 0 => '0');
        IDC_DR2sel_O <= '0';
        IDC_RA_O <= IDC_Instr_I(8 downto 6);        --******
        IDC_WBenable_O <= '1';          
        IDC_OUTen_O <= '0';
        IDC_Opcode_O <= (6 downto 0 => '0');
        IDC_DISP_O <= (15 downto 0 => '0');   
        IDC_MEMopr_O <= "10";                       --******
        IDC_BUBBLE_O <= '1';                        --******
    
    --STORE
    when "0010001"=>
        IDC_IXread1_O <= IDC_Instr_I(5 downto 3);   --******
        IDC_IXread2_O <= IDC_Instr_I(8 downto 6);   --******
        IDC_ALUmode_O <= "1000";                    --******
        IDC_DR1sel_O <= "00";
        IDC_DR2C_O <= (16 downto 0 => '0');
        IDC_DR2sel_O <= '0';
        IDC_RA_O <= "000";
        IDC_WBenable_O <= '0';
        IDC_OUTen_O <= '0';
        IDC_Opcode_O <= (6 downto 0 => '0');
        IDC_DISP_O <= (15 downto 0 => '0');   
        IDC_MEMopr_O <= "11";                       --******
        IDC_BUBBLE_O <= '0';
     
     --LOADIMM  
     when "0010010"=>
        IDC_IXread1_O <= "111";                                      --******
        IDC_IXread2_O <= "000";
        IDC_ALUmode_O <= "101"&IDC_Instr_I(8);                       --******
        IDC_DR1sel_O <= "00";
        IDC_DR2C_O <= (16 downto 8 => '0')&IDC_Instr_I(7 downto 0);  --******
        IDC_DR2sel_O <= '1';
        IDC_RA_O <= "111";                                           --******
        IDC_WBenable_O <= '1';                                       --******
        IDC_OUTen_O <= '0';
        IDC_Opcode_O <= (6 downto 0 => '0');
        IDC_DISP_O <= (15 downto 0 => '0');
        IDC_MEMopr_O <= "00";
        IDC_BUBBLE_O <= '0';
        
    --MOV
    when "0010011"=>
        IDC_IXread1_O <= IDC_Instr_I(5 downto 3);   --******    
        IDC_IXread2_O <= "000";
        IDC_ALUmode_O <= "1000";                    --******
        IDC_DR1sel_O <= "00";
        IDC_DR2C_O <= (16 downto 0 => '0');
        IDC_DR2sel_O <= '0';
        IDC_RA_O <= IDC_Instr_I(8 downto 6);        --******
        IDC_WBenable_O <= '1';
        IDC_OUTen_O <= '0';
        IDC_Opcode_O <= (6 downto 0 => '0');
        IDC_DISP_O <= (15 downto 0 => '0');
        IDC_MEMopr_O <= "00";
        IDC_BUBBLE_O <= '0';
            
     when others=>
        IDC_IXread1_O <= "000";
        IDC_IXread2_O <= "000";
        IDC_ALUmode_O <= "0000";                    --******
        IDC_DR1sel_O <= "00";
        IDC_DR2C_O <= (16 downto 0 => '0');
        IDC_DR2sel_O <= '0';
        IDC_RA_O <= "000";
        IDC_WBenable_O <= '0';
        IDC_OUTen_O <= '0';
        IDC_Opcode_O <= (6 downto 0 => '0');
        IDC_DISP_O <= (15 downto 0 => '0');
        IDC_MEMopr_O <= "00";
        IDC_BUBBLE_O <= '0';
     end case;   
end process;
        
end Behavioral;
