library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity top_level is
		generic(N: integer := 8; N2: integer:=256 ; N1: integer:=1);
		port (
		iCLK 					 : in std_logic; 
		reset_in 			 : in std_logic;
		address_o			 : out std_logic_vector(19 downto 0);
		we, oe, lb, ub, ce : out std_logic;			
		IO						 : inout std_logic_vector(15 downto 0);
		data_out				 : out std_LOGIC_VECTOR(27 downto 0);
		address_out			 : out std_logic_vector(13 downto 0);
		keypad_data_test	 : in std_logic;
	   row  : in std_logic_vector(4 DOWNTO 0); 
		led	:out std_LOGIC;
	   col : out std_logic_vector(3 downto 0)
		);
end top_level;

architecture Structural of top_level is
	
	
	
	component State_Machine is
    Port ( clk : in STD_LOGIC;
           clk_en : in STD_LOGIC;
           rst : in STD_LOGIC;
           keypad_data : in STD_LOGIC_VECTOR(4 downto 0);
           data_valid_pulse : in STD_LOGIC;
			  init_address			:in std_logic_vector(7 downto 0);
			  init_data				:in std_logic_vector(15 downto 0);
			  new_address		:in std_logic_vector(7 downto 0);
			  new_data        :in std_logic_vector(15 downto 0);
			  pulse_5ms			:in std_LOGIC;
           state : out STD_LOGIC_VECTOR(3 downto 0);
			  led   : out std_LOGIC;
			  up :    out std_LOGIC;
			  en :    out std_LOGIC;
			  address:out std_logic_vector(7 downto 0);
			  data:	 out std_logic_vector(15 downto 0);
			  rw :    out std_LOGIC);
end component;

component Shift_Register_Address is 
   port(
      keypad_data_in :in std_logic_vector(4 downto 0);  
		reset				:in std_LOGIC;
      Clk            :in std_logic;
		clk_en_5ms     :in std_logic;
      pulse_5ms      :in std_logic;
		mode				:in std_logic_VECTOR(3 downto 0);
		Q_out				:out std_logic_vector(7 downto 0)
		);
		end component;
		
		component Shift_Register is 
   port(
      keypad_data_in :in std_logic_vector(4 downto 0);   
		reset				:in std_logic;
      Clk            :in std_logic;
		clk_en_5ms     :in std_logic;
      pulse_5ms      :in std_logic;
		mode				:in std_logic_vector(3 downto 0);
		Q_out				:out std_logic_vector(15 downto 0)
		
   );
end component;
		
	component univ_bin_counter is
		generic(N: integer := 4; N2: integer:=9 ; N1: integer:=0);  --8, 9, 0??? Changed to 8 to 4
		port(
			clk, reset					: in std_logic;
			syn_clr, load, en, up	: in std_logic;
			clk_en 						: in std_logic := '1';			
			d								: in std_logic_vector(N-1 downto 0);
			max_tick, min_tick		: out std_logic;
			q								: out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	component rom1p IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END component;

	component Reset_Delay IS
       generic(MAX: integer :=15);	
		 PORT (
			  SIGNAL iCLK 		: IN std_logic;	
			  SIGNAL oRESET 	: OUT std_logic
				);	
	end component;	
		
		component clk_enabler is
	GENERIC (CONSTANT cnt_max : integer := 49999999; CONSTANT cnt_max2 : integer := 249999 );      --  1.0 Hz 
	port(	
		clock:		in std_logic;
		state:      in STD_LOGIC_VECTOR(3 downto 0);
		clk_en: 		out std_logic	
	);

    end component;
	 
	 component btn_debounce_toggle is
	GENERIC(
		CONSTANT CNTR_MAX : std_logic_vector(15 downto 0) := X"FFFF");
		Port( BTN_I		: in STD_LOGIC;
				CLK		: in STD_LOGIC;
				BTN_O			:out STD_LOGIC;
				TOGGLE_O		:out STD_LOGIC;
				PULSE_O		:out STD_LOGIC);
end component;

component LUT is
	PORT(
         Address		:	in std_logic_vector(3 downto 0);
			LUT_Out		:	out std_logic_vector(6 downto 0)
		);

end component;
		
		component sram_ctrl is
port(
   clk, reset             : in std_logic; 
   rw                     : in std_logic;
   pulse        			  : in std_logic;
   address_in             : in std_logic_vector(7 downto 0);  --address 8 bit address 
   data_in                : in std_logic_vector(15 downto 0);  -- 8 bit data to be written to sram 
   SRAM_addr              : out std_logic_vector(19 downto 0);  -- sent to sram  
	data_out               : out std_logic_vector(15 downto 0);
   we_n 						  : out std_logic;
	oe_n                   : out std_logic;  -- sent to sram 
   io                     : inout std_logic_vector(15 downto 0);  -- goes into i/o  
   ce_n                   : out std_logic; -- tied low
   lb_n						  : out std_logic;
	ub_n						  : out std_logic 
); 
end component;



component Keypad_controller is
	Port(
	row  							: in std_logic_vector(4 DOWNTO 0);
	iClk                    : in std_logic;
 	clk_en_5ms              : in std_logic;
	DATA_out                : out std_logic_vector(4 downto 0);
	pulse_5ms               : out std_logic;
	pulse_20ns              : out std_logic;
	pulse_520ns             : out std_logic;
	col 							: out std_logic_vector(3 downto 0);
	statecontrol            : out std_logic_vector(1 downto 0);
	control_state           : out std_logic_vector(1 downto 0));
end component;

component keypad_lut is
port(
	iClk 	 	: in std_logic;
	state  	: std_logic_vector(1 downto 0);
	DATA_in 	: std_logic_vector(4 downto 0);
   DATA_out : out std_logic_vector(4 downto 0);
	statecontrol : out std_logic_vector(1 downto 0)
	);
end component;

	component seg_controller is
port(
op_data			: in std_logic_vector(15 downto 0);
shift_data			: in std_logic_vector(15 downto 0);
data_out			: out std_logic_vector(15 downto 0);
op_address			: in std_logic_vector(7 downto 0);
shift_address			: in std_logic_vector(7 downto 0);
state						: in std_logic_vector(3 downto 0);
address_out				: out std_logic_vector(7 downto 0)
);
end component; 




component clk_enabler2 is
	GENERIC (
		CONSTANT cnt_max : integer := 125000);      
	port(	
		clock		:	in std_logic;	 
		clk_en	: 	out std_logic
	);
end component;

component shift_controller is
port(
clk				: in std_logic;
shift_data	   : in std_logic_vector(15 downto 0);
shift_address  : in std_logic_vector(7 downto 0);
keypad_data	   : in std_logic_VECTOR(4 downto 0);
address_out		: out std_logic_vector(7 downto 0);
data_out		   : out std_logic_vector(15 downto 0)
);
end component; 




   signal reset_d			        		: std_logic;	
	signal Counter_Reset					: std_logic;
	signal data								: std_LOGIC_VECTOR(15 downto 0);
	signal rw                        : std_logic; -- read write, 1 read, 0 write,
   signal addr                      : std_logic_vector(7 downto 0); 
	signal clk_en						   : std_logic;
	signal reset_db						: std_logic;
	signal up						   : std_logic;
   signal en						   : std_logic;
	signal st							: std_LOGIC_vector(3 downto 0);
	signal pulse_5ms					: std_logic;   --temp
	signal Program_Address			: std_logic_vector(7 downto 0); --temp
	signal Program_Data				: std_LOGIC_VECTOR(15 downto 0); -- temp
   signal init_address			: std_logic_vector(7 downto 0); --temp
	signal init_data				: std_LOGIC_VECTOR(15 downto 0);
	signal ready				   : std_logic;
	signal data_LUT				: std_logic_vector(15 downto 0);
	signal data_SRAM				: std_logic_vector(15 downto 0);
	signal address_load			: std_logic_vector(7 downto 0);
	signal data_load				: std_logic_vector(15 downto 0);
   signal clken_5ms            : std_logic;
	signal keypad_data				 : std_loGIC_vector(4 downto 0);
	signal pulse_20ns              : std_logic;
	signal pulse_520ns             : std_logic;
	signal statecontrol            : std_logic_vector(1 downto 0);
	signal control_state           : std_logic_vector(1 downto 0);
	signal op_data						 : std_logic_vector(15 downto 0);
   signal shift_data      			 : std_LOGIC_VECTOR(15 downto 0);
	signal op_address					 : std_logic_vector(7 downto 0);
	signal Address_State				 : std_logic_vector(7 downto 0);
	signal Data_State					 : std_logic_vector(15 downto 0);





	begin



inst_Shift_controller: shift_controller
port map(
clk            => iCLK,
shift_data     => Program_Data,
shift_address  => Program_Address,
keypad_data		=> keypad_data,
address_out		=> Address_State,
data_out			=> Data_State
);
	
	
	
   Counter_Reset <= not reset_db or reset_d;		--BROKEN?

	

	
	Inst_segcontroller: seg_controller
	port map (
	op_data       => op_data,
	shift_data	  => Program_Data,
	data_out      => data_LUT,   
	op_address    => op_address,
	shift_address => Program_Address,
	state         => st,
	address_out	  => addr
	);
	
	
	
	
	
	
	
	
	
	Inst_sram_crtl: sram_ctrl 
	port map (
	clk             => iCLK,
	reset           => counter_Reset,
	address_in      => op_address,    --address_load
	rw		          => rw,
	data_in         => data,     --data_load
	pulse           => clk_en,
	SRAM_addr       => address_o,
	data_out        => op_data,     --data_SRAM
	we_n 		       => we,
	oe_n            => oe,
	ce_n  	       => ce,
 lb_n				 => lb,
 ub_n				 => ub,
	io             => IO
	);
	
	Inst_rom1p: rom1p
	port map(
	address   => init_address,-- 8 bit from counter
	clock     => iCLK,
	q         => init_data
	);
	
	Inst_clk_Reset_Delay: Reset_Delay		--clk vs not having it?
			generic map(MAX => 7)
			port map(
			  iCLK 		=> iCLK,	
			  oRESET    => reset_d
				);		
			
		Inst_univ_bin_counter: univ_bin_counter
		generic map(N => 8, N2=> 255, N1 =>0)
		port map(
			clk 			=> iCLK,
			reset 		=> Counter_Reset,
			syn_clr		=> '0', 
			load			=> '0', 
			en				=> en, --en 
			up				=> up, --up 
			clk_en 		=> clk_en,
			d				=> (others => '0'),
			max_tick		=> open, 
			min_tick 	=> open,
			q				=> init_address );	
				
				Inst_clk_enabler: clk_enabler
			generic map(cnt_max => 249999, cnt_max2 => 49999999)                     --49999999         --49999999 for implementation  and 100 for simulation
			port map( 
			clock 		=> iCLK,
			state       => st,
			clk_en 		=> clk_en
			);
			
		
			inst_KEY0: btn_debounce_toggle
	GENERIC MAP( CNTR_MAX => X"FFFF")		--use X'FFFF" for implementation
		PORT Map(
				BTN_I			=> reset_in,
				CLK			      => iCLK,
				BTN_O			=> reset_db,
				TOGGLE_O		=> open,
				PULSE_O		=> open);
				


inst_State_Machine: State_Machine
port map(
clk              => iCLK,
clk_en           => clk_en,
rst              => counter_Reset,
keypad_data      => keypad_data,
data_valid_pulse => pulse_20ns,      --pulse_20ns
init_address	  => init_address,
init_data		  => init_data,
new_Address      => Address_State,
new_Data	        => Data_State,
pulse_5ms		  => pulse_5ms,
state				  => st,
en					  => en,
up					  => up,
led              => led,
address			  => op_address,
data				  => data,
rw					  => rw);


inst_Shift_Register: Shift_Register
port map(
keypad_data_in => keypad_data,
Clk				=> iCLK,
clk_en_5ms		=> clk_en,
pulse_5ms		=> pulse_5ms,
mode				=> st,
reset				=> counter_Reset,
Q_out				=> Program_Data
);

inst_Shift_Register_Address: Shift_Register_Address
port map(
keypad_data_in => keypad_data,
Clk				=> iCLK,
clk_en_5ms		=> clk_en,
pulse_5ms		=> pulse_5ms,
mode				=> st,
reset				=> counter_Reset,
Q_out				=> Program_Address
);

inst_LUT_1: LUT
--generic map(N => 4)
	PORT map(
         Address => data_LUT(15 downto 12),
			LUT_Out => data_out(27 downto 21)
		);

inst_LUT_2: LUT
--generic map(N => 4)
	PORT map(
         Address => data_LUT(11 downto 8),
			LUT_Out => data_out(20 downto 14)
		);
		
		inst_LUT_3: LUT
--generic map(N => 4)
	PORT map(
         Address => data_LUT(7 downto 4),
			LUT_Out => data_out(13 downto 7)
		);
		
		inst_LUT_4: LUT
--generic map(N => 4)
	PORT map(
         Address => data_LUT(3 downto 0),
			LUT_Out => data_out(6 downto 0)
		);
		
				inst_LUT_5: LUT
--generic map(N => 4)
	PORT map(
         Address => addr(7 downto 4),
			LUT_Out => address_out(13 downto 7)
		);
		
				inst_LUT_6: LUT
--generic map(N => 4)
	PORT map(
         Address => addr(3 downto 0),
			LUT_Out => address_out(6 downto 0)
		);
		
		Inst_kpc: Keypad_controller 
	Port map(
	row  => row,
	iClk  => iCLK,
	DATA_out => keypad_data,
 	clk_en_5ms => clken_5ms,
	pulse_5ms => pulse_5ms,
	pulse_20ns => pulse_20ns,
	pulse_520ns  => pulse_520ns,
	statecontrol  => statecontrol,
	col			  => col,
	control_state => control_state);
	
	Inst_clk_en: clk_enabler2 
	GENERIC map( cnt_max => 249999)       --125000 
	port map(	
		clock => iCLK,	 
		clk_en => clken_5ms);
			
				end Structural;