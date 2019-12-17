--This module is a recreation of an SN74LS374 octal flip-flop.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                  --Octal Flip-flop Entity--                                    --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn74ls374 is
    port 
    ( 
        clk : in  std_logic; --Positive edge triggered.
        oc  : in  std_logic; --Active low.      
        d   : in  std_logic_vector(7 downto 0);       
        q   : out std_logic_vector(7 downto 0)
    );     
end sn74ls374;

----------------------------------------------------------------------------------------------------
--                               --Octal Flip-flop Architecture--                                 --
----------------------------------------------------------------------------------------------------

architecture structural of sn74ls374 is

    signal q_buf : std_logic_vector(7 downto 0) := "00000000";

begin

    --Output buffer control.
    process(q_buf, oc)
    begin
        if oc = '0' then
            q <= q_buf;
        else
            q <= "ZZZZZZZZ";
        end if;
    end process;

    --Simple D flip-flop logic.
    process(clk)
    begin
        if rising_edge(clk) then
            for i in 0 to 7 loop
                q_buf(i) <= d(i);
            end loop;
        end if;
    end process;
end structural;
