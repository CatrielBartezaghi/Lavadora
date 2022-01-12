--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:02:51 07/31/2020
-- Design Name:   
-- Module Name:   C:/Documents and Settings/Lavadora2/EnjuagueYCentrifugado.vhd
-- Project Name:  Lavadora2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Lav
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY EnjuagueYCentrifugado IS
END EnjuagueYCentrifugado;
 
ARCHITECTURE behavior OF EnjuagueYCentrifugado IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Lav
    PORT(
         S : IN  std_logic_vector(4 downto 0);
         Bin : IN  std_logic;
         Clk : IN  std_logic;
         Reset : IN  std_logic;
         P : IN  std_logic_vector(2 downto 0);
         V : OUT  std_logic_vector(3 downto 0);
         Cvm : OUT  std_logic_vector(1 downto 0);
         Cb : OUT  std_logic;
         Tt : OUT  std_logic;
         L : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal S : std_logic_vector(4 downto 0) := (others => '0');
   signal Bin : std_logic := '0';
   signal Clk : std_logic := '0';
   signal Reset : std_logic := '0';
   signal P : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal V : std_logic_vector(3 downto 0);
   signal Cvm : std_logic_vector(1 downto 0);
   signal Cb : std_logic;
   signal Tt : std_logic;
   signal L : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Lav PORT MAP (
          S => S,
          Bin => Bin,
          Clk => Clk,
          Reset => Reset,
          P => P,
          V => V,
          Cvm => Cvm,
          Cb => Cb,
          Tt => Tt,
          L => L
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.

		P <= "110"; --Programa centrifugado y enjuague
		Bin <= '0';
		S <= "00000"; --Ningun sensor activado porque no hay agua
		wait for 10 ns;
		Bin <= '1';
		wait for 10 ns;
		S <= "01111";	--Lleno
		wait for 10 ns;
		Bin <= '0';
		S <= "11111";  --Rebasa
		wait for 10 ns;
		S <= "01111";
		wait for 10 ns;
		S <= "00000";
		wait for 10 ns;
		reset <= '1';
		wait for 10 ns;
      wait;
   end process;

END;
