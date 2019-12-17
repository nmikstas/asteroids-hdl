--This module is a recreation of an SN74LS157 multiplexer.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                    --Multiplexer Entity--                                      --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn74ls157 is
    port 
    ( 
        a_b : in  std_logic; --Select line: 0 = a, 1 = b.
        g   : in  std_logic; --Active low.
        a   : in  std_logic_vector(3 downto 0);
        b   : in  std_logic_vector(3 downto 0);
        y   : out std_logic_vector(3 downto 0)
    );     
end sn74ls157;

----------------------------------------------------------------------------------------------------
--                                 --Multiplexer Architecture--                                   --
----------------------------------------------------------------------------------------------------

architecture structural of sn74ls157 is
begin

    --Just simple 2 to 1 mux logic.
    process(a, b, a_b, g)
    begin
        for i in 0 to 3 loop
            y(i) <= ((not g) and (not a_b) and a(i)) or ((not g) and a_b and b(i));
        end loop;
    end process;
end structural;
