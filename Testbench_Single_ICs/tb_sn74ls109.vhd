--Test bench for the SN74LS109 dual JK-type flip flops.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn74ls109 is
end tb_sn74ls109;

architecture behavioral of tb_sn74ls109 is

    signal clk1   : std_logic;
    signal pre1_n : std_logic;
    signal clr1_n : std_logic;
    signal j1     : std_logic;
    signal k1     : std_logic;
    signal q1     : std_logic;
    signal q1_n   : std_logic;

    signal clk2   : std_logic;
    signal pre2_n : std_logic;
    signal clr2_n : std_logic;
    signal j2     : std_logic;
    signal k2     : std_logic;
    signal q2     : std_logic;
    signal q2_n   : std_logic;

begin

    sn74ls109_0: entity work.sn74ls109
    port map
    (
        clk1   => clk1,
        pre1_n => pre1_n,
        clr1_n => clr1_n,
        j1     => j1,
        k1     => k1,
        q1     => q1,
        q1_n   => q1_n,

        clk2   => clk2,
        pre2_n => pre2_n,
        clr2_n => clr2_n,
        j2     => j2,
        k2     => k2,
        q2     => q2,
        q2_n   => q2_n
    );

    process
    begin

        wait for 10 ns;
        clk1 <= '0';
        pre1_n <= '1';
        clr1_n <= '1';
        j1 <= '1';
        k1 <= '1';

        wait for 10 ns;
        pre1_n <= '0';

        wait for 10 ns;
        clr1_n <= '0';

        wait for 10 ns;
        pre1_n <= '1';

        wait for 10 ns;
        clr1_n <= '1';

        wait for 10 ns;
        clk1 <= '1';

        wait for 10 ns;
        clk1 <= '0';
        j1 <= '0';
        k1 <= '1';
        
        wait for 10 ns;
        clk1 <= '1';

        wait for 10 ns;
        clk1 <= '0';
        j1 <= '0';
        k1 <= '0';

        wait for 10 ns;
        clk1 <= '1';

        wait for 10 ns;
        clk1 <= '0';
        j1 <= '1';
        k1 <= '0';

        wait for 10 ns;
        clk1 <= '1';

        wait for 10 ns;
        clk1 <= '0';

        wait for 10 ns;
        clk1 <= '1';

        wait for 10 ns;
        clk1 <= '0';

        wait for 10 ns;
        clk1 <= '1';

        wait for 10 ns;
        clk1 <= '0';

        wait for 15 ns;
        std.env.stop;    --End the simulation.
    end process;
end behavioral;