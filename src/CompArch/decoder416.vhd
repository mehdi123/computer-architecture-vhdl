library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity DECODER416 is
port(	
	I:	in std_logic_vector(3 downto 0);
	O:	out std_logic_vector(15 downto 0)
);
end DECODER416;

architecture decode of DECODER416 is
begin
    process (I)
    begin
		if (CONV_INTEGER(I) >= 0 and CONV_INTEGER(I) <= 15 ) then
			O <= "0000000000000000";
		    O(CONV_INTEGER(I)) <= '1';
		end if;
    end process;
end decode;

