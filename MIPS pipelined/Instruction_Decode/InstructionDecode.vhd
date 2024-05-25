library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.comp.all;

entity InstructionDecode is
    port (
		  clk : in std_logic;
        reset : in std_logic;
		  --from previous stage(Fetch stage)
        instruction : in std_logic_vector(inst_size-1 downto 0);
		  pc_out: in std_logic_vector(inst_addr_size-1 downto 0); 
		  
		  --from Write-Back stage
		  wrt_data_in: in std_logic_vector(data_size-1 downto 0);  
		  wrt_reg_in: in std_logic_vector(4 downto 0);  
		  RegWriteWB: in std_logic; 
     
        -- Control signals (except Regdst)
		  --to next stage (Execution)
        MemtoReg : out std_logic; --WB
		  RegWrite : out std_logic; --WB
		  input_flag :out STD_LOGIC; --WB
		  output_flag :out STD_LOGIC; -- used in top module
		  
		  ALUSrc : out std_logic; --EX
		  ALUOp : out std_logic_vector(2 downto 0); --EX
		  
        branch : out std_logic; --MEM
        MemRead : out std_logic; --MEM
        MemWrite : out std_logic; --MEM
		  
		  jump: out std_logic; --directly connected to Fetch stage
		  
		  
		 
		  
		 
		  
        
       
        -- Data outputs
		  jump_target: out std_logic_vector(inst_addr_size -1 downto 0); --directly connected to Fetch stage
		  funct: out std_logic_vector(5 downto 0); --EX
        Rd_data1 : out std_logic_vector(data_size-1 downto 0); --EX
        Rd_data2 : out std_logic_vector(data_size-1 downto 0); --EX, MEM
        sign_ext_imm : out std_logic_vector(data_size-1 downto 0); --EX
		  pc_incremented_out: out std_logic_vector(inst_addr_size-1 downto 0); --EX
		  wrt_reg_out: out std_logic_vector(4 downto 0) --mux output	WB	 
		  --output :out std_logic_vector(data_size-1 downto 0) --directly connnected to processor output
    );
end InstructionDecode;

architecture Behavioral of InstructionDecode is
    -- Intermediate signals
    signal rs : std_logic_vector(4 downto 0);
    signal rt : std_logic_vector(4 downto 0);
    signal rd : std_logic_vector(4 downto 0);
    signal immediate : std_logic_vector(15 downto 0);
    signal opcode : std_logic_vector(5 downto 0);
	 signal local_funct : std_logic_vector(5 downto 0);
    
    -- Control signals
    signal local_RegWrite : std_logic;
    signal local_MemtoReg : std_logic;
    signal local_branch : std_logic;
    signal local_MemRead : std_logic;
    signal local_MemWrite : std_logic;
    signal local_RegDst : std_logic;
    signal local_ALUSrc : std_logic;
    signal local_ALUOp : std_logic_vector(2 downto 0);
	 
	 signal local_input_flag : STD_LOGIC;
	 signal local_output_flag : STD_LOGIC;
	
	 signal mux_out : std_logic_vector(4 downto 0) := (others => '0');
    
	 --regsiters read data
	 signal local_Rd_data1 : std_logic_vector(data_size-1 downto 0);
	 signal local_Rd_data2 : std_logic_vector(data_size-1 downto 0);
	 --write register
    -- Sign-extended immediate value
    signal sign_ext_imm_internal : std_logic_vector(data_size-1 downto 0);

begin
    -- Instruction field extraction
    opcode <= instruction(31 downto 26) when instruction /= x"00000000" else "ZZZZZZ"; --to ignore initialized instruction and all 0 instructions
    rs <= instruction(25 downto 21); --Read Register 1
    rt <= instruction(20 downto 16); --Read Register 2
    rd <= instruction(15 downto 11); --Write Register
    immediate <= instruction(15 downto 0);
	 local_funct <= instruction(5 downto 0);
	 jump_target <= instruction(inst_addr_size-1 downto 0);

    -- Instantiate the Control Unit
    Control_Unit_inst : entity work.CONTROL_UNIT
        port map (
            OP => opcode,
				
            RegWrite => local_RegWrite,
            MemtoReg => local_MemtoReg,
            branch => local_branch,
				jump => jump,
				input_flag => local_input_flag,
				output_flag => local_output_flag,
            MemRead => local_MemRead,
            MemWrite => local_MemWrite,
            RegDst => local_RegDst,
            ALUSrc => local_ALUSrc,
            ALUOp => local_ALUOp
        );
		  
	--output <= local_Rd_data1 when local_output_flag = '1' else (others => 'Z'); 
		  
	 -- MUX to select between incremented PC and branch target
    Wrt_reg_MUX: entity work.Mux
        generic map(n => 5)
        port map (
            mux_in0 => rt,
            mux_in1 => rd,
            mux_sel => local_RegDst,
            mux_out => mux_out
        );

    -- Instantiate the Register File
    Register_File_inst : entity work.Register_File
        generic map (
            B => data_size,
            W => 5
        )
        port map (
            Rd_reg1 => rs,
            Rd_reg2 => rt,
            Wrt_reg => wrt_reg_in,  -- Wrt_reg is used for write-back address
            Wrt_data => Wrt_data_in, --data from write back stage
            RegWrt =>  RegWriteWB, --RegWrite from write back
            Rd_data1 => local_Rd_data1,
            Rd_data2 => local_Rd_data2
        );

    -- Instantiate the Sign Extender
    SignExtender_inst : entity work.SignExtender
        port map (
            se_in => immediate,
            se_out => sign_ext_imm_internal
        );
		  
	 -- ID/EX Pipeline Register for Contrtol signals, sign extended immediate, data read from register file, mux output, and function
    ID_EX_Pipeline_Reg : entity work.Reg
        generic map(n => 8 + 3 + 6 + 3*data_size + inst_addr_size + 5)
        port map (
            --inputs
            Datain(0) => local_MemtoReg,
				Datain(1) => local_branch,	
				Datain(2) => local_MemRead,
				Datain(3) => local_MemWrite,
				Datain(4) => local_ALUSrc,
				Datain(5) => local_RegWrite,
				Datain(6) => local_input_flag,
				Datain(9 downto 7) => local_ALUOp,
				Datain(15 downto 10) => local_funct,
				Datain(20 downto 16) => mux_out,
				
				Datain(21 + data_size - 1 downto 21) => local_Rd_data1,
				Datain(21 + 2*data_size - 1 downto 21 + data_size) => local_Rd_data2,
				Datain(21 + 3*data_size - 1 downto 21 + 2*data_size) => sign_ext_imm_internal,
				Datain(21 + 3*data_size + inst_addr_size - 1 downto 21 + 3*data_size) => pc_out,
				
				Datain(21 + 3*data_size + inst_addr_size) => local_output_flag,
				--outputs
            Dataout(0) => MemtoReg,
				Dataout(1) => branch,	
				Dataout(2) => MemRead,
				Dataout(3) => MemWrite,
				Dataout(4) => ALUSrc,
				Dataout(5) => RegWrite,
				Dataout(6) => input_flag,
				Dataout(9 downto 7) => ALUOp,
				Dataout(15 downto 10) => funct,
				Dataout(20 downto 16) => wrt_reg_out,
				
				Dataout(21 + data_size - 1 downto 21) => Rd_data1,
				Dataout( 21 + 2*data_size - 1 downto 21 + data_size) => Rd_data2,
				Dataout(21 + 3*data_size - 1 downto 21 + 2*data_size) => sign_ext_imm,
				Dataout(21 + 3*data_size + inst_addr_size - 1 downto 21 + 3*data_size) => pc_incremented_out,
				
				Dataout(21 + 3*data_size + inst_addr_size) => output_flag,
				
            ld => '1',
            en => '1',
            clk => clk,
            reset => reset
        );


end Behavioral;