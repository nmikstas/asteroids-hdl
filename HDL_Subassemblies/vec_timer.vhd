--This module is the vector timer for Atari's Asteroids vector generator.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                    --Vector Timer Entity--                                     --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vec_timer is
    port 
    ( 
        vgck       : in  std_logic; --1.5MHz MCU clock.
        go         : in  std_logic;
        latch2_n   : in  std_logic;
        dvx11      : in  std_logic;
        dvy11      : in  std_logic;
        timer      : in  std_logic_vector(3 downto 0);
        scale      : in  std_logic_vector(3 downto 0);

        alphanum_n : out std_logic;
        stop_n     : out std_logic
    );     
end vec_timer;

----------------------------------------------------------------------------------------------------
--                                 --Vector Timer Architecture--                                  --
----------------------------------------------------------------------------------------------------

architecture structural of vec_timer is

    signal mux_in       : std_logic_vector(3 downto 0)  := "0000";
    signal mux_out      : std_logic_vector(3 downto 0)  := "0000";
    signal ff_out       : std_logic_vector(3 downto 0)  := "0000";
    signal add_out      : std_logic_vector(3 downto 0)  := "0000";
    signal dec_out      : std_logic_vector(9 downto 0)  := "0000000000";
    signal count0_in    : std_logic_vector(3 downto 0)  := "0000";
    signal count1_in    : std_logic_vector(3 downto 0)  := "0000";
    signal count2_in    : std_logic_vector(3 downto 0)  := "0000";
    signal count0_out   : std_logic_vector(3 downto 0)  := "0000";
    signal count1_out   : std_logic_vector(3 downto 0)  := "0000";
    signal count2_out   : std_logic_vector(3 downto 0)  := "0000";
    signal count_val    : std_logic_vector(11 downto 0) := "000000000000";
    signal timer31_nand : std_logic := '0';
    signal ff_clk       : std_logic := '0';
    signal alphanum_int : std_logic := '0';
    signal dvx11_n      : std_logic := '0';
    signal rip0         : std_logic := '0';
    signal rip1         : std_logic := '0';
    signal rip2         : std_logic := '0';
    
begin

    ----------N5 NAND, Pins 8,9,10----------
    timer31_nand <= not(timer(3) and timer(1));

    ----------N6 OR, Pins 8,9,10----------
    ff_clk <= timer31_nand or latch2_n;

    ----------E5 4-Input NAND, Pins 1,2,4,5,6----------
    alphanum_int <= not(timer(0) and timer(1) and timer(2) and timer(3));

    --Assign the output alphanum_n.
    alphanum_n <= alphanum_int;

    ----------B6 Inverter, Pins 3,4----------
    dvx11_n <= not dvx11;

    --Combine the input signals to the MUX.
    mux_in <= '0' & dvx11 & dvx11_n & dvy11;

    ----------F6 4-Bit 2-To-1 MUX--------
    sn74ls157_0 : entity work.sn74ls157
    port map
    ( 
        a_b => alphanum_int,
        g   => '0',
        a   => mux_in,
        b   => timer,
        y   => mux_out
    );     

    --------M7 Quad Flip-Flop----------
    sn74ls175_0 : entity work.sn74ls175
    port map
    ( 
        clk   => ff_clk,
        clr_n => '1', --Pullup resistor R27.
        d     => scale,
        q     => ff_out,
        q_n   => open
    );

    ----------M6 4-Bit Adder----------
    sn74ls83_0 : entity work.sn74ls83
    port map
    ( 
        c0 => '0',
        a  => ff_out,
        b  => mux_out,
        c4 => open,
        s  => add_out
    );

    ----------E7 4-Bit To Decimal Decoder----------
    sn74ls42_0 : entity work.sn74ls42
    port map
    ( 
        i => add_out,
        o => dec_out
    ); 

    --Assign the inputs to the counters.
    count0_in <= dec_out(2 downto 0) & '1';
    count2_in <= '1' & dec_out(9 downto 7);

    ----------D7 4-Bit Counter----------
    sn74ls161_0 : entity work.sn74ls161
    port map
    ( 
        clk     => vgck,
        enp     => go,
        ent     => go,
        load_n  => go,
        clear_n => '1', --Pullup resistor R29.
        i       => count0_in,
        rco     => rip0,
        q       => count0_out
    );

    ----------C7 4-Bit Counter----------
    sn74ls161_1 : entity work.sn74ls161
    port map
    ( 
        clk     => vgck,
        enp     => rip0,
        ent     => rip0,
        load_n  => go,
        clear_n => '1', --Pullup resistor R29.
        i       => dec_out(6 downto 3),
        rco     => rip1,
        q       => count1_out
    );

    ----------B7 4-Bit Counter----------
    sn74ls161_2 : entity work.sn74ls161
    port map
    ( 
        clk     => vgck,
        enp     => rip1,
        ent     => rip1,
        load_n  => go,
        clear_n => '1', --Pullup resistor R29.
        i       => count2_in,
        rco     => rip2,
        q       => count2_out
    );

    ----------A8 NAND, Pins 1,2,12,13----------
    stop_n <= not rip2;

    --Create a concantenation of the timer signals for simulation.
    count_val <= count2_out & count1_out & count0_out;

end structural;
