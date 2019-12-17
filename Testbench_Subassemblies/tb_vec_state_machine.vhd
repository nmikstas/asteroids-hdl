--Test bench for the state machine for Atari's Asteroids vector generator.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_vec_state_machine is
end tb_vec_state_machine;

architecture behavioral of tb_vec_state_machine is

    constant VGCK_PERIOD     : time := 666.667 ns; --1.5MHz MCU clock.
    constant CLK6MHZ_PERIOD  : time := 166.667 ns; --6MHz system clock.

    signal vgck         : std_logic := '0';
    signal clk6mhz      : std_logic := '0';
    signal reset_n      : std_logic := '0';
    signal vmem_n       : std_logic := '1';
    signal dmago_n      : std_logic := '1';
    signal dmacnt_n     : std_logic := '1';
    signal stop_n       : std_logic := '1';
    signal timer        : std_logic_vector(3 downto 0) := "0000";

    signal go           : std_logic;
    signal go_n         : std_logic;
    signal go_s_n       : std_logic;
    signal halt         : std_logic;
    signal blank_n      : std_logic;
    signal vgck_s_n     : std_logic;
    signal adma0        : std_logic;
    signal haltstrobe_n : std_logic;
    signal gostrobe_n   : std_logic;
    signal dmald_n      : std_logic;
    signal dmapush_n    : std_logic;
    signal latch_n      : std_logic_vector(3 downto 0);
    

begin

    --Set up clocks.
    vgck    <= NOT vgck    after VGCK_PERIOD    / 2;
    clk6mhz <= NOT clk6mhz after CLK6MHZ_PERIOD / 2;

    vec_state_machine_0 : entity work.vec_state_machine
    port map
    ( 
        vgck         => vgck,
        clk6mhz      => clk6mhz,
        reset_n      => reset_n,
        vmem_n       => vmem_n,
        dmago_n      => dmago_n,
        dmacnt_n     => dmacnt_n,
        stop_n       => stop_n,
        timer        => timer,
        go           => go,
        go_n         => go_n,
        go_s_n       => go_s_n,
        halt         => halt,
        blank_n      => blank_n,
        vgck_s_n     => vgck_s_n,
        adma0        => adma0,
        haltstrobe_n => haltstrobe_n,
        gostrobe_n   => gostrobe_n,
        dmald_n      => dmald_n,
        dmapush_n    => dmapush_n,
        latch_n      => latch_n
    );

    process
    begin
        wait for 1000 ns;
        reset_n <= '1';

        wait for 2000 ns;
        vmem_n <= '1';

        --Instruct the state machine to start.
        wait for 2500 ns;
        wait until vgck = '1';
        dmago_n <= '0';
        wait until vgck = '1';
        dmago_n <= '1';

        wait for 5500 ns;
        timer  <= "1011";

        wait for 10500 ns;
        stop_n <= '0';    
        wait until vgck = '0';
        wait until vgck = '1';
        stop_n <= '1';
        

        wait for 100000 ns;
        std.env.stop; --End the simulation.
    end process;

end behavioral;

