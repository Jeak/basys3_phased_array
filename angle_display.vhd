

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

signal clk_240 : std_logic := '0';
signal SEL : std_logic := '0';
signal MUX_INPUT : std_logic_vector(7 downto 0);
signal MUX_OUTPUT : std_logic_vector(3 downto 0);

begin

CATHODE(0) <= '1'; -- turn off decimal point

process(CURRENT_ANGLE) is -- take absolute value of current angle, because negative sign is tears and sadness
begin
    MUX_INPUT <= std_logic_vector(abs(signed(CURRENT_ANGLE)));
end process;

-- create a 240 hz tone
 tone_gen : process (CLK)
        variable count : unsigned (31 downto 0) := "00000000000000000000000000000000";
    begin
        if rising_edge(CLK) then
            count := count + X"1";
            --if count = X"1" then -- simulation 100mhz
            if count = "00000000000001100101101110011011" then -- create a 240hz clock
                clk_240 <= not clk_240;
                count := "00000000000000000000000000000000";
            end if;
        end if;
    end process;
    
mux_switches : process (SEL) -- choose which set
begin
    case (SEL) is
        when '0' => MUX_OUTPUT <= MUX_INPUT(3 downto 0);
        when '1' => MUX_OUTPUT <= MUX_INPUT(7 downto 4);
    end case; 
end process;       

anode_selector : process (clk_240)
    variable count : unsigned (0 downto 0) := "0"; 
begin
    if rising_edge(clk_240) then
        count := count + 1;
        case count is
            -- anode (digit) selecred gets pulled to a 0 (one-cold)
            when "0" =>
            -- select digit 0
            SEL <= '0';
            ANODE <= "1110";
            
            when "1" =>
            -- select digit 1
            SEL <= '1';
            ANODE <= "1101";
        end case;            
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
