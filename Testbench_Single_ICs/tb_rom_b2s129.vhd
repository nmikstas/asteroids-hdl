--Test bench for the b2s129 ROM.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rom_b2s129 is
end tb_rom_b2s129;

architecture behavioral of tb_rom_b2s129 is

    signal cs1_n : std_logic := '1';
    signal cs2_n : std_logic := '1';
    signal a     : std_logic_vector(7 downto 0) := "00000000";
    signal d     : std_logic_vector(3 downto 0) := "ZZZZ";

begin

    rom_b2s129_1 : entity work.rom_b2s129
    generic map
    (
        --Asteroids Vector ROM.
        filename => "./ROM_Data_Files/Vec_State_Machine_ROM.hex"
    )
    port map
    ( 
        cs1_n => cs1_n,
        cs2_n => cs2_n,
        a     => a,
        d     => d
    );

    process
    begin
        wait for 10 ns;
        cs1_n <= '0';

        wait for 10 ns;
        cs2_n <= '0';

        for i in 0 to 255 loop
            a <= std_logic_vector(to_unsigned(i, a'length));
            wait for 1 ns;
        end loop;

        cs1_n <= '1';
        cs2_n <= '1';
        wait for 10 ns;

        std.env.stop; --End the simulation.
    end process;
end behavioral;