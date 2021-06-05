library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity bloco_mux5 is
    port (
           selec : in  std_logic;
           A     : in  std_logic_vector(4 downto 0);
           B     : in  std_logic_vector(4 downto 0);
           Z     : out std_logic_vector(4 downto 0)
          );
end bloco_mux5;

architecture arc_mux5 of bloco_mux5 is
  begin
    Z <= A when (selec = '0') else B;
end arc_mux5;


