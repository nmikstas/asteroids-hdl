--Test bench for the SN74LS193 up/down counter.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn74ls193 is
end tb_sn74ls193;

architecture behavioral of tb_sn74ls193 is

    signal d      :std_logic_vector(3 downto 0) := "0000";
    signal down   :std_logic                    := '1';
    signal up     :std_logic                    := '1';
    signal clr    :std_logic                    := '0';
    signal load_n :std_logic                    := '1';
    signal q      :std_logic_vector(3 downto 0);
    signal bo_n   :std_logic;
    signal co_n   :std_logic;
    
begin

    sn74ls193_0 : entity work.sn74ls193
    port map 
    ( 
        down   => down,
        up     => up,
        clr    => clr,
        load_n => load_n,
        d      => d,
        bo_n   => bo_n,
        co_n   => co_n,
        q      => q
    ); 

    process
    begin
        wait for 15 ns;
        d <= "1011";

        wait for 10 ns;
        load_n <= '0';

        wait for 10 ns;
        load_n <= '1';

        for i in 0 to 20 loop
            wait for 15 ns;
            down <= '0';

            wait for 15 ns;
            down <= '1';
        end loop;

        wait for 50 ns;
        clr <= '1';

        wait for 10 ns;
        clr <= '0';

        wait for 50 ns;

        for i in 0 to 20 loop
            wait for 15 ns;
            up <= '0';

            wait for 15 ns;
            up <= '1';
        end loop;

        wait for 50 ns;
        std.env.stop;
    end process; 
end behavioral;