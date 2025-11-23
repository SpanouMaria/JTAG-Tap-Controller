library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity for a 3-bit Instruction Register built from three serial IR cells
entity IR_Register is
	Port (
       TDI         : in  STD_LOGIC;                     -- Test Data In (serial input)
       ClockIR     : in  STD_LOGIC;                     -- Clock for shifting and updating
       ShiftIR     : in  STD_LOGIC;                     -- Enables shifting of instruction bits
       UpdateIR    : in  STD_LOGIC;                     -- Enables parallel load of instruction
       Instruction : out STD_LOGIC_VECTOR(1 downto 0);  -- Parallel instruction output
       TDO         : out STD_LOGIC                      -- Test Data Out (serial output)
   );
end IR_Register;

architecture Structural of IR_Register is
  signal tdo0 : STD_LOGIC;
begin
  IR0: entity work.IR port map(
    Data        => '0',
    TDI         => TDI,
    ShiftIR     => ShiftIR,
    ClockIR     => ClockIR,
    UpdateIR    => UpdateIR,
    ParallelOut => Instruction(0),
    TDO         => tdo0
  );

  IR1: entity work.IR port map(
    Data        => '0',
    TDI         => tdo0,
    ShiftIR     => ShiftIR,
    ClockIR     => ClockIR,
    UpdateIR    => UpdateIR,
    ParallelOut => Instruction(1),
    TDO         => TDO
  );
end Structural;
