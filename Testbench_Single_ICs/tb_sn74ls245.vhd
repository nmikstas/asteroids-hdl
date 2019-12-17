--Test bench for the SN74LS245 octal bus transceiver.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn74ls245 is
end tb_sn74ls245;

architecture behavioral of tb_sn74ls245 is

    signal dir  : std_logic                    := '0';
    signal oe_n : std_logic                    := '0';
    signal a    : std_logic_vector(7 downto 0) := "ZZZZZZZZ";
    signal b    : std_logic_vector(7 downto 0) := "ZZZZZZZZ";

begin

    sn74ls2451: entity work.sn74ls245
    port map
    (
        dir  => dir,
        oe_n => oe_n,
        a    => a,
        b    => b
    );

    process
    begin
        wait for 15 ns;       
        b <= "10101010";

        wait for 15 ns; 
        dir <= '1';     
        a <= "01010101";
        b <= "ZZZZZZZZ";

        wait for 15 ns;
        b <= "11101010";

        wait for 15 ns;
        dir <= '0';
        
        wait for 15 ns;
        a <= "ZZZZZZZZ";

        wait for 15 ns;
        oe_n <= '1';
        a <= "01010101";

        wait for 15 ns;
        std.env.stop;    --End the simulation.
    end process;

end behavioral;
