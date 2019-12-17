--Test bench for the memory data latches for Atari's Asteroids vector generator.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_vec_mem_latches is
end tb_vec_mem_latches;

architecture behavioral of tb_vec_mem_latches is

    signal reset_n    : std_logic                    := '0';
    signal dmago_n    : std_logic                    := '1';
    signal alphanum_n : std_logic                    := '0';
    signal ddma       : std_logic_vector(7 downto 0) := (others => '0');
    signal latch_n    : std_logic_vector(3 downto 0) := (others => '0');
    signal dvx        : std_logic_vector(11 downto 0);
    signal dvy        : std_logic_vector(11 downto 0);
    signal timer      : std_logic_vector(3 downto 0);
    signal scale      : std_logic_vector(3 downto 0);

begin

    vec_mem_latches_0 : entity work.vec_mem_latches
    port map
    ( 
        reset_n    => reset_n,
        dmago_n    => dmago_n,
        alphanum_n => alphanum_n,
        ddma       => ddma,
        latch_n    => latch_n,
        dvx        => dvx,
        dvy        => dvy,
        timer      => timer,
        scale      => scale
    );

    process
    begin

        --Get all the flip-flops into a known state.
        wait for 10 ns;
        latch_n <= "1111";

        wait for 10 ns;
        reset_n    <= '1';
        alphanum_n <= '1';
        
        --Load a 4-byte value into the latches.
        wait for 10 ns;
        ddma <= "01010101";

        wait for 10 ns;
        latch_n(1) <= '0';
        wait for 10 ns;
        latch_n(1) <= '1';
        
        wait for 10 ns;
        latch_n(0) <= '0';
        wait for 10 ns;
        latch_n(0) <= '1';
        
        wait for 10 ns;
        latch_n(3) <= '0';
        wait for 10 ns;
        latch_n(3) <= '1';

        wait for 10 ns;
        latch_n(2) <= '0';
        wait for 10 ns;
        latch_n(2) <= '1';

        --Load a 2-byte value into the latches.
        wait for 10 ns;
        ddma <= "10011001";
        alphanum_n <= '0';
        wait for 100 ns;

        wait for 10 ns;
        latch_n(1) <= '0';
        wait for 10 ns;
        latch_n(1) <= '1';
        
        wait for 10 ns;
        latch_n(0) <= '0';
        wait for 10 ns;
        latch_n(0) <= '1';

        --DMAGO
        wait for 100 ns;
        dmago_n <= '0';

        wait for 1000 ns;
        std.env.stop; --End the simulation.
    end process;

end behavioral;

