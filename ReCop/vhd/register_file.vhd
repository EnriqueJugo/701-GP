library ieee;
use ieee.std_logic_1164.all;

use IEEE.numeric_std.all;

use work.recop_types.all;
use work.various_constants.all;

entity register_file is
  port (
    clk   : in std_logic;
    reset : in std_logic;
    ld_rz : in std_logic;

    -- Address to Rx and Rz registers
    rz_addr : in integer range 0 to 15;
    rx_addr : in integer range 0 to 15;
    data_in : in std_logic_vector(15 downto 0);
    rz_out  : out std_logic_vector(15 downto 0);
    rx_out  : out std_logic_vector(15 downto 0)
  );
end entity register_file;

architecture rtl of register_file is
  type reg_array is array (0 to 15) of std_logic_vector(15 downto 0);
  signal regs : reg_array := (others => (others => '0'));
  signal rz   : std_logic_vector(15 downto 0);
  signal rx   : std_logic_vector(15 downto 0);
begin
  process (clk, reset)
  begin
    if reset = '1' then
      regs <= (others => (others => '0'));
    elsif rising_edge(clk) then
      -- Keep register 0 to only be 0
      regs(0) <= x"0000";
      -- Load date in Register Z
      if ld_rz = '1' and rz_addr /= 0 then
        regs(rz_addr) <= data_in;
      else

      end if;
    end if;
  end process;

  rz_out <= regs(rz_addr);
  rx_out <= regs(rx_addr);
end architecture;