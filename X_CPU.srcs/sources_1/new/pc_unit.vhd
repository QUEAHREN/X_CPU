----------------------------------------------------------------------------------
-- Project Name: X_CPU
-- Description: Program Counter unit of X_CPU
--
-- Simple black box for holding and manipulating the PC
-- 
-- Revision: 1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

library work;
use work.tpu_constants.all;

entity pc_unit is
    Port ( I_clk : in  STD_LOGIC;
           I_nPC : in  STD_LOGIC_VECTOR (15 downto 0);
           I_nPCop : in  STD_LOGIC_VECTOR (1 downto 0);
			  I_intVec: in STD_LOGIC;
           O_PC : out  STD_LOGIC_VECTOR (15 downto 0)
			  );
end pc_unit;

architecture Behavioral of pc_unit is
	signal current_pc: std_logic_vector( 15 downto 0) := ADDR_RESET;
begin

	process (I_clk)
	begin
		if rising_edge(I_clk) then
			case I_nPCop is
				when PCU_OP_NOP => 	-- NOP, keep PC the same/halt
					if I_intVec = '1' then -- in a NOP, you can get intterupts. check.
						current_pc <= ADDR_INTVEC;-- set PC to interrupt vector;
					end if;
				when PCU_OP_INC => 	-- increment
					current_pc <= std_logic_vector(unsigned(current_pc) + 2); -- BYTE ADDRESSING!
				when PCU_OP_ASSIGN => 	-- set from external input
					current_pc <= I_nPC;
				when PCU_OP_RESET => 	-- Reset
					current_pc <= ADDR_RESET;
				when others =>
			end case;
		end if;
	end process;

	O_PC <= current_pc;
	
end Behavioral;
