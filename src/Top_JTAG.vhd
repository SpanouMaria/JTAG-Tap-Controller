library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity of Top_JTAG
entity Top_JTAG is
	Port (
       -- JTAG Signals
       TDI       : in  STD_LOGIC;  -- Test Data In (serial input)
       TDO       : out STD_LOGIC;  -- Test Data Out (serial output)
       TCK       : in  STD_LOGIC;  -- Test Clock
       TMS       : in  STD_LOGIC;  -- Test Mode Select
       TRST      : in  STD_LOGIC   -- Test Reset (active high)
   );
end Top_JTAG;

architecture Structural of Top_JTAG is

   -- Internal signals between Boundary Scan Cells (BSCs) and the Core Under Test (CUT)
   signal a_int, b_int, c_int, d_int : STD_LOGIC;
   signal i_int, j_int               : STD_LOGIC;

   -- Signals for the serial shift chain between BSCs
   signal bsc1_out, bsc2_out, bsc3_out, bsc4_out, bsc5_out, bsc6_out : STD_LOGIC;

   -- Control signals from the TAP Controller
   signal ShiftDR, UpdateDR, ClockDR, ShiftIR, UpdateIR, ClockIR : STD_LOGIC;                     -- DR and IR path controls
   signal mode                                                   : STD_LOGIC;                     -- Test mode selector
   signal tap_state                                              : STD_LOGIC_VECTOR(3 downto 0);  -- TAP FSM state

   -- Signals for the Instruction Register and Decoder
   signal IRout : STD_LOGIC_VECTOR(1 downto 0);  -- Output of instruction register
   signal enable_BSR, enable_BR : STD_LOGIC;     -- Enables Boundary Scan Register path and Enables Bypass Register path

   -- Output of the Bypass Register
   signal br_out : STD_LOGIC;

   -- MUX and Flip-Flop logic for final TDO output
   signal tdo_mux_out : STD_LOGIC;  -- Output of first MUX between BSR and BR
   signal ir_tdo      : STD_LOGIC;  -- Output from Instruction Register (serial)
   signal mux2_sel    : STD_LOGIC;  -- Selector for 2nd MUX
   signal mux2_out    : STD_LOGIC;  -- Output of second MUX
   signal tdo_ff_out  : STD_LOGIC;  -- Output of TDO flip-flop
   signal tdo_final   : STD_LOGIC;  -- Final registered TDO

begin

   -- Instantiate the TAP Controller (named TAP_Controller2)
   TAP: entity work.TAP_Controller2 port map(
       TCK => TCK,
       TMS => TMS,
       TRST => TRST,
       ShiftDR => ShiftDR,
       UpdateDR => UpdateDR,
       ClockDR => ClockDR,
       ShiftIR => ShiftIR,
       UpdateIR => UpdateIR,
       ClockIR => ClockIR,
       state => tap_state
   );

   -- Instruction Register
   IRREG: entity work.IR_Register port map(
       TDI         => TDI,
       ClockIR     => ClockIR,
       ShiftIR     => ShiftIR,
       UpdateIR    => UpdateIR,
       Instruction => IRout,
       TDO         => ir_tdo  
   );

   -- Instruction Decoder
   DEC: entity work.Instruction_Decoder port map(
       IR         => IRout,
       enable_BSR => enable_BSR,
       enable_BR  => enable_BR,
       mode       => mode
   );

   -- Bypass Register
   BR: entity work.BR port map(
       TDI       => TDI,
       CaptureDR => ShiftDR,
       ClockDR   => ClockDR,
       TDO_BR    => br_out
   );

   -- INPUT BSCs
   BSC_A: entity work.BSC port map(input_pin => a_int, shiftIn => TDI, clkDr => ClockDR,
                                   shiftDr => ShiftDR, updDr => UpdateDR, mode => mode,
                                   shiftOut => bsc1_out, output_pin => a_int);
   BSC_B: entity work.BSC port map(input_pin => b_int, shiftIn => bsc1_out, clkDr => ClockDR,
                                   shiftDr => ShiftDR, updDr => UpdateDR, mode => mode,
                                   shiftOut => bsc2_out, output_pin => b_int);
   BSC_C: entity work.BSC port map(input_pin => c_int, shiftIn => bsc2_out, clkDr => ClockDR,
                                   shiftDr => ShiftDR, updDr => UpdateDR, mode => mode,
                                   shiftOut => bsc3_out, output_pin => c_int);
   BSC_D: entity work.BSC port map(input_pin => d_int, shiftIn => bsc3_out, clkDr => ClockDR,
                                   shiftDr => ShiftDR, updDr => UpdateDR, mode => mode,
                                   shiftOut => bsc4_out, output_pin => d_int);

   -- CUT
   UUT: entity work.CUT port map(
       a => a_int, b => b_int, c => c_int, d => d_int,
       i => i_int, j => j_int
   );

   -- OUTPUT BSCs
   BSC_I: entity work.BSC port map(input_pin => i_int, shiftIn => bsc4_out, clkDr => ClockDR,
                                   shiftDr => ShiftDR, updDr => UpdateDR, mode => mode,
                                   shiftOut => bsc5_out, output_pin => open);
   BSC_J: entity work.BSC port map(input_pin => j_int, shiftIn => bsc5_out, clkDr => ClockDR,
                                    shiftDr => ShiftDR, updDr => UpdateDR, mode => mode,
                                    shiftOut => bsc6_out, output_pin => open);

   -- MUX-1: Selects output between BSR (Boundary Scan Register) and BR (Bypass Register)
   tdo_mux_out <= bsc6_out when enable_BSR = '1' else
                  br_out    when enable_BR  = '1' else
                  '0';
   -- MUX-2: Selects between IR (Instruction Register) output and MUX-1 output
   mux2_sel <= ShiftIR;
   mux2_out <= ir_tdo when mux2_sel = '1' else
               tdo_mux_out;
   -- Flip-Flop for final TDO (according to the block diagram)
   process(TCK)
   begin
       if rising_edge(TCK) then
           tdo_ff_out <= mux2_out;
       end if;
   end process;

   tdo_final <= tdo_ff_out;
   -- Final TDO output
   TDO <= tdo_final;
end Structural;