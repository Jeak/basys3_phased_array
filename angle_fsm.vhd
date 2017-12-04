

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity angle_fsm is
    Port ( CLK,LEFT,RIGHT,RST : in std_logic;
           CURRENT_ANGLE : out std_logic_vector(7 downto 0) );
end angle_fsm;

architecture Behavioral of angle_fsm is
    signal PS,NS : std_logic_vector(7 downto 0) := "00000000"; --8 bit signed to represent value (range: -90 to +90), defaults to 0
    signal clk_sig : std_logic;
begin

-- create a 1.5hz clock
 slow_clock_gen : process (CLK)
        variable count : unsigned (31 downto 0) := "00000000000000000000000000000000";
    begin
        if rising_edge(CLK) then
            count := count + X"1";
            --if count = X"1" then -- simulation 100mhz
            if count = "11111110010100000010101010" then -- create a 1.5hz clock
                clk_sig <= not clk_sig;
                count := "00000000000000000000000000000000";
            end if;
        end if;
    end process;


-- only update state when buttons change get pressed and on rising edge of clock for speed
    update_state : process (clk_sig)
        begin
            if (rising_edge(clk_sig)) then
                PS <= NS;
            end if;
       end process;
       
-- angle logic (completely combinatorial)
       angle_logic : process (LEFT,RIGHT,RST,PS)
       begin
       ------------------------------
       -- PS        | Angle (degrees)
       -- 10100110  | -90
       -- 10110000  | -80
       -- 10111010  | -70
       -- 11000100  | -60
       -- 11001110  | -50
       -- 11011000  | -40
       -- 11100010  | -30
       -- 11101100  | -20
       -- 11110110  | -10
       -- 00000000  | 0
       -- 00001010  | 10
       -- 00010100  | 20
       -- 00011110  | 30
       -- 00101000  | 40
       -- 00110010  | 50
       -- 00111100  | 60
       -- 01000110  | 70
       -- 01010000  | 80
       -- 01011010  | 90
       ------------------------------
       NS <= PS;
            case (PS) is
                when "10100110" =>
                    CURRENT_ANGLE <= "10100110"; -- -90 degrees
                    if LEFT = '1' then -- go left
                        NS <= "10100110"; -- still -90 degrees                   
                    elsif RIGHT = '1' then -- go right
                        NS <= "10110000"; -- -80 degrees
                    elsif RST = '1' then -- goto 0   
                        NS <= "00000000"; -- 0 degrees
                    end if;
                
                when "10110000" => 
                    CURRENT_ANGLE <= "10110000";-- -80 degrees
                    if LEFT = '1' then -- go left
                        NS <= "10100110"; -- -90 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "10111010"; -- -70 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees
                    end if;
                    
                when "10111010" =>
                    CURRENT_ANGLE <= "10111010"; -- -70 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "10110000"; -- -80 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "11000100"; -- -60 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees
                    end if;   
                            
                when "11000100" => 
                    CURRENT_ANGLE <= "11000100"; -- -60 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "10111010"; -- -70 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "11001110"; -- -50 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees
                    end if;   

                when "11001110" =>
                    CURRENT_ANGLE <= "11001110"; -- -50 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "11000100"; -- -60 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "11011000"; -- -40 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees
                    end if;

                when "11011000" => 
                    CURRENT_ANGLE <= "11011000"; -- -40 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "11001110"; -- -50 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "11100010"; -- -30 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees
                    end if;

                when "11100010" =>
                    CURRENT_ANGLE <= "11100010"; -- -30 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "11011000"; -- -40 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "11101100"; -- -20 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees
                    end if;

                when "11101100" =>
                    CURRENT_ANGLE <= "11101100"; -- -20 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "11100010"; -- -30 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "11110110"; -- -10 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees
                    end if;

                when "11110110" =>
                    CURRENT_ANGLE <= "11110110"; -- -10 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "11101100"; -- -20 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "00000000"; -- 0 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees
                    end if;

                when "00000000" =>
                    CURRENT_ANGLE <= "00000000"; -- 0 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "11110110"; -- -10 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "00001010"; -- 10 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees
                    end if;

                when "00001010" =>
                    CURRENT_ANGLE <= "00001010"; -- 10 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "00000000"; -- 0 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "00010100"; -- 20 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees
                    end if;

                when "00010100" =>
                    CURRENT_ANGLE <= "00010100"; -- 20 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "00001010"; -- 10 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "00011110"; -- 30 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees
                    end if;

                when "00011110" =>
                    CURRENT_ANGLE <= "00011110"; -- 30 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "00010100"; -- 20 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "00101000"; -- 40 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees 
                    end if;

                when "00101000" =>
                    CURRENT_ANGLE <= "00101000"; -- 40 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "00011110"; -- 30 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "00110010"; -- 50 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees
                    end if;

                when "00110010" =>
                    CURRENT_ANGLE <= "00110010"; -- 50 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "00101000"; -- 40 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "00111100"; -- 60 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees 
                    end if;

                when "00111100" =>
                    CURRENT_ANGLE <= "00111100"; -- 60 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "00110010"; -- 50 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "01000110"; -- 70 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees 
                    end if;

                when "01000110" =>
                    CURRENT_ANGLE <= "01000110"; -- 70 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "00111100"; -- 60 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "01010000"; -- 80 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees
                    end if;

                when "01010000" =>
                    CURRENT_ANGLE <= "01010000"; -- 80 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "01000110"; -- 70 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "01011010"; -- 90 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees
                    end if;

                when "01011010" =>
                    CURRENT_ANGLE <= "01011010"; -- 90 degrees     
                    if LEFT = '1' then -- go left
                        NS <= "01010000"; -- 80 degrees
                    elsif RIGHT = '1' then -- go right
                        NS <= "01011010"; -- 90 degrees
                    elsif RST = '1' then -- goto 0
                        NS <= "00000000"; -- 0 degrees
                    end if;
                       
                when others => -- failsafe case
                    CURRENT_ANGLE <= "00000000";
                    NS <= "00000000";
            end case;
       end process;

end Behavioral;
