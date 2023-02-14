library ieee;
use ieee.std_logic_1164.all;

entity logic_processor is 
port (
	logic_in0,logic_in1 				: in std_logic_vector (3 downto 0);  -- two logical operands as inputs
	mux_select                          : in std_logic_vector (1 downto 0);  -- the selector
	logic_out                           : out std_logic_vector (3 downto 0)  -- output of the operation result
);

end logic_processor;

architecture  process_logic of logic_processor is

	-- circuit begin
	begin
		with mux_select(1 downto 0) select  -- 2bits selector, there are 4 possible combinations
		logic_out <= (logic_in0 AND logic_in1)  when "00",  -- if selector is 00 then do AND operation for two inputs
					 (logic_in0 OR logic_in1)   when "01",  -- if selector is 01 then do OR operation for two inputs
					 (logic_in0 XOR logic_in1)  when "10",  -- if selector is 10 then do XOR operation for two inputs
					 (logic_in0 XNOR logic_in1) when "11";  -- if selector is 11 then do XNOR operation for two inputs
					 
				  
	end process_logic;
