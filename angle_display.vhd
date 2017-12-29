

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity angle_display is
    Port ( CURRENT_ANGLE : in std_logic_vector(7 downto 0); -- treat the angle as a signed 8-bit number (range -128 to 127 covered)
           CLK   : in std_logic;
           ANODE : out std_logic_vector(3 downto 0);
           CATHODE : out std_logic_vector(7 downto 0)   );
end angle_display;

architecture Behavioral of angle_display is

	component clock_divider is
		Generic ( DIVISOR : natural ); -- must be even
		Port( 
				CLK : in  std_logic;
				RST : in std_logic;
				HOLDOFF : in std_logic_vector(31 downto 0);
				CLKDIV : out  std_logic);
	end component;

signal clk_240 : std_logic := '0';
signal clk_240_old : std_logic := '0';
signal display_update : std_logic := '0';
signal SEL : std_logic := '0';
signal MUX_INPUT : std_logic_vector(7 downto 0);
signal MUX_OUTPUT : std_logic_vector(3 downto 0);
signal toggle : std_logic := '0';

begin

CATHODE(0) <= '1'; -- turn off decimal point

-- take absolute value of current angle, because negative sign is tears and sadness
-- (high bit is the sign bit; just set to 0 to get a positive number)
MUX_INPUT <= "0" & CURRENT_ANGLE(6 downto 0);

-- create a 240 hz tone
tone_gen: clock_divider 
generic map ( DIVISOR => 416666 )
PORT MAP(
	CLK => CLK,
	RST => '0',
	HOLDOFF => (others => '0'),
	CLKDIV => clk_240
);

-- detect rising edge of clk_240
process(CLK) is
begin
if(rising_edge(CLK)) then
	clk_240_old <= clk_240;
end if;
end process;
display_update <= clk_240 and not clk_240_old;



    
mux_switches : process (SEL) -- choose which set
begin
    case (SEL) is
        when '0' => MUX_OUTPUT <= MUX_INPUT(3 downto 0);
        when '1' => MUX_OUTPUT <= MUX_INPUT(7 downto 4);
		  when others => MUX_OUTPUT <= (others => '0');
    end case; 
end process;       

anode_selector : process (CLK)
begin
	if rising_edge(CLK) then
		if(display_update = '1') then
			toggle <= not toggle;
			if(toggle = '0') then
				-- anode (digit) selecred gets pulled to a 0 (one-cold)
				-- select digit 0
				SEL <= '0';
				ANODE <= "1110";
			elsif(toggle = '1') then
				-- select digit 1
				SEL <= '1';
				ANODE <= "1101";
			end if;  
		end if;
	end if;
end process;

seven_segment_decoder : process(MUX_OUTPUT) begin
    case (MUX_OUTPUT) is
        -- case statement from professor advanced FSM example, credit to Prof. Hummel
        when "0000" => CATHODE(7 downto 1) <= "0000001"; -- 0
        when "0001" => CATHODE(7 downto 1) <= "1001111"; -- 1
        when "0010" => CATHODE(7 downto 1) <= "0010010"; -- 2
        when "0011" => CATHODE(7 downto 1) <= "0000110"; -- 3
        when "0100" => CATHODE(7 downto 1) <= "1001100"; -- 4
        when "0101" => CATHODE(7 downto 1) <= "0100100"; -- 5
        when "0110" => CATHODE(7 downto 1) <= "0100000"; -- 6
        when "0111" => CATHODE(7 downto 1) <= "0001111"; -- 7
        when "1000" => CATHODE(7 downto 1) <= "0000000"; -- 8
        when "1001" => CATHODE(7 downto 1) <= "0001100"; -- 9
        when "1010" => CATHODE(7 downto 1) <= "0001000"; -- A
        when "1011" => CATHODE(7 downto 1) <= "1100000"; -- b
        when "1100" => CATHODE(7 downto 1) <= "0110001"; -- C
        when "1101" => CATHODE(7 downto 1) <= "1000010"; -- d
        when "1110" => CATHODE(7 downto 1) <= "0110000"; -- E
        when "1111" => CATHODE(7 downto 1) <= "0111000"; -- F    
        when others => CATHODE(7 downto 1) <= "1111111"; -- blank (should never occur)    
    end case;
end process;


end Behavioral;
