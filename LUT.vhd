library ieee;
use ieee.std_logic_1164.all;

entity LUT is
--generic(N: integer := 4);
	PORT(
         Address		:	in std_logic_vector(3 downto 0);
			LUT_Out		:	out std_logic_vector(6 downto 0)
		);

end LUT;


architecture Behavioral of LUT is


begin
process(Address)
	begin
	case Address is 
	when "0000" =>LUT_Out <="1000000";
	when "0001" =>LUT_Out <="1111001";
	when "0010" =>LUT_Out <="0100100";
	when "0011" =>LUT_Out <="0110000";
	when "0100" =>LUT_Out <="0011001";
	when "0101" =>LUT_Out <="0010010";
	when "0110" =>LUT_Out <="0000010";
	when "0111" =>LUT_Out <="1111000";
	when "1000" =>LUT_Out <="0000000";
	when "1001" =>LUT_Out <="0010000";
	when "1010" =>LUT_Out <="0001000";
	when "1011" =>LUT_Out <="0000011";
	when "1100" =>LUT_Out <="1000110";
	when "1101" =>LUT_Out <="0100001";
	when "1110" =>LUT_Out <="0000110";
	when "1111" =>LUT_Out <="0001110";
	when others =>LUT_Out <="1111111";
	
	end case;
	end process;
	end Behavioral;