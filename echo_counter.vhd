----------------Entity: echo_counter ---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity echo_counter is
	generic ( N : integer := 21);

	port (
		clk	: in std_logic;
		enable  : in std_logic;
		reset	  : in std_logic;
		counter_out  : out std_logic_vector (N-1 downto 0) := (others => '0')
	);

end entity;

architecture counter of echo_counter is
signal  cnt : std_logic_vector (N-1 downto 0) := (others=>'0') ;
begin

	process (clk,reset)	 
	begin
			if reset = '0' then
				cnt <= (others=>'0');
			elsif clk'event and clk='1' then 
				if enable = '1' then
					cnt <= cnt + 1;
				end if;
			end if;			
	end process;
	counter_out <= cnt;
end counter;
