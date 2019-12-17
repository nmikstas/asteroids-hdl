--Asteroids vector generator top level module.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                  --Vector Generator Entity--                                   --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vec_gen_top is
    port 
    ( 
       vgck     : in std_logic; --1.5 MHz system clock.
       phi2     : in std_logic; --1.5 MHz clock output from processor.
       clk6mhz  : in std_logic; --6 MHz clock.
       clk3mhz  : in std_logic; --3 MHz clock.
       reset_n  : in std_logic; --System reset signal.
       dmago_n  : in std_logic; --starts vector state machine.
       dmacnt_n : in std_logic; --Not used. should always be 1.
       vmem_n   : in std_logic; --0=adr bus driven by state machine, 1=driven by processor.
       r_wb     : in std_logic; --Processor read/write control signal.
       ab       : in std_logic_vector(12 downto 0); --Processor address bus.

       db       : inout std_logic_vector(7 downto 0); --Processor data bus.

       halt     : out std_logic; --Current state signal.
       bvld     : out std_logic; --Beam valid signal.
       blank_n  : out std_logic; --Beam blank signal.
       vgck_s_n : out std_logic; --Video output clock.
       dacx_s   : out std_logic_vector(10 downto 1); --DAC X output.
       dacy_s   : out std_logic_vector(10 downto 1)  --DAC Y output.
    );     
end vec_gen_top;

----------------------------------------------------------------------------------------------------
--                               --Vector Generator Architecture--                                --
----------------------------------------------------------------------------------------------------

architecture structural of vec_gen_top is

    --Internal representations of the output signal.
    signal halt_int     : std_logic := '0';
    signal bvld_int     : std_logic := '0';
    signal blank_n_int  : std_logic := '0';
    signal vgck_s_n_int : std_logic := '0';
    signal dacx_s_int   : std_logic_vector(10 downto 1) := "0000000000";
    signal dacy_s_int   : std_logic_vector(10 downto 1) := "0000000000";

    --Internal connections.
    signal dmald_n      : std_logic := '0';
    signal dmapush_n    : std_logic := '0';
    signal latch0_n     : std_logic := '0';
    signal latch2_n     : std_logic := '0';
    signal timer0       : std_logic := '0';
    signal go           : std_logic := '0';
    signal go_n         : std_logic := '0';
    signal go_s_n       : std_logic := '0';
    signal alphanum_n   : std_logic := '0';
    signal stop_n       : std_logic := '0';
    signal haltstrobe_n : std_logic := '0';
    signal gostrobe_n   : std_logic := '0';
    signal buffen_n     : std_logic := '0';
    signal vw_n         : std_logic := '0';
    signal vrom2_n      : std_logic := '0';
    signal vram_n       : std_logic := '0';

    signal latch_n : std_logic_vector(3 downto 0)  := "1111";
    signal timer   : std_logic_vector(3 downto 0)  := "0000";
    signal scale   : std_logic_vector(3 downto 0)  := "0000";
    signal ddma    : std_logic_vector(7 downto 0)  := "00000000";
    signal dvx     : std_logic_vector(11 downto 0) := "000000000000";
    signal dvy     : std_logic_vector(11 downto 0) := "000000000000";
    signal adma    : std_logic_vector(12 downto 0) := "0000000000000";
    signal am      : std_logic_vector(12 downto 0) := "0000000000000";

begin

    --Always assign outputs.
    halt     <= halt_int;
    bvld     <= bvld_int;
    blank_n  <= blank_n_int;
    vgck_s_n <= vgck_s_n_int;
    dacx_s   <= dacx_s_int;
    dacy_s   <= dacy_s_int;

    --Separate latch bus into individual signals.
    latch0_n <= latch_n(0);
    latch2_n <= latch_n(2);

    --Separate timer bus into individual signals.
    timer0 <= timer(0);

    --Vector Generator Program Counter.
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
        adma      => adma(12 downto 1)
    );  

    --Vector Timer.
    vec_timer_0 : entity work.vec_timer
    port map
    ( 
        vgck       => vgck,
        go         => go,
        latch2_n   => latch2_n,
        dvx11      => dvx(11),
        dvy11      => dvy(11),
        timer      => timer,
        scale      => scale,
        alphanum_n => alphanum_n,
        stop_n     => stop_n
    );     

    --Vector Generator Memory Address Selector.
    vec_mem_select_0 : entity work.vec_mem_select
    port map
    ( 
        adma     => adma,
        ab       => ab,
        phi2     => phi2,
        r_wb     => r_wb,
        vmem_n   => vmem_n,
        am       => am,
        buffen_n => buffen_n,
        vw_n     => vw_n,
        vrom2_n  => vrom2_n,
        vram_n   => vram_n
    );  

    --Vector Generator Data Buffer.
    vec_data_buffer_0 : entity work.vec_data_buffer
    port map
    ( 
        buffen_n => buffen_n,
        r_wb     => r_wb,
        db       => db,
        ddma     => ddma
    );     

    --X And Y Position Counters.
    vec_xy_counters_0 : entity work.vec_xy_counters
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
        bvld         => bvld_int,
        dacx_s       => dacx_s_int,
        dacy_s       => dacy_s_int
    );

    --Vector Generator Memory Data Latches.
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

    --Vector Generator RAM.
    vec_ram_0 : entity work.vec_ram
    port map
    ( 
        vw_n   => vw_n,
        vram_n => vram_n,
        am     => am(10 downto 0),
        ddma   => ddma
    ); 

    --Vector Generator ROM.
    vec_rom_0 : entity work.vec_rom
    port map
    ( 
        vrom2_n => vrom2_n,
        am      => am(10 downto 0),
        ddma    => ddma
    ); 

    --State Machine.
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
        halt         => halt_int,
        blank_n      => blank_n_int,
        vgck_s_n     => vgck_s_n_int,
        adma0        => adma(0),
        haltstrobe_n => haltstrobe_n,
        gostrobe_n   => gostrobe_n,
        dmald_n      => dmald_n,
        dmapush_n    => dmapush_n,
        latch_n      => latch_n
    );

end structural;
