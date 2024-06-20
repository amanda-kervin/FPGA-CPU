----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:58:47 03/04/2015 
-- Design Name: 
-- Module Name:    SegDisplay - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- CLKbrd is the 50Mhz system clock FPGA pin B8
-- RST is is FPGA pin B18
--MEM_Hex3_I, MEM_Hex2_I,MEM_Hex1_I and MEM_Hex0_I are four bit arrays used to store hex display character
--an (an0,an1, an2, an3) four bit array that connect to the display transistors
--sseg 7bit array that stores the individual segments of the hex display
-- refer to ucf file and Nexys2 manual

entity SegDisplay is
	port(
		CLKbrd, RST: in std_logic;
		MEM_Hex3_I, MEM_Hex2_I, MEM_Hex1_I, MEM_Hex0_I: in std_logic_vector(3 downto 0);
		MEM_AN_O: out std_logic_vector(3 downto 0);
		MEM_Sseg_O: out std_logic_vector(6 downto 0)
	);
end SegDisplay;

-- This architecture below describes the behavior of the multiplexer using its individual processes as well as
-- its seven-segment decoder to display numbers on the anodes using cathodes. 

architecture arch of SegDisplay is 
	
	-- each 7-seg led enabled (2^18/4)*25 ns (40 ms)
	constant N: integer:=18;
	
	-- These signals are operations within the FPGA that help the processes overall but that we cannot see.
	--q_reg and q_next are 18 bit arrays, in this application N=18
        --sel is a 2 bit array that selects the hex display
        --hex is a 4 bit array the contains the hex value to be displayed

	signal q_reg, q_next: unsigned(17 downto 0);
	signal sel: std_logic_vector(1 downto 0);
	signal hex: std_logic_vector(3 downto 0);


begin

	-- This process controls the RST button of the clock.

	process(CLKbrd, RST)
	begin
		if RST='1' then                       --If button pressed all  bits in q_reg set to 0
			q_reg <= (others=>'0');
		elsif (CLKbrd'event and CLKbrd='1') then       --If clock is rising q_next assigned to q_reg
			q_reg <= q_next;
		end if;
	end process;
	
	-- State logic for the counter                  --Increment q_reg and assign to q_next
	q_next <= q_reg + 1;
	
	-- 2 MSBs of counter to control 4-to-1 multiplexing 
	--assign bits17 and 16 to sel array
        sel <= std_logic_vector(q_reg(17 downto 16));   
	
	-- This is the 2:4 decoder, which converts a two-bit input into a four-bit input for the seven-segment decoder.
	
        --The value in the sel array will determine which of the Case statements is selected. Since 
        -- the sel array is two bits then there are only four possible cases 0,1,2,3.
        --The value in MEM_AN_O will determine which transistor is turned on that selects one of four hex
        --displays.
        --The MEM_Hex0_I, MEM_Hex1_I, MEM_Hex2_I, and MEM_Hex3_I value comes from the Counter.vhd file

	process(sel, MEM_Hex0_I, MEM_Hex1_I, MEM_Hex2_I, MEM_Hex3_I)
	begin
		case sel is
			when "00" =>
				MEM_AN_O <= "1110";
				hex <= MEM_Hex0_I;
			when "01" =>
				MEM_AN_O <= "1101";
				hex <= MEM_Hex1_I;
			when "10" =>
				MEM_AN_O <= "1011";
				hex <= MEM_Hex2_I;
			when others =>
				MEM_AN_O <= "0111";
				hex <= MEM_Hex3_I;
				
		end case;
	end process;
	
	-- The value that was assigned to the hex array is used to assign the MEM_Sseg_O array. Example: If   
        -- the hex array contained the value 1001 (9) then the MEM_Sseg_O array would be assigned the 
        -- value 0010000 which would display a 9 on the selected hex display. See reference 
        --if needed
	
	with hex select
		MEM_Sseg_O(6 downto 0) <=
			"1000000" when "0000", -- 0
			"1111001" when "0001", -- 1
			"0100100" when "0010", -- 2
			"0110000" when "0011", -- 3
			"0011001" when "0100", -- 4
			"0010010" when "0101", -- 5
			"0000010" when "0110", -- 6
			"1111000" when "0111", -- 7
			"0000000" when "1000", -- 8
			"0010000" when "1001", -- 9
			"0001000" when "1010", -- A, which signifies "10"
			"0000011" when "1011", -- B, which signifies "11"
			"1000110" when "1100", -- C, which signifies "12"
			"0100001" when "1101", -- D, which signifies "13"
			"0000110" when "1110", -- E, which signifies "14"
			"0001110" when others;  -- F, which signifies "15"
			

end arch;
				
