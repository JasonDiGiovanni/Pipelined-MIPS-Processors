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
       i_RST               : in std_logic;
       i_RegWrAddrEXMEM    : in std_logic_vector(4 downto 0);
       i_MemToRegEXMEM     : in std_logic;  -- Should be mem read but we are reusing MemToReg because only lw reads from mem
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


  component dffg
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic;     -- Data value input
         o_Q          : out std_logic);   -- Data value output
  end component;

  signal s_FlushIDEX, s_FlushIDEXnot, s_FlushIDEXwait, s_FlushIDEXwaitwait, s_FlushIFID, s_FlushIFIDnot, s_FlushIFIDwait, s_FlushIFIDwaitwait : std_logic;



begin

process_label : process( i_CLK ) --i_RegRtAddrIDEX, i_MemToRegIDEX, i_RegRsAddrIFID, i_RegRtAddrIFID

	begin


-------------------------------------------------------- FlushIDEX following clock ------------------------------------------------------------------------------------------

 if (rising_edge(i_CLK)) then 
 
	-- case of lw values not being ready for the next instruction
        if ((i_MemToRegIDEX = '1') and ((i_RegRtAddrIDEX = i_RegRsAddrIFID) or (i_RegRtAddrIDEX = i_RegRtAddrIFID)))
                then s_FlushIDEX <= '1'; --o_FlushIDEX
			s_FlushIFID <= '0';

	-- case of branch values not being ready from the previous instruction
	elsif ((i_isBranchIFID = '1')  and (i_RegWrAddrIDEX /= "00000") and ((i_RegRsAddrIFID = i_RegWrAddrIDEX) or (i_RegRtAddrIFID = i_RegWrAddrIDEX)) )
		then s_FlushIDEX <= '1'; --o_FlushIDEX
			s_FlushIFID <= '0';

	-- case of branch directly follows a lw needing two stalls
	elsif ((i_isBranchIFID = '1') and (i_MemToRegEXMEM = '1') and (i_RegWrAddrEXMEM /= "00000") and ((i_RegRsAddrIFID = i_RegWrAddrEXMEM) or (i_RegRtAddrIFID = i_RegWrAddrEXMEM)))
		then s_FlushIDEX <= '1'; --o_FlushIDEX
			s_FlushIFID <= '0';

	elsif (i_isJump = '1')
		then s_FlushIDEX <= '0';
                	s_FlushIFID <= '1';

        else
                s_FlushIDEX <= '0'; --o_FlushIDEX
		s_FlushIFID <= '0';
	end if;
--else 
	--o_FlushIDEX <= '0';

end if;

-------------------------------------------------------- FlushIDEX following clock ------------------------------------------------------------------------------------------

---------------------------------------------------- FlushIDEX following NOT clock ------------------------------------------------------------------------------------------

 --if (falling_edge(i_CLK)) then 
 
	-- case of lw values not being ready for the next instruction
 --       if ((i_MemToRegIDEX = '1') and ((i_RegRtAddrIDEX = i_RegRsAddrIFID) or (i_RegRtAddrIDEX = i_RegRtAddrIFID)))
 --               then s_FlushIDEXnot <= '1'; --o_FlushIDEX
 --               	s_FlushIFIDnot <= '0';

	-- case of branch values not being ready from the previous instruction
	--elsif ((i_isBranchIFID = '1')  and (i_RegWrAddrIDEX /= "00000") and ((i_RegRsAddrIFID = i_RegWrAddrIDEX) or (i_RegRtAddrIFID = i_RegWrAddrIDEX)) )
	--	then s_FlushIDEXnot <= '1'; --o_FlushIDEX
 --               	s_FlushIFIDnot <= '0';

	-- case of branch directly follows a lw needing two stalls
	--elsif ((i_isBranchIFID = '1') and (i_MemToRegEXMEM = '1') and (i_RegWrAddrEXMEM /= "00000") and ((i_RegRsAddrIFID = i_RegWrAddrEXMEM) or (i_RegRtAddrIFID = i_RegWrAddrEXMEM)))
	--	then s_FlushIDEXnot <= '1'; --o_FlushIDEX
 --               	s_FlushIFIDnot <= '0';

	--elsif (i_isJump = '1')
  --              then s_FlushIDEXnot <= '0';
  --              	s_FlushIFIDnot <= '1';

  --      else
--                s_FlushIDEXnot <= '0'; --o_FlushIDEX
 --               s_FlushIFIDnot <= '0';
	--end if;
--else 
	--o_FlushIDEX <= '0';

--end if;

---------------------------------------------------- FlushIDEX following NOT clock ------------------------------------------------------------------------------------------






-------------------------------------------------------- FlushIFID following clock ------------------------------------------------------------------------------------------

-- if (rising_edge(i_CLK)) then
 
	--case of flushing the instruction after jump or branch to retrieve target address
--        if ((i_MemToRegIDEX = '1') and ((i_RegRtAddrIDEX = i_RegRsAddrIFID) or (i_RegRtAddrIDEX = i_RegRtAddrIFID)))
--                then s_FlushIFID <= '0'; --o_FlushIFID

	--case of flushing the instruction after jump or branch to retrieve target address
--	elsif ((i_isBranchIFID = '1')  and (i_RegWrAddrIDEX /= "00000") and ((i_RegRsAddrIFID = i_RegWrAddrIDEX) or (i_RegRtAddrIFID = i_RegWrAddrIDEX)) )
--		then s_FlushIFID <= '0'; --o_FlushIFID

	--case of flushing the instruction after jump or branch to retrieve target address
--	elsif ((i_isBranchIFID = '1') and (i_MemToRegEXMEM = '1') and (i_RegWrAddrEXMEM /= "00000") and ((i_RegRsAddrIFID = i_RegWrAddrEXMEM) or (i_RegRtAddrIFID = i_RegWrAddrEXMEM)))
--		then s_FlushIFID <= '0'; --o_FlushIFID

	--case of flushing the instruction after jump or branch to retrieve target address
--	elsif (i_isJump = '1')
--                then s_FlushIFID <= '1'; --o_FlushIFID

--        else
 --               s_FlushIFID <= '0'; --o_FlushIFID
--	end if;
--else 
	--o_FlushIFID <= '0'; 

--end if;

-------------------------------------------------------- FlushIFID following clock ------------------------------------------------------------------------------------------




-------------------------------------------------------- FlushIFID following NOT clock ------------------------------------------------------------------------------------------

 --if (falling_edge(i_CLK)) then
 
	--case of flushing the instruction after jump or branch to retrieve target address
 --       if ((i_MemToRegIDEX = '1') and ((i_RegRtAddrIDEX = i_RegRsAddrIFID) or (i_RegRtAddrIDEX = i_RegRtAddrIFID)))
 --               then s_FlushIFIDnot <= '0'; --o_FlushIFID

	--case of flushing the instruction after jump or branch to retrieve target address
	--elsif ((i_isBranchIFID = '1')  and (i_RegWrAddrIDEX /= "00000") and ((i_RegRsAddrIFID = i_RegWrAddrIDEX) or (i_RegRtAddrIFID = i_RegWrAddrIDEX)) )
	--	then s_FlushIFIDnot <= '0'; --o_FlushIFID
--
	--case of flushing the instruction after jump or branch to retrieve target address
	--elsif ((i_isBranchIFID = '1') and (i_MemToRegEXMEM = '1') and (i_RegWrAddrEXMEM /= "00000") and ((i_RegRsAddrIFID = i_RegWrAddrEXMEM) or (i_RegRtAddrIFID = i_RegWrAddrEXMEM)))
	--	then s_FlushIFIDnot <= '0'; --o_FlushIFID

	--case of flushing the instruction after jump or branch to retrieve target address
	--elsif (i_isJump = '1')
  --              then s_FlushIFIDnot <= '1'; --o_FlushIFID

  --      else
  --              s_FlushIFIDnot <= '0'; --o_FlushIFID
	--end if;
--else 
	--o_FlushIFID <= '0'; 

--end if;

-------------------------------------------------------- FlushIFID following NOT clock ------------------------------------------------------------------------------------------




-------------------------------------------------------- PC and IFID Stall following NOT clock ------------------------------------------------------------------------------------------

 if (falling_edge(i_CLK)) then

	-- case of lw values not being ready for later instructions
        if ((i_MemToRegIDEX = '1') and ((i_RegRtAddrIDEX = i_RegRsAddrIFID) or (i_RegRtAddrIDEX = i_RegRtAddrIFID))) 
                then o_Stall <= '1';

	-- case of branch values not being ready from previous instructions
	elsif ((i_isBranchIFID = '1')  and (i_RegWrAddrIDEX /= "00000") and ((i_RegRsAddrIFID = i_RegWrAddrIDEX) or (i_RegRtAddrIFID = i_RegWrAddrIDEX)) )
		then o_Stall <= '1';
	
	-- case of branch directly follows a lw needing two stalls
	elsif ((i_isBranchIFID = '1') and (i_MemToRegEXMEM = '1') and (i_RegWrAddrEXMEM /= "00000") and ((i_RegRsAddrIFID = i_RegWrAddrEXMEM) or (i_RegRtAddrIFID = i_RegWrAddrEXMEM)))
		then o_Stall <= '1';
        else
               o_Stall <= '0';
	end if;



end if;


end process;


 -- FlushIFIDwaitcycle: dffg port map(
	--      i_CLK     => i_CLK,
	--      i_RST     => i_RST,
	--      i_WE      => '1',
	--      i_D       => s_FlushIFIDnot,
--	      o_Q       => s_FlushIFIDwait);
--
-- FlushIFIDwaitwait: dffg port map(
--	      i_CLK     => not i_CLK,
--	      i_RST     => i_RST,
--	      i_WE      => '1',
	--      i_D       => s_FlushIFIDwait,
	--      o_Q       => s_FlushIFIDwaitwait);


 -- FlushIDEXwaitcycle: dffg port map(
	--      i_CLK     => i_CLK,
	--      i_RST     => i_RST,
	--      i_WE      => '1',
	--      i_D       => s_FlushIDEXnot,
	--      o_Q       => s_FlushIDEXwait);

 -- FlushIDEXwaitwait: dffg port map(
	--      i_CLK     => not i_CLK,
	--      i_RST     => i_RST,
	--      i_WE      => '1',
	--      i_D       => s_FlushIDEXwait,
	--      o_Q       => s_FlushIDEXwaitwait);
--


--o_FlushIFID <= (s_FlushIFID and not s_FlushIFIDwaitwait and i_isJump); -- or (s_FlushIFID and s_FlushIFIDwait and s_FlushIFIDnot);
--o_FlushIDEX <= (s_FlushIDEX and not s_FlushIDEXwaitwait) or (s_FlushIDEX and s_FlushIDEXwait and s_FlushIDEXwaitwait and s_FlushIDEXnot);

o_FlushIFID <= s_FlushIFID and i_isJump; --and not i_CLK;
o_FlushIDEX <= s_FlushIDEX and i_isBranchIFID; --and not i_CLK;





end dataflow;
