------------------ Entity: trigger_generator ------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity distance_calcualtion is
generic ( N : integer := 21);

port(
	echo : in std_logic := '0'; 
	echo_cnt  : in std_logic_vector (N-1 downto 0) := (others => '0');
	distance: out std_logic_vector(8 downto 0) := (others => '0')
	);
end distance_calcualtion;

architecture calcualtion of distance_calcualtion is

begin
	process(echo)
		variable multiplier: std_logic_vector (22 downto 0) := (others => '0');
	begin
		if (falling_edge(echo)) then
				-- CLOCK: 1ck -> 20ns = 20/1000 us.
				-- HCSR04: Distance = x(us) / 58.
				-- -> Result = y(chu ki)*20/1000*58 = y(chu ki) / 2900. ~ y.3(chu ki) /(2^13)
			multiplier := echo_cnt * "11"; -- nhan voi 3
				
			if (multiplier (22 downto 13) > "00111000010") then
				distance <="111111111";
			else
				distance <=  multiplier (21 downto 13);
			end if ;
		end if ;
	end process;
end calcualtion;
