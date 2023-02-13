library ieee;
use ieee.std_logic_1164.all;

entity full_adder_4bit is 
port (
	in_a, in_b      	 		: in std_logic_vector (3 downto 0);
	carry_in                : in std_logic;
	carry_out3              : out std_logic;
	sum	 					   : out std_logic_vector (3 downto 0)
);

end full_adder_4bit;

architecture  adder_full_4bit of full_adder_4bit is
	component full_adder_1bit port (
		in_a, in_b      	 						: in std_logic;
		carry_in                          	: in std_logic;
		carry_out                           : out std_logic;
		sum_out 										: out std_logic
		);
	end component;
	
	
	signal carry_out0       :std_logic;
	signal carry_out1       :std_logic;
	signal carry_out2       :std_logic;
	
begin

	INST1: full_adder_1bit port map(in_a(0), in_b(0), carry_in, carry_out0, sum(0));
	INST2: full_adder_1bit port map(in_a(1), in_b(1), carry_out0, carry_out1, sum(1));
	INST3: full_adder_1bit port map(in_a(2), in_b(2), carry_out1, carry_out2, sum(2));
	INST4: full_adder_1bit port map(in_a(3), in_b(3), carry_out2, carry_out3, sum(3));
		
				  
end adder_full_4bit;