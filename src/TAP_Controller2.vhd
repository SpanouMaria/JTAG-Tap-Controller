library IEEE;
use IEEE.std_logic_1164.all;

-- TAP_Controller2 entity
entity TAP_Controller2 is
    Port (
        TCK       : in  std_logic;
        TMS       : in  std_logic;
        TRST      : in  std_logic;
        state     : out std_logic_vector(3 downto 0);
        ShiftDR   : out std_logic;
        UpdateDR  : out std_logic;
        ClockDR   : out std_logic;
        ShiftIR   : out std_logic;
        UpdateIR  : out std_logic;
        ClockIR   : out std_logic
    );
end TAP_Controller2;

architecture only of TAP_Controller2 is

	-- TAP FSM states
    type state_type is (
        Test_Logic_Reset, Run_Test_Idle,
       Select_DR_Scan, Capture_DR, Shift_DR, Exit1_DR, Pause_DR, Exit2_DR, Update_DR,
       Select_IR_Scan, Capture_IR, Shift_IR, Exit1_IR, Pause_IR, Exit2_IR, Update_IR
    );

    signal current_state : state_type := Test_Logic_Reset;
    signal next_state    : state_type := Test_Logic_Reset;

	 -- Internal control signals
    signal shiftdr_i, updatedr_i : std_logic := '0';
    signal shiftir_i, updateir_i : std_logic := '0';
    signal clockdr_i, clockir_i  : std_logic := '0';

begin

	-- State transition logic
    process(TCK, TRST)
    begin
        if TRST = '1' then
            current_state <= Test_Logic_Reset;
        elsif rising_edge(TCK) then
            current_state <= next_state;
        end if;
    end process;

	 -- State transition logic
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

            when others => next_state <= Test_Logic_Reset;
        end case;
    end process;

	 -- Generate control signals based on state
    process(current_state)
    begin
        shiftdr_i  <= '0'; updatedr_i <= '0';
        shiftir_i  <= '0'; updateir_i <= '0';
		  
        case current_state is
            when SHIFT_DR   => shiftdr_i  <= '1';
            when UPDATE_DR  => updatedr_i <= '1';
            when SHIFT_IR   => shiftir_i  <= '1';
            when UPDATE_IR  => updateir_i <= '1';
            when others     => null;
        end case;
    end process;

	 -- Clock generation: pass TCK only during SHIFT states
	 ClockIR <= not(TCK) when current_state = SHIFT_IR else '0';
	 ClockDR <= not(TCK) when current_state = SHIFT_DR else '0';
	 
    -- Connect internal signals to outputs
    ShiftDR  <= shiftdr_i;
    UpdateDR <= updatedr_i;
	 
    ShiftIR  <= shiftir_i;
    UpdateIR <= updateir_i;

    -- Output state as std_logic_vector
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

end only;
