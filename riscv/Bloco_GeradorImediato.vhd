library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity bloco_gimediato is
	port(
     	     instruc : in std_logic_vector(31 downto 0);
	     imediato : out std_logic_vector(31 downto 0));
end entity bloco_gimediato;


architecture arc_gimediato of bloco_gimediato is
signal opcode : std_logic_vector(6 downto 0);
signal func3 : std_logic_vector(2 downto 0);
signal func7 : std_logic;
signal sig_instruc : std_logic_vector(31 downto 0);

begin
	opcode <= instruc(6 downto 0);
	func3 <= instruc(14 downto 12);
	sig_instruc <= instruc;
	process (opcode, sig_instruc)
    begin
	case opcode is
		when "0110011" => -- R
			imediato <= "00000000000000000000000000000000";
		when "0000011"|"0010011"|"1100111" => -- I T
			if func3 = "101" then -- SRAI e SRLI
			   imediato <= std_logic_vector(resize(signed(instruc(24 downto 20)), 32));
			 else
			    imediato <= std_logic_vector(resize(signed(instruc(31 downto 20)), 32));
			 end if;
		when "0100011" =>  -- S 
			 imediato <= std_logic_vector(resize(signed(instruc(31 downto 25) & instruc(11 downto 7)), 32));
		when "1100011" =>  -- B
			 imediato <= std_logic_vector(resize(signed(instruc(31) & instruc(7) & instruc(30 downto 25) & instruc(11 downto 8) & '0'), 32));
		when "0110111"|"0010111" =>  -- U 
			 imediato <= std_logic_vector(resize(signed(instruc(31 downto 12)),32) sll 12);
		when "1101111" =>  -- UJ
			 imediato <= std_logic_vector(resize(signed(instruc(31)& instruc(19 downto 12) & instruc(20) & instruc(30 downto 21) & '0'),32));
		when others =>
            		 imediato <= "00000000000000000000000000000000";
	end case;
end process;
end arc_gimediato;
