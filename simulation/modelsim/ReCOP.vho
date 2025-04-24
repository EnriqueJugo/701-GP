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

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"

-- DATE "04/24/2025 17:47:21"

-- 
-- Device: Altera 5CSEMA5F31C6 Package FBGA896
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	ReCOP IS
    PORT (
	clock : IN std_logic;
	alu_reset : IN std_logic;
	Clock_TEST : IN std_logic;
	sip_in : IN std_logic_vector(15 DOWNTO 0)
	);
END ReCOP;

-- Design Ports Information
-- sip_in[14]	=>  Location: PIN_E2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sip_in[15]	=>  Location: PIN_AK27,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sip_in[12]	=>  Location: PIN_AJ2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sip_in[13]	=>  Location: PIN_W16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sip_in[0]	=>  Location: PIN_E3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sip_in[1]	=>  Location: PIN_AH22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sip_in[2]	=>  Location: PIN_AD19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sip_in[3]	=>  Location: PIN_E9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sip_in[4]	=>  Location: PIN_AF5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sip_in[5]	=>  Location: PIN_E7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sip_in[6]	=>  Location: PIN_AA25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sip_in[7]	=>  Location: PIN_AH2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sip_in[8]	=>  Location: PIN_AE29,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sip_in[9]	=>  Location: PIN_AB22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sip_in[10]	=>  Location: PIN_AD29,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sip_in[11]	=>  Location: PIN_W19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clock	=>  Location: PIN_J7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- alu_reset	=>  Location: PIN_B2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Clock_TEST	=>  Location: PIN_V23,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF ReCOP IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clock : std_logic;
SIGNAL ww_alu_reset : std_logic;
SIGNAL ww_Clock_TEST : std_logic;
SIGNAL ww_sip_in : std_logic_vector(15 DOWNTO 0);
SIGNAL \sip_in[14]~input_o\ : std_logic;
SIGNAL \sip_in[15]~input_o\ : std_logic;
SIGNAL \sip_in[12]~input_o\ : std_logic;
SIGNAL \sip_in[13]~input_o\ : std_logic;
SIGNAL \sip_in[0]~input_o\ : std_logic;
SIGNAL \sip_in[1]~input_o\ : std_logic;
SIGNAL \sip_in[2]~input_o\ : std_logic;
SIGNAL \sip_in[3]~input_o\ : std_logic;
SIGNAL \sip_in[4]~input_o\ : std_logic;
SIGNAL \sip_in[5]~input_o\ : std_logic;
SIGNAL \sip_in[6]~input_o\ : std_logic;
SIGNAL \sip_in[7]~input_o\ : std_logic;
SIGNAL \sip_in[8]~input_o\ : std_logic;
SIGNAL \sip_in[9]~input_o\ : std_logic;
SIGNAL \sip_in[10]~input_o\ : std_logic;
SIGNAL \sip_in[11]~input_o\ : std_logic;
SIGNAL \clock~input_o\ : std_logic;
SIGNAL \alu_reset~input_o\ : std_logic;
SIGNAL \Clock_TEST~input_o\ : std_logic;
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;

BEGIN

ww_clock <= clock;
ww_alu_reset <= alu_reset;
ww_Clock_TEST <= Clock_TEST;
ww_sip_in <= sip_in;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

-- Location: IOIBUF_X8_Y81_N52
\sip_in[14]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sip_in(14),
	o => \sip_in[14]~input_o\);

-- Location: IOIBUF_X80_Y0_N52
\sip_in[15]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sip_in(15),
	o => \sip_in[15]~input_o\);

-- Location: IOIBUF_X14_Y0_N18
\sip_in[12]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sip_in(12),
	o => \sip_in[12]~input_o\);

-- Location: IOIBUF_X52_Y0_N18
\sip_in[13]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sip_in(13),
	o => \sip_in[13]~input_o\);

-- Location: IOIBUF_X8_Y81_N35
\sip_in[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sip_in(0),
	o => \sip_in[0]~input_o\);

-- Location: IOIBUF_X66_Y0_N92
\sip_in[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sip_in(1),
	o => \sip_in[1]~input_o\);

-- Location: IOIBUF_X76_Y0_N18
\sip_in[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sip_in(2),
	o => \sip_in[2]~input_o\);

-- Location: IOIBUF_X30_Y81_N1
\sip_in[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sip_in(3),
	o => \sip_in[3]~input_o\);

-- Location: IOIBUF_X8_Y0_N18
\sip_in[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sip_in(4),
	o => \sip_in[4]~input_o\);

-- Location: IOIBUF_X4_Y81_N35
\sip_in[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sip_in(5),
	o => \sip_in[5]~input_o\);

-- Location: IOIBUF_X89_Y9_N38
\sip_in[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sip_in(6),
	o => \sip_in[6]~input_o\);

-- Location: IOIBUF_X10_Y0_N58
\sip_in[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sip_in(7),
	o => \sip_in[7]~input_o\);

-- Location: IOIBUF_X89_Y23_N38
\sip_in[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sip_in(8),
	o => \sip_in[8]~input_o\);

-- Location: IOIBUF_X89_Y9_N4
\sip_in[9]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sip_in(9),
	o => \sip_in[9]~input_o\);

-- Location: IOIBUF_X89_Y23_N55
\sip_in[10]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sip_in(10),
	o => \sip_in[10]~input_o\);

-- Location: IOIBUF_X80_Y0_N18
\sip_in[11]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sip_in(11),
	o => \sip_in[11]~input_o\);

-- Location: IOIBUF_X16_Y81_N1
\clock~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clock,
	o => \clock~input_o\);

-- Location: IOIBUF_X16_Y81_N35
\alu_reset~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_alu_reset,
	o => \alu_reset~input_o\);

-- Location: IOIBUF_X89_Y15_N4
\Clock_TEST~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Clock_TEST,
	o => \Clock_TEST~input_o\);

-- Location: MLABCELL_X65_Y36_N0
\~QUARTUS_CREATED_GND~I\ : cyclonev_lcell_comb
-- Equation(s):

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
;
END structure;


