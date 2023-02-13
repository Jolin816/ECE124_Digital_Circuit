library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab2_top is port (
   clkin_50			: in	std_logic;
	pb_n				: in	std_logic_vector(3 downto 0);
 	sw   				: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds				: out std_logic_vector(7 downto 0); -- for displaying the switch content
   seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  	: out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  	: out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab2_top;

architecture SimpleCircuit of LogicalStep_Lab2_top is
--
-- Components Used ---
------------------------------------------------------------------- 
   component SevenSegment port (
   hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   );
	end component;
	
	component segment7_mux port (
			clk 				: in std_logic := '0';
			DIN2 				: in std_logic_vector (6 downto 0);
			DIN1 				: in std_logic_vector (6 downto 0);
			DOUT 				: out std_logic_vector(6 downto 0);
			DIG2				: out std_logic;
			DIG1				: out std_logic
	);
	end component;
	
	component PB_Inverters port (
		pb_n : IN std_logic_vector(3 downto 0);
		pb   : OUT std_logic_vector(3 downto 0)
	);
	end component;
	
	component logic_processor port (
	logic_in0,logic_in1 						: in std_logic_vector (3 downto 0);
	mux_select                          : in std_logic_vector (1 downto 0);
	logic_out                           : out std_logic_vector (3 downto 0)
	);
	end component;
	
	component full_adder_4bit port (
	
		in_a, in_b      	 		: in std_logic_vector (3 downto 0);
		carry_in                : in std_logic;
		carry_out3              : out std_logic;
		sum	 					   : out std_logic_vector (3 downto 0)
	);
	end component;
	
	component mux_2_1 port (
		in_1, in_2									: in std_logic_vector (3 downto 0);
		pb2											: in std_logic;
		hex_out                             : out std_logic_vector (3 downto 0)
	);
	end component;
	
-- Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--
	signal seg7_A				: std_logic_vector(6 downto 0);
	signal hex_A				: std_logic_vector(3 downto 0);
	signal hex_B 				: std_logic_vector(3 downto 0);
	signal seg7_B 				: std_logic_vector(6 downto 0); 
	signal pb 					: std_logic_vector(3 downto 0);
	signal hex_sum_4bit		: std_logic_vector(3 downto 0);
	signal carry_out_signal : std_logic;
	signal signal_C			: std_logic_vector(3 downto 0);
	signal mux_1				: std_logic_vector(3 downto 0);
	signal mux_2				: std_logic_vector(3 downto 0);
	
	
	
-- Here the circuit begins

begin

	hex_A <= sw(3 downto 0);
	hex_B <= sw(7 downto 4);
	signal_C <= "000" & carry_out_signal;
	
	INST1: SevenSegment port map(mux_2, seg7_B);
	INST2: SevenSegment port map(mux_1, seg7_A);
	INST3: segment7_mux port map(clkin_50, seg7_A, seg7_B, seg7_data, seg7_char1, seg7_char2);
	INST4: PB_Inverters  port map(pb_n, pb);
	INST5: logic_processor port map(hex_A, hex_B, pb(1 downto 0), leds(3 downto 0));
	INST6: full_adder_4bit port map(hex_A, hex_B, '0', carry_out_signal, hex_sum_4bit);
	INST7: mux_2_1 port map(hex_B, signal_C, pb(2), mux_1);
	INST8: mux_2_1 port map(hex_A, hex_sum_4bit, pb(2), mux_2);
 
 
end SimpleCircuit;

