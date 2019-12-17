--This module is the memory address selector for Atari's Asteroids vector generator.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                              --Memory Address Selector Entity--                                --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vec_mem_select is
    port 
    ( 
        adma     : in  std_logic_vector(12 downto 0);
        ab       : in  std_logic_vector(12 downto 0);
        phi2     : in  std_logic;
        r_wb     : in  std_logic;
        vmem_n   : in  std_logic;

        am       : out std_logic_vector(12 downto 0);
        buffen_n : out std_logic;
        vw_n     : out std_logic;
        vrom2_n  : out std_logic;
        vram_n   : out std_logic
    );     
end vec_mem_select;

----------------------------------------------------------------------------------------------------
--                            --Memory Address Selector Architecture--                            --
----------------------------------------------------------------------------------------------------

architecture structural of vec_mem_select is

    signal vw_or     : std_logic := '0';
    signal dec_out   : std_logic_vector(3 downto 0)  := "0000";
    signal mux1_in_a : std_logic_vector(3 downto 0)  := "0000";
    signal mux1_in_b : std_logic_vector(3 downto 0)  := "0000";
    signal mux1_out  : std_logic_vector(3 downto 0)  := "0000";
    signal mux2_in_a : std_logic_vector(3 downto 0)  := "0000";
    signal mux2_in_b : std_logic_vector(3 downto 0)  := "0000";
    signal mux2_out  : std_logic_vector(3 downto 0)  := "0000";
    signal mux3_in_a : std_logic_vector(3 downto 0)  := "0000";
    signal mux3_in_b : std_logic_vector(3 downto 0)  := "0000";
    signal mux3_out  : std_logic_vector(3 downto 0)  := "0000";
    signal mux4_in_a : std_logic_vector(3 downto 0)  := "0000";
    signal mux4_in_b : std_logic_vector(3 downto 0)  := "0000";
    signal mux4_out  : std_logic_vector(3 downto 0)  := "0000";
    signal am_int    : std_logic_vector(12 downto 0) := "0000000000000";

begin

    --Always assign outputs.
    am <= am_int;

    --Always assign multiplexer inputs and outputs.
    mux1_in_a <= r_wb & phi2 & ab(12 downto 11);
    mux1_in_b <= "11" & adma(12 downto 11); 
    mux2_in_a <= '0' & ab(10 downto 8);
    mux2_in_b <= '0' & adma(10 downto 8);
    mux3_in_a <= ab(7 downto 4);
    mux3_in_b <= adma(7 downto 4);
    mux4_in_a <= ab(3 downto 0);
    mux4_in_b <= adma(3 downto 0);

    --MUX 1 output.
    vw_or                <= mux1_out(3);
    buffen_n             <= mux1_out(2);
    am_int(12 downto 11) <= mux1_out(1 downto 0);

    --MUX2 output.
    am_int(10 downto 8) <= mux2_out(2 downto 0);

    --MUX3 output.
    am_int(7 downto 4) <= mux3_out;

    --MUX4 output.
    am_int(3 downto 0) <= mux4_out;

    ----------K3 Multiplexer----------
    sn74ls157_0 : entity work.sn74ls157
    port map
    ( 
        a_b => vmem_n,
        g   => '0',
        a   => mux1_in_a,
        b   => mux1_in_b,
        y   => mux1_out
    );     

    ----------J3 Multiplexer----------
    sn74ls157_1 : entity work.sn74ls157
    port map
    ( 
        a_b => vmem_n,
        g   => '0',
        a   => mux2_in_a,
        b   => mux2_in_b,
        y   => mux2_out
    );   

    ----------H3 Multiplexer----------
    sn74ls157_2 : entity work.sn74ls157
    port map
    ( 
        a_b => vmem_n,
        g   => '0',
        a   => mux3_in_a,
        b   => mux3_in_b,
        y   => mux3_out
    );

    ----------F3 Multiplexer----------
    sn74ls157_3 : entity work.sn74ls157
    port map
    ( 
        a_b => vmem_n,
        g   => '0',
        a   => mux4_in_a,
        b   => mux4_in_b,
        y   => mux4_out
    );

    ----------M5 OR, Pins 8,9,10----------
    vw_n <= vw_or or phi2;

    ----------L3 Decoder----------
    sn74ls139_0 : entity work.sn74ls139
    port map
    ( 
        --Unused decoder.
        g1_n => '0',
        i1   => "00",
        o1   => open,

        g2_n => '0',
        i2   => am_int(12 downto 11),
        o2   => dec_out
    );   

    --Always assign decoder out signals.
    vrom2_n <= dec_out(2);
    vram_n  <= dec_out(0);

end structural;

