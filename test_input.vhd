-------------------Entity: test_input ----------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--entity test_input is
--	port (
--		clk : in std_logic;
--		d0: out std_logic_vector(7 downto 0) := X"31";
--		d1: out std_logic_vector(7 downto 0) := X"31";
--		d2: out std_logic_vector(7 downto 0) := X"31"
--	);
--end test_input;
--
--architecture gen_test of test_input is
--signal d0_temp : std_logic_vector(7 downto 0) := X"30";
--signal d1_temp : std_logic_vector(7 downto 0) := X"30";
--signal d2_temp : std_logic_vector(7 downto 0) := X"30";
--begin
-- process(clk)
-- variable count : integer range 0 to 4000 := 0;
-- begin
--  if(rising_edge(clk)) then
--		if(count < 4000) then
--			count := count + 1;
--		else
--			d0_temp <= d0_temp + X"01";
--		   if (d0_temp = X"39") then
--				d0_temp <= X"30";
--			end if;
--			count := 0;
--		end if ;
--  end if ;
-- end process;
-- 
-- d0 <= d0_temp;
-- d1 <= X"30";
-- d2 <= X"31";
--end architecture;


entity test_input is
	port (
		clk : in std_logic;
		bint: out std_logic_vector(8 downto 0) := (others => '0')		
	);
end test_input;

architecture gen_test of test_input is
signal bint_temp : std_logic_vector(8 downto 0) := (others => '0');

begin
 process(clk)
 variable count : integer range 0 to 50000000 := 0;
 begin
  if(rising_edge(clk)) then
		if(count < 50000000) then
			count := count + 1;
		else
			bint_temp <= (bint_temp + "000000101");
			count := 0;
		end if ;
  end if ;
 end process;
 bint <= bint_temp;
end architecture;