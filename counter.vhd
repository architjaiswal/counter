-- Archit Jaiswal
-- Entity: Counter (for signal_buffer)

-- Functionality: It raises output flag AS SOON AS the count has reached the MAX_COUNT_NUMBER



----------------------- COUNTER ENTITY ------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity counter is
    generic (MAX_COUNT_NUMBER: integer := 127); -- it will count from 0 to 127, so total 128 times
    port (
        clk : in std_logic;
        rst : in std_logic;
        add_one : in std_logic;
        subtract_one : in std_logic;
        output : out std_logic -- single bit output (will be 1 when the count reaches MAX_COUNT_NUMBER)
    );
end counter;

architecture non_registered_output of counter is

    constant NUM_BITS : positive := integer(ceil(log2(real(MAX_COUNT_NUMBER+1))));
    signal count_r : unsigned(NUM_BITS-1 downto 0);

begin

    process(clk, rst)
        variable count_v : unsigned(count_r'range);
    begin

        if (rst = '1') then
            count_r <= (others => '0');
            -- output  <= '0';
        
        elsif (rising_edge(clk)) then

            count_v := count_r;

            if (add_one = '1') then
                if (count_v <= MAX_COUNT_NUMBER) then -- if the count value is MAX then it will not go inside this which is a problem
                    count_v := count_v + 1;
                end if;
            end if;

            if (subtract_one = '1') then
                if (count_v /= 0) then
                    count_v := count_v - 1;
                end if;
            end if;

            count_r <= count_v;
        end if;

    end process;

    output <= '1' when count_r >= MAX_COUNT_NUMBER else '0';

end non_registered_output;

-------------------------------------------------------------------------------------------------------------

------------------------------- OPTION 2 --------------------------------------------------------------------

-- architecture potential_solution of counter is

--     constant NUM_BITS : positive := integer(ceil(log2(real(MAX_COUNT_NUMBER+1))));
--     signal count_r : unsigned(NUM_BITS-1 downto 0);

-- begin

--     process(clk, rst)
--         variable count_v : unsigned(count_r'range);
--     begin

--         if (rst = '1') then
--             count_r <= (others => '0');
--             count_v := (others => '0');
        
--         elsif (rising_edge(clk)) then

--             count_v := count_r;

--             if (add_one = '1') then

--                 count_v := count_r + 1;

--                 if (count_v > MAX_COUNT_NUMBER) then
--                     count_v := to_unsigned(MAX_COUNT_NUMBER, count_v'length);
--                 end if;
--             end if;

--             if (subtract_one = '1') then
--                 if (count_r /= 0) then
--                     count_v := count_v - 1;
--                 end if;
--             end if;

--             count_r <= count_v;
--         end if;

--     end process;

--     output <= '1' when count_r = MAX_COUNT_NUMBER else '0';

-- end potential_solution;

-------------------------------------------------------------------------------------------------------------




-- Registering the output is delaying everything by one clock cycle (NOT USEFUL)
-- architecture registered_output of counter is

--     constant NUM_BITS : positive := integer(ceil(log2(real(MAX_COUNT_NUMBER+1))));
--     signal count_r : unsigned(NUM_BITS-1 downto 0);

-- begin

--     process(clk, rst)
--     begin

--         if (rst = '1') then
--             count_r <= (others => '0');
--             output <= '0';
        
--         elsif (rising_edge(clk)) then
--             output <= '0';

--             if (count_r = MAX_COUNT_NUMBER) then
--                 output <= '1';
--             end if;

--             if (add_one = '1') then
--                 if (count_r /= MAX_COUNT_NUMBER) then
--                     count_r <= count_r + 1;
--                 end if;
--             end if;

--             if (subtract_one = '1') then
--                 if (count_r /= 0) then
--                     count_r <= count_r - 1;
--                 end if;
--             end if;
--         end if;

--     end process;

-- end registered_output;