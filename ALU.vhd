library IEEE;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
entity ALU is 
	port(a,b : in std_logic_vector(15 downto 0);
		mode : in std_logic_vector(2 downto 0);
		OE : in std_logic;
		
		c : out std_logic_vector(15 downto 0);
		zero, carry : out std_logic);
end ALU;

architecture simple of ALU is 
	begin
	
	alu : process(OE,mode) is
	 procedure main is
	    variable mode_num : integer;
	    variable a_s, b_s, c_s : signed(15 downto 0);
	    variable F : signed(16 downto 0);
	    variable carry_s : std_logic;
		  begin
		    F := "00000000000000000";-- initialize 
		    --A_num := signed(a, a'length);-- Convert to unsigned int and store
		    --B_num := to_signed(b, b'length);
		    -- Assign values
		    a_s := signed(a);
		    b_s := signed(b);
		    
		    mode_num := to_integer(unsigned(mode));
		    
		    -- Check which mode is selected and apply correect opperation
		    case mode_num is
		       when 0 =>
		         F := a_s + b_s;
		         c_s := F(15 downto 0);
		         carry <= std_logic(F(16));-- check for carry
		       when 1 =>
		         F := a_s - b_s;
		         c_s := F(15 downto 0);
		         carry <= std_logic(F(16));-- check for carry
		       when 2 =>
		         F := -a_s;
		         c_s := F(15 downto 0);
		         carry <= std_logic(F(16));-- check for carry
		       when 3 =>
		         F := shift_left(a_s, 1);
		         c_s := F(15 downto 0);
		       when 4 =>
		         F := a_s AND b_s;
		         c_s := F(15 downto 0);
		       when 5 =>
		         F := a_s OR b_s;
		         c_s := F(15 downto 0);
		       when 6 =>
		         F := a_s XOR b_s;
		         c_s := F(15 downto 0);
		       when 7 =>
		         F := NOT(a_s);
		         c_s := F(15 downto 0);
		       when others =>
		         F := a_s;
		         c_s := F(15 downto 0);
        end case;
        
        if c_s = 0 then
          zero <= '1';
        else
          zero <= '0';
        end if;
	  end;	  
	  
		begin
		main;

	







	end process;
end simple;
		
		