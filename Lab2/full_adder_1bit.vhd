library ieee;
use ieee.std_logic_1164.all;

entity full_adder_1bit is 
port (
	in_a, in_b      	 						: in std_logic;
	carry_in                          	: in std_logic;
	carry_out                           : out std_logic;
	sum_out 										: out std_logic
);

end full_adder_1bit;

architecture  adder_full_1bit of full_adder_1bit is
	
begin
	carry_out <= ((in_a AND in_b) OR (carry_in AND (in_a XOR in_b)));
	sum_out   <= (carry_in XOR (in_a XOR in_b));
				  
end adder_full_1bit;