----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:21:48 07/30/2020 
-- Design Name: 
-- Module Name:    Lav - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Lav is
    Port ( S : in  STD_LOGIC_VECTOR (4 downto 0); -- rebasa, lleno lv2 lv1 vacio
           Bin : in  STD_LOGIC; -- Boton Inicio
           Clk : in  STD_LOGIC; -- Reloj
			  Reset : in STD_LOGIC; 
			  P : in  STD_LOGIC_VECTOR (2 downto 0); --centr, enjuague, lavado
--			  T : in STD_LOGIC; --Tiempo
           V : out  STD_LOGIC_VECTOR (3 downto 0); --Vs, Vj, Vl, Vv
           Cvm : out  STD_LOGIC_VECTOR (1 downto 0); -- Vel tambor: off(00), mid(01), high(10)
           Cb : out  STD_LOGIC; -- Bomba vaciado
           Tt : out  STD_LOGIC; --Traba tapa
			  L : out  STD_LOGIC_VECTOR (4 downto 0)); --Leds: tapa, lavado, enjuague, centr
end Lav;

architecture Behavioral of Lav is

 --Use descriptive names for the states, like st1_reset, st2_search
   type state_type is (inicio, carga1, lavado, vacio1, carga2, enjuague, vacio2, centrifugado); 
   signal state, next_state : state_type; 
	
	constant t_lavado:integer := 1;			--Para facilitat el testeo se ponen en 1
	constant t_enjuague:integer :=1;
	constant t_centrifugado:integer :=1;
	signal tiempo : integer range 0 to 1023;
  
  --Declare internal signals for all outputs of the state-machine
--   signal <output>_i : std_logic;  -- example output signal
   --other outputs


begin

--Insert the following in the architecture after the begin keyword
    process (clk,reset) 
	 begin
    if(Reset='1') then
      state <= inicio;
    elsif rising_edge(Clk) then
      state <= next_state; 
    end if;
  end process;
	

 
   NEXT_STATE_DECODE: process (state, S, Bin, P)
   begin
      --declare default state for next_state to avoid latches
      next_state <= state;  --default is to stay in current state
      --insert statements to decode next_state
      --below is a simple example
      case (state) is
         when inicio =>
            
				 V <= "0000";
				 Cvm <= "00";
				 Cb <= '0';
				 Tt <= '0';
				 L <= "00000";
				 tiempo <= 0;
				--1
				if (Bin = '0') then
               next_state <= inicio;
				end if;
				
				if (Bin = '1') then
               Tt <= '1';
					L(4) <= '1';
				end if;
				
				--2
				if (P(0) = '0' and P(1) = '0' and P(2) = '0' and Bin = '1') then
					next_state <= inicio;
					Tt <= '0';
					L(0) <= '0';
            end if;
				--3
				if (P(0) = '1' and Bin = '1') then
					next_state <= carga1;
				end if;
				--4
				if (P(0) = '0' and P(1) = '1' and Bin = '1') then
					next_state <= carga2;
				end if;
				--5
				if (P(0) = '0' and P(1) = '0' and P(2)='1' and Bin = '1') then
					next_state <= centrifugado;
				end if;
			
			
			when carga1 =>
            V(3) <= '1';
				V(2) <= '1';
				V(1) <= '1';
				L(2) <= '0';
				--6
				if (S(3)= '0') then
               next_state <= carga1;
            end if;
				--7
				if (S(3) = '1') then
				V(3) <= '0';
				V(2) <= '0';
				V(1) <= '0';
					next_state <= lavado;
				end if;	
				
				
			when lavado =>
				Cb <= '0' ;
				V(0) <= '0' ;
				Cvm <= "01";
				
				if (S(4) = '1') then
					Cvm <= "00";
					V(0) <= '1';
					Cb <= '1' ;
					next_state <= lavado;
				end if;
				
				--8
				if (tiempo = t_lavado) then
					next_state <= vacio1;
				else
					next_state <= lavado;
				end if;
				tiempo <= tiempo+1;
				
				
			when vacio1 =>
				tiempo <= 0;
				Cvm <= "00";
				V(0) <= '1';
				Cb <= '1';
				if (S(0) = '0') then
					Cb <= '0';
					V(0) <= '0';
					L(2) <= '0';
				end if;
				--10
				if (S(0) = '1') then
					next_state <= vacio1 ;
				end if;
				--11
				if (P(1) = '1' and S(0) = '0') then
					next_state <= carga2;
				end if;
				--12
				if (P(1) = '0' and P(2) = '1' and S(0) = '0') then
					next_state <= centrifugado;
				end if;
				--13
				if (P(1) = '0' and P(2) = '0' and S(0) = '0') then
					next_state <= inicio ;
				end if;
			
			when carga2 =>
				V(1) <= '1';
				L(1) <= '1';
				--14
				if (S(3) = '0') then
					next_state <= carga2;
				end if;
				--15
				if (S(3) = '1') then
					V(1) <= '0';
					next_state <= enjuague;
				end if;
			when enjuague =>
				Cb <= '0' ;
				V(0) <= '0' ;
				Cvm <= "01";
				
				if (S(4) = '1') then
					Cvm <= "00";
					V(0) <= '1';
					Cb <= '1' ;
					next_state <= enjuague;
				end if;
				
				if (tiempo = t_enjuague) then
					next_state <= vacio2;
					else
					next_state <= enjuague;
				end if;
				tiempo <= tiempo + 1;
			when vacio2 =>
				tiempo <=0;
				Cvm <= "00";
				V(0) <= '1';
				Cb <= '1';
				if (S(0) = '0') then
					Cb <= '0';
					V(0) <= '0';
					L(1) <= '0';
				end if;
				--18
				if (S(0) = '1') then
					next_state <= vacio2  ;
				end if;
				--19
				if (P(2) = '1' and S(0) = '0') then
					next_state <= centrifugado ;
				end if;
				--20
				if (P(2) = '0' and S(0) = '0') then
					next_state <= inicio ;
				end if;
			
			when centrifugado =>
				L(0) <= '1';
				Cvm <= "10";
				V(0) <= '1';
				Cb <= '1';
				
				--22
				if (tiempo = t_centrifugado) then
					next_state <= inicio;
					else
					next_state <= centrifugado;
				end if;
				tiempo <= tiempo +1;
         when others =>
            next_state <= inicio;
      end case;      
   end process;

end Behavioral;

