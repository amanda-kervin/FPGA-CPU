----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2024 03:57:34 PM
-- Design Name: 
-- Module Name: ShiftRegister - Behavioral
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

entity ShiftRegister is
    Port ( 
        SR_BUBBLE_I : in STD_LOGIC;
        SR_CLKen_O : out STD_LOGIC;
        SR_CLK_I : in STD_LOGIC;
        SR_RST_I,SR_CLR_I: in STD_LOGIC
    );
end ShiftRegister;


architecture Behavioral of ShiftRegister is

signal shiftReg1_S : STD_LOGIC;
signal shiftReg2_S : STD_LOGIC;

begin

process(SR_CLK_I)
begin
    if(SR_CLK_I='1' and SR_CLK_I'event) then
        if((SR_RST_I='1') or (SR_CLR_I='1')) then
            shiftReg2_S <= '0';
        else
            shiftReg2_S <= shiftReg1_S;
        end if;
    end if;
end process;

process(SR_BUBBLE_I,SR_RST_I,SR_CLR_I)
begin
    if((SR_RST_I='1') or (SR_CLR_I='1')) then
        shiftReg1_S <= '0';
    else
        shiftReg1_S <= SR_BUBBLE_I;
    end if;
end process;

    SR_CLKen_O<=not(shiftReg1_S or shiftReg2_S);

end Behavioral;
