library ieee;
use ieee.std_logic_1164.all;

entity full_adder_4bit is 
port (
	in_a, in_b      	 	: in std_logic_vector (3 downto 0);  -- 4bits adder operands
	carry_in                : in std_logic;						 -- carryin
	carry_out3              : out std_logic;					 -- final carryout as output
	sum	 					: out std_logic_vector (3 downto 0)  -- final sum as output
);

end full_adder_4bit;

architecture  adder_full_4bit of full_adder_4bit is
	-- the 4bits adder is made of 4 1bit adders so we have to contain 1bit adder compounent
	component full_adder_1bit port (
		in_a, in_b      	 				: in std_logic;
		carry_in                          	: in std_logic;
		carry_out                           : out std_logic;
		sum_out 							: out std_logic
		);
	end component;
	
	
	--  internal carryouts which will be used as the carryins of each of the 1bit adders
	signal carry_out0       :std_logic;
	signal carry_out1       :std_logic;
	signal carry_out2       :std_logic;
	
	-- circuit begins
	begin

		INST1: full_adder_1bit port map(in_a(0), in_b(0), carry_in, carry_out0, sum(0));
		-- first 1bit adder add the first bits of the two inputs with the initial carryin
		-- outputs the first carryout and first bit of sum 
		--
		INST2: full_adder_1bit port map(in_a(1), in_b(1), carry_out0, carry_out1, sum(1));
		-- second 1bit adder add the second bits of the two inputs with the first carryout as the carryin for INST2
		-- outputs the second carryout and second bit of sum
		--
		INST3: full_adder_1bit port map(in_a(2), in_b(2), carry_out1, carry_out2, sum(2));
		-- third 1bit adder add the third bits of the two inputs with the second carryout as the carryin for INST3
		-- outputs the third carryout and third bit of sum
		--
		INST4: full_adder_1bit port map(in_a(3), in_b(3), carry_out2, carry_out3, sum(3));
		-- forth 1bit adder ass the forth bits of the two inputs with the third carryout as the carryin for INST4
		-- ouputs the final carryout and the forth bit of sum
		
				  
	end adder_full_4bit;