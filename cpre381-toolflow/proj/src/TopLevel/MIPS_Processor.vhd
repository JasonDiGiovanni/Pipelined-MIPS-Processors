-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-- 10/14/2024 by Corey Heithoff
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

  component fetchLogic is
   port(i_CLK           : in std_logic;
	i_RST           : in std_logic; 
	is_Brch         : in std_logic; 
	is_Jump         : in std_logic; 
	is_JumpReg      : in std_logic;
	is_zero		: in std_logic;
	i_instr         : in std_logic_vector(31 downto 0);
	i_immed         : in std_logic_vector(31 downto 0);
	i_rs_data       : in std_logic_vector(31 downto 0);
	i_PCplusFour	: in std_logic_vector(31 downto 0);
	o_PC		: out std_logic_vector(31 downto 0));
  end component;


  component controlUnit is
    port(
	op_Code	    		: in std_logic_vector(5 downto 0);
	Funct		    	: in std_logic_vector(5 downto 0);
	RegDst		    	: out std_logic;
	MemtoReg 	   	: out std_logic;
	MemWrite 	    	: out std_logic;
	ALUSrc 		   	: out std_logic;
	RegWrite 	   	: out std_logic;
	UnsignedNoOverflow	: out std_logic;
	ALUControl	    	: out std_logic_vector(3 downto 0);
	beq 		    	: out std_logic;
 	bne 		    	: out std_logic;
	j  		        : out std_logic;
	jr 		        : out std_logic;
	sltu            	: out std_logic;
	shiftVariable   	: out std_logic;
	upper_immediate 	: out std_logic;
	signSel		 	: out std_logic;
	halt                    : out std_logic
	);
  end component;


  component sign_ext is
  	generic(	
		INPUT_BIT_LENGTH   : integer := 16;
		OUTPUT_BIT_LENGTH  : integer := 32); 

  	port(		
		i_signSel : in std_logic;
		i_imm 	: in std_logic_vector(INPUT_BIT_LENGTH-1 downto 0);
		o_imm 	: out std_logic_vector(OUTPUT_BIT_LENGTH-1 downto 0)
		);
  end component;


  component regFile
  	port(	i_CLK        : in std_logic;     
       		i_RST        : in std_logic; 
       		i_regWrite   : in std_logic;     -- Write Enable    
       		i_rs_sel     : in std_logic_vector(4 downto 0);
       		i_rt_sel     : in std_logic_vector(4 downto 0);
       		i_rd_sel     : in std_logic_vector(4 downto 0);
       		i_rd_D	     : in std_logic_vector(31 downto 0);
       		o_rs_D       : out std_logic_vector(31 downto 0); 
       		o_rt_D	     : out std_logic_vector(31 downto 0)
  		);
  end component;

  component mux2t1 is
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic;
         i_D1                 : in std_logic;
         o_O                  : out std_logic);
  end component;


  component mux2t1_N is
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic_vector(31 downto 0);
         i_D1                 : in std_logic_vector(31 downto 0);
         o_O                  : out std_logic_vector(31 downto 0));
  end component;

  component alu is
    port(i_A			: in std_logic_vector(31 downto 0);
	i_B			: in std_logic_vector(31 downto 0);
	i_BrrlShamt		: in std_logic_vector(4 downto 0);
	i_AluCntrl		: in std_logic_vector(3 downto 0);
	o_Zero			: out std_logic;
	o_C			: out std_logic;
	o_O			: out std_logic;
	o_AluOut		: out std_logic_vector(31 downto 0)
	);
  end component;

  component org2
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

  component adder_N
    generic(N : integer := 32); 
    port(i_C          : in std_logic;
         i_A          : in std_logic_vector(N-1 downto 0);
         i_B          : in std_logic_vector(N-1 downto 0);
         o_S          : out std_logic_vector(N-1 downto 0);
         o_C          : out std_logic);
  end component;


  component reg_NPC
  	generic(N : integer := 32); 
  	port(	i_CLK        : in std_logic;     -- Clock input
       		i_RST        : in std_logic;     -- Reset input
       		i_WE         : in std_logic;     -- Write enable input
       		i_D          : in std_logic_vector(N-1 downto 0);     -- Data value inputs
       		o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value outputs
  end component;

component reg_IFID is
  port(i_CLK        : in std_logic;     		    -- Clock input
       i_RST        : in std_logic;    			    -- Reset input
       i_WE         : in std_logic;                         -- Write enable input
       i_PC         : in std_logic_vector(31 downto 0);     -- PC value input
       i_Instr      : in std_logic_vector(31 downto 0);     -- Instruction value input
       o_PC         : out std_logic_vector(31 downto 0);    -- PC value output
       o_Instr      : out std_logic_vector(31 downto 0));   -- Instruction value output
end component;

component reg_IDEX is
  port(i_CLK        : in std_logic;     		    -- Clock input
       i_RST        : in std_logic;     		    -- Reset input
       i_WE         : in std_logic;     		    -- Write enable input
       i_Halt       : in std_logic;     		    -- Halt control signal
       i_Branch     : in std_logic;     		    -- Branch control signal
       i_MemToReg   : in std_logic;     		    -- MemToReg control signal
       i_RegWr      : in std_logic;     		    -- RegWr control signal
       i_MemWr      : in std_logic;     		    -- MemWr control signal
       i_isJump     : in std_logic;     		    -- J control signal
       i_isJumpReg  : in std_logic;     		    -- JR control signal
       i_RegDst     : in std_logic;     		    -- RegDst control signal
       i_luiCtrl    : in std_logic;                         -- lui control signal
       i_AluSrc     : in std_logic;    		 	    -- AluSrc control signal
       i_AluCtrl    : in std_logic_vector(3 downto 0);      -- AluCtrl control signal
       i_RegWrAddr  : in std_logic_vector(4 downto 0);      -- RegWrAddr
       i_Imm        : in std_logic_vector(15 downto 0);     -- Imm value 
       i_Instr      : in std_logic_vector(31 downto 0);     -- Instr
       i_A          : in std_logic_vector(31 downto 0);     -- A input
       i_B          : in std_logic_vector(31 downto 0);     -- B input
       i_SignExt    : in std_logic_vector(31 downto 0);     -- Sign Extended input
       i_PC         : in std_logic_vector(31 downto 0);     -- PC input
       o_Halt       : out std_logic;     		    -- Halt control signal
       o_Branch     : out std_logic;     		    -- Branch control signal
       o_MemToReg   : out std_logic;    		    -- MemToReg control signal
       o_RegWr      : out std_logic;    		    -- RegWr control signal
       o_MemWr      : out std_logic;    		    -- MemWr control signal
       o_isJump     : out std_logic;    		    -- J control signal
       o_isJumpReg  : out std_logic;    		    -- JR control signal
       o_RegDst     : out std_logic;     		    -- RegDst control signal
       o_luiCtrl    : out std_logic;                        -- lui control signal
       o_AluSrc     : out std_logic;     		    -- AluSrc control signal
       o_AluCtrl    : out std_logic_vector(3 downto 0);     -- AluCtrl control signal
       o_RegWrAddr  : out std_logic_vector(4 downto 0);     -- RegWrAddr
       o_Imm        : out std_logic_vector(15 downto 0);    -- Imm value
       o_Instr      : out std_logic_vector(31 downto 0);    -- Instr
       o_A          : out std_logic_vector(31 downto 0);    -- A output
       o_B          : out std_logic_vector(31 downto 0);    -- B output
       o_SignExt    : out std_logic_vector(31 downto 0);    -- Sign Extended output
       o_PC         : out std_logic_vector(31 downto 0));   -- Pc output
end component;

component reg_EXMEM is
  port(i_CLK        : in std_logic;                          -- Clock input
       i_RST        : in std_logic;                          -- Reset input
       i_WE         : in std_logic;                          -- Write enable input
       i_Halt       : in std_logic;     		     -- Halt control signal      
       i_Branch     : in std_logic;     		     -- Branch control signal
       i_MemToReg   : in std_logic;     		     -- MemToReg control signal
       i_RegWr      : in std_logic;     		     -- RegWr control signal
       i_MemWr      : in std_logic;     		     -- MemWr control signal
       i_isJump     : in std_logic;                          -- RegWr control signal
       i_isJumpReg  : in std_logic;   		             -- JumpReg control signal
       i_AluZero    : in std_logic;     		     -- ALu is 0 control signal
       i_luiCtrl    : in std_logic;                          -- RegWr control signal
       i_RegWrAddr  : in std_logic_vector(4 downto 0);       -- RegWrAddr
       i_Imm        : in std_logic_vector(15 downto 0);      -- RegWr control signal
       i_PCnext     : in std_logic_vector(31 downto 0);      -- fetch calculated PC
       i_AluOut     : in std_logic_vector(31 downto 0);      -- Alu input
       i_RdDataB    : in std_logic_vector(31 downto 0);      -- Read Data B input
       i_PC         : in std_logic_vector(31 downto 0);      -- PC input
       o_Halt       : out std_logic;     		     -- Halt control signal
       o_Branch     : out std_logic;     		     -- Branch control signal
       o_MemToReg   : out std_logic;    		     -- MemToReg control signal
       o_RegWr      : out std_logic;     		     -- RegWr control signal
       o_MemWr      : out std_logic;    		     -- MemWr control signal
       o_isJump     : out std_logic;                         -- isJump control signal
       o_isJumpReg  : out std_logic;  			     -- JumpReg control signal
       o_AluZero    : out std_logic;     		     -- ALu is 0 control signal
       o_luiCtrl    : out std_logic;                         -- lui control signal
       o_RegWrAddr  : out std_logic_vector(4 downto 0);      -- RegWrAddr
       o_Imm        : out std_logic_vector(15 downto 0);     -- Imm value
       o_PCnext     : out std_logic_vector(31 downto 0);     -- fetch calculated PC
       o_AluOut     : out std_logic_vector(31 downto 0);     -- Alu output
       o_RdDataB    : out std_logic_vector(31 downto 0);     -- Read Data B output
       o_PC         : out std_logic_vector(31 downto 0));    -- Pc output  
end component;

component reg_MEMWB is
  port(i_CLK        : in std_logic;                         -- Clock input
       i_RST        : in std_logic;                         -- Reset input
       i_WE         : in std_logic;                         -- Write enable input
       i_Halt       : in std_logic;     		    -- Halt control signal
       i_Branch     : in std_logic;                         -- Branch control signal
       i_MemToReg   : in std_logic;                         -- MemToReg control signal
       i_RegWr      : in std_logic;                         -- RegWr control signal
       i_isJump     : in std_logic;                         -- isJump control signal
       i_luiCtrl    : in std_logic;                         -- lui control signal
       i_RegWrAddr  : in std_logic_vector(4 downto 0);      -- RegWrAddr
       i_Imm        : in std_logic_vector(15 downto 0);     -- RegWr control signal
       i_MemData    : in std_logic_vector(31 downto 0);     -- Data mem ouput
       i_AluOut     : in std_logic_vector(31 downto 0);     -- Alu output
       i_PC         : in std_logic_vector(31 downto 0);     -- PC input   
       o_Halt       : out std_logic;     		    -- Halt control signal          
       o_Branch     : out std_logic;                        -- Branch control signal
       o_MemToReg   : out std_logic;                        -- MemToReg control signal
       o_RegWr      : out std_logic;                        -- RegWr control signal
       o_isJump     : out std_logic;                        -- isJump control signal
       o_luiCtrl    : out std_logic;                        -- lui control signal
       o_RegWrAddr  : out std_logic_vector(4 downto 0);     -- RegWrAddr
       o_Imm        : out std_logic_vector(15 downto 0);    -- Imm value
       o_MemData    : out std_logic_vector(31 downto 0);    -- Data mem output
       o_AluOut     : out std_logic_vector(31 downto 0);    -- Alu output
       o_PC         : out std_logic_vector(31 downto 0));   -- Pc output 
end component;

component equalityModule is
  port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic);
end component;

component hazardDetectionUnit is
  port(i_RegRdAddrMEMWB    : in std_logic;
       i_RegWriteMEMWB     : in std_logic;
       i_RegRdAddrEXMEM    : in std_logic;
       i_RegWriteEXMEM     : in std_logic;
       i_RegRsAddrIDEX     : in std_logic;
       i_RegRtAddrIDEX     : in std_logic;
       i_MemToRegIDEX      : in std_logic;  -- Should be mem read but we are reusing MemToReg because only lw reads from mem
       i_RegRsAddrIFID     : in std_logic;
       i_RegRtAddrIFID     : in std_logic;
       o_Stall             : in std_logic;
       o_forwardA          : out std_logic_vector(2 downto 0);
       o_forwardB          : out std_logic_vector(2 downto 0));
end component;




  signal s_aluctr   : std_logic_vector(3 downto 0); 
  signal s_rs_sel,s_rt_sel, s_RegWrAddrCtrl    : std_logic_vector(4 downto 0);
  signal s_rs_DA, s_rt_DB, s_immExt, s_aluOut, s_ialuB, s_DMemOrAlu, s_DMemOrAluOrLui, s_RegWrAddrLong, s_RegWrAddrLongOut, s_PC4, si_PC, s_PCfetch : std_logic_vector(31 downto 0);  
  signal s_isJump, s_isJumpReg, s_is_zero, s_aluCar, s_aluSrc, s_memWr, s_regDst, s_MemtoReg, s_is_Lui, s_signExtSel, s_BrchEq, s_BrchNe, 
         temp, tempt, s_ALUOverflow, s_CntrlOverflow, so_Car_PC4, s_tempHalt, s_RegWrCtrl, s_EqlOut, s_BrnchMuxOut : std_logic;

   

-----Pipeline Register Signals---
--=============================== 


---------Start IF/ID-------------
signal s_PCfourIFID, s_InstIFID, s_rs_DAIFID, s_rt_DBIFID : std_logic_vector(31 downto 0);
---------End IF/ID---------------


---------Start ID/EX-------------
signal s_aluctrIDEX : std_logic_vector(3 downto 0); 
signal s_RegWrAddrIDEX : std_logic_vector(4 downto 0); 
signal s_ImmIDEX : std_logic_vector(15 downto 0); 
signal s_PCfourIDEX, s_InstIDEX, s_rs_DAIDEX,  s_rt_DBIDEX, s_immExtIDEX: std_logic_vector(31 downto 0);  
signal s_isJumpIDEX, s_isJumpRegIDEX, s_luiCtrlIDEX, s_BranchIDEX, s_DMemWrIDEX, s_RegWrIDEX, s_regDstIDEX, s_MemtoRegIDEX, s_aluSrcIDEX, s_HaltIDEX  : std_logic;
---------End ID/EX---------------


---------Start EX/MEM------------
signal s_RegWrAddrEXMEM : std_logic_vector(4 downto 0); 
signal s_ImmEXMEM : std_logic_vector(15 downto 0); 
signal s_PCfourEXMEM, s_aluOutEXMEM, s_rt_DBEXMEM, s_PCEXMEM : std_logic_vector(31 downto 0);
signal s_isJumpEXMEM, s_isJumpRegEXMEM, s_luiCtrlEXMEM, s_BranchEXMEM, s_DMemWrEXMEM, s_RegWrEXMEM, s_MemtoRegEXMEM, s_AluZeroEXMEM, s_HaltEXMEM : std_logic;
---------End EX/MEM--------------


---------Start MEM/WB------------
signal s_ImmMEMWB : std_logic_vector(15 downto 0);
signal s_PCfourMEMWB, s_DMemOutMEMWB, s_aluOutMEMWB : std_logic_vector(31 downto 0);
signal s_isJumpMEMWB, s_luiCtrlMEMWB, s_BranchMEMWB, s_MemtoRegMEMWB, s_HaltMEMWB : std_logic;
---------End MEM/WB--------------
--===============================

---------Start STALL/FLUSH SIGNALS------------
signal s_flushIFID, s_flushIDEX, s_flushEXMEM, s_flushMEMWB, s_stallIFID, s_stallIDEX, s_stallEXMEM, s_stallMEMWB : std_logic;
---------End Start STALL/FLUSH SIGNALS--------------
                                                    
  

---------------------------------------------------------------------------------------------------------

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


------------------------------------------------------Start Fetch-------------------------------------------------------------------------
  
  g_NBITREG_PC: reg_NPC port map(
	        i_CLK     => iCLK,
	        i_RST     => iRST,
	        i_WE      => '1',
	        i_D       => si_PC,
	        o_Q       => s_NextInstAddr);	-- stores PC value
		

  g_NBITMUX_PCnextAddr: mux2t1_N port map (
		i_S => ((s_BrnchMuxOut and (s_BrchEq or s_BrchNe)) or s_isJump or s_isJumpReg) ,	
		i_D0 => s_PC4,
		i_D1 => s_PCfetch,
		o_O => si_PC);


  g_NBITADDER_PC: adder_N port map (
	    	i_C => '0',
	    	i_A => s_NextInstAddr,
	    	i_B => x"00000004",	-- adding 4 for PC value
	    	o_S => s_PC4,
	    	o_C => so_Car_PC4); 

  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
------------------------------------------------------End Fetch---------------------------------------------------------------------------

  IFID_Pipeline_Reg : reg_IFID port map (
       i_CLK         =>   iCLK,
       i_RST         =>   s_flushIFID,   
       i_WE          =>   not s_stallIFID,     
       i_PC          =>   s_PC4,      
       i_Instr       =>   s_Inst,   
       o_PC          =>   s_PCfourIFID,    
       o_Instr       =>   s_InstIFID);

------------------------------------------------------Start Decode------------------------------------------------------------------------
  g_SIGNEXT: sign_ext port map(
		i_signSel 	=> s_signExtSel,
		i_imm 		=> s_InstIFID(15 downto 0), 
		o_imm 		=> s_immExt);

  g_REGFILE: regFile port map(
		i_CLK        => not iCLK, 
       		i_RST        => iRST, 
		i_regWrite   => s_RegWr, 
       		i_rs_sel     => s_InstIFID(25 downto 21),
       		i_rt_sel     => s_InstIFID(20 downto 16),
       		i_rd_sel     => s_RegWrAddr, 
       		i_rd_D	     => s_RegWrData,
       		o_rs_D       => s_rs_DAIFID,
       		o_rt_D	     => s_rt_DBIFID);

e_equalityModule: equalityModule
  port map(
            i_A  => s_rs_DAIFID,
      	    i_B  => s_rt_DBIFID,
      	    o_F  => s_EqlOut);

BrnchMux: mux2t1 
  port map(
           i_S      => s_BrchNe,      -- if bit is 0 then beq, if bit is a 1 then bne
           i_D0     => s_EqlOut, 
           i_D1     => not s_EqlOut,  
           o_O      => s_BrnchMuxOut);  

  g_FETCHLOGIC : fetchLogic port map(
		i_CLK       	=> iCLK, 
       		i_RST       	=> iRST, 
		is_Brch  	=> s_BrchEq OR s_BrchNe,
		is_Jump  	=> s_isJump,
		is_JumpReg  	=> s_isJumpReg,
		is_zero  	=> s_BrnchMuxOut,
		i_instr    	=> s_InstIFID, 
		i_immed    	=> s_immExt, 
		i_rs_data    	=> s_rs_DAIFID, 
                i_PCplusFour    => s_PCfourIFID,                                
		o_PC		=> s_PCfetch); 

--  g_FETCHLOGIC : fetchLogic port map(
--		i_CLK       	=> iCLK, 
--       		i_RST       	=> iRST, 
--		is_Brch  	=> s_BranchIDEX,
--		is_Jump  	=> s_isJumpIDEX,
--		is_JumpReg  	=> s_isJumpRegIDEX,
--		is_zero  	=> s_is_zero,
--		i_instr    	=> s_InstIDEX, 
--		i_immed    	=> s_ImmExtIDEX, 
--		i_rs_data    	=> s_rs_DAIDEX, 
--                i_PCplusFour    => s_PCfourIDEX,                                
--		o_PC		=> s_PCfetch); 

  g_CONTRUNIT : controlUnit port map(
		op_Code	    		=> s_InstIFID(31 downto 26),	
		Funct		    	=> s_InstIFID(5 downto 0),	
		RegDst		    	=> s_regDst,	
		MemtoReg 	   	=> s_MemtoReg,	
		MemWrite 	    	=> s_memWr,	
		ALUSrc 		   	=> s_aluSrc,	
		RegWrite 	   	=> s_RegWrCtrl,
		UnsignedNoOverflow	=> s_CntrlOverflow,
		ALUControl	    	=> s_aluctr,	
		beq 		    	=> s_BrchEq,	-- only need one branch control so they are ORed
 		bne 		    	=> s_BrchNe,	
		j  		        => s_isJump,	-- used to j and jal control
		jr 		        => s_isJumpReg,	
		sltu            	=> temp,	-- not needed?
		shiftVariable   	=> tempt,	-- not needed?
		upper_immediate 	=> s_is_Lui,	
		signSel 		=> s_signExtSel,
		halt                    => s_tempHalt);



 g_NBITMUX_RegWrAddr: mux2t1_N port map (
		i_S => s_regDst,	
		i_D0(31 downto 5) => "000000000000000000000000000", -- 27 zeros and 5 address bits
		i_D0(4 downto 0) => s_InstIFID(20 downto 16), 
		i_D1(31 downto 5) => "000000000000000000000000000", -- 27 zeros and 5 address bits
		i_D1(4 downto 0) => s_InstIFID(15 downto 11), 
		o_O => s_RegWrAddrLongOut);

  g_NBITMUX_RegWrAddrJAL: mux2t1_N port map (
		i_S => s_isJump,	
		i_D0 => s_RegWrAddrLongOut,
		i_D1 => x"0000001F",
		o_O => s_RegWrAddrLong);

  s_RegWrAddrCtrl <= s_RegWrAddrLong(4 downto 0);
------------------------------------------------------End Decode--------------------------------------------------------------------------

IDEX_Pipeline_Reg:  reg_IDEX port map(
       i_CLK         =>   iCLK,
       i_RST         =>   s_flushIDEX,
       i_WE          =>   not s_stallIDEX,
       i_Halt        =>   s_tempHalt,
       i_Branch      =>   s_BrchEq OR s_BrchNe,
       i_MemToReg    =>   s_MemtoReg,
       i_RegWr       =>   s_RegWrCtrl,
       i_MemWr       =>   s_memWr,
       i_isJump      =>   s_isJump,
       i_isJumpReg   =>   s_isJumpReg,
       i_RegDst      =>   s_regDst,
       i_luiCtrl     =>   s_is_Lui,
       i_AluSrc      =>   s_aluSrc,
       i_AluCtrl     =>   s_aluctr,
       i_RegWrAddr   =>   s_RegWrAddrCtrl,
       i_Imm         =>   s_InstIFID(15 downto 0),
       i_Instr       =>   s_InstIFID,
       i_A           =>   s_rs_DAIFID,
       i_B           =>   s_rt_DBIFID,
       i_SignExt     =>   s_immExt,
       i_PC          =>   s_PCfourIFID,
       o_Halt        =>   s_HaltIDEX,
       o_Branch      =>   s_BranchIDEX,
       o_MemToReg    =>   s_MemtoRegIDEX,
       o_RegWr       =>   s_RegWrIDEX,
       o_MemWr       =>   s_DMemWrIDEX,
       o_isJump      =>   s_isJumpIDEX,
       o_isJumpReg   =>   s_isJumpRegIDEX,
       o_RegDst      =>   s_regDstIDEX,
       o_luiCtrl     =>   s_luiCtrlIDEX,
       o_AluSrc      =>   s_aluSrcIDEX,
       o_AluCtrl     =>   s_aluctrIDEX,
       o_Imm         =>   s_ImmIDEX,
       o_RegWrAddr   =>   s_RegWrAddrIDEX,
       o_Instr       =>   s_InstIDEX,
       o_A           =>   s_rs_DAIDEX,
       o_B           =>   s_rt_DBIDEX,
       o_SignExt     =>   s_immExtIDEX,
       o_PC          =>   s_PCfourIDEX);

------------------------------------------------------Start Execute-----------------------------------------------------------------------

   g_NBITMUX_ALUB: mux2t1_N port map (
		i_S => s_aluSrcIDEX,	
		i_D0 => s_rt_DBIDEX,   
		i_D1 => s_immExtIDEX, 
		o_O => s_ialuB);

    g_ALU : alu port map(
		i_A			=> s_rs_DAIDEX,
		i_B			=> s_ialuB,
		i_BrrlShamt		=> s_InstIDEX(10 downto 6),
		i_AluCntrl		=> s_aluctrIDEX,
		o_Zero			=> s_is_zero,
		o_C			=> s_aluCar,
		o_O			=> s_ALUOverflow,
		o_AluOut		=> s_aluOut);

 s_Ovfl     <= s_ALUOverflow and (not s_CntrlOverflow);
 oALUOut    <= s_aluOut;
------------------------------------------------------End Execute-------------------------------------------------------------------------

  EXMEM_Pipeline_Red :  reg_EXMEM port map(
       i_CLK         =>   iCLK,
       i_RST         =>   s_flushEXMEM,
       i_WE          =>   not s_stallEXMEM,
       i_Halt        =>   s_HaltIDEX,
       i_Branch      =>   s_BranchIDEX, 
       i_MemToReg    =>   s_MemtoRegIDEX,
       i_RegWr       =>   s_RegWrIDEX,
       i_MemWr       =>   s_DMemWrIDEX,
       i_isJump      =>   s_isJumpIDEX,
       i_isJumpReg   =>   s_isJumpRegIDEX,
       i_AluZero     =>   s_is_zero,
       i_luiCtrl     =>   s_luiCtrlIDEX,
       i_RegWrAddr   =>   s_RegWrAddrIDEX,
       i_Imm         =>   s_ImmIDEX,
       i_PCnext      =>   s_PCfetch, 
       i_AluOut      =>   s_aluOut,
       i_RdDataB     =>   s_rt_DBIDEX,
       i_PC          =>   s_PCfourIDEX,
       o_Halt        =>   s_HaltEXMEM,
       o_Branch      =>   s_BranchEXMEM,
       o_MemToReg    =>   s_MemtoRegEXMEM,
       o_RegWr       =>   s_RegWrEXMEM,
       o_MemWr       =>   s_DMemWr,
       o_isJump      =>   s_isJumpEXMEM,
       o_isJumpReg   =>   s_isJumpRegEXMEM,
       o_AluZero     =>   s_AluZeroEXMEM,
       o_luiCtrl     =>   s_luiCtrlEXMEM,
       o_RegWrAddr   =>   s_RegWrAddrEXMEM,
       o_Imm         =>   s_ImmEXMEM,
       o_PCnext      =>   s_PCEXMEM, 
       o_AluOut      =>   s_DMemAddr,
       o_RdDataB     =>   s_DMemData,
       o_PC          =>   s_PCfourEXMEM);

   s_aluOutEXMEM <= s_DMemAddr;

------------------------------------------------------Start Memory------------------------------------------------------------------------
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);
------------------------------------------------------End Memory--------------------------------------------------------------------------

  MEMWB :  reg_MEMWB port map(
       i_CLK         =>   iCLK,
       i_RST         =>   s_flushMEMWB,
       i_WE          =>   not s_stallMEMWB,
       i_Halt        =>   s_HaltEXMEM,
       i_Branch      =>   s_BranchEXMEM,
       i_MemToReg    =>   s_MemtoRegEXMEM,
       i_RegWr       =>   s_RegWrEXMEM,
       i_isJump      =>   s_isJumpEXMEM,
       i_luiCtrl     =>   s_luiCtrlEXMEM,
       i_RegWrAddr   =>   s_RegWrAddrEXMEM,
       i_Imm         =>   s_ImmEXMEM,
       i_MemData     =>   s_DMemOut,
       i_AluOut      =>   s_aluOutEXMEM,
       i_PC          =>   s_PCfourEXMEM,
       o_Halt        =>   s_HaltMEMWB,
       o_Branch      =>   s_BranchMEMWB,
       o_MemToReg    =>   s_MemtoRegMEMWB,
       o_RegWr       =>   s_RegWr,
       o_isJump      =>   s_isJumpMEMWB,
       o_luiCtrl     =>   s_luiCtrlMEMWB,
       o_RegWrAddr   =>   s_RegWrAddr,
       o_Imm         =>   s_ImmMEMWB,
       o_MemData     =>   s_DMemOutMEMWB,
       o_AluOut      =>   s_aluOutMEMWB,
       o_PC          =>   s_PCfourMEMWB);

------------------------------------------------------Start Write Back--------------------------------------------------------------------
  g_NBITMUX_MemtoReg: mux2t1_N port map (
		i_S => s_MemtoRegMEMWB,	
		i_D0 => s_aluOutMEMWB,   
		i_D1 => s_DMemOutMEMWB, 
		o_O => s_DMemOrAlu);

 g_NBITMUX_Lui: mux2t1_N port map (
		i_S => s_luiCtrlMEMWB,	
		i_D0 => s_DMemOrAlu,   
		i_D1(31 downto 16) => s_ImmMEMWB, -- Lui: upper 16 bits is immediate value and lower 16 bits is filled with zeros
		i_D1(15 downto 0) => x"0000",
		o_O => s_DMemOrAluOrLui);

  g_NBITMUX_JumpLink: mux2t1_N port map (
		i_S => s_isJumpMEMWB,	
		i_D0 => s_DMemOrAluOrLui,  
		i_D1 => s_PCfourMEMWB, 
		o_O => s_RegWrData);

 s_Halt <= s_HaltMEMWB;
------------------------------------------------------End Write Back----------------------------------------------------------------------
--========================================================================================================================================







end structure;

