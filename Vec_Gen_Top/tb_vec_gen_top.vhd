--Test bench for Asteroids vector generator top level module.
--Written by Nick Mikstas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_vec_gen_top is
end tb_vec_gen_top;

architecture behavioral of tb_vec_gen_top is

    constant CLK6MHZ_PERIOD  : time := 166.667 ns; --6MHz system clock.

    signal vgck     : std_logic := '1';
    signal phi2     : std_logic := '1';
    signal clk6mhz  : std_logic := '1';
    signal clk3mhz  : std_logic := '1';
    signal reset_n  : std_logic := '0';
    signal dmago_n  : std_logic := '1';
    signal dmacnt_n : std_logic := '1';
    signal vmem_n   : std_logic := '1';
    signal r_wb     : std_logic := '1';
    signal ab       : std_logic_vector(12 downto 0) := '0' & x"000";
    signal db       : std_logic_vector(7 downto 0)  := "ZZZZZZZZ";
    signal halt     : std_logic;
    signal bvld     : std_logic;
    signal blank_n  : std_logic;
    signal vgck_s_n : std_logic;
    signal dacx_s   : std_logic_vector(10 downto 1);
    signal dacy_s   : std_logic_vector(10 downto 1);
    
begin

    --Create the clocks.
    clk6mhz <= NOT clk6mhz after CLK6MHZ_PERIOD / 2;

    process(all)
    begin
        if rising_edge(clk6mhz) then
            clk3mhz <= not clk3mhz;
        end if;

        if rising_edge(clk3mhz) then
            vgck <= not vgck;
            phi2 <= not phi2;
        end if;
    end process;

    --Instantiate the vector generator!
    vec_gen_top_0 : entity work.vec_gen_top
    port map
    ( 
       vgck     => vgck,
       phi2     => phi2,
       clk6mhz  => clk6mhz,
       clk3mhz  => clk3mhz,
       reset_n  => reset_n,
       dmago_n  => dmago_n,
       dmacnt_n => dmacnt_n,
       vmem_n   => vmem_n,
       r_wb     => r_wb,
       ab       => ab,
       db       => db,
       halt     => halt,
       bvld     => bvld,
       blank_n  => blank_n,
       vgck_s_n => vgck_s_n,
       dacx_s   => dacx_s,
       dacy_s   => dacy_s
    );     

    process
    begin
        --Release the reset.
        wait for 3000 ns;
        wait until rising_edge(vgck);
        reset_n <= '1';
        wait for 2000 ns;

        --Write a CUR command to the vector RAM.
        --Set the X,Y position to 300,400.
        --Set the global scaling multiplier to 2.
        --Memory write: 0xA190112C.
        wait until rising_edge(vgck);
        r_wb   <= '0';
        vmem_n <= '0';
        db     <= x"90";
        ab     <= '0' & x"000";
        wait until rising_edge(vgck);
        db     <= x"A1";
        ab     <= '0' & x"001";
        wait until rising_edge(vgck);
        db     <= x"2C";
        ab     <= '0' & x"002";
        wait until rising_edge(vgck);
        db     <= x"11";
        ab     <= '0' & x"003";

        --Write a JSR command to the vector RAM.
        --Subroutine location is 0x54F0 in ROM.
        --Draws the letter "A".
        --Memory write: 0xCA78.
        wait until rising_edge(vgck);
        r_wb   <= '0';
        vmem_n <= '0';
        db     <= x"78";
        ab     <= '0' & x"004";
        wait until rising_edge(vgck);
        db     <= x"CA";
        ab     <= '0' & x"005";
        
        --Write a JUMP command to the vector RAM.
        --Jump to RAM address 0x4010.
        --Memory write: 0xE008.
        wait until rising_edge(vgck);
        db     <= x"08";
        ab     <= '0' & x"006";
        wait until rising_edge(vgck);
        db     <= x"E0";
        ab     <= '0' & x"007";

        --Write a JSR command to the vector RAM.
        --Subroutine location is 0x52C2 in ROM.
        --Draws the ship's thrust graphic.
        --Memory write: 0xC961.
        wait until rising_edge(vgck);
        db     <= x"61";
        ab     <= '0' & x"010";
        wait until rising_edge(vgck);
        db     <= x"C9";
        ab     <= '0' & x"011";

        --Write a HALT command to the vector RAM.
        --Memory write: 0xB000.
        wait until rising_edge(vgck);
        db     <= x"00";
        ab     <= '0' & x"012";
        wait until rising_edge(vgck);
        db     <= x"B0";
        ab     <= '0' & x"013";

        --Finish writing to RAM.
        wait until rising_edge(vgck);
        db     <= "ZZZZZZZZ";
        r_wb   <= '1';
        vmem_n <= '1';

        --Start the state machine.
        wait for 2000 ns;
        wait until rising_edge(vgck);
        dmago_n <= '0';
        wait until rising_edge(vgck);
        dmago_n <= '1';

        --Wait for the simulation to finish.
        wait until halt = '1';
        wait for 10000 ns;
        std.env.stop; 
    end process;

end behavioral;

