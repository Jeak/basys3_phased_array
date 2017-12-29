
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity time_delay is
    Port ( CLK : in std_logic;
           CURRENT_ANGLE : in std_logic_vector(7 downto 0);
           CURRENT_ANGLE_INDEX : in std_logic_vector(4 downto 0);
           ELEMENT : out std_logic_vector(9 downto 0));
end time_delay;

architecture Behavioral of time_delay is
    signal element_sig : std_logic_vector(9 downto 0) := "0000000000";
    signal rst : std_logic := '0';
    -- create a shared variable
    signal count : integer range -500000 to 500000;
	 signal old_current_angle : std_logic_vector(7 downto 0) := (others => '0');
	 signal angle_changed : std_logic := '0';
	 signal angle_changed_delay : std_logic := '0';
	 
	 signal count_local0 : unsigned(31 downto 0) := (others => '0');
	 signal count_local1 : unsigned(31 downto 0) := (others => '0');
	 signal count_local2 : unsigned(31 downto 0) := (others => '0');
	 signal count_local3 : unsigned(31 downto 0) := (others => '0');
	 signal count_local4 : unsigned(31 downto 0) := (others => '0');
	 signal count_local5 : unsigned(31 downto 0) := (others => '0');
	 signal count_local6 : unsigned(31 downto 0) := (others => '0');
	 signal count_local7 : unsigned(31 downto 0) := (others => '0');
	 signal count_local8 : unsigned(31 downto 0) := (others => '0');
	 signal count_local9 : unsigned(31 downto 0) := (others => '0');
	 
	 -- 2d array of delay vs element number & angle.
	 -- The outer index (0 to 18) is the angle, and the inner index (0 to 9) is the element.
	 -- I'm not sure if I got the sign right here: does row 0 correspond to -90 or +90 deg?
	 type row is array(0 to 9) of natural;
	 type ram_t is array(0 to 18) of row;
	 constant delay_ram : ram_t :=
	 (
		( 33333*0, 33333*1, 33333*2, 33333*3, 33333*4, 33333*5, 33333*6, 33333*7, 33333*8, 33333*9 ), 
		( 32826*0, 32826*1, 32826*2, 32826*3, 32826*4, 32826*5, 32826*6, 32826*7, 32826*8, 32826*9 ),  
		( 31323*0, 31323*1, 31323*2, 31323*3, 31323*4, 31323*5, 31323*6, 31323*7, 31323*8, 31323*9 ),
		( 28867*0, 28867*1, 28867*2, 28867*3, 28867*4, 28867*5, 28867*6, 28867*7, 28867*8, 28867*9 ),
		( 25534*0, 25534*1, 25534*2, 25534*3, 25534*4, 25534*5, 25534*6, 25534*7, 25534*8, 25534*9 ),
		( 21426*0, 21426*1, 21426*2, 21426*3, 21426*4, 21426*5, 21426*6, 21426*7, 21426*8, 21426*9 ),
		( 16666*0, 16666*1, 16666*2, 16666*3, 16666*4, 16666*5, 16666*6, 16666*7, 16666*8, 16666*9 ),
		( 11400*0, 11400*1, 11400*2, 11400*3, 11400*4, 11400*5, 11400*6, 11400*7, 11400*8, 11400*9 ),
		(  5788*0,  5788*1,  5788*2,  5788*3,  5788*4,  5788*5,  5788*6,  5788*7,  5788*8,  5788*9 ),
		(     0*0,     0*1,     0*2,     0*3,     0*4,     0*5,     0*6,     0*7,     0*8,     0*9 ),
		(  5788*9,  5788*8,  5788*7,  5788*6,  5788*5,  5788*4,  5788*3,  5788*2,  5788*1,  5788*0 ),
		( 11400*9, 11400*8, 11400*7, 11400*6, 11400*5, 11400*4, 11400*3, 11400*2, 11400*1, 11400*0 ),
		( 16666*9, 16666*8, 16666*7, 16666*6, 16666*5, 16666*4, 16666*3, 16666*2, 16666*1, 16666*0 ),
		( 21426*9, 21426*8, 21426*7, 21426*6, 21426*5, 21426*4, 21426*3, 21426*2, 21426*1, 21426*0 ),
		( 25534*9, 25534*8, 25534*7, 25534*6, 25534*5, 25534*4, 25534*3, 25534*2, 25534*1, 25534*0 ),
		( 28867*9, 28867*8, 28867*7, 28867*6, 28867*5, 28867*4, 28867*3, 28867*2, 28867*1, 28867*0 ),
		( 31323*9, 31323*8, 31323*7, 31323*6, 31323*5, 31323*4, 31323*3, 31323*2, 31323*1, 31323*0 ),
		( 32826*9, 32826*8, 32826*7, 32826*6, 32826*5, 32826*4, 32826*3, 32826*2, 32826*1, 32826*0 ),
		( 33333*9, 33333*8, 33333*7, 33333*6, 33333*5, 33333*4, 33333*3, 33333*2, 33333*1, 33333*0 )
	 );
	 signal element_data : row;
	 signal ram_addr : natural range 0 to 18 := 0;
	 
	component clock_divider is
		Generic ( DIVISOR : natural ); -- must be even
		Port( 
				CLK : in  std_logic;
				RST : in std_logic;
				HOLDOFF : in std_logic_vector(31 downto 0);
				CLKDIV : out  std_logic);
	end component;
	 
begin

	-- When making a large lookup table, it is vastly preferred to read out the data with a clocked process.
	-- This gives the synthesis tool the opportunity to put all the data into a bram if it prefers, or at the
	-- very least a bunch of flip flops. It takes a ton of logic to pull data out of a large array so using
	-- flip flops or bram will greatly improve timing performance.
	process(CLK) is
	begin
	if(rising_edge(CLK)) then
		ram_addr <= to_integer(unsigned(CURRENT_ANGLE_INDEX));
		element_data <= delay_ram(ram_addr);
	end if;
	end process;
	
	
	-- Since we want to trigger a reset when changing angles, let's make an edge detector
	process(CLK) is
	begin
	if(rising_edge(CLK)) then
		old_current_angle <= CURRENT_ANGLE;
		if(old_current_angle /= CURRENT_ANGLE) then
			angle_changed <= '1';
		else
			angle_changed <= '0';
		end if;
		angle_changed_delay <= angle_changed;
	end if;
	end process;
	
	-- Now we need N resettable clock dividers with the reset time configurable
	
	gen_clocks : for i in 0 to 9 generate
	
		a_clock: clock_divider 
		generic map ( DIVISOR => 66666 ) -- here's where you set the frequency of the audio
		PORT MAP(
			CLK => CLK,
			RST => angle_changed_delay,
			HOLDOFF => std_logic_vector(to_unsigned(element_data(i), 32)), -- this is the clever bit
			CLKDIV => element_sig(i)
		);
	
	end generate gen_clocks;
	
    
	ELEMENT <= element_sig;
	
	
	
	
--------------
---- Time delay is element to element
---- Here's a chart of time delay in seconds. Note that if time delay is negative
---- start with the highest numbered element, i.e #9 instead of #0
---- remember 1 clock period = 10 ns = 1*10^-9 s
---- delay in s = clock cycles * clock period
---- conversely clock cycles = delay in s / clock period
--     
---- Time delay in seconds    | angle | clock cycles
---- -0.000333333333333       |-90    |333333.333333
---- -0.000328269251004       |-80    |328269.251004
---- -0.000313230873595       |-70    |313230.873595
---- -0.000288675134595       |-60    |288675.134595
---- -0.000255348147706       |-50    |255348.147706
---- -0.000214262536562       |-40    |214262.536562
---- -0.000166666666667       |-30    |166666.666667
---- -0.000114006714442       |-20    |114006.714442
---- -0.000057882725889       |-10    |57882.725889
---- 0                        |0      |0
---- 0.000057882725889        |10     |57882.725889
---- 0.000114006714442        |20     |114006.714442
---- 0.000166666666667        |30     |166666.666667
---- 0.000214262536562        |40     |214262.536562
---- 0.000255348147706        |50     |255348.147706
---- 0.000288675134595        |60     |288675.134595
---- 0.000313230873595        |70     |313230.873595
---- 0.000328269251004        |80     |328269.251004
---- 0.000333333333333        |90     |333333.333333


end Behavioral;
