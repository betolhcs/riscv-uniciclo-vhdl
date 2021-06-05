library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;	
	
entity bloco_ctrlgeral is 
	port(
	     opcode: in std_logic_vector(6 downto 0);
	     branch: out std_logic;
	     memRead: out std_logic;
	     memToReg: out std_logic;
	     ulaOP: out std_logic_vector(2 downto 0);
	     memWrite: out std_logic;
	     ulaSource: out std_logic;
	     regWrite: out std_logic;
	     isLUI: out std_logic;
	     isAUIPC: out std_logic;
	     isJALR: out std_logic;
	     isJALX: out std_logic
	);
end entity bloco_ctrlgeral;

architecture arc_ctrlgeral of bloco_ctrlgeral is  
  signal sig_opcode : std_logic_vector(6 downto 0);
  signal sig_branch : std_logic;
  signal sig_memRead : std_logic;
  signal sig_memToReg : std_logic;
  signal sig_ulaOP : std_logic_vector(2 downto 0);
  signal sig_memWrite : std_logic;
  signal sig_ulaSource : std_logic;
  signal sig_regWrite : std_logic;
  signal sig_isLUI: std_logic;
  signal sig_isAUIPC: std_logic;
  signal sig_isJALX: std_logic;
  signal sig_isJALR: std_logic;

begin
   --opcode <= sig_opcode;
  sig_opcode <= opcode;
  branch <= sig_branch;
  memRead <= sig_memRead;
  memToReg <= sig_memToReg;
  ulaOP <= sig_ulaOP;
  memWrite <= sig_memWrite;
  ulaSource <= sig_ulaSource;
  regWrite <= sig_regWrite;
  isLUI <= sig_isLUI;
  isAUIPC <= sig_isAUIPC;
  isJALX <= sig_isJALX;
  isJALR <= sig_isJALR;

process (sig_opcode)
    begin
      case sig_opcode is
        when "0110011" => -- R
          sig_branch <= '0';
          sig_memRead <= '0';
          sig_memToReg <= '0';
          sig_ulaOP <= "010";
          sig_memWrite <= '0';
          sig_ulaSource <= '0';
          sig_regWrite <= '1';
          sig_isLUI <= '0';
	  sig_isAUIPC <= '0';
	  sig_isJALX <= '0';
	  sig_isJALR <= '0';
        when "0010011" => -- I
          sig_branch <= '0';
          sig_memRead <= '0';
          sig_memToReg <= '0';
          sig_ulaOP <= "011";
          sig_memWrite <= '0';
          sig_ulaSource <= '1';
          sig_regWrite <= '1';
          sig_isLUI <= '0';
	  sig_isAUIPC <= '0';
	  sig_isJALX <= '0';
	  sig_isJALR <= '0';
        when "0100011" => -- SW
          sig_branch <= '0';
          sig_memRead <= '0';
          sig_memToReg <= '0';
          sig_ulaOP <= "000";
          sig_memWrite <= '1';
          sig_ulaSource <= '1';
          sig_regWrite <= '0';
          sig_isLUI <= '0';
	  sig_isAUIPC <= '0';
	  sig_isJALX <= '0';
	  sig_isJALR <= '0';    
	when "0000011" => -- LW
          sig_branch <= '0';
          sig_memRead <= '1';
          sig_memToReg <= '1';
          sig_ulaOP <= "000";
          sig_memWrite <= '0';
          sig_ulaSource <= '1';
          sig_regWrite <= '1';
          sig_isLUI <= '0';
	  sig_isAUIPC <= '0';
	  sig_isJALX <= '0';
	  sig_isJALR <= '0';
        when "1100011" => -- SB
          sig_branch <= '1';
          sig_memRead <= '0';
          sig_memToReg <= '0';
          sig_ulaOP <= "001";
          sig_memWrite <= '0';
          sig_ulaSource <= '0';
          sig_regWrite <= '0';
          sig_isLUI <= '0';
	  sig_isAUIPC <= '0';
	  sig_isJALX <= '0';
	  sig_isJALR <= '0';
        when "0110111" => -- LUI
          sig_branch <= '0';
          sig_memRead <= '0';
          sig_memToReg <= '0';
          sig_ulaOP <= "000";
          sig_memWrite <= '0';
          sig_ulaSource <= '1';
          sig_regWrite <= '1';
          sig_isLUI <= '1';
	  sig_isAUIPC <= '0';
	  sig_isJALX <= '0';
	  sig_isJALR <= '0';
        when "0010111" => -- AUIPC
          sig_branch <= '0';
          sig_memRead <= '0';
          sig_memToReg <= '0';
          sig_ulaOP <= "000";
          sig_memWrite <= '0';
          sig_ulaSource <= '1';
          sig_regWrite <= '1';
          sig_isLUI <= '0';
	  sig_isAUIPC <= '1';
	  sig_isJALX <= '0';
	  sig_isJALR <= '0';
        when "1101111" => -- JAL
          sig_branch <= '1';
          sig_memRead <= '0';
          sig_memToReg <= '0';
          sig_ulaOP <= "100"; 
          sig_memWrite <= '0';
          sig_ulaSource <= '0';
          sig_regWrite <= '1';
          sig_isLUI <= '0';
	  sig_isAUIPC <= '0';
	  sig_isJALX <= '1';
	  sig_isJALR <= '0';
        when "1100111" => -- JALR 
          sig_branch <= '1';
          sig_memRead <= '0';
          sig_memToReg <= '0';
          sig_ulaOP <= "110"; 
          sig_memWrite <= '0';
          sig_ulaSource <= '1';
          sig_regWrite <= '1';
          sig_isLUI <= '0';
	  sig_isAUIPC <= '0';
	  sig_isJALX <= '1';
	  sig_isJALR <= '1';
        when others =>
          sig_branch <= '0';
          sig_memRead <= '0';
          sig_memToReg <= '0';
          sig_ulaOP <= "000";
          sig_memWrite <= '0';
          sig_ulaSource <= '0';
          sig_regWrite <= '0';
          sig_isLUI <= '0';
	  sig_isAUIPC <= '0';
	  sig_isJALX <= '0';
	  sig_isJALR <= '0'; 
        end case;
end process;
end arc_ctrlgeral;
