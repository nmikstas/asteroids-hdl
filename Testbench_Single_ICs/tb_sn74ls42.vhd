--Test bench for the SN74LS42 decimal decoder.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn74ls42 is
end tb_sn74ls42;

architecture behavioral of tb_sn74ls42 is

    signal i  : std_logic_vector(3 downto 0);
    signal o  : std_logic_vector(9 downto 0);
    
begin
    
    sn74ls42_0: entity work.sn74ls42
    port map
    (
        i => i,
        o => o
    );

    process
    begin
        wait for 15 ns;
        i <= "0000";

        wait for 15 ns;
        i <= "0001";

        wait for 15 ns;
        i <= "0010";

        wait for 15 ns;
        i <= "0011";

        wait for 15 ns;
        i <= "0100";

        wait for 15 ns;
        i <= "0101";

        wait for 15 ns;
        i <= "0110";

        wait for 15 ns;
        i <= "0111";

        wait for 15 ns;
        i <= "1000";

        wait for 15 ns;
        i <= "1001";

        wait for 15 ns;
        i <= "1010";

        wait for 15 ns;
        i <= "1011";

        wait for 15 ns;
        i <= "1100";

        wait for 15 ns;
        i <= "1101";

        wait for 15 ns;
        i <= "1110";

        wait for 15 ns;
        i <= "1111";

        wait for 15 ns;
        std.env.stop;    --End the simulation.
    end process;
end behavioral;
