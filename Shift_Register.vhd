-- FPGA projects using VHDL/ VHDL 
-- fpga4student.com
-- VHDL code for D Flip FLop
-- VHDL code for rising edge D flip flop 
Library IEEE;
USE IEEE.Std_logic_1164.all;

entity Shift_Register is 
   port(
      keypad_data_in :in std_logic_vector(4 downto 0);
		reset				:in std_logic;
      Clk            :in std_logic;
		clk_en_5ms     :in std_logic;
      pulse_5ms      :in std_logic;
		mode				:in std_logic_vector(3 downto 0);
		Q_out				:out std_logic_vector(15 downto 0)
		
   );
end Shift_Register;
architecture Behavioral of Shift_Register is  

signal Q 		: std_logic_vector(15 downto 0) := (others => '0');
begin  
 process(Clk, reset)
 begin
if reset = '1' then
Q <= "0000000000000000";  
    elsif rising_edge(Clk) and clk_en_5ms = '1' and pulse_5ms = '1' and mode(3) = '1' and mode(0) = '0' and keypad_data_in(4) = '0' then
		Q(3 downto 0) <= keypad_data_in(3 downto 0);
		Q(7 downto 4) <= Q(3 downto 0);
		Q(11 downto 8) <= Q(7 downto 4);
		Q(15 downto 12) <= Q(11 downto 8);
    end if;
Q_out(15 downto 12) <= Q(15 downto 12);
Q_out(11 downto 8)  <= Q(11 downto 8);
Q_out(7 downto 4)	  <= Q(7 downto 4);
Q_out(3 downto 0)   <= Q(3 downto 0);
 
 end process;  
end Behavioral; 