library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arithmetic_operation is
	generic(
		bit_length: positive := 5
	);
	port(
		operand1, operand2: in std_logic_vector(bit_length-1 downto 0);
		in_operator: in std_logic_vector(1 downto 0);
		clock: in std_logic;
		result, remainder: out std_logic_vector(bit_length-1 downto 0);
		error: out std_logic;
		out_operator: out std_logic_vector(1 downto 0)
	);
end entity arithmetic_operation;

architecture main of arithmetic_operation is
	signal curr_result, curr_remainder, result_oprt1, remainder_oprt1, result_oprt2, remainder_oprt2, result_oprt3, remainder_oprt3: std_logic_vector(bit_length-1 downto 0) := (others => '0');
	signal curr_error, error_oprt1, error_oprt2, error_oprt3: std_logic := '0';
	signal curr_operator: std_logic_vector(1 downto 0) := (others => '0');

begin
	BAS: entity work.binary_adder_and_subtractor(main)
		generic map(
			bit_length => bit_length
		)
		port map(
			in_a => operand1,
			in_b => operand2,
			subtract => in_operator(0),
			out_sum => result_oprt1,
			out_error => error_oprt1
		);
	BM: entity work.binary_multiplier(main)
		generic map(
			bit_length => bit_length
		)
		port map(
			in_a => operand1,
			in_b => operand2,
			clock => clock,
			out_product => result_oprt2,
			out_error => error_oprt2
		);
	BD: entity work.binary_divider(main)
		generic map(
			bit_length => bit_length
		)
		port map(
			in_a => operand1,
			in_b => operand2,
			clock => clock,
			out_quotient => result_oprt3,
			out_remainder => remainder_oprt3,
			out_error => error_oprt3
		);
	process(clock) begin
		if rising_edge(clock) then
			curr_operator <= in_operator;
			case curr_operator is
				when "00" =>
					curr_result <= result_oprt1;
					curr_remainder <= remainder_oprt1;
					curr_error <= error_oprt1;
				when "01" =>
					curr_result <= result_oprt1;
					curr_remainder <= remainder_oprt1;
					curr_error <= error_oprt1;
				when "10" =>
					curr_result <= result_oprt2;
					curr_remainder <= remainder_oprt2;
					curr_error <= error_oprt2;
				when "11" =>
					curr_result <= result_oprt3;
					curr_remainder <= remainder_oprt3;
					curr_error <= error_oprt3;
			end case;
		end if;
	end process;
	
	result <= curr_result;
	remainder <= curr_remainder;
	error <= curr_error;
	out_operator <= curr_operator;

end architecture main;
