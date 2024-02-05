library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity keypad_lut is
    Port (
			iClk   : in std_logic;
			state  : in std_logic_vector (1 downto 0);
			ns20	: in std_LOGIC;
			DATA_in : in STD_LOGIC_VECTOR (4 downto 0);
         hex    : out STD_LOGIC_VECTOR(4 downto 0);
			statecontrol     : out std_logic_vector(1 downto 0));
end keypad_lut;

architecture behavior of keypad_lut is
begin

--type states is (zero, one, two, three, four, five, six, seven, eight, nine, a, b, c, d, e, f, shift, L, H, big)


	process(ns20)
	begin
	if falling_edge(ns20) then
		case DATA_in is 
			when "11110" =>
				if state = "00" then
					hex <= "01010";
				elsif state = "01" then
					hex <= "01011";
				elsif state = "10" then
					hex <= "01100";
				elsif state = "11" then
					hex <= "01101";
				else
					hex <= "00000";
				end if;
			when "11101" =>
				if state = "00" then
					hex <= "00001";
				elsif state = "01" then
					hex <= "00010";
				elsif state = "10" then
					hex <= "00011";
				elsif state = "11" then
					hex <= "01110";
				else
					hex <= "00000";
				end if;
			when "11011" =>
				if state = "00" then
					hex <= "00100";
				elsif state = "01" then
					hex <= "00101";
				elsif state = "10" then
					hex <= "00110";
				elsif state = "11" then
					hex <= "01111";
					else
					hex <= "00000";
				end if;
			when "10111" =>
				if state = "00" then
					hex <= "00111";
				elsif state = "01" then
					hex <= "01000";
				elsif state = "10" then
					hex <= "01001";
				elsif state = "11" then
					statecontrol <= "01";
					else
					hex <= "01000";
				end if;
			when "01111" =>
				if state = "00" then
					hex <= "10000";
				elsif state = "01" then
					hex <= "10001";
					statecontrol <= "10";
				elsif state = "10" then
				    hex <= "10010";
					statecontrol <= "11";
					else
					hex <= "00000";
				end if;
			when "11111" =>
				statecontrol <= "00";
				hex <= "00000";
				
			when others =>
				statecontrol <= "00";
				hex <= "00000";
		end case;
	end if;
	end process;
	
--	with DATA_in select
--	keypad_data <= "11110" when A,
--					   "11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--						"11110" when A,
--	
	
	
	
end behavior;