library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.comp.all;

entity Execution is
    port (
        clk : in std_logic;
        reset : in std_logic;
        -- Inputs from ID/EX pipeline register
		
         --Control signals (except Regdst)
		  --from previous stage (Instruction Decode)
        MemtoReg : in std_logic; --WB
		  RegWrite : in std_logic; --WB
		  input_flag :in STD_LOGIC; --WB
		  output_flag :in STD_LOGIC;
		  
        branch : in std_logic; --MEM
        MemRead : in std_logic; --MEM
        MemWrite : in std_logic; --MEM 
		  
        ALUSrc : in std_logic; --EX(current)(a5erha hna)
        ALUOp : in std_logic_vector(2 downto 0); --EX(current)
   
		  funct: in std_logic_vector(5 downto 0); --EX(current)
        Rd_data1 : in std_logic_vector(data_size-1 downto 0); --EX(current)
        Rd_data2 : in std_logic_vector(data_size-1 downto 0); --EX(current), MEM
        sign_ext_imm : in std_logic_vector(data_size-1 downto 0); --EX(current)
		  pc_incremented_out: in std_logic_vector(inst_addr_size-1 downto 0); --EX(current) 
		  wrt_reg_in: in std_logic_vector(4 downto 0); --WB 	 
		  
        -- Outputs to EX/MEM pipeline register
        ALU_result : out std_logic_vector(data_size-1 downto 0); --MEM
        zero_flag : out std_logic; --MEM
        Rd_data2_out : out std_logic_vector(data_size-1 downto 0); --MEM
		  branch_target: out std_logic_vector(inst_addr_size-1 downto 0); --directly to Fetch stage 
		  branch_out : out std_logic; --MEM
		  MemRead_out : out std_logic; --MEM
        MemWrite_out : out std_logic; --MEM
		  RegWrite_out : out std_logic; --WB
		  MemtoReg_out : out std_logic; --WB
		  input_flag_out :out STD_LOGIC; --WB
		  wrt_reg_out: out std_logic_vector(4 downto 0);--WB
		  output_flag_out :out STD_LOGIC
		   
		  
    );
end Execution;

architecture Behavioral of Execution is
    -- Intermediate signals
    signal ALU_in2 : std_logic_vector(data_size-1 downto 0);
    signal ALU_control : std_logic_vector(3 downto 0);
    signal ALU_zero : std_logic;
	 signal local_ALU_result : std_logic_vector(data_size-1 downto 0);
	 signal adder_out : std_logic_vector(inst_addr_size-1 downto 0);
	 signal adder_in2 : std_logic_vector(inst_addr_size-1 downto 0);
	 
	 
	 
	 
begin  
	--add 1 to pc_incremented_out if SKP instruction, else add immediate to pc_incremented_out
	adder_in2 <= x"1" when ALUOp = "100" else  sign_ext_imm(inst_addr_size-1 downto 0);
	--Adder to calculate branch target
	calc_target_branch: entity work.adder
		 generic map(n => inst_addr_size)
        port map (
            a => pc_incremented_out,
            b => adder_in2, --*****
            cin => '0',  
            s => adder_out,
            cout => open
        );
    -- ALU source selection MUX
    ALU_Src_MUX: entity work.MUX
        generic map(n => data_size)
        port map (
            mux_in0 => Rd_data2,
            mux_in1 => sign_ext_imm,
            mux_sel => ALUSrc,
            mux_out => ALU_in2
        );

    -- Instantiate the ALU Control Unit
    ALU_Control_Unit: entity work.ALU_CONTROL
        port map (
            FUNCT => funct,
            ALU_OP_IN => ALUOp,
            ALU_IN => ALU_control
        );

    -- Instantiate the ALU
    ALU_inst: entity work.ALU
        generic map(Size => data_size)
        port map (
            A => Rd_data1,
            B => ALU_in2,
            ALU_Sel => ALU_control,
            ALU_Out => local_ALU_result,
            Zero => ALU_zero,
            Carryout => open
        );
		  
	 -- EX/MEM Pipeline Register instance
    EX_MEM_Pipeline_Reg : entity work.Reg
        generic map(n => 8 + 5 + 2*data_size + inst_addr_size) 
        port map (
            -- Control signals
            Datain(0) => MemtoReg,
            Datain(1) => RegWrite,
            Datain(2) => branch,
            Datain(3) => MemRead,
            Datain(4) => MemWrite,
            Datain(5) => ALU_zero,
            -- Data and address signals
            Datain(5 + data_size downto 6) => local_ALU_result,
            Datain(5 + 2*data_size downto 6 + data_size) => Rd_data2,
            Datain(5 + 2*data_size + inst_addr_size downto 6 + 2*data_size) => adder_out,
            Datain(5 + 2*data_size + inst_addr_size + 5 downto 6 + 2*data_size + inst_addr_size) => wrt_reg_in,
            Datain(6 + 2*data_size + inst_addr_size + 5) => input_flag,
				Datain(6 + 2*data_size + inst_addr_size + 6) => output_flag,		-- Control signal
            -- Outputs
            Dataout(0) => MemtoReg_out,
            Dataout(1) => RegWrite_out,
            Dataout(2) => branch_out,
            Dataout(3) => MemRead_out,
            Dataout(4) => MemWrite_out,
            Dataout(5) => zero_flag,
            Dataout(5 + data_size downto 6) => ALU_result,
            Dataout(5 + 2*data_size downto 6 + data_size) => Rd_data2_out,
            Dataout(5 + 2*data_size + inst_addr_size downto 6 + 2*data_size) => branch_target,
            Dataout(5 + 2*data_size + inst_addr_size + 5 downto 6 + 2*data_size + inst_addr_size) => wrt_reg_out,
            Dataout(6 + 2*data_size + inst_addr_size + 5) => input_flag_out, 
				Dataout(6 + 2*data_size + inst_addr_size + 6) => output_flag_out,
            -- Pipeline register control signals
            ld => '1',
            en => '1',
            clk => clk,
            reset => reset -- Changed from '0' to reset signal
        );

end Behavioral;