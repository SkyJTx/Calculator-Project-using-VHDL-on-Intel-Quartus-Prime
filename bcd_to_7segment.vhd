library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_to_7segment is
	port(
		in_bcd: in std_logic_vector(3 downto 0);
		clock: in std_logic;
		out_7segment: out std_logic_vector(0 to 6)
	);
end entity bcd_to_7segment;

architecture main of bcd_to_7segment is

begin
	process(clock) begin
		if rising_edge(clock) then
			case in_bcd is -- abcdefg pullup
				when "0000" => out_7segment <= "0000001"; --7-segment display number 0
				when "0001" => out_7segment <= "1001111"; --7-segment display number 1
				when "0010" => out_7segment <= "0010010"; --7-segment display number 2
				when "0011" => out_7segment <= "0000110"; --7-segment display number 3
				when "0100" => out_7segment <= "1001100"; --7-segment display number 4 
				when "0101" => out_7segment <= "0100100"; --7-segment display number 5
				when "0110" => out_7segment <= "0100000"; --7-segment display number 6
				when "0111" => out_7segment <= "0001111"; --7-segment display number 7
				when "1000" => out_7segment <= "0000000"; --7-segment display number 8
				when "1001" => out_7segment <= "0000100"; --7-segment display number 9
				when "1010" => out_7segment <= "1111110"; --7-segment display negative sign
				when "1011" => out_7segment <= "1111111"; --7-segment display none
				when "1111" => out_7segment <= "0111000"; --7-segment display F
				when others => out_7segment <= "0110000"; --7-segment display E
			end case;
		end if;
	end process;
end architecture main;
