--PACKAGE ram_constants IS
--	constant ADDR_WIDTH: INTEGER := 8;
--	constant DATA_WIDTH: INTEGER := 8;
--END ram_constants;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY lpm;
USE lpm.lpm_components.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--LIBRARY work;
--USE work.ram_constants.all;

ENTITY ram IS
PORT(
	data	:	IN STD_LOGIC_VECTOR (15 downto 0);
	address :	IN STD_LOGIC_VECTOR (11 downto 0);
	we		:	IN STD_LOGIC;
	inclock	:	IN STD_LOGIC;
	outclock:	IN STD_LOGIC;
	q		:	OUT STD_LOGIC_VECTOR (15 downto 0)
);
END ram;

ARCHITECTURE mem OF ram IS
BEGIN
inst_1	: LPM_RAM_DQ
			GENERIC MAP (lpm_widthad => 12,
						 lpm_width => 16)
			PORT MAP (data => data, address => address, we => we,
					  inclock => inclock, outclock => outclock,
					  q => q);
END mem;


