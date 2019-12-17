--Test bench for the SN74LS670 octal flip-flop.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn74ls670 is
end tb_sn74ls670;

architecture behavioral of tb_sn74ls670 is

    signal gw_n : std_logic := '1';
    signal gr_n : std_logic := '1';
    signal w    : std_logic_vector(1 downto 0) := "00";
    signal r    : std_logic_vector(1 downto 0) := "00";
    signal d    : std_logic_vector(3 downto 0) := "0000";
    signal q    : std_logic_vector(3 downto 0);

begin

    sn74ls670_1 : entity work.sn74ls670
    port map
    ( 
        gw_n => gw_n,
        gr_n => gr_n,
        w    => w,
        r    => r,
        d    => d,
        q    => q
    );     

    process
    begin
        wait for 15 ns;
        w <= "11";
        d <= "0110";

        wait for 15 ns;
        gw_n <= '0';

        wait for 15 ns;
        w <= "00";
        d <= "1010";

        wait for 15 ns;
        w <= "01";
        d <= "1111";

        wait for 15 ns;
        w <= "10";
        d <= "1001";

        wait for 15 ns;
        gw_n <= '1';

        wait for 15 ns;
        gr_n <= '0';
        r    <= "00";

        wait for 15 ns;
        r    <= "01";

        wait for 15 ns;
        r    <= "10";

        wait for 15 ns;
        r    <= "11";

        wait for 15 ns;
        gr_n <= '1';

        wait for 15 ns;
        std.env.stop;
    end process;

end behavioral;