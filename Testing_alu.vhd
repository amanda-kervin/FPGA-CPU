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

entity Testing_alu is
    Port ( 
           EX_DR1_I : in STD_LOGIC_VECTOR(15 downto 0);
           EX_DR2_I : in STD_LOGIC_VECTOR(15 downto 0);
           --EX_ALUmode_I : in STD_LOGIC_VECTOR(2 downto 0);
           --CLK_IN: in STD_LOGIC;
           EX_AR_O : out STD_LOGIC_VECTOR(15 downto 0)
           --EX_Z_O,EX_N_O : out STD_LOGIC
           );
end Testing_alu;

architecture Behavioral of Testing_alu is
    --signal result: STD_LOGIC_VECTOR (15 downto 0);
begin

--process(EX_ALUmode_I, EX_DR1_I, EX_DR2_I, result)
--begin
    -- ADD
    --case(EX_ALUmode_I) is
    --when "001" =>
    --    result <= std_logic_vector( signed(EX_DR1_I) + signed(EX_DR2_I) );
    --when others =>
    --    result <= (15 downto 0=>'0');
    --end case;
    EX_AR_O <= std_logic_vector( signed(EX_DR1_I) + signed(EX_DR2_I) );
--end process;
    --EX_AR_O<=result;
        
end Behavioral;

-- multiply:
if(("0000000000000001" AND EX_DR1_I) = "0000000000000001") then
            result <= std_logic_vector(signed(EX_DR1_I));
        else
            result <= (15 downto 0 => '0');  
        end if;
        if(("0000000000000010" AND EX_DR1_I) = "0000000000000010") then
            result <= std_logic_vector(signed(result) + shift_left(signed(EX_DR1_I), 1));
        end if;
        if(("0000000000000100" AND EX_DR1_I) = "0000000000000100") then
            result <= std_logic_vector(signed(result) + shift_left(signed(EX_DR1_I), 2));
        end if;
        if(("0000000000001000" AND EX_DR1_I) = "0000000000001000") then
            result <= std_logic_vector(signed(result) + shift_left(signed(EX_DR1_I), 3));
        end if;
        if(("0000000000010000" AND EX_DR1_I) = "0000000000010000") then
            result <= std_logic_vector(signed(result) + shift_left(signed(EX_DR1_I), 4));
        end if;
        if(("0000000000100000" AND EX_DR1_I) = "0000000000100000") then
            result <= std_logic_vector(signed(result) + shift_left(signed(EX_DR1_I), 5));
        end if;
        if(("0000000001000000" AND EX_DR1_I) = "0000000001000000") then
            result <= std_logic_vector(signed(result) + shift_left(signed(EX_DR1_I), 6));
        end if;    
        if(("0000000010000000" AND EX_DR1_I) = "0000000010000000") then
            result <= std_logic_vector(signed(result) + shift_left(signed(EX_DR1_I), 7));
        end if;
        if(("0000000100000000" AND EX_DR1_I) = "0000000100000000") then
            result <= std_logic_vector(signed(result) + shift_left(signed(EX_DR1_I), 8));
        end if;
        if(("0000001000000000" AND EX_DR1_I) = "0000001000000000") then
            result <= std_logic_vector(signed(result) + shift_left(signed(EX_DR1_I), 9));
        end if;
        if(("0000010000000000" AND EX_DR1_I) = "0000010000000000") then
            result <= std_logic_vector(signed(result) + shift_left(signed(EX_DR1_I), 10));
        end if;
        if(("0000100000000000" AND EX_DR1_I) = "0000100000000000") then
            result <= std_logic_vector(signed(result) + shift_left(signed(EX_DR1_I), 11));
        end if;
        if(("0001000000000000" AND EX_DR1_I) = "0001000000000000") then
            result <= std_logic_vector(signed(result) + shift_left(signed(EX_DR1_I), 12));
        end if;
        if(("0010000000000000" AND EX_DR1_I) = "0010000000000000") then
            result <= std_logic_vector(signed(result) + shift_left(signed(EX_DR1_I), 13));
        end if;
        if(("0100000000000000" AND EX_DR1_I) = "0100000000000000") then
            result <= std_logic_vector(signed(result) + shift_left(signed(EX_DR1_I), 14));
        end if;
        if(("1000000000000000" AND EX_DR1_I) = "1000000000000000") then
            result <= std_logic_vector(signed(result) + shift_left(signed(EX_DR1_I), 15));
        end if;
