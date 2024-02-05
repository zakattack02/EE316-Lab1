library ieee;
use ieee.std_logic_1164.all;

entity counter is
port(
   clk                : in std_logic;
	reset					 : in std_logic;  -- memory, asserted 1 to initate a memory operation 
   state              : in std_logic; -- read write, 1 read, 0 write,
	clk_en				 : in std_logic;
	address				 : out std_logic_vector(7 downto 0)
	enable				 : in STD_logic;
); 
end counter;

architecture arch of counter is

signal clock_ren :std_logic;
signal clock_wen :std_logic;
signal byte_sel  :std_logic_vector(7 downto 0);

begin
process(reset, clk, enable)
begin
if(reset = '1') then 
address <= '0';

elseif rising_edge(clk) and clk_en ='1' then 
address <= address + 1;

elseif address = 255 then
address <= '0';