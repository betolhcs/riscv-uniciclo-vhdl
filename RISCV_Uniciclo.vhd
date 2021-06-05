-- Criado por Luís Humberto Chaves Senno
-- Processador RISC-V Uniciclo em VHDL
-- Em 22/05/2021
-- Universidade de Brasília, Matriculas 180053922 e 180023631

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;	

entity riscV is
  port(
      clock : in std_logic
  );
end entity riscV;

architecture arc_riscV of riscV is

component bloco_pc is
    port( 
         clock   : in  std_logic;
         pcin    : in  std_logic_vector(31 downto 0);
         pcout   : out  std_logic_vector(31 downto 0)
         );
end component;

component bloco_rom is 
	port(
	     address  : in std_logic_vector;
	     dataout  : out std_logic_vector
	     );
end component;

component bloco_ram is
 	port (
 	      clock       : in std_logic;
 	      writeEnable : in std_logic;
 	      address     : in std_logic_vector;
 	      datain      : in std_logic_vector;
 	      dataout     : out std_logic_vector
               );
end component;

component bloco_ctrlgeral is 
	port(
	     opcode    : in std_logic_vector(6 downto 0);
	     branch    : out std_logic;
	     memRead   : out std_logic;
	     memToReg  : out std_logic;
	     ulaOP     : out std_logic_vector(2 downto 0);
	     memWrite  : out std_logic;
	     ulaSource : out std_logic;
	     regWrite  : out std_logic;
	     isLUI     : out std_logic;
	     isAUIPC   : out std_logic;
	     isJALX    : out std_logic;
	     isJALR    : out std_logic
	     );
end component;

component bloco_breg is
  port(
       writeData    : in  std_logic_vector(31 downto 0);
       writeEnable  : in  std_logic;
       select1      : in  std_logic_vector(4 downto 0);
       select2      : in  std_logic_vector(4 downto 0);
       selectWrite  : in  std_logic_vector(4 downto 0);
       clock        : in  std_logic;
       register1    : out std_logic_vector(31 downto 0);
       register2    : out std_logic_vector(31 downto 0)
       );
end component;

component bloco_gimediato is
  port(
       instruc : in std_logic_vector(31 downto 0);
       imediato : out std_logic_vector(31 downto 0)
       );
end component;

component bloco_ctrlula is
	port (
		ulaOP: in std_logic_vector(2 downto 0);
		func3: in std_logic_vector(2 downto 0);
		bitfunc7: in std_logic;
		ulaCode: out std_logic_vector(3 downto 0)
		);
end component;

component bloco_ula is
  port(
       opcode : in std_logic_vector(3 downto 0);
       A, B   : in std_logic_vector(31 downto 0);
       Z      : out std_logic_vector(31 downto 0);
       zero   : out std_logic
       );
end component;

component bloco_mux32 is
    port(
         selec : in  std_logic;
         A     : in  std_logic_vector(31 downto 0);
         B     : in  std_logic_vector(31 downto 0);
         Z     : out std_logic_vector(31 downto 0)
         );
end component;

component bloco_mux5 is
    port(
         selec : in  std_logic;
         A     : in  std_logic_vector(4 downto 0);
         B     : in  std_logic_vector(4 downto 0);
         Z     : out std_logic_vector(4 downto 0)
         );
end component;

component bloco_and is
    port(
         A   : in std_logic;
         B   : in std_logic;
         Z   : out std_logic
         );
end component;

component bloco_somador is
    port( 
	 A : in  std_logic_vector(31 downto 0);
         B : in  std_logic_vector(31 downto 0);
         Z : out  std_logic_vector(31 downto 0)
         );
end component;

signal fake_clock     : std_logic;
signal sig_pcin       : std_logic_vector(31 downto 0);
signal sig_pcout      : std_logic_vector(31 downto 0);
signal instruction    : std_logic_vector(31 downto 0);
signal sig_branch     : std_logic;
signal sig_memRead    : std_logic;
signal sig_memToReg   : std_logic;
signal sig_ulaOP      : std_logic_vector(2 downto 0);
signal sig_memWrite   : std_logic;
signal sig_ulaSource  : std_logic;
signal sig_regWrite   : std_logic;
signal sig_isLUI      : std_logic;
signal sig_isAUIPC    : std_logic;
signal sig_isJALX     : std_logic;
signal sig_isJALR     : std_logic;
signal sig_writeData  : std_logic_vector(31 downto 0);
signal sig_register1  : std_logic_vector(31 downto 0);
signal sig_register2  : std_logic_vector(31 downto 0);
signal sig_imediato   : std_logic_vector(31 downto 0);
signal sig_ulaCode    : std_logic_vector(3 downto 0);
signal sig_ulaB       : std_logic_vector(31 downto 0);
signal sig_ulaZ       : std_logic_vector(31 downto 0);
signal sig_ulaZero    : std_logic;


alias sig_addressRom  : std_logic_vector(9 downto 0) is sig_pcout(11 downto 2); --n�o s�o necess�rios todos os bits de endere�o
alias sig_addressRam  : std_logic_vector(9 downto 0) is sig_ulaZ(11 downto 2);
signal sig_dataOutRam : std_logic_vector(31 downto 0);
alias sig_opcode      : std_logic_vector(6 downto 0) is instruction(6 downto 0);
alias sig_select1     : std_logic_vector(4 downto 0) is instruction(19 downto 15);
alias sig_select2     : std_logic_vector(4 downto 0) is instruction(24 downto 20);
alias sig_selectWrite : std_logic_vector(4 downto 0) is instruction(11 downto 7);
alias sig_func3       : std_logic_vector(2 downto 0) is instruction(14 downto 12);
alias sig_bitfunc7    : std_logic is instruction(30);


signal sig_soma_pcimediato : std_logic_vector(31 downto 0);
signal sig_soma_pc4 : std_logic_vector(31 downto 0);
signal sig_and_branchzero : std_logic;
signal sig_mux_somasdepc : std_logic_vector(31 downto 0);
signal sig_mux_select1lui: std_logic_vector(4 downto 0);

--Mux RAM
signal sig_mux_ramulaz : std_logic_vector(31 downto 0);

--Mux AUIPC
signal sig_mux_auipc : std_logic_vector(31 downto 0);


begin

pc: bloco_pc port map(
                   clock   => fake_clock,
                   pcin  => sig_pcin,
                   pcout => sig_pcout
                  );

memoria_de_instrucoes: bloco_rom port map(
                                  address => sig_addressRom,
                                  dataout => instruction
                                );
                                
bloco_de_controle_geral : bloco_ctrlgeral port map(
                                            opcode => sig_opcode,
                                            branch => sig_branch,
                                            memRead => sig_memRead,
                                            memToReg => sig_memToReg,
                                            ulaOP => sig_ulaOP,
                                            memWrite => sig_memWrite,
                                            ulaSource => sig_ulaSource,
                                            regWrite => sig_regWrite,
                                            isLUI => sig_isLUI,
                                            isAUIPC => sig_isAUIPC,
                                            isJALX => sig_isJALX,
                                            isJALR => sig_isJALR
                                          );
                                          
breg: bloco_breg port map(
                                        writeData => sig_writeData,
                                        writeEnable => sig_regWrite,
                                        select1 => sig_mux_select1lui,
                                        select2 => sig_select2,
                                        selectWrite => sig_selectWrite,
                                        clock => fake_clock,
                                        register1 => sig_register1,
                                        register2 => sig_register2
                                      );
                                      
gerador_de_imediato: bloco_gimediato port map(
                                     instruc => instruction,
                                     imediato => sig_imediato
                                    );
                                    
controle_da_ula: bloco_ctrlula port map(
                                    ulaOP => sig_ulaOP,
		                    func3 => sig_func3,
		                    bitfunc7 => sig_bitfunc7,
		                    ulaCode => sig_ulaCode
                                  );
                                  
mux32_breg_imm: bloco_mux32 port map(
                                       selec => sig_ulaSource,
                                       A => sig_register2,
          	                       B => sig_imediato,
                                       Z => sig_ulaB
                                      );
                                      
ula: bloco_ula port map(
                     opcode => sig_ulaCode,
		     A => sig_register1,
		     B => sig_ulaB,
		     Z => sig_ulaZ,
		     zero => sig_ulaZero
                    );
                    
memoria_de_dados: bloco_ram port map(
                             	     clock => fake_clock,
 		                     writeEnable => sig_memWrite,
 		                     address => sig_addressRam,
 		                     datain => sig_register2,
 		                     dataout => sig_dataOutRam
                            );
                            
mux32_memdados_ula: bloco_mux32 port map(
                                       selec => sig_memToReg,
                                       A => sig_ulaZ,
          	                       B => sig_dataOutRam,
                                       Z => sig_mux_ramulaz
                                      );
                                      
somador_pc_imm: bloco_somador port map(
                                        A => sig_pcout,
                                        B => sig_imediato,
                                        Z => sig_soma_pcimediato
                                      );
                                      
somador_pc_4: bloco_somador port map(
                                        A => sig_pcout,
                                        B => "00000000000000000000000000000100",
                                        Z => sig_soma_pc4
                                      );
                                      
and_branch: bloco_and port map(
                              A => sig_branch,
                              B => sig_ulaZero,
                              Z => sig_and_branchzero
                             );
                             
mux32_pc4_pcimediato: bloco_mux32 port map(
                                       selec => sig_and_branchzero,
                                       A => sig_soma_pc4,
          	                       B => sig_soma_pcimediato,
                                       Z => sig_mux_somasdepc
                                      );
                                      
mux_lui: bloco_mux5 port map(
                            selec => sig_isLUI,
                            A => sig_select1,
 	                    B => "00000",
                            Z => sig_mux_select1lui
                           );
                           
mux_auipc: bloco_mux32 port map(
                              selec => sig_isAUIPC,
                              A => sig_mux_ramulaz,
          	              B => sig_soma_pcimediato,
                              Z => sig_mux_auipc
                             );
                             
mux_jalx: bloco_mux32 port map(
                              selec => sig_isJALX,
                              A => sig_mux_auipc,
          	              B => sig_soma_pc4,
                              Z => sig_writeData
                             );
                             
mux_jalr: bloco_mux32 port map(
                              selec => sig_isJALR,
                              A => sig_mux_somasdepc,
          	              B => sig_ulaZ,
                              Z => sig_pcin
                             );

process
  begin
    --fake_clock <= clock
    fake_clock <= '0'; --comentar daqui pra baixo para utilizar a entrada de clock
    wait for 1 ns;
    fake_clock <= '1';
    wait for 1 ns;
end process;  
end arc_riscV;