library ieee;
use ieee.std_logic_1164.all;

entity keypad is
port(
   clk						  : in std_logic; 
	rows						  : in std_logic_vector(4 downto 0);
	pulse_5ms   			  : out std_logic;
	pulse_20ns_out		     : out std_logic;
	columns					  : out std_logic_vector(3 downto 0);
	keypad					  : out std_logic_vector(4 downto 0)

); 

end keypad;

architecture arch of keypad is

type state_type is (columns_1, columns_2, columns_3, columns_4);
signal state     : state_type;
signal row		  : std_logic_vector(3 downto 0);
signal clk_en2	  : std_logic;
type state_type2 is (low_pulse, high_pulse);
signal state2    : state_type2;
signal pulse_20ns :std_LOGIC;


 component btn_debounce_toggle is
	GENERIC(
		CONSTANT CNTR_MAX : std_logic_vector(15 downto 0) := X"FFFF");
		Port( BTN_I		: in STD_LOGIC;
				CLK		: in STD_LOGIC;
				BTN_O			:out STD_LOGIC;
				TOGGLE_O		:out STD_LOGIC;
				PULSE_O		:out STD_LOGIC);
end component;

component clk_enabler2 is
generic (constant cnt_max  : integer := 249999
         );
port    (	
	clock:		in std_logic;	 
	clk_en: 		out std_logic
        );
end  component;


begin

pulse_20ns_out <= pulse_20ns;



process(pulse_20ns, clk_en2) 
begin 
if pulse_20ns = '1' then 
state2 <= high_pulse;
end if;

case state2 is 

when high_pulse =>
pulse_5ms <= '1';

if clk_en2 = '1' then
state2 <= low_pulse;
end if;
when low_pulse => 
pulse_5ms <= '0';

end case;
end process;



process(clk, rows, clk_en2)

begin 

if rising_edge(clk) then

case state is

when columns_1 =>
pulse_20ns <= '0';
columns <= "0111";

if rows(0) = '0' and clk_en2 = '1' then
keypad <= "01010";
pulse_20ns <= '1';
elsif rows(1) = '0' and clk_en2 = '1' then
keypad <= "00001";
pulse_20ns <= '1';
elsif rows(2) = '0' and clk_en2 = '1'then
keypad <= "00100";
pulse_20ns <= '1';
elsif rows(3) = '0' and clk_en2 = '1' then
keypad <= "00111";
pulse_20ns <= '1';
else
keypad <= "00000";
end if;


state <= columns_2 ;

when columns_2 =>
pulse_20ns <= '0';
columns <= "1011";

if rows(0) = '0' and clk_en2 = '1' then
keypad <= "01011";
pulse_20ns <= '1';
elsif rows(1) = '0' and clk_en2 = '1' then
keypad <= "00010";
pulse_20ns <= '1';
elsif rows(2) = '0' and clk_en2 = '1' then
keypad <= "00101";
pulse_20ns <= '1';
elsif rows(3) = '0' and clk_en2 = '1' then
keypad <= "01000";
pulse_20ns <= '1';
else
keypad <= "00000";
end if;

state <= columns_3;

when columns_3 =>
pulse_20ns <= '0';
columns <= "1101";

if rows(0) = '0' and clk_en2 = '1'then
keypad <= "01100";
pulse_20ns <= '1';
elsif rows(1) = '0' and clk_en2 = '1' then
keypad <= "00011";
pulse_20ns <= '1';
elsif rows(2) = '0' and clk_en2 = '1' then
keypad <= "00110";
pulse_20ns <= '1';
elsif rows(3) = '0' and clk_en2 = '1' then
keypad <= "01001";
pulse_20ns <= '1';
else
keypad <= "00000";
end if;

state <= columns_4;

when columns_4 =>
pulse_20ns <= '0';
columns <= "1110";


if rows(0) = '0' and clk_en2 = '1' then
keypad <= "01101";
pulse_20ns <= '1';
elsif rows(1) = '0' and clk_en2 = '1' then
keypad <= "01110";
pulse_20ns <= '1';
elsif rows(2) = '0' and clk_en2 = '1' then
keypad <= "01111";
pulse_20ns <= '1';
elsif rows(3) = '0' and clk_en2 = '1' then
keypad <= "10000";
pulse_20ns <= '1';
else
keypad <= "00000";
end if;

state <= columns_1;

end case;
end if;
end process;


--			inst_row0: btn_debounce_toggle
--	GENERIC MAP( CNTR_MAX => X"FFFF")		--use X'FFFF" for implementation
--		PORT Map(
--				BTN_I			=> rows(0),
--				CLK			      => clk,
--				BTN_O			=> row(0),
--				TOGGLE_O		=> open,
--				PULSE_O		=> pulse_5ms);
--				
--							inst_row1: btn_debounce_toggle
--	GENERIC MAP( CNTR_MAX => X"FFFF")		--use X'FFFF" for implementation
--		PORT Map(
--				BTN_I			=> rows(1),
--				CLK			      => clk,
--				BTN_O			=> row(1),
--				TOGGLE_O		=> open,
--				PULSE_O		=> pulse_5ms);
--				
--			inst_row2: btn_debounce_toggle
--	GENERIC MAP( CNTR_MAX => X"FFFF")		--use X'FFFF" for implementation
--		PORT Map(
--				BTN_I			=> rows(2),
--				CLK			      => clk,
--				BTN_O			=> row(2),
--				TOGGLE_O		=> open,
--				PULSE_O		=> pulse_5ms);
--
--				
--							inst_row3: btn_debounce_toggle
--	GENERIC MAP( CNTR_MAX => X"FFFF")		--use X'FFFF" for implementation
--		PORT Map(
--				BTN_I			=> rows(3),
--				CLK			      => clk,
--				BTN_O			=> row(3),
--				TOGGLE_O		=> open,
--				PULSE_O		=> pulse_5ms);
				

			Inst_clk_enabler2: clk_enabler2
			generic map(cnt_max => 249999)                     --49999999         --49999999 for implementation  and 100 for simulation
			port map( 
			clock 		=> clk,
			clk_en 		=> clk_en2
			);
				
				

end arch;