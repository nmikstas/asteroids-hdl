--This module is the memory data latches for Atari's Asteroids vector generator.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                 --Memory Data Latches Entity--                                 --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vec_mem_latches is
    port 
    ( 
        reset_n    : in  std_logic;
        dmago_n    : in  std_logic;
        alphanum_n : in  std_logic;
        ddma       : in  std_logic_vector(7 downto 0);
        latch_n    : in  std_logic_vector(3 downto 0);

        dvx        : out std_logic_vector(11 downto 0);
        dvy        : out std_logic_vector(11 downto 0);
        timer      : out std_logic_vector(3 downto 0);
        scale      : out std_logic_vector(3 downto 0)
    );     
end vec_mem_latches;

----------------------------------------------------------------------------------------------------
--                              --Memory Data Latches Architecture--                              --
----------------------------------------------------------------------------------------------------

architecture structural of vec_mem_latches is

    signal alph_l0_out : std_logic := '0';
    signal top_ff_ck   : std_logic := '0';
    signal rst_dgo_out : std_logic := '0';
    signal bot_ff_clr  : std_logic := '0';
    signal ff0_out     : std_logic_vector(7 downto 0) := "00000000";
    signal ff1_out     : std_logic_vector(7 downto 0) := "00000000";
    signal ff2_out     : std_logic_vector(7 downto 0) := "00000000";
    signal ff3_out     : std_logic_vector(7 downto 0) := "00000000";

begin

    --Assign flip-flop outputs to ports.
    scale            <= ff0_out(7 downto 4);
    dvx(11 downto 8) <= ff0_out(3 downto 0);
    dvx(7 downto 0)  <= ff1_out;
    timer            <= ff2_out(7 downto 4);
    dvy(11 downto 8) <= ff2_out(3 downto 0);
    dvy(7 downto 0)  <= ff3_out;

    ----------B9 OR, Pins 1,2,3----------
    alph_l0_out <= alphanum_n or latch_n(0);

    ----------K6 AND, Pins 11,12,13----------
    top_ff_ck <= latch_n(3) and alph_l0_out;

    ----------K6 AND, Pins 1,2,3----------
    rst_dgo_out <= reset_n and dmago_n;

    ----------K6 AND, Pins 4,5,6----------
    bot_ff_clr <= alphanum_n and rst_dgo_out;

    ----------K7 Octal Flip-Flop----------
    sn74ls273_0 : entity work.sn74ls273
    port map
    ( 
        clk   => top_ff_ck,
        clr_n => '1', --Pullup R27.
        d     => ddma,
        q     => ff0_out
    ); 

    ----------J7 Octal Flip-Flop----------
    sn74ls273_1 : entity work.sn74ls273
    port map
    ( 
        clk   => latch_n(2),
        clr_n => alphanum_n,
        d     => ddma,
        q     => ff1_out
    ); 

    ----------F7 Octal Flip-Flop----------
    sn74ls273_2 : entity work.sn74ls273
    port map
    ( 
        clk   => latch_n(1),
        clr_n => rst_dgo_out,
        d     => ddma,
        q     => ff2_out
    ); 

    ----------H7 Octal Flip-Flop----------
    sn74ls273_3 : entity work.sn74ls273
    port map
    ( 
        clk   => latch_n(0),
        clr_n => bot_ff_clr,
        d     => ddma,
        q     => ff3_out
    ); 

end structural;

