-------------------------------------------------------------------------
-- Owen Jewell
-- CprE 381
-- Iowa State University
-------------------------------------------------------------------------


-- forwardingUnit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural implementation of the 
-- forwarding unit
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity forwardingUnit is

  port(i_RegRdAddrMEMWB       : in std_logic;
       i_Rs                   : in std_logic_vector(4 downto 0);
       i_Rt                   : in std_logic_vector(4 downto 0);
       o_muxSrcSelA           : out std_logic;
       o_muxSrcSelB           : out std_logic);

end forwardingUnit;