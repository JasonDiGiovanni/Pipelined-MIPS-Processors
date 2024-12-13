

library IEEE;
use IEEE.std_logic_1164.all;

entity nxorg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end nxorg2;

architecture dataflow of nxorg2 is
begin

  o_F <= not (i_A xor i_B);
  
end dataflow;
