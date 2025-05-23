library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ReCOP_TopLevel is
  port (
    clk            : in std_logic;
    reset          : in std_logic;
    sip_input      : in std_logic_vector(15 downto 0);
    sop_output     : out std_logic_vector(15 downto 0);
    pc_ld_tb       : out std_logic;
    pc_out_tb      : out std_logic_vector(15 downto 0);
    pc_plus_one_tb : out std_logic_vector(15 downto 0);
    pc_sel_tb      : out std_logic_vector(1 downto 0);
    state_tb       : out std_logic_vector(5 downto 0);
    inst_tb        : out std_logic_vector(31 downto 0);
    ir_ld_tb       : out std_logic;
    opcode_tb      : out std_logic_vector(5 downto 0);
    ir_reset_tb    : out std_logic;
    rf_ra_tb       : out std_logic_vector(15 downto 0);
    rf_rb_tb       : out std_logic_vector(15 downto 0);
    rf_data_in_tb  : out std_logic_vector(15 downto 0);
    rf_data_sel_tb : out std_logic_vector(1 downto 0);
    sip_ld_tb      : out std_logic;
    sip_reset_tb   : out std_logic;
    sip_data_tb    : out std_logic_vector(15 downto 0);
    sop_ld_tb      : out std_logic;
    sop_reset_tb   : out std_logic;
    z_flag_out     : out std_logic
  );
end entity;

architecture structural of ReCOP_TopLevel is

  -- Internal signal connections between control unit and datapath
  signal pc_sel, mar_sel      : std_logic_vector(1 downto 0);
  signal wr_data_sel          : std_logic_vector(1 downto 0);
  signal alu_op               : std_logic_vector(2 downto 0);
  signal rb_sel, rf_b_sel     : std_logic_vector(1 downto 0);
  signal rf_a_sel, reg_dst    : std_logic;
  signal rf_reset, rf_wr      : std_logic;
  signal rf_a_re, rf_b_re     : std_logic;
  signal ir_ld, ir_reset      : std_logic;
  signal mar_ld, mar_reset    : std_logic;
  signal mem_read, mem_write  : std_logic;
  signal pc_reset             : std_logic;
  signal clr_z_flag           : std_logic;
  signal reset_alu            : std_logic;
  signal address_sel          : std_logic;
  signal sop_reset, sop_ld    : std_logic;
  signal sip_reset, sip_ld    : std_logic;
  signal svop_reset, svop_ld  : std_logic;
  signal dpcr_ld, dpcr_reset  : std_logic;
  signal dpcr_low_sel         : std_logic;
  signal pc_ld                : std_logic;
  signal alu_ra_sel           : std_logic_vector(1 downto 0);
  signal alu_rb_sel           : std_logic_vector(1 downto 0);
  signal data_mem_wr_data_sel : std_logic_vector(1 downto 0);

  signal er_ld, er_clear, eot_ld, eot_clear : std_logic;

  signal rf_alu_er_sel : std_logic;
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
      clk                  => clk,
      reset                => reset,
      addressing_mode      => addressing_mode,
      opcode               => opcode,
      ir_reset             => ir_reset,
      ir_ld                => ir_ld,
      rf_a_sel             => rf_a_sel,
      rf_b_sel             => rf_b_sel,
      reg_dst              => reg_dst,
      wr_data_sel          => wr_data_sel,
      rf_reset             => rf_reset,
      rf_wr                => rf_wr,
      rf_a_re              => rf_a_re,
      rf_b_re              => rf_b_re,
      mem_read             => mem_read,
      mem_write            => mem_write,
      reset_alu            => reset_alu,
      alu_op               => alu_op,
      clr_z_flag           => clr_z_flag,
      mar_sel              => mar_sel,
      mar_ld               => mar_ld,
      mar_reset            => mar_reset,
      pc_sel               => pc_sel,
      dpcr_ld              => dpcr_ld,
      dpcr_reset           => dpcr_reset,
      dpcr_low_sel         => dpcr_low_sel,
      sip_ld               => sip_ld,
      sip_reset            => sip_reset,
      sop_ld               => sop_ld,
      sop_reset            => sop_reset,
      pc_reset             => pc_reset,
      address_sel          => address_sel,
      z_flag               => z_flag,
      pc_ld                => pc_ld,
      alu_ra_sel           => alu_ra_sel,
      alu_rb_sel           => alu_rb_sel,
      data_mem_wr_data_sel => data_mem_wr_data_sel,
      svop_ld              => svop_ld,
      svop_reset           => svop_reset,
      er_ld                => er_ld,
      er_clear             => er_clear,
      eot_ld               => eot_ld,
      eot_clear            => eot_clear,
      rf_alu_er_sel        => rf_alu_er_sel,
      state_out            => state_tb
    );

  pc_ld_tb       <= pc_ld;
  pc_sel_tb      <= pc_sel;
  ir_ld_tb       <= ir_ld;
  opcode_tb      <= opcode;
  ir_reset_tb    <= ir_reset;
  rf_data_sel_tb <= wr_data_sel;
  sip_ld_tb      <= sip_ld;
  sip_reset_tb   <= sip_reset;
  sop_ld_tb      <= sop_ld;
  sop_reset_tb   <= sop_reset;

  -- Instantiate the datapath
  datapath_inst : entity work.datapath
    port map
    (
      clk                  => clk,
      pc_reset             => pc_reset,
      pc_sel               => pc_sel,
      dpcr_ld              => dpcr_ld,
      dpcr_reset           => dpcr_reset,
      dpcr_low_sel         => dpcr_low_sel,
      ir_ld                => ir_ld,
      ir_reset             => ir_reset,
      mem_write            => mem_write,
      mem_read             => mem_read,
      mar_sel              => mar_sel,
      mar_ld               => mar_ld,
      mar_reset            => mar_reset,
      rf_reset             => rf_reset,
      rf_write             => rf_wr,
      rf_a_read            => rf_a_re,
      rf_b_read            => rf_b_re,
      rf_a_sel             => rf_a_sel,
      rf_b_sel             => rf_b_sel,
      sop_reset            => sop_reset,
      sop_ld               => sop_ld,
      sip_reset            => sip_reset,
      sip_ld               => sip_ld,
      sip_in               => sip_input,
      alu_reset            => reset_alu,
      alu_op               => alu_op,
      addr_sel             => address_sel,
      clr_z_flag           => clr_z_flag,
      wr_data_sel          => wr_data_sel,
      pc_out               => pc_out_tb,
      dpcr_out             => open,
      inst_out             => inst_tb,
      addr_mode            => addressing_mode,
      opcode               => opcode,
      sop_out              => sop_output,
      z_flag               => z_flag,
      read_data_out        => open,
      pc_ld                => pc_ld,
      alu_ra_sel           => alu_ra_sel,
      alu_rb_sel           => alu_rb_sel,
      data_mem_wr_data_sel => data_mem_wr_data_sel,
      svop_ld              => svop_ld,
      svop_reset           => svop_reset,
      er_ld                => er_ld,
      er_clear             => er_clear,
      eot_ld               => eot_ld,
      eot_clear            => eot_clear,
      alu_er_sel           => rf_alu_er_sel,
      pc_plus_one          => pc_plus_one_tb,
      rf_ra_out            => rf_ra_tb,
      rf_rb_out            => rf_rb_tb,
      rf_data_in           => rf_data_in_tb,
      sip_data_out         => sip_data_tb
    );

  z_flag_out <= z_flag;

end architecture;
