library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;


entity seg_controller is
port(
--clk				: in std_logic;
op_data			: in std_logic_vector(15 downto 0);
shift_data			: in std_logic_vector(15 downto 0);
data_out			: out std_logic_vector(15 downto 0);
op_address			: in std_logic_vector(7 downto 0);
shift_address			: in std_logic_vector(7 downto 0);
state						: in std_logic_vector(3 downto 0);
address_out				: out std_logic_vector(7 downto 0)
);
end seg_controller;  


architecture struct of seg_controller is

begin 

process(state)

	begin
	--if rising_edge(clk) then
	if state(3) = '1' then
	data_out <= shift_data;
	   end if;
	address_out <= shift_address;
	if state(3) = '0' then
	data_out <= op_data;
	address_out <= op_address;
	end if;
	--end if;
	end process;
	
	end struct;
	
