
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
    shared variable delay : integer range -500000 to 500000;
	 
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
		( 333333*0, 333333*1, 333333*2, 333333*3, 333333*4, 333333*5, 333333*6, 333333*7, 333333*8, 333333*9 ),
		( 328269*0, 328269*1, 328269*2, 328269*3, 328269*4, 328269*5, 328269*6, 328269*7, 328269*8, 328269*9 ),
		( 313230*0, 313230*1, 313230*2, 313230*3, 313230*4, 313230*5, 313230*6, 313230*7, 313230*8, 313230*9 ),
		( 288675*0, 288675*1, 288675*2, 288675*3, 288675*4, 288675*5, 288675*6, 288675*7, 288675*8, 288675*9 ),
		( 255348*0, 255348*1, 255348*2, 255348*3, 255348*4, 255348*5, 255348*6, 255348*7, 255348*8, 255348*9 ),
		( 214262*0, 214262*1, 214262*2, 214262*3, 214262*4, 214262*5, 214262*6, 214262*7, 214262*8, 214262*9 ),
		( 166666*0, 166666*1, 166666*2, 166666*3, 166666*4, 166666*5, 166666*6, 166666*7, 166666*8, 166666*9 ),
		( 114006*0, 114006*1, 114006*2, 114006*3, 114006*4, 114006*5, 114006*6, 114006*7, 114006*8, 114006*9 ),
		(  57882*0,  57882*1,  57882*2,  57882*3,  57882*4,  57882*5,  57882*6,  57882*7,  57882*8,  57882*9 ),
		(      0*0,      0*1,      0*2,      0*3,      0*4,      0*5,      0*6,      0*7,      0*8,      0*9 ),
		(  57882*9,  57882*8,  57882*7,  57882*6,  57882*5,  57882*4,  57882*3,  57882*2,  57882*1,  57882*0 ),
		( 114006*9, 114006*8, 114006*7, 114006*6, 114006*5, 114006*4, 114006*3, 114006*2, 114006*1, 114006*0 ),
		( 166666*9, 166666*8, 166666*7, 166666*6, 166666*5, 166666*4, 166666*3, 166666*2, 166666*1, 166666*0 ),
		( 214262*9, 214262*8, 214262*7, 214262*6, 214262*5, 214262*4, 214262*3, 214262*2, 214262*1, 214262*0 ),
		( 255348*9, 255348*8, 255348*7, 255348*6, 255348*5, 255348*4, 255348*3, 255348*2, 255348*1, 255348*0 ),
		( 288675*9, 288675*8, 288675*7, 288675*6, 288675*5, 288675*4, 288675*3, 288675*2, 288675*1, 288675*0 ),
		( 313230*9, 313230*8, 313230*7, 313230*6, 313230*5, 313230*4, 313230*3, 313230*2, 313230*1, 313230*0 ),
		( 328269*9, 328269*8, 328269*7, 328269*6, 328269*5, 328269*4, 328269*3, 328269*2, 328269*1, 328269*0 ),
		( 333333*9, 333333*8, 333333*7, 333333*6, 333333*5, 333333*4, 333333*3, 333333*2, 333333*1, 333333*0 )
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
	end if;
	end process;
	
	-- Now we need N resettable clock dividers with the reset time configurable
	
	gen_clocks : for i in 0 to 9 generate
	
		a_clock: clock_divider 
		generic map ( DIVISOR => 66666 ) -- here's where you set the frequency of the audio
		PORT MAP(
			CLK => CLK,
			RST => angle_changed,
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
