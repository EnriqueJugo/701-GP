library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity datapath is
  port (
    clk : in std_logic;

    pc_reset : in std_logic;
    pc_sel   : in std_logic_vector(1 downto 0);
    pc_inc   : in std_logic;

    dcpr_ld      : in std_logic;
    dcpr_reset   : in std_logic;
    dcpr_low_set : in std_logic;

    ir_ld    : in std_logic;
    ir_reset : in std_logic;

    mem_write : in std_logic;
    mem_read  : in std_logic;

    mar_sel   : in std_logic_vector(1 downto 0);
    mar_ld    : in std_logic;
    mar_reset : in std_logic;

    rf_reset  : in std_logic;
    rf_write  : in std_logic;
    rf_a_read : in std_logic;
    rf_b_read : in std_logic;
    rf_a_sel  : in std_logic;
    rf_b_sel  : in std_logic_vector(1 downto 0);

    sop_reset : in std_logic;
    sop_ld    : in std_logic;

    sip_reset  : in std_logic;
    sip_ld     : in std_logic;
    sip_in     : in std_logic_vector(15 downto 0);
    alu_reset  : in std_logic;
    alu_op     : in std_logic_vector(2 downto 0);
    alu_rb_sel : in std_logic_vector(1 downto 0);
    addr_sel   : in std_logic;

    clr_z_flag : in std_logic;

    wr_data_sel : in std_logic_vector(1 downto 0);

    pc_out        : out std_logic_vector(15 downto 0);
    dcpr_out      : out std_logic_vector(31 downto 0);
    inst_out      : out std_logic_vector(31 downto 0);
    addr_mode     : out std_logic_vector(1 downto 0);
    opcode        : out std_logic_vector(5 downto 0);
    sop_out       : out std_logic_vector(15 downto 0);
    z_flag        : out std_logic;
    read_data_out : out std_logic_vector(15 downto 0)
  );
end entity datapath;

architecture rtl of datapath is

  component adder_1
    generic (
      bit_width : integer
    );
    port (
      adder_in  : in std_logic_vector(15 downto 0);
      adder_out : out std_logic_vector(15 downto 0)
    );
  end component;

  component alu
    port (
      clk        : in std_logic;
      clr_z_flag : in std_logic;
      alu_reset  : in std_logic;
      alu_op     : in std_logic_vector(2 downto 0);
      ra         : in std_logic_vector(15 downto 0);
      rb         : in std_logic_vector(15 downto 0);
      z_flag     : out std_logic;
      alu_result : out std_logic_vector(15 downto 0)
    );
  end component;

  component dpcr_register
    port (
      clk        : in std_logic;
      dpcr_ld    : in std_logic;
      dpcr_reset : in std_logic;
      high_in    : in std_logic_vector(15 downto 0);
      low_in     : in std_logic_vector(15 downto 0);
      dpcr_out   : out std_logic_vector(31 downto 0)
    );
  end component;

  component mux_4
    port (
      data0x : in std_logic_vector(15 downto 0);
      data1x : in std_logic_vector(15 downto 0);
      data2x : in std_logic_vector(15 downto 0);
      data3x : in std_logic_vector(15 downto 0);
      sel    : in std_logic_vector(1 downto 0);
      result : out std_logic_vector(15 downto 0)
    );
  end component;

  component data_memory
    port (
      clock      : in std_logic;
      mem_write  : in std_logic;
      mem_read   : in std_logic;
      address    : in std_logic_vector(15 downto 0);
      write_data : in std_logic_vector(15 downto 0);
      read_data  : out std_logic_vector(15 downto 0)
    );
  end component;

  component prog_mem
    port (
      clock   : in std_logic;
      address : in std_logic_vector(15 downto 0);
      q       : out std_logic_vector(31 downto 0)
    );
  end component;

  component mux_2
    port (
      sel    : in std_logic;
      data0x : in std_logic_vector(15 downto 0);
      data1x : in std_logic_vector(15 downto 0);
      result : out std_logic_vector(15 downto 0)
    );
  end component;

  component register_file
    port (
      clk         : in std_logic;
      rf_reset    : in std_logic;
      rf_wr       : in std_logic;
      rf_a_re     : in std_logic;
      rf_b_re     : in std_logic;
      read_reg_a  : in std_logic_vector(3 downto 0);
      read_reg_b  : in std_logic_vector(3 downto 0);
      write_data  : in std_logic_vector(15 downto 0);
      write_reg   : in std_logic_vector(3 downto 0);
      read_data_a : out std_logic_vector(15 downto 0);
      read_data_b : out std_logic_vector(15 downto 0)
    );
  end component;

  component instruction_register
    port (
      clk       : in std_logic;
      reset     : in std_logic;
      ir_ld     : in std_logic;
      ir_data   : in std_logic_vector(31 downto 0);
      addr_mode : out std_logic_vector(1 downto 0);
      opcode    : out std_logic_vector(5 downto 0);
      s_operand : out std_logic_vector(15 downto 0);
      rx        : out std_logic_vector(3 downto 0);
      rz        : out std_logic_vector(3 downto 0)
    );
  end component;

  component memory_address_register
    generic (
      bit_width : integer
    );
    port (
      clk       : in std_logic;
      mar_ld    : in std_logic;
      mar_reset : in std_logic;
      mar_in    : in std_logic_vector(15 downto 0);
      mar_out   : out std_logic_vector(15 downto 0)
    );
  end component;

  component mux_3
    port (
      data0x : in std_logic_vector(15 downto 0);
      data1x : in std_logic_vector(15 downto 0);
      data2x : in std_logic_vector(15 downto 0);
      sel    : in std_logic_vector(1 downto 0);
      result : out std_logic_vector(15 downto 0)
    );
  end component;

  component mux_2_4bit
    port (
      sel    : in std_logic;
      data0x : in std_logic_vector(3 downto 0);
      data1x : in std_logic_vector(3 downto 0);
      result : out std_logic_vector(3 downto 0)
    );
  end component;

  component mux_3_4bit
    port (
      data0x : in std_logic_vector(3 downto 0);
      data1x : in std_logic_vector(3 downto 0);
      data2x : in std_logic_vector(3 downto 0);
      sel    : in std_logic_vector(1 downto 0);
      result : out std_logic_vector(3 downto 0)
    );
  end component;

  component program_counter
    port (
      clk      : in std_logic;
      pc_reset : in std_logic;
      pc_in    : in std_logic_vector(15 downto 0);
      pc_out   : out std_logic_vector(15 downto 0)
    );
  end component;

  component sip_register
    port (
      clk       : in std_logic;
      sip_reset : in std_logic;
      sip_ld    : in std_logic;
      sip_in    : in std_logic_vector(15 downto 0);
      sip_out   : out std_logic_vector(15 downto 0)
    );
  end component;

  component sop_register
    port (
      clk       : in std_logic;
      sop_reset : in std_logic;
      sop_ld    : in std_logic;
      sop_in    : in std_logic_vector(15 downto 0);
      sop_out   : out std_logic_vector(15 downto 0)
    );
  end component;

  -- Internal Signals
  signal s_pc_mux_out   : std_logic_vector(15 downto 0);
  signal s_pc_out       : std_logic_vector(15 downto 0);
  signal s_pc_plus_one  : std_logic_vector(15 downto 0);
  signal s_data_mem_out : std_logic_vector(15 downto 0);
  signal s_operand      : std_logic_vector(15 downto 0);
  signal s_rx_out       : std_logic_vector(15 downto 0);

  signal s_instruction : std_logic_vector(31 downto 0);
  signal s_addr_mode   : std_logic_vector(1 downto 0);
  signal s_rx          : std_logic_vector(3 downto 0);
  signal s_rz          : std_logic_vector(3 downto 0);

  signal s_rx_integer : integer range 0 to 15;
  signal s_rz_integer : integer range 0 to 15;
  signal s_rf_data_in : std_logic_vector(15 downto 0);
  signal s_rf_ra_data : std_logic_vector(15 downto 0);
  signal s_rf_rb_data : std_logic_vector(15 downto 0);
  signal s_rz_mux_out : std_logic_vector(3 downto 0);
  signal s_rx_mux_out : std_logic_vector(3 downto 0);

begin

  program_counter_inst : entity work.program_counter
    port map
    (
      clk      => pc_inc,
      pc_in    => s_pc_mux_out,
      pc_reset => pc_reset,
      pc_out   => s_pc_out
    );

  pc_out <= s_pc_out;

  adder_1_inst : entity work.adder_1
    generic map(
      bit_width => 16
    )
    port map
    (
      adder_in  => s_pc_out,
      adder_out => s_pc_plus_one
    );

  mux_4_inst : entity work.mux_4
    port map
    (
      data0x => s_rx_out,
      data1x => s_operand,
      data2x => s_pc_plus_one,
      data3x => s_data_mem_out,
      sel    => pc_sel,
      result => s_pc_mux_out
    );

  prog_mem_inst : entity work.prog_mem
    port map
    (
      address => s_pc_out,
      clock   => clk,
      q       => s_instruction
    );

  inst_out <= s_instruction;

  instruction_register_inst : entity work.instruction_register
    port map
    (
      clk       => clk,
      reset     => ir_reset,
      ir_ld     => ir_ld,
      ir_data   => s_instruction,
      addr_mode => s_addr_mode,
      opcode    => opcode,
      operand   => s_operand,
      rx        => s_rx,
      rz        => s_rz
    );

  s_rz_integer <= to_integer(unsigned(s_rz_mux_out));
  s_rx_integer <= to_integer(unsigned(s_rx_mux_out));

  mux_3_4bit_inst : entity work.mux_3_4bit
    port map
    (
      data0x => "0111",
      data1x => s_rz,
      data2x => s_rx,
      sel    => rf_b_sel,
      result => s_rx_mux_out
    );

  mux_2_4bit_inst : entity work.mux_2_4bit
    port map
    (
      sel    => rf_a_sel,
      data0x => s_rz,
      data1x => s_rx,
      result => s_rz_mux_out
    );
  register_file_inst : entity work.register_file
    port map
    (
      clk         => clk,
      rf_reset    => rf_reset,
      rf_wr       => rf_write,
      rf_a_re     => rf_a_read,
      rf_b_re     => rf_b_read,
      read_reg_a  => s_rz_integer,
      read_reg_b  => s_rx_integer,
      write_reg   => s_rz,
      write_data  => s_rf_data_in,
      read_data_a => s_rf_ra_data,
      read_data_b => s_rf_rb_data
    );

end rtl;