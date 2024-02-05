library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity State_Machine is
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
			  up    : out std_LOGIC;
			  en	  : out std_LOGIC;
			  led   : out std_logic;
			  address:out std_logic_vector(7 downto 0);
			  data  : out std_logic_vector(15 downto 0);
			  rw	  : out std_logic);
end State_Machine;

architecture Behavioral of State_Machine is
    type states is (INIT, OP_UP_Pause, OP_UP, OP_DOWN, OP_DOWN_Pause, Prog_UP_DATA, Prog_UP_ADDress, Prog_DOWN_DATA, Prog_DOWN_ADDress);
    signal current_state : states;
    signal state_value : STD_LOGIC_VECTOR(3 downto 0);
	 signal true_address	:std_logic_vector(7 downto 0);
	 signal true2_address :std_logic_vector(7 downto 0);
begin
    process(clk, rst, init_address)
    begin
        if rst = '1' then
            current_state <= INIT;

        elsif rising_edge(clk)  then   --clk_en = '1'


        case current_state is
            when INIT =>
				      up <= '1';
						en <= '1';
						rw <= '1';
						led <= '0';
						data <= init_data;
						address <= true_address;
						if init_address = "11111111" and clk_en = '0' then
					   --rw <= '0';
					end if;
					 if true_address = "11111111" and clk_en = '0' then
						  rw <= '0';
                    current_state <= OP_UP_PAUSE;  --_Pause
						  
					 end if;

            when OP_UP_Pause =>
						up <= '1';
						en <= '0';
						rw <= '0';
						led <= '1';
						--data <= init_data;
						address <= init_address;
                if keypad_data = "10010" and data_valid_pulse = '1' then
                    current_state <= OP_UP;
                elsif keypad_data = "10000" and data_valid_pulse = '1' then
                    current_state <= Prog_UP_ADDress;
                elsif keypad_data = "10001" and data_valid_pulse = '1' then
                    current_state <= OP_DOWN_Pause;
                end if;

            when OP_UP =>
				      up <= '1';
						en <= '1';
						rw <= '0';
						led <= '1';
						--data <= init_data;
						address <= init_address;
                if keypad_data = "10010" and data_valid_pulse = '1' then
                    current_state <= OP_UP_Pause;
                elsif keypad_data = "10000" and data_valid_pulse = '1' then
                    current_state <= Prog_UP_ADDress;
                elsif keypad_data = "10001" and data_valid_pulse = '1' then
                    current_state <= OP_DOWN;
                end if;

            when Prog_UP_ADDress =>
						up <= '1';
						en <= '0';
						rw <= '0';
						led <= '0';
						data <= init_data;
						address <= init_address;
                if keypad_data = "10000" and data_valid_pulse = '1' then
                    current_state <= OP_UP_Pause;
                elsif keypad_data = "10010" and data_valid_pulse = '1' then
                    current_state <= Prog_UP_DATA;
                end if;

            when Prog_UP_DATA =>
						up <= '1';
						en <= '0';
						led <= '0';
						--rw <= '0';
						data <= init_data;
						address <= init_address;

                if keypad_data = "10000" and data_valid_pulse = '1' then
                    current_state <= OP_UP_Pause;
                elsif keypad_data = "10010" and data_valid_pulse = '1' then
                    current_state <= Prog_UP_ADDress;
                end if;
					 if keypad_data = "10001" and data_valid_pulse = '1' then
					 	data <= new_data;
						address <= new_address;
						rw <= '1';
						elsif pulse_5ms = '0' then
						rw <= '0';
						end if;

            when OP_DOWN_Pause =>
						up <= '0';
						en <= '0';
						rw <= '0';
						led <= '1';
						--data <= init_data;
						address <= init_address;
                if keypad_data = "10010" and data_valid_pulse = '1' then
                    current_state <= OP_DOWN;
                elsif keypad_data = "10000" and data_valid_pulse = '1' then
                    current_state <= Prog_DOWN_ADDress;
                elsif keypad_data = "10001" and data_valid_pulse = '1' then
                    current_state <= OP_UP_PAUSE;
                end if;

            when OP_DOWN =>
					   up <= '0';
						en <= '1';
						rw <= '0';
						led <= '1';
						--data <= init_data;
						address <= init_address;
                if keypad_data = "10010" and data_valid_pulse = '1' then
                    current_state <= OP_DOWN_Pause;
                elsif keypad_data = "10000" and data_valid_pulse = '1' then
                    current_state <= Prog_DOWN_ADDress;
                elsif keypad_data = "10001" and data_valid_pulse = '1' then
                    current_state <= OP_UP;
                end if;

            when Prog_DOWN_ADDress =>
					   up <= '0';
						en <= '0';
						led <= '0';
						--rw <= '1';
				      data <= init_data;
						address <= init_address;
                if keypad_data = "10000" and data_valid_pulse = '1' then
                    current_state <= OP_DOWN_Pause;
                elsif keypad_data = "10010" and data_valid_pulse = '1' then
                    current_state <= Prog_DOWN_DATA;
                end if;

            when Prog_DOWN_DATA =>
				      up <= '0';
						en <= '0';
						led <= '0';
						--rw <= '1';
					     data <= init_data;
						address <= init_address;
                if keypad_data = "10000" and data_valid_pulse = '1' then
                    current_state <= OP_DOWN_Pause;
                elsif keypad_data = "10010" and data_valid_pulse = '1' then
                    current_state <= Prog_DOWN_ADDress;
                end if;
					 if keypad_data = "10001" and data_valid_pulse = '1' then
					 	data <= new_data;
						address <= new_address;
						rw <= '1';
						elsif pulse_5ms = '0' then
						rw <= '0';
					end if;
            when others =>
                current_state <= INIT;  -- Reset to INIT state if in an unknown state
			
        end case;
		  		 end if;
    end process;

	 with current_state select
    state_value <= "0011" when INIT,
                   "0110" when OP_UP_Pause,
                   "0111" when OP_UP,
                   "0101" when OP_DOWN,
                   "0100" when OP_DOWN_Pause,
                   "1010" when Prog_UP_DATA,
                   "1011" when Prog_UP_ADDress,
                   "1000" when Prog_DOWN_DATA,
                   "1001" when Prog_DOWN_ADDress,
                   "0000" when others;  -- Default value for unknown states

    state <= state_value;
 
 process(clk)
begin

if rising_edge(clk_en) then
true_address <= init_address;
end if;
end process;
 
 
 
 
end Behavioral;

