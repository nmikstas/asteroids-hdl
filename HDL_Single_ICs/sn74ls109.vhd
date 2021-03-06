--This module is a recreation of an SN74LS109 dual JK-type flip flops.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                      --Flip-Flop Entity--                                      --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn74ls109 is
    port 
    ( 
        clk1   : in  std_logic;
        pre1_n : in  std_logic;
        clr1_n : in  std_logic;
        j1     : in  std_logic;
        k1     : in  std_logic;
        q1     : out std_logic;
        q1_n   : out std_logic;

        clk2   : in  std_logic;
        pre2_n : in  std_logic;
        clr2_n : in  std_logic;
        j2     : in  std_logic;
        k2     : in  std_logic;
        q2     : out std_logic;
        q2_n   : out std_logic
    );     
end sn74ls109;

----------------------------------------------------------------------------------------------------
--                                   --Flip-Flop Architecture--                                   --
----------------------------------------------------------------------------------------------------

architecture behavioral of sn74ls109 is
    signal q1_int : std_Logic := '0';
    signal q2_int : std_Logic := '0';
begin

    --Assign the outputs.
    q1   <= q1_int;
    q2   <= q2_int;
    q1_n <= not q1_int;
    q2_n <= not q2_int;

    --Flip-flop 1.
    process(clk1, pre1_n, clr1_n)
    begin

        --Invalid for both set and clear to be active.
        if clr1_n = '0' and pre1_n = '0' then
            q1_int <= 'X';
        elsif clr1_n = '0' then
            q1_int <= '0';
        elsif pre1_n = '0' then
            q1_int <= '1';
        elsif rising_edge(clk1) and j1 = '0' and k1 = '0' then
            q1_int <= '0';
        elsif rising_edge(clk1) and j1 = '1' and k1 = '0' then
            q1_int <= not q1_int;
        elsif rising_edge(clk1) and j1 = '1' and k1 = '1' then
            q1_int <= '1';
        end if;
    end process;

    --Flip-flop 2.
    process(clk2, pre2_n, clr2_n)
    begin

        --Invalid for both set and clear to be active.
        if clr2_n = '0' and pre2_n = '0' then
            q2_int <= 'X';
        elsif clr2_n = '0' then
            q2_int <= '0';
        elsif pre2_n = '0' then
            q2_int <= '1';
        elsif rising_edge(clk2) and j2 = '0' and k2 = '0' then
            q2_int <= '0';
        elsif rising_edge(clk2) and j2 = '1' and k2 = '0' then
            q2_int <= not q2_int;
        elsif rising_edge(clk2) and j2 = '1' and k2 = '1' then
            q2_int <= '1';
        end if;
    end process;

end behavioral;
