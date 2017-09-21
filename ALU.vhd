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
	constant result : integer := 255;
	begin
	
	alu : process(OE,mode) is
	 procedure C_OUT is
		  begin
			  if (OE = '1') then	
			 	 c <= std_logic_vector(to_unsigned(result, c'length));
			  else c <= "ZZZZZZZZZZZZZZZZ";
			  end if;
	  end;
		begin
		C_OUT;

	







	end process;
end simple;
		
		