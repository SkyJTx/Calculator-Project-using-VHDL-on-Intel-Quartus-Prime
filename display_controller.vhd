library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_controller is
	generic(
		bit_length: positive := 5
	);
	port(
		operand1, operand2, result, remainder: in std_logic_vector(bit_length-1 downto 0);
		state, operator: in std_logic_vector(1 downto 0);
		error, clock: in std_logic;
		seven_segment_digit1, seven_segment_digit2, seven_segment_digit3, seven_segment_digit4, seven_segment_digit5, seven_segment_digit6: out std_logic_vector(0 to 6)
	);
end entity display_controller;

architecture main of display_controller is
	signal bcd_oprd11, bcd_oprd12, bcd_oprd13, bcd_oprd21, bcd_oprd22, bcd_oprd23, bcd_oprt, bcd_res1, bcd_res2, bcd_res3, bcd_rem1, bcd_rem2, bcd_rem3, bcd_7seg1, bcd_7seg2, bcd_7seg3, bcd_7seg4, bcd_7seg5, bcd_7seg6: std_logic_vector(3 downto 0) := (others => '0');

begin
	binary_to_bcd_for_operand1: entity work.binary_to_bcd(operand)
		generic map(
			bit_length => bit_length
		)
		port map(
			in_binary => operand1,
			in_operator => operator,
			in_error => '0',
			clock => clock,
			out_bcd1 => bcd_oprd11,
			out_bcd2 => bcd_oprd12,
			out_bcd3 => bcd_oprd13
		);
	binary_to_bcd_for_operand2: entity work.binary_to_bcd(operand)
		generic map(
			bit_length => bit_length
		)
		port map(
			in_binary => operand2,
			in_operator => operator,
			in_error => '0',
			clock => clock,
			out_bcd1 => bcd_oprd21,
			out_bcd2 => bcd_oprd22,
			out_bcd3 => bcd_oprd23
		);
	binary_to_bcd_for_operator: entity work.binary_to_bcd(operator)
		generic map(
			bit_length => 2
		)
		port map(
			in_binary => operator,
			in_operator => operator,
			in_error => '0',
			clock => clock,
			out_bcd1 => bcd_oprt
		);
	binary_to_bcd_for_result: entity work.binary_to_bcd(result)
		generic map(
			bit_length => bit_length
		)
		port map(
			in_binary => result,
			in_operator => operator,
			in_error => error,
			clock => clock,
			out_bcd1 => bcd_res1,
			out_bcd2 => bcd_res2,
			out_bcd3 => bcd_res3
		);
	binary_to_bcd_for_remainder: entity work.binary_to_bcd(remainder)
		generic map(
			bit_length => bit_length
		)
		port map(
			in_binary => remainder,
			in_operator => operator,
			in_error => error,
			clock => clock,
			out_bcd1 => bcd_rem1,
			out_bcd2 => bcd_rem2,
			out_bcd3 => bcd_rem3
		);
	process(clock) begin
		if rising_edge(clock) then
			if state = "00" then
				bcd_7seg4 <= bcd_oprd11;
				bcd_7seg5 <= bcd_oprd12;
				bcd_7seg6 <= bcd_oprd13;
				bcd_7seg1 <= bcd_oprd21;
				bcd_7seg2 <= bcd_oprd22;
				bcd_7seg3 <= bcd_oprd23;
			elsif state = "01" then
				bcd_7seg4 <= bcd_oprt;
				bcd_7seg5 <= bcd_oprt;
				bcd_7seg6 <= bcd_oprt;
				bcd_7seg1 <= bcd_oprt;
				bcd_7seg2 <= bcd_oprt;
				bcd_7seg3 <= bcd_oprt;
			elsif state = "10" then
				bcd_7seg4 <= bcd_res1;
				bcd_7seg5 <= bcd_res2;
				bcd_7seg6 <= bcd_res3;
				bcd_7seg1 <= bcd_rem1;
				bcd_7seg2 <= bcd_rem2;
				bcd_7seg3 <= bcd_rem3;
			end if;
		end if;
	end process;
	bcd_to_7segment1: entity work.bcd_to_7segment(main)
		port map(
			in_bcd => bcd_7seg1,
			clock => clock,
			out_7segment => seven_segment_digit1
		);
	bcd_to_7segment2: entity work.bcd_to_7segment(main)
		port map(
			in_bcd => bcd_7seg2,
			clock => clock,
			out_7segment => seven_segment_digit2
		);
	bcd_to_7segment3: entity work.bcd_to_7segment(main)
		port map(
			in_bcd => bcd_7seg3,
			clock => clock,
			out_7segment => seven_segment_digit3
		);
	bcd_to_7segment4: entity work.bcd_to_7segment(main)
		port map(
			in_bcd => bcd_7seg4,
			clock => clock,
			out_7segment => seven_segment_digit4
		);
	bcd_to_7segment5: entity work.bcd_to_7segment(main)
		port map(
			in_bcd => bcd_7seg5,
			clock => clock,
			out_7segment => seven_segment_digit5
		);
	bcd_to_7segment6: entity work.bcd_to_7segment(main)
		port map(
			in_bcd => bcd_7seg6,
			clock => clock,
			out_7segment => seven_segment_digit6
		);
end architecture main;
		
		