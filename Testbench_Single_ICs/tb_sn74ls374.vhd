--Test bench for the SN74LS374 octal flip-flop.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn74ls374 is
end tb_sn74ls374;

architecture behavioral of tb_sn74ls374 is

    constant CLK_PERIOD : time := 1 ns;

    signal clk : std_logic := '0';
    signal oc  : std_logic := '1';
    signal d   : std_logic_vector(7 downto 0) := "00000000";
    signal q   : std_logic_vector(7 downto 0);

begin

    --Define clock based on the clock period and disable ouput for 10 clock periods.
    clk <= NOT clk after CLK_PERIOD / 2;
    oc  <= '0' after 10 * CLK_PERIOD;

    sn74ls374_0: entity work.sn74ls374
    port map
    (
        clk => clk,
        oc  => oc,
        d   => d,
        q   => q
    );

    process
    begin
        wait for 15 ns;
        d <= "10101010";

        wait for 15 ns;
        std.env.stop;    --End the simulation.
    end process;
end behavioral;