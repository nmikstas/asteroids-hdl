--This module is the program counter for Atari's Asteroids vector generator.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                  --Program Counter Entity--                                    --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vec_pgm_counter is
    port 
    ( 
        clk3mhz   : in  std_logic;
        dmald_n   : in  std_logic;
        dmapush_n : in  std_logic;
        timer0    : in  std_logic;
        latch0_n  : in  std_logic;
        latch2_n  : in  std_logic;
        dvy       : in  std_logic_vector(11 downto 0);

        adma      : out std_logic_vector(12 downto 1)
    );     
end vec_pgm_counter;

----------------------------------------------------------------------------------------------------
--                                --Program Counter Architecture--                                --
----------------------------------------------------------------------------------------------------

architecture structural of vec_pgm_counter is

    signal load      : std_logic_vector(12 downto 1) := "000000000000";
    signal adma_int  : std_logic_vector(12 downto 1) := "000000000000";
    signal ff_q_n    : std_logic := '0';
    signal or1_out   : std_logic := '0';
    signal stack_ck  : std_logic := '0';
    signal stack_ptr : std_logic_vector(3 downto 0) := "0000";
    signal timer0_n  : std_logic := '0';
    signal dmapush   : std_logic := '0';
    signal reg_wr    : std_logic := '0';
    signal cntr_ck   : std_logic := '0';
    signal carry0    : std_logic := '0';
    signal carry1    : std_logic := '0';

begin

    --Always assign output.
    adma <= adma_int;

    ----------D4 Flip-Flop----------
    sn74ls74_0 : entity work.sn74ls74
    port map
    ( 
        clk1   => clk3mhz,
        pre1_n => '1', --Pullup R29.
        clr1_n => timer0,
        d1     => dmald_n,
        q1     => open,
        q1_n   => ff_q_n,

        --The second flip-flop is unused.
        clk2   => '0',
        pre2_n => '0',
        clr2_n => '0',
        d2     => '0',  
        q2     => open,
        q2_n   => open
    );

    ----------B9 OR, Pins 8,9,10----------
    or1_out <= dmald_n or ff_q_n;

    ----------K6 AND, Pins 8,9,10----------
    stack_ck <= dmapush_n and or1_out;

    ----------K5 Counter----------
    sn74ls191_0 : entity work.sn74ls191
    port map
    ( 
        clk     => stack_ck,
        cten    => '0',
        load    => '1', --Pullup R27.
        d_u     => timer0,
        d       => "0000",
        max_min => open,
        rco     => open,
        q       => stack_ptr
    ); 

    ----------B5 Inverter, Pins 1,2----------
    dmapush <= not dmapush_n;

    ----------B5 Inverter, Pins 3,4----------
    timer0_n <= not timer0;

    ----------C6 NAND, Pins 1,2,3----------
    reg_wr <= not(clk3mhz and dmapush);

    ----------F4 Register File----------
    sn74ls670_0 : entity work.sn74ls670
    port map
    ( 
        gw_n => reg_wr,
        gr_n => timer0_n,
        w    => stack_ptr(1 downto 0),
        r    => stack_ptr(1 downto 0),
        d    => adma_int(4 downto 1),
        q    => load(4 downto 1)
    );

    ----------H4 Register File----------
    sn74ls670_1 : entity work.sn74ls670
    port map
    ( 
        gw_n => reg_wr,
        gr_n => timer0_n,
        w    => stack_ptr(1 downto 0),
        r    => stack_ptr(1 downto 0),
        d    => adma_int(8 downto 5),
        q    => load(8 downto 5)
    );

    ----------J4 Register File----------
    sn74ls670_2 : entity work.sn74ls670
    port map
    ( 
        gw_n => reg_wr,
        gr_n => timer0_n,
        w    => stack_ptr(1 downto 0),
        r    => stack_ptr(1 downto 0),
        d    => adma_int(12 downto 9),
        q    => load(12 downto 9)
    );

    ----------H6 Bus Driver----------
    sn74ls367_0 : entity work.sn74ls367
    port map
    ( 
        g1_n => timer0,
        g2_n => timer0,
        a1   => dvy(5 downto 2),
        a2   => dvy(1 downto 0),
        y1   => load(6 downto 3),
        y2   => load(2 downto 1)
    );

    ----------J6 Bus Driver----------
    sn74ls367_1 : entity work.sn74ls367
    port map
    ( 
        g1_n => timer0,
        g2_n => timer0,
        a1   => dvy(11 downto 8),
        a2   => dvy(7 downto 6),
        y1   => load(12 downto 9),
        y2   => load(8 downto 7)
    );

    ----------B8 AND, Pins 4,5,6----------
    cntr_ck <= latch0_n and latch2_n;

    ----------F5 Counter----------
    sn74ls193_0 : entity work.sn74ls193
    port map
    ( 
        down   => '1', --Pullup R27.
        up     => cntr_ck,
        clr    => '0',
        load_n => dmald_n,
        d      => load(4 downto 1),
        bo_n   => open,
        co_n   => carry0,
        q      => adma_int(4 downto 1)
    ); 

    ----------H5 Counter----------
    sn74ls193_1 : entity work.sn74ls193
    port map
    ( 
        down   => '1', --Pullup R27.
        up     => carry0,
        clr    => '0',
        load_n => dmald_n,
        d      => load(8 downto 5),
        bo_n   => open,
        co_n   => carry1,
        q      => adma_int(8 downto 5)
    );

    ----------J5 Counter----------
    sn74ls193_2 : entity work.sn74ls193
    port map
    ( 
        down   => '1', --Pullup R27.
        up     => carry1,
        clr    => '0',
        load_n => dmald_n,
        d      => load(12 downto 9),
        bo_n   => open,
        co_n   => open,
        q      => adma_int(12 downto 9)
    );

end structural;

