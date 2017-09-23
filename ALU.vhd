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
  	 
  	 -- function to count the number of elements that are '1'
	 function determineParity(myBits : signed(15 downto 0)) return std_logic is
	     variable counter : integer;
	     variable parity : std_logic;
	     begin
	       counter := 0;
	           for i in 0 to myBits'length - 1 loop -- loop through all bits and count the '1's
	             if(myBits(i) = '1') then
	                 counter := counter + 1;
	             end if;
	           end loop;
	           if(counter mod 2 = 0) then -- check to see if it is even or odd
	             parity := '0';
	           else
	             parity := '1';
	           end if;
	       return parity;
	 end determineParity;
  
	begin
	
	alu : process(OE, mode, a, b) is
	 
	 procedure main is
	    variable mode_num : integer;
	    variable a_s, b_s, c_s : signed(15 downto 0);
	    variable x_s : signed(0 downto 0);
	    variable carry_s, a_ov, b_ov: std_logic;
		  begin
		    --A_num := signed(a, a'length);-- Convert to unsigned int and store
		    --B_num := to_signed(b, b'length);
		    -- Assign values
		    a_s := signed(a);
		    b_s := signed(b);
        a_ov := a(15);
        b_ov := b(15);		    
		    mode_num := to_integer(unsigned(mode));
		  if(OE = '1') then
		    -- Check which mode is selected and apply correect opperation
		    case mode_num is
		       when 0 =>
		         c_s := a_s + b_s;
		         
		         -- determine if overflow occurs
		         x_s(0) := c_s(15);
		         if(((a_ov = '0') AND (b_ov = '0') AND (x_s(0) = '0')) OR ((a_ov = '1') AND (b_ov = '1') AND (x_s(0) = '1'))) then -- No overflow occurs
		            carry <= '0';
		         else
		            carry <= '1';
		         end if;
		          
		       when 1 =>
		         c_s := a_s - b_s;
		         x_s(0) := c_s(15);
		         
		         -- determine if overflow occurs
		         if(((a_ov = '1') AND (b_ov = '0') AND (x_s(0) = '0')) OR ((a_ov = '0') AND (b_ov = '1') AND (x_s(0) = '1'))) then -- Overflow occurs
		            carry <= '1';
		         else
		            carry <= '0';
		         end if;
            
		       when 2 =>
		         c_s := -a_s; -- perform opperation
		         
		         carry <= '0';-- overflow is impossible
		         
		       when 3 =>
		         c_s := shift_left(a_s, 1);
		         if(c_s(15) = a_ov) then -- no overflow
		            carry_s := '0';
		         else
		           carry_s := '1';-- overflow occured
		         end if;               
	
		       when 4 =>
		         c_s := a_s AND b_s;
		         carry <= determineParity(c_s);		  
		         
		       when 5 =>
		         c_s := a_s OR b_s;
		         carry <= determineParity(c_s);		  		         		         
		       when 6 =>
		         c_s := a_s XOR b_s;
		         carry <= determineParity(c_s);		  		
		       when 7 =>
		         c_s := NOT(a_s);
		         carry <= determineParity(c_s);		  		
		       when others =>
		         c_s := a_s;
		         carry <= determineParity(c_s);		  		
        end case;
        
        -- check to see if the result is zero
        if c_s = 0 then
          zero <= '1';
        else
          zero <= '0';
        end if;
        
        -- convert the result of the performed opperation back to std_logic vector and put on bus
        c <= std_logic_vector(c_s);
        
        
      end if;
        
	  end;-- ends procedure
	  
		begin
		main;


	end process;
end simple;
		
		