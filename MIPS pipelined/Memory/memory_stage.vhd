library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.comp.all;

entity MEM_Stage is
    port (
        clk : in std_logic;
        reset : in std_logic;
        
        -- Inputs from EX/MEM pipeline register
		  --memory stage (current)
        zero_flag_in : in std_logic; --MEM (current)
		  MemRead_in : in std_logic; --MEM (current)
        MemWrite_in : in std_logic; --MEM (current)
		  Rd_data2_in : in std_logic_vector(data_size-1 downto 0); --MEM (current)
		  --write-back stage
        ALU_result_in : in std_logic_vector(data_size-1 downto 0); --WB
        wrt_reg_in : in std_logic_vector(4 downto 0); --WB
        branch_in : in std_logic; --WB
        MemtoReg_in : in std_logic; --WB
        RegWrite_in : in std_logic; --WB
		  input_flag :in STD_LOGIC; --WB
		  output_flag :in STD_LOGIC;
        
        -- Outputs to MEM/WB pipeline register
		  Rd_data2_out : out std_logic_vector(data_size-1 downto 0);
        Mem_data_out : out std_logic_vector(data_size-1 downto 0); --WB
        ALU_result_out : out std_logic_vector(data_size-1 downto 0); --WB
        wrt_reg_out : out std_logic_vector(4 downto 0); --WB
        MemtoReg_out : out std_logic; --WB
        RegWrite_out : out std_logic; --WB
		  input_flag_out :out STD_LOGIC; --WB
		  branch_out: out std_logic; --directly to Fetch stage
        output_flag_out :out STD_LOGIC
       
    );
end MEM_Stage;

architecture Behavioral of MEM_Stage is

    signal data_memory_data_out : std_logic_vector(data_size-1 downto 0);

begin
--branch instructions : branch if alu result = 0 (BEQ) OR content of memory is positive (SKP)
	branch_out <= (branch_in and zero_flag_in) or (branch_in and not data_memory_data_out(data_size-1)) ; 

    -- Instantiate the data memory
    data_mem_inst: entity work.data_memory
        port map (
            data_memory_ADDR => ALU_result_in(data_addr_size-1 downto 0),
            data_memory_DATA_IN => Rd_data2_in, -- write data
            data_memory_WR => MemWrite_in,
            data_memory_RD => MemRead_in,
            data_memory_CLOCK => clk,
            data_memory_DATA_OUT => data_memory_data_out --Read data
        );

     -- MEM/WB Pipeline Register instance
    MEM_WB_Pipeline_Reg: entity work.Reg
        generic map(n => 3 * data_size + 5 + 4) 
        port map (
            -- Control signals
            Datain(0) => MemtoReg_in,
            Datain(1) => RegWrite_in,
            Datain(2) => input_flag, -- Added input_flag
            -- Data signals
            Datain(2 + data_size downto 3) => data_memory_data_out,
            Datain(2 + 2 * data_size downto 3 + data_size) => ALU_result_in,
            Datain(2 + 2 * data_size + 5 downto 3 + 2 * data_size) => wrt_reg_in,
				Datain(2 + 2 * data_size + 6) => output_flag,
				Datain( 2 + 3* data_size + 6 downto 2 + 2 * data_size + 7) => Rd_data2_in,
            -- Outputs
            Dataout(0) => MemtoReg_out,
            Dataout(1) => RegWrite_out,
            Dataout(2) => input_flag_out, 
            Dataout(2 + data_size downto 3) => Mem_data_out,
            Dataout(2 + 2 * data_size downto 3 + data_size) => ALU_result_out,
            Dataout(2 + 2 * data_size + 5 downto 3 + 2 * data_size) => wrt_reg_out,
				Dataout(2 + 2 * data_size + 6) => output_flag_out,
				Dataout( 2 + 3* data_size + 6 downto 2 + 2 * data_size + 7) => Rd_data2_out,
            -- Pipeline register control signals
            ld => '1',
            en => '1',
            clk => clk,
            reset => reset
        );

end Behavioral;
