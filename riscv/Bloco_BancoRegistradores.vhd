library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bloco_breg is
  port(
    writeData     : in  std_logic_vector(31 downto 0);
    writeEnable   : in  std_logic;
    select1       : in  std_logic_vector(4 downto 0);
    select2       : in  std_logic_vector(4 downto 0);
    selectWrite   : in  std_logic_vector(4 downto 0);
    clock         : in  std_logic;
    register1     : out std_logic_vector(31 downto 0);
    register2     : out std_logic_vector(31 downto 0)
    );
end entity bloco_breg;


architecture arc_breg of bloco_breg is
  type registerArray is array(0 to 31) of std_logic_vector(31 downto 0);
  signal banco_reg : registerArray := (others => "00000000000000000000000000000000");

begin
  register1 <= banco_reg(to_integer(unsigned(select1)));
  register2 <= banco_reg(to_integer(unsigned(select2)));
  write:process (clock) is
  begin
    if rising_edge(clock) then
      if writeEnable = '1' and selectWrite /= "00000" then -- Não pode escrever no zero
        banco_reg(to_integer(unsigned(selectWrite))) <= writeData;
        -- if select1 = selectWrite then  -- Bypass 
        --   register1 <= writeData;
        -- end if;
        -- if select2 = selectWrite then  -- Bypass
        --   register2 <= writeData; 
        -- end if;
      end if;
    end if;
  end process;
end arc_breg;
