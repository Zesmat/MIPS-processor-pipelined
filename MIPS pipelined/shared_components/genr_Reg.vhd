----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:24:04 03/19/2024 
-- Design Name: 
-- Module Name:    Reg - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Reg is
generic( n: integer:=4);
    Port ( Datain : in  STD_LOGIC_VECTOR (n-1 downto 0);
           Dataout : out  STD_LOGIC_VECTOR (n-1 downto 0);
           ld : in  STD_LOGIC;
           en : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end Reg;

architecture Behavioral of Reg is
signal data : STD_LOGIC_VECTOR (n-1 downto 0) := (others => '0');
begin
process(clk,reset)
begin
if reset='1' then
	data<=(others=>'0');  -- Initialize Dataout to '0' on reset
elsif(rising_edge(clk))then
	if ld ='1' then 
		data <=datain;
	end if;
--	if en='1' then 
--		dataout<=data;
--	else
--		dataout<=(others=>'Z');
--	end if;
end if;
end process;
dataout <= data;
end Behavioral;

