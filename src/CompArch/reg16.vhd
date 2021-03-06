library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity reg16 is
port(	I:	in std_logic_vector(15 downto 0);
	clock:	in std_logic;
	load:	in std_logic;
	clear:	in std_logic;
	inr:	in std_logic;
	zero:	out std_logic;
	Q:	out std_logic_vector(15 downto 0)
);
end reg16;

----------------------------------------------------

architecture behv of reg16 is

    signal Q_tmp: std_logic_vector(15 downto 0);
    signal z: std_logic;

begin

    process(I, clock, load, clear, inr)
    begin

	if clear = '1' then
            -- use 'range in signal assigment 
            Q_tmp <= (Q_tmp'range => '0');
	elsif (clock='1' and clock'event) then
	    if load = '1' then
			Q_tmp <= I;
	    elsif inr = '1' then
			Q_tmp <= Q_tmp + 1;
		end if;
	end if;
	z <= '0';
	for i in 0 to 15 loop
		z <= z or Q_tmp(i);
	end loop;
    end process;
    Q <= Q_tmp;
    zero <= z;
end behv;

