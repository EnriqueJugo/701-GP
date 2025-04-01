library ieee;
use ieee.std_logic_1164.all;

entity ReCop_Testbench is
end entity ReCop_Testbench;

architecture rtl of ReCop_Testbench is

  component ReCop is
    port (
      CLOCK_50 : in std_logic;
      clk_0    : out std_logic;
      clk_1    : out std_logic
    );
  end component;

  signal clk_in, clk_0, clk_1 : std_logic := '0';
begin

  ReCOP_inst : entity work.ReCOP
    port map
    (
      CLOCK_50 => clk_in,
      clk_0    => clk_0,
      clk_1    => clk_1
    );

  clk_in <= '1' after 1 ns, '0' after 2 ns, '1' after 3 ns, '0' after 4 ns, '1' after 5 ns, '0' after 6 ns;

end architecture;