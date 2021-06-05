library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity bloco_somador is
    port( 
	 A : in  std_logic_vector(31 downto 0);
         B : in  std_logic_vector(31 downto 0);
         Z : out  std_logic_vector(31 downto 0)
         );
end bloco_somador;

architecture arc_somador of bloco_somador is
begin

    Z <= std_logic_vector(signed(A) + signed(B));

end arc_somador;