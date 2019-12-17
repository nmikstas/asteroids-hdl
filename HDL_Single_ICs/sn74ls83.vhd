--This module is a recreation of an SN74LS83 4-bit fast adder.
--Written by Nick Mikstas

----------------------------------------------------------------------------------------------------
--                                     --Fast Adder Entity--                                      --
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn74ls83 is
    port 
    ( 
        c0 : in  std_logic; --Carry in.
        a  : in  std_logic_vector(4 downto 1);
        b  : in  std_logic_vector(4 downto 1);
        c4 : out std_logic; --Carry out.
        s  : out std_logic_vector(4 downto 1)
    );     
end sn74ls83;

----------------------------------------------------------------------------------------------------
--                                  --Fast Adder Architecture--                                   --
----------------------------------------------------------------------------------------------------

architecture structural of sn74ls83 is

    --First layer of input signals;
    signal notc0 : std_logic := '0';
    signal nor1  : std_logic := '0';
    signal nand1 : std_logic := '0';
    signal nor2  : std_logic := '0';
    signal nand2 : std_logic := '0';
    signal nor3  : std_logic := '0';
    signal nand3 : std_logic := '0';
    signal nor4  : std_logic := '0';
    signal nand4 : std_logic := '0';

    --Sum, bit 1 signals.
    signal s1_0 : std_logic := '0';
    signal s1_1 : std_logic := '0';

    --Sum, bit 2 signals.
    signal s2_0 : std_logic := '0';
    signal s2_1 : std_logic := '0';
    signal s2_2 : std_logic := '0';
    signal s2_3 : std_logic := '0';

    --Sum, bit 3 signals.
    signal s3_0 : std_logic := '0';
    signal s3_1 : std_logic := '0';
    signal s3_2 : std_logic := '0';
    signal s3_3 : std_logic := '0';
    signal s3_4 : std_logic := '0';

    --Sum, bit 4 signals.
    signal s4_0 : std_logic := '0';
    signal s4_1 : std_logic := '0';
    signal s4_2 : std_logic := '0';
    signal s4_3 : std_logic := '0';
    signal s4_4 : std_logic := '0';
    signal s4_5 : std_logic := '0';

    --Carry 4 signals.
    signal c4_0 : std_logic := '0';
    signal c4_1 : std_logic := '0';
    signal c4_2 : std_logic := '0';
    signal c4_3 : std_logic := '0';
    signal c4_4 : std_logic := '0';

begin

    --Assign first layer of input signals.
    notc0 <= not c0;
    nor1  <= a(1) nor  b(1);
    nand1 <= a(1) nand b(1);
    nor2  <= a(2) nor  b(2);
    nand2 <= a(2) nand b(2);
    nor3  <= a(3) nor  b(3);
    nand3 <= a(3) nand b(3);
    nor4  <= a(4) nor  b(4);
    nand4 <= a(4) nand b(4);

    --Assign sum, bit 1 signals.
    s1_0 <= nand1 and not nor1;
    s1_1 <= not notc0;
    s(1) <= s1_0 xor s1_1;

    --Assign sum, bit 2 signals.
    s2_0 <= nand2 and not nor2;
    s2_1 <= nor1;
    s2_2 <= nand1 and notc0;
    s2_3 <= not(s2_1 or s2_2);
    s(2) <= s2_0  xor s2_3;

    --Assign sum, bit 3 signals.
    s3_0 <= nand3 and not nor3;
    s3_1 <= nor2;
    s3_2 <= nor1  and nand2;
    s3_3 <= nand2 and nand1 and notc0;
    s3_4 <= not(s3_1 or s3_2 or s3_3);
    s(3) <= s3_0  xor s3_4;

    --Assign sum, bit 4 signals.
    s4_0 <= nand4 and not nor4;
    s4_1 <= nor3;
    s4_2 <= nor2  and nand3;
    s4_3 <= nor1  and nand3 and nand2;
    s4_4 <= nand3 and nand2 and nand1 and notc0;
    s4_5 <= not(s4_1 or s4_2 or s4_3 or s4_4);
    s(4) <= s4_0  xor s4_5;

    --Assign carry 4 signals.
    c4_0 <= nor4;
    c4_1 <= nand4 and nor3;
    c4_2 <= nand4 and nand3 and nor2;
    c4_3 <= nand4 and nand3 and nand2 and nor1;
    c4_4 <= nand4 and nand3 and nand2 and nand1 and notc0;
    c4   <= not(c4_0 or c4_1 or c4_2 or c4_3 or c4_4);

end structural;
