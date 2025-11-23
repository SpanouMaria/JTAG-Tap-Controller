library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity for decoding the Instruction Register value into control signals
entity Instruction_Decoder is
	Port (
       IR          : in  STD_LOGIC_VECTOR(1 downto 0);  -- 3-bit instruction input
       enable_BSR  : out STD_LOGIC;                     -- Enables Boundary Scan Register
       enable_BR   : out STD_LOGIC;                     -- Enables Bypass Register
       mode        : out STD_LOGIC                      -- 1 = Test Mode, 0 = Normal Mode
   );
end Instruction_Decoder;

architecture Behavioral of Instruction_Decoder is
begin

	-- Combinational process to decode the IR value
   process(IR)
   begin
	
       -- Set default outputs
       enable_BSR <= '0';
       enable_BR  <= '0';
       mode       <= '0';  -- Default is normal mode

       case IR is
           when "00" =>           -- SAMPLE/PRELOAD instruction
               enable_BSR <= '1';  -- Enable BSR path
               mode       <= '1';  -- Enter test mode

           when "11" =>           -- BYPASS instruction
               enable_BR  <= '1';  -- Enable Bypass Register
               mode       <= '1';  -- Enter test mode

           when others =>
               -- Any other instruction leads to normal mode
               mode <= '0';
       end case;
   end process;

end Behavioral;