library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;


entity shift_controller is
port(
clk				: in std_logic;
shift_data	   : in std_logic_vector(15 downto 0);
shift_address  : in std_logic_vector(7 downto 0);
keypad_data	   : in std_logic_vector(4 downto 0);
address_out		: out std_logic_vector(7 downto 0);
data_out		   : out std_logic_vector(15 downto 0)
);
end shift_controller;  


architecture struct of shift_controller is

begin 

process(clk, keypad_data)
begin
if rising_edge(clk) and keypad_data = "10001" then
data_out <= shift_data;
address_out <= shift_address;
end if;
end process;


	
	end struct;