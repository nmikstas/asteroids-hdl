--Test bench for the X and Y position counters for Atari's Asteroids vector generator.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_vec_xy_counters is
end tb_vec_xy_counters;

architecture behavioral of tb_vec_xy_counters is

    constant VGCK_PERIOD     : time := 666.667 ns; --1.5MHz MCU clock.
    constant CLK6MHZ_PERIOD  : time := 166.667 ns; --6MHz system clock.

    signal vgck         : std_logic := '0';
    signal clk6mhz      : std_logic := '0';
    signal haltstrobe_n : std_logic := '1';
    signal timer0       : std_logic := '0';
    signal go_n         : std_logic := '1';
    signal go_s_n       : std_logic := '1';
    signal dvx          : std_logic_vector(11 downto 0) := x"000";
    signal dvy          : std_logic_vector(11 downto 0) := x"000";
    signal bvld         : std_logic;
    signal dacx_s       : std_logic_vector(9 downto 0);
    signal dacy_s       : std_logic_vector(9 downto 0);

begin

    --Set up clocks.
    vgck    <= NOT vgck    after VGCK_PERIOD    / 2;
    clk6mhz <= NOT clk6mhz after CLK6MHZ_PERIOD / 2;

    vec_xy_counters : entity work.vec_xy_counters
    port map
    (
        vgck         => vgck,
        clk6mhz      => clk6mhz,
        haltstrobe_n => haltstrobe_n,
        timer0       => timer0,
        go_n         => go_n,
        go_s_n       => go_s_n,
        dvx          => dvx,
        dvy          => dvy,    
        bvld         => bvld,
        dacx_s       => dacx_s,
        dacy_s       => dacy_s
    );

    process
    begin
        wait for 1000 ns;
        
        ----------Bottom left corner, Y hits first----------

        --Set go_n and go_s_n to 1 to stop the counters.
        go_n <= '1';
        go_s_n <= '1';

        wait for 1000 ns;

        --Set DVX and DVY.
        dvx <= "000000011111";
        dvy <= "000000011111";

        wait for 1000 ns;

        --Strobe haltstrobe_n to load the counters and rate multipliers.
        haltstrobe_n <= '0';

        wait for 1000 ns;
        haltstrobe_n <= '1';

        wait for 100 ns;
        dvx <= "010000000001";
        dvy <= "010000001111";

        wait for 1000 ns;

        --Set go_n and go_s_n to 0 to start the counters.
        go_n <= '0';
        go_s_n <= '0';

        wait for 30000 ns;

        ----------Bottom left corner, X hits first----------

        --Set go_n and go_s_n to 1 to stop the counters.
        go_n <= '1';
        go_s_n <= '1';

        wait for 1000 ns;

        --Set DVX and DVY.
        dvx <= "000000011111";
        dvy <= "000000011111";

        wait for 1000 ns;

        --Strobe haltstrobe_n to load the counters and rate multipliers.
        haltstrobe_n <= '0';

        wait for 1000 ns;
        haltstrobe_n <= '1';

        wait for 100 ns;
        dvx <= "010000001111";
        dvy <= "010000000001";

        wait for 1000 ns;

        --Set go_n and go_s_n to 0 to start the counters.
        go_n <= '0';
        go_s_n <= '0';

        wait for 30000 ns;

       ----------Top left corner, Y hits first----------

        --Set go_n and go_s_n to 1 to stop the counters.
        go_n <= '1';
        go_s_n <= '1';

        wait for 1000 ns;

        --Set DVX and DVY.
        dvx <= "000000011111";
        dvy <= "001111100000";

        wait for 1000 ns;

        --Strobe haltstrobe_n to load the counters and rate multipliers.
        haltstrobe_n <= '0';

        wait for 1000 ns;
        haltstrobe_n <= '1';

        wait for 100 ns;
        dvx <= "010000000001";
        dvy <= "000000001111";

        wait for 1000 ns;

        --Set go_n and go_s_n to 0 to start the counters.
        go_n <= '0';
        go_s_n <= '0';

        wait for 30000 ns;

        ----------Top left corner, X hits first----------

        --Set go_n and go_s_n to 1 to stop the counters.
        go_n <= '1';
        go_s_n <= '1';

        wait for 1000 ns;

        --Set DVX and DVY.
        dvx <= "000000011111";
        dvy <= "001111100000";

        wait for 1000 ns;

        --Strobe haltstrobe_n to load the counters and rate multipliers.
        haltstrobe_n <= '0';

        wait for 1000 ns;
        haltstrobe_n <= '1';

        wait for 100 ns;
        dvx <= "010000001111";
        dvy <= "000000000001";

        wait for 1000 ns;

        --Set go_n and go_s_n to 0 to start the counters.
        go_n <= '0';
        go_s_n <= '0';

        wait for 30000 ns;

        ----------Top right corner, Y hits first----------

        --Set go_n and go_s_n to 1 to stop the counters.
        go_n <= '1';
        go_s_n <= '1';

        wait for 1000 ns;

        --Set DVX and DVY.
        dvx <= "001111100000";
        dvy <= "001111100000";

        wait for 1000 ns;

        --Strobe haltstrobe_n to load the counters and rate multipliers.
        haltstrobe_n <= '0';

        wait for 1000 ns;
        haltstrobe_n <= '1';

        wait for 100 ns;
        dvx <= "000000000001";
        dvy <= "000000001111";

        wait for 1000 ns;

        --Set go_n and go_s_n to 0 to start the counters.
        go_n <= '0';
        go_s_n <= '0';

        wait for 30000 ns;

        ----------Top right corner, X hits first----------

        --Set go_n and go_s_n to 1 to stop the counters.
        go_n <= '1';
        go_s_n <= '1';

        wait for 1000 ns;

        --Set DVX and DVY.
        dvx <= "001111100000";
        dvy <= "001111100000";

        wait for 1000 ns;

        --Strobe haltstrobe_n to load the counters and rate multipliers.
        haltstrobe_n <= '0';

        wait for 1000 ns;
        haltstrobe_n <= '1';

        wait for 100 ns;
        dvx <= "000000001111";
        dvy <= "000000000001";

        wait for 1000 ns;

        --Set go_n and go_s_n to 0 to start the counters.
        go_n <= '0';
        go_s_n <= '0';

        wait for 30000 ns;

        ----------Bottom right corner, Y hits first----------

        --Set go_n and go_s_n to 1 to stop the counters.
        go_n <= '1';
        go_s_n <= '1';

        wait for 1000 ns;

        --Set DVX and DVY.
        dvx <= "001111100000";
        dvy <= "000000011111";

        wait for 1000 ns;

        --Strobe haltstrobe_n to load the counters and rate multipliers.
        haltstrobe_n <= '0';

        wait for 1000 ns;
        haltstrobe_n <= '1';

        wait for 100 ns;
        dvx <= "000000000001";
        dvy <= "010000001111";

        wait for 1000 ns;

        --Set go_n and go_s_n to 0 to start the counters.
        go_n <= '0';
        go_s_n <= '0';

        wait for 30000 ns;

        ----------Bottom right corner, X hits first----------

        --Set go_n and go_s_n to 1 to stop the counters.
        go_n <= '1';
        go_s_n <= '1';

        wait for 1000 ns;

        --Set DVX and DVY.
        dvx <= "001111100000";
        dvy <= "000000011111";

        wait for 1000 ns;

        --Strobe haltstrobe_n to load the counters and rate multipliers.
        haltstrobe_n <= '0';

        wait for 1000 ns;
        haltstrobe_n <= '1';

        wait for 100 ns;
        dvx <= "000000001111";
        dvy <= "010000000001";

        wait for 1000 ns;

        --Set go_n and go_s_n to 0 to start the counters.
        go_n <= '0';
        go_s_n <= '0';

        wait for 30000 ns;
        std.env.stop; --End the simulation.
    end process;
 
end behavioral;