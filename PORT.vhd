----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2024 03:28:38 PM
-- Design Name: 
-- Module Name: PORT - Behavioral
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

entity IOPORT is
    Port (     
        IOPORT_IN_I : in STD_LOGIC_VECTOR (15 downto 0);
        IOPORT_OUT_I : in STD_LOGIC_VECTOR (16 downto 0);
        IOPORT_IN_O : out STD_LOGIC_VECTOR (15 downto 0);
        IOPORT_OUT_O : out STD_LOGIC_VECTOR (15 downto 0);
        IOPORT_OUTen_I : in STD_LOGIC;
        IOPORT_RST_I : in STD_LOGIC;
        IOPORT_CLK_I : in STD_LOGIC
           );
end IOPORT;

architecture Behavioral of IOPORT is

begin

process(IOPORT_CLK_I)--, MEMopr,WBopr)
begin
    if(IOPORT_CLK_I='1' and IOPORT_CLK_I'event) then
    --end if;
    --if(IOPORT_CLK_I='0' and IOPORT_CLK_I'event) then
        if(IOPORT_RST_I='1') then
            IOPORT_OUT_O <= (15 downto 0 => '0');
        elsif(IOPORT_OUTen_I='1') then
            IOPORT_OUT_O <= IOPORT_OUT_I(15 downto 0);
        end if;
    end if;
end process;        

IOPORT_IN_O <= IOPORT_IN_I;

end Behavioral;
