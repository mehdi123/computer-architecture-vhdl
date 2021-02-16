library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity encoder is
port(	
	I:	in std_logic_vector(7 downto 0);
	en:	in std_logic;
	O:	out std_logic_vector(2 downto 0)
);
end encoder;

architecture encode of encoder is
begin
    process (I)
    begin
	case I is
	when "00000001" =>
	o <= "000";
	when "00000010" =>
	o <= "001";
	when "00000100" =>
	o <= "010";
	when "00001000" =>
	o <= "011";
	when "00010000" =>
	o <= "100";
	when "00100000" =>
	o <= "101";
	when "01000000" =>
	o <= "110";
	when "10000000" =>
	o <= "111";
	when others =>
	o <= "ZZZ";
	end case;
    end process;
end encode;
