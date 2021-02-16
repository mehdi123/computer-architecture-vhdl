library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity ALU is
port(
	Ai:	in std_logic_vector(15 downto 0);
	Bi:	in std_logic_vector(15 downto 0);
	Sel:	in std_logic_vector(4 downto 0);
	inp8:	in std_logic_vector(7 downto 0);
--	en: in std_logic;
	Res:	out std_logic_vector(15 downto 0);
	E: out std_logic
);
end ALU;

architecture behv of ALU is

component Adder is
port(	A:	in std_logic_vector(15 downto 0);
		B:	in std_logic_vector(15 downto 0);
		cin:	in std_logic;
		cout:	out std_logic;
		sum:	out std_logic_vector(15 downto 0)
);
end component;

signal A, B: std_logic_vector(15 downto 0);
signal cin, cout: std_logic;
signal sum: std_logic_vector(15 downto 0);
begin					   
	ADDUnit: Adder port map(A, B, cin, cout, sum);
    process(Sel)
    begin
	case Sel is
	    when "00000" =>
		A <= Ai;
		B <= Bi;
		cin <= '0';
		Res <= sum;
		E <= cout;
	    when "00001" =>						
		A <= Ai;
		B <= Bi;
		cin <= '1';
		Res <= sum;
		E <= cout;
		when "00010" =>
		A <= Ai;
		for i in 0 to 15 loop
			B(i) <= not Bi(i);
		end loop;
		cin <= '0';
		Res <= sum;
		E <= cout;
	    when "00011" =>	 
		A <= Ai;
		for i in 0 to 15 loop
			B(i) <= not Bi(i);
		end loop;
		cin <= '1';
		Res <= sum;
		E <= cout;
	    when "00100" =>	 
		A <= Ai;
		B <= "0000000000000000";
		cin <= '0';
		Res <= sum;
		E <= cout;
	    when "00101" =>	 
		A <= Ai;
		B <= "0000000000000000";
		cin <= '1';
		Res <= sum;
		E <= cout;
	    when "00110" =>
		A <= Ai;
		B <= "1111111111111111";
		cin <= '0';
		Res <= sum;
		E <= cout;
	    when "00111" =>	
		A <= Ai;
		B <= "0000000000000000";
		cin <= '0';
		Res <= sum;
		E <= cout;
	    when "01000" =>	
		Res(0) <= Ai(15);
		for i in 0 to 14 loop
			Res(i+1) <= Ai(i);
		end loop;
		E <= Ai(15);
	    when "01001" =>	
		Res(15) <= Ai(0);
		for i in 0 to 14 loop
			Res(i) <= Ai(i+1);
		end loop;
		E <= Ai(0);
		when "01010" =>
			for i in 0 to 7 loop
				Res(i) <= inp8(i);
				Res(i+8) <= Ai(i+8);
			end loop;
		when "01011" =>
			for i in 0 to 15 loop
				Res(i) <= not Ai(i);
			end loop;
		when "01100" =>
			for i in 0 to 15 loop
				Res(i) <= Ai(i) and Bi(i);
			end loop;
		when "01101" =>
			Res <= Bi;
	    when others =>	 
		Res <= "ZZZZZZZZZZZZZZZZ";
        end case;
    end process;
end behv;
