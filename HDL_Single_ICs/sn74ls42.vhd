--This module is a recreation of an SN74LS42 decimal decoder.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                   --Decimal Decoder Entity--                                   --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn74ls42 is
    port 
    ( 
        i : in  std_logic_vector(3 downto 0);
        o : out std_logic_vector(9 downto 0)
    );     
end sn74ls42;

----------------------------------------------------------------------------------------------------
--                                --Decimal Decoder Architecture--                                --
----------------------------------------------------------------------------------------------------

architecture behavioral of sn74ls42 is
begin

    --Simply assign the output based on the input.
    o <= "1111111110" when i = "0000" else
         "1111111101" when i = "0001" else
         "1111111011" when i = "0010" else
         "1111110111" when i = "0011" else
         "1111101111" when i = "0100" else
         "1111011111" when i = "0101" else
         "1110111111" when i = "0110" else
         "1101111111" when i = "0111" else
         "1011111111" when i = "1000" else
         "0111111111" when i = "1001" else
         "1111111111";

end behavioral;

