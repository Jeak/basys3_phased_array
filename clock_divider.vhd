----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:10:41 12/20/2017 
-- Design Name: 
-- Module Name:    clock_divider - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_divider is
	Generic ( DIVISOR : natural ); -- must be even
	Port( 
			CLK : in  std_logic;
			RST : in std_logic;
			HOLDOFF : in std_logic_vector(31 downto 0);
			CLKDIV : out  std_logic);
end clock_divider;

architecture Behavioral of clock_divider is
	signal count : natural := 0;
	signal clkout : std_logic := '0';
	-- Each time DIVISOR is hit, the internal register changes
	-- state. So we're dividing down by a factor of 2 more than
	-- the input DIVISOR
	constant actual_divisor : natural := DIVISOR / 2;
begin
	check_divisor : assert (DIVISOR mod 2 = 0) report "clock_divider:DIVISOR must be even" severity FAILURE;

	process(CLK) is
	begin
	if(rising_edge(CLK)) then
		if(count = actual_divisor-1) then
			clkout <= not clkout;
			count <= 0;
		else
			count <= count + 1;
		end if;
	end if;
	end process;
	
	CLKDIV <= clkout;

end Behavioral;

