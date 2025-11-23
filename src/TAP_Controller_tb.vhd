library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Entity of TAP_Controller_tb
entity TAP_Controller_tb is
end TAP_Controller_tb;

architecture sim of TAP_Controller_tb is

	-- Signals to drive and observe the DUT (Device Under Test)
	signal TCK   : std_logic := '0';             -- Test Clock
   signal TMS   : std_logic := '0';             -- Test Mode Select 
   signal TRST  : std_logic := '1';             -- Asynchronous reset (active high)
   signal state : std_logic_vector(3 downto 0); -- Encoded TAP state output

	-- Clock period definition
   constant clk_period : time := 10 ns;

begin

   -- Instantiate the TAP_Controller unit
   DUT: entity work.TAP_Controller
       port map (
           TCK   => TCK,
           TMS   => TMS,
           TRST  => TRST,
           state => state
       );

   -- Clock generation process for TCK (10 ns period)
   clk_process: process
   begin
       while true loop
           TCK <= '0';
           wait for clk_period / 2;
           TCK <= '1';
           wait for clk_period / 2;
       end loop;
   end process;

   -- Stimulus process to simulate TMS transitions and test the FSM
   stim_proc: process
   begin
       -- Hold TRST high to force reset
       wait for 10 ns;
       TRST <= '0';     -- Release reset to allow state transitions

       -- TMS sequence: 0 to 1 to 0 to 0 to 1
       -- Expected TAP state transitions:
       -- TestLogicReset to RunTestIdle to SelectDRScan to CaptureDR to ShiftDR to Exit1_DR
       TMS <= '0'; wait for clk_period;  -- TestLogicReset to RunTestIdle
       TMS <= '1'; wait for clk_period;  -- RunTestIdle to SelectDRScan
       TMS <= '0'; wait for clk_period;  -- SelectDRScan to CaptureDR
       TMS <= '0'; wait for clk_period;  -- CaptureDR to ShiftDR
       TMS <= '1'; wait for clk_period;  -- ShiftDR to Exit1_DR

       -- Wait some extra time before ending the simulation
       wait for 3 * clk_period;
       wait;     -- Stop the simulation here
   end process;

end sim;