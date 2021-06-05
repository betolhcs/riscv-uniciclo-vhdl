library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;	
	
entity bloco_ctrlula is 
	port(
	     ulaOP: in std_logic_vector(2 downto 0);
	     func3: in std_logic_vector(2 downto 0);
	     bitfunc7: in std_logic;
	     ulaCode: out std_logic_vector(3 downto 0)
	     );
end entity bloco_ctrlula;

architecture arc_ctrlula of bloco_ctrlula is

  signal sig_ulaOP : std_logic_vector(2 downto 0);
  signal sig_func3 : std_logic_vector(2 downto 0);
  signal sig_bitfunc7 : std_logic;
  signal sig_ulaCode : std_logic_vector(3 downto 0);
  
begin
  
  sig_ulaOP <= ulaOP;
  sig_func3 <= func3;
  sig_bitfunc7 <= bitfunc7;
  ulaCode <= sig_ulaCode;
  
  process (sig_ulaOP, sig_func3, sig_bitfunc7)
    begin
      case sig_ulaOP is  
        when "000" =>
          sig_ulaCode <= "0000"; -- ADD (SW, LW, LUI, AUIPC)            
        when "001" =>
          if sig_func3 = "000" then
            sig_ulaCode <= "1101"; -- SNE (BEQ)
          end if;
          if sig_func3 = "001" then
            sig_ulaCode <= "1100"; -- SEQ (BNE)
          end if;
          if sig_func3 = "100" then
            sig_ulaCode <= "1010"; -- SGE (BLT)
          end if;
          if sig_func3 = "101" then
            sig_ulaCode <= "1000"; -- SLT (BGE)
          end if;        
        when "010" =>
          if sig_func3 = "000" then
            if sig_bitfunc7 = '1' then 
              sig_ulaCode <= "0001"; -- SUB
            else
              sig_ulaCode <= "0000"; -- ADD
            end if;
          end if;
          if sig_func3 = "001" then
            sig_ulaCode <= "0101"; -- SLL
          end if;
          if sig_func3 = "010" then
            sig_ulaCode <= "1000"; -- SLT
          end if;
          if sig_func3 = "011" then
            sig_ulaCode <= "1001"; -- SLTU
          end if;
          if sig_func3 = "100" then
            sig_ulaCode <= "0100"; -- XOR
          end if;
          if sig_func3 = "101" then
            if sig_bitfunc7 = '1' then
              sig_ulaCode <= "0111"; -- SRA
            else
              sig_ulaCode <= "0110"; -- SRL
            end if;
          end if;
          if sig_func3 = "110" then
            sig_ulaCode <= "0011"; -- OR
          end if; 
          if sig_func3 = "111" then
            sig_ulaCode <= "0010"; -- AND
          end if;
	when "011" =>
          if sig_func3 = "000" then
            sig_ulaCode <= "0000"; -- ADDi
          end if;
          if sig_func3 = "010" then
            sig_ulaCode <= "1000"; -- SLTi
          end if;
          if sig_func3 = "011" then
            sig_ulaCode <= "1001"; -- SLTUi
          end if;
          if sig_func3 = "100" then
            sig_ulaCode <= "0100"; -- XORi
          end if;
          if sig_func3 = "001" then
            sig_ulaCode <= "0101"; -- SLLi
          end if;
          if sig_func3 = "101" then
            if sig_bitfunc7 = '1' then
              sig_ulaCode <= "0111"; -- SRAi
            else
              sig_ulaCode <= "0110"; -- SRLi
            end if;
          end if;
          if sig_func3 = "110" then
            sig_ulaCode <= "0011"; -- ORi
          end if;
          if sig_func3 = "111" then
            sig_ulaCode <= "0010"; -- ANDi
          end if;
        when "100" =>
          sig_ulaCode <= "1110"; -- JAL
        when "110" =>
          sig_ulaCode <= "1111"; -- JALR 
        when others =>
          sig_ulaCode <= "0000"; -- Erro ou não programado
    end case;
  end process;
end arc_ctrlula;