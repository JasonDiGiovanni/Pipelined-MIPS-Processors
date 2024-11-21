-------------------------------------------------------------------------
-- Owen Jewell
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- reg_IFID.vhd
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

entity reg_IFID is

  port(i_CLK        : in std_logic;     		    -- Clock input
       i_RST        : in std_logic;    			    -- Reset input
       i_WE         : in std_logic;                         -- Write enable input
       i_Flush      : in std_logic;  
       i_PC         : in std_logic_vector(31 downto 0);     -- PC value input
       i_Instr      : in std_logic_vector(31 downto 0);     -- Instruction value input
       o_PC         : out std_logic_vector(31 downto 0);    -- PC value output
       o_Instr      : out std_logic_vector(31 downto 0));   -- Instruction value output

end reg_IFID;

architecture structure of reg_IFID is


  component dffg
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic;     -- Data value input
         o_Q          : out std_logic);   -- Data value output
  end component;

  component mux2t1_N is
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic_vector(31 downto 0);
         i_D1                 : in std_logic_vector(31 downto 0);
         o_O                  : out std_logic_vector(31 downto 0));
  end component;



signal s_Instr, s_PC : std_logic_vector(31 downto 0);


begin

 
  g_NBITMUX_Instr: mux2t1_N port map (
		i_S => i_Flush,
		i_D0 => i_Instr,
		i_D1 => x"00000000",
		o_O => s_Instr);

  g_NBITMUX_PC: mux2t1_N port map (
		i_S => i_Flush,
		i_D0 => i_PC,
		i_D1 => x"00000000",
		o_O => s_PC);



  G_NBit_RegInstr: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_Instr(i),
	      o_Q       => o_Instr(i));
  end generate G_NBit_RegInstr;

  G_NBit_RegPC: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_PC(i),
	      o_Q       => o_PC(i));
  end generate G_NBit_RegPC;


  
end structure;
