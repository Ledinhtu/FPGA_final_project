----Entity: lcd_controller-----

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity lcd_controller is
port(
	clk : in std_logic; -- 50MHz
	----- d = d2d1d0
	d2: in std_logic_vector(7 downto 0) := (others => '0');
	d1: in std_logic_vector(7 downto 0) := (others => '0');
	d0: in std_logic_vector(7 downto 0) := (others => '0');
	lcd_rw, lcd_rs, lcd_en : out std_logic := '0'; --read/write, setup/data, and enable for lcd
	lcd_data_out : out std_logic_vector(7 downto 0) := x"00" --data signals for lcd
	);
end lcd_controller;
architecture controller of lcd_controller is
	--state machine 
	type lcd_sm is(lcd_power_up, lcd_init, lcd_display);
	signal state : lcd_sm := lcd_power_up;

	type lcd_cmd_array is array (integer range 0 to 4) of std_logic_vector(7 downto 0);
	constant lcd_cmd: lcd_cmd_array := (
												0	=>	x"38",	--function set
												1	=>	x"0c",	--display on/off control
												2	=>	x"01",	--clear display (1.52ms)		
												3	=>	x"06",	--entry mode set
												4	=>	x"80"		--set ddram address
												);
	type lcd_data_array is array (0 to 15) of std_logic_vector( 7 downto 0 );
	signal display_data : lcd_data_array := (x"44",x"49",x"53",x"54",x"41",x"4e",x"43",x"45",x"3a",x"20",x"43",x"43",x"43",x"20",x"43",x"4d"); --distance: d2d1d0 cm----
												
	signal ptr: integer range 0 to 15 := 0;
	signal clk_count : integer range 0 to 2500000:= 0; 
begin
	display_data(10) <= d2 + x"30";
	display_data(11) <= d1 + x"30";
	display_data(12) <= d0 + x"30";
	lcd_rw <= '0';
	process(clk)	
	begin
	if (rising_edge(clk)) then
		case state is
		when lcd_power_up =>
			if(clk_count < 2500000) then --wait 50 ms
				clk_count <= clk_count + 1;
				state <= lcd_power_up;
			else -- power-up complete
				clk_count <= 0;
				state <= lcd_init;
			end if;
		when lcd_init =>
			lcd_rs <= '0';
			lcd_data_out <= lcd_cmd(ptr);
			clk_count <= clk_count + 1;
			if(clk_count = 5)	then lcd_en <= '1';	-- wait 100ns (min 60ns)
			elsif(clk_count = 30)	then lcd_en <= '0';	-- wait 500ms (min 450ns) 
			elsif(clk_count = 76030)	then clk_count <= 0;	-- wait min 1.52ms (cmd 'clear display')
				if ptr = 4 then			-- send init cmd complete
					state <= lcd_display;
					ptr <= 0;
				else					
					ptr <= ptr + 1;
				end if;
			end if;
		when lcd_display =>	
			lcd_rs <= '1';
			clk_count <= clk_count + 1;
			lcd_data_out <= display_data(ptr);
			if(clk_count = 5)	then lcd_en <= '1';	-- wait min 60ns
			elsif(clk_count = 30)	then lcd_en <= '0';	-- wait 500ms (min 450ns) 
			elsif(clk_count = 2000)	then clk_count <= 0;	-- wait 37us (min 37us)
				if ptr = 15 then	
					state <= lcd_init;
					ptr <= 4;		-- set ddram address = 00
				else					
					ptr <= ptr + 1;
				end if;
			end if;
	end case;
	end if;
	end process;
end controller;
 
