--This module is a recreation of a b2s129 256 X 4 ROM.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                         --ROM Entity--                                         --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;

entity rom_b2s129 is
    generic
    (
        filename : string := "./ROM.hex"
    );
    port 
    ( 
        cs1_n : in  std_logic;
        cs2_n : in  std_logic;
        a     : in  std_logic_vector(7 downto 0);
        d     : out std_logic_vector(3 downto 0)       
    );     
end rom_b2s129;

----------------------------------------------------------------------------------------------------
--                                      --ROM Architecture--                                      --
----------------------------------------------------------------------------------------------------

architecture structural of rom_b2s129 is

    type mem is array(255 downto 0) of std_logic_vector(3 downto 0);
    signal t_mem : mem := (others => (others => '0'));

begin

    process(a, cs1_n, cs2_n)
        file f     : text;
        variable l : line;
        variable i : integer := 0;
        variable b : std_logic_vector(3 downto 0);
    begin
    
        file_open(f, filename, read_mode);

        --Read the contents of the ROM file into memory.
        while (i < 256) and not endfile(f) loop
            readline(f, l);
            hread(l, b);
            t_mem(i) <= b;
            i := i + 1;
        end loop;

        file_close(f);

        --Put the data on the output as long as the chip is enabled.
        if cs1_n = '0' and cs2_n = '0' then
            d <= t_mem(to_integer(unsigned(a)));
        else
            d <= "ZZZZ";
        end if;

    end process;
end structural;
