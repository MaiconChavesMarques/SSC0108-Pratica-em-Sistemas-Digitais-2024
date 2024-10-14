-- Copyright (C) 2021  Intel Corporation. All rights reserved.
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
-- VERSION		"Version 21.1.0 Build 842 10/21/2021 SJ Lite Edition"
-- CREATED		"Tue Aug 20 17:47:03 2024"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY flipflop IS 
	PORT
	(
		D :  IN  STD_LOGIC;
		CLK :  IN  STD_LOGIC;
		QA :  OUT  STD_LOGIC;
		QB :  OUT  STD_LOGIC
	);
END flipflop;

ARCHITECTURE bdf_type OF flipflop IS 

COMPONENT latch2
	PORT(D : IN STD_LOGIC;
		 CLK : IN STD_LOGIC;
		 QA : OUT STD_LOGIC;
		 QB : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;


BEGIN 



b2v_inst : latch2
PORT MAP(D => D,
		 CLK => SYNTHESIZED_WIRE_0,
		 QA => SYNTHESIZED_WIRE_1);


b2v_inst1 : latch2
PORT MAP(D => SYNTHESIZED_WIRE_1,
		 CLK => CLK,
		 QA => QA,
		 QB => QB);


SYNTHESIZED_WIRE_0 <= NOT(CLK);



END bdf_type;