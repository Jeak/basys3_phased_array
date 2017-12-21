
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
begin
    
    element <= element_sig;
------------
-- Time delay is element to element
-- Here's a chart of time delay in seconds. Note that if time delay is negative
-- start with the highest numbered element, i.e #9 instead of #0
-- remember 1 clock period = 10 ns = 1*10^-9 s
-- delay in s = clock cycles * clock period
-- conversely clock cycles = delay in s / clock period
     
-- Time delay in seconds    | angle | clock cycles
-- -0.000333333333333       |-90    |333333.333333
-- -0.000328269251004       |-80    |328269.251004
-- -0.000313230873595       |-70    |313230.873595
-- -0.000288675134595       |-60    |288675.134595
-- -0.000255348147706       |-50    |255348.147706
-- -0.000214262536562       |-40    |214262.536562
-- -0.000166666666667       |-30    |166666.666667
-- -0.000114006714442       |-20    |114006.714442
-- -0.000057882725889       |-10    |57882.725889
-- 0                        |0      |0
-- 0.000057882725889        |10     |57882.725889
-- 0.000114006714442        |20     |114006.714442
-- 0.000166666666667        |30     |166666.666667
-- 0.000214262536562        |40     |214262.536562
-- 0.000255348147706        |50     |255348.147706
-- 0.000288675134595        |60     |288675.134595
-- 0.000313230873595        |70     |313230.873595
-- 0.000328269251004        |80     |328269.251004
-- 0.000333333333333        |90     |333333.333333


-- create a counter that only resets when current_angle changes
counter : process (CLK)
begin
	if rising_edge(CLK) then
		old_current_angle <= CURRENT_ANGLE;
		if(CURRENT_ANGLE /= old_current_angle) then
			count <= -500000;
		else
			if count < 500000 then
				count <= count + 1;
			end if;
		end if;
	end if;
end process;

-- run when current angle changes
angle_delay : process (CURRENT_ANGLE)

begin
    case (CURRENT_ANGLE) is
                when "10100110" =>
                    delay := -333333;    
                
                when "10110000" => 
                    delay := -328269;
                    
                when "10111010" =>
                    delay := -313230;
                            
                when "11000100" => 
                    delay := -288675;  

                when "11001110" =>
                    delay := -255348;

                when "11011000" => 
                    delay := -214262; 

                when "11100010" =>
                    delay := -166666;

                when "11101100" =>
                    delay := -114006;

                when "11110110" =>
                    delay := -57882;

                when "00000000" =>
                    delay := 0;

                when "00001010" =>
                    delay := 57882;

                when "00010100" =>
                    delay := 114006;
                    
                when "00011110" =>
                    delay := 166666;

                when "00101000" =>
                    delay := 214262;

                when "00110010" =>
                    delay := 255348;

                when "00111100" =>
                    delay := 288675; 

                when "01000110" =>
                    delay := 313230;

                when "01010000" =>
                    delay := 328269;

                when "01011010" =>
                    delay := 333333;
                       
                when others => -- failsafe case
            end case;
end process;


clockgen_0 : process (CLK)
begin
    if (rising_edge(CLK) and (count >= (delay * 0))) then
                count_local0 <= count_local0 + X"1";
                --if count = X"1" then -- simulation 100mhz
                if count_local0 = ("00000000000000010000010001101010" / 2) then
                    element_sig(0) <= not element_sig(0);
                    count_local0 <= "00000000000000000000000000000000";
                end if;
            end if;          
end process;

clockgen_1 : process (CLK)
begin
    if (rising_edge(CLK) and (count >= (delay * 1))) then
                count_local1 <= count_local1 + X"1";
                --if count = X"1" then -- simulation 100mhz
                if count_local1 = ("00000000000000010000010001101010" / 2) then
                    element_sig(1) <= not element_sig(1);
                    count_local1 <= "00000000000000000000000000000000";
                end if;
            end if;          
end process;

clockgen_2 : process (CLK)
begin
    if (rising_edge(CLK) and (count >= (delay * 2))) then
                count_local2 <= count_local2 + X"1";
                --if count = X"1" then -- simulation 100mhz
                if count_local2 = ("00000000000000010000010001101010" / 2) then
                    element_sig(2) <= not element_sig(2);
                    count_local2 <= "00000000000000000000000000000000";
                end if;
            end if;          
end process;


clockgen_3 : process (CLK)
begin
    if (rising_edge(CLK) and (count >= (delay * 3))) then
                count_local3 <= count_local3 + X"1";
                --if count = X"1" then -- simulation 100mhz
                if count_local3 = ("00000000000000010000010001101010" / 2) then
                    element_sig(3) <= not element_sig(3);
                    count_local3 <= "00000000000000000000000000000000";
                end if;
            end if;          
end process;


clockgen_4 : process (CLK)
begin
    if (rising_edge(CLK) and (count >= (delay * 4))) then
                count_local4 <= count_local4 + X"1";
                --if count = X"1" then -- simulation 100mhz
                if count_local4 = ("00000000000000010000010001101010" / 2) then
                    element_sig(4) <= not element_sig(4);
                    count_local4 <= "00000000000000000000000000000000";
                end if;
            end if;          
end process;


clockgen_5 : process (CLK)
begin
    if (rising_edge(CLK) and (count >= (delay * 5))) then
                count_local5 <= count_local5 + X"1";
                --if count = X"1" then -- simulation 100mhz
                if count_local5 = ("00000000000000010000010001101010" / 2) then
                    element_sig(5) <= not element_sig(5);
                    count_local5 <= "00000000000000000000000000000000";
                end if;
            end if;          
end process;


clockgen_6 : process (CLK)
begin
    if (rising_edge(CLK) and (count >= (delay * 6))) then
                count_local6 <= count_local6 + X"1";
                --if count = X"1" then -- simulation 100mhz
                if count_local6 = ("00000000000000010000010001101010" / 2) then
                    element_sig(6) <= not element_sig(6);
                    count_local6 <= "00000000000000000000000000000000";
                end if;
            end if;          
end process;


clockgen_7 : process (CLK)
begin
    if (rising_edge(CLK) and (count >= (delay * 7))) then
                count_local7 <= count_local7 + X"1";
                --if count = X"1" then -- simulation 100mhz
                if count_local7 = ("00000000000000010000010001101010" / 2) then
                    element_sig(7) <= not element_sig(7);
                    count_local7 <= "00000000000000000000000000000000";
                end if;
            end if;          
end process;


clockgen_8 : process (CLK)
begin
    if (rising_edge(CLK) and (count >= (delay * 8))) then
                count_local8 <= count_local8 + X"1";
                --if count = X"1" then -- simulation 100mhz
                if count_local8 = ("00000000000000010000010001101010" / 2) then
                    element_sig(8) <= not element_sig(8);
                    count_local8 <= "00000000000000000000000000000000";
                end if;
            end if;          
end process;


clockgen_9 : process (CLK)
begin
    if (rising_edge(CLK) and (count >= (delay * 9))) then
                count_local9 <= count_local9 + X"1";
                --if count = X"1" then -- simulation 100mhz
                if count_local9 = ("00000000000000010000010001101010" / 2) then
                    element_sig(9) <= not element_sig(9);
                    count_local9 <= "00000000000000000000000000000000";
                end if;
            end if;          
end process;
end Behavioral;
