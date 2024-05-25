library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.comp.all;

entity WriteBack is
    port (
			clk: in std_logic;
        reset : in std_logic;
        
        -- Inputs from MEM/WB pipeline register
        Mem_data_in : in std_logic_vector(data_size-1 downto 0); --WB (current)
        ALU_result_in : in std_logic_vector(data_size-1 downto 0); --WB (current)
        wrt_reg_in : in std_logic_vector(4 downto 0); --WB (current)
        MemtoReg_in : in std_logic; --WB (current)
        RegWrite_in : in std_logic; --WB (current)
		  input_flag :in STD_LOGIC; --WB (current)
		  
        input : in std_logic_vector(data_size-1 downto 0);
        -- Outputs to Register File (instruction decode stage)
        wrt_reg_out : out std_logic_vector(4 downto 0); --directly to Instruction Decode stage 
        wrt_data_out : out std_logic_vector(data_size-1 downto 0); --directly to Instruction Decode stage
        RegWrite_out : out std_logic --directly to Instruction Decode stage
    );
end WriteBack;

architecture Behavioral of WriteBack is
signal mux_out: std_logic_vector(data_size-1 downto 0); 
signal input_in: std_logic_vector(data_size-1 downto 0); 
begin

input_in <= input when input /= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU" else (others => '0');
    -- Instantiate the memory to register MUX
    MUX_inst: entity work.MUX
        generic map (
            N => data_size
        )
        port map (
            mux_in0 => ALU_result_in,
            mux_in1 => Mem_data_in,
            mux_sel => MemtoReg_in,
            mux_out => mux_out
        );
		  
		  -- Instantiate the input MUX
    MUX_input_inst: entity work.MUX
        generic map (
            N => data_size
        )
        port map (
            mux_in0 => mux_out,
            mux_in1 => input_in,
            mux_sel => input_flag,
            mux_out => wrt_data_out
        );


    -- Output the write register address and RegWrite signal
    wrt_reg_out <= wrt_reg_in;
    RegWrite_out <= RegWrite_in;

end Behavioral;
