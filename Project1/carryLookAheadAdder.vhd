-------------------------------------------------------------------------
-- Owen Jewell
-- CprE 381
-- Iowa State University
-------------------------------------------------------------------------


-- carryLookaheadAdder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural implementation of a N Bit
-- look ahead adder
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

--Look ahead logic resource: https://nandland.com/carry-lookahead-adder/

---------------------------------------------------------------------
--Over Flow Calculation:
-- take the xor of Cn-1 and Cout to get over flow.
--   |   Cn-1 | Cout | Overflow  |
--   |  ________________________ |
--   |     0  |   0  |   0       |
--   |     0  |   1  |   1       |
--   |     1  |   0  |   1       |
--   |     1  |   1  |   0       |
---------------------------------------------------------------------

entity carryLookaheadAdder is
  port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       i_nAddSub    : in std_logic;
       o_C          : out std_logic;
       o_O          : out std_logic;
       o_S          : out std_logic_vector(31 downto 0));

end carryLookaheadAdder;

architecture mixed of fullAddSub_N is

component fullAddSub_N is
  port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       i_AddSubCI   : in std_logic;
       o_CO         : out std_logic;
       o_S          : out std_logic_vector(31 downto 0));

end component;

component xorg2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

--Signals
singal w_G : std_logic_vector(31 downto 0);
singal w_P : std_logic_vector(31 downto 0);
singal w_C : std_logic_vector(31 downto 0);
signal w_SUM : std_logic_vector(31 downto 0);


begin


G_NBit_FULL: for i in 1 to N-1 generate
   FULLI: fullAddSub_N port map(
              i_A        =>  i_A(i),
              i_B        =>  i_B(i),
              i_AddSubCI =>  i_nAddSub,
              o_CO       =>  open,     
              o_S        =>  w_SUM(i));
  end generate G_NBit_FULL;

  -- Create the Generate (G) Terms:  Gi=Ai*Bi
  -- Create the Propagate Terms: Pi=Ai+Bi
  -- Create the Carry Terms:  
  GEN_CLA : for j in 0 to g_WIDTH-1 generate
    w_G(j)   <= i_add1(j) and i_add2(j);
    w_P(j)   <= i_add1(j) or i_add2(j);
    w_C(j+1) <= w_G(j) or (w_P(j) and w_C(j));
  end generate GEN_CLA;


g_Xor: xorg2
    port MAP(i_A             => w_C(30),
             i_B             => w_C(31),
             o_F             => o_O);


end mixed;