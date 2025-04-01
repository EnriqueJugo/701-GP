library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_subtractor is
    generic (bit_width : integer := 8);
    port (
        A : in std_logic_vector(bit_width - 1 downto 0) := (others => '0');
        B : in std_logic_vector(bit_width - 1 downto 0) := (others => '0');
        add : in std_logic;
        Y : out std_logic_vector(bit_width - 1 downto 0)
    );
end adder_subtractor;

architecture beh of adder_subtractor is
begin
    with add select Y <=
        std_logic_vector(unsigned(A) + unsigned(B)) when '1',
        std_logic_vector(unsigned(A) - unsigned(B)) when '0';
end architecture; -- beh