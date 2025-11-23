library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity of BSC
entity BSC is 
	port(
		input_pin  : in std_logic;   -- Input signal from the external pin
		shiftIn    : in std_logic;   -- Serial data input (from previous scan cell)
		clkDr      : in std_logic;   -- Clock for shift/capture operations
		shiftDr    : in std_logic;   -- Control signal for shift mode
		updDr      : in std_logic;   -- Control signal for update mode
		mode       : in std_logic;   -- Mode select: '1' for test mode, '0' for normal mode
		shiftOut   : out std_logic;  -- Serial data output (to next scan cell)
		output_pin : out std_logic); -- Output driven to external pin or internal logic
end BSC;

architecture Behavioral of BSC is 

	signal D_in1 : std_logic;          -- Input to the capture flip-flop (CAP FF)
	signal Q1    : std_logic  := '0';  -- Output of the capture flip-flop (CAP FF)
	signal Q2    : std_logic  := '0';  -- Output of the update flip-flop (UPD FF)

	
	begin

    -- MUX1: Select between serial input (shiftIn) or normal input (input_pin)
    -- If shiftDr = '1', we are in shift mode, so take serial input
    -- Otherwise, capture the value from input_pin
    D_in1 <= shiftIn when shiftDr = '1' else input_pin;

    -- CAP Flip-Flop: Captures D_in1 on rising edge of clkDr
    process(clkDr)
    begin
        if rising_edge(clkDr) then
            Q1 <= D_in1;
        end if;
    end process;

    -- UPD Flip-Flop: Latches Q1 into Q2 on rising edge of updDr
    process(updDr)
    begin
        if rising_edge(updDr) then
            Q2 <= Q1;
        end if;
    end process;

    -- shiftOut: Outputs the captured value (Q1) to the next scan cell
    shiftOut <= Q1;

    -- MUX2: Drives the output pin
    -- If mode = '1' (test mode), use the value latched in Q2
    -- If mode = '0' (normal operation), use input_pin directly
    output_pin <= Q2 when mode = '1' else input_pin;

end Behavioral;