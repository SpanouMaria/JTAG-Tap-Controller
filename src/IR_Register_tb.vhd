-- Testbench για IR_Register με 2-bit shift
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IR_Register_tb is
end IR_Register_tb;

architecture behavior of IR_Register_tb is

    signal TDI         : std_logic := '0';
    signal ClockIR     : std_logic := '0';
    signal ShiftIR     : std_logic := '0';
    signal UpdateIR    : std_logic := '0';
    signal Instruction : std_logic_vector(1 downto 0);
    signal TDO         : std_logic;

begin

    uut: entity work.IR_Register
        port map (
            TDI => TDI,
            ClockIR => ClockIR,
            ShiftIR => ShiftIR,
            UpdateIR => UpdateIR,
            Instruction => Instruction,
            TDO => TDO
        );

    -- Clock generator (TCK for ClockIR)
    process
    begin
        wait for 10 ns;
        ClockIR <= '1';
        wait for 10 ns;
        ClockIR <= '0';
    end process;

    -- Stimulus process
    process
    begin
        wait for 15 ns;
        ShiftIR <= '1';

        -- Shift bit 0 (TDI = '0')
        TDI <= '0';
        wait for 20 ns;

        -- Shift bit 1 (TDI = '1')
        TDI <= '1';
        wait for 20 ns;

        -- Stop shifting
        ShiftIR <= '0';
        TDI <= '0';
        wait for 10 ns;

        -- Trigger update
        UpdateIR <= '1';
        wait for 10 ns;
        UpdateIR <= '0';

        -- Τέλος δοκιμής
        wait;
    end process;

end behavior;