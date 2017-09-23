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
	
	alu : process(OE, mode, a, b) is
	 procedure main is
	    variable mode_num : integer;
	    variable a_s, b_s, c_s : signed(15 downto 0);
	    variable x_s : signed(0 downto 0);
	    variable carry_s, a_ov, b_ov, c_ov : std_logic;
		  begin
		    --A_num := signed(a, a'length);-- Convert to unsigned int and store
		    --B_num := to_signed(b, b'length);
		    -- Assign values
		    a_s := signed(a);
		    b_s := signed(b);
        a_ov := a(15);
        b_ov := b(15);		    
		    mode_num := to_integer(unsigned(mode));
		    
		    -- Check which mode is selected and apply correect opperation
		    case mode_num is
		       when 0 =>
		         c_s := a_s + b_s;
		         x_s(0) := c_s(15);
		         if(((a_ov = '0') AND (b_ov = '0') AND (x_s(0) = '0')) OR ((a_ov = '1') AND (b_ov = '1') AND (x_s(0) = '1'))) then -- No overflow occurs
		            carry_s := '0';
		         else
		            carry_s := '1';
		         end if;
		          
		       when 1 =>
		         c_s := a_s - b_s;
		         x_s(0) := c_s(15);
		         if(((a_ov = '1') AND (b_ov = '0') AND (x_s(0) = '0')) OR ((a_ov = '0') AND (b_ov = '1') AND (x_s(0) = '1'))) then -- Overflow occurs
		            carry_s := '1';
		         else
		            carry_s := '0';
		         end if;

		       when 2 =>
		         c_s := -a_s;
		         c_ov := '0';
		       when 3 =>
		         c_s := shift_left(a_s, 1);
		         if(c_s(15) = a_ov) then -- no carry
		            carry_s := '0';
		         else
		           carry_s := '1';
		         end if;
	
		       when 4 =>
		         c_s := a_s AND b_s;
		       when 5 =>
		         c_s := a_s OR b_s;
		       when 6 =>
		         c_s := a_s XOR b_s;
		       when 7 =>
		         c_s := NOT(a_s);
		       when others =>
		         c_s := a_s;
        end case;
        
        --c <= std_logic_vector(c_s);
        
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
		
		