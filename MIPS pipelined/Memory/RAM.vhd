----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:40:6 05/04/2024 
-- Design Name: 
-- Module Name:    data_memory - Behavioral 
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
use work.comp.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_memory is
port(
 data_memory_ADDR: in std_logic_vector(data_addr_size-1 downto 0); -- Address to write/read data_memory
 data_memory_DATA_IN: in std_logic_vector(data_size-1 downto 0); -- Data to write into data_memory
 data_memory_WR: in std_logic; -- Write enable 
 data_memory_RD: in std_logic; -- Read enable 
 data_memory_CLOCK: in std_logic; -- clock input for data_memory
 data_memory_DATA_OUT: out std_logic_vector(data_size-1 downto 0) -- Data output of data_memory
);
end data_memory;

architecture Behavioral of data_memory is

type data_memory_ARRAY is array (0 to 2**data_addr_size-1 ) of std_logic_vector (data_size-1 downto 0); --64 words
-- initial values in the data_memory
signal data_memory: data_memory_ARRAY := (
    x"00000000", x"00000001", x"00000002", x"00000003", 
    x"00000004", x"00000005", x"00000006", x"00000007", 
    x"00000008", x"00000009", x"0000001A", x"0000000B", 
    x"0000000C", x"0000000D", x"EEEEEEEE", x"0000000F", 
    x"00000010", x"00000011", x"00000012", x"00000013",
    others => (others => '0')
);
	
signal DATA_OUT: std_logic_vector(data_size-1 downto 0) := (others=>'0');
begin


process(data_memory_WR, data_memory_RD, data_memory_ADDR, data_memory_DATA_IN )
begin
 
 if(data_memory_WR='1' and data_memory_RD='0' ) then -- when write enable = 1, 
 -- write input data into data_memory at the provided address
	data_memory(to_integer(unsigned(data_memory_ADDR))) <= data_memory_DATA_IN;
	Data_out <= (data_size-1 => '1' ,others =>'Z'); --MSB is '1' for the SKP instruction
 -- The index of the data_memory array type needs to be integer so
 -- converts data_memory_ADDR from std_logic_vector -> Unsigned -> Interger using numeric_std library
 elsif(data_memory_RD='1' and data_memory_WR='0') then -- when write enable = 1, 
 -- write input data into data_memory at the provided address
	DATA_OUT <= data_memory(to_integer(unsigned(data_memory_ADDR))); 
 --end if;
 else
	Data_out <= (data_size-1 => '1' ,others =>'Z');
 end if;
end process;
 -- Data to be read out 
 data_memory_DATA_OUT <= DATA_OUT;


end Behavioral;

