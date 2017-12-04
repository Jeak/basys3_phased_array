-- Basys 3 Phased Array Controller
-- By Jack Gallegos for CPE 133, Winter 2017, California Polytechnic State University

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    port ( BUTTON_LEFT,BUTTON_RIGHT,BUTTON_CENTER,CLK : in std_logic;
           ELEMENT : out std_logic_vector(9 downto 0) := "0000000000";
           ANODE : out std_logic_vector(3 downto 0);
           CATHODE : out std_logic_vector(7 downto 0);
           NEG : out std_logic); -- 10 elements in this array
end top;
    


architecture Behavioral of top is

-- declare angle FSM
component angle_fsm
    Port ( CLK,LEFT,RIGHT,RST : in std_logic;
           CURRENT_ANGLE : out std_logic_vector(7 downto 0) );
end component; 

-- declare angle display
component angle_display
    Port ( CURRENT_ANGLE : in std_logic_vector(7 downto 0); -- treat the angle as a signed 8-bit number (range -128 to 127 covered)
           CLK   : in std_logic;
           ANODE : out std_logic_vector(3 downto 0);
           CATHODE : out std_logic_vector(7 downto 0)   );
end component;

component time_delay
    Port ( CLK : in std_logic;
           CURRENT_ANGLE : in std_logic_vector(7 downto 0);
           TONE : in std_logic;
           ELEMENT : out std_logic_vector(9 downto 0));
end component;

signal clk_1500hz : std_logic :='0';
signal CURRENT_ANGLE : std_logic_vector(7 downto 0);

begin

FSM : angle_fsm port map (CLK => CLK, LEFT => button_left, RIGHT => button_right, RST => button_center, CURRENT_ANGLE => CURRENT_ANGLE);

DISPLAY : angle_display port map (CLK => CLK, ANODE => ANODE, CATHODE => CATHODE, CURRENT_ANGLE => CURRENT_ANGLE);

DELAY : time_delay port map (CLK => CLK, TONE => clk_1500hz, CURRENT_ANGLE => CURRENT_ANGLE, ELEMENT => ELEMENT);

-- create a 1500 Hz Tone
 tone_gen : process (CLK)
        variable count : unsigned (31 downto 0) := "00000000000000000000000000000000";
    begin
        if rising_edge(CLK) then
            count := count + X"1";
            --if count = X"1" then -- simulation 100mhz
            if count = "00000000000000000000001010011010" then
                clk_1500hz <= not clk_1500hz;
                count := "00000000000000000000000000000000";
            end if;
        end if;
    end process;
 
negative_indicate : process (CURRENT_ANGLE)
    variable angle_int : integer range -90 to 90;
begin
    angle_int := to_integer(signed(CURRENT_ANGLE));
    
    if angle_int >= 0 then
        NEG <= '0';
    else
        NEG <= '1';
    end if;
    
end process;
     




end Behavioral;
