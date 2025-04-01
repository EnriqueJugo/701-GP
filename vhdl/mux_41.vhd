library ieee;
use ieee.std_logic_1164.all;

entity mux_4 is
    generic (bit_width : integer := 8);
    port (
        sel : in std_logic_vector(1 downto 0);
        A   : in std_logic_vector(bit_width - 1 downto 0);
        B   : in std_logic_vector(bit_width - 1 downto 0);
        C   : in std_logic_vector(bit_width - 1 downto 0);
        D   : in std_logic_vector(bit_width - 1 downto 0);
        Y   : out std_logic_vector(bit_width - 1 downto 0)
    );
end mux_4;

architecture beh of mux_4 is
begin
    with sel select y <=
        A when "00",
        B when "01",
        C when "10",
        D when "11";

end architecture; -- beh