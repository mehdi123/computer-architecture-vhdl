library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-------------------------------------------------

entity Mux81 is
port(	
	I7: 	in std_logic_vector(15 downto 0);
	I6: 	in std_logic_vector(15 downto 0);
	I5: 	in std_logic_vector(15 downto 0);
	I4: 	in std_logic_vector(15 downto 0);
	I3: 	in std_logic_vector(15 downto 0);
	I2: 	in std_logic_vector(11 downto 0);
	I1: 	in std_logic_vector(11 downto 0);
	I0: 	in std_logic_vector(15 downto 0);
	S:	in std_logic_vector(2 downto 0);
	O:	out std_logic_vector(15 downto 0)
);
end Mux81;  

-------------------------------------------------

architecture behv1 of Mux81 is
begin
    process(S)
    begin
        case S is
	    when "000" =>	O <= I0;
	    when "001" =>	O(11 downto 0) <= I1;
	    when "010" =>	O(11 downto 0) <= I2;
	    when "011" =>	O <= I3;
	    when "100" =>	O <= I4;
	    when "101" =>	O <= I5;
	    when "110" =>	O <= I6;
	    when "111" =>	O <= I7;
	    when others =>	O <= "ZZZZZZZZZZZZZZZZ";
	end case;
    end process;
end behv1;

