----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/05/2024 04:36:35 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( 
           EX_DR1_I : in STD_LOGIC_VECTOR(16 downto 0);
           EX_DR2_I : in STD_LOGIC_VECTOR(16 downto 0);
           EX_ALUmode_I : in STD_LOGIC_VECTOR(3 downto 0);
           EX_ALUresult_O : out STD_LOGIC_VECTOR(16 downto 0);
           EX_Z_O,EX_N_O,EX_V_O : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
    signal result: STD_LOGIC_VECTOR (16 downto 0);
--    signal result32: STD_LOGIC_VECTOR (31 downto 0);
begin

process(EX_ALUmode_I, EX_DR1_I, EX_DR2_I, result)
begin

    case(EX_ALUmode_I) is
    --when "001" =>
    --    result <= std_logic_vector( signed(EX_DR1_I) + signed(EX_DR2_I) );

    -- NOP   
    when "0000" =>
        result <= (16 downto 0 => '0');
        
    -- ADD
    when "0001" =>
        result <= std_logic_vector( signed(EX_DR1_I) + signed(EX_DR2_I) );
    
    -- SUB
    when "0010" =>
        result <=  std_logic_vector( signed(EX_DR1_I) - signed(EX_DR2_I) );
    
    -- MUL
    when "0011" =>
        result <= std_logic_vector(to_signed(to_integer(signed(EX_DR1_I))*to_integer(signed(EX_DR2_I)), 17));
        --add code that sets the 17th bit to 1 if any overflow is detected
    
    -- NAND
    when "0100" =>
        result <= (EX_DR1_I NAND EX_DR2_I);
    
    -- SHL
    when "0101" =>
        result <= std_logic_vector(shift_left( signed(EX_DR1_I) , to_integer( signed(EX_DR2_I) ) ) ) ;
    
    -- SHR
    when "0110" =>
        result <= std_logic_vector(shift_right( signed(EX_DR1_I) , to_integer( signed(EX_DR2_I) ) ) );
    
    -- TEST
    when "0111" =>
    --a<=update this
        result <= EX_DR1_I;
        
        if (result(15) = '1') then
            EX_N_O <= '1';
        else
            EX_N_O <= '0';
        end if;
        
        if (result(15 downto 0) = "0000000000000000") then
            EX_Z_O <= '1';
        else
            EX_Z_O <= '0';
        end if;
        
        if (result(16) /= result(15)) then
            EX_V_O <= '1';
        else
            EX_V_O <= '0';
        end if;
    
    --PASS THROUGH
    when "1000" =>
        result <= EX_DR1_I;    
    
    --REPLACE LOWER   
    when "1010" =>
        result <= EX_DR1_I(16 downto 8) & EX_DR2_I(7 downto 0); 
    
    --REPLACE UPPER    
    when "1011" =>
        result <= '0'&EX_DR2_I(7 downto 0) & EX_DR1_I(7 downto 0);   
        
    when others =>
        result <= (16 downto 0 => '0');
    end case;
            
end process;

EX_ALUresult_O <= result;
        
end Behavioral;