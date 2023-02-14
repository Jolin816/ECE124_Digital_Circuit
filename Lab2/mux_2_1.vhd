library ieee;
use ieee.std_logic_1164.all;

entity mux_2_1 is 
port (
	in_1, in_2							: in std_logic_vector (3 downto 0);  -- two inputs that will be selected on
	pb2									: in std_logic;						 -- 1bit selector, 1 or 0
	hex_out                             : out std_logic_vector (3 downto 0)  -- output th eselection result 
);

end mux_2_1;

architecture  mux_2_1 of mux_2_1 is

	-- circuit begins
	begin

		with pb2 select  -- select 1 or 0
		hex_out <=	in_1 when '0',  -- if pb2 is 0, then output input1
					in_2 when '1';  -- if pb2 is 1, then output input2

				  
	end mux_2_1;
