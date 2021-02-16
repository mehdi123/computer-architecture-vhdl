--------------------------------------------------------
-- VHDL code for n-bit adder (ESD figure 2.5)	
-- by Weujun Zhang, 04/2001
--
-- function of adder:
-- A plus B to get n-bit sum and 1 bit carry	
-- we may use generic statement to set the parameter 
-- n of the adder.							
--------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--------------------------------------------------------

entity ADDER is
port(	A:	in std_logic_vector(15 downto 0);
	B:	in std_logic_vector(15 downto 0);
	cin:	in std_logic;
	cout:	out std_logic;
	sum:	out std_logic_vector(15 downto 0)
);
end ADDER;

--------------------------------------------------------

architecture behv of ADDER is

signal result: std_logic_vector(16 downto 0);

begin					  
    -- the 3rd bit should be carry
    result <= ('0' & A)+('0' & B)+("000000000000000" & cin);
    sum <= result(15 downto 0);
    cout <= result(16);
end behv;
