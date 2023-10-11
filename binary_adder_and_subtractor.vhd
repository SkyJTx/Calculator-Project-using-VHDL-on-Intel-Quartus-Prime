library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_adder_and_subtractor is
	generic(
		bit_length: positive
	);
	port(
		in_a, in_b: in std_logic_vector(bit_length-1 downto 0);
		subtract: in std_logic;
		out_sum: out std_logic_vector(bit_length-1 downto 0);
		out_carry, out_error: out std_logic
	);
end entity binary_adder_and_subtractor;

architecture main of binary_adder_and_subtractor is
	signal carry_array: std_logic_vector(bit_length downto 0) := (others => '0');

begin
	carry_array(0) <= subtract;

	full_adder: for i in 0 to bit_length-1 generate
		out_sum(i) <= in_a(i) xor (in_b(i) xor subtract) xor carry_array(i);
		carry_array(i+1) <= ((in_a(i) xor (in_b(i) xor subtract)) and carry_array(i)) or (in_a(i) and (in_b(i) xor subtract));
	end generate;

	out_carry <= carry_array(bit_length);
	out_error <= carry_array(bit_length) xor carry_array(bit_length-1);

end architecture main;
