library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Definition of the CUT (Circuit Under Test) entity
entity CUT is
	Port ( a, b, c, d : in STD_LOGIC;
			i, j : out STD_LOGIC);
end CUT;

architecture Behavioral of CUT is
	signal e, f, g, h : STD_LOGIC;
begin
	-- Logic Gates
	e <= a XOR b;  -- XOR operation between inputs a and b
	f <= c XOR d;  -- XOR operation between inputs c and d
	g <= a XOR c;  -- XOR operation between inputs a and c
	h <= b XOR d;  -- XOR operation between inputs b and d
	-- Output Logic
	i <= e AND f;  -- 'i' output: Result of AND gate between e and f
	j <= g OR h;   -- 'j' output: Result of OR gate between g and h
  
end Behavioral;
