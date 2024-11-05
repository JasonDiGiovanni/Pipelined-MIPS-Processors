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
       i_SignSel    : in std_logic;     -- SignSel control signal
       i_J          : in std_logic;     -- J control signal
       i_JR         : in std_logic;     -- JR control signal
       i_Branch     : in std_logic;     -- Branch control signal
       i_AluSrc     : in std_logic;     -- AluSrc control signal
       i_AluCtrl    : in std_logic;     -- AluCtrl control signal
       i_MemWr      : in std_logic;     -- MemWr control signal
       i_RegWr      : in std_logic;     -- RegWr control signal
       i_MemToReg   : in std_logic;     -- MemToReg control signal
       i_RegDst     : in std_logic;     -- RegDst control signal
       o_Branch     : out std_logic;     -- Branch control signal
       o_AluSrc     : out std_logic;     -- AluSrc control signal
       o_AluCtrl    : out std_logic;     -- AluCtrl control signal
       o_MemWr      : out std_logic;     -- MemWr control signal
       o_RegWr      : out std_logic;     -- RegWr control signal
       o_MemToReg   : out std_logic;     -- MemToReg control signal
       o_RegDst     : out std_logic;     -- RegDst control signal
       i_A          : in std_logic_vector(31 downto 0);     -- A input
       i_B          : in std_logic_vector(31 downto 0);     -- B input
       i_SignExt    : in std_logic_vector(31 downto 0);     -- Sign Extended input
       i_PC         : in std_logic_vector(31 downto 0);     -- PC input
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

  G_NBit_RegPC: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_PC(i),
	      o_Q       => o_PC(i));
  end generate G_NBit_RegPC;


  
end structure;