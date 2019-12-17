--This module is a recreation of an SN74LS139 dual decoder.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                    --Dual Decoder Entity--                                     --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn74ls139 is
    port 
    ( 
        g1_n : in  std_logic;
        i1   : in  std_logic_vector(1 downto 0);
        o1   : out std_logic_vector(3 downto 0);

        g2_n : in  std_logic;
        i2   : in  std_logic_vector(1 downto 0);
        o2   : out std_logic_vector(3 downto 0)
    );     
end sn74ls139;

----------------------------------------------------------------------------------------------------
--                                 --Dual Decoder Architecture--                                  --
----------------------------------------------------------------------------------------------------

architecture behavioral of sn74ls139 is
begin

    --Decoder 1.
    o1 <= "1111" when g1_n = '1'  else
          "1110" when i1   = "00" else
          "1101" when i1   = "01" else
          "1011" when i1   = "10" else
          "0111" when i1   = "11" else
          "1111";

    --Decoder 2.
    o2 <= "1111" when g2_n = '1'  else
          "1110" when i2   = "00" else
          "1101" when i2   = "01" else
          "1011" when i2   = "10" else
          "0111" when i2   = "11" else
          "1111";

end behavioral;
