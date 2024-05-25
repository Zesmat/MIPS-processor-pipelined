----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:46:46 05/14/2024 
-- Design Name: 
-- Module Name:    adder - Behavioral 
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

entity adder is
	generic (n: integer:=4);
    Port ( a : in  STD_LOGIC_VECTOR (n-1 downto 0);
           b : in  STD_LOGIC_VECTOR (n-1 downto 0);
           cin : in  STD_LOGIC;
           s : out  STD_LOGIC_VECTOR (n-1 downto 0);
           cout : out  STD_LOGIC);
end adder;

architecture Behavioral of adder is
component full_adder is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           cin : in  STD_LOGIC;
           s : out  STD_LOGIC;
           cout : out  STD_LOGIC);
end component;

signal c : std_logic_vector(n downto 0):= (others=>'0');
begin
generate_loop: for i in 0 to n-1 generate
fa: full_adder  port map(
	a=>a(i),
	b=>b(i),
	cin=>c(i),
	s=>s(i),
	cout=>c(i+1)
);

end generate;

cout<=c(n);
c(0)<=cin;
end Behavioral;


