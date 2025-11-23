library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity of TAP Controller
entity TAP_Controller is
	Port (
		TCK   : in  std_logic;                    -- Test Clock
      TMS   : in  std_logic;                    -- Test Mode Select
      TRST  : in  std_logic;                    -- Test Reset (asynchronous reset)
      state : out std_logic_vector(3 downto 0)  -- Encoded current state output
	);
end TAP_Controller;

architecture Behavioral of TAP_Controller is

	-- Define the state enumeration for the JTAG TAP FSM
   type state_type is (
       Test_Logic_Reset, Run_Test_Idle,
       Select_DR_Scan, Capture_DR, Shift_DR, Exit1_DR, Pause_DR, Exit2_DR, Update_DR,
       Select_IR_Scan, Capture_IR, Shift_IR, Exit1_IR, Pause_IR, Exit2_IR, Update_IR
   );

   -- Internal signals for current and next state
   signal current_state, next_state : state_type := Test_Logic_Reset;

begin

   -- Map each state to a 4-bit vector for output
   with current_state select
       state <=
           "0000" when Test_Logic_Reset,
           "0001" when Run_Test_Idle,
           "0010" when Select_DR_Scan,
           "0011" when Capture_DR,
           "0100" when Shift_DR,
           "0101" when Exit1_DR,
           "0110" when Pause_DR,
           "0111" when Exit2_DR,
           "1000" when Update_DR,
           "1001" when Select_IR_Scan,
           "1010" when Capture_IR,
           "1011" when Shift_IR,
           "1100" when Exit1_IR,
           "1101" when Pause_IR,
           "1110" when Exit2_IR,
           "1111" when Update_IR;
			  
   -- Synchronous state update process with asynchronous reset (TRST)
   process(TCK, TRST)
   begin
       if TRST = '1' then
			  -- If reset is active, go to Test_Logic_Reset state
           current_state <= Test_Logic_Reset;
       elsif rising_edge(TCK) then
		     -- On TCK rising edge, update state
           current_state <= next_state;
       end if;
   end process;

   -- Combinational process to determine next state based on current state and TMS
   process(current_state, TMS)
   begin
       case current_state is
           when Test_Logic_Reset =>
               if TMS = '0' then next_state <= Run_Test_Idle;
               else next_state <= Test_Logic_Reset; end if;

           when Run_Test_Idle =>
               if TMS = '0' then next_state <= Run_Test_Idle;
               else next_state <= Select_DR_Scan; end if;

           when Select_DR_Scan =>
               if TMS = '0' then next_state <= Capture_DR;
               else next_state <= Select_IR_Scan; end if;

           when Capture_DR =>
               if TMS = '0' then next_state <= Shift_DR;
               else next_state <= Exit1_DR; end if;

           when Shift_DR =>
               if TMS = '0' then next_state <= Shift_DR;
               else next_state <= Exit1_DR; end if;

           when Exit1_DR =>
               if TMS = '0' then next_state <= Pause_DR;
               else next_state <= Update_DR; end if;

           when Pause_DR =>
               if TMS = '0' then next_state <= Pause_DR;
               else next_state <= Exit2_DR; end if;

           when Exit2_DR =>
               if TMS = '0' then next_state <= Shift_DR;
               else next_state <= Update_DR; end if;

           when Update_DR =>
               if TMS = '0' then next_state <= Run_Test_Idle;
               else next_state <= Select_DR_Scan; end if;

           when Select_IR_Scan =>
               if TMS = '0' then next_state <= Capture_IR;
               else next_state <= Test_Logic_Reset; end if;

           when Capture_IR =>
               if TMS = '0' then next_state <= Shift_IR;
               else next_state <= Exit1_IR; end if;

           when Shift_IR =>
               if TMS = '0' then next_state <= Shift_IR;
               else next_state <= Exit1_IR; end if;

           when Exit1_IR =>
               if TMS = '0' then next_state <= Pause_IR;
               else next_state <= Update_IR; end if;

           when Pause_IR =>
               if TMS = '0' then next_state <= Pause_IR;
               else next_state <= Exit2_IR; end if;

           when Exit2_IR =>
               if TMS = '0' then next_state <= Shift_IR;
               else next_state <= Update_IR; end if;

           when Update_IR =>
               if TMS = '0' then next_state <= Run_Test_Idle;
               else next_state <= Select_DR_Scan; end if;

           when others =>
               next_state <= Test_Logic_Reset;
       end case;
   end process;

end Behavioral;
