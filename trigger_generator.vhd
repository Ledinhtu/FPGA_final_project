------------------ Entity: trigger_generator ------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity trigger_generator is
generic ( N : integer := 24); --25: delay500ms / 24: delay250ms
port(
	clk : in std_logic; 
	trigger : out std_logic
	);
end trigger_generator;

architecture generator of trigger_generator is
	signal counter : std_logic_vector (N-1 downto 0) := (others=>'0');
	constant t_delay : std_logic_vector (N-1 downto 0):= "101111101011110000100000"; -- 250 ms
	constant t_cycle : std_logic_vector (N-1 downto 0):= "101111101100111110101000"; -- delay:250ms + trigger:100us
--	constant t_delay : std_logic_vector (N-1 downto 0):= "1011111010111100001000000"; -- 500 ms
--	constant t_cycle : std_logic_vector (N-1 downto 0):= "1011111011000101111001000"; -- delay:500ms + trigger:100us
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (counter >= t_cycle) then
				counter <= (others=>'0');
			else
				if ((counter > t_delay) and (counter < t_cycle)) then
					trigger <= '1';
				else 
					trigger <= '0';
				end if;
				
				counter <= counter + 1;
			end if;
		end if;
	end process;
end generator;
