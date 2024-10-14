-- Copyright (C) 2023  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 23.1std.0 Build 991 11/28/2023 SC Lite Edition"
-- CREATED		"Mon Aug 26 20:35:18 2024"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY part4 IS 
	PORT
	(
		D :  IN  STD_LOGIC;
		CLK :  IN  STD_LOGIC;
		QaLatch :  OUT  STD_LOGIC;
		QbFFUP :  OUT  STD_LOGIC;
		QaFFUP :  OUT  STD_LOGIC;
		QaFFDOWN :  OUT  STD_LOGIC;
		QbLatch :  OUT  STD_LOGIC;
		QbFFDOWN :  OUT  STD_LOGIC
	);
END part4;

ARCHITECTURE bdf_type OF part4 IS 

COMPONENT flipflop
	PORT(D : IN STD_LOGIC;
		 CLK : IN STD_LOGIC;
		 QA : OUT STD_LOGIC;
		 QB : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT latch2
	PORT(D : IN STD_LOGIC;
		 CLK : IN STD_LOGIC;
		 QA : OUT STD_LOGIC;
		 QB : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;


BEGIN 



b2v_FlipFlopD : flipflop
PORT MAP(D => D,
		 CLK => CLK,
		 QA => QaFFUP,
		 QB => QbFFUP);


b2v_FlipFlopDNot : flipflop
PORT MAP(D => D,
		 CLK => SYNTHESIZED_WIRE_0,
		 QA => QaFFDOWN,
		 QB => QbFFDOWN);


SYNTHESIZED_WIRE_0 <= NOT(CLK);



b2v_LatchD : latch2
PORT MAP(D => D,
		 CLK => CLK,
		 QA => QaLatch,
		 QB => QbLatch);


END bdf_type;