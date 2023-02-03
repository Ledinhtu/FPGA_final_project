----------------- Entity: conv_bcd ----------------
----------------- Convert Binary to BCD -----------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity conv_bcd is
 port(
	bin: in std_logic_vector(8 downto 0) := (others => '0');
	d2: out std_logic_vector(7 downto 0) := (others => '0');
	d1: out std_logic_vector(7 downto 0) := (others => '0');
	d0: out std_logic_vector(7 downto 0) := (others => '0')
 );
end conv_bcd;

architecture converter of conv_bcd is

begin
 process(bin)
	variable i : integer range 0 to 8 := 0;
	variable bcd_temp : std_logic_vector(20 downto 0);
 begin
	bcd_temp := (others => '0'); -- bcd = "000000000"
	bcd_temp(8 downto 0) := bin;
	for i in 0 to 8 loop  
		
		bcd_temp( 19 downto 0 ) := bcd_temp( 18 downto 0 )  & '0'; -- Dich bit sang trai
			
		if (i<8 and bcd_temp(12 downto 9) > "0100") then
			bcd_temp(12 downto 9) := bcd_temp(12 downto 9) + "0011";
		end if;
		 
		if (i<8 and bcd_temp(16 downto 13) > "0100") then 
			bcd_temp(16 downto 13) := bcd_temp(16 downto 13) + "0011";
		end if;
			 
		if (i<8 and bcd_temp(20 downto 17) > "0100") then 
			bcd_temp(20 downto 17) := bcd_temp(20 downto 17) + "0011";
		end if;
			 
	end loop;

	d2 <= (bcd_temp(20 downto 17)) + X"00";
	d1 <= (bcd_temp(16 downto 13)) + X"00";
	d0 <= (bcd_temp(12 downto 9)) + X"00";
	
 end process;
 
end converter;
