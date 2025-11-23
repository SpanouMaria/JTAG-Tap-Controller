library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_JTAG_tb is
end Top_JTAG_tb;

architecture sim of Top_JTAG_tb is
   signal TDI   : std_logic := '0';
   signal TDO   : std_logic;
   signal TCK   : std_logic := '0';
   signal TMS   : std_logic := '0';
   signal TRST  : std_logic := '1';

   constant clk_period : time := 10 ns;

begin

   -- DUT
   DUT: entity work.Top_JTAG
      port map (
         TDI  => TDI,
         TDO  => TDO,
         TCK  => TCK,
         TMS  => TMS,
         TRST => TRST
      );

   -- Clock generation
   clk_process : process
   begin
      while true loop
         TCK <= '0';
         wait for clk_period / 2;
         TCK <= '1';
         wait for clk_period / 2;
      end loop;
   end process;
	
   -- Stimulus process
   stim_proc : process
   begin
      -- Reset pulse
      TRST <= '1';
      wait for clk_period;
      TRST <= '0';
      wait for clk_period;

		
		wait for 1ns;
		 TMS <= '1'; wait for clk_period - 1ns; -- Select-DR-Scan
		wait for 1ns;
		 TMS <= '1'; wait for clk_period - 1ns; -- Select-IR-Scan
		wait for 1ns;
		 TMS <= '0'; wait for clk_period - 1ns; -- Capture-IR
		wait for 1ns;
		 TMS <= '0'; TDI <= '0'; wait for clk_period; -- Shift-IR bit 0
		 TDI <= '0'; wait for clk_period; -- Shift-IR bit 1
		wait for 1ns;
		 TMS <= '1'; wait for clk_period - 1ns; -- Exit1-IR
		wait for 1ns;
		 TMS <= '1'; wait for clk_period - 1ns; -- Update-IR
		wait for 1ns;
		 TMS <= '0'; wait for clk_period - 1ns; -- Run-Test/Idle
		 wait for clk_period;
		 
		wait for 1ns;
		 TMS <= '1'; wait for clk_period - 1ns; -- Select-DR-Scan
		wait for 1ns;
		 TMS <= '0'; wait for clk_period - 1ns; -- Capture-DR
		wait for 1ns;
		 TMS <= '0'; TDI <= '0'; wait for clk_period; -- Shift-DR Bit 0
		 TDI <= '0'; wait for clk_period; -- Bit 1
		 wait for 1ns;
		 TMS <= '1'; wait for clk_period - 1ns; -- Exit1-DR
		 wait for 1ns;
		 TMS <= '1'; wait for clk_period - 1ns; -- Update-DR
		 wait for 1ns;
		 TMS <= '0'; wait for clk_period - 1ns; -- Go to Run-Test/Idle
		 wait for clk_period; -- Extra wait
		
		wait for 1ns;
		 TMS <= '1'; wait for clk_period - 1ns; -- Select-DR-Scan
		wait for 1ns;
		 TMS <= '1'; wait for clk_period - 1ns; -- Select-IR-Scan
		wait for 1ns;
		 TMS <= '0'; wait for clk_period - 1ns; -- Capture-IR
		wait for 1ns;
		 TMS <= '0'; TDI <= '1'; wait for clk_period; -- Shift-IR Bit 0
		 TDI <= '1'; wait for clk_period; -- Bit 1
		 wait for 1ns;
		 TMS <= '1'; wait for clk_period - 1ns; -- Exit1-IR
		 wait for 1ns;
		 TMS <= '1'; wait for clk_period - 1ns; -- Update-IR
		 wait for 1ns;
		 TMS <= '0'; wait for clk_period - 1ns; -- Go to Run-Test/Idle
		 wait for clk_period; -- Extra wait
		 
		 wait for 1ns;
		 TMS <= '1'; wait for clk_period - 1ns; -- Select-DR-Scan
		wait for 1ns;
		 TMS <= '0'; wait for clk_period - 1ns; -- Capture-DR
		wait for 1ns;
		 TMS <= '0'; TDI <= '1'; wait for clk_period; -- Shift-DR Bit 0
		 TDI <= '1'; wait for clk_period; -- Bit 1
		 wait for 1ns;
		 TMS <= '1'; wait for clk_period - 1ns; -- Exit1-DR
		 wait for 1ns;
		 TMS <= '1'; wait for clk_period - 1ns; -- Update-DR
		 wait for 1ns;
		 TMS <= '0'; wait for clk_period - 1ns; -- Go to Run-Test/Idle
		 wait for clk_period; -- Extra wait

      wait;
   end process;

end sim;
