--Test bench for the memory address selector for Atari's Asteroids vector generator.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_vec_mem_select is
end tb_vec_mem_select;

architecture behavioral of tb_vec_mem_select is

    constant PHI2_PERIOD : time := 666.667 ns; --1.5MHz MCU clock.

    signal adma     : std_logic_vector(12 downto 0) := '0' & x"000";
    signal ab       : std_logic_vector(12 downto 0) := '0' & x"000";
    signal phi2     : std_logic := '0';
    signal r_wb     : std_logic := '0';
    signal vmem_n   : std_logic := '0';
    signal am       : std_logic_vector(12 downto 0);
    signal buffen_n : std_logic;
    signal vw_n     : std_logic;
    signal vrom2_n  : std_logic;
    signal vram_n   : std_logic;

begin

    phi2 <= NOT phi2 after PHI2_PERIOD / 2;

    vec_mem_select_0 : entity work.vec_mem_select
    port map
    ( 
        adma     => adma,
        ab       => ab,
        phi2     => phi2,
        r_wb     => r_wb,
        vmem_n   => vmem_n,
        am       => am,
        buffen_n => buffen_n,
        vw_n     => vw_n,
        vrom2_n  => vrom2_n,
        vram_n   => vram_n
    );  

    process
    begin
        wait for 10000 ns;
        adma <= "1100110011001";
        ab   <= "1001001001000";

        wait for 10000 ns;
        wait until rising_edge(phi2);
        vmem_n <= '1';

        wait for 10000 ns;
        adma <= "0101010101010";

        wait for 30000 ns;
        std.env.stop; --End the simulation.
    end process;

end behavioral;

