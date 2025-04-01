-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
-- CREATED		"Tue Apr 01 22:21:53 2025"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY ReCOP IS 
	PORT
	(
		CLOCK_50 :  IN  STD_LOGIC;
		clk_0 :  OUT  STD_LOGIC;
		clk_1 :  OUT  STD_LOGIC
	);
END ReCOP;

ARCHITECTURE bdf_type OF ReCOP IS 

ATTRIBUTE black_box : BOOLEAN;
ATTRIBUTE noopt : BOOLEAN;

COMPONENT lpm_constant_0
	PORT(		 result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;
ATTRIBUTE black_box OF lpm_constant_0: COMPONENT IS true;
ATTRIBUTE noopt OF lpm_constant_0: COMPONENT IS true;

COMPONENT adder_subtractor
GENERIC (bit_width : INTEGER
			);
	PORT(add : IN STD_LOGIC;
		 A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Y : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT constant_1
	PORT(		 result : OUT STD_LOGIC_VECTOR(0 TO 0)
	);
END COMPONENT;

COMPONENT pll
	PORT(inclk0 : IN STD_LOGIC;
		 c0 : OUT STD_LOGIC;
		 c1 : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT program_counter
	PORT(clk : IN STD_LOGIC;
		 pc_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 pc_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(15 DOWNTO 0);


BEGIN 
clk_0 <= SYNTHESIZED_WIRE_3;



b2v_inst : adder_subtractor
GENERIC MAP(bit_width => 16
			)
PORT MAP(add => SYNTHESIZED_WIRE_0,
		 A => SYNTHESIZED_WIRE_1,
		 B => SYNTHESIZED_WIRE_2,
		 Y => SYNTHESIZED_WIRE_4);


b2v_inst2 : lpm_constant_0
PORT MAP(		 result => SYNTHESIZED_WIRE_2);


b2v_inst5 : constant_1
PORT MAP(		 result(0) => SYNTHESIZED_WIRE_0);


b2v_inst6 : pll
PORT MAP(inclk0 => CLOCK_50,
		 c0 => SYNTHESIZED_WIRE_3,
		 c1 => clk_1);


b2v_PC : program_counter
PORT MAP(clk => SYNTHESIZED_WIRE_3,
		 pc_in => SYNTHESIZED_WIRE_4,
		 pc_out => SYNTHESIZED_WIRE_1);


END bdf_type;