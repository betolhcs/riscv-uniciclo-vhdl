-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity bloco_ula is
	generic (WSIZE : natural := 32);
	port(
	     opcode : in std_logic_vector(3 downto 0);
	     A, B : in std_logic_vector(31 downto 0);
	     Z : out std_logic_vector(31 downto 0);
	     zero : out std_logic);
end bloco_ula;

architecture arc_ula of bloco_ula is
signal aux : std_logic_vector(31 downto 0);
begin
    Z <= aux;
    zero <= '1' when (aux = "00000000000000000000000000000000") else '0';
process (A, B, opcode)
	begin
    	case opcode is
     	when "0000" => --ADD
         	  aux <= std_logic_vector(signed(A) + signed(B));	
	when "0001" => --SUB
            	  aux <= std_logic_vector(signed(A) - signed(B));
	when "0010" => --AND
            	  aux <= std_logic_vector(A and B);
	when "0011" => --OR
            	  aux <= std_logic_vector(A or B);
	when "0100" => --XOR
            	  aux <= std_logic_vector(A xor B);
	when "0101" => --SLL
            	  aux <= std_logic_vector(unsigned(A) sll to_integer(unsigned(B)));
	when "0110" => --SRL
            	  aux <= std_logic_vector(unsigned(A) srl to_integer(unsigned(B)));
	when "0111" => --SRA
            	  aux <= std_logic_vector(signed(A) sra to_integer(unsigned(B)));
	when "1000" => --SLT
            	  if signed(A) < signed(B) then
            		aux <= "00000000000000000000000000000001";
		  else
                	aux <= "00000000000000000000000000000000";
		  end if;
	when "1001" => --SLTU
            	  if unsigned(A) < unsigned(B) then
            		aux <= "00000000000000000000000000000001";
		  else
                	aux <= "00000000000000000000000000000000";
		  end if;
	when "1010" => --SGE
            	  if signed(A) >= signed(B) then
            		aux <= "00000000000000000000000000000001";
		  else
                	aux <= "00000000000000000000000000000000";
		  end if;	
	when "1011" => --SGEU
            	  if unsigned(A) >= unsigned(B) then
            		aux <= "00000000000000000000000000000001";
		  else
                	aux <= "00000000000000000000000000000000";
		  end if;	
	when "1100" => --SEQ
            	  if signed(A) = signed(B) then
            		aux <= "00000000000000000000000000000001";
		  else
                	aux <= "00000000000000000000000000000000";
		  end if;
	when "1101" => --SNE
            	  if signed(A) /= signed(B) then
            		aux <= "00000000000000000000000000000001";
		  else
                	aux <= "00000000000000000000000000000000";
		  end if;	
	when "1110" => --JAL
			  aux <= "00000000000000000000000000000000";
	when "1111" => --JALR
			  aux <= A;  
	when others =>
            	  aux <= "00000000000000000000000000000000";
	end case;
end process;
end arc_ula;
