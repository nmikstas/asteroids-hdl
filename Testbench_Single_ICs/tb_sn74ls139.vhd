--Test bench for the SN74LS139 dual decoder.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn74ls139 is
end tb_sn74ls139;

architecture behavioral of tb_sn74ls139 is

    signal g1_n : std_Logic;
    signal i1   : std_logic_vector(1 downto 0);
    signal o1   : std_logic_vector(3 downto 0);

    signal g2_n : std_Logic;
    signal i2   : std_logic_vector(1 downto 0);
    signal o2   : std_logic_vector(3 downto 0);
    
begin
    
    sn74ls139_0: entity work.sn74ls139
    port map
    (
        g1_n => g1_n,
        i1   => i1,
        o1   => o1,

        g2_n => g2_n,
        i2   => i2,
        o2   => o2
    );

    process
    begin
        wait for 15 ns;
        i1 <= "00";
        g1_n <= '1';

        wait for 15 ns;
        g1_n <= '0';

        wait for 15 ns;
        i1 <= "01";

        wait for 15 ns;
        i1 <= "10";

        wait for 15 ns;
        i1 <= "11";

        wait for 15 ns;
        std.env.stop;    --End the simulation.
    end process;
end behavioral;