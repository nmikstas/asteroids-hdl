--This module is a recreation of an SN74LS670 register file.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                   --Register File Entity--                                     --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn74ls670 is
    port 
    ( 
        gw_n : in  std_logic;
        gr_n : in  std_logic;
        w    : in  std_logic_vector(1 downto 0);
        r    : in  std_logic_vector(1 downto 0);
        d    : in  std_logic_vector(3 downto 0);
        q    : out std_logic_vector(3 downto 0)
    );     
end sn74ls670;

----------------------------------------------------------------------------------------------------
--                                --Register File Architecture--                                  --
----------------------------------------------------------------------------------------------------

architecture behavioral of sn74ls670 is

    type data_array is array(3 downto 0) of std_logic_vector(3 downto 0);
    signal dat : data_array := ("0000", "0000", "0000", "0000");

begin

    process(gw_n, gr_n, w, r, d)
    begin
        --Write the register file.
        if gw_n <= '0' then
            dat(to_integer(unsigned(w))) <= d;
        end if;

        --Read the register file.
        if gr_n <= '0' then
            q <= dat(to_integer(unsigned(r)));
        else
            q <= "ZZZZ";
        end if;
    end process;

end behavioral;
