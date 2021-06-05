library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;	

entity bloco_and is
    port(
         A : in std_logic;
         B : in std_logic;
         Z : out std_logic
         );
end bloco_and;

architecture arc_and of bloco_and is
begin
    Z <= A AND B;
end arc_and; 
