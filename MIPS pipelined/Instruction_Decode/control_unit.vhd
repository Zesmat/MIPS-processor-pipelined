


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity CONTROL_UNIT is
	port( 
	
		OP			: in	STD_LOGIC_VECTOR (5 downto 0); 		

		RegWrite		: out	STD_LOGIC; 				
		MemtoReg		: out	STD_LOGIC;  --write back				
		branch			: out	STD_LOGIC;
		jump 			:out STD_LOGIC;
		input_flag      :out STD_LOGIC;
		output_flag      :out STD_LOGIC;
		
		MemRead			: out	STD_LOGIC; 			
		MemWrite		: out	STD_LOGIC; 		
		
		RegDst			: out	STD_LOGIC; 				
		ALUSrc			: out	STD_LOGIC;				
		ALUOp				: out	STD_LOGIC_VECTOR(2 downto 0)
	);
end CONTROL_UNIT;


architecture behavioral of CONTROL_UNIT is  


	signal R_TYPE		: STD_LOGIC;
	signal LW		: STD_LOGIC; --lw $5, 4($2)
	signal SW		: STD_LOGIC;
	signal BEQ		: STD_LOGIC;
	signal ADDI		: STD_LOGIC; --also used for MOVE and LI 
	signal BUN 		: STD_LOGIC; 
	signal SKP 		: STD_LOGIC;
	signal INP 		: STD_LOGIC;
	signal OUTP 		: STD_LOGIC;
	
begin	

	R_TYPE <= '1' when op = "000000" else '0';  
		
	LW		<=	'1' when op = "100011" else '0';  
		
	SW		<=	'1' when op = "101000" else '0';  

	BEQ	<=	'1' when op = "000100" else '0';  

	ADDI	<= '1' when op = "001000" else '0';
	
	BUN <= '1' when op = "000101" else '0';
	
	SKP <= '1' when op = "000110" else '0';
	
	INP <= '1' when op = "000010" else '0';
	
	OUTP <= '1' when op = "000011" else '0';
	
	
	
	RegWrite	<= R_TYPE or LW or ADDI or INP;		
	MemtoReg	<= LW;		
	branch	<= BEQ or SKP;
	jump <= BUN;
	input_flag <= INP;
	output_flag <= OUTP;
	
	MemRead	<= LW or SKP;
	MemWrite	<= SW;
	
	RegDst		<= R_TYPE; --1 -> Rd  , 0->Rt
	ALUSrc		<= LW or SW or ADDI or SKP; -- 1-> immediate, 0-> regsiter
	
	
	ALUOp(0)		<= BEQ;  --ALU will sub
	ALUOp(1)		<= R_TYPE; --ALUcontrol checks function
	ALUOp(2)		<= ADDI or SKP or LW or SW; --ALU will add
			
end behavioral;