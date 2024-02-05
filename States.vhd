library IEEE; 

use IEEE.STD_LOGIC_1164.ALL; 

use IEEE.STD_LOGIC_ARITH.ALL; 

use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity States is
port( clk : in STD_LOGIC;
		rst : in STD_LOGIC;	
		keypad_data : in STD_LOGIC;
		states    : out STD_LOGIC;
		addr  :in std_logic_vector(7 downto 0)
		);
		
		end States;
		
		architecture arch of States is 
		type State_Type is (Run, Program, startup);
	   signal state: State_Type;
		
		begin
		process(clk, rst, keypad_data)
		begin
		
--		if rst = '1' then
--	   state <= run;
--		end if;
		if rising_edge(clk) then 
		--state <= run;
		case state is
--			when startup =>
--			states <= '0';
--			if addr = X"FF" then
--			state <= run;
--			end if;
			when run =>
			states <= '1';
			if keypad_data = '1' then
			state <= program;
			end if;
			when program =>
			states <= '0';
			if keypad_data = '0' then
			state <= run;
			end if;
			when others => null;
			end case;
			end if;
			end process;
end arch;			
			

		
		