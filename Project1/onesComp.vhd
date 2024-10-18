-------------------------------------------------------------------------
-- Owen Jewell
-- CprE 381
-- Iowa State University
-------------------------------------------------------------------------


-- onesComp.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural implementation of a one's
--complementor
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity onesComp is

  port(i_I           : in std_logic;
       o_O           : out std_logic);

end onesComp;

architecture structure of onesComp is
-- Describe the component entities as defined in invg.vhd

component invg
    port(i_A          : in std_logic;
         o_F          : out std_logic);
  end component;

begin

g_Not: invg
    port MAP(i_A             => i_I,
             o_F             => o_O);

end structure;