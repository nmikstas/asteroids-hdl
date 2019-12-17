--Test bench for the SN74LS273 octal flip-flop.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn74ls273 is
end tb_sn74ls273;

architecture behavioral of tb_sn74ls273 is

    constant CLK_PERIOD : time := 1 ns;

    signal clk   : std_logic := '0';
    signal clr_n : std_logic := '1';
    signal d     : std_logic_vector(7 downto 0) := "00000000";
    signal q     : std_logic_vector(7 downto 0);

begin

    clk <= NOT clk after CLK_PERIOD / 2;
    
    sn74ls273_1: entity work.sn74ls273
    port map
    (
        clk    => clk,
        clr_n  => clr_n,
        d      => d,
        q      => q
    );

    process
    begin
        wait for 10 ns;
        clr_n <= '0';

        wait for 10 ns;
        clr_n <= '1';

        wait for 10 ns;
        d <= "10101010";

        wait for 10 ns;
        d <= "00001111";

        wait for 10 ns;
        d <= "11110000";

        wait for 10 ns;
        clr_n <= '0';
        d <= "01010101";

        wait for 100 ns;
        std.env.stop;    --End the simulation.
    end process;

end behavioral;

