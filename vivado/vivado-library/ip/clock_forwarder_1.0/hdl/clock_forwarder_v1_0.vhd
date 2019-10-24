library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity clock_forwarder_v1_0 is
	port (
	  aRst : in std_logic;
	  InClk : in std_logic;
	  iCE : in std_logic;
	  OutClk : out std_logic
	);
end clock_forwarder_v1_0;

architecture arch_imp of clock_forwarder_v1_0 is
begin
   
ODDR_inst : ODDR
generic map(
   DDR_CLK_EDGE => "OPPOSITE_EDGE", -- "OPPOSITE_EDGE" or "SAME_EDGE" 
   INIT => '0',   -- Initial value for Q port ('1' or '0')
   SRTYPE => "ASYNC") -- Reset Type ("ASYNC" or "SYNC")
port map (
   Q => OutClk,   -- 1-bit DDR output
   C => InClk,    -- 1-bit clock input
   CE => iCE,  -- 1-bit clock enable input
   D1 => '1',  -- 1-bit data input (positive edge)
   D2 => '0',  -- 1-bit data input (negative edge)
   R => aRst,    -- 1-bit reset input
   S => '0'     -- 1-bit set input
);
end arch_imp;
