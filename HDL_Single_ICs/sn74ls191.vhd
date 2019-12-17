--This module is a recreation of an SN74LS191 up/down counter.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                  --Up/Down Counter Entity--                                    --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn74ls191 is
    port 
    ( 
        clk     : in std_logic; --Positive edge triggered.
        cten    : in std_logic; --Active low.
        load    : in std_logic; --Active low.
        d_u     : in std_logic; --High = count down, low = count up.
        d       : in std_logic_vector(3 downto 0);
        max_min : out std_logic; --Active high
        rco     : out std_logic; --Active low.
        q       : out std_logic_vector(3 downto 0)
    );     
end sn74ls191;

----------------------------------------------------------------------------------------------------
--                               --Up/Down Counter Architecture--                                 --
----------------------------------------------------------------------------------------------------

architecture structural of sn74ls191 is

    --T flip-flop array signals. signal names taken from the sn74ls191 datasheet.
    signal t     : std_logic_vector(3 downto 0) := "0000"; --enable inputs(J/K tied together).
    signal c     : std_logic_vector(3 downto 0) := "0000"; --clock inputs.
    signal q_buf : std_logic_vector(3 downto 0) := "0000"; --Outputs.
    signal q_not : std_logic_vector(3 downto 0) := "0000"; --Inverted outputs.
    
    --Misc. internal signals.
    signal s_int    : std_logic_vector(3 downto 0) := "0000";
    signal up_max   : std_logic := '0';
    signal down_min : std_logic := '0';
    signal tc0      : std_logic := '0';
    signal tc1      : std_logic := '0';

begin

    --Always assign q_not to the inverse of q_buf.
    q_not <= not q_buf;

    --Assign q output.
    q <= q_buf;

    --Assign rco output.
    rco <= not((up_max or down_min) and (not clk) and (not cten));

    --Assign max_min output.
    up_max   <= (not d_u) and q_buf(0) and q_buf(1) and q_buf(2) and q_buf(3);
    down_min <= d_u and q_not(0) and q_not(1) and q_not(2) and q_not(3);
    max_min  <= up_max or down_min;

    --Assign toggles.
    t(0) <= not cten;
    t(1) <= (tc1 and q_not(0)) or (tc0 and q_buf(0));
    t(2) <= (tc1 and q_not(0) and q_not(1)) or (tc0 and q_buf(0) and q_buf(1));
    t(3) <= (tc1 and q_not(0) and q_not(1) and q_not(2)) or
            (tc0 and q_buf(0) and q_buf(1) and q_buf(2));

    --Internal control signals.
    tc0 <= (not d_u) and (not cten);
    tc1 <= d_u and (not cten);

    --Toggle flip flop control.
    process(clk, load, d)

        variable s : std_logic_vector(3 downto 0); --Asynchronous set.
        variable r : std_logic_vector(3 downto 0); --Asynchronous reset.

    begin

        --Assign asynchronous sets.
        for i in 0 to 3 loop
            s(i) := not((not load) and d(i));
        end loop;

        --Assign asynchronous resets.
        for i in 0 to 3 loop
            r(i) := not(s(i) and (not load));
        end loop;

        for i in 0 to 3 loop
            --Asynchronous set.
            if s(i) = '0' then
                q_buf(i) <= '1';

            --Asynchronous reset.
            elsif r(i) = '0' then 
                q_buf(i) <= '0';
        
            --Toggle the output on the positive clock edge when toggle is high.
            elsif rising_edge(clk) then
                if t(i) = '1' then
                    q_buf(i) <= not q_buf(i);
                end if;
            end if;
        end loop;
    end process;

end structural;


