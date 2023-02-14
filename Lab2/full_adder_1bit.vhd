-- Author: Group 9, Jolin Xie, Molly Huang

library ieee;
use ieee.std_logic_1164.all;

entity full_adder_1bit is 
port (
	in_a, in_b      	 				: in std_logic;  -- two operands
	carry_in                          	: in std_logic;  -- carry in
	carry_out                           : out std_logic; -- carryout as output
	sum_out 							: out std_logic  -- sum as output
);

end full_adder_1bit;

architecture  adder_full_1bit of full_adder_1bit is

-- circuits begin
begin
	-- According to the schemetic form of 1bit adder:
	-- 1. inputA AND inputB = result1
	-- 2. inputA XOR inputB = result2
	-- 3. carryin XOR result2 = result3
	-- 4. carryin AND result2 = result4
	-- 5. result1 OR result4 = result5
	carry_out <= ((in_a AND in_b) OR (carry_in AND (in_a XOR in_b)));
	-- carry_out is result5
	sum_out   <= (carry_in XOR (in_a XOR in_b));
	-- sum_out is result3
				  
end adder_full_1bit;