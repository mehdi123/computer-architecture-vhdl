library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity DECODER38 is
port(	
	I:	in std_logic_vector(2 downto 0);
	O:	out std_logic_vector(7 downto 0)
);
end DECODER38;

architecture decod of DECODER38 is
begin

process(I)
begin
	O <= "00000000";
	O(conv_integer(I)) <= '1';
end process;
end decod;



