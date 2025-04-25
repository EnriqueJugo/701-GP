library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
  port (
    clk             : in std_logic;
    reset           : in std_logic;
    addressing_mode : in std_logic_vector(1 downto 0);
    opcode          : in std_logic_vector(5 downto 0);

    -- Instruction Register (IR)
    ir_reset : out std_logic;
    ir_ld    : out std_logic;

    rf_a_sel : out std_logic;
    rf_b_sel : out std_logic_vector(1 downto 0);
    reg_dst  : out std_logic;

    -- Register File write select
    wr_data_sel : out std_logic_vector(1 downto 0); -- select data source for RF write
    rf_reset    : out std_logic;
    rf_wr       : out std_logic; -- write enable for destination register
    rf_a_re     : out std_logic;
    rf_b_re     : out std_logic;

    -- ALU inputs / memory controls
    rb_sel    : out std_logic_vector(1 downto 0); -- select B input for ALU
    mem_read  : out std_logic;
    mem_write : out std_logic;

    -- ALU
    reset_alu  : out std_logic;
    alu_op     : out std_logic_vector(2 downto 0);
    clr_z_flag : out std_logic;

    -- Memory Address Register (MAR)
    mar_sel   : out std_logic_vector(1 downto 0);
    mar_ld    : out std_logic;
    mar_reset : out std_logic;

    -- Program Counter controls
    pc_sel : out std_logic_vector(1 downto 0);

    -- DPCR controls
    dpcr_ld      : out std_logic;
    dpcr_reset   : out std_logic;
    dpcr_low_sel : out std_logic;

    -- SIP
    sip_ld    : out std_logic;
    sip_reset : out std_logic;

    -- SOP
    sop_ld    : out std_logic;
    sop_reset : out std_logic;

    -- GOSH DARN IT
    pc_reset    : out std_logic;
    address_sel : out std_logic;
    z_flag      : in std_logic
  );
end entity control_unit;

architecture fsm of control_unit is
  -- Micro-state declarations
  type state_type is (
    FETCH1,
    FETCH2,
    DECODE,
    EXEC_LDR,
    EXEC_STR,
    EXEC_JMP,
    EXEC_PRESENT,
    EXEC_ANDR,
    EXEC_ORR,
    EXEC_ADDR,
    EXEC_SUBR,
    EXEC_SUBVR,
    EXEC_CLFZ,
    EXEC_CER,
    EXEC_CEOT,
    EXEC_SEOT,
    EXEC_NOOP,
    EXEC_SZ,
    EXEC_LER,
    EXEC_SSVOP,
    EXEC_SSOP,
    EXEC_LSIP,
    EXEC_DATACALL_REG,
    EXEC_DATACALL_IMM,
    EXEC_MAX,
    EXEC_STRPC,
    EXEC_SRES
  );
  signal state, next_state : state_type;

  -- Opcode constants
  constant OP_LDR          : std_logic_vector(5 downto 0) := "000000";
  constant OP_STR          : std_logic_vector(5 downto 0) := "000010";
  constant OP_JMP          : std_logic_vector(5 downto 0) := "011000";
  constant OP_PRESENT      : std_logic_vector(5 downto 0) := "011100";
  constant OP_ANDR         : std_logic_vector(5 downto 0) := "001000";
  constant OP_ORR          : std_logic_vector(5 downto 0) := "001100";
  constant OP_ADDR         : std_logic_vector(5 downto 0) := "111000";
  constant OP_SUBR         : std_logic_vector(5 downto 0) := "000100";
  constant OP_SUBVR        : std_logic_vector(5 downto 0) := "000011";
  constant OP_CLFZ         : std_logic_vector(5 downto 0) := "010000";
  constant OP_CER          : std_logic_vector(5 downto 0) := "111100";
  constant OP_CEOT         : std_logic_vector(5 downto 0) := "111110";
  constant OP_SEOT         : std_logic_vector(5 downto 0) := "111111";
  constant OP_NOOP         : std_logic_vector(5 downto 0) := "110100";
  constant OP_SZ           : std_logic_vector(5 downto 0) := "010100";
  constant OP_LER          : std_logic_vector(5 downto 0) := "110110";
  constant OP_SSVOP        : std_logic_vector(5 downto 0) := "111011";
  constant OP_SSOP         : std_logic_vector(5 downto 0) := "111010";
  constant OP_LSIP         : std_logic_vector(5 downto 0) := "110111";
  constant OP_DATACALL_REG : std_logic_vector(5 downto 0) := "101000";
  constant OP_DATACALL_IMM : std_logic_vector(5 downto 0) := "101001";
  constant OP_MAX          : std_logic_vector(5 downto 0) := "011110";
  constant OP_STRPC        : std_logic_vector(5 downto 0) := "011101";
  constant OP_SRES         : std_logic_vector(5 downto 0) := "101010";

begin
  -- State register
  process (clk, reset)
  begin
    if reset = '1' then
      state <= FETCH1;
    elsif rising_edge(clk) then
      state <= next_state;
    end if;
  end process;

  -- FSM next-state and outputs
  process (state, opcode, reset)
  begin
    if (reset = '1') then
      -- default all controls off
      mar_sel     <= (others => '0');
      mar_ld      <= '0';
      mar_reset   <= '0';
      ir_reset    <= '0';
      ir_ld       <= '0';
      wr_data_sel <= "00";
      rf_reset    <= '0';
      rf_wr       <= '0';
      rb_sel      <= (others => '0');
      address_sel <= '0';
      mem_read    <= '0';
      mem_write   <= '0';
      reset_alu   <= '0';
      alu_op      <= (others => '0');
      clr_z_flag  <= '0';
      pc_sel      <= (others => '0');
      next_state  <= FETCH1;
    end if;

    case state is
      when FETCH1 =>
        -- T0: MAR ← PC ; PC ← PC+1
        mar_sel <= "00"; -- PC
        pc_sel  <= "10"; -- PC+1
        mar_ld  <= '1';

        next_state <= FETCH2;

      when FETCH2 =>
        -- T1: IR ← ProgMem[MAR]
        mar_ld     <= '0';
        mem_read   <= '1';
        ir_ld      <= '1';
        next_state <= DECODE;

      when DECODE =>
        -- T2: decode opcode
        if opcode = OP_LDR then
          next_state <= EXEC_LDR;
        elsif opcode = OP_STR then
          next_state <= EXEC_STR;
        elsif opcode = OP_JMP then
          next_state <= EXEC_JMP;
        elsif opcode = OP_PRESENT then
          next_state <= EXEC_PRESENT;
        elsif opcode = OP_ANDR then
          next_state <= EXEC_ANDR;
        elsif opcode = OP_ORR then
          next_state <= EXEC_ORR;
        elsif opcode = OP_ADDR then
          next_state <= EXEC_ADDR;
        elsif opcode = OP_SUBR then
          next_state <= EXEC_SUBR;
        elsif opcode = OP_SUBVR then
          next_state <= EXEC_SUBVR;
        elsif opcode = OP_CLFZ then
          next_state <= EXEC_CLFZ;
        elsif opcode = OP_NOOP then
          next_state <= EXEC_NOOP;
        elsif opcode = OP_SZ then
          next_state <= EXEC_SZ;
        elsif opcode = OP_LER then
          next_state <= EXEC_LER;
        elsif opcode = OP_SSVOP then
          next_state <= EXEC_SSVOP;
        elsif opcode = OP_SSOP then
          next_state <= EXEC_SSOP;
        elsif opcode = OP_LSIP then
          next_state <= EXEC_LSIP;
        elsif opcode = OP_DATACALL_REG then
          next_state <= EXEC_DATACALL_REG;
        elsif opcode = OP_DATACALL_IMM then
          next_state <= EXEC_DATACALL_IMM;
        elsif opcode = OP_MAX then
          next_state <= EXEC_MAX;
        elsif opcode = OP_STRPC then
          next_state <= EXEC_STRPC;
        elsif opcode = OP_SRES then
          next_state <= EXEC_SRES;
        else
          next_state <= FETCH1;
        end if;

      when EXEC_LDR =>
        case addressing_mode is
          when "01" => -- Immediate
            wr_data_sel <= "00";
            rf_wr       <= '1';
            next_state  <= FETCH1;
          when "10" => -- Direct
            mar_sel     <= "01";
            mar_ld      <= '1';
            mem_read    <= '1';
            wr_data_sel <= "01";
            rf_wr       <= '1';
            next_state  <= FETCH1;
          when "11" => -- Indirect
            mar_sel     <= "00";
            mar_ld      <= '1';
            mem_read    <= '1';
            wr_data_sel <= "01";
            rf_wr       <= '1';
            next_state  <= FETCH1;
          when others =>
            next_state <= FETCH1;
        end case;
      when EXEC_STR =>
        -- T3: compute EA
        rb_sel    <= "01";
        reset_alu <= '1';
        alu_op    <= "000";
        mar_sel   <= "01";
        mar_ld    <= '1';
        -- T4: store data
        rb_sel      <= "01"; -- Rx
        address_sel <= '1';
        mem_write   <= '1';
        next_state  <= FETCH1;
        case addressing_mode is
          when "01" => -- Immediate
            rf_b_sel   <= "01";
            rf_a_sel   <= '1';
            rf_a_re    <= '0';
            rf_b_re    <= '1';
            mar_sel    <= "01";
            mar_ld     <= '1';
            mem_write  <= '1';
            mem_read   <= '0';
            next_state <= FETCH1;
          when "10" => -- Direct
            rf_b_sel   <= "01";
            rf_a_sel   <= '1';
            rf_a_re    <= '0';
            rf_b_re    <= '1';
            mar_sel    <= "01";
            mar_ld     <= '1';
            mem_write  <= '1';
            mem_read   <= '0';
            next_state <= FETCH1;
          when "11" => -- Indirect
            next_state <= FETCH1;
          when others =>
            next_state <= FETCH1;
        end case;

      when EXEC_JMP =>
        -- T3: PC ← target
        rb_sel     <= "01";
        reset_alu  <= '1';
        alu_op     <= "000";
        pc_sel     <= "01";
        next_state <= FETCH1;

        case addressing_mode is
          when "01" => -- Immediate
            pc_sel     <= "01";
            next_state <= FETCH1;
          when "10" => -- Direct
            mar_sel    <= "01";
            mar_ld     <= '1';
            mem_read   <= '1';
            pc_sel     <= "11";
            next_state <= FETCH1;
          when others =>
            next_state <= FETCH1;
        end case;

      when EXEC_PRESENT =>
        -- T3: TEST PRESENT Rz, Rx
        rf_a_sel  <= '0';
        rf_a_re   <= '1';
        rb_sel    <= "00";
        reset_alu <= '1';
        alu_op    <= "000";
        if z_flag = '1' then
          pc_sel     <= "01";
          clr_z_flag <= '1';
        end if;
        next_state <= FETCH1;

      when EXEC_ANDR =>
        -- T3: Rz ← Rz AND Rx
        case addressing_mode is
          when "01" => -- Immediate
            rf_a_sel    <= '1';
            rf_a_re     <= '1';
            rf_b_re     <= '0';
            rb_sel      <= "01";
            alu_op      <= "010";
            reset_alu   <= '1';
            wr_data_sel <= "10";
            rf_wr       <= '1';

            next_state <= FETCH1;

          when "10" => -- Direct
            rf_a_sel    <= '1';
            rf_a_re     <= '1';
            rf_b_re     <= '0';
            reset_alu   <= '1';
            rb_sel      <= "11";
            alu_op      <= "010";
            wr_data_sel <= "10";
            rf_wr       <= '1';
            next_state  <= FETCH1;
          when others =>
            next_state <= FETCH1;
        end case;

      when EXEC_ORR =>
        case addressing_mode is
          when "01" => -- Immediate
            rf_a_sel    <= '1';
            rf_a_re     <= '1';
            rf_b_re     <= '0';
            rb_sel      <= "01";
            alu_op      <= "010";
            reset_alu   <= '1';
            wr_data_sel <= "10";
            rf_wr       <= '1';

            next_state <= FETCH1;
          when "10" => -- Direct
            next_state <= FETCH1;
          when others =>
            next_state <= FETCH1;
        end case;

      when EXEC_ADDR =>
        -- T3: Rz ← Rz + (#imm/Rx)
        rb_sel     <= "10"; -- imm or Rx
        reset_alu  <= '1';
        alu_op     <= "000";
        rf_wr      <= '1';
        next_state <= FETCH1;

      when EXEC_SUBR =>
        -- T3: Rz ← Rz - Rx
        rb_sel     <= "01";
        reset_alu  <= '1';
        alu_op     <= "110";
        rf_wr      <= '1';
        next_state <= FETCH1;

      when EXEC_SUBVR =>
        -- T3: Rz ← Rz - #imm
        rb_sel     <= "10";
        reset_alu  <= '1';
        alu_op     <= "110";
        rf_wr      <= '1';
        next_state <= FETCH1;

      when EXEC_CLFZ =>
        -- T3: clear Z flag
        clr_z_flag <= '1';
        next_state <= FETCH1;

      when EXEC_NOOP =>
        -- NOP
        next_state <= FETCH1;

      when EXEC_SZ =>
        -- Set Z-flag based on immediate
        rb_sel     <= "10"; -- Immediate value
        alu_op     <= "110"; -- SUB operation to test for zero
        reset_alu  <= '1';
        next_state <= FETCH1;

      when EXEC_SSOP =>
        rf_a_sel   <= '1';
        rf_a_re    <= '1';
        rf_b_re    <= '0';
        sop_ld     <= '1';
        next_state <= FETCH1;

      when EXEC_LSIP =>
        reg_dst     <= '0';
        sip_ld      <= '1';
        mem_write   <= '1';
        wr_data_sel <= "11";

        next_state <= FETCH1;

      when EXEC_DATACALL_REG =>
        rf_a_sel     <= '1';
        rf_b_sel     <= "00";
        rf_a_re      <= '1';
        rf_b_re      <= '1';
        dpcr_low_sel <= '0';
        dpcr_ld      <= '1';

        next_state <= FETCH1;

      when EXEC_DATACALL_IMM =>
        -- Data Call (Immediate)
        rf_a_sel     <= '1';
        rf_a_re      <= '1';
        rf_b_re      <= '0';
        dpcr_low_sel <= '1';
        dpcr_ld      <= '1';
        next_state   <= FETCH1;

      when EXEC_MAX =>
        -- MAX Rz, #imm
        rb_sel     <= "10"; -- Immediate
        alu_op     <= "110"; -- SUB (to compare)
        reset_alu  <= '1';
        rf_wr      <= '1'; -- Conditionally done (assuming internal logic)
        next_state <= FETCH1;

      when EXEC_STRPC =>
        -- Store PC to Address
        mar_sel     <= "10"; -- Immediate address
        mar_ld      <= '1';
        address_sel <= '1';
        mem_write   <= '1';
        pc_sel      <= "00"; -- Current PC
        next_state  <= FETCH1;

      when EXEC_SRES =>
        -- System Reset
        mar_reset  <= '1';
        ir_reset   <= '1';
        rf_reset   <= '1';
        reset_alu  <= '1';
        next_state <= FETCH1;

      when others =>
        next_state <= FETCH1;
    end case;
  end process;
end architecture fsm;
