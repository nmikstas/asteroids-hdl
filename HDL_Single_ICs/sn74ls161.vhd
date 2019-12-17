--This module is a recreation of an SN74LS161 binary counter.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                   --Binary Counter Entity--                                    --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn74ls161 is
    port 
    ( 
        clk     : in  std_logic;
        enp     : in  std_logic;
        ent     : in  std_logic;
        load_n  : in  std_logic;
        clear_n : in  std_logic;
        i       : in  std_logic_vector(3 downto 0);
        
        rco     : out std_logic;
        q       : out std_logic_vector(3 downto 0)
    );     
end sn74ls161;

----------------------------------------------------------------------------------------------------
--                                --Binary Counter Architecture--                                 --
----------------------------------------------------------------------------------------------------

architecture behavioral of sn74ls161 is

   signal q_int : unsigned(3 downto 0) := "0000";

begin

    --Assign the output count value.
    q <= std_logic_vector(q_int);

    --Assign ripple carry output.
    process(q_int, ent)
    begin
        if q_int = "1111" and ent = '1' then
            rco <= '1';
        else 
            rco <= '0';
        end if;
    end process;

    --Counter behavior.
    process(clk, clear_n)
    begin
        if clear_n = '0' then

            --Asynchronous clear.
            q_int <= "0000";

        elsif rising_edge(clk) then
            
            --Synchronous load.
            if load_n = '0' then
                q_int <= unsigned(i);
            elsif enp = '1' and ent = '1' then
                q_int <= q_int + "1";
            end if;

        end if;
    end process; 

end behavioral;
