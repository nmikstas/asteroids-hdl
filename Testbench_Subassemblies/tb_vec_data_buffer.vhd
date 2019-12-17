--Test bench for the data buffer for Atari's Asteroids vector generator.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_vec_data_buffer is
end tb_vec_data_buffer;

architecture behavioral of tb_vec_data_buffer is

    signal buffen_n : std_logic := '1';
    signal r_wb     : std_logic := '0';
    signal db       : std_logic_vector(7 downto 0) := "00000000";
    signal ddma     : std_logic_vector(7 downto 0) := "ZZZZZZZZ";

begin

    vec_gen_data_buffer1: entity work.vec_data_buffer
    port map
    ( 
        buffen_n => buffen_n,
        r_wb     => r_wb,
        db       => db,
        ddma     => ddma
    );

    process
    begin
        wait for 100 ns;

        r_wb <= '1';
        buffen_n <= '0';
        ddma <= "11110000";

        wait for 100 ns;

        db <= "10101010";
        ddma <= "ZZZZZZZZ";

        wait for 100 ns;

        r_wb <= '0';

        wait for 100 ns;

        std.env.stop; --End the simulation.
    end process;

end behavioral;