-------------------------------------------------------------------------
-- Owen Jewell
-- CprE 381
-- Iowa State University
-------------------------------------------------------------------------


-- mux3t1_32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural implementation of the ALU
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux4t1_32 is
  port(i_S          : in std_logic_vector(1 downto 0);
       i_D0         : in std_logic_vector(31 downto 0);
       i_D1         : in std_logic_vector(31 downto 0);
       i_D2         : in std_logic_vector(31 downto 0);
       i_D3         : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));

end mux4t1_32;

architecture structural of mux4t1_32 is

component mux2t1_N is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(31 downto 0);
       i_D1         : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
end component;

signal s_muxOut1, s_muxOut2 : std_logic_vector(31 downto 0);

begin

  MUX1: mux2t1_N
  port map(
            i_D0  => i_D0,
      	    i_D1  => i_D1,
      	    i_S	  => i_S(0),
      	    o_O   => s_muxOut1);

  MUX2: mux2t1_N
  port map(
            i_D0  => i_D2,
      	    i_D1  => i_D3,
      	    i_S	  => i_S(0),
      	    o_O   => s_muxOut2);


  MUX3: mux2t1_N
  port map(
            i_D0  => s_muxOut1,
      	    i_D1  => s_muxOut2,
      	    i_S	  => i_S(1),
      	    o_O   => o_O);


end structural;
