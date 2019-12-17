--Test bench for the vector timer for Atari's Asteroids vector generator.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_vec_timer is
end tb_vec_timer;

architecture behavioral of tb_vec_timer is

    constant VGCK_PERIOD : time := 666.667 ns; --1.5MHz MCU clock.
    
    signal vgck       : std_logic := '0';
    signal go         : std_logic := '0';
    signal latch2_n   : std_logic := '1';
    signal dvx11      : std_logic := '0';
    signal dvy11      : std_logic := '0';
    signal timer      : std_logic_vector(3 downto 0) := "0000";
    signal scale      : std_logic_vector(3 downto 0) := "0000";
    signal alphanum_n : std_logic;
    signal stop_n     : std_logic;

begin

    --Set up clocks.
    vgck <= NOT vgck after VGCK_PERIOD / 2;

    vec_timer_0 : entity work.vec_timer
    port map
    ( 
        vgck       => vgck,
        go         => go,
        latch2_n   => latch2_n,
        dvx11      => dvx11,
        dvy11      => dvy11,
        timer      => timer,
        scale      => scale,
        alphanum_n => alphanum_n,
        stop_n     => stop_n
    );     

    process
    begin
        wait for 1000 ns;
        dvx11 <= '0';
        dvy11 <= '1';

        --Lock in a global scaling value.
        scale <= "0101"; --Global multiplier value of 32.

        wait for 1000 ns;
        timer <= "1010";
        latch2_n <= '0';

        wait for 1000 ns;
        timer <= "0000";
        latch2_n <= '1';

        --Load a local scaling value.
        wait for 1000 ns;
        timer <= "1111"; --VEC scaling multiplier of 1/64.

        --Start the timer.
        wait for 1000 ns;
        go <= '1';

        --Wait until counter expires.
        wait until stop_n <= '0';
        wait for 1000 ns;
        wait until stop_n <= '0';

        wait for 30000 ns;
        std.env.stop; --End the simulation.
    end process;
 
end behavioral;