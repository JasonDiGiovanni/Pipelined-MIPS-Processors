-------------------------------------------------------------------------
-- Owen Jewell
-- CprE 381
-- Iowa State University
-------------------------------------------------------------------------


-- hazardDetectionUnit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural implementation of the 
-- forwarding unit
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity hazardDetectionUnit is

  port(
       i_CLK               : in std_logic;
       i_RegRtAddrIDEX     : in std_logic_vector(4 downto 0);
       i_MemToRegIDEX      : in std_logic;  -- Should be mem read but we are reusing MemToReg because only lw reads from mem
       i_RegRsAddrIFID     : in std_logic_vector(4 downto 0);
       i_RegRtAddrIFID     : in std_logic_vector(4 downto 0);
       o_Stall             : out std_logic;
       o_Flush             : out std_logic);

end hazardDetectionUnit;


architecture dataflow of hazardDetectionUnit is


begin

process_label : process( i_CLK ) --i_RegRtAddrIDEX, i_MemToRegIDEX, i_RegRsAddrIFID, i_RegRtAddrIFID

	begin

 if (rising_edge(i_CLK)) then
 
        if ((i_MemToRegIDEX = '1') and ((i_RegRtAddrIDEX = i_RegRsAddrIFID) or (i_RegRtAddrIDEX = i_RegRtAddrIFID)))
                then o_Flush <= '1';
        else
                o_Flush <= '0';
	end if;

else 
    o_Flush <= '0';

end if;

 if (falling_edge(i_CLK)) then

        if ((i_MemToRegIDEX = '1') and ((i_RegRtAddrIDEX = i_RegRsAddrIFID) or (i_RegRtAddrIDEX = i_RegRtAddrIFID)))
                then o_Stall <= '1';
        else
               o_Stall <= '0';
	end if;

end if;

end process;









end dataflow;
