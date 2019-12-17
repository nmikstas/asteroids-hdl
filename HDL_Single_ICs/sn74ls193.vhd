--This module is a recreation of an SN74LS193 up/down counter.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                   --Up/Down Counter Entity--                                   --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn74ls193 is
    port 
    ( 
        down   : in  std_logic; --Count down clock.
        up     : in  std_logic; --Count up clock.
        clr    : in  std_logic;
        load_n : in  std_logic;
        d      : in  std_logic_vector(3 downto 0);

        bo_n   : out std_logic; --Borrow out.
        co_n   : out std_logic; --Carry out.
        q      : out std_logic_vector(3 downto 0)
    );     
end sn74ls193;

----------------------------------------------------------------------------------------------------
--                               --Up/Down Counter Architecture--                                 --
----------------------------------------------------------------------------------------------------

architecture behavioral of sn74ls193 is

    signal t_ff : std_logic_vector(3 downto 0) := "0000"; --The 4 internal T flip-flops.
    signal t    : std_logic_vector(3 downto 0) := "0000"; --Flip-flop toggle inputs.

    --Inverted input signals.
    signal down_n : std_logic := '0';
    signal up_n   : std_logic := '0';
    signal clr_n  : std_logic := '0';
    signal load   : std_logic := '0';

begin

    --Assign output.
    q <= t_ff;

    --Assign inverted signals.
    down_n <= not down;
    up_n   <= not up;
    clr_n  <= not clr;
    load   <= not load_n;
   
     --Assign toggles.
     t(0) <= down_n or up_n;
     t(1) <= (down_n and not t_ff(0)) or (up_n and t_ff(0));
     t(2) <= (down_n and not t_ff(0) and not t_ff(1)) or (up_n and t_ff(0) and t_ff(1));
     t(3) <= (down_n and not t_ff(0) and not t_ff(1) and not t_ff(2)) or 
             (up_n and t_ff(0) and t_ff(1) and t_ff(2));
    
    --Assign borrow out and carry out.
    bo_n <= not(down_n and not t_ff(0) and not t_ff(1) and not t_ff(2) and not t_ff(3));
    co_n <= not(up_n and t_ff(0) and t_ff(1) and t_ff(2) and t_ff(3));

    process(t, d, load, clr_n)
        
        variable s : std_logic_vector(3 downto 0); --Flip-flop set signals.
        variable r : std_logic_vector(3 downto 0); --Flip-flop reset signals.

    begin

        --Assign set signals.
        for i in 0 to 3 loop
            s(i) := not(d(i) and load and clr_n);
        end loop;
    
        --Assign reset signals.
        for i in 0 to 3 loop
            r(i) := not clr_n or not (not(s(i) and load));
        end loop;
            
        --Set and reset functions of the T flip-flops.
        for i in 0 to 3 loop
            if s(i) = '0' then
                t_ff(i) <= '1';
            elsif r(i) = '1' then
                t_ff(i) <= '0';
            end if;
        end loop;

        if falling_edge(t(0)) and s(0) = '1' and r(0) = '0' then
            t_ff(0) <= not t_ff(0);
        end if;

        if falling_edge(t(1)) and s(1) = '1' and r(1) = '0' then
            t_ff(1) <= not t_ff(1);
        end if;

        if falling_edge(t(2)) and s(2) = '1' and r(2) = '0' then
            t_ff(2) <= not t_ff(2);
        end if;

        if falling_edge(t(3)) and s(3) = '1' and r(3) = '0' then
            t_ff(3) <= not t_ff(3);
        end if;

    end process;
end architecture;
