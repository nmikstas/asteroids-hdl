--This module is a recreation of an SN74LS273 octal flip-flop.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                  --Octal Flip-flop Entity--                                    --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn74ls273 is
    port 
    ( 
        clk   : in  std_logic; --Positive edge triggered.
        clr_n : in  std_logic; --Active low.      
        d     : in  std_logic_vector(7 downto 0);       
        q     : out std_logic_vector(7 downto 0) := "00000000"
    );     
end sn74ls273;

----------------------------------------------------------------------------------------------------
--                               --Octal Flip-flop Architecture--                                 --
----------------------------------------------------------------------------------------------------

architecture structural of sn74ls273 is
begin

    process(clk, clr_n)
    begin

        --Asynchronous clear.
        if clr_n = '0' then
            q <= "00000000";

        --Positive edge triggered D-type flip-flops.
        elsif rising_edge(clk) then
            q <= d;
        end if;

    end process;
end structural;

