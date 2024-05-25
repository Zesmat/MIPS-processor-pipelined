----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:18:26 05/19/2024 
-- Design Name: 
-- Module Name:    instruction_fetch - Behavioral 
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
use work.comp.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstructionFetch is
    port (
			
        clk : in std_logic;
        reset : in std_logic;
		  --from Memory stage
        PCSrc : in std_logic; --MUX select 1 -> branch, 0-> next instruction (from and gate)
		  jump: in std_logic; 
		  jump_target : in std_logic_vector(inst_addr_size-1 downto 0); 
        branch_target : in std_logic_vector(inst_addr_size-1 downto 0); 
		  --to Instruction Decode stage
        instruction : out std_logic_vector(inst_size-1 downto 0);
        pc_out : out std_logic_vector(inst_addr_size-1 downto 0)
    );
end InstructionFetch;

architecture Behavioral of InstructionFetch is
    signal mux1_out : std_logic_vector(inst_addr_size-1 downto 0) := (others => '0');
	 signal mux2_out : std_logic_vector(inst_addr_size-1 downto 0) := (others => '0');
	 
    signal adder_out : std_logic_vector(inst_addr_size-1 downto 0):= (others => '0');
    signal pc_reg_out : std_logic_vector(inst_addr_size-1 downto 0):= (others => '0');
    signal instruction_mem_out : std_logic_vector(inst_size-1 downto 0):= (others => 'Z');
	 
	 signal instruction_out : std_logic_vector(inst_size-1 downto 0);
	 
	 signal adder_in2: std_logic_vector(inst_addr_size-1 downto 0);

begin
    -- Program Counter Register
    PC_Reg: entity work.Reg(Behavioral) 
        generic map(n => inst_addr_size)
        port map (
            Datain => mux2_out,
            Dataout => pc_reg_out,
            ld => '1',
            en => '1',
            clk => clk,
            reset => '0'
        );
	-- Add 1 to PC if PC <= 14 (PC limit is 15), else Add 0
	adder_in2 <= (0 => '1', others => '0') when pc_reg_out < x"F" else (others => '0');
    -- Adder to increment PC by 1
    PC_Adder: entity work.adder(Behavioral)
        generic map(n => inst_addr_size)
        port map (
            a => pc_reg_out,
            b => adder_in2, 
            cin => '0',
            s => adder_out,
            cout => open
        );

    -- MUX to select between incremented PC and branch target
    PC_MUX1: entity work.Mux(Behavioral)
        generic map(n => inst_addr_size)
        port map (
            mux_in0 => adder_out,
            mux_in1 => branch_target,
            mux_sel => PCSrc,
            mux_out => mux1_out
        );
	-- MUX to select between output of PC_MUX1 and jump target
	 PC_MUX2: entity work.Mux(Behavioral)
        generic map(n => inst_addr_size)
        port map (
            mux_in0 => mux1_out,
            mux_in1 => jump_target,
            mux_sel => jump,
            mux_out => mux2_out
        );


    -- Instruction Memory
    Inst_Mem: entity work.Instruction_Memory(Behavioral)
        port map (
            pc => pc_reg_out,
            instruction => instruction_mem_out
        );
	instruction_out <= (others=>'0') when jump = '1' else instruction_mem_out; 
    -- IF/ID Pipeline Register for PC and Instruction
    IF_ID_Pipeline_Reg: entity work.Reg(Behavioral)
        generic map(n => inst_addr_size + inst_size)
        port map (
            Datain(inst_size + inst_addr_size - 1 downto inst_addr_size) => instruction_out, --Instruction
            Datain(inst_addr_size-1 downto 0) => adder_out, -- PC+1
				
            Dataout(inst_size + inst_addr_size - 1 downto inst_addr_size) => instruction, -- Instruction
            Dataout(inst_addr_size-1 downto 0) => pc_out, -- PC
            ld => '1',
            en => '1',
            clk => clk,
            reset => reset
        );

end Behavioral;