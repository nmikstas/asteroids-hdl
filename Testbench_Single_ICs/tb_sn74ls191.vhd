--Test bench for the SN74LS191 up/down counter.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn74ls191 is
end tb_sn74ls191;

architecture Behavioral of tb_sn74ls191 is

    constant CLK_PERIOD : time := 1 ns;

    signal clk     : std_logic := '0';
    signal cten    : std_logic := '1';
    signal load    : std_logic := '1';
    signal d_u     : std_logic := '0';
    signal d       : std_logic_vector(3 downto 0) := "1111";
    signal max_min : std_logic;
    signal rco     : std_logic;
    signal q       : std_logic_vector(3 downto 0);

begin

    --Define clock based on the clock period and disable count for 10 clock periods.
    clk   <= NOT clk after CLK_PERIOD / 2;

    sn74ls191_0: entity work.sn74ls191
    port map
    (
        clk     => clk,
        cten    => cten,
        load    => load,
        d_u     => d_u,
        d       => d,
        max_min => max_min,
        rco     => rco,
        q       => q
    );

    process
    begin
        wait for 15 ns;
        cten <= '0';     --Enable counting.

        wait for 35 ns;  --Change from counting up to counting down.
        d_u <= '1';

        wait for 10 ns;
        d    <= "0110";
        load <= '0';
        
        wait for 3 ns;
        load <= '1';

        wait for 300 ns; --Wait some time for the output results.
        std.env.stop;    --End the simulation.
    end process;

end Behavioral;