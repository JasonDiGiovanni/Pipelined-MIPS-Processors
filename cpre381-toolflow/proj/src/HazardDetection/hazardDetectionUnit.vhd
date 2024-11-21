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
       i_RegWrAddrEXMEM    : in std_logic_vector(4 downto 0);
       i_RegWrAddrIDEX     : in std_logic_vector(4 downto 0);
       i_RegRtAddrIDEX     : in std_logic_vector(4 downto 0);
       i_MemToRegIDEX      : in std_logic;  -- Should be mem read but we are reusing MemToReg because only lw reads from mem
       i_RegRsAddrIFID     : in std_logic_vector(4 downto 0);
       i_RegRtAddrIFID     : in std_logic_vector(4 downto 0);
       i_isBranchIFID      : in std_logic;
       i_isJump            : in std_logic;       
       o_FlushIFID         : out std_logic;
       o_Stall             : out std_logic;
       o_FlushIDEX         : out std_logic);

end hazardDetectionUnit;


architecture dataflow of hazardDetectionUnit is


begin

process_label : process( i_CLK ) --i_RegRtAddrIDEX, i_MemToRegIDEX, i_RegRsAddrIFID, i_RegRtAddrIFID

	begin

--Flushing IDEX register and Flush IFID Register
---------------------------------------------------------------------------------------------------------------------------------------------------------------
 if (rising_edge(i_CLK)) then
 
	--Data Hazard
	-- Flush is for a load word use case something ex.
	--lw t1 x(x)
	--add x t1 x
        if ((i_MemToRegIDEX = '1') and ((i_RegRtAddrIDEX = i_RegRsAddrIFID) or (i_RegRtAddrIDEX = i_RegRtAddrIFID)))
                then o_FlushIDEX <= '1';
 		o_FlushIFID <= '0';

	--Data Hazard
	--Branching (must flush is there is a data hazard before branch can happen in decode stage) ex.
	--add t1 x x 
	--beq t1 x label
	elsif ((i_isBranchIFID = '1')  and (i_RegWrAddrIDEX /= "00000") and ((i_RegRsAddrIFID = i_RegWrAddrIDEX) or (i_RegRtAddrIFID = i_RegWrAddrIDEX)) )
		then o_FlushIDEX <= '1';
		o_FlushIFID <= '0';

	--Control Hazard
	-- When a branch is taken it flushes the IDEX register
	elsif (i_isJump = '1')
                then o_FlushIDEX <= '0';
		o_FlushIFID <= '1';

        else
                o_FlushIDEX <= '0';
		o_FlushIFID <= '0';
	end if;
else 
	o_FlushIDEX <= '0';
	o_FlushIFID <= '0';

end if;
---------------------------------------------------------------------------------------------------------------------------------------------------------------


--Flush IFID register
---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- if (rising_edge(i_CLK)) then
 
	--Ensures that if flushing IDEX you must wait before flushing IFID
        --if ((i_MemToRegIDEX = '1') and ((i_RegRtAddrIDEX = i_RegRsAddrIFID) or (i_RegRtAddrIDEX = i_RegRtAddrIFID)))
               -- then o_FlushIFID <= '0';

	--elsif ((i_isBranchIFID = '1')  and (i_RegWrAddrIDEX /= "00000") and ((i_RegRsAddrIFID = i_RegWrAddrIDEX) or (i_RegRtAddrIFID = i_RegWrAddrIDEX)) )
		--then o_FlushIFID <= '0';

	--elsif (i_isJump = '1')
                --then o_FlushIFID <= '1';

       -- else
              --  o_FlushIFID <= '0';
	--end if;
--else 
	--o_FlushIFID <= '0';

--end if;
---------------------------------------------------------------------------------------------------------------------------------------------------------------



--These are for data hazards into branch
-- Stall is for a load word use case or Branch
-- Stalls PC and IFID Register
---------------------------------------------------------------------------------------------------------------------------------------------------------------

 if (falling_edge(i_CLK)) then

        if ((i_MemToRegIDEX = '1') and ((i_RegRtAddrIDEX = i_RegRsAddrIFID) or (i_RegRtAddrIDEX = i_RegRtAddrIFID))) 
                then o_Stall <= '1';

	elsif ((i_isBranchIFID = '1')  and (i_RegWrAddrIDEX /= "00000") and ((i_RegRsAddrIFID = i_RegWrAddrIDEX) or (i_RegRtAddrIFID = i_RegWrAddrIDEX)) )
		then o_Stall <= '1';

	--elsif ((i_isBranchIFID = '1') and (i_RegWrAddrEXMEM /= "00000") and ((i_RegRsAddrIFID = i_RegWrAddrEXMEM) or (i_RegRtAddrIFID = i_RegWrAddrEXMEM)))
		--then o_Stall <= '1';
        else
               o_Stall <= '0';
	end if;

---------------------------------------------------------------------------------------------------------------------------------------------------------------

end if;


end process;









end dataflow;
