--This module is the X and Y position counters for Atari's Asteroids vector generator.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                             --X and Y Position Counters Entity--                               --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vec_xy_counters is
    port 
    ( 
        vgck         : in std_logic;                      --1.5MHz MCU clock.
        clk6mhz      : in std_logic;                      --6MHz system clock.
        haltstrobe_n : in std_logic;
        timer0       : in std_logic;
        go_n         : in std_logic;
        go_s_n       : in std_logic;
        dvx          : in std_logic_vector(11 downto 0);  --X counter inputs.
        dvy          : in std_logic_vector(11 downto 0);  --Y counter inputs.
        
        bvld         : out std_logic;                     --Beam valid.
        dacx_s       : out std_logic_vector(10 downto 1); --10-bit X output to DAC.
        dacy_s       : out std_logic_vector(10 downto 1)  --10-bit Y output to DAC.
    );     
end vec_xy_counters;

----------------------------------------------------------------------------------------------------
--                           --X and Y Position Counters Architecture--                           --
----------------------------------------------------------------------------------------------------

architecture structural of vec_xy_counters is

    ----------X Counter Signals----------

    --J8 rate multiplier signals (X position counter).
    signal rate_mult_x1_b : std_logic_vector(5 downto 0) := "000000";
    signal rate_mult_x1_y : std_logic := '0';

    --J8/K8 rate multiplier common signals (X position counter).
    signal rate_mult_x_en : std_logic := '0';
    signal unity_cas_x    : std_logic := '0';

    --H10 inverter, pins 5 and 6 output.
    signal x1_y_n         : std_logic := '0';

    --E9, D9, C9 output bus.
    signal unmdacx        : std_logic_vector(12 downto 1) := "000000000000";

    --Inverted 12th bit, X counter.
    signal unmdacx12_n    : std_logic := '0';
    
    --Counter X1 and X2 ripple carry out.
    signal x1_rco         : std_logic := '0';
    signal x2_rco         : std_logic := '0';

    --Multiplexer 1, X counter, remap.
    signal mult_x1_a      : std_logic_vector(4 downto 1) := "0000";
    signal mult_x1_b      : std_logic_vector(4 downto 1) := "0000";
    signal mult_x1_y      : std_logic_vector(4 downto 1) := "0000";

    --Multiplexer 2, X counter, remap.
    signal mult_x2_a      : std_logic_vector(4 downto 1) := "0000";
    signal mult_x2_b      : std_logic_vector(4 downto 1) := "0000";
    signal mult_x2_y      : std_logic_vector(4 downto 1) := "0000";

    --Multiplexer 3, X counter, remap.
    signal mult_x3_a      : std_logic_vector(4 downto 1) := "0000";
    signal mult_x3_b      : std_logic_vector(4 downto 1) := "0000";
    signal mult_x3_y      : std_logic_vector(4 downto 1) := "0000";

    --Multiplexer outputs, X counter.
    signal dacx           : std_logic_vector(10 downto 1) := "0000000000";

    --X beam valid indicator.
    signal xvld            : std_logic := '0';

    ----------Y Counter Signals----------

    --H8 rate multiplier signals (Y position counter).
    signal rate_mult_y1_b : std_logic_vector(5 downto 0);
    signal rate_mult_y1_y : std_logic;

    --H8/F8 rate multiplier common signals (Y position counter).
    signal rate_mult_y_en : std_logic;
    signal unity_cas_y    : std_logic;

    --H10 inverter, pins 8 and 9 output.
    signal y1_y_n         : std_logic;

    --J9, H9, F9 output bus.
    signal unmdacy        : std_logic_vector(12 downto 1);

    --Inverted 12th bit, Y counter.
    signal unmdacy12_n    : std_logic;

    --Counter Y1 and Y2 ripple carry out.
    signal y1_rco         : std_logic;
    signal y2_rco         : std_logic;

    --Multiplexer 1, Y counter, remap.
    signal mult_y1_a      : std_logic_vector(4 downto 1);
    signal mult_y1_b      : std_logic_vector(4 downto 1);
    signal mult_y1_y      : std_logic_vector(4 downto 1);

    --Multiplexer 2, Y counter, remap.
    signal mult_y2_a      : std_logic_vector(4 downto 1);
    signal mult_y2_b      : std_logic_vector(4 downto 1);
    signal mult_y2_y      : std_logic_vector(4 downto 1);

    --Multiplexer 3, Y counter, remap.
    signal mult_y3_a      : std_logic_vector(4 downto 1);
    signal mult_y3_b      : std_logic_vector(4 downto 1);
    signal mult_y3_y      : std_logic_vector(4 downto 1);

    --Multiplexer outputs, Y counter.
    signal dacy           : std_logic_vector(10 downto 1);

    --Y beam valid indicator.
    signal yvld           : std_logic;

    ----------Shared Counter Signals----------

    --Load strobe, active low.
    signal ldstrobe_n     : std_logic;

    --Flip-flops inputs, shared, remap.
    signal ff_in          : std_logic_vector(6 downto 1);

    --Flip-flops outputs, shared, remap.
    signal ff_out         : std_logic_vector(6 downto 1);

    --Beam XY valid signals.
    signal xvld_s         : std_logic;
    signal yvld_s         : std_logic;

begin

    -------------------------------------[ X Counter Hardware ]-------------------------------------

    --Assign input ports to rate multiplier x1_b inputs.
    rate_mult_x1_b <= dvx(3 downto 0) & "00";

    ----------J8 Rate Multiplier----------
    rate_mult1 : entity work.sn7497
    port map
    (
        clk       => vgck,
        clr       => go_s_n,
        en_in     => rate_mult_x_en,
        strb      => rate_mult_x_en,
        unity_cas => unity_cas_x,
        b         => rate_mult_x1_b,
        en_out    => open,
        y         => rate_mult_x1_y,
        z         => open
    );

    ----------K8 Rate Multiplier----------
    rate_mult2 : entity work.sn7497
    port map
    (
        clk       => vgck,
        clr       => go_s_n,
        en_in     => go_s_n,
        strb      => go_s_n,
        unity_cas => '1', --Pullup resistor R27.
        b         => dvx(9 downto 4),
        en_out    => rate_mult_x_en,
        y         => open,
        z         => unity_cas_x
    );

    ----------H10 NOT gate, pins 5 and 6----------
    x1_y_n <= not rate_mult_x1_y;

    ----------E9 counter----------
    counter1 : entity work.sn74ls191
    port map
    ( 
        clk     => x1_y_n,
        cten    => go_n,
        load    => ldstrobe_n,
        d_u     => dvx(10),
        d       => dvx(3 downto 0),
        max_min => open,
        rco     => x1_rco,
        q       => unmdacx(4 downto 1)
    );     

    ----------D9 counter----------
    counter2 : entity work.sn74ls191
    port map
    ( 
        clk     => x1_y_n,
        cten    => x1_rco,
        load    => ldstrobe_n,
        d_u     => dvx(10),
        d       => dvx(7 downto 4),
        max_min => open,
        rco     => x2_rco,
        q       => unmdacx(8 downto 5)
    ); 

    ----------C9 counter----------
    counter3 : entity work.sn74ls191
    port map
    ( 
        clk     => x1_y_n,
        cten    => x2_rco,
        load    => ldstrobe_n,
        d_u     => dvx(10),
        d       => dvx(11 downto 8),
        max_min => open,
        rco     => open,
        q       => unmdacx(12 downto 9)
    ); 

    --Invert the MSB.
    unmdacx12_n <= not unmdacx(12);

    --Remap C10 multiplexer A input.
    mult_x1_a <= unmdacx(3) & unmdacx(1) & unmdacx(2) & unmdacx(4);
    
    --Remap C10 multiplexer B input.
    mult_x1_b <= unmdacx12_n & unmdacx12_n & unmdacx12_n & unmdacx12_n;
    
    --Remap C10 multiplexer Y output.
    dacx(4 downto 1) <= mult_x1_y(1) & mult_x1_y(4) & mult_x1_y(2) & mult_x1_y(3);
    
    ----------C10 multiplexer----------
    multiplexer1 : entity work.sn74ls157
    port map
    ( 
        a_b => unmdacx(11),
        g   => '0',
        a   => mult_x1_a,
        b   => mult_x1_b,
        y   => mult_x1_y
    );     

    --Remap D/E10 multiplexer A input.
    mult_x2_a <= unmdacx(7) & unmdacx(5) & unmdacx(6) & unmdacx(8);

    --Remap D/E10 multiplexer B input.
    mult_x2_b <= unmdacx12_n & unmdacx12_n & unmdacx12_n & unmdacx12_n;

    --Remap D/E10 multiplexer Y output.
    dacx(8 downto 5) <= mult_x2_y(1) & mult_x2_y(4) & mult_x2_y(2) & mult_x2_y(3);

    ----------D/E10 multiplexer----------
    multiplexer2 : entity work.sn74ls157
    port map
    ( 
        a_b => unmdacx(11),
        g   => '0',
        a   => mult_x2_a,
        b   => mult_x2_b,
        y   => mult_x2_y
    );

    --Remap E10 multiplexer A input.
    mult_x3_a <= unmdacx(9) & 'X' & unmdacx12_n & unmdacx(10);

    --Remap E10 multiplexer B input.
    mult_x3_b <= unmdacx12_n & 'X' & '0' & unmdacx12_n;

    --Remap E10 multiplexer Y output.
    dacx(10 downto 9) <= mult_x3_y(1) & mult_x3_y(4);
    xvld <= mult_x3_y(2);

    ----------E10 multiplexer----------
    multiplexer3 : entity work.sn74ls157
    port map
    ( 
        a_b => unmdacx(11),
        g   => '0',
        a   => mult_x3_a,
        b   => mult_x3_b,
        y   => mult_x3_y
    );

    ----------D10 flip-flops----------
    ff1 : entity work.sn74ls374
    port map
    ( 
        clk => clk6mhz,
        oc  => '0',     
        d   => dacx(8 downto 1),     
        q   => dacx_s(8 downto 1)
    );     

    -------------------------------------[ Y Counter Hardware ]-------------------------------------

    --Assign input ports to rate multiplier y1_b inputs.
    rate_mult_y1_b <= dvy(3 downto 0) & "00";

    ----------H8 Rate Multiplier----------
    rate_mult3 : entity work.sn7497
    port map
    (
        clk       => vgck,
        clr       => go_s_n,
        en_in     => rate_mult_y_en,
        strb      => rate_mult_y_en,
        unity_cas => unity_cas_y,
        b         => rate_mult_y1_b,
        en_out    => open,
        y         => rate_mult_y1_y,
        z         => open 
    );

    ----------F8 Rate Multiplier----------
    rate_mult4 : entity work.sn7497
    port map
    (
        clk       => vgck,
        clr       => go_s_n,
        en_in     => go_s_n,
        strb      => go_s_n,
        unity_cas => '1', --Pullup resistor R27.
        b         => dvy(9 downto 4),
        en_out    => rate_mult_y_en,
        y         => open,
        z         => unity_cas_y
    );

    ----------H10 NOT gate, pins 8 and 9----------
    y1_y_n <= not rate_mult_y1_y;

    ----------J9 counter----------
    counter4 : entity work.sn74ls191
    port map
    ( 
        clk     => y1_y_n,
        cten    => go_n,
        load    => ldstrobe_n,
        d_u     => dvy(10),
        d       => dvy(3 downto 0),
        max_min => open,
        rco     => y1_rco,
        q       => unmdacy(4 downto 1)
    );     

    ----------H9 counter----------
    counter5 : entity work.sn74ls191
    port map
    ( 
        clk     => y1_y_n,
        cten    => y1_rco,
        load    => ldstrobe_n,
        d_u     => dvy(10),
        d       => dvy(7 downto 4),
        max_min => open,
        rco     => y2_rco,
        q       => unmdacy(8 downto 5)
    ); 

    ----------F9 counter----------
    counter6 : entity work.sn74ls191
    port map
    ( 
        clk     => y1_y_n,
        cten    => y2_rco,
        load    => ldstrobe_n,
        d_u     => dvy(10),
        d       => dvy(11 downto 8),
        max_min => open,
        rco     => open,
        q       => unmdacy(12 downto 9)
    ); 

    --Invert the MSB.
    unmdacy12_n <= not unmdacy(12);

    --Remap A10 multiplexer A input.
    mult_y1_a <= unmdacy(3) & unmdacy(1) & unmdacy(2) & unmdacy(4);
    
    --Remap A10 multiplexer B input.
    mult_y1_b <= unmdacy12_n & unmdacy12_n & unmdacy12_n & unmdacy12_n;
    
    --Remap A10 multiplexer Y output.
    dacy(4 downto 1) <= mult_y1_y(1) & mult_y1_y(4) & mult_y1_y(2) & mult_y1_y(3);

    ----------A10 multiplexer----------
    multiplexer4 : entity work.sn74ls157
    port map
    ( 
        a_b => unmdacy(11),
        g   => '0',
        a   => mult_y1_a,
        b   => mult_y1_b,
        y   => mult_y1_y
    ); 

    --Remap B/C10 multiplexer A input.
    mult_y2_a <= unmdacy(7) & unmdacy(5) & unmdacy(6) & unmdacy(8);

    --Remap B/C10 multiplexer B input.
    mult_y2_b <= unmdacy12_n & unmdacy12_n & unmdacy12_n & unmdacy12_n;

    --Remap B/C10 multiplexer Y output.
    dacy(8 downto 5) <= mult_y2_y(1) & mult_y2_y(4) & mult_y2_y(2) & mult_y2_y(3);

    ----------B/C10 multiplexer----------
    multiplexer5 : entity work.sn74ls157
    port map
    ( 
        a_b => unmdacy(11),
        g   => '0',
        a   => mult_y2_a,
        b   => mult_y2_b,
        y   => mult_y2_y
    );

    --Remap F/H10 multiplexer A input.
    mult_y3_a <= unmdacy(10) & unmdacy(9) & 'X' & unmdacy12_n;

    --Remap F/H10 multiplexer B input.
    mult_y3_b <= unmdacy12_n & unmdacy12_n & 'X' & '0';

    --Remap F/H10 multiplexer Y output.
    dacy(10 downto 9) <= mult_y3_y(4) & mult_y3_y(3);
    yvld <= mult_y3_y(1);

    ----------F/H10 multiplexer----------
    multiplexer6 : entity work.sn74ls157
    port map
    ( 
        a_b => unmdacy(11),
        g   => '0',
        a   => mult_y3_a,
        b   => mult_y3_b,
        y   => mult_y3_y
    );

    ----------B10 flip-flops----------
    ff2 : entity work.sn74ls374
    port map
    ( 
        clk => clk6mhz,
        oc  => '0',     
        d   => dacy(8 downto 1),     
        q   => dacy_s(8 downto 1)
    ); 

    ----------------------------------[ Shared Counter Hardware ]-----------------------------------

    ----------B9 OR gate, pins 11, 12 and 13----------
    ldstrobe_n <= haltstrobe_n or timer0;

    --Remap F10 flip-flops input.
    ff_in <= dacx(10) & dacx(9) & xvld & dacy(9) & dacy(10) & yvld;

    --Remap F10 flip-flops output.
    dacx_s(10) <= ff_out(6);
    dacx_s(9)  <= ff_out(5);
    xvld_s     <= ff_out(4);
    dacy_s(9)  <= ff_out(3);
    dacy_s(10) <= ff_out(2);
    yvld_s     <= ff_out(1);

    ----------F10 flip-flops----------
    ff3 : entity work.sn74ls174
    port map
    ( 
        clk => clk6mhz,
        clr => '1', --Pullup resistor R27.
        d   => ff_in, 
        q   => ff_out
    );     

    ----------B8 AND gate, pins 8, 9 and 10----------
    bvld <= xvld_s and yvld_s;

end structural;