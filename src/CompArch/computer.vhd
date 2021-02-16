library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY Computer IS
	PORT
	(
	clock: in std_logic;
--	loading:in std_logic;
	inpr: in std_logic_vector(7 downto 0);
	outr: out std_logic_vector(7 downto 0);
	acout: out std_logic_vector(15 downto 0);
	E:	out std_logic;
	tout: 	out std_logic_vector(15 downto 0);
	cnt_out:	out std_logic_vector(3 downto 0);
	ar_ldo:	out std_logic;
	pc_ldo:	out std_logic;
	dr_ldo:	out std_logic;
	ac_ldo:	out std_logic;
--	tr_ldo:	out std_logic;
	ir_ldo:	out std_logic
	);
END Computer;

ARCHITECTURE arch OF Computer IS

component Ram is
PORT(
	data	:	IN STD_LOGIC_VECTOR (15 downto 0);
	address :	IN STD_LOGIC_VECTOR (11 downto 0);
	we		:	IN STD_LOGIC;
	inclock	:	IN STD_LOGIC;
	outclock:	IN STD_LOGIC;
	q		:	OUT STD_LOGIC_VECTOR (15 downto 0)
);
end component;

component Alu is
port(
	Ai:	in std_logic_vector(15 downto 0);
	Bi:	in std_logic_vector(15 downto 0);
	Sel:	in std_logic_vector(4 downto 0);
	inp8:	in std_logic_vector(7 downto 0);
--	en: in std_logic;
	Res:	out std_logic_vector(15 downto 0);
	E: out std_logic
);
end component;


component counter is
port(
	clock:	in std_logic;
	clear:	in std_logic;
	count:	in std_logic;
	Q:	out std_logic_vector(3 downto 0)
);
end component;

component decoder38 is
port(	
	I:	in std_logic_vector(2 downto 0);
	O:	out std_logic_vector(7 downto 0)
);
end component;

component decoder416 is
port(
	I: in std_logic_vector(3 downto 0);
	O:	out	std_logic_vector(15 downto 0)
);
end component;

component encoder is
port(
	I: in std_logic_vector(7 downto 0);
	en: in std_logic;
	O:	out	std_logic_vector(2 downto 0)
);
end component;

component reg16 is
port(	I:	in std_logic_vector(15 downto 0);
	clock:	in std_logic;
	load:	in std_logic;
	clear:	in std_logic;
	inr:	in std_logic;
	zero:	out std_logic;
	Q:	out std_logic_vector(15 downto 0)
);
end component;

component reg12 is
port(	I:	in std_logic_vector(11 downto 0);
	clock:	in std_logic;
	load:	in std_logic;
	clear:	in std_logic;
	inr:	in std_logic;
	Q:	out std_logic_vector(11 downto 0)
);
end component;

component Mux81 is
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
end component;  

signal alusel: std_logic_vector(4 downto 0);
signal alures: std_logic_vector(15 downto 0);
signal datae, alueout, ec: std_logic;
signal aluen: std_logic;  -- := '0';
signal d: std_logic_vector(7 downto 0);
signal rm_read, rm_write: std_logic;
signal rm_en: std_logic := '1';
--signal rm_addr: std_logic_vector(11 downto 0);
signal rm_datain: std_logic_vector(15 downto 0);
signal rm_dataout: std_logic_vector(15 downto 0);

signal count_out: std_logic_vector(3 downto 0);
signal count_clr: std_logic ;
signal count_cnt: std_logic ;
signal dec_en: std_logic := '1';
signal FGI, FGO: std_logic;
signal nop: std_logic;
signal halt: std_logic := '0';

signal t:	std_logic_vector(15 downto 0);
signal x:	std_logic_vector(7 downto 0);

signal	ar_ld, ar_inr, ar_clr:	std_logic;
signal	pc_ld, pc_inr, pc_clr:	std_logic;
signal	dr_ld, dr_inr, dr_clr:	std_logic;
signal	ac_ld, ac_inr, ac_clr:	std_logic;
signal	tr_ld, tr_inr, tr_clr:	std_logic;
signal	ir_ld, ir_inr, ir_clr:	std_logic;
signal dr_zero, ac_zero, dummy1, dummy2: std_logic;

signal busSel:	std_logic_vector(2 downto 0);

signal	temp:	std_logic_vector(15 downto 0);
signal	inp_temp:	std_logic_vector(7 downto 0);
signal	out_temp:	std_logic_vector(7 downto 0);
signal	E_temp:	std_logic;


signal	aro:	std_logic_vector(11 downto 0);
signal	pco:	std_logic_vector(11 downto 0);
signal	dro:	std_logic_vector(15 downto 0);
signal	aco:	std_logic_vector(15 downto 0);
signal	iro:	std_logic_vector(15 downto 0);
signal	tro:	std_logic_vector(15 downto 0);


--signal ldadr:	integer range 0 to 11;
--type prog_type is array (0 to 20) of 
--	std_logic_vector(15 downto 0);
--signal program: prog_type;


BEGIN

--	count_clr <= '0';
--	count_cnt <= '1';
	inp_temp <= inpr;
	alunit: Alu port map(aco, dro, alusel, inp_temp, alures, alueout);

	memunit: Ram port map(temp, aro, rm_write, clock, clock, rm_dataout);

	seqcount: counter port map(clock, count_clr, count_cnt, count_out);

	insdec: decoder38 port map(iro(14 downto 12), d);

	tdec:	decoder416 port map(count_out, t);
	enc:	encoder port map(x, dec_en, bussel);

	cbus:	Mux81 port map(rm_dataout, tro, iro, aco, dro, pco, aro, rm_dataout, bussel, temp);



	ar:	reg12 port map(temp(11 downto 0), clock, ar_ld, ar_clr, ar_inr, aro);
	pc: 	reg12 port map(temp(11 downto 0), clock, pc_ld, pc_clr, pc_inr, pco);
	dr:	reg16 port map(temp, clock, dr_ld, dr_clr, dr_inr, dr_zero, dro);
	ac: 	reg16 port map(alures, clock, ac_ld, ac_clr, ac_inr, ac_zero, aco);
	ir:	reg16 port map(temp, clock, ir_ld, ir_clr, ir_inr, dummy1, iro);
	tr:	reg16 port map(temp, clock, tr_ld, tr_clr, tr_inr, dummy2, tro);
	
	acout <= alures;
	ar_ld <= (t(0) or t(2) or (iro(15) and t(3)));-- and (not loading);
	ar_inr<= (d(5) and t(4)) ;-- and (not loading));

	pc_ld <= ( (d(4) and t(4)) or (d(5) and t(5))) ;--and (not loading);
	pc_inr <=(t(1) or ( d(6) and t(6) and dr_zero ) or ( ( d(7) and (not iro(15)) and t(3) ) and
				( aco(15) or (not aco(15)) or ac_zero or (not datae))) 
			 or ( ( d(7) and iro(15) and t(3) ) and ((iro(8) and FGO) or (iro(9) and FGI))));-- and (not loading);
	
	dr_ld <= ((d(0) and t(4)) or (d(1) and t(4)) or (d(2) and t(4)) or (d(6) and t(4)));-- and (not loading);
	dr_inr <= ((d(6) and t(5) and (not d(7))));-- and (not loading);
	
	ac_ld <= ((d(0) and t(5)) or (d(1) and t(5)) or (d(2) and t(5)) or (( d(7) and (not iro(15)) and t(3) ) 
				and (iro(6) or iro(7) or iro(9))) or (( d(7) and iro(15) and t(3) ) and iro(11)));-- and (not loading);
	ac_inr <= (( (d(7) and (not iro(15)) and t(3)) and iro(5))) ;--and (not loading);
	ac_clr <= ((( d(7) and (not iro(15)) and t(3) ) and iro(11))) ;--and (not loading);
	
	ir_ld <= t(1); --and (not loading);
	
	ar_ldo <= ar_ld;
	pc_ldo <= pc_ld;
	dr_ldo <= dr_ld;
	ac_ldo <= ac_ld;
--	tr_ldo <= tr_ld;
	ir_ldo <= ir_ld;
	tout <= t;
	cnt_out <= count_out;
	
	
	x(1) <=  d(5) and t(5);
	x(2) <=  t(0) or (d(5) and t(4));
	x(3) <=  (d(2) and t(5)) or (d(6) and t(6));
	x(4) <=  (d(3) and t(4)) or (( d(7) and iro(15) and t(3) ) and iro(11));
	x(5) <= t(2) ;
	x(7) <=	t(1) or ((not d(7)) and iro(15) and t(3)) or (d(0) and t(4)) or (d(1) and t(4)) or (d(2) and t(4))
				 or (d(6) and t(4));
	x(6) <= '0';
	x(0) <= '0';

--	rm_read <= t(1) or ((not d(7)) and iro(15) and t(3)) or  ((d(0) or d(1) or d(2) or d(6)) and t(4));
--
	rm_write <= ((t(4) and (d(3) or d(5)) ) or (t(6) and d(6)));
	count_clr <=(d(7) and iro(15) and t(3)) or
				(d(7) and (not iro(15)) and t(3)) or 
				((not d(7)) and d(0) and t(5)) or
				((not d(7)) and d(1) and t(5)) or
				((not d(7)) and d(2) and t(5)) or
				((not d(7)) and d(3) and t(4)) or
				((not d(7)) and d(4) and t(4)) or
				((not d(7)) and d(5) and t(5)) or
				((not d(7)) and d(6) and t(6)) or halt;
	
	process(t, clock)
	begin
	case t is
	when "0000000000000011" =>
		if d(7) = '1' and iro(15) = '1' then
			if iro(11) = '1' then
				alusel <= "01010";
				FGI <= '0';
			elsif iro(10) = '1' then 
				out_temp <= aco(7 downto 0);
				FGO <= '0';
			end if;
		elsif d(7) = '1' and iro(15) = '0' then
			if iro(10) = '1' then
				E_temp <= '0';
			elsif iro(9) = '1' then
				alusel <= "01011"; 
			elsif iro(8) = '1' then
				E_temp <= not datae;
			elsif iro(7) = '1' then
				alusel <= "01001";
			elsif iro(6) = '1' then
				alusel <= "01000";
			elsif iro(0) = '1' then
				halt <= '1';
			end if;
		elsif d(7) = '0' then
			if d(0) = '1' and t(5) = '1' then
				alusel <= "01100";
			elsif d(1) = '1' and t(5)= '1' then
				alusel <= "00000";
				E_temp <= datae;
			elsif d(2) = '1' and t(5) = '1' then
				alusel <= "01101";
			end if; 
		end if; 
	when others =>
		nop <= '1';
	end case;
	end process;
	outr <= out_temp;
	E <= E_temp;
END arch;



