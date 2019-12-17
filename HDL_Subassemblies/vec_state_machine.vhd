--This module is the state machine for Atari's Asteroids vector generator.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                    --State Machine Entity--                                    --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vec_state_machine is
    port 
    ( 
        vgck         : in  std_logic; --1.5MHz MCU clock.
        clk6mhz      : in  std_logic; --6MHz system clock.
        reset_n      : in  std_logic;
        vmem_n       : in  std_logic;
        dmago_n      : in  std_logic;
        dmacnt_n     : in  std_logic;
        stop_n       : in  std_logic;
        timer        : in  std_logic_vector(3 downto 0);
        
        go           : out std_logic;
        go_n         : out std_logic;
        go_s_n       : out std_logic;
        halt         : out std_logic;
        blank_n      : out std_logic;
        vgck_s_n     : out std_logic;
        adma0        : out std_logic;
        haltstrobe_n : out std_logic;
        gostrobe_n   : out std_logic;
        dmald_n      : out std_logic;
        dmapush_n    : out std_logic;
        latch_n      : out std_logic_vector(3 downto 0)
    );     
end vec_state_machine;

----------------------------------------------------------------------------------------------------
--                                 --State Machine Architecture--                                 --
----------------------------------------------------------------------------------------------------

architecture structural of vec_state_machine is

    --ROM signals.
    signal adr_lower : std_logic_vector(3 downto 0) := "0000";
    signal adr       : std_logic_vector(7 downto 0) := "00000000";
    signal rom_dat   : std_logic_vector(3 downto 0) := "0000";
    signal a7        : std_logic := '0';
    signal a6        : std_logic := '0';
    signal a5        : std_logic := '0';
    signal a4        : std_logic := '0';

    --Output mapped signals.
    signal go_n_int : std_logic := '0';
    signal halt_int : std_logic := '0';

    --Dual flip-flop signals.
    signal ff1_q   : std_logic := '0';
    signal ff1_q_n : std_logic := '0';
    signal ff2_q   : std_logic := '0';
    signal ff1_pre : std_logic := '0';

    --Decoder signals.
    signal dec_input  : std_logic_vector(3 downto 0) :="0000";
    signal dec_output : std_logic_vector(9 downto 0) :="0000000000";
    signal dec_in_hi  : std_logic := '0';

    --Hex flip-flop signals.
    signal ff_input  : std_logic_vector(5 downto 0) := "000000";
    signal ff_output : std_logic_vector(5 downto 0) := "000000";   
    signal ff_clk    : std_logic := '0';
    signal ff_4_n    : std_logic := '0';

    --Go/halt flip-flop signals.
    signal haltstrobe_int : std_logic := '0';
    signal gostrobe_int   : std_logic := '0';
    signal halt_n         : std_logic := '0';
    signal gostrobe       : std_logic := '0';
    signal h_ff_clr       : std_logic := '0';
    signal go_int         : std_logic := '0';

begin

    --Always assign output signals.
    haltstrobe_n <= haltstrobe_int;
    gostrobe_n   <= gostrobe_int;
    go_n         <= go_n_int;
    go           <= go_int;
    halt         <= halt_int;
    adma0        <= ff_output(2);

    ----------B8 AND, Pins 1,2,3----------
    a7 <= go_n_int and halt_n;

    ----------E6 AND, Pins 4,5,6----------
    a6 <= timer(2) and timer(3);

    ----------E6 AND, Pins 1,2,3----------
    a5 <= timer(1) and timer(3);

    ----------E6 AND, Pins 11,12,13----------
    a4 <= timer(0) and timer(3);

    --Combine address portions into a single bus.
    adr_lower <= ff_output(5 downto 2);
    adr       <= a7 & a6 & a5 & a4 & adr_lower;

    ----------C8 ROM----------
    rom_b2s129_0 : entity work.rom_b2s129
    generic map
    (
        --Asteroids Vector ROM.
        filename => "./ROM_Data_Files/Vec_State_Machine_ROM.hex"
    )
    port map
    ( 
        cs1_n => '0',
        cs2_n => '0',
        a     => adr,
        d     => rom_dat
    );

    --Remap Flip-flop inputs.
    ff_input <= rom_dat & '0' & halt_int;

    ----------B9 OR, Pins 4,5,6----------
    ff_clk <= vgck or ff1_q_n;

    --------D8 Hex Flip-Flops----------
    sn74ls174_0 : entity work.sn74ls174
    port map
    ( 
        clk => ff_clk,
        clr => reset_n,
        d   => ff_input,
        q   => ff_output
    );

    ----------D6 NAND, Pins 11,12,13----------
    blank_n <= not(ff_output(5) or ff_output(0));

    ----------A7 Dual Flip-Flop----------
    sn74ls74_0 : entity work.sn74ls74
    port map
    ( 
        clk1   => vgck,
        pre1_n => ff1_pre,
        clr1_n => '1', --Pullup R29.
        d1     => vmem_n,
        q1     => ff1_q,
        q1_n   => ff1_q_n,

        clk2   => clk6mhz,
        pre2_n => '1', --Pullup R29.
        clr2_n => '1', --Pullup R29.
        d2     => vgck,
        q2     => ff2_q,
        q2_n   => vgck_s_n
    );

    ----------A8 NAND, Pins 3,4,5,6----------
    dec_in_hi <= not(ff_output(5) and ff1_q and ff2_q);

    --Combine decoder input into a single bus.
    dec_input <= dec_in_hi & ff_output(4 downto 2);

    ----------L5 Inverter, Pins 12,13----------
    ff_4_n <= not ff_output(4);

    ----------A8 NAND, Pins 8,9,10,11----------
    ff1_pre <= not(ff_4_n and ff2_q);

    ----------E8 Decoder----------
    sn74ls42_0: entity work.sn74ls42
    port map
    ( 
        i => dec_input,
        o => dec_output
    ); 

    --Assign control signal outputs.
    latch_n        <= dec_output(7 downto 4);
    haltstrobe_int <= dec_output(3);
    gostrobe_int   <= dec_output(2);
    dmald_n        <= dec_output(1);
    dmapush_n      <= dec_output(0);

    ----------B6 Inverter, Pins 1,2----------
    gostrobe <= not gostrobe_int;

    ----------H10 Inverter, Pins 1,2----------
    go_s_n <= not go_int;

    ----------B8 AND, Pins 11,12,13----------
    h_ff_clr <= dmago_n and dmacnt_n;

    ----------A9 Dual JK Flip-Flop----------
    sn74ls109_0 : entity work.sn74ls109
    port map
    ( 
        clk1   => haltstrobe_int,
        pre1_n => reset_n,
        clr1_n => h_ff_clr,
        j1     => timer(0),
        k1     => timer(0),
        q1     => halt_int,
        q1_n   => halt_n,

        clk2   => clk6mhz,
        pre2_n => '1', --Pullup R29.
        clr2_n => halt_n,
        j2     => gostrobe,
        k2     => stop_n,
        q2     => go_int,
        q2_n   => go_n_int
    );    

end structural;

