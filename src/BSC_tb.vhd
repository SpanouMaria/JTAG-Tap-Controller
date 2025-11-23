library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity of BSC_tb
entity BSC_tb is
end BSC_tb;

architecture sim of BSC_tb is

	-- Signals to connect to the DUT (Device Under Test)
   signal input_pin  : std_logic := '0';  -- Simulated input pin
   signal shiftIn    : std_logic := '0';  -- Simulated serial input
   signal clkDr      : std_logic := '0';  -- Clock for capture/shift flip-flop
   signal shiftDr    : std_logic := '0';  -- Selects between shiftIn or input_pin
   signal updDr      : std_logic := '0';  -- Clock for update flip-flop
   signal mode       : std_logic := '0';  -- Mode select (normal/test)
   signal shiftOut   : std_logic;         -- Output of capture flip-flop
   signal output_pin : std_logic;         -- Final output pin (depends on mode)

   -- Clock period definition
   constant clk_period : time := 10 ns;

begin

   -- Instantiate the Device Under Test (DUT)
   DUT: entity work.BSC
       port map (
           input_pin  => input_pin,
           shiftIn    => shiftIn,
           clkDr      => clkDr,
           shiftDr    => shiftDr,
           updDr      => updDr,
           mode       => mode,
           shiftOut   => shiftOut,
           output_pin => output_pin
       );

   -- Clock generator for clkDr (fast clock)
   clk_process : process
   begin
       while true loop
           clkDr <= '0';
           wait for clk_period / 2;
           clkDr <= '1';
           wait for clk_period / 2;
       end loop;
   end process;

   -- Clock generator for updDr (slower, to observe separation)
   upd_process : process
   begin
       while true loop
           updDr <= '0';
           wait for 2 * clk_period;
           updDr <= '1';
           wait for 2 * clk_period;
       end loop;
   end process;

   -- Main stimulus process
   stim_proc: process
   begin
       -- 1. Capture input_pin in normal mode
       input_pin <= '1';     -- Apply value to input pin
       shiftDr <= '0';       -- Select input_pin as input to CAP FF
       wait for clk_period;  -- Wait one clkDr cycle to capture into Q1

       -- 2. Update Q1 value into Q2
       wait for 2 * clk_period;  -- Allow updDr to latch value into Q2

       -- 3. Capture from shiftIn using shift mode
       input_pin <= '0';     -- Change input pin to 0
       shiftIn <= '1';       -- Apply serial input
       shiftDr <= '1';       -- Select shiftIn as input to CAP FF
       wait for clk_period;  -- Wait for capture into Q1

       -- 4. Update Q1 into Q2 again
       wait for 2 * clk_period;

       -- 5. Check output_pin in normal mode
       mode <= '0';          -- Normal mode: output_pin = input_pin
       wait for clk_period;

       -- 6. Check output_pin in test mode
       mode <= '1';          -- Test mode: output_pin = Q2
       wait for clk_period;

       wait; -- End simulation
   end process;

end sim;