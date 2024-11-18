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
use IEEE.numeric_std.all;

entity forwardingUnit is

  port(
       i_RegRdAddrMEMWB    : in std_logic_vector(4 downto 0);
       i_RegWriteMEMWB     : in std_logic;
       i_RegRdAddrEXMEM    : in std_logic_vector(4 downto 0);
       i_RegWriteEXMEM     : in std_logic;
       i_RegRsAddrIDEX     : in std_logic_vector(4 downto 0);
       i_RegRtAddrIDEX     : in std_logic_vector(4 downto 0);
       i_selImmIDEX        : in std_logic;
       o_forwardA          : out std_logic_vector(1 downto 0);
       o_forwardB          : out std_logic_vector(1 downto 0));

end forwardingUnit;


architecture dataflow of forwardingUnit is


begin

process_label : process( i_RegRdAddrMEMWB, i_RegWriteMEMWB, i_RegRdAddrEXMEM , i_RegWriteEXMEM, i_RegRsAddrIDEX, i_RegRtAddrIDEX, i_selImmIDEX )

	begin



-------------------Forwarding A Logic ----------------------------------------------------------
	if ((i_RegWriteEXMEM = '1') and (i_RegRdAddrEXMEM = i_RegRsAddrIDEX) and (i_RegRdAddrEXMEM /= "00000") and (i_RegRsAddrIDEX /= "00000"))
		then o_forwardA <= "10";

	elsif ((i_RegWriteMEMWB = '1') and (i_RegRdAddrMEMWB /= "00000") and  not ((i_RegWriteEXMEM = '1') and (i_RegRdAddrEXMEM /= "00000") and (i_RegRdAddrEXMEM = i_RegRsAddrIDEX)) and (i_RegRdAddrMEMWB = i_RegRsAddrIDEX)) 
		then o_forwardA <= "01";

	else
		o_forwardA <= "00";
	end if;
-------------------Forwarding A Logic ----------------------------------------------------------



-------------------Forwarding B Logic ----------------------------------------------------------
	if ((i_RegWriteEXMEM = '1') and (i_RegRdAddrEXMEM = i_RegRtAddrIDEX) and (i_RegRdAddrEXMEM /= "00000") and (i_selImmIDEX = '0')) 
		then o_forwardB <= "10";

	elsif ((i_RegWriteMEMWB = '1') and (i_RegRdAddrMEMWB /= "00000") and not ((i_RegWriteEXMEM = '1') and (i_RegRdAddrEXMEM /= "00000") and (i_RegRdAddrEXMEM = i_RegRtAddrIDEX)) and (i_RegRdAddrMEMWB = i_RegRtAddrIDEX)) 
		then o_forwardB <= "01";

	else
		o_forwardB <= "00";
	end if;
-------------------Forwarding B Logic ----------------------------------------------------------


end process;









end dataflow;