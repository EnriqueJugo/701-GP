library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ReCOP_TopLevel is
  port (
    clk        : in std_logic;
    reset      : in std_logic;
    sip_input  : in std_logic_vector(15 downto 0);
    z_flag_out : out std_logic
  );
end entity;

architecture structural of ReCOP_TopLevel is

  -- Internal signal connections between control unit and datapath
  signal pc_sel, mar_sel     : std_logic_vector(1 downto 0);
  signal wr_data_sel         : std_logic_vector(1 downto 0);
  signal alu_op              : std_logic_vector(2 downto 0);
  signal rb_sel, rf_b_sel    : std_logic_vector(1 downto 0);
  signal rf_a_sel, reg_dst   : std_logic;
  signal rf_reset, rf_wr     : std_logic;
  signal rf_a_re, rf_b_re    : std_logic;
  signal ir_ld, ir_reset     : std_logic;
  signal mar_ld, mar_reset   : std_logic;
  signal mem_read, mem_write : std_logic;
  signal pc_reset            : std_logic;
  signal clr_z_flag          : std_logic;
  signal reset_alu           : std_logic;
  signal address_sel         : std_logic;
  signal sop_reset, sop_ld   : std_logic;
  signal sip_reset, sip_ld   : std_logic;
  signal dpcr_ld, dpcr_reset : std_logic;
  signal dpcr_low_sel        : std_logic;
  signal pc_inc              : std_logic;

  -- Instruction decoder outputs
  signal addressing_mode : std_logic_vector(1 downto 0);
  signal opcode          : std_logic_vector(5 downto 0);

  -- Feedback signal from datapath
  signal z_flag : std_logic;

begin

  -- Instantiate the control unit
  control : entity work.control_unit
    port map
    (
      clk             => clk,
      reset           => reset,
      addressing_mode => addressing_mode,
      opcode          => opcode,
      ir_reset        => ir_reset,
      ir_ld           => ir_ld,
      rf_a_sel        => rf_a_sel,
      rf_b_sel        => rf_b_sel,
      reg_dst         => reg_dst,
      wr_data_sel     => wr_data_sel,
      rf_reset        => rf_reset,
      rf_wr           => rf_wr,
      rf_a_re         => rf_a_re,
      rf_b_re         => rf_b_re,
      rb_sel          => rb_sel,
      mem_read        => mem_read,
      mem_write       => mem_write,
      reset_alu       => reset_alu,
      alu_op          => alu_op,
      clr_z_flag      => clr_z_flag,
      mar_sel         => mar_sel,
      mar_ld          => mar_ld,
      mar_reset       => mar_reset,
      pc_sel          => pc_sel,
      dpcr_ld         => dpcr_ld,
      dpcr_reset      => dpcr_reset,
      dpcr_low_sel    => dpcr_low_sel,
      sip_ld          => sip_ld,
      sip_reset       => sip_reset,
      sop_ld          => sop_ld,
      sop_reset       => sop_reset,
      pc_reset        => pc_reset,
      address_sel     => address_sel,
      z_flag          => z_flag,
      pc_inc          => pc_inc
    );

  -- Instantiate the datapath
  datapath_inst : entity work.datapath
    port map
    (
      clk           => clk,
      pc_reset      => pc_reset,
      pc_sel        => pc_sel,
      dcpr_ld       => dpcr_ld,
      dcpr_reset    => dpcr_reset,
      dcpr_low_set  => dpcr_low_sel,
      ir_ld         => ir_ld,
      ir_reset      => ir_reset,
      mem_write     => mem_write,
      mem_read      => mem_read,
      mar_sel       => mar_sel,
      mar_ld        => mar_ld,
      mar_reset     => mar_reset,
      rf_reset      => rf_reset,
      rf_write      => rf_wr,
      rf_a_read     => rf_a_re,
      rf_b_read     => rf_b_re,
      rf_a_sel      => rf_a_sel,
      rf_b_sel      => rf_b_sel,
      sop_reset     => sop_reset,
      sop_ld        => sop_ld,
      sip_reset     => sip_reset,
      sip_ld        => sip_ld,
      sip_in        => sip_input,
      alu_reset     => reset_alu,
      alu_op        => alu_op,
      alu_rb_sel    => rb_sel,
      addr_sel      => address_sel,
      clr_z_flag    => clr_z_flag,
      wr_data_sel   => wr_data_sel,
      pc_out        => open,
      dcpr_out      => open,
      inst_out      => open,
      addr_mode     => addressing_mode,
      opcode        => opcode,
      sop_out       => open,
      z_flag        => z_flag,
      read_data_out => open,
      pc_inc        => pc_inc
    );

  z_flag_out <= z_flag;

end architecture;
