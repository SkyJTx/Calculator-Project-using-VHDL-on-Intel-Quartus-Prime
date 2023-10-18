library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_divider is
	generic(
		bit_length: positive := 5
	);
	port(
		in_a, in_b: in std_logic_vector(bit_length-1 downto 0);
		clock: in std_logic;
		out_quotient, out_remainder: out std_logic_vector(bit_length-1 downto 0);
		out_error: out std_logic
	);
end entity binary_divider;

architecture main of binary_divider is
	type state_type is (
		check,
		divide
	);
	signal a: std_logic_vector(bit_length-1 downto 0) := in_a;
	signal conv_a, conv_b, previn_a, start_quotient, start_remainder, previn_b, intermediate_quotient: std_logic_vector(bit_length-1 downto 0) := (others => '0');
	signal curr_state: state_type := check;
	signal error, locker: std_logic := '0';
	signal count, is_positive: integer := 0;

begin
	a_convert: entity work.binary_adder_and_subtractor(main)
		generic map(
			bit_length => bit_length
		)
		port map(
			in_a => (others => '0'),
			in_b => in_a,
			subtract => in_b(bit_length-1),
			out_sum => conv_a
		);
	b_convert: entity work.binary_adder_and_subtractor(main)
		generic map(
			bit_length => bit_length
		)
		port map(
			in_a => (others => '0'),
			in_b => in_b,
			subtract => in_a(bit_length-1),
			out_sum => conv_b
		);
	binary_subtractor: entity work.binary_adder_and_subtractor(main)
		generic map(
			bit_length => bit_length
		)
		port map(
			in_a => a,
			in_b => conv_b,
			subtract => '1',
			out_sum => intermediate_quotient,
			out_error => error
		);
	
	process(clock) begin
		if rising_edge(clock) then
			if conv_a /= previn_a or conv_b /= previn_b then
				a <= conv_a;
				count <= 0;
				locker <= '0';
				curr_state <= check;
				previn_a <= conv_a;
				previn_b <= conv_b;
			end if;

			previn_a <= conv_a;
			previn_b <= conv_b;

			case curr_state is
				when divide =>
					if (abs(to_integer(signed(a))) + is_positive) > abs(to_integer(signed(conv_b))) then
						if locker = '0' then
							locker <= error;
						end if;

                        a <= intermediate_quotient;
						count <= count + 1;
 					end if;
				when check =>
					if to_integer(signed(conv_b)) /= 0 then
						curr_state <= divide;
						if (in_a(bit_length-1) xor in_b(bit_length-1)) = '1' then
							start_quotient <= (others => '1');
							start_remainder <= std_logic_vector(to_signed(abs(to_integer(signed(in_b))), bit_length));
							is_positive <= 0;
						else
							start_quotient <= (others => '0');
							start_remainder <= (others => '0');
							is_positive <= 1;
						end if;
					else
						locker <= '1';
					end if;
			end case;
		end if;
	end process;
	
	quotient_convert: entity work.binary_adder_and_subtractor(main)
		generic map(
			bit_length => bit_length
		)
		port map(
			in_a => start_quotient,
			in_b => std_logic_vector(to_signed(count, bit_length)),
			subtract => in_a(bit_length-1) xor in_b(bit_length-1),
			out_sum => out_quotient
		);
	remainder_convert: entity work.binary_adder_and_subtractor(main)
		generic map(
			bit_length => bit_length
		)
		port map(
			in_a => start_remainder,
			in_b => a,
			subtract => '0',
			out_sum => out_remainder
		);
	out_error <= locker;

end architecture main;