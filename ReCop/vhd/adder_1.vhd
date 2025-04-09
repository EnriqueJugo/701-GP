library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_1 is
  generic (bit_width : integer := 8);
  port (
    A : in std_logic_vector(bit_width - 1 downto 0) := (others => '0');
    Y : out std_logic_vector(bit_width - 1 downto 0)
  );
end adder_1;

architecture beh of adder_1 is
begin
  Y <= std_logic_vector(unsigned(A) + 1);
end architecture; -- beh