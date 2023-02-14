-- Author: Group 9, Jolin Xie, Molly Huang

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab2_top is port (
	clkin_50					 : in	std_logic;							
	pb_n						 : in	std_logic_vector(3 downto 0);
 	sw   						 : in   std_logic_vector(7 downto 0);  -- The switch inputs
	led							 : out  std_logic_vector(7 downto 0);  -- for displaying the switch content
	seg7_data 					 : out  std_logic_vector(6 downto 0);  -- 7-bit outputs to a 7-segment
	seg7_char1  				 : out	std_logic;				       -- seg7 digit1 selector
	seg7_char2  				 : out	std_logic				       -- seg7 digit2 selector
	
); 
end LogicalStep_Lab2_top;

architecture SimpleCircuit of LogicalStep_Lab2_top is
--
-- Components Used ---
------------------------------------------------------------------- 

   -- SevenSegment Components, used later to convert the 4bit data to the 7-segment
   component SevenSegment port (
   		hex   				: in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   		sevenseg 			: out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   );
	end component;

	-- segment7_mux Components
	component segment7_mux port (
		clk					 : in std_logic := '0';
		DIN2 				 : in std_logic_vector (6 downto 0);
		DIN1 			   	 : in std_logic_vector (6 downto 0);
		DOUT 			  	 : out std_logic_vector(6 downto 0);
		DIG2				 : out std_logic;
		DIG1			 	 : out std_logic
	);
	end component;
	
	-- PB inverter Component, used later to be the selector in the logic_processer
	component PB_Inverters port (
		pb_n 				 : IN std_logic_vector(3 downto 0);	-- 4bits pbinput 
		pb   			     : OUT std_logic_vector(3 downto 0)  -- 4bits NOT pb_n
	);
	end component;
	
	-- A multiplexer to implement the leds on FPGA board. 
	-- There are two inputs which is from the board switches, 
	-- if the selector pb1 and pb0 are 00, then the two inputs do AND
	-- if the selector pb1 and pb0 are 01, then the two inputs do OR
	-- if the selector pb1 and pb0 are 10, then the two inputs do XOR
	-- if the selector pb1 and pb0 are 11, then the two inputs do XNOR
	-- after the logic operation, the output will be the logic_out(4bits)
	component logic_processor port (
		logic_in0,logic_in1 	: in std_logic_vector (3 downto 0);  -- two 4bit logic inputs for the later operation
		mux_select              : in std_logic_vector (1 downto 0);  -- 2bits selector determine which operation will be use
		logic_out               : out std_logic_vector (3 downto 0)  -- 4bit output after the operation is done
	);
	end component;
	
	-- A 4bit adder component
	-- in_a and in_b are two 4bits operands
	-- the initial carryin is 0 because no operation has been done
	-- the sum is the output which will be displayed on the FPGA board
	-- this 4bits adder are made up with 4 1bitadders
	component full_adder_4bit port (
		in_a, in_b      	 	: in std_logic_vector (3 downto 0);  -- 4bits operands
		carry_in             	: in std_logic;						 -- initial carryin (0)
		carry_out3           	: out std_logic;					 -- the carry_out signal, will be used for concatenation 
		sum	 				 	: out std_logic_vector (3 downto 0)  -- the final output of the sum of two inputs
	);
	end component;
	
	-- A 2 to 1 multoplexer
	-- two inputs in1 and in2
	-- a pb2 selecter (1 or 0)
	-- the output will depend on the pb2
	component mux_2_1 port (
		in_1, in_2		: in std_logic_vector (3 downto 0);  -- two inputs, one for the 7segment display, one for the sum display
		pb2				: in std_logic;						 -- pb2 controller
		hex_out         : out std_logic_vector (3 downto 0)  -- final display signal on the FPGA board
	);
	end component;
	
--  Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--
	signal hex_A				: std_logic_vector(3 downto 0);  -- 4bits hex_A input 
	signal hex_B 				: std_logic_vector(3 downto 0);  -- 4bits hex_B input
	signal seg7_A				: std_logic_vector(6 downto 0);  -- 7bits A output for 7segment display
	signal seg7_B 				: std_logic_vector(6 downto 0);  -- 7bits B output for 7segment display
	signal pb 					: std_logic_vector(3 downto 0);  -- 4bits pb switch
	signal hex_sum_4bit		    : std_logic_vector(3 downto 0);  -- 4bits sum
	signal carry_out_signal     : std_logic;					 -- carryout signal for concatenation
	signal signal_C			    : std_logic_vector(3 downto 0);  -- signal store the concatenation
	signal mux_1				: std_logic_vector(3 downto 0);  -- 4bits output of the multiplexer where hex_A goes in
	signal mux_2				: std_logic_vector(3 downto 0);  -- 4bits output of the multiplexer where hex_B goes in
	
	
	
-- Here the circuit begins

begin

	hex_A <= sw(3 downto 0);			   -- hex_A is displayed on sw3 downto sw0 on the FPGA
	hex_B <= sw(7 downto 4);			   -- hex_B is displayed on sw7 downto sw4 on the FPGA
	signal_C <= "000" & carry_out_signal;  -- concatenation operation
	
	-- INST6-3 follows the schemetic order
	--
	INST6: full_adder_4bit port map(hex_A, hex_B, '0', carry_out_signal, hex_sum_4bit);
	-- INST6: the beginning of the circuit
	--        hex_A and hex_B come into the full_adder_4bit with the initial carryin(0) as the inputs 
	--        the adder outputs the carryout(carry_out_signal) and sum(the hex_sum_4bit)
	--        the carry_out_signal do the concatenation with "000" and the result is stored in signal_C
	--
	INST7: mux_2_1 port map(hex_B, signal_C, pb(2), mux_1);
	INST8: mux_2_1 port map(hex_A, hex_sum_4bit, pb(2), mux_2);
	-- INST7&INST8: the 2to1 multiplexers(mux_2_1) are used to determine what will be displayed on the FPGA board
	--              if pb2 is 1, the FPGA will display the sum of the two input:
	--              	the two multiplexers select signal_C(from INST6) and hex_sum_4bit(from INST6)
	--                  store them in the output signal mux_1 and mux_2
	--              if pb2 is 0, the FPGA will display the individual A,B number:
	--              	the two multiplexers select hex_B and hex_A
	--                  store them in the output signal mux_1 and mux_2
	--
	INST1: SevenSegment port map(mux_2, seg7_A);
	INST2: SevenSegment port map(mux_1, seg7_B);
	-- INST1&INST2: the SevenSegment is a converter which convert the 4bits input data into 7bits 7segments
	--              two SevenSegments take the input mux_2 and mux_1 (from INST7&INST8)
	--              mux_2 and mux_1 stores either hex_A,hex_b or hexsum,signal_C
	--              two SevenSegments convert mux_2 and mux_1 into 7bits 7segments
	--
	INST3: segment7_mux port map(clkin_50, seg7_A, seg7_B, seg7_data, seg7_char1, seg7_char2);

	-- Display of the leds
	INST4: PB_Inverters  port map(pb_n, pb);
	INST5: logic_processor port map(hex_A, hex_B, pb(1 downto 0), leds(3 downto 0));
	-- the logic_processor is a 4to1 mux
	-- hex_A and hex_B are the logic oprands inputted before the mux
	-- according to the value of pb, one of the AND, OR, XOR, XNOR operation will be selected
	-- the logicoutput will be the 4bits result of the operation which will be displayed by the leds on FPGA
	
end SimpleCircuit;

