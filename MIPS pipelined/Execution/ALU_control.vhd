----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:22:57 05/18/2024 
-- Design Name: 
-- Module Name:    ALU_control - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.all;		
use IEEE.numeric_std.all;


entity ALU_CONTROL is
	port(
		
			FUNCT		:	in STD_LOGIC_VECTOR(5 downto 0);	
			ALU_OP_IN	:	in STD_LOGIC_VECTOR(2 downto 0);			
		   ALU_IN		:	out STD_LOGIC_VECTOR(3 downto 0)						
	);
end ALU_CONTROL;

architecture behavioral of ALU_CONTROL is
begin
	process(FUNCT, ALU_OP_IN)
	begin
		case ALU_OP_IN is
			when "010" =>  -- R-type instructions
				case FUNCT is
					when "100000" => ALU_IN <= "0000"; -- ADD
					when "100010" => ALU_IN <= "0001"; -- SUB
					when "011000" => ALU_IN <= "0010"; -- MUL
					when "011010" => ALU_IN <= "0011"; -- DIV
					when "000000" => ALU_IN <= "0100"; -- SLL
					when "000010" => ALU_IN <= "0101"; -- SRL
					when "000100" => ALU_IN <= "0110"; -- ROL
					when "000110" => ALU_IN <= "0111"; -- ROR
					when "100100" => ALU_IN <= "1000"; -- AND
					when "100101" => ALU_IN <= "1001"; -- OR
					when "100110" => ALU_IN <= "1010"; -- XOR
					when "100111" => ALU_IN <= "1011"; -- NOR
					when "101000" => ALU_IN <= "1100"; -- NAND
					when "101001" => ALU_IN <= "1101"; -- XNOR
					--when "000001" => ALU_IN <= "0000"; -- MOVE (equivalent to ADD with zero offset)  --addi $5, $7, 0
					when others => ALU_IN <= "0000"; -- Default to ADD
				end case;
				
			--when "000" => ALU_IN <= "0000"; -- ADD (for LW, SW)
			when "001" => ALU_IN <= "0001"; -- SUB (for BEQ)
			--ADD for (ADDI)
			when others => ALU_IN <= "0000"; -- Default to ADD
		end case;
	end process;
--	ALU_IN(0) <= ALU_OP_IN(1) and ( FUNCT(0) or FUNCT(3) );
--	ALU_IN(1) <= (not ALU_OP_IN(1)) or (not FUNCT(2));
--	ALU_IN(2) <= ALU_OP_IN(0) or ( ALU_OP_IN(1) and FUNCT(1) );
--	ALU_IN(3) <= ALU_OP_IN(2);

end behavioral;

