----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:54:17 05/04/2024 
-- Design Name: 
-- Module Name:    MUX - Behavioral 
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

entity MUX is
    Generic (
        N: integer :=32
        );
    Port( mux_in0 :in STD_LOGIC_VECTOR(N-1 downto 0);
            mux_in1 :in STD_LOGIC_VECTOR(N-1 downto 0);
            mux_sel :in STD_LOGIC;
            mux_out :out STD_LOGIC_VECTOR(N-1 downto 0)
            );
end MUX;


architecture Behavioral of MUX is

begin
    mux_out<= mux_in0 when mux_sel = '0' else 
                 mux_in1;

end Behavioral;