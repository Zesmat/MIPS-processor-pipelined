-- Main Register File Code


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Register_File is
	generic (
		B: integer:= 32;	 --number of register data bits
		W: integer:= 5	 --number of register address bits
		);
		Port( 
				Rd_reg1: in std_logic_vector(W-1 downto 0);
				Rd_reg2: in std_logic_vector(W-1 downto 0);
				Wrt_reg: in std_logic_vector(W-1 downto 0);
				Wrt_data: in std_logic_vector(B-1 downto 0);
				RegWrt:in std_logic;
				Rd_data1: out std_logic_vector(B-1 downto 0);
				Rd_data2: out std_logic_vector(B-1 downto 0)
				);
end Register_File;

architecture Behavioral of Register_File is


	type reg_file_type is array(0 to 2**W-1) of std_logic_vector(B-1 downto 0); 
		-- The array has 32 registers, each register is B bits... 32 bits
			
		signal array_reg : reg_file_type := ( x"00000000", --$zero $0
														  x"11111111", --$at $1
														  x"22222222", --$v0 $2
														  x"33333333", --$v1 $3
														  x"44444444", --$a0 $4
														  x"55555555", --$a1 $5
														  x"66666666", --$a2 $6
														  x"77777777", --$a3 $7
													     x"00000008", --$t0 $8
														  x"99999999", --$t1 $9
														  x"00000002", --$t2 $10
														  x"0000000b", --$t3 $11
														  x"0000000c", --$t4 $12
														  x"cccccccc", --$t5 $13
														  x"0000000a", --$t6 $14
														  x"0000000b", --$t7 $15
														  x"00000000", --$s0 $16
														  x"11111111", --$s1 $17
														  x"22222222", --$s2
														  x"33333333", --$s3
														  x"44444444", --$s4
														  x"55555555", --$s5
														  x"66666666", --$s6
														  x"77777777", --$s7
													     x"88888888", --$t8
														  x"99999999", --$t9
														  x"aaaaaaaa", --$k0
														  x"bbbbbbbb", --$k1
														  x"10008000", --$gp
														  x"7FFFF1EC", --$sp
														  x"eeeeeeee", --$fp
														  x"ffffffff" --$ra
														  );


begin
	process(RegWrt, Wrt_reg, wrt_data) -- pulse on write
	begin
		if( RegWrt = '1') then
			array_reg(to_integer(unsigned(Wrt_reg))) <= Wrt_data; --Wrt_reg is used as an index
		end if;
	end process;
	
	--read port
	Rd_data1 <= array_reg(to_integer(unsigned(Rd_reg1)));
   Rd_data2 <= array_reg(to_integer(unsigned(Rd_reg2)));

			
end Behavioral;