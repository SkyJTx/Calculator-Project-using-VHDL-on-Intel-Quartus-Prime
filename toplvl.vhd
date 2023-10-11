library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculatorProject is
	generic(
		bit_length: positive := 5
	);
	port(
		start, reset, clock: in std_logic;
		SWs: in std_logic_vector(2*bit_length-1 downto 0);
		seven_segment_digit1, seven_segment_digit2, seven_segment_digit3, seven_segment_digit4, seven_segment_digit5, seven_segment_digit6: out std_logic_vector(0 to 6);
		done: out std_logic_vector(0 to 9)
	);
end entity calculatorProject;

architecture main of calculatorProject is
	signal operand1, operand2, result, remainder: std_logic_vector(bit_length-1 downto 0) := (others => '0');
	signal operator, curr_operator, state: std_logic_vector(1 downto 0) := (others => '0');
	signal curr_done, error: std_logic := '0';

begin
	SCaM: entity work.state_controller_and_memory(main)
		generic map(
			bit_length => bit_length
		)
		port map(
			SWs => SWs,
			button => start,
			reset => reset,
			clock => clock,
			operand1 => operand1,
			operand2 => operand2,
			operator => operator,
			state => state,
			done => curr_done
		);
	AO: entity work.arithmetic_operation(main)
		generic map(
			bit_length => bit_length
		)
		port map(
			operand1 => operand1,
			operand2 => operand2,
			in_operator => operator,
			clock => clock,
			result => result,
			remainder => remainder,
			error => error,
			out_operator => curr_operator
		);
	DC: entity work.display_controller(main)
		generic map(
			bit_length => bit_length
		)
		port map(
			operand1 => operand1,
			operand2 => operand2,
			result => result,
			remainder => remainder,
			state => state,
			operator => curr_operator,
			error => error,
			clock => clock,
			seven_segment_digit1 => seven_segment_digit1,
			seven_segment_digit2 => seven_segment_digit2,
			seven_segment_digit3 => seven_segment_digit3,
			seven_segment_digit4 => seven_segment_digit4,
			seven_segment_digit5 => seven_segment_digit5,
			seven_segment_digit6 => seven_segment_digit6
		);
	done_led: for i in 0 to 9 generate
		done(i) <= curr_done;
	end generate;
end architecture main;
