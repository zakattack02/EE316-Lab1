library ieee;
use ieee.std_logic_1164.all;

entity key_LUT is
--generic(N: integer := 4);
	PORT(
         Data_in		:	in std_logic_vector(6 downto 0);
			LUT_Out		:	out std_logic_vector(4 downto 0)
		);

end key_LUT;


architecture Behavioral of key_LUT is


begin
process(Data_in)
	begin
	case Data_in is 
	when "0011110" =>LUT_Out <="01010";
	when "0111110" =>LUT_Out <="01011";
	when "1011110" =>LUT_Out <="01100";
	when "1111110" =>LUT_Out <="01101";
	when "0011101" =>LUT_Out <="00001";
	when "0111101" =>LUT_Out <="00010";
	when "1011101" =>LUT_Out <="00011";
	when "1111101" =>LUT_Out <="01110";
	when "0011011" =>LUT_Out <="00100";
	when "0111011" =>LUT_Out <="00101";
	when "1011011" =>LUT_Out <="00110";
	when "1111011" =>LUT_Out <="01111";
	when "0010111" =>LUT_Out <="00111";
	when "0110111" =>LUT_Out <="01000";
	when "1010111" =>LUT_Out <="01001";
	when "1110111" =>LUT_Out <="10000";
	when "0001111" =>LUT_Out <="00000";
	when "0101111" =>LUT_Out <="10010";
	when "1001111" =>LUT_Out <="10001";
	when others =>LUT_Out <="00000";
	
	end case;
	end process;
	end Behavioral;