library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_multiplier is
	generic(
		bit_length: positive := 5
	);
	port(
		in_a, in_b: in std_logic_vector(bit_length-1 downto 0);
		clock: in std_logic;
		out_product: out std_logic_vector(bit_length-1 downto 0);
		out_error: out std_logic
	);
end entity binary_multiplier;

architecture main of binary_multiplier is
	type state_type is (
		check,
		multiply
	);
	signal a: std_logic_vector(bit_length-1 downto 0) := in_a;
	signal conv_a, previn_a, previn_b, intermediate_product: std_logic_vector(bit_length-1 downto 0) := (others => '0');
	signal error, locker: std_logic := '0';
	signal curr_state: state_type := check;
	signal count: integer := 0;

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
	
	process(clock) begin
		if rising_edge(clock) then
			if conv_a /= previn_a or in_b /= previn_b then
				a <= conv_a;
				locker <= '0';
				count <= 0;
				curr_state <= check;
			end if;

			previn_a <= conv_a;
			previn_b <= in_b;

			case curr_state is
				when multiply =>
					if count < abs(to_integer(signed(previn_b))) - 1 then
						if locker = '0' then
							locker <= error;
						end if;

                        a <= intermediate_product;
						count <= count + 1;
					end if;
				when check =>
					if (to_integer(signed(previn_a)) /= 0) and (to_integer(signed(previn_b)) /= 0) then
						curr_state <= multiply;
					end if;
			end case;

		end if;
	end process;

	binary_adder: entity work.binary_adder_and_subtractor(main)
		generic map(
			bit_length => bit_length
		)
		port map(
			in_a => a,
			in_b => previn_a,
			subtract => '0',
			out_sum => intermediate_product,
			out_error => error
		);

	out_product <= a;
	out_error <= locker;

end architecture main;