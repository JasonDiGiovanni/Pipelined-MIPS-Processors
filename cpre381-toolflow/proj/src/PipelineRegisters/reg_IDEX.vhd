-------------------------------------------------------------------------
-- Owen Jewell
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- reg_IDEX.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a N-bit register
-- for the IF/ID pipeline register
--
--
-- NOTES:
-- Created 11/05/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity reg_IDEX is

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_J          : in std_logic;     -- J control signal
       i_JR         : in std_logic;     -- JR control signal
       i_Branch     : in std_logic;     -- Branch control signal
       i_AluSrc     : in std_logic;     -- AluSrc control signal
       i_AluCtrl    : in std_logic;     -- AluCtrl control signal
       i_MemWr      : in std_logic;     -- MemWr control signal
       i_RegWr      : in std_logic;     -- RegWr control signal
       i_MemToReg   : in std_logic;     -- MemToReg control signal
       i_RegDst     : in std_logic;     -- RegDst control signal
       o_J          : out std_logic;     -- J control signal
       o_JR         : out std_logic;     -- JR control signal
       o_Branch     : out std_logic;     -- Branch control signal
       o_AluSrc     : out std_logic;     -- AluSrc control signal
       o_AluCtrl    : out std_logic;     -- AluCtrl control signal
       o_MemWr      : out std_logic;     -- MemWr control signal
       o_RegWr      : out std_logic;     -- RegWr control signal
       o_MemToReg   : out std_logic;     -- MemToReg control signal
       o_RegDst     : out std_logic;     -- RegDst control signal
       i_RegWrAddr  : in std_logic_vector(4 downto 0);     -- RegWrAddr
       o_RegWrAddr  : in std_logic_vector(4 downto 0);     -- RegWrAddr
       i_luiCtrl    : in std_logic;     -- RegWr control signal
       i_Imm        : in std_logic_vector(15 downto 0);;     -- RegWr control signal
       o_luiCtrl    : in std_logic;     -- RegWr control signal
       o_Imm        : in std_logic_vector(15 downto 0);
       i_A          : in std_logic_vector(31 downto 0);     -- A input
       i_B          : in std_logic_vector(31 downto 0);     -- B input
       i_SignExt    : in std_logic_vector(31 downto 0);     -- Sign Extended input
       i_PC         : in std_logic_vector(31 downto 0);     -- PC input
       i_Instr      : in std_logic_vector(31 downto 0);     -- Instr
       o_Instr      : out std_logic_vector(31 downto 0);    -- Instr
       o_A          : out std_logic_vector(31 downto 0);    -- A output
       o_B          : out std_logic_vector(31 downto 0);    -- B output
       o_SignExt    : out std_logic_vector(31 downto 0);     -- Sign Extended output
       o_PC         : out std_logic_vector(31 downto 0));   -- Pc output

end reg_IDEX;

architecture structure of reg_IDEX is


  component dffg
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic;     -- Data value input
         o_Q          : out std_logic);   -- Data value output
  end component;


begin


  G_NBit_RegA: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_A(i),
	      o_Q       => o_A(i));
  end generate G_NBit_RegA;

  G_NBit_RegB: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_B(i),
	      o_Q       => o_B(i));
  end generate G_NBit_RegB;

  G_NBit_RegInstr: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_Instr(i),
	      o_Q       => o_Instr(i));
  end generate G_NBit_RegInstr;

  G_NBit_RegSX: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_SignExt(i),
	      o_Q       => o_SignExt(i));
  end generate G_NBit_RegSX;

  G_NBit_RegPC: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_PC(i),
	      o_Q       => o_PC(i));
  end generate G_NBit_RegPC;

G_NBit_RegRegWr: for i in 0 to 4 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_RegWrAddr(i),
	      o_Q       => o_RegWrAddr(i));
  end generate G_NBit_RegRegWr;

G_NBit_RegIMM: for i in 0 to 15 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_Imm(i),
	      o_Q       => o_Imm(i));
  end generate G_NBit_RegIMM;

 isJump: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_isJump,
	      o_Q       => o_isJump);

 luiCtrl: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_luiCtrl,
	      o_Q       => o_luiCtrl);

 J: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_J,
	      o_Q       => o_J);

 JR: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_JR,
	      o_Q       => o_JR);

 Branch: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_Branch,
	      o_Q       => o_Branch);

 AluSrc: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_AluSrc,
	      o_Q       => o_AluSrc);

 AluCtrl: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_AluCtrl,
	      o_Q       => o_AluCtrl);

 MemWr: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_MemWr,
	      o_Q       => o_MemWr);

 RegWr: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_RegWr,
	      o_Q       => o_RegWr);

 MemToReg: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_MemToReg,
	      o_Q       => o_MemToReg);

 RegDst: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_RegDst,
	      o_Q       => o_RegDst);



  
end structure;
