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

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_Branch     : in std_logic;     -- Branch control signal
       i_MemToReg   : in std_logic;     -- MemToReg control signal
       i_RegWr      : in std_logic;     -- RegWr control signal
       o_MemToReg   : out std_logic;     -- MemToReg control signal
       o_RegWr      : out std_logic;     -- RegWr control signal
       i_MemData    : in std_logic_vector(31 downto 0);     -- Data mem ouput
       i_AluOut     : in std_logic_vector(31 downto 0);     -- Alu output
       i_PC         : in std_logic_vector(31 downto 0);     -- PC input
       o_MemData    : out std_logic_vector(31 downto 0);    -- Data mem output
       o_AluOut     : out std_logic_vector(31 downto 0);     -- Alu output
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


  G_NBit_Reg: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => i_D(i),
	      o_Q       => o_Q(i));
  end generate G_NBit_Reg;


  
end structure;