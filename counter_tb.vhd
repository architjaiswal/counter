-- Archit Jaiswal
-- Testbench for counter that counts upto the max specified value

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.math_real.ceil;

entity counter_tb is
end counter_tb;

architecture TB of counter_tb is 

    constant TOTAL_SIMULATION_TIME  : time := 1 ms;
    constant CLOCK_TIME : time := 10 ns;
    constant WR_EN_TOGGLE_TIME : time := 20 ns;

    constant MAX_VALUE : integer := 5;
    constant NUM_BITS  : integer := positive(ceil(log2(real(MAX_VALUE+1))));

    signal clk    : std_logic := '0';
    signal rst    : std_logic := '0';
    signal wr_en    : std_logic := '1'; -- should count up whenever wr_en = '1'
    signal rd_en    : std_logic := '0'; -- should count down whenever rd_en = '1'
    -- signal output : std_logic_vector(NUM_BITS-1 downto 0);
    signal output : std_logic;

    signal done   : std_logic := '0';
    signal clk_en : std_logic := '1';

begin 

    U_CNT: entity work.counter
        generic map (MAX_COUNT_NUMBER => MAX_VALUE)
        port map (
            clk    => clk,
            rst    => rst,
            add_one => wr_en,
            subtract_one => rd_en,
            output => output);

    clk <= not clk and clk_en after CLOCK_TIME;

    --------------------------------- TEST 1 ---------------------------------------------------------
    -- Toggle the wr_en signal to stop counting for 2 cycles and the counter value should not increment
    -- wr_en <= not wr_en and clk_en after WR_EN_TOGGLE_TIME;

    -- process
    -- begin

    --     rst <= '1';
    --     -- wait until rising_edge(clk);
    --     for i in 0 to 3 loop
    --         wait until rising_edge(clk);
    --     end loop;

    --     rst <= '0';
    --     for i in 0 to 300 loop
    --         if (i/=130) then
    --             wr_en <= '1';
    --             rd_en <= '0';
    --             -- wr_en <= '0';
    --             wait until rising_edge(clk);
    --             -- wr_en <= '0';
    --             -- wait until rising_edge(clk);
    --             -- wait until rising_edge(clk);
    --         end if;
    --         if (i = 130) then
    --             rd_en <= '1';
    --             wr_en <= '0';
    --             wait until rising_edge(clk);
    --             -- wait until rising_edge(clk);
    --         end if;
    --     end loop;

    --     clk_en <= '0';

    -- end process;

    -- clk_en <= not clk_en after TOTAL_SIMULATION_TIME;
------------------------------------------------------------------------------------------------------

    process
    begin

        rst <= '1';
        -- wait until rising_edge(clk);
        for i in 0 to 3 loop
            wait until rising_edge(clk);
        end loop;

        rst <= '0';
        for i in 0 to 20 loop
            if (i/=5) then
                wr_en <= '1';
                rd_en <= '0';
                -- wr_en <= '0';
                wait until rising_edge(clk);
                -- wr_en <= '0';
                -- wait until rising_edge(clk);
                -- wait until rising_edge(clk);
            end if;
            if (i = 5) then
                rd_en <= '1';
                -- wr_en <= '0';
                wait until rising_edge(clk);
                -- wait until rising_edge(clk);
            end if;
        end loop;

        clk_en <= '0';

    end process;

end TB;