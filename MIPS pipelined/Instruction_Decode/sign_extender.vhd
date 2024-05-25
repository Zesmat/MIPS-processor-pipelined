----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:06:40 05/04/2024 
-- Design Name: 
-- Module Name:    SignExtender - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SignExtender is
    Port ( se_in : in  STD_LOGIC_VECTOR (15 downto 0);-- 16 bit in
           se_out : out  STD_LOGIC_VECTOR (31 downto 0)); -- 32 bit out
end SignExtender;

architecture Behavioral of SignExtender is

begin
	se_out<= x"0000" & se_in when se_in(15) ='0' else
				x"FFFF" & se_in;


end Behavioral;