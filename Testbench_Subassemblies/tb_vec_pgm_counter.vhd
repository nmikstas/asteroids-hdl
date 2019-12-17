--Test bench for the program counter for Atari's Asteroids vector generator.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_vec_pgm_counter is
end tb_vec_pgm_counter;

architecture behavioral of tb_vec_pgm_counter is

    constant CLK3MHZ_PERIOD : time := 333.333 ns;

    signal clk3mhz   : std_logic := '1';
    signal dmald_n   : std_logic := '1';
    signal dmapush_n : std_logic := '1';
    signal timer0    : std_logic := '1';
    signal latch0_n  : std_logic := '1';
    signal latch2_n  : std_logic := '1';
    signal dvy       : std_logic_vector(11 downto 0) := x"000";
    signal adma      : std_logic_vector(12 downto 1);
   
begin

    clk3mhz <= NOT clk3mhz after CLK3MHZ_PERIOD / 2;

    vec_pgm_counter_0 : entity work.vec_pgm_counter
    port map
    ( 
        clk3mhz   => clk3mhz,
        dmald_n   => dmald_n,
        dmapush_n => dmapush_n,
        timer0    => timer0,
        latch0_n  => latch0_n,
        latch2_n  => latch2_n,
        dvy       => dvy,
        adma      => adma
    );


    process
    begin
        wait for 1000 ns;
        timer0 <= '0';

        --Push 1st value into stack.
        wait for 1000 ns;
        dvy <= "110011001100";
        
        wait for 1000 ns;
        dmald_n <= '0';

        wait for 1000 ns;
        dmald_n <= '1';

        wait for 1000 ns;
        dmapush_n <= '0';

        wait for 1000 ns;
        dmapush_n <= '1';

        --Push 2nd value into stack.
        wait for 1000 ns;
        dvy <= "111111111111";
        
        wait for 1000 ns;
        dmald_n <= '0';

        wait for 1000 ns;
        dmald_n <= '1';

        wait for 1000 ns;
        dmapush_n <= '0';

        wait for 1000 ns;
        dmapush_n <= '1';

        --Push 3rd value into stack.
        wait for 1000 ns;
        dvy <= "010101010101";
        
        wait for 1000 ns;
        dmald_n <= '0';

        wait for 1000 ns;
        dmald_n <= '1';

        wait for 1000 ns;
        dmapush_n <= '0';

        wait for 1000 ns;
        dmapush_n <= '1';

        --Push 4th value into stack.
        wait for 1000 ns;
        dvy <= "111100001111";
        
        wait for 1000 ns;
        dmald_n <= '0';

        wait for 1000 ns;
        dmald_n <= '1';

        wait for 1000 ns;
        dmapush_n <= '0';

        wait for 1000 ns;
        dmapush_n <= '1';

        --Switch to stack data.
        wait for 1000 ns;
        timer0 <= '1';

        --Pop the stack into the program counter.
        wait for 1000 ns;
        dmald_n <= '0';

        wait for 1000 ns;
        dmald_n <= '1';

        --Increment the program counter.
        for i in 0 to 100 loop
            wait until rising_edge(clk3mhz);
            latch2_n <= not latch2_n;
        end loop;

        wait for 30000 ns;
        std.env.stop; --End the simulation.
    end process;

end behavioral;

