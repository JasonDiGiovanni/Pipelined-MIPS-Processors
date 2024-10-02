-------------------------------------------------------------------------
-- HCorey Heithoff
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- onesComp_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide One's
-- Complementor using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- Created 9/4/24.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity onesComp_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A         : in std_logic_vector(N-1 downto 0);
       o_F         : out std_logic_vector(N-1 downto 0));

end onesComp_N;

architecture structural of onesComp_N is

  -- NOT gate
  component invg is
    port(i_A          : in std_logic;
         o_F          : out std_logic);
  end component;

begin

  -- Instantiate N mux instances.
  G_NBit_OnesComp: for i in 0 to N-1 generate
    INVGI: invg port map(
              i_A     => i_A(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              o_F      => o_F(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_OnesComp;
  
end structural;
