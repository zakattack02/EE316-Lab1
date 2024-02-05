LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench_top is 
end testbench_top;

architecture behavoral of testbench_top is

component top_level is 
	generic(N: integer := 8; N2: integer:=256 ; N1: integer:=1);
		port (
		iCLK 					: in std_logic; 
		reset_in 			: in std_logic; 
		keypad_data			: in std_logic_vector(4 downto 0);
		address_o				: out std_logic_vector(7 downto 0);
		we, oe			   : out std_logic;			
		IO						: inout std_logic_vector(15 downto 0);
		data_out				: out std_logic_vector(27 downto 0)
		);
		
		end component;
		
		signal iCLK     : std_logic :='0';
		signal reset_in :std_logic :='0';
		signal address_o	 :std_logic_vector(7 downto 0);
		signal we, oe   :std_logic;
		signal IO		 :std_logic_vector(15 downto 0);
		signal keypad_data : std_logic_vector(4 downto 0) := "00000";
		signal data_out	: std_logic_vector(27 downto 0);
		
		
		begin
		
		iCLK <= not iCLK after 10 ns;
		
		DUT: Top_level
		generic map(N => 8, N2=> 256, N1 =>1)
		port map(
		iCLK		=> iCLK,
		reset_in => reset_in,
		address_o   => address_o,
		we		   => we,
		oe			=> oe,
		IO			=> IO,
		keypad_data => keypad_data,
		data_out		=> data_out
		);
		
		process 
		begin
		
		wait for 1000 us;
		keypad_data <= "10000";
		wait for 10 us;
		keypad_data <= "00000";
		--wait for 15 ns;
		--keypad_data <= '0';
		wait for 1000 us;
		
		
		
		
		
		end process;
		end behavoral;
--		
		