library ieee;
use ieee.std_logic_1164.all;

entity mux_2_1 is 
port (
	in_1, in_2									: in std_logic_vector (3 downto 0);
	pb2											: in std_logic;
	hex_out                             : out std_logic_vector (3 downto 0)
);

end mux_2_1;

architecture  mux_2_1 of mux_2_1 is

begin

	with pb2 select
	hex_out <= in_1 when '0',
				  in_2 when '1';

				  
end mux_2_1;
