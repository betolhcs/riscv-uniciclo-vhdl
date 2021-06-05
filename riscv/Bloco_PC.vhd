library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity bloco_pc is
    port( 
         clock  : in  std_logic;
         pcin  : in  std_logic_vector(31 downto 0);
       	 pcout : out  std_logic_vector(31 downto 0) :=  "00000000000000000000000000000000"
         );
end bloco_pc;

architecture arc_pc of bloco_pc is
begin
  process (clock) is
  begin
      if rising_edge(clock) then
          pcout <= pcin;
      end if;
  end process;
end arc_pc;
