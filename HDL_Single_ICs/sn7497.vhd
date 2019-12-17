--This module is a recreation of an SN7497 rate multiplier.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                  --Rate Multiplier Entity--                                    --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn7497 is
    port 
    ( 
        clk       : in  std_logic;  --Positive edge triggered.
        clr       : in  std_logic;  --Active high.
        en_in     : in  std_logic;  --Active low.
        strb      : in  std_logic;  --Active low.
        unity_cas : in  std_logic;
        b         : in  std_logic_vector(5 downto 0);
        en_out    : out std_logic;
        y         : out std_logic;
        z         : out std_logic
    );     
end sn7497;

----------------------------------------------------------------------------------------------------
--                               --Rate Multiplier Architecture--                                 --
----------------------------------------------------------------------------------------------------

architecture structural of sn7497 is

    --T flip-flop array signals. signal names taken from the SN7497 datasheet.
    signal g     : std_logic_vector(5 downto 0) := "000000"; --Enable inputs.
    signal t     : std_logic_vector(5 downto 0) := "000000"; --Clock inputs.
    signal q     : std_logic_vector(5 downto 0) := "000000"; --Outputs.
    signal q_not : std_logic_vector(5 downto 0) := "000000"; --Inverted outputs.
    signal clear : std_logic_vector(5 downto 0) := "000000"; --Asynchronous clear.

    --Misc. internal signals.
    signal strb_n   : std_logic := '0';
    signal rate_and : std_logic_vector(5 downto 0) := "000000";
    signal rate_or  : std_logic := '0';
    
begin
    --Always assign q_not to the inverse of q.
    q_not <= not q;

    --Enable signals for the T flip-flop array.
    g(0)   <= not en_in;
    g(1)   <= not en_in and q(0);
    g(2)   <= not en_in and q(0) and q(1);
    g(3)   <= not en_in and q(0) and q(1) and q(2);
    g(4)   <= not en_in and q(0) and q(1) and q(2) and q(3);
    g(5)   <= not en_in and q(0) and q(1) and q(2) and q(3) and q(4);
    en_out <= not en_in and q(0) and q(1) and q(2) and q(3) and q(4) and q(5);

    --Internal strobe signal assignment.
    strb_n <= (not clk) and (not strb);

    --Assign the output of the rate AND gates.
    rate_and(0) <= strb_n and q_not(0) and b(5);
    rate_and(1) <= strb_n and q(0) and q_not(1) and b(4);
    rate_and(2) <= strb_n and q(0) and q(1) and q_not(2) and b(3);
    rate_and(3) <= strb_n and q(0) and q(1) and q(2) and q_not(3) and b(2);
    rate_and(4) <= strb_n and q(0) and q(1) and q(2) and q(3) and q_not(4) and b(1);
    rate_and(5) <= strb_n and q(0) and q(1) and q(2) and q(3) and q(4) and q_not(5) and b(0);

    --Assign the output of the rate OR gate.
    rate_or <= rate_and(0) or rate_and(1) or rate_and(2) or 
               rate_and(3) or rate_and(4) or rate_and(5);

    --Assign Y and Z outputs.
    z <= not rate_or;
    y <= rate_or or (not unity_cas);

    --Toggle flip flop control.
    process(clk, clr)
    begin
        --Asynchronous clear.
        if clr = '1' then 
            q <= "000000";

        --Toggle the output on the positive clock edge when enable is high.
        elsif rising_edge(clk) then
            for i in 0 to 5 loop
                if g(i) = '1' then
                    q(i) <= not q(i);
                end if;
            end loop;
        end if;
    end process;
end structural;

