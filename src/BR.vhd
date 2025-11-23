library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity of BR
entity BR is
	port (
		TDI       : in std_logic;   -- Serial data input (Test Data In)
		CaptureDR : in std_logic;   -- Control signal to capture data
		ClockDR   : in std_logic;   -- Clock signal for capturing data
		TDO_BR    : out std_logic); -- Serial data output from boundary register
end BR;

architecture Behavioral of BR is 

	signal D_in : std_logic;          -- Internal signal: input to the flip-flop
	signal Q    : std_logic  := '0';  -- Output of the flip-flop

begin 
	
	-- Logic to control data input:
   -- D_in is high only if both TDI and CaptureDR are high
	D_in <= TDI AND CaptureDR;
	
	-- Flip-flop process triggered on rising edge of ClockDR
	process(CLockDR)
	begin
		if rising_edge(ClockDR) then
			Q <= D_in;  -- Capture the value of D_in
		end if;
	end process;
	
	-- Output the captured value on TDO_BR
	TDO_BR <= Q;

end Behavioral;