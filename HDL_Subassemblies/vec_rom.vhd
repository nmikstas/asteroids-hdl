--This module is a recreation the Asteroids vector generator ROM.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                     --Vector ROM Entity--                                      --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;

entity vec_rom is
    port 
    ( 
        vrom2_n : in  std_logic                     := '1';
        am      : in  std_logic_vector(10 downto 0) := "00000000000";
        ddma    : out std_logic_vector(7 downto 0)  := "ZZZZZZZZ"       
    );     
end vec_rom;

----------------------------------------------------------------------------------------------------
--                                  --Vector ROM Architecture--                                   --
----------------------------------------------------------------------------------------------------

architecture structural of vec_rom is

begin

    ----------N/P3 ROM----------
    rom_8316e_1 : entity work.rom_8316e
    generic map
    (
        --Asteroids Vector ROM data.
        filename => "./ROM_Data_Files/Asteroids_ROM.hex"
    )
    port map
    ( 
        cs1_n => vrom2_n,
        cs2_n => '0',
        cs3   => '1',
        a     => am,
        d     => ddma
    );

end structural;
