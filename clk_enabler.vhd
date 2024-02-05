library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use ieee.std_logic_unsigned.all;

entity clk_enabler is
	GENERIC (
		CONSTANT cnt_max : integer := 49999999; CONSTANT cnt_max2 : integer := 249999);      --  1.0 Hz 
	port(	
		clock:		in std_logic;
		state:      in std_logic_vector(3 downto 0);
		clk_en: 		out std_logic
	);
end clk_enabler;

----------------------------------------------------

architecture behv of clk_enabler is

signal clk_cnt2: integer range 0 to cnt_max2;
signal clk_cnt: integer range 0 to cnt_max;
signal clk_cnts: integer range 0 to 2;
	 
begin
	process(clock,state)
	begin
	if rising_edge(clock) then
	if state = "0011"  then
		if (clk_cnts = 2) then
			clk_cnts <= 0;
			clk_en <= '1';
		else
			clk_cnts <= clk_cnts + 1;
			clk_en <= '0';
			end if;
			end if;
		if state = "0111"  then
		if (clk_cnt2 = cnt_max2) then						
			clk_cnt2 <= 0;
			clk_en <= '1';
		else
			clk_cnt2 <= clk_cnt2 + 1;
			clk_en <= '0';
			end if;
			end if;
				if state = "0101"  then
		if (clk_cnt2 = cnt_max2) then
			clk_cnt2 <= 0;
			clk_en <= '1';
		else
			clk_cnt2 <= clk_cnt2 + 1;
			clk_en <= '0';
			end if;
			end if;
				if state = "0100" then
		if (clk_cnt2 = cnt_max2) then
			clk_cnt2 <= 0;
			clk_en <= '1';
		else
			clk_cnt2 <= clk_cnt2 + 1;
			clk_en <= '0';
			end if;
			end if;
	if state = "0110" then
		if (clk_cnt2 = cnt_max2) then
			clk_cnt2 <= 0;
			clk_en <= '1';
		else
			clk_cnt2 <= clk_cnt2 + 1;
			clk_en <= '0';
			end if;
			end if;
		if state = "1011" then
		if (clk_cnt = cnt_max) then
			clk_cnt <= 0;
			clk_en <= '1';
		else
			clk_cnt <= clk_cnt + 1;
			clk_en <= '0';
		end if;
	end if;	
	if state = "1000" then
		if (clk_cnt = cnt_max) then
			clk_cnt <= 0;
			clk_en <= '1';
		else
			clk_cnt <= clk_cnt + 1;
			clk_en <= '0';
		end if;
	end if;	
	if state = "1001" then
		if (clk_cnt = cnt_max) then
			clk_cnt <= 0;
			clk_en <= '1';
		else
			clk_cnt <= clk_cnt + 1;
			clk_en <= '0';
		end if;
	end if;	
	if state = "1010" then
		if (clk_cnt = cnt_max) then
			clk_cnt <= 0;
			clk_en <= '1';
		else
			clk_cnt <= clk_cnt + 1;
			clk_en <= '0';
		end if;
end if;
end if;

	end process;
	

end behv;
