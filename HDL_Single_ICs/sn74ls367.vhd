--This module is a recreation of an SN74LS367 hex bus driver.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                     --Bus Driver Entity--                                      --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn74ls367 is
    port 
    ( 
        g1_n : in  std_logic;
        g2_n : in  std_logic;
        a1   : in  std_logic_vector(3 downto 0);
        a2   : in  std_logic_vector(1 downto 0);
        y1   : out std_logic_vector(3 downto 0);
        y2   : out std_logic_vector(1 downto 0)
    );     
end sn74ls367;

----------------------------------------------------------------------------------------------------
--                                 --Bus Driver Architecture--                                    --
----------------------------------------------------------------------------------------------------

architecture structural of sn74ls367 is
begin

    y1 <= a1 when g1_n = '0' else "ZZZZ";
    y2 <= a2 when g2_n = '0' else "ZZ";

end structural;
