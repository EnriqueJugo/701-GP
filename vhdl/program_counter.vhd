library ieee;
use ieee.std_logic_1164.all;

entity program_counter is
    port (
        clk    : in std_logic;
        pc_in  : in integer;
        pc_out : out integer;
    );
end program_counter;

architecture beh of program_counter is

begin

    p1 : process (clk)
    begin
        if (rising_edge(clk)) then
            pc_out <= pc_in;
        end if;
    end process; -- p1

end architecture; -- beh