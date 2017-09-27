library STD;
use STD.textio.all; -- used for printing output to a txt file for easier documentation
library IEE;
use IEEE.std_logic_1164.all; -- for std logic tpes
use IEEE.numeric_std.all; -- good for typecasting opperations


entity ALU_TestBench is
end ALU_TestBench;

architecture behavior of ALU_TestBench is
  
  -- define number of bits on input
  constant INPUT_BIT_WIDTH : integer := 16;
  
  -- define number of bits on mode
  constant MODE_BIT_WIDTH : integer := 3;
  
  -- Set timing
	constant MAX_DELAY : time := 20 ns;
	
	-- Set number of tests
	constant NO_TESTS : integer := 20; -- ??? T.B.D.
	
	-- declare a type to hold an array of input values
	type input_value_array is array(1 to NO_TESTS) of std_logic_vector(INPUT_BIT_WIDTH - 1 downto 0);
	-- define the test conditions and expected results
	constant a_values : input_value_array := ("0000111100001111",......);
	constant b_values : input_value_array := ("0000111100001111",......);
	constant c_values : input_value_array := ("0000111100001111",......);-- holds expected results
	
	-- declare a type to hold an array of mode values
	type mode_value_array is array(1 to NO_TESTS) of std_logic_vector(MODE_BIT_WIDTH - 1 downto 0);
	-- define the test conditions
	constant mode_values : mode_value_array := ("000", ....);
	constant enable_values : std_logic_vector(1 to NO_TESTS) := (others := 1);
	
	-- define the expected result bits
	constant ov_p_values : std_logic_vector(1 to NO_TESTS) := ('1', ...);
	constant zero_values : std_logic_vector(1 to NO_TESTS) := ('1'. ...);
	
	
	
	-- define signals to connect to DUT
	-- Inputs
	signal a_in, b_in : std_logic_vector(INPUT_BIT_WIDTH - 1 downto 0);
	signal enable_in : std_logic;
	signal mode_in : std_logic_vector(MODE_BIT_WIDTH -1 down to 0);
	
	-- Outputs
	signal c_out : std_logic_vector(INPUT_BIT_WIDTH - 1 downto 0);
	signal ov_p_out, zero_out : std_logic;
	
	-- Save results to file
	file lab4_results : TEXT open WRITE_MODE is "lab4_testbench_results.txt";
	
	begin
	  -- process that will generate the inputs
	  stimulus : process
	     variable currentOutput : LINE;
	       begin
	         write(currentOutput, string'("time(ns),a_in,b_in,c_out,zero,overflow/parity"))
	         writeline(lab_results, currentOutput);
	         for i in 1 to NO_TESTS loop
	            mode_in <= mode_values(i);
	            a_in <= a_values(i);
	            b_in <= b_values(i);
	            enable_in <= enable_values(i);
	            wait for MAX_DELAY;
	         end loop;
	         file_close(lab4_results);
	  end process stimulus;
	  
	  
	  -- Component instantiation for DUT
	  DUT : entity work.ALU(simple)
	     -- maps local signals to DUT
	     port map(a => a_in,
	              b => b_in,
	              mode => mode_in,
	              OE => enable_in,
	              zero => zero_out,
	              carry => ov_p_out,
	              c => c_out);
	              
	 
	     
	
	 -- Process to monitor outputs
	 monitor : process
	   variable i : integer;
	   variable currentOutput : LINE;-- used to store out put in txt file
	   variable simulationTime : time;-- used to keep track of the time
	   begin
	      wait on a_in, b_in, enable_in, mode_in -- start only when one of these signals change
	      wait for MAX_DLAY/2;
	      i := 1;
	      while i <= NO_TESTS loop
	        exit when ((a_in = a_values(i)) AND (b_in = b_values(i)) AND (mode_in = mode_values(i)))
	        i := i + 1;
	      end loop;
	      assert i <= NO_TESTS
	       report "Failure - no valid inputs found"
	       severity failure;
	       
	      assert c_out = c_values(i)
	         report "Error - value of output invalid: c_out = " & 
	           std_logic_vetor'image(c_out) & ", c_values(i) = " &
	           std_logic_vector'image(c_values(i))
	         severity error;
	         
	      assert zero_out = zero_values(i)
	         report "Error - zero bit invalid: zero_out = " &
	           std_logic'image(zero_out) & ", zero_values(i) = " &
	           std_logic'image(zero_values(i))
	         severity error;
	      
	      assert ov_p_out = ov_p_values(i)
	         report "Error - parity/overflow bit invalid: ov_p_out = " &
	           std_logic'image(ov_p_out) & ", ov_p_values(i) = " &
	           std_logic'image(ov_p_values(i))
	         severity error;
	         