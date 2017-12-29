

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity angle_fsm is
	generic (SIMULATING : boolean );
    Port ( CLK,LEFT,RIGHT,RST : in std_logic;
           CURRENT_ANGLE : out std_logic_vector(7 downto 0);
           CURRENT_ANGLE_INDEX : out std_logic_vector(4 downto 0));
end angle_fsm;

architecture Behavioral of angle_fsm is
    signal clk_sig : std_logic;
	 
	component clock_divider is
		Generic ( DIVISOR : natural ); -- must be even
		Port( 
				CLK : in  std_logic;
				RST : in std_logic;
				HOLDOFF : in std_logic_vector(31 downto 0);
				CLKDIV : out  std_logic);
	end component;
	
	type ram_t is array(natural range <>) of std_logic_vector(7 downto 0);
	constant ram : ram_t(0 to 18) := 
	(
		std_logic_vector(to_signed(-90, 8)),
		std_logic_vector(to_signed(-80, 8)),
		std_logic_vector(to_signed(-70, 8)),
		std_logic_vector(to_signed(-60, 8)),
		std_logic_vector(to_signed(-50, 8)),
		std_logic_vector(to_signed(-40, 8)),
		std_logic_vector(to_signed(-30, 8)),
		std_logic_vector(to_signed(-20, 8)),
		std_logic_vector(to_signed(-10, 8)),
		x"00",
		std_logic_vector(to_signed(10, 8)),
		std_logic_vector(to_signed(20, 8)),
		std_logic_vector(to_signed(30, 8)),
		std_logic_vector(to_signed(40, 8)),
		std_logic_vector(to_signed(50, 8)),
		std_logic_vector(to_signed(60, 8)),
		std_logic_vector(to_signed(70, 8)),
		std_logic_vector(to_signed(80, 8)),
		std_logic_vector(to_signed(90, 8))
	);
	signal ram_addr : natural range 0 to ram'high := 0;
	signal ram_addr2 : natural range 0 to ram'high := 0;
	signal ram_data : std_logic_vector(7 downto 0);
	
begin

	CURRENT_ANGLE_INDEX <= std_logic_vector(to_unsigned(ram_addr, CURRENT_ANGLE_INDEX'length));

-- create a 1.5hz clock
slow_clock_gen: clock_divider 
generic map ( DIVISOR => 66666666 )
PORT MAP(
	CLK => CLK,
	RST => '0',
	HOLDOFF => (others => '0'),
	CLKDIV => clk_sig
);
-- NOTE: clk_sig is not a real clock! In other words it
-- can't be used to drive the CLK input of a flip flop.
-- That's why I use it within the if statements below
-- instead of in the process sensitivity list.


	ram_proc : process(CLK) is
	begin
	if(rising_edge(CLK)) then
		ram_addr2 <= ram_addr;
		ram_data <= ram(ram_addr2);
	end if;
	end process;

	CURRENT_ANGLE <= ram_data;

	angle_logic : process(CLK) is
	begin
	if(rising_edge(CLK)) then
		if(RST = '1') then
			ram_addr <= 9; -- angle=0
		else
			if(LEFT = '1' and (clk_sig = '1' or simulating)) then
				if(ram_addr = 0) then
					ram_addr <= ram'high;
				else
					ram_addr <= ram_addr - 1;
				end if;
			elsif(RIGHT = '1' and (clk_sig = '1' or simulating)) then
				if(ram_addr = ram'high) then
					ram_addr <= 0;
				else
					ram_addr <= ram_addr + 1;
				end if;
			end if;
		end if;
	end if;
	end process;

	

end Behavioral;
