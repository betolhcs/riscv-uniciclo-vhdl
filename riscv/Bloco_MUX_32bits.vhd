library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity bloco_mux32 is
    port (
           selec : in  std_logic;
           A     : in  std_logic_vector(31 downto 0);
           B     : in  std_logic_vector(31 downto 0);
           Z     : out std_logic_vector(31 downto 0)
          );
end bloco_mux32;

architecture arc_mux32 of bloco_mux32 is
  begin
    Z <= A when (selec = '0') else B;
end arc_mux32;
