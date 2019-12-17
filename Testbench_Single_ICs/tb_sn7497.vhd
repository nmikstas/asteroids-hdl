--Test bench for the SN7497 rate multiplier.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn7497 is
end tb_sn7497;

architecture Behavioral of tb_sn7497 is

    constant CLK_PERIOD : time := 1 ns;

    signal clk    : std_logic := '0';
    signal clr    : std_logic := '1';
    signal b      : std_logic_vector(5 downto 0);
    signal en_out : std_logic;
    signal y      : std_logic;
    signal z      : std_logic;

begin

    --Define clock based on the clock period and assert clear for 10 clock periods.
    clk  <= NOT clk after CLK_PERIOD / 2;
    clr  <= '0' after 10 * CLK_PERIOD;

    sn7497_0: entity work.sn7497
    port map
    (
        clk       => clk,
        clr       => clr,
        en_in     => '0',
        strb      => '0',
        unity_cas => '1',
        b         => b,
        en_out    => en_out,
        y         => y,
        z         => z
    );

    process
    begin
        b <= "011111";
        wait for 300 ns; --Wait some time for the output results.
        std.env.stop;    --End the simulation.
    end process;
end Behavioral;