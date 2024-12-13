-------------------------------------------------------------------------
-- Owen Jewell
-- CprE 381
-- Iowa State University
-------------------------------------------------------------------------


-- equalityModule.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural implementation of the 
-- equality module for ALU
-------------------------------------------------------------------------



library IEEE;
use IEEE.std_logic_1164.all;

entity equalityModule is

  port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       i_brch          : in std_logic;
       o_F          : out std_logic);

end equalityModule;

architecture dataflow of equalityModule is

signal s_F : std_logic;

begin
UNLABELED:
    s_F <= '1' when i_A = i_B else '0';
    o_F <= not s_F when i_brch = '1' else s_F;

  
end dataflow;
