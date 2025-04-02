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

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "04/02/2025 18:41:48"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          ReCOP
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY ReCOP_vhd_vec_tst IS
END ReCOP_vhd_vec_tst;
ARCHITECTURE ReCOP_arch OF ReCOP_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL addr_mod : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL CLOCK : STD_LOGIC;
SIGNAL instruction : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL ld : STD_LOGIC;
SIGNAL opcode : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL operand : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL pc_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL reset : STD_LOGIC;
SIGNAL rx : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL ry : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL rz : STD_LOGIC_VECTOR(2 DOWNTO 0);
COMPONENT ReCOP
	PORT (
	addr_mod : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	CLOCK : IN STD_LOGIC;
	instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	ld : IN STD_LOGIC;
	opcode : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
	operand : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	pc_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	reset : IN STD_LOGIC;
	rx : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	ry : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	rz : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : ReCOP
	PORT MAP (
-- list connections between master ports and signals
	addr_mod => addr_mod,
	CLOCK => CLOCK,
	instruction => instruction,
	ld => ld,
	opcode => opcode,
	operand => operand,
	pc_out => pc_out,
	reset => reset,
	rx => rx,
	ry => ry,
	rz => rz
	);

-- CLOCK
t_prcs_CLOCK: PROCESS
BEGIN
LOOP
	CLOCK <= '0';
	WAIT FOR 5000 ps;
	CLOCK <= '1';
	WAIT FOR 5000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_CLOCK;

-- ld
t_prcs_ld: PROCESS
BEGIN
	ld <= '1';
WAIT;
END PROCESS t_prcs_ld;

-- reset
t_prcs_reset: PROCESS
BEGIN
	reset <= '0';
WAIT;
END PROCESS t_prcs_reset;
END ReCOP_arch;
