library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcodes.all;

entity control_unit is
  port (
    clk    : in std_logic;
    reset  : in std_logic;
    opcode : in std_logic_vector(5 downto 0);
  );
end entity control_unit;

architecture rtl of control_unit is

begin

end architecture;