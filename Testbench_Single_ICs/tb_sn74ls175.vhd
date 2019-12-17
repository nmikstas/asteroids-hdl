--Test bench for the SN74LS175 quad flip-flop.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn74ls175 is
end tb_sn74ls175;

architecture behavioral of tb_sn74ls175 is

    constant CLK_PERIOD : time := 10 ns;

    signal clk   : std_logic := '0'; --Positive edge triggered.
    signal clr_n : std_logic := '0'; --Active low.      
    signal d     : std_logic_vector(3 downto 0) := "0000";       
    signal q     : std_logic_vector(3 downto 0);
    signal q_n   : std_logic_vector(3 downto 0);

begin

    clk <= NOT clk after CLK_PERIOD / 2;

    sn74ls175_0 : entity work.sn74ls175
    port map
    (
        clk   => clk,
        clr_n => clr_n,
        d     => d,
        q     => q,
        q_n   => q_n
    );

    process
    begin
        wait for 15 ns;
        d <= "1010";

        wait until clk = '0';
        clr_n <= '1';

        wait for 10 ns;
        d <= "1111";

        wait for 10 ns;
        d <= "1001";

        wait for 10 ns;
        clr_n <= '0';

        wait for 15 ns;
        std.env.stop;
    end process;
end behavioral;
