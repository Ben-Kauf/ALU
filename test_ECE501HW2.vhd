library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

use std.textio.all;
use ieee.std_logic_textio.all;


entity test_ECE501HW2 is
end;

architecture test of test_ECE501HW2 is

component ECE501HW2
	Port (
		opcode			: in std_logic_vector(3 downto 0);
		A					: in signed(31 downto 0);
		B					: in signed(31 downto 0);
		result			: out signed(31 downto 0);
		ERROR				: out std_logic
	);
end component;

signal opcode_input	:	std_logic_vector(3 downto 0);
signal A_input			:	signed(31 downto 0);
signal B_input			: signed(31 downto 0);
signal test_result	: signed(31 downto 0);
signal expected_output : signed(31 downto 0);
signal test_ERROR		  : std_logic;

begin 
	dev_to_test: ECE501HW2 port map (
		A => A_input, B => B_input, opcode => opcode_input,
		result => test_result, ERROR => test_ERROR);
		
		expected_proc : process(opcode_input, A_input, B_input)
			variable i : integer := 0;
			variable total_indexes : integer := 31;
			variable sign : std_logic;
			variable intermed : std_logic_vector(31 downto 0);
			variable new_reg : std_logic_vector(31 downto 0);
			variable temp : std_logic_vector(31 downto 0);
			variable carry : integer := 0;
			variable first : integer:= 0;
			variable temp_B : std_logic_vector(31 downto 0);
			begin
				case opcode_input is 
				
					when "0000" => 
						for i in 0 to 31 loop
							expected_output(i) <= not A_input(i);
						end loop;
						
					when "0001" =>
						for i in 0 to 31 loop
							expected_output(i) <= not B_input(i);
						end loop;
					-- A + B
					when "0010" => 
						carry := 0;
						for i in 0 to 31 loop
							if(A_input(i) ='0' and B_input(i) ='0' and carry = 0) then
								temp(i) := '0';
							elsif(A_input(i) ='0' and B_input(i) ='0' and carry = 1) then
								temp(i) := '1';
								carry := 0;
							elsif(A_input(i) ='1' and B_input(i) ='0' and carry = 0) then
								temp(i) := '1';
								carry := 0;
							elsif(A_input(i) ='0' and B_input(i) ='1' and carry = 0) then
								temp(i) := '1';
								carry := 0;
							elsif(A_input(i) ='1' and B_input(i) ='1' and carry = 0) then
								temp(i) := '0';
								carry := 1;
							elsif(A_input(i) ='1' and B_input(i) ='0' and carry = 1) then
								temp(i) := '0';
								carry := 1;
							elsif(A_input(i) ='0' and B_input(i) ='1' and carry = 1) then
								temp(i) := '0';
								carry := 1;
							elsif(A_input(i) = '1' and B_input(i) ='1' and carry = 1) then
								temp(i) := '1';
								carry := 1;
							end if;
						end loop;
						expected_output <= signed(temp);
					-- subtraction using 2's complement A - B
					when "0011" => 
					first := 0;
					carry := 0;
					for i in 0 to 31 loop
						if(B_input(i) = '0' and first = 0) then
							temp_B(i) := '0';
						elsif(B_input(i) = '1' and first =0) then
							temp_B(i) := '1';
							first := 1;
						elsif(B_input(i) = '0' and first = 1) then
							temp_B(i) := '1';
						elsif(B_input(i) = '1' and first = 1) then
							temp_B(i) := '0';
						end if;
					end loop;

					for i in 0 to 31 loop
							if(A_input(i) ='0' and temp_B(i) ='0' and carry = 0) then
								temp(i) := '0';
							elsif(A_input(i) ='0' and temp_B(i) ='0' and carry = 1) then
								temp(i) := '1';
								carry := 0;
							elsif(A_input(i) ='1' and temp_B(i) ='0' and carry = 0) then
								temp(i) := '1';
								carry := 0;
							elsif(A_input(i) ='0' and temp_B(i) ='1' and carry = 0) then
								temp(i) := '1';
								carry := 0;
							elsif(A_input(i) ='1' and temp_B(i) ='1' and carry = 0) then
								temp(i) := '0';
								carry := 1;
							elsif(A_input(i) ='1' and temp_B(i) ='0' and carry = 1) then
								temp(i) := '0';
								carry := 1;
							elsif(A_input(i) ='0' and temp_B(i) ='1' and carry = 1) then
								temp(i) := '0';
								carry := 1;
							elsif(A_input(i) = '1' and temp_B(i) ='1' and carry = 1) then
								temp(i) := '1';
								carry := 1;
							end if;
						end loop;
						expected_output <= signed(temp);
					
					--shift left by 1 for A
					when "0100" =>
						new_reg(0) := '0';
						for i in 0 to 30 loop
							new_reg(i+1) := A_input(i);
						end loop;
						expected_output <= signed(new_reg);
					--shift A right by 2
					when "0101" => 
						for i in 31 downto 2 loop
							sign := A_input(31);
							intermed(i-2) := A_input(i);
						end loop;
						intermed(31) := sign;
						intermed(30) := sign;
						expected_output <= signed(intermed);
					--shift B left by 1
					when "0110" =>
						new_reg(0) := '0';
						for i in 0 to 30 loop
							new_reg(i+1) := B_input(i);
						end loop;
						expected_output <= signed(new_reg);
					--shift A right by 2
					when "0111" =>
					--same as "0101
						for i in 31 downto 2 loop
							sign := A_input(31);
							intermed(i-2) := B_input(i);
						end loop;
						intermed(31) := sign;
						intermed(30) := sign;
						expected_output <= signed(intermed);
					
					--flips bits from lsb to msb for A_input
					when "1000" => 
						for i in 0 to 31 loop
							temp(i) := A_input(31-i);
						end loop;
						expected_output <= signed(temp);
					--flips bits from lsb to msb for B_input
					when "1001" =>
						for i in 0 to 31 loop
							temp(i) := B_input(31 - i);
						end loop;
						expected_output <= signed(temp);
						
					--Checks bitwise AND
					when "1010" =>
						for i in 0 to 31 loop
							expected_output(i) <= A_input(i) AND B_input(i);
						end loop;
						
					--Checks bitwise OR
					when "1011" => 
						for i in 0 to 31 loop
							expected_output(i) <= A_input(i) OR B_input(i);
						end loop;
					--Every other opcode
					when others => expected_output <= (others =>'X');
					
					end case;
				end process expected_proc;
				
				stimulus : process
				
				variable ErrCnt : integer := 0;
				variable WriteBuf : line;
				
				begin
					for i in 0 to 11 loop
						opcode_input <= std_logic_vector(to_unsigned(i, opcode_input'length));
						for j in 0 to 10000000 loop
							A_input <= to_signed(j, A_input'length);
							for k in 0 to 1000000 loop
								B_input <= to_signed(k, B_input'length);
						
								wait for 10 ns;
								if(expected_output /= test_result) then
									write(WriteBuf, String'("ERROR ALU tested failed at opcode_input = "));
									write(WriteBuf, opcode_input);
									writeline(Output, WriteBuf);
									
									write(WriteBuf, String'("Output = ")); 
									write(WriteBuf, std_logic_vector(test_result));
									write(WriteBuf, String'(". Exp. Output = "));
									write(WriteBuf, std_logic_vector(expected_output));
									writeline(Output, WriteBuf);
									
									ErrCnt := ErrCnt + 1;
								end if;
							end loop;
						end loop;
					end loop;
				
					if(ErrCnt = 0) then
						report "Success! ALU Test Completed.";
					else
						report "The ALU is broken." severity error;
					end if;
				end process stimulus;
			end test;
							
					
							
							
							
						