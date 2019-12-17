--This module is the data buffer for Atari's Asteroids vector generator.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                     --Data Buffer Entity--                                     --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vec_data_buffer is
    port 
    ( 
        buffen_n : in std_logic;
        r_wb     : in std_logic;
        db       : inout std_logic_vector(7 downto 0);
        ddma     : inout std_logic_vector(7 downto 0)     
    );     
end vec_data_buffer;

----------------------------------------------------------------------------------------------------
--                                  --Data Buffer Architecture--                                  --
----------------------------------------------------------------------------------------------------

architecture structural of vec_data_buffer is

    --Pullups R1-R8.
    constant pullups : std_logic_vector(7 downto 0) := "HHHHHHHH";

begin

    --Instantiate the pullup resistors.
    ddma <= pullups;

    ----------R2 Bus Tranceiver----------
    sn74ls245_0 : entity work.sn74ls245
    port map
    (
        dir  => r_wb,
        oe_n => buffen_n,
        a    => ddma,
        b    => db
    );

end structural;