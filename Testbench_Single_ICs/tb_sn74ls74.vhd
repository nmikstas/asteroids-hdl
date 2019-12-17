--Test bench for the SN74LS74 dual D-type flip flops.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn74ls74 is
end tb_sn74ls74;

architecture behavioral of tb_sn74ls74 is

    signal clk1   : std_logic;
    signal pre1_n : std_logic;
    signal clr1_n : std_logic;
    signal d1     : std_logic;
    signal clk2   : std_logic;
    signal pre2_n : std_logic;
    signal clr2_n : std_logic;
    signal d2     : std_logic;
    signal q1     : std_logic;
    signal q1_n   : std_logic;
    signal q2     : std_logic;
    signal q2_n   : std_logic;

begin

    sn74ls74_0: entity work.sn74ls74
    port map
    (
        clk1   => clk1,
        pre1_n => pre1_n,
        clr1_n => clr1_n,
        d1     => d1,
        clk2   => clk2,
        pre2_n => pre2_n,
        clr2_n => clr2_n,
        d2     => d2,
        q1     => q1,
        q1_n   => q1_n,
        q2     => q2,
        q2_n   => q2_n
    );

    process
    begin

        wait for 10 ns;
        clk1   <= '0';
        pre1_n <= '1';
        clr1_n <= '1';
        d1     <= '1';

        clk2   <= '0';
        pre2_n <= '1';
        clr2_n <= '1';
        d2     <= '1';
        
        wait for 10 ns;
        clk1 <= '1';

        wait for 10 ns;
        clk1 <= '0';
        clr1_n <= '0';

        wait for 10 ns;
        pre1_n <= '0';

        wait for 10 ns;
        clr1_n <= '1';

        wait for 10 ns;
        pre1_n <= '1';
        d1     <= '0';

        wait for 10 ns;
        clk1 <= '1';

        wait for 15 ns;
        std.env.stop;    --End the simulation.
    end process;
end behavioral;