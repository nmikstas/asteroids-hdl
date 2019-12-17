--Test bench for the 2114 RAM file.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ram_2114 is
end tb_ram_2114;

architecture behavioral of tb_ram_2114 is

    signal we_n : std_logic := '1';
    signal ce_n : std_logic := '1';
    signal a    : std_logic_vector(9 downto 0) := "0000000000";
    signal dq   : std_logic_vector(3 downto 0) := "ZZZZ";

begin

    ram_21141 : entity work.ram_2114
    port map
    ( 
        we_n => we_n,
        ce_n => ce_n,
        a    => a,
        dq   => dq
    );

    process
    begin
        wait for 10 ns;
        ce_n <= '0';

        wait for 10 ns;
        a <= "1000000001";
        dq <= "0001";
        we_n <= '0';

        wait for 10 ns;
        a <= "1000000010";
        dq <= "0010";

        wait for 10 ns;
        a <= "1000000011";
        dq <= "0011";

        wait for 10 ns;
        a <= "1000000100";
        dq <= "0100";

        wait for 10 ns;
        we_n <= '1';
        dq <= "ZZZZ";
        a <= "1000000001";

        wait for 10 ns;
        a <= "1000000010";

        wait for 10 ns;
        a <= "1000000011";

        wait for 10 ns;
        a <= "1000000100";

        wait for 100 ns;
        std.env.stop; --End the simulation.
    end process;

end behavioral;