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
       i_MemWriteIDEX      : in std_logic;
       i_RegRsAddrIDEX     : in std_logic_vector(4 downto 0);
       i_RegRtAddrIDEX     : in std_logic_vector(4 downto 0);
       i_RegWrAddrIDEX     : in std_logic_vector(4 downto 0);
       i_selImmIDEX        : in std_logic;
       i_RegRsAddrIFID     : in std_logic_vector(4 downto 0);
       i_RegRtAddrIFID     : in std_logic_vector(4 downto 0);
       i_isBranchIFID      : in std_logic;
       o_forwardBMEM       : out std_logic;
       o_forwardA          : out std_logic_vector(1 downto 0);
       o_forwardB          : out std_logic_vector(1 downto 0);
       o_BranchForwardA    : out std_logic_vector(1 downto 0);
       o_BranchForwardB    : out std_logic_vector(1 downto 0));

end forwardingUnit;


architecture dataflow of forwardingUnit is


begin

process_label : process( all  ) --i_RegRdAddrMEMWB, i_RegWriteMEMWB, i_RegRdAddrEXMEM , i_MemWriteIDEX, i_RegWriteEXMEM, i_RegWrAddrIDEX, i_RegRsAddrIDEX, i_RegRtAddrIDEX, i_selImmIDEX, i_isBranchIFID, i_RegRtAddrIFID, i_RegRsAddrIFID

	begin

--(i_isBranchIFID = '0') and 

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
	if ((i_RegWriteEXMEM = '1') and (i_RegRdAddrEXMEM = i_RegRtAddrIDEX) and (i_RegRdAddrEXMEM /= "00000")  and ((i_selImmIDEX = '0'))) -- 
		then o_forwardB <= "10";

	elsif ((i_RegWriteMEMWB = '1') and (i_RegRdAddrMEMWB /= "00000") and not ((i_RegWriteEXMEM = '1') and (i_RegRdAddrEXMEM /= "00000") and (i_RegRdAddrEXMEM = i_RegRtAddrIDEX)) and (i_RegRdAddrMEMWB = i_RegRtAddrIDEX)) 
		then o_forwardB <= "01";

	else
		o_forwardB <= "00";
	end if;
-------------------Forwarding B Logic ----------------------------------------------------------

---------------------------Load Word Use Case Hazard---------------------------------------
	if ((i_RegWriteEXMEM = '1') and (i_RegRdAddrEXMEM = i_RegRtAddrIDEX) and (i_RegRdAddrEXMEM /= "00000")  and ((i_MemWriteIDEX = '1'))) -- 
		then o_forwardBMem <= '1';

	else
		o_forwardBMem <= '0';

	end if;
---------------------------Load Word Use Case Hazard---------------------------------------
--Forwarding specifically a load word data hazard (the value is after the load word)


---------------------------Branch Decision Forwarding---------------------------------------


	if ((i_isBranchIFID = '1')  and (i_RegWrAddrIDEX /= "00000") and (i_RegRsAddrIFID = i_RegWrAddrIDEX))
		then o_BranchForwardA <= "10";

	elsif ((i_isBranchIFID = '1') and (i_RegRdAddrEXMEM /= "00000") and (i_RegRsAddrIFID = i_RegRdAddrEXMEM) )
		then o_BranchForwardA <= "01";

        else 
                 o_BranchForwardA <= "00";
        end if;


	if ((i_isBranchIFID = '1')  and (i_RegWrAddrIDEX /= "00000") and (i_RegRtAddrIFID = i_RegWrAddrIDEX))
		then o_BranchForwardB <= "10";

	elsif ((i_isBranchIFID = '1') and (i_RegRdAddrEXMEM /= "00000") and (i_RegRtAddrIFID = i_RegRdAddrEXMEM) )
		then o_BranchForwardB <= "01";

        else 
                 o_BranchForwardB <= "00";
	 end if;


---------------------------Branch Decision Forwarding---------------------------------------

end process;









end dataflow;
