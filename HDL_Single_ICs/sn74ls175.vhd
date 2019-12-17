--This module is a recreation of an SN74LS175 quad flip-flop.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                   --Quad Flip-flop Entity--                                    --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn74ls175 is
    port 
    ( 
        clk   : in  std_logic; --Positive edge triggered.
        clr_n : in  std_logic; --Active low.      
        d     : in  std_logic_vector(3 downto 0);       
        q     : out std_logic_vector(3 downto 0);
        q_n   : out std_logic_vector(3 downto 0)
    );     
end sn74ls175;

----------------------------------------------------------------------------------------------------
--                               --Quad Flip-flop Architecture--                                  --
----------------------------------------------------------------------------------------------------

architecture behavioral of sn74ls175 is

    --Internal 4-bit register.
    signal q_int : std_logic_vector(3 downto 0) := "0000";

begin

    --Set the outputs based on the internal register.
    q   <= q_int;
    q_n <= not q_int;

    process(clk, clr_n)
    begin

        --Asynchronous clear.
        if clr_n = '0' then
            q_int <= "0000";

        --Positive edge triggered D-type flip-flops.
        elsif rising_edge(clk) then
            q_int <= d;
        end if;

    end process;
end behavioral;
