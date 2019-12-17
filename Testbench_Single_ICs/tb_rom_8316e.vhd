--Test bench for the 8316e ROM.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rom_8316e is
end tb_rom_8316e;

architecture behavioral of tb_rom_8316e is

    signal cs1_n : std_logic := '1';
    signal cs2_n : std_logic := '1';
    signal cs3   : std_logic := '1';
    signal a     : std_logic_vector(10 downto 0) := "00000000000";
    signal d     : std_logic_vector(7 downto 0)  := "ZZZZZZZZ";

begin

    rom_8316e_1 : entity work.rom_8316e
    generic map
    (
        --Asteroids Vector ROM.
        filename => "./ROM_Data_Files/Asteroids_ROM.hex"
    )
    port map
    ( 
        cs1_n => cs1_n,
        cs2_n => cs2_n,
        cs3   => '1',
        a     => a,
        d     => d
    );

    process
    begin
        wait for 10 ns;
        cs1_n <= '0';

        wait for 10 ns;
        cs2_n <= '0';

        for i in 0 to 2047 loop
            a <= std_logic_vector(to_unsigned(i, a'length));
            wait for 1 ns;
        end loop;

        cs1_n <= '1';
        cs2_n <= '1';
        wait for 10 ns;

        std.env.stop; --End the simulation.
    end process;
end behavioral;
