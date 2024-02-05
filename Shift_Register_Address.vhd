Library IEEE;
USE IEEE.Std_logic_1164.all;

entity Shift_Register_Address is 
   port(
      keypad_data_in :in std_logic_vector(4 downto 0);
		reset				:in std_logic;
      Clk            :in std_logic;
		clk_en_5ms     :in std_logic;
      pulse_5ms      :in std_logic;
		mode				:in std_logic_vector(3 downto 0);
		Q_out				:out std_logic_vector(7 downto 0)
		
   );
end Shift_Register_Address;
architecture Behavioral of Shift_Register_Address is  

signal Q 		: std_logic_vector(7 downto 0) := (others => '0');
begin  
 process(Clk, reset)
 begin 
 if reset = '1' then
 Q <= "00000000";
    elsif rising_edge(Clk) and clk_en_5ms = '1' and pulse_5ms = '1' and mode(3) = '1' and mode(0) = '1' and keypad_data_in(4) = '0' then
		Q(3 downto 0) <= keypad_data_in(3 downto 0);
		Q(7 downto 4) <= Q(3 downto 0);
    end if;

Q_out(7 downto 4)	  <= Q(7 downto 4);
Q_out(3 downto 0)   <= Q(3 downto 0);
 
 end process;  
end Behavioral; 