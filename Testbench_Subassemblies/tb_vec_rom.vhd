--Test bench for the Asteroids vector generator ROM.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_vec_rom is
end tb_vec_rom;

architecture behavioral of tb_vec_rom is

    signal vrom2_n : std_logic                     := '1';
    signal am      : std_logic_vector(10 downto 0) := "00000000000";
    signal ddma    : std_logic_vector(7 downto 0)  := "ZZZZZZZZ";

begin

    vec_rom_1 : entity work.vec_rom
    port map
    ( 
        vrom2_n => vrom2_n,
        am      => am,
        ddma    => ddma
    );

    process
    begin
        wait for 10 ns;
        vrom2_n <= '0';

        for i in 0 to 2047 loop
            am <= std_logic_vector(to_unsigned(i, am'length));
            wait for 1 ns;
        end loop;

        vrom2_n <= '1';
        wait for 10 ns;

        std.env.stop; --End the simulation.
    end process;
end behavioral;