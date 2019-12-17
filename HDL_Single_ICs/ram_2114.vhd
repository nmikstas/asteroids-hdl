--This module is a recreation of a 2114 RAM chip
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                        --RAM Entity--                                          --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_2114 is
    port 
    ( 
        we_n : in std_logic := '1';
        ce_n : in std_logic := '1';
        a    : in std_logic_vector(9 downto 0);
        dq   : inout std_logic_vector(3 downto 0)
    );     
end ram_2114;

----------------------------------------------------------------------------------------------------
--                                     --RAM Architecture--                                       --
----------------------------------------------------------------------------------------------------

architecture behaviorial of ram_2114 is

    type mem is array(1023 downto 0) of std_logic_vector(3 downto 0);
    signal t_mem : mem := (others => (others => '0'));

begin

    process(a, we_n, ce_n, dq)
    begin

        --only read or write if the chip enable line is low.
        if ce_n = '0' then

            --If write enable is low, write to RAM.
            if we_n <= '0' then
                dq <= "ZZZZ";
                t_mem(to_integer(unsigned(a))) <= dq;

            --If write enable is high, read from RAM.
            elsif we_n <= '1' then
                dq <= t_mem(to_integer(unsigned(a)));
            end if;

        --Chip is not enabled, set the output to high impedance.
        elsif ce_n <= '1' then
            dq <= "ZZZZ";
        end if;

    end process;

end behaviorial;