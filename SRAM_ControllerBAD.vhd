library ieee;
use ieee.std_logic_1164.all;

entity sram_ctrl is
port(
   clk, reset             : in std_logic;
   mem                    : in std_logic;  -- memory, asserted 1 to initate a memory operation 
   rw                     : in std_logic; -- read write, 1 read, 0 write,
   addr                   : in std_logic_vector(7 downto 0);  --address 8 bit address 
   data_f2s               : in std_logic_vector(15 downto 0);  -- 8 bit data to be written to sram 
   ready                  : out std_logic;  --  ready status, when the controller is ready to accept new command
   data_s2f_r, data_s2f_ur: out std_logic_vector(15 downto 0);  -- 8 bit registered data retrieved from s ram, ur, unregistered data retrieved from sram 
   ad                     : out std_logic_vector(19 downto 0);  -- sent to sram  
   we_n, oe_n             : out std_logic;  -- sent to sram 
   dio                    : inout std_logic_vector(15 downto 0);  -- goes into i/o  
   ce_n                   : out std_logic -- tied low 
); 

end sram_ctrl;

architecture arch of sram_ctrl is
type state_type is (idle, r1, r2, w1, w2);
signal state_reg, state_next: state_type;
signal data_f2s_reg, data_f2s_next  :std_logic_vector(15 downto 0);
signal data_s2f_reg, data_s2f_next  :std_logic_vector(15 downto 0);
signal addr_reg                     :std_logic_vector(7 downto 0);
signal addr_next                    :std_logic_vector(7 downto 0);
signal we_buf, oe_buf, tri_buf      : std_logic;
signal we_reg, oe_reg, tri_reg      : std_logic;
signal io									: std_logic_vector(19 downto 0);

begin
process(clk, reset)
begin
if (reset = '1') then
state_reg <= idle;
addr_reg <= (others => '0');
data_f2s_reg <= (others => '0');
data_s2f_reg <= (others => '0');
tri_reg <= '1';
we_reg <= '1';
oe_reg <= '1';

elsif (clk'event and clk = '1') then
state_reg <= state_next;
addr_reg <= addr_next;
data_f2s_reg <= data_f2s_next;
data_s2f_reg <= data_s2f_next;
tri_reg <= tri_buf;
we_reg <= we_buf;
oe_reg <= oe_buf;

end if;
end process;

-- next state logic

process(state_reg, mem, rw, dio, addr, data_f2s,
data_f2s_reg, data_s2f_reg, addr_reg)

begin
addr_next <= addr_reg;
data_f2s_next <= data_f2s_reg;
data_s2f_next <= data_s2f_reg;
ready <= '0';

case state_reg is

when idle =>
if (mem = '0') then
state_next <= idle;
else
addr_next <= addr;
if (rw = '1') then -- write
state_next <= w1;
data_f2s_next <= data_f2s;
else
state_next <= r1;
end if;
end if;
ready <= '1';

when w1 =>
state_next <= w2;
when w2 =>
state_next <= idle;

when r1 =>
state_next <= r2;

when r2 =>
data_s2f_next <= dio;
state_next <= idle;
end case;
end process;
-- look-ahead output logic

process(state_next)

begin
tri_buf <= '1';
we_buf <= '1';
oe_buf <= '1';

case state_next is
when idle =>

when w1 =>
tri_buf <= '0';
we_buf <= '0';

when w2 =>
tri_buf <= '0';

when r1 =>
oe_buf <= '0';

when r2 =>
oe_buf <= '0';

end case; end process;
-- to main system
data_s2f_r <= data_s2f_reg;
data_s2f_ur <= dio;
-- to SRAM
we_n <= we_reg;
oe_n <= oe_reg;
ad(19 downto 8) <= "000000000000";
ad(7 downto 0) <= addr_reg;
-- I/O for SRAM chip
ce_n <= '0';
dio <= data_f2s_reg when tri_reg = '0'
else (others => 'Z');
end arch;