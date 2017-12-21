--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:13:19 12/20/2017
-- Design Name:   
-- Module Name:   C:/Users/Steven/Desktop/basys3_phased_array//clock_divider_tb.vhd
-- Project Name:  project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clock_divider
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
USE ieee.numeric_std.ALL;
 
ENTITY clock_divider_tb IS
END clock_divider_tb;
 
ARCHITECTURE behavior OF clock_divider_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clock_divider
	 generic ( DIVISOR : natural );
    PORT(
         CLK : IN  std_logic;
			RST : in std_logic;
			HOLDOFF : in std_logic_vector(31 downto 0);
         CLKDIV : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
	signal HOLDOFF : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(5, 32));

 	--Outputs
   signal CLKDIV : std_logic;

	constant DIVISOR : natural := 4;

	signal count : natural := 0;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clock_divider 
	generic map ( DIVISOR => DIVISOR )
	PORT MAP (
          CLK => CLK,
			 RST => RST,
			 HOLDOFF => HOLDOFF,
          CLKDIV => CLKDIV
        );

	CLK <= not CLK after 4 ns;
	
	process(CLK) is
	begin
	if(rising_edge(CLK)) then
		count <= count + 1;
		if(count = 20) then
			RST <= '1';
		else
			RST <= '0';
		end if;
	end if;
	end process;

END;
