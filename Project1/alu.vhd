-------------------------------------------------------------------------
-- Owen Jewell
-- CprE 381
-- Iowa State University
-------------------------------------------------------------------------


-- alu.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural implementation of the ALU
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity alu is
  port(i_A          : in std_logic_vector(31 downto 0);             -- First 32 bit data input
       i_B          : in std_logic_vector(31 downto 0);             -- Second 32 bit data input
       i_brrlShamt  : in std_logic_vector(4 downto 0);              -- Barrel shifter shift amount (0 to 31)
       i_AluCntrl   : in std_logic_vector(3 downto 0);  
       o_Zero       : out std_logic;                                -- Output used for to take either program counter + 4 or branch immediate
       o_C          : out std_logic;                                -- Carry output
       o_O          : out std_logic;                                -- Overflow output
       o_AluOut     : out std_logic_vector(31 downto 0));           -- ALU out

end alu;


----------------------------------------------------------------------
-- ALU control Truth table:
-- nAddSub    : in std_logic;                                 -- Add or subtract select (0 = add, 1 = subtract)
-- i_brrlDir    : in std_logic;                               -- Barrel shifter shift direction  (0 = left, 1 = right)
-- i_brrlTyp    : in std_logic;                               -- Barrel shifter shift type (0 = logical, 1 = arithmetic)
-- i_EqNeSel    : in std_logic;                               -- Equal or Not Equal Select ( If input 0 = bne | If input 1 = beq  )
                                                              -- If bne output 1 if not equal and 0 if equal
                                                              -- If beq output 1 if equal and 0 if not equal
--   |    ALU control
--   |  ______________________________
--   |     0  |   0  |   0   |   0   |  
--   |     0  |   0  |   0   |   1   |  or, ori
--   |     0  |   0  |   1   |   0   |  add, addi, addu, addiu, lw, sw, 
--   |     0  |   0  |   1   |   1   |  nor
--   |     0  |   1  |   0   |   0   |  xor, xori
--   |     0  |   1  |   0   |   1   |  sll 
--   |     0  |   1  |   1   |   0   |  sub, subu 
--   |     0  |   1  |   1   |   1   |  slt, slti, sltiu, sltu
--   |     1  |   0  |   0   |   0   |  sra
--   |     1  |   0  |   0   |   1   |  srl
--   |     1  |   0  |   1   |   0   |  beq
--   |     1  |   0  |   1   |   1   |  bne
--   |     1  |   1  |   0   |   0   | 
--   |     1  |   1  |   0   |   1   |  
--   |     1  |   1  |   1   |   0   |  and, andi
--   |     1  |   1  |   1   |   1   |  sll


architecture structural of alu is

component carryLookaheadAdder is
  port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       i_nAddSub    : in std_logic;
       o_C          : out std_logic;
       o_O          : out std_logic;
       o_S          : out std_logic_vector(31 downto 0));
end component;

component barrelShifter is
   port(i_Shft_Type_Sel    : in std_logic;                              
        i_Shft_Dir         : in std_logic;                              
        i_Shft_Amt         : in std_logic_vector(4 downto 0);           
        i_D                : in std_logic_vector(31 downto 0);          
        o_O                : out std_logic_vector(31 downto 0));       
end component;


component mux2t1 is
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic;
         i_D1                 : in std_logic;
         o_O                  : out std_logic);
end component;

component invg
    port(i_A          : in std_logic;
         o_F          : out std_logic);
  end component;

  component andg2
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

  component org2
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

  component xorg2
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

--Signals
signal s_BrrlOut : std_logic_vector(31 downto 0);
signal s_BrchOut : std_logic;


begin

b_branch_xor: for i in 0 to N-1 generate
  XORI: xor2 port map(
              i_A(i)    =>  i_A(i), 
              i_B(i)    =>  i_B(i), 
              o_F(i)    =>  s_BrchOut(i));
end generate G_NBit_ONES;

b_branch_xor: for i in 0 to N-1 generate
  XORI: xor2 port map(
              i_A(i)    =>  i_A(i), 
              i_B(i)    =>  i_B(i), 
              o_F(i)    =>  s_BrchOut(i));
end generate G_NBit_ONES;



b_barrelShifter : barrelShifter
  port map(i_Shft_Type_Sel    =>   i_AluCntrl(0),
           i_Shft_Dir         =>   i_AluCntrl(2),
 	   i_Shft_Amt         =>   i_brrlShamt,      
           i_D                =>   i_B,                  
           o_O                =>   s_BrrlOut); 


