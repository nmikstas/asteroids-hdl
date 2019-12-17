--This module is a recreation of an SN74LS174 hex flip-flop.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                   --Hex Flip-flop Entity--                                     --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn74ls174 is
    port 
    ( 
        clk : in  std_logic; --Positive edge triggered.
        clr : in  std_logic; --Active low.      
        d   : in  std_logic_vector(5 downto 0);       
        q   : out std_logic_vector(5 downto 0) := "000000"
    );     
end sn74ls174;

----------------------------------------------------------------------------------------------------
--                                --Hex Flip-flop Architecture--                                  --
----------------------------------------------------------------------------------------------------

architecture structural of sn74ls174 is
begin

    --Standard D flip-flop with an asynchronous clear.
    process(clk, clr)
    begin
        if clr = '0' then
            q <= "000000";
        elsif rising_edge(clk) then
            q <= d;
        end if;
    end process;
end structural;