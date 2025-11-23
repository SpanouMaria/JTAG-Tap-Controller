library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Entity of IR 
entity IR is
	Port (
		Data : in STD_LOGIC; -- Parallel data input
		 TDI : in STD_LOGIC; -- Serial data input (Test Data In)
		 ShiftIR : in STD_LOGIC; -- Control signal: selects serial shifting
		 ClockIR : in STD_LOGIC; -- Clock signal for shifting
		 UpdateIR : in STD_LOGIC; -- Clock signal for updating (latching)
		 ParallelOut : out STD_LOGIC; -- Parallel output (latched value)
		 TDO : out STD_LOGIC -- Serial data output (Test Data Out)
	 );
end IR;
architecture Behavioral of IR is
	 signal SRFFQ : STD_LOGIC := '0'; -- Output of the Shift Register Flip-Flop
	 signal LFFQ : STD_LOGIC := '0'; -- Output of the Latch Flip-Flop
	 signal DfromMux : STD_LOGIC; -- Output of the multiplexer
begin
	 -- Multiplexer: selects between serial input (TDI) and parallel input (Data)
	 DfromMux <= TDI when ShiftIR = '1' else Data;
	 -- TDO outputs the current value of the shift flip-flop
	 TDO <= SRFFQ;
	 -- ParallelOut outputs the value stored in the latch flip-flop
	 ParallelOut <= LFFQ;
	 -- Shift Register Flip-Flop (SRFF)
	 -- On rising edge of ClockIR, load the value from the multiplexer
	 process(ClockIR)
	 begin
		 if rising_edge(ClockIR) then
		 SRFFQ <= DfromMux;
		 end if;
	 end process;
	 -- Latch Flip-Flop (LFF)
	 -- On rising edge of UpdateIR, latch the current SRFFQ value
	 process(UpdateIR)
	 begin
		 if rising_edge(UpdateIR) then
		 LFFQ <= SRFFQ;
	 end if;
 end process;
end Behavioral;