--This module is a recreation of an SN74LS245 octal bus transceiver.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                               --Octal Bus Transceiver Entity--                                 --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn74ls245 is
    port 
    ( 
        dir  : in    std_logic; --0 = B data to A bus, 1 = A data to B bus.
        oe_n : in    std_logic; --Active low, 1 = isolation.      
        a    : inout std_logic_vector(7 downto 0) := "ZZZZZZZZ";       
        b    : inout std_logic_vector(7 downto 0) := "ZZZZZZZZ"
    );     
end sn74ls245;

----------------------------------------------------------------------------------------------------
--                            --Octal Bus Transceiver Architecture--                              --
----------------------------------------------------------------------------------------------------

architecture structural of sn74ls245 is

    signal a_en  : std_logic := '0';
    signal b_en  : std_logic := '0';
    signal a_out : std_logic_vector(7 downto 0) := "ZZZZZZZZ";
    signal b_out : std_logic_vector(7 downto 0) := "ZZZZZZZZ";

begin

    --Always assign a value to a_en and b_en.
    a_en <= dir and (not oe_n);
    b_en <= (not dir) and (not oe_n);

    a_out <= a when a_en = '1' else "ZZZZZZZZ";
    b_out <= b when b_en = '1' else "ZZZZZZZZ";

    b <= a_out;
    a <= b_out;   
       
end structural;
