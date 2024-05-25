----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:18:26 05/19/2024 
-- Design Name: 
-- Module Name:    MIPS_Processor - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use work.comp.all;

entity MIPS_Processor is
    port (
        clk : in std_logic;
        reset : in std_logic;
		  input: in std_logic_vector(data_size-1 downto 0);
		  output: out std_logic_vector(data_size-1 downto 0)
    );
end MIPS_Processor;

architecture Behavioral of MIPS_Processor is

    -- IF stage signals
    signal IF_instruction : std_logic_vector(inst_size-1 downto 0) := (others => 'Z');
    signal IF_pc_out : std_logic_vector(inst_addr_size-1 downto 0);

    -- ID stage signals
	 
  
    signal ID_MemtoReg : std_logic;
    signal ID_RegWrite : std_logic;
    signal ID_branch : std_logic;
	 
    signal ID_jump : std_logic;
	 signal ID_jump_target : std_logic_vector(inst_addr_size-1 downto 0);
	
    signal ID_MemRead : std_logic;
    signal ID_MemWrite : std_logic;
	 signal ID_input_flag : STD_LOGIC;
	 signal ID_output_flag : STD_LOGIC;
    signal ID_ALUSrc : std_logic;
    signal ID_ALUOp : std_logic_vector(2 downto 0);
    signal ID_funct : std_logic_vector(5 downto 0);
    signal ID_Rd_data1 : std_logic_vector(data_size-1 downto 0);
    signal ID_Rd_data2 : std_logic_vector(data_size-1 downto 0);
    signal ID_sign_ext_imm : std_logic_vector(data_size-1 downto 0);
    signal ID_pc_incremented_out : std_logic_vector(inst_addr_size-1 downto 0);
    signal ID_wrt_reg_out : std_logic_vector(4 downto 0);

    -- EX stage signals
    signal EX_ALU_result : std_logic_vector(data_size-1 downto 0);
    signal EX_zero_flag : std_logic;
    signal EX_Rd_data2_out : std_logic_vector(data_size-1 downto 0);
    signal EX_branch_target : std_logic_vector(inst_addr_size-1 downto 0);
    signal EX_branch_out : std_logic;
    signal EX_MemRead_out : std_logic;
    signal EX_MemWrite_out : std_logic;
	 signal EX_input_flag : STD_LOGIC;
	 signal EX_output_flag : STD_LOGIC;
    signal EX_RegWrite_out : std_logic;
    signal EX_MemtoReg_out : std_logic;
    signal EX_wrt_reg_out : std_logic_vector(4 downto 0);

    -- MEM stage signals
    signal MEM_Mem_data_out : std_logic_vector(data_size-1 downto 0);
    signal MEM_ALU_result_out : std_logic_vector(data_size-1 downto 0);
	 signal MEM_Rd_data2_out : std_logic_vector(data_size-1 downto 0);
    signal MEM_wrt_reg_out : std_logic_vector(4 downto 0);
    signal MEM_MemtoReg_out : std_logic;
	 signal MEM_input_flag : STD_LOGIC;
	 signal MEM_output_flag : STD_LOGIC;
    signal MEM_RegWrite_out : std_logic;
    signal MEM_branch_out : std_logic;

    -- WB stage signals
    signal WB_wrt_data_out : std_logic_vector(data_size-1 downto 0);
    signal WB_wrt_reg_out : std_logic_vector(4 downto 0);
    signal WB_RegWrite_out : std_logic;

    -- Control signals
    signal PCSrc : std_logic;
	 signal reset_in: std_logic;

begin
		
	 -- Control Signal for PCSrc
    PCSrc <= MEM_branch_out;
	 reset_in <= reset or MEM_branch_out; --pipeline registers are reset if branch is taken
	 
    -- Instruction Fetch Stage
    IF_stage: entity work.InstructionFetch
        port map (
				--inputs
            clk => clk,
            reset =>  reset_in,
            PCSrc => PCSrc, --from and gate
            branch_target => EX_branch_target,
				jump => ID_jump,
				jump_target => ID_jump_target,
				--outputs
            instruction => IF_instruction,
            pc_out => IF_pc_out
        );

    -- Instruction Decode Stage
    ID_stage: entity work.InstructionDecode
        port map (
				--inputs
            clk => clk,
            reset =>  reset_in,
            instruction => IF_instruction,
            pc_out => IF_pc_out,
            wrt_data_in => WB_wrt_data_out,
            wrt_reg_in => WB_wrt_reg_out,
            RegWriteWB => WB_RegWrite_out,
				--outputs
            MemtoReg => ID_MemtoReg,
            RegWrite => ID_RegWrite,
            branch => ID_branch,
				jump => ID_jump,
				jump_target => ID_jump_target,
            MemRead => ID_MemRead,
            MemWrite => ID_MemWrite,
				input_flag => ID_input_flag,
				output_flag => ID_output_flag,
            ALUSrc => ID_ALUSrc,
            ALUOp => ID_ALUOp,
            funct => ID_funct,
            Rd_data1 => ID_Rd_data1,
            Rd_data2 => ID_Rd_data2,
            sign_ext_imm => ID_sign_ext_imm,
            pc_incremented_out => ID_pc_incremented_out,
            wrt_reg_out => ID_wrt_reg_out
        );
	output <= MEM_Rd_data2_out when MEM_output_flag = '1' else (others => 'Z'); 
    -- Execution Stage
    EX_stage: entity work.Execution
        port map (
				--inputs
            clk => clk,
            reset =>  reset, --MEM_branch_out not connected as it's an output of this stage so the pipeline register shouldn't be reset
            MemtoReg => ID_MemtoReg,
            RegWrite => ID_RegWrite,
            branch => ID_branch,
            MemRead => ID_MemRead,
            MemWrite => ID_MemWrite,
				input_flag => ID_input_flag,
				output_flag => ID_output_flag,
            ALUSrc => ID_ALUSrc,
            ALUOp => ID_ALUOp,
            funct => ID_funct,
            Rd_data1 => ID_Rd_data1,
            Rd_data2 => ID_Rd_data2,
            sign_ext_imm => ID_sign_ext_imm,
            pc_incremented_out => ID_pc_incremented_out,
            wrt_reg_in => ID_wrt_reg_out,
				--outputs
            ALU_result => EX_ALU_result,
            zero_flag => EX_zero_flag,
            Rd_data2_out => EX_Rd_data2_out,
            branch_target => EX_branch_target, --to fetch
            branch_out => EX_branch_out,
            MemRead_out => EX_MemRead_out,
            MemWrite_out => EX_MemWrite_out,
				input_flag_out => EX_input_flag,
				output_flag_out => EX_output_flag,
            RegWrite_out => EX_RegWrite_out,
            MemtoReg_out => EX_MemtoReg_out,
            wrt_reg_out => EX_wrt_reg_out
        );

    -- Memory Stage
    MEM_stage: entity work.MEM_Stage
        port map (
				--inputs
            clk => clk,
            reset =>  reset_in,
            zero_flag_in => EX_zero_flag,
            MemRead_in => EX_MemRead_out,
            MemWrite_in => EX_MemWrite_out,
				input_flag => EX_input_flag,
				output_flag => EX_output_flag,
            Rd_data2_in => EX_Rd_data2_out,
            ALU_result_in => EX_ALU_result,
            wrt_reg_in => EX_wrt_reg_out,
            branch_in => EX_branch_out,
            MemtoReg_in => EX_MemtoReg_out,
            RegWrite_in => EX_RegWrite_out,
				--outputs
            Mem_data_out => MEM_Mem_data_out,
            ALU_result_out => MEM_ALU_result_out,
            wrt_reg_out => MEM_wrt_reg_out,
            MemtoReg_out => MEM_MemtoReg_out,
            RegWrite_out => MEM_RegWrite_out,
				input_flag_out => MEM_input_flag,
				output_flag_out => MEM_output_flag,
				Rd_data2_out => MEM_Rd_data2_out,
            branch_out => MEM_branch_out --to fetch
        );

    -- Write Back Stage
    WB_stage: entity work.WriteBack
        port map (
				--inputs
				clk => clk,
            reset => reset_in,
            Mem_data_in => MEM_Mem_data_out,
            ALU_result_in => MEM_ALU_result_out,
            wrt_reg_in => MEM_wrt_reg_out,
            MemtoReg_in => MEM_MemtoReg_out,
            RegWrite_in => MEM_RegWrite_out,
				input_flag => MEM_input_flag,
				input => input,
				--outputs
            wrt_reg_out => WB_wrt_reg_out,
            wrt_data_out => WB_wrt_data_out,
            RegWrite_out => WB_RegWrite_out
        );

  

end Behavioral;
