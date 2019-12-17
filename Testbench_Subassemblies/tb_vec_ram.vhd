--Test bench for the Asteroids vector generator RAM.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_vec_ram is
end tb_vec_ram;

architecture behavioral of tb_vec_ram is

    signal vw_n   : std_logic := '1';
    signal vram_n : std_logic := '1';
    signal am     : std_logic_vector(10 downto 0) := "00000000000";
    signal ddma   : std_logic_vector(7 downto 0)  := "ZZZZZZZZ";

begin

    vec_ram_0 : entity work.vec_ram
    port map
    ( 
        vw_n   => vw_n,
        vram_n => vram_n,
        am     => am,
        ddma   => ddma
    );

    process
    begin
        wait for 10 ns;
        vram_n <= '0';

        wait for 10 ns;
        vw_n <= '0';
        am <= "01111111110";
        ddma <= "01111110";

        wait for 10 ns;
        am <= "01111111111";
        ddma <= "01111111";

        wait for 10 ns;
        am <= "10000000000";
        ddma <= "10000000";

        wait for 10 ns;
        am <= "10000000001";
        ddma <= "10000001";

        wait for 10 ns;
        vw_n <= '1';
        am <= "01111111110";
        ddma <= "ZZZZZZZZ";

        wait for 10 ns;
        am <= "01111111111";

        wait for 10 ns;
        am <= "10000000000";

        wait for 10 ns;
        am <= "10000000001";

        wait for 10 ns;
        vram_n <= '1';

        wait for 100 ns;
        std.env.stop; --End the simulation.
    end process;
end behavioral;
