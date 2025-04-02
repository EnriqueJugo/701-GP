library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
  generic (bit_width : integer := 8);
  port (
    A   : in std_logic_vector(bit_width - 1 downto 0) := (others => '0');
    add : in std_logic;
    Y   : out std_logic_vector(bit_width - 1 downto 0)
  );
end add_sub;

architecture beh of add_sub is
begin
  with add select Y <=
    std_logic_vector(unsigned(A) + 1) when '1',
    std_logic_vector(unsigned(A) - 1) when '0';
end architecture; -- beh