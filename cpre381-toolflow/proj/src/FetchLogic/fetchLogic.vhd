------------------------------------------------------------------------
-- Corey Heithoff
-- CprE 381
-- Iowa State University
-------------------------------------------------------------------------


-- fetchLogic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the project1 implementation of the
-- fetch logic
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity fetchLogic is
   port(i_CLK           : in std_logic;
	i_RST           : in std_logic; 
--	is_Brch         : in std_logic; 
--	is_Jump         : in std_logic; 
--	is_JumpReg      : in std_logic;
--	is_zero		: in std_logic;
	i_fetchsel	: in std_logic_vector(1 downto 0);
	i_instr         : in std_logic_vector(31 downto 0);
	i_immed         : in std_logic_vector(31 downto 0);
	i_rs_data       : in std_logic_vector(31 downto 0);
	i_PCplusFour	: in std_logic_vector(31 downto 0);
	o_PC		: out std_logic_vector(31 downto 0));
end fetchLogic;

architecture structural of fetchLogic is


  --component mux2t1_N is
  --  port(i_S                  : in std_logic;
  --       i_D0                 : in std_logic_vector(31 downto 0);
  --       i_D1                 : in std_logic_vector(31 downto 0);
  --       o_O                  : out std_logic_vector(31 downto 0));
  --end component;


  component adder_N
    generic(N : integer := 32); 
    port(i_C          : in std_logic;
         i_A          : in std_logic_vector(N-1 downto 0);
         i_B          : in std_logic_vector(N-1 downto 0);
         o_S          : out std_logic_vector(N-1 downto 0);
         o_C          : out std_logic);
  end component;


  --component andg2
  --  port(i_A          : in std_logic;
  --       i_B          : in std_logic;
  --       o_F          : out std_logic);
  --end component;

  component mux4t1_32 is
    port(i_S          : in std_logic_vector(1 downto 0);
       i_D0         : in std_logic_vector(31 downto 0);
       i_D1         : in std_logic_vector(31 downto 0);
       i_D2         : in std_logic_vector(31 downto 0);
       i_D3         : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
  end component;


signal so_bshftI, so_bshftJ, so_Sum_I, si_PC, so_PC4_I, so_PC4_I_J         : std_logic_vector(31 downto 0);
signal so_Car_I, so_Car_PC4, ss_Brch 							: std_logic;
signal fetchsel : std_logic_vector(1 downto 0);




begin



g_NBITADDER_I: adder_N port map (
	    	i_C => '0',
	    	i_A => i_PCplusFour,
	    	i_B(31 downto 2) => i_immed(29 downto 0), -- I-Format immediate shifted left by 2
		i_B(1 downto 0) => "00", 
	    	o_S => so_Sum_I,	-- adds shifted I-format immediate and PC + 4
	    	o_C => so_Car_I);

--g_NBITMUX_Brch: mux2t1_N port map (
	--	i_S => ss_Brch,	-- 0 for PC + 4, and 1 for I-format Immediate
--		i_D0 => i_PCplusFour,   
	--	i_D1 => so_Sum_I, 
	--	o_O => so_PC4_I);


--g_NBITMUX_Jump: mux2t1_N port map (
--		i_S => is_Jump,		-- 0 for (PC + 4 or I-Immed) and 1 for J-format Address
--		i_D0 => so_PC4_I,   
--		i_D1(31 downto 28) => i_PCplusFour(31 downto 28), -- taking first four bits of (PC + 4) and (the last 16 bits of J-format instruction (address) shifted left by 2)
--		i_D1(27 downto 2) => i_instr(25 downto 0),
--		i_D1(1 downto 0) => "00",
--		o_O => so_PC4_I_J);


--g_NBITMUX_JumpReg: mux2t1_N port map (
--		i_S => is_JumpReg,	-- 0 for (PC + 4 or I-Immed or J-Addr) and 1 for Jump Register
--		i_D0 => so_PC4_I_J,   
--		i_D1 => i_rs_data, 
--		o_O => o_PC);

--g_ADD: andg2 port map (
--		i_A => is_brch,
--		i_B => is_zero,
--		o_F => ss_Brch); -- select signals for branching

--process_label : process (is_brch, is_zero, is_Jump, is_JumpReg)
--	begin

--if ((is_brch = '1') and (is_zero = '1')) then
--	fetchsel <= "01";
--elsif is_Jump then
--	fetchsel <= "10";
--elsif is_JumpReg then
--	fetchsel <= "11";
--else
--	fetchsel <= "00";
--end if;

--end process;


fetch_mux : mux4t1_32 port map (
       i_S          => i_fetchsel, -- optimization
       i_D0         => i_PCplusFour,
       i_D1         => so_Sum_I, 
       i_D2	    => i_instr,
       --i_D2(31 downto 28) => i_PCplusFour(31 downto 28), -- taking first four bits of (PC + 4) and (the last 16 bits of J-format instruction (address) shifted left by 2)
       --i_D2(27 downto 0) => i_instr(27 downto 0),
       i_D3         => i_rs_data, 
       o_O          => o_PC );
		

--o_PC <= si_PC;
 


end structural;
