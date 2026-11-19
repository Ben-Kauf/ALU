Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity ECE501HW2 is
	generic (
		bit_depth		:integer := 32);
	port (
		opcode			: in std_logic_vector(3 downto 0);
		--Signed values allow for arithemetic operations such as + and -
		A					: in signed(bit_depth-1 downto 0);
		B					: in signed(bit_depth-1 downto 0);
		result			: out signed(bit_depth-1 downto 0);
		ERROR				: out std_logic
	);
end ECE501HW2;

architecture behavior of ECE501HW2 is

	begin
	
		state_operation: process(opcode, A, B)
			variable	temp	: std_logic;
			begin
				ERROR <= '0';
				
				case opcode is
					--Not A
					when "0000" => result <= not A;
					--Not B
					when "0001" => result <= not B;
					--Addition A+B
					when "0010" => result <= A+B;
					--Subtraction A-B
					when "0011" => result <= A-B;
					--SLL for A (i.e A x 2)
					-- sll and srl ideas came from ECE 314
					-- looked up operators in VHDL came across this website: https://technobyte.org/operators-vhdl/
					-- saw sra and sll were built-in operators so that could save logic elements and eliminate the need to create another for loop
					--Is there a way to make functions in behavioral VHDL? That would simplify the code even more.
					when "0100" => result <= A sll 1;
					--Sign shift right by 2 bits
					when "0101" => result <= shift_right(A, 2);
					--SLL for B (i.e B x 2)
					when "0110" => result <= B sll 1;
					--Sign shift right
					when "0111" => result <= shift_right(B, 2);
					--Flip bits of A
					when "1000" => 
						for i in 0 to bit_depth-1 loop
							result(i) <= A(bit_depth-1-i);
						end loop;		
					--Flip bits of B
					when "1001" =>
						for i in 0 to bit_depth-1 loop
								result(i) <= B(bit_depth-1-i);
							end loop;
					--bitwise AND
					when "1010" => result <= A AND B;
					--bitwise OR
					when "1011" => result <= A OR B;
					--Else throw Error
					when others => result <= (others => 'X');
				end case;
			end process;
end behavior;
					
		