----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:39:38 05/04/2024 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity ALU is
  generic ( 
     constant N: natural := 1; -- number of shifted or rotated bits
	  constant Size: natural := 16  -- number of operand bits 
    );
  
    Port (
    A, B     : in  STD_LOGIC_VECTOR(Size-1 downto 0);  -- 2 inputs 
    ALU_Sel  : in  STD_LOGIC_VECTOR(3 downto 0);  -- 1 input 4-bit for selecting function
    ALU_Out   : out  STD_LOGIC_VECTOR(Size-1 downto 0); -- 1 output 
    Carryout : out std_logic;	 -- Carryout flag
	 Zero: out STD_LOGIC
    );
end ALU; 
architecture Behavioral of ALU is

signal ALU_Result : std_logic_vector (Size-1 downto 0);
signal tmp: std_logic_vector (Size downto 0);

begin
   process(A,B,ALU_Sel)
 begin
  case(ALU_Sel) is
  when "0000" => -- Addition
   ALU_Result <= A + B ; 
  when "0001" => -- Subtraction
   ALU_Result <= A - B ;
  when "0010" => -- Multiplication
   ALU_Result <= std_logic_vector(to_unsigned((to_integer(unsigned(A)) * to_integer(unsigned(B))),Size)) ;
  when "0011" => -- Division 
   ALU_Result <= A;--std_logic_vector(to_unsigned(to_integer(unsigned(A(size-1 downto 1) & 0) / to_integer(unsigned(B)),Size)) ;
  when "0100" => -- Logical shift left
   ALU_Result <= std_logic_vector(unsigned(A) sll N);
  when "0101" => -- Logical shift right
   ALU_Result <= std_logic_vector(unsigned(A) srl N);
  when "0110" => --  Rotate left
   ALU_Result <= std_logic_vector(unsigned(A) rol N);
  when "0111" => -- Rotate right
   ALU_Result <= std_logic_vector(unsigned(A) ror N);
  when "1000" => -- Logical and 
   ALU_Result <= A and B;
  when "1001" => -- Logical or
   ALU_Result <= A or B;
  when "1010" => -- Logical xor 
   ALU_Result <= A xor B;
  when "1011" => -- Logical nor
   ALU_Result <= A nor B;
  when "1100" => -- Logical nand 
   ALU_Result <= A nand B;
  when "1101" => -- Logical xnor
   ALU_Result <= A xnor B;
	
  when "1110" => -- Greater comparison
   if(A>B) then
	 ALU_Result <= (others => '0') ;
   else
    ALU_Result <= (0 => '1', others => '0');
   end if; 
	
  when "1111" => --Equal comparison   
   if(A=B) then
	 ALU_Result <= (others => '0') ;
   else
    ALU_Result <= (0 => '1', others => '0');
   end if;
  when others => ALU_Result <= A + B ; 
  end case;
 end process;
 zero <= '1' when  ALU_Result = std_logic_vector(to_unsigned(0, size)) else '0';
 ALU_Out <= ALU_Result; -- ALU out
 tmp <= ('0' & A) + ('0' & B);
 Carryout <= tmp(size); -- Carryout flag
end Behavioral;

