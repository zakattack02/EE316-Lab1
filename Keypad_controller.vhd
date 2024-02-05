library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity Keypad_controller is
	Port(
	row   : in std_logic_vector(4 DOWNTO 0); 
	iClk                    : in std_logic;
 	clk_en_5ms              : in std_logic;
	DATA_out                : out std_logic_vector(4 downto 0);
	pulse_5ms               : out std_logic;
	pulse_20ns              : out std_logic;
	pulse_520ns             : out std_logic;
	statecontrol            : out std_logic_vector(1 downto 0);
	control_state           : out std_logic_vector(1 downto 0);
	col : out std_logic_vector(3 downto 0):= "1110"
	);
	
end Keypad_controller;

Architecture behavior of Keypad_controller is

	component clock_en is
		GENERIC (
			CONSTANT cnt_max : integer := 250000);      
		port(	
			clock:		in std_logic;	 
			clk_en: 		out std_logic);
	end component;

	
	component btn_debounce_toggle is
	GENERIC (
		CONSTANT CNTR_MAX : std_logic_vector(15 downto 0) := X"0001");  
		Port ( 
				 BTN_I 	 : in  STD_LOGIC;
             CLK 		 : in  STD_LOGIC;
             BTN_O 	 : out  STD_LOGIC;
             TOGGLE_O : out  STD_LOGIC;
		       PULSE_O  : out STD_LOGIC);
	end component;
	
	component key_LUT is
--generic(N: integer := 4);
	PORT(
         Data_in		:	in std_logic_vector(6 downto 0);
			LUT_Out		:	out std_logic_vector(4 downto 0)
		);

end component;
	
	CONSTANT cnt_max : integer := 250000;
	constant CNTR_MAX : std_logic_vector(15 downto 0) := X"0001";
	type state_type is (St_A, St_B, St_C, St_D);
	signal next_state : state_type;
   signal kp : std_logic;
	signal state : std_logic_vector(1 downto 0) :="00";
	signal statecontrol_lut    : std_logic_vector(1 downto 0) :="00";
	signal DATA_in : std_logic_vector(6 downto 0);
	signal btn_sync	: std_logic_vector(1 downto 0);
	signal btn_toggle : std_LOGIC:= '1';
	signal kp_temp 	: std_logic;
	signal pulse_20nsSig :std_LOGIC;
	signal row_temp 	: std_logic_vector(4 downto 0);
	signal R				: std_LOGIC_VECTOR(1 downto 0);
	signal Q				: std_LOGIC_VECTOR(1 downto 0);
	
begin
	
	statecontrol <= statecontrol_lut;
	control_state <= state;
	
	process(iclk, kp)
	begin 
	--kp <= not (row1 and row2 and row3 and row4 and row5);
	kp_temp <= not (row_temp(0) and row_temp(1) and row_temp(2) and row_temp(3) and row_temp(4)); 
	
	if rising_edge(iClk) and clk_en_5ms = '1' then  
		case next_state is
			when St_A =>
				state <= "01";
				if kp_temp <= '0' then
			
					next_state <= St_B;
					col(1) <= '0';
					col(0) <= '1';
					
				else
					DATA_in(4 downto 0) <= (row_temp(0) & row_temp(1) & row_temp(2) & row_temp(3) & row_temp(4));--row5 & row4 & row3 & row2 & row1; 
					DatA_in(6 downto 5) <= state;
					next_state <= St_A;
				end if;
			when St_B =>
							state <= "10";
				if kp_temp <= '0' then
					
					col(2) <= '0';
					col(1) <= '1';
	
					next_state <= St_C;
					
				else
					DATA_in(4 downto 0) <= (row_temp(0) & row_temp(1) & row_temp(2) & row_temp(3) & row_temp(4));--row5 & row4 & row3 & row2 & row1; 
					DatA_in(6 downto 5) <= state;
					next_state <= St_B;
				end if;
			when St_C =>
				state <= "11";
				if kp_temp <= '0' then
				
					col(3) <= '0';
					col(2) <= '1';
					next_state <= St_D;
					
				else
					DATA_in(4 downto 0) <= (row_temp(0) & row_temp(1) & row_temp(2) & row_temp(3) & row_temp(4));--row5 & row4 & row3 & row2 & row1; 
					DatA_in(6 downto 5) <= state;
					next_state <= St_C;
				end if;
			when St_D =>
				state <= "00";
				if kp_temp <= '0' then
				
					col(0) <= '0';
					col(3) <= '1';
					next_state <= St_A;
					
				else
				   DATA_in(4 downto 0) <= (row_temp(0) & row_temp(1) & row_temp(2) & row_temp(3) & row_temp(4));--row5 & row4 & row3 & row2 & row1; 
					DatA_in(6 downto 5) <= state;
					next_state <= St_D;
				end if;
		end case;
		
end if;
	end process;
	

	INST_ROWDB0: btn_debounce_toggle
	GENERIC map (
		CNTR_MAX => X"FFFF")  
		Port map( 
				 BTN_I 	 => row(0),
             CLK 		 => iClk,
             BTN_O 	 => Row_temp(0),
             TOGGLE_O => open,
		       PULSE_O  => open
			);
	INST_ROWDB1: btn_debounce_toggle
	GENERIC map (
		CNTR_MAX => X"FFFF")  
		Port map ( 
				 BTN_I 	 => row(1),
             CLK 		 => iClk,
             BTN_O 	 => Row_temp(1),
             TOGGLE_O => open,
		       PULSE_O  => open
			);
	INST_ROWDB2: btn_debounce_toggle
	GENERIC map (
		CNTR_MAX => X"FFFF")  
		Port map ( 
				 BTN_I 	 => row(2),
             CLK 		 => iClk,
             BTN_O 	 => Row_temp(2),
             TOGGLE_O => open,
		       PULSE_O  => open
			);	
	INST_ROWDB3: btn_debounce_toggle
	GENERIC map (
		CNTR_MAX => X"FFFF") 
		Port map ( 
				 BTN_I 	 => row(3),
             CLK 		 => iClk,
             BTN_O 	 => Row_temp(3),
             TOGGLE_O => open,
		       PULSE_O  => open
			);		
	INST_ROWDB4: btn_debounce_toggle
	GENERIC map (
		CNTR_MAX => X"FFFF")  
		Port map ( 
				 BTN_I 	 => row(4),
             CLK 		 => iClk,
             BTN_O 	 => Row_temp(4),
             TOGGLE_O => open,
		       PULSE_O  => open
			);


process(iclk)
begin
	if rising_edge(iclk) and clk_en_5ms = '1' then
	Q(0) <= kp_temp;
	Q(1) <= Q(0);
	pulse_5ms <= Q(0) and not Q(1);

end if;
end process;

process(iclk)
begin
	if rising_edge(iclk) and clk_en_5ms = '1' then
	R(0) <= kp_temp;
	R(1) <= R(0);
	pulse_20ns <= R(0) and not R(1);

end if;
end process;		 

	Inst_key_lut: key_lut
	port map(
	DatA_in => datA_in,
	LUT_Out => DatA_out
		);		 
				 
			
			
	Inst_clk: clock_en 
		GENERIC map ( cnt_max => cnt_max)      
		port map(	
			clock => iClk,		
			clk_en => pulse_520ns);


end behavior;