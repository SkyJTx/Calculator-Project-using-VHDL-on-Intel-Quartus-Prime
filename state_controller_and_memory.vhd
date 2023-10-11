library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_controller_and_memory is
	generic(
		bit_length: positive
	);
	port(
		SWs: in std_logic_vector(2*bit_length-1 downto 0);
		button, reset, clock: in std_logic;
		operand1, operand2: out std_logic_vector(bit_length-1 downto 0);
		operator, state: out std_logic_vector(1 downto 0);
		done: out std_logic
	);
end entity state_controller_and_memory;

architecture main of state_controller_and_memory is
	type state_type is (
		oprds,
		oprt,
		rslt
	);
	signal curr_operand1, curr_operand2: std_logic_vector(bit_length-1 downto 0) := (others => '0');
	signal curr_operator, out_state: std_logic_vector(1 downto 0) := (others => '0');
	signal curr_state: state_type := oprds;
	signal curr_done: std_logic := '0';

begin
	process(clock, button, reset, SWs) begin
		
		if rising_edge(button) then
			case curr_state is
				when oprds => curr_state <= oprt;
				when oprt => curr_state <= rslt;
				when rslt => curr_state <= rslt;
			end case;
		end if;

		if reset = '0' then
			curr_operand1 <= (others => '0');
			curr_operand2 <= (others => '0');
			curr_operator <= (others => '0');
			curr_done <= '0';
			out_state <= (others => '0');
			curr_state <= oprds;
		elsif rising_edge(clock) then
			if curr_state = oprds then
				out_state <= "00";
				curr_operand1 <= SWs(2*bit_length-1 downto bit_length);
				curr_operand2 <= SWs(bit_length-1 downto 0);
			elsif curr_state = oprt then
				out_state <= "01";
				curr_operator <= SWs(1 downto 0);
			elsif curr_state = rslt then
				out_state <= "10";
				curr_done <= '1';
			end if;
		end if;

	end process;

	operand1 <= curr_operand1;
	operand2 <= curr_operand2;
	operator <= curr_operator;
	state <= out_state;
	done <= curr_done;

end architecture main;