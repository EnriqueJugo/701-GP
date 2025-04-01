library ieee;
use ieee.std_logic_1164.all;

entity mux_2 is
    generic (bit_width : integer := 8);
    port (
        sel : in std_logic;
        A   : in std_logic_vector(bit_width - 1 downto 0);
        B   : in std_logic_vector(bit_width - 1 downto 0);
        Y   : out std_logic_vector(bit_width - 1 downto 0)
    );
end mux_2;

architecture beh of mux_2 is
begin
    with sel select Y <=
        A when '0',
        B when '1';
end architecture; -- beh