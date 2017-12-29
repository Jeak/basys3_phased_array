--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:20:10 12/20/2017
-- Design Name:   
-- Module Name:   C:/Users/Steven/Desktop/basys3_phased_array//angle_fsm_tb.vhd
-- Project Name:  project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: angle_fsm
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY angle_fsm_tb IS
END angle_fsm_tb;
 
ARCHITECTURE behavior OF angle_fsm_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT angle_fsm
	generic (SIMULATING : boolean );
    PORT(
         CLK : IN  std_logic;
         LEFT : IN  std_logic;
         RIGHT : IN  std_logic;
         RST : IN  std_logic;
         CURRENT_ANGLE : OUT  std_logic_vector(7 downto 0);
			CURRENT_ANGLE_INDEX : out std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal LEFT : std_logic := '0';
   signal RIGHT : std_logic := '0';
   signal RST : std_logic := '0';

 	--Outputs
   signal CURRENT_ANGLE : std_logic_vector(7 downto 0);
   signal CURRENT_ANGLE_INDEX : std_logic_vector(4 downto 0);


	signal count : natural := 0;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: angle_fsm 
	generic map ( SIMULATING => true )
	PORT MAP (
          CLK => CLK,
          LEFT => LEFT,
          RIGHT => RIGHT,
          RST => RST,
          CURRENT_ANGLE => CURRENT_ANGLE,
          CURRENT_ANGLE_INDEX => CURRENT_ANGLE_INDEX
        );
	CLK <= not CLK after 4 ns;
	
	
	process(CLK) is
	begin
	if(rising_edge(CLK)) then
		count <= count + 1;
		
		if(count mod 8 = 0) then
			if(count < 165) then
				LEFT <= '1';
			else
				RIGHT <= '1';
			end if;
		else
			LEFT <= '0';
			RIGHT <= '0';
		end if;
	end if;
	end process;
	

END;
