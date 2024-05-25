----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:56:09 05/12/2024 
-- Design Name: 
-- Module Name:    Instruction_memory - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  
use work.comp.all;


-- VHDL code for the Instruction Memory of the MIPS Processor
entity Instruction_Memory is

port (
 pc: in std_logic_vector(inst_addr_size-1 downto 0);
 instruction: out  std_logic_vector(inst_size-1 downto 0)
);
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is


 type ROM_type is array (0 to 2**inst_addr_size - 1 ) of std_logic_vector(inst_size-1 downto 0);
 constant rom_data: ROM_type:=(
 
--"000000 00101 00001 00010 00111 000000", R type
--"000011 00000 01001 0000000000000000", I type
--"100000 0000000000000000000000 1011", J type
-- MUL: R type---MOV,SKP,INP,OUTP: I type, BUN: J type 
	
	"00001000000010000000000000000000", --INP R0 === INP $8 
	"10001101010010010000000000000001", --MOV R0, M0 === lw $9, 1($10) 	
	"00001000000010110000000000000000", --INP R1 === INP $11
	"10001101100011010000000000000010", --MOV R1,M1 === lw $13 , 2($12)
	"00000001110011110111000000011000", --MUL M0, R1 === mul $14, $14, $15  
	"10001110000000010000000000000100", --MOV R1,M2 === lw $1 , 4($16) 
   "00011010000000000000000000000100", --SKP M2 === SKP 4($16)
   "00010100000000000000000000001010", --BUN Negative === BUN 10
   "00001100000010010000000000000000", --OUT R1 == OUTP $9
   "00010100000000000000000000001011", --BUN End === BUN 11 
   "00001100000010000000000000000000", --Negative: OUT R1 === OUTP $8  (Negative = 10)
   "00010100000000000000000000001011", --End: BUN End === BUN 11     (End = 11)
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
	"00000000000000000000000000000000",
   "00000000000000000000000000000000" --!!
	
	
--	  "00010100000000000000000000000011", --BUN 3  (j 3)  
--	  "00000000100001010001000000011000", --mul $2, $4, $5   
--	  "00000000110000110000100111100000", --add $1, $6, $3 
--	  "10001101000001110000000000000010", --lw $7, 2($8)
--	  "00100000000010010000000000001110", --addi $9, $0, 14 == li $9, 14 
--	  "10100001011010100000000000000100", --sw $10, 4($11)  

--   "00100001111011100000000000000000", --addi $14, $15, 0 == move $14, $15
--   "00011010000000000000000000000100", --SKP 4($16)
--   "00000000110000110000100111100000", --add $1, $6, $3 
--   "00000000100001010001000000011000", --mul $2, $4, $5   
--   "00001000000100010000000000000000", --INP $17
--   "00001110010000000000000000000000", --OUTP $18
--   "00000000000000000000000000000000",
--   "00000000000000000000000000000000",
--	  "00010001100011011111111111111101", --beq $12, $13, -3 
--   "00000000000000000000000000000000" --!!
	
	
  );
begin

  instruction <= rom_data(to_integer(unsigned(pc))) when pc <= x"F"  else (others =>'0'); --pc limit = 15

end Behavioral;
