---------------

library ieee;
use ieee.std_logic_1164.all;

entity hcsr04_lcd is
generic ( max_bit_counter : integer := 21);
port(
	fpga_clk : in std_logic; -- 50MHz
	------------------
	echo : in std_logic;
	trig : out std_logic;
	-------------------
	lcd_rw, lcd_rs, lcd_en : out std_logic := '0'; --read/write, setup/data, and enable for lcd
	lcd_data_out : out std_logic_vector(7 downto 0) := x"00" --data signals for lcd
	);
end hcsr04_lcd;

architecture top_entity of hcsr04_lcd is

--component test_input is
--	port (
--		clk : in std_logic;
--		bint: out std_logic_vector(8 downto 0) := (others => '0')		
--	);
--end component;

component conv_bcd is
 port(
	bin: in std_logic_vector(8 downto 0) := (others => '0');
	d2: out std_logic_vector(7 downto 0) := (others => '0');
	d1: out std_logic_vector(7 downto 0) := (others => '0');
	d0: out std_logic_vector(7 downto 0) := (others => '0')
 );
end component;

component lcd_controller is
port(
	clk : in std_logic; 
	----- d = d2d1d0
	d2: in std_logic_vector(7 downto 0) := (others => '0');
	d1: in std_logic_vector(7 downto 0) := (others => '0');
	d0: in std_logic_vector(7 downto 0) := (others => '0');
	lcd_rw, lcd_rs, lcd_en : out std_logic := '0'; --read/write, setup/data, and enable for lcd
	lcd_data_out : out std_logic_vector(7 downto 0) := x"00" --data signals for lcd
	);
end component;

component distance_calcualtion is
	generic ( N : integer := 21);
	port (
		echo : in std_logic; 
		echo_cnt  : in std_logic_vector (N-1 downto 0);
		distance: out std_logic_vector(8 downto 0) := (others => '0')
	);
end component;

component trigger_generator is
generic ( N : integer := 24);
port(
	clk : in std_logic; 
	trigger : out std_logic
	);
end component;

component echo_counter is
	generic ( N : integer := 21);
	port (
		clk	: in std_logic;
		enable  : in std_logic;
		reset	  : in std_logic;
		cnt_out  : out std_logic_vector (N-1 downto 0)
	);

end component;

signal temp_bin: std_logic_vector(8 downto 0) := (others => '0'); 
signal temp_d2: std_logic_vector(7 downto 0) := (others => '0'); 
signal temp_d1: std_logic_vector(7 downto 0) := (others => '0'); 
signal temp_d0: std_logic_vector(7 downto 0) := (others => '0'); 
signal temp_trigger:  std_logic := '0';
signal temp_counter_out : std_logic_vector (max_bit_counter-1 downto 0) := (others => '0');

begin
--ut: test_input port map(fpga_clk, temp_bin);
trig <= temp_trigger;

U0: trigger_generator port map(fpga_clk, temp_trigger);

U1: echo_counter generic map (max_bit_counter) port map(fpga_clk, echo, temp_trigger, temp_counter_out);

U2: distance_calcualtion generic map (max_bit_counter) port map(echo, temp_counter_out, temp_bin);

U3: conv_bcd port map(temp_bin, temp_d2, temp_d1, temp_d0);

U4: lcd_controller port map(	fpga_clk, 
										temp_d2, temp_d1, temp_d0,
										lcd_rw, lcd_rs, lcd_en,
										lcd_data_out
									);
 
end top_entity;