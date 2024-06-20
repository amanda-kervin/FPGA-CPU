----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2024 03:49:08 PM
-- Design Name: 
-- Module Name: RegisterFile - Behavioral
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

entity RegisterFile is
    Port ( IDR_RA_I : in STD_LOGIC_VECTOR(2 downto 0);
           IDR_WBdata_I : in STD_LOGIC_VECTOR(16 downto 0);
           IDR_WBenable_I : in STD_LOGIC;
           IDR_IXread1_I : in STD_LOGIC_VECTOR(2 downto 0);
           IDR_IXread2_I : in STD_LOGIC_VECTOR(2 downto 0);
           IDR_CLK_I : in STD_LOGIC;
           IDR_RST_I : in STD_LOGIC;
           IDR_DR1R_O : out STD_LOGIC_VECTOR(16 downto 0);
           IDR_DR2R_O : out STD_LOGIC_VECTOR(16 downto 0);
           IDR_TestReg0_O : out STD_LOGIC_VECTOR(16 downto 0);
           IDR_TestReg1_O : out STD_LOGIC_VECTOR(16 downto 0);
           IDR_TestReg2_O : out STD_LOGIC_VECTOR(16 downto 0);
           IDR_TestReg3_O : out STD_LOGIC_VECTOR(16 downto 0);
           IDR_TestReg4_O : out STD_LOGIC_VECTOR(16 downto 0);
           IDR_TestReg5_O : out STD_LOGIC_VECTOR(16 downto 0);
           IDR_TestReg6_O : out STD_LOGIC_VECTOR(16 downto 0);
           IDR_TestReg7_O : out STD_LOGIC_VECTOR(16 downto 0)
           );

end RegisterFile;

architecture Behavioral of RegisterFile is

type reg_array is array (integer range 0 to 7) of std_logic_vector(16 downto 0);
--internals signals
signal reg_file : reg_array; begin
--write operation 
process(IDR_CLK_I)

begin
   if(IDR_CLK_I='0' and IDR_CLK_I'event) then if(IDR_RST_I='1') then
      for i in 0 to 7 loop
         reg_file(i)<= (16 downto 0 => '0'); 
      end loop;
   elsif(IDR_WBenable_I='1') then
      case IDR_RA_I(2 downto 0) is
      when "000" => reg_file(0) <= IDR_WBdata_I;
      when "001" => reg_file(1) <= IDR_WBdata_I;
      when "010" => reg_file(2) <= IDR_WBdata_I;
      when "011" => reg_file(3) <= IDR_WBdata_I;
      when "100" => reg_file(4) <= IDR_WBdata_I;
      when "101" => reg_file(5) <= IDR_WBdata_I;
      when "110" => reg_file(6) <= IDR_WBdata_I;
      when "111" => reg_file(7) <= IDR_WBdata_I;
      
      when others => NULL; end case;
    end if; 
    end if;
end process;

--read operation
IDR_DR1R_O <=	
reg_file(0) when(IDR_IXread1_I="000") else
reg_file(1) when(IDR_IXread1_I="001") else
reg_file(2) when(IDR_IXread1_I="010") else
reg_file(3) when(IDR_IXread1_I="011") else
reg_file(4) when(IDR_IXread1_I="100") else
reg_file(5) when(IDR_IXread1_I="101") else
reg_file(6) when(IDR_IXread1_I="110") else
reg_file(7);

IDR_DR2R_O <=	
reg_file(0) when(IDR_IXread2_I="000") else
reg_file(1) when(IDR_IXread2_I="001") else
reg_file(2) when(IDR_IXread2_I="010") else
reg_file(3) when(IDR_IXread2_I="011") else
reg_file(4) when(IDR_IXread2_I="100") else
reg_file(5) when(IDR_IXread2_I="101") else
reg_file(6) when(IDR_IXread2_I="110") else
reg_file(7);


--*********BRENTS TESTING**********
IDR_TestReg0_O<=reg_file(0);
IDR_TestReg1_O<=reg_file(1);
IDR_TestReg2_O<=reg_file(2);
IDR_TestReg3_O<=reg_file(3);
IDR_TestReg4_O<=reg_file(4);
IDR_TestReg5_O<=reg_file(5);
IDR_TestReg6_O<=reg_file(6);
IDR_TestReg7_O<=reg_file(7);

end Behavioral;
