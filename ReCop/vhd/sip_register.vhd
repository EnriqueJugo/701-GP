library ieee;
use ieee.std_logic_1164.all;

entity sip_register is
    port (
        clk        : in  std_logic;
        sip_reset  : in  std_logic;
        sip_ld     : in  std_logic;  -- Load enable (used by FSM when SSIP or similar)
        sip_in     : in  std_logic_vector(15 downto 0);
        sip_out    : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of sip_register is
    signal sip_reg : std_logic_vector(15 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if sip_reset = '1' then
                sip_reg <= (others => '0');
            elsif sip_ld = '1' then
                sip_reg <= sip_in;
            end if;
        end if;
    end process;

    sip_out <= sip_reg;
end architecture;
