--Test bench for the SN74LS174 hex flip-flop.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn74ls174 is
end tb_sn74ls174;

architecture Behavioral of tb_sn74ls174 is

    constant CLK_PERIOD : time := 1 ns;

    signal clk : std_logic := '0';
    signal clr : std_logic := '0';
    signal d   : std_logic_vector(5 downto 0) := "111111";
    signal q   : std_logic_vector(5 downto 0);

begin

    --Define clock based on the clock period and set clear for 10 clock periods.
    clk <= NOT clk after CLK_PERIOD / 2;
    clr  <= '1' after 10 * CLK_PERIOD;

    sn74ls174_0: entity work.sn74ls174
    port map
    (
        clk => clk,
        clr => clr,
        d   => d,
        q   => q
    );

    process
    begin
        wait for 15 ns;
        d <= "101010";

        wait for 15 ns;
        std.env.stop;    --End the simulation.
    end process;
end Behavioral;