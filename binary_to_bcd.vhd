library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_to_bcd is
	generic(
		bit_length: positive := 5
	);
	port(
		in_binary: in std_logic_vector(bit_length-1 downto 0);
		in_operator: in std_logic_vector(1 downto 0);
		in_error, clock: in std_logic;
		out_bcd1, out_bcd2, out_bcd3: out std_logic_vector(3 downto 0)
	);
end entity binary_to_bcd;

architecture operand of binary_to_bcd is
	signal signbit: std_logic := '0';
	signal absolute: std_logic_vector(bit_length-1 downto 0) := (others => '0');

begin
	signbit <= in_binary(bit_length-1);
	ABSOLUTE_OPERATION: entity work.binary_adder_and_subtractor(main)
		generic map(
			bit_length => bit_length-1
		)
		port map(
			in_a => (others => '0'),
			in_b => in_binary(bit_length-2 downto 0),
			subtract => signbit,
			out_sum => absolute(bit_length-2 downto 0),
			out_carry => absolute(bit_length-1)
		);
	process(clock) begin
		if rising_edge(clock) then
			out_bcd2 <= std_logic_vector(to_unsigned(to_integer(unsigned(absolute)) / 10, out_bcd2'length));
			out_bcd1 <= std_logic_vector(to_unsigned(to_integer(unsigned(absolute)) mod 10, out_bcd1'length));
			case signbit is
				when '0' => out_bcd3 <= "1011";
				when '1' => out_bcd3 <= "1010";
			end case;
		end if;
	end process;
end architecture operand;

architecture operator of binary_to_bcd is

begin
	process(clock) begin
		if rising_edge(clock) then
			out_bcd1 <= std_logic_vector(to_unsigned(to_integer(unsigned(in_operator)), out_bcd1'length));
			out_bcd2 <= std_logic_vector(to_unsigned(to_integer(unsigned(in_operator)), out_bcd2'length));
			out_bcd3 <= std_logic_vector(to_unsigned(to_integer(unsigned(in_operator)), out_bcd3'length));
		end if;
	end process;
end architecture operator;

architecture result of binary_to_bcd is
	signal signbit: std_logic := '0';
	signal absolute: std_logic_vector(bit_length-1 downto 0) := (others => '0');

begin
	signbit <= in_binary(bit_length-1);
	ABSOLUTE_OPERATION: entity work.binary_adder_and_subtractor(main)
		generic map(
			bit_length => bit_length-1
		)
		port map(
			in_a => (others => '0'),
			in_b => in_binary(bit_length-2 downto 0),
			subtract => signbit,
			out_sum => absolute(bit_length-2 downto 0),
			out_carry => absolute(bit_length-1)
		);
	process(clock) begin
		if rising_edge(clock) then
			out_bcd2 <= std_logic_vector(to_unsigned(to_integer(unsigned(absolute)) / 10, out_bcd2'length));
			out_bcd1 <= std_logic_vector(to_unsigned(to_integer(unsigned(absolute)) mod 10, out_bcd1'length));
			case signbit is
				when '0' => out_bcd3 <= "1011";
				when '1' => out_bcd3 <= "1010";
			end case;

			if in_error = '1' then
				out_bcd1 <= "1111";
				out_bcd2 <= "1111";
				out_bcd3 <= "1111";
			end if;
		end if;
	end process;

end architecture result;

architecture remainder of binary_to_bcd is
	signal signbit: std_logic := '0';
	signal absolute: std_logic_vector(bit_length-1 downto 0) := (others => '0');

begin
	signbit <= in_binary(bit_length-1);
	ABSOLUTE_OPERATION: entity work.binary_adder_and_subtractor(main)
		generic map(
			bit_length => bit_length-1
		)
		port map(
			in_a => (others => '0'),
			in_b => in_binary(bit_length-2 downto 0),
			subtract => signbit,
			out_sum => absolute(bit_length-2 downto 0),
			out_carry => absolute(bit_length-1)
		);
	process(clock) begin
		if rising_edge(clock) then
			out_bcd2 <= std_logic_vector(to_unsigned(to_integer(unsigned(absolute)) / 10, out_bcd2'length));
			out_bcd1 <= std_logic_vector(to_unsigned(to_integer(unsigned(absolute)) mod 10, out_bcd1'length));
			case signbit is
				when '0' => out_bcd3 <= "1011";
				when '1' => out_bcd3 <= "1010";
			end case;
			
			if in_operator /= "11" then
				out_bcd1 <= "1011";
				out_bcd2 <= "1011";
				out_bcd3 <= "1011";
			end if;

			if in_error = '1' then
				out_bcd1 <= "1111";
				out_bcd2 <= "1111";
				out_bcd3 <= "1111";
			end if;
		end if;
	end process;

end architecture remainder;
