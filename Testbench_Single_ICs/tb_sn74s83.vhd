--Test bench for the SN74LS83 4-bit fast adder.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sn74ls83 is
end tb_sn74ls83;

architecture behavioral of tb_sn74ls83 is

    signal c0 : std_logic := '0';
    signal a  : std_logic_vector(4 downto 1) := "0000";
    signal b  : std_logic_vector(4 downto 1) := "0000";
    signal c4 : std_logic;
    signal s  : std_logic_vector(4 downto 1);
    signal o  : std_logic_vector(4 downto 0);

begin

    sn74ls83_0 : entity work.sn74ls83
    port map
    ( 
        c0 => c0,
        a  => a,
        b  => b,
        c4 => c4,
        s  => s
    );  

    --Concantenate the results to make it easier to read in the simulator.
    o <= c4 & s;

    process
    begin
        wait for 15 ns;        
        b  <= "0000";
        a  <= "0000";
        c0 <= '1';
        
        wait for 15 ns;        
        b  <= "0000";
        a  <= "0001";
        c0 <= '0';
        
        wait for 15 ns;        
        b  <= "1111";
        a  <= "1111";
        c0 <= '1';
        
        wait for 15 ns;        
        b  <= "1010";
        a  <= "0101";
        c0 <= '1';

        wait for 15 ns;
        std.env.stop;    --End the simulation.
    end process;

end behavioral;

