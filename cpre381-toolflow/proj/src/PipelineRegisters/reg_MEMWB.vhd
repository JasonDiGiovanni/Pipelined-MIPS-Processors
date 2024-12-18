-------------------------------------------------------------------------
-- Owen Jewell
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- reg_MEMWB.vhd
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

entity reg_MEMWB is

  port(i_CLK        : in std_logic;                         -- Clock input
       i_RST        : in std_logic;                         -- Reset input
       i_WE         : in std_logic;                         -- Write enable input
       i_Halt       : in std_logic;     		    -- Halt control signal
       i_Branch     : in std_logic;                         -- Branch control signal
       i_MemToReg   : in std_logic;                         -- MemToReg control signal
       i_RegWr      : in std_logic;                         -- RegWr control signal
       i_isJump     : in std_logic;                         -- isJump control signal
       i_luiCtrl    : in std_logic;                         -- lui control signal
       i_RegWrAddr  : in std_logic_vector(4 downto 0);      -- RegWrAddr
       i_Imm        : in std_logic_vector(15 downto 0);     -- RegWr control signal
       i_MemData    : in std_logic_vector(31 downto 0);     -- Data mem ouput
       i_AluOut     : in std_logic_vector(31 downto 0);     -- Alu output
       i_PC         : in std_logic_vector(31 downto 0);     -- PC input   
       o_Halt       : out std_logic;     		    -- Halt control signal          
       o_Branch     : out std_logic;                        -- Branch control signal
       o_MemToReg   : out std_logic;                        -- MemToReg control signal
       o_RegWr      : out std_logic;                        -- RegWr control signal
       o_isJump     : out std_logic;                         -- isJump control signal
       o_luiCtrl    : out std_logic;                         -- lui control signal
       o_RegWrAddr  : out std_logic_vector(4 downto 0);      -- RegWrAddr
       o_Imm        : out std_logic_vector(15 downto 0);     -- Imm value
       o_MemData    : out std_logic_vector(31 downto 0);    -- Data mem output
       o_AluOut     : out std_logic_vector(31 downto 0);    -- Alu output
       o_PC         : out std_logic_vector(31 downto 0));   -- Pc output 

end reg_MEMWB;

architecture structure of reg_MEMWB is


  component dffg
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic;     -- Data value input
         o_Q          : out std_logic);   -- Data value output
  end component;


begin

 Halt: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_Halt,
	      o_Q       => o_Halt);

 Branch: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_Branch,
	      o_Q       => o_Branch);

 MemToReg: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_MemToReg,
	      o_Q       => o_MemToReg);

 RegWr: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_RegWr,
	      o_Q       => o_RegWr);

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

G_NBit_RegRegWrAddr: for i in 0 to 4 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_RegWrAddr(i),
	      o_Q       => o_RegWrAddr(i));
  end generate G_NBit_RegRegWrAddr;

G_NBit_RegIMM: for i in 0 to 15 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_Imm(i),
	      o_Q       => o_Imm(i));
  end generate G_NBit_RegIMM;

  G_NBit_RegMemData: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_MemData(i),
	      o_Q       => o_MemData(i));
  end generate G_NBit_RegMemData;

  G_NBit_RegALU: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_AluOut(i),
	      o_Q       => o_AluOut(i));
  end generate G_NBit_RegALU;

  G_NBit_RegPC: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_PC(i),
	      o_Q       => o_PC(i));
  end generate G_NBit_RegPC;




  
end structure;
