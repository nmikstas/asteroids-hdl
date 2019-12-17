--This module is the RAM for Atari's Asteroids vector generator.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                     --Vector RAM Entity--                                      --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vec_ram is
    port 
    ( 
        vw_n   : in std_logic;
        vram_n : in std_logic;
        am     : in std_logic_vector(10 downto 0);
        ddma   : inout std_logic_vector(7 downto 0)   
    );     
end vec_ram;

----------------------------------------------------------------------------------------------------
--                                  --Vector RAM Architecture--                                   --
----------------------------------------------------------------------------------------------------

architecture structural of vec_ram is

    signal am10_n : std_logic := '0';
    signal cs1_n  : std_logic := '0';
    signal cs2_n  : std_logic := '0';

begin

    ----------L5 Inverter, Pins 3,4----------
    am10_n <= not am(10);

    ----------M5 OR, Pins 4,5,6----------
    cs1_n <= vram_n or am(10);

    ----------M5 OR, Pins 1,2,3----------
    cs2_n <= vram_n or am10_n;

    ----------R4 RAM----------
    ram_2114_0 : entity work.ram_2114
    port map
    ( 
        we_n => vw_n,
        ce_n => cs1_n,
        a    => am(9 downto 0),
        dq   => ddma(7 downto 4)
    ); 

    ----------P4 RAM----------
    ram_2114_1 : entity work.ram_2114
    port map
    ( 
        we_n => vw_n,
        ce_n => cs2_n,
        a    => am(9 downto 0),
        dq   => ddma(7 downto 4)
    );

    ----------M4 RAM----------
    ram_2114_2 : entity work.ram_2114
    port map
    ( 
        we_n => vw_n,
        ce_n => cs1_n,
        a    => am(9 downto 0),
        dq   => ddma(3 downto 0)
    ); 

    ----------N4 RAM----------
    ram_2114_3 : entity work.ram_2114
    port map
    ( 
        we_n => vw_n,
        ce_n => cs2_n,
        a    => am(9 downto 0),
        dq   => ddma(3 downto 0)
    ); 

end structural;
