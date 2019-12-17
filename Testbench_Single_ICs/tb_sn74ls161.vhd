--Test bench for the SN74LS161 dual decoder.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn74ls161 is
end tb_sn74ls161;

architecture behavioral of tb_sn74ls161 is

    constant CLK_PERIOD : time := 10 ns;

    signal clk     : std_logic := '0';
    signal enp     : std_logic;
    signal ent     : std_logic;
    signal load_n  : std_logic;
    signal clear_n : std_logic;
    signal i       : std_logic_vector(3 downto 0);    
    signal rco     : std_logic;
    signal q       : std_logic_vector(3 downto 0);
    
begin
    
    clk  <= NOT clk after CLK_PERIOD / 2;

    sn74ls161_0: entity work.sn74ls161
    port map
    (
        clk     => clk,
        enp     => enp,
        ent     => ent,
        load_n  => load_n,
        clear_n => clear_n,
        i       => i,
        rco     => rco,
        q       => q
    );

    process
    begin
        wait for 20 ns;
        enp <= '1';
        ent <= '1';
        i   <= "0010";
        clear_n <= '0';
        load_n <= '1';

        wait for 10 ns;
        clear_n <= '1';

        wait for 30 ns;
        load_n <= '0';

        wait for 30 ns;
        load_n <= '1';

        wait for 30 ns;
        ent <= '0';

        wait for 30 ns;
        ent <= '1';

        wait for 30 ns;
        enp <= '0';

        wait for 30 ns;
        enp <= '1';

        wait for 250 ns;
        std.env.stop;    --End the simulation.
    end process;
end behavioral;
