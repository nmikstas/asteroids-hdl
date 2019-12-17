--Test bench for the SN74LS367 hex bus driver.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn74ls367 is
end tb_sn74ls367;

architecture behavioral of tb_sn74ls367 is

    signal g1_n : std_logic := '1';
    signal g2_n : std_logic := '1';
    signal a1   : std_logic_vector(3 downto 0) := "0000";
    signal a2   : std_logic_vector(1 downto 0) := "00";
    signal y1   : std_logic_vector(3 downto 0);
    signal y2   : std_logic_vector(1 downto 0);

begin

    sn74ls367_0 : entity work.sn74ls367
    port map
    (
        g1_n => g1_n,
        g2_n => g2_n,
        a1   => a1,
        a2   => a2,
        y1   => y1,
        y2   => y2
    );

    process
    begin
        wait for 15 ns;
        a1 <= "1100";

        wait for 15 ns;
        g1_n <= '0';

        wait for 15 ns;
        a2 <= "10";

        wait for 15 ns;
        g2_n <= '0';

        wait for 15 ns;
        g1_n <= '1';
       
        wait for 15 ns;
        g2_n <= '1';

        wait for 15 ns;
        std.env.stop;
    end process;
end behavioral;