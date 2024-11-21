-------------------------------------------------------------------------
-- Owen Jewell
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- reg_IDEX.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a N-bit register
-- for the IF/ID pipeline register
--
--
-- NOTES:
-- Created 11/05/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity reg_IDEX is

  port(i_CLK        : in std_logic;     		    -- Clock input
       i_RST        : in std_logic;     		    -- Reset input
       i_WE         : in std_logic;     		    -- Write enable input
       i_Flush      : in std_logic;
       i_Halt       : in std_logic;     		    -- Halt control signal
       i_Branch     : in std_logic;     		    -- Branch control signal
       i_MemToReg   : in std_logic;     		    -- MemToReg control signal
       i_RegWr      : in std_logic;     		    -- RegWr control signal
       i_MemWr      : in std_logic;     		    -- MemWr control signal
       i_isJump     : in std_logic;     		    -- J control signal
       i_isJumpReg  : in std_logic;     		    -- JR control signal
       i_RegDst     : in std_logic;     		    -- RegDst control signal
       i_luiCtrl    : in std_logic;                         -- lui control signal
       i_forwardA   : in std_logic_vector(1 downto 0);      -- forward A control
       i_forwardB   : in std_logic_vector(1 downto 0);      -- forward B control
       i_AluSrc     : in std_logic;    		 	    -- AluSrc control signal
       i_AluCtrl    : in std_logic_vector(3 downto 0);      -- AluCtrl control signal
       i_RsAddr     : in std_logic_vector(4 downto 0);      -- Rs Addr
       i_RtAddr     : in std_logic_vector(4 downto 0);      -- Rt Addr
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
       o_forwardA   : out std_logic_vector(1 downto 0);     -- forward A control
       o_forwardB   : out std_logic_vector(1 downto 0);     -- forward B control
       o_AluSrc     : out std_logic;     		    -- AluSrc control signal
       o_AluCtrl    : out std_logic_vector(3 downto 0);     -- AluCtrl control signal
       o_RsAddr     : out std_logic_vector(4 downto 0);     -- Rs Addr
       o_RtAddr     : out std_logic_vector(4 downto 0);     -- Rt Addr
       o_RegWrAddr  : out std_logic_vector(4 downto 0);     -- RegWrAddr
       o_Imm        : out std_logic_vector(15 downto 0);    -- Imm value
       o_Instr      : out std_logic_vector(31 downto 0);    -- Instr
       o_A          : out std_logic_vector(31 downto 0);    -- A output
       o_B          : out std_logic_vector(31 downto 0);    -- B output
       o_SignExt    : out std_logic_vector(31 downto 0);    -- Sign Extended output
       o_PC         : out std_logic_vector(31 downto 0));   -- Pc output

end reg_IDEX;

architecture structure of reg_IDEX is


  component dffg
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic;     -- Data value input
         o_Q          : out std_logic);   -- Data value output
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

----------------------------------------------Signals Start ------------------------------------

--1 Bit
signal s_Halt, s_Branch, s_MemToReg, s_regWr, s_MemWr, s_isJump, s_isJumpReg, s_RegDst, s_luiCtrl, s_AluSrc : std_logic;

--2 Bit
signal s_forwardA, s_forwardB : std_logic_vector(1 downto 0);

--4 Bit
signal s_AluCtrl : std_logic_vector(3 downto 0);

--5 Bit
signal s_RsAddr, s_RtAddr, s_RegWrAddr : std_logic_vector(4 downto 0);

--16 Bit
signal s_Imm : std_logic_vector(15 downto 0);

--31 Bit
signal s_Instr, s_A, s_B, s_SignExt, s_Pc : std_logic_vector(31 downto 0);

--Long Signals
signal s_forwardALong, s_forwardBLong, s_AluCtrlLong, s_RsAddrLong, s_RtAddrLong, s_RegWrAddrLong, s_ImmLong : std_logic_vector(31 downto 0);

----------------------------------------------Signals End ------------------------------------

begin


---------------31 bit Muxes Start-----------------

  g_NBITMUX_Instr: mux2t1_N port map (
		i_S => i_Flush,
		i_D0 => i_Instr,
		i_D1 => x"00000000",
		o_O => s_Instr);

  g_NBITMUX_A: mux2t1_N port map (
		i_S => i_Flush,
		i_D0 => i_A,
		i_D1 => x"00000000",
		o_O => s_A);

  g_NBITMUX_B: mux2t1_N port map (
		i_S => i_Flush,
		i_D0 => i_B,
		i_D1 => x"00000000",
		o_O => s_B);

  g_NBITMUX_SignExt: mux2t1_N port map (
		i_S => i_Flush,
		i_D0 => i_SignExt,
		i_D1 => x"00000000",
		o_O => s_SignExt);

  g_NBITMUX_PC: mux2t1_N port map (
		i_S => i_Flush,
		i_D0 => i_PC,
		i_D1 => x"00000000",
		o_O => s_PC);


---------------31 bit Muxes End-----------------


---------------2 bit Muxes Start-----------------
 g_NBITMUX_forwardA: mux2t1_N port map (
		i_S => i_Flush,	
		i_D0(31 downto 2) => "000000000000000000000000000000", -- 30 zeros and 2 address bits
		i_D0(1 downto 0) => i_forwardA, 
		i_D1 => x"00000000",
		o_O => s_forwardALong);
s_forwardA <= s_forwardALong(1 downto 0); 

 g_NBITMUX_forwardB: mux2t1_N port map (
		i_S => i_Flush,	
		i_D0(31 downto 2) => "000000000000000000000000000000", -- 30 zeros and 2 address bits
		i_D0(1 downto 0) => i_forwardB, 
		i_D1 => x"00000000",
		o_O => s_forwardBLong);
s_forwardB <= s_forwardBLong(1 downto 0); 

---------------2 bit Muxes End-----------------



---------------4 bit Muxes Start-----------------
 g_NBITMUX_AluCtrl: mux2t1_N port map (
		i_S => i_Flush,	
		i_D0(31 downto 4) => "0000000000000000000000000000", -- 28 zeros and 4 address bits
		i_D0(3 downto 0) => i_AluCtrl, 
		i_D1 => x"00000000",
		o_O => s_AluCtrlLong);
s_AluCtrl <= s_AluCtrlLong(3 downto 0); 


---------------4 bit Muxes End-------------------



---------------5 bit Muxes Start-----------------
 g_NBITMUX_RsAddr: mux2t1_N port map (
		i_S => i_Flush,	
		i_D0(31 downto 5) => "000000000000000000000000000", -- 27 zeros and 5 address bits
		i_D0(4 downto 0) => i_RsAddr, 
		i_D1 => x"00000000",
		o_O => s_RsAddrLong);
s_RsAddr <= s_RsAddrLong(4 downto 0); 

 g_NBITMUX_RtAddr: mux2t1_N port map (
		i_S => i_Flush,	
		i_D0(31 downto 5) => "000000000000000000000000000", -- 27 zeros and 5 address bits
		i_D0(4 downto 0) => i_RtAddr, 
		i_D1 => x"00000000",
		o_O => s_RtAddrLong);
s_RtAddr <= s_RtAddrLong(4 downto 0); 

 g_NBITMUX_RegWrAddr: mux2t1_N port map (
		i_S => i_Flush,	
		i_D0(31 downto 5) => "000000000000000000000000000", -- 27 zeros and 5 address bits
		i_D0(4 downto 0) => i_RegWrAddr, 
		i_D1 => x"00000000",
		o_O => s_RegWrAddrLong);
s_RegWrAddr <= s_RegWrAddrLong(4 downto 0); 
---------------5 bit Muxes End-------------------


---------------16 bit Muxes Start-----------------
 g_NBITMUX_Imm: mux2t1_N port map (
		i_S => i_Flush,	
		i_D0(31 downto 16) => "0000000000000000", -- 27 zeros and 5 address bits
		i_D0(15 downto 0) => i_Imm, 
		i_D1 => x"00000000",
		o_O => s_ImmLong);
s_Imm <= s_ImmLong(15 downto 0);
---------------16 bit Muxes End-------------------


---------------Single Muxes Start-----------------


  g_NBITMUX_Halt: mux2t1 port map (
		i_S => i_Flush,
		i_D0 => i_Halt,
		i_D1 => '0',
		o_O => s_Halt);

  g_NBITMUX_Branch: mux2t1 port map (
		i_S => i_Flush,
		i_D0 => i_Branch,
		i_D1 => '0',
		o_O => s_Branch);

  g_NBITMUX_MemToReg: mux2t1 port map (
		i_S => i_Flush,
		i_D0 => i_MemToReg,
		i_D1 => '0',
		o_O => s_MemToReg);

  g_NBITMUX_RegWr: mux2t1 port map (
		i_S => i_Flush,
		i_D0 => i_RegWr,
		i_D1 => '0',
		o_O => s_RegWr);

  g_NBITMUX_MemWr: mux2t1 port map (
		i_S => i_Flush,
		i_D0 => i_MemWr,
		i_D1 => '0',
		o_O => s_MemWr);

  g_NBITMUX_isJump: mux2t1 port map (
		i_S => i_Flush,
		i_D0 => i_isJump,
		i_D1 => '0',
		o_O => s_isJump);

  g_NBITMUX_isJumpReg: mux2t1 port map (
		i_S => i_Flush,
		i_D0 => i_isJumpReg,
		i_D1 => '0',
		o_O => s_isJumpReg);

  g_NBITMUX_RegDst: mux2t1 port map (
		i_S => i_Flush,
		i_D0 => i_RegDst,
		i_D1 => '0',
		o_O => s_RegDst);
 
  g_NBITMUX_luiCtrl: mux2t1 port map (
		i_S => i_Flush,
		i_D0 => i_luiCtrl,
		i_D1 => '0',
		o_O => s_luiCtrl);

  g_NBITMUX_AluSrc: mux2t1 port map (
		i_S => i_Flush,
		i_D0 => i_AluSrc,
		i_D1 => '0',
		o_O => s_AluSrc);


---------------Single Muxes End-------------------

 Halt: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_Halt,
	      o_Q       => o_Halt);

 Branch: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_Branch,
	      o_Q       => o_Branch);

 MemToReg: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_MemToReg,
	      o_Q       => o_MemToReg);

 RegWr: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_RegWr,
	      o_Q       => o_RegWr);


 MemWr: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_MemWr,
	      o_Q       => o_MemWr);

 isJump: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_isJump,
	      o_Q       => o_isJump);

 isJumpReg: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_isJumpReg,
	      o_Q       => o_isJumpReg);

 RegDst: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_RegDst,
	      o_Q       => o_RegDst);


 luiCtrl: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_luiCtrl,
	      o_Q       => o_luiCtrl);

G_NBit_forwardA: for i in 0 to 1 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_forwardA(i),
	      o_Q       => o_forwardA(i));
  end generate G_NBit_forwardA;

G_NBit_forwardB: for i in 0 to 1 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_forwardB(i),
	      o_Q       => o_forwardB(i));
  end generate G_NBit_forwardB;

 AluSrc: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_AluSrc,
	      o_Q       => o_AluSrc);

G_NBit_RegAluCtrl: for i in 0 to 3 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_AluCtrl(i),
	      o_Q       => o_AluCtrl(i));
  end generate G_NBit_RegAluCtrl;


G_NBit_RegRegWr: for i in 0 to 4 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_RegWrAddr(i),
	      o_Q       => o_RegWrAddr(i));
  end generate G_NBit_RegRegWr;

G_NBit_RegRsAddr: for i in 0 to 4 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_RsAddr(i),
	      o_Q       => o_RsAddr(i));
  end generate G_NBit_RegRsAddr;

G_NBit_RegRtAddr: for i in 0 to 4 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_RtAddr(i),
	      o_Q       => o_RtAddr(i));
  end generate G_NBit_RegRtAddr;

G_NBit_RegIMM: for i in 0 to 15 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_Imm(i),
	      o_Q       => o_Imm(i));
  end generate G_NBit_RegIMM;

  G_NBit_RegInstr: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_Instr(i),
	      o_Q       => o_Instr(i));
  end generate G_NBit_RegInstr;


  G_NBit_RegA: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_A(i),
	      o_Q       => o_A(i));
  end generate G_NBit_RegA;

  G_NBit_RegB: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_B(i),
	      o_Q       => o_B(i));
  end generate G_NBit_RegB;

  G_NBit_RegSX: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_SignExt(i),
	      o_Q       => o_SignExt(i));
  end generate G_NBit_RegSX;

  G_NBit_RegPC: for i in 0 to 31 generate
    REGI: dffg port map(
	      i_CLK     => i_CLK,
	      i_RST     => i_RST,
	      i_WE      => i_WE,
	      i_D       => s_PC(i),
	      o_Q       => o_PC(i));
  end generate G_NBit_RegPC;





  
end structure;
