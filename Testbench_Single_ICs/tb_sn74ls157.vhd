--Test bench for the SN74ls157 multipplexer.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn74ls157 is
end tb_sn74ls157;

architecture Behavioral of tb_sn74ls157 is

    signal a_b : std_logic := '0';
    signal g   : std_logic := '1';
    signal a   : std_logic_vector(3 downto 0);
    signal b   : std_logic_vector(3 downto 0);
    signal y   : std_logic_vector(3 downto 0);
    
begin

    sn74ls157_0: entity work.sn74ls157
    port map
    (
        a_b => a_b,
        g   => g,
        a   => a,
        b   => b,
        y   => y
    );

    process
    begin
        a <= "1010";
        b <= "0101";
        
        wait for 15 ns;
        g <= '0';

        wait for 15 ns;
        a_b <= '1';

        wait for 15 ns;
        g <= '1';

        wait for 15 ns;
        std.env.stop;    --End the simulation.
    end process;
end Behavioral;



