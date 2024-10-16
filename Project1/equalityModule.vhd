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
       o_F          : out std_logic);

end equalityModule;

architecture dataflow of xorg2 is

signal s_O          : in std_logic_vector(31 downto 0);

begin

 process (i_A, i_B) is
 variable count: unsigned (5 downto 0);
    begin
	count:="000000";  
	 for i in 0 to 31 loop
             s_O(i) <= i_A xor i_B;
         end loop;

	 for i in 0 to 31 loop 
             if(s_O(i)= '0') then                
                count := count + 1;              
             end if;            
         end loop;         
             
         if(count > 0) then                
               o_F <= '0';
         else
      	       o_F <= '1';
         end if;
   
    end process;
  
end dataflow;
