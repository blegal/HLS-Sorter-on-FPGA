library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity sorter_uart is
    Port ( 
           CLK          : in  STD_LOGIC;
           RESETN       : in  STD_LOGIC;
           SW           : in  STD_LOGIC_VECTOR ( 1 downto 0);
           LED 		    : out STD_LOGIC_VECTOR (15 downto 0);
           UART_TXD_IN  : in  STD_LOGIC;
           UART_RXD_OUT : out STD_LOGIC
	);
end sorter_uart;

architecture Behavioral of sorter_uart is
	SIGNAL   dat  : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');

	SIGNAL   data_from_uart    : STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL   data_from_uart_en : STD_LOGIC;

	SIGNAL   data_to_uart      : STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL   data_to_uart_en   : STD_LOGIC;

	SIGNAL   input_data        : UNSIGNED (15 downto 0) := (others=>'0');
	SIGNAL   output_data       : UNSIGNED (15 downto 0) := (others=>'0');

	SIGNAL   read_uart_data    : STD_LOGIC;
	SIGNAL   uart_is_sending   : STD_LOGIC;

	SIGNAL   RESET : STD_LOGIC;

    attribute mark_debug : string;
    attribute keep       : string;

    attribute mark_debug of data_from_uart    : signal is "true";
    attribute mark_debug of data_from_uart_en : signal is "true";
    attribute mark_debug of data_to_uart      : signal is "true";
    attribute mark_debug of data_to_uart_en   : signal is "true";
    attribute mark_debug of input_data        : signal is "true";
    attribute mark_debug of output_data       : signal is "true";

BEGIN

    PROCESS(clk)
    BEGIN
        IF clk'event AND clk = '1' THEN
            RESET <= NOT RESETN;
        END IF;
    END PROCESS;


	----------------------------------------------------------
	------                LED Control                  -------
	----------------------------------------------------------


    PROCESS(clk)
    BEGIN
        IF clk'event AND clk = '1' THEN
            IF RESET = '1' THEN
                input_data <= (others=>'0');
            ELSIF data_from_uart_en = '1' THEN
                input_data <= input_data + TO_UNSIGNED(1, 1);
            END IF;
        END IF;
    END PROCESS;


	----------------------------------------------------------
	------                LED Control                  -------
	----------------------------------------------------------


    PROCESS(clk)
    BEGIN
        IF clk'event AND clk = '1' THEN
            IF RESET = '1' THEN
                output_data <= (others=>'0');
            ELSIF data_to_uart_en = '1' THEN
                output_data <= output_data + TO_UNSIGNED(1, 1);
            END IF;
        END IF;
    END PROCESS;


	----------------------------------------------------------
	------                LED Control                  -------
	----------------------------------------------------------


    rcv : ENTITY work.UART_recv
    PORT MAP(
        RESET  => RESET,
          clk  => clk,
           rx  => UART_TXD_IN,
          dat  => data_from_uart,
       dat_en  => data_from_uart_en
    );


	----------------------------------------------------------
	------                LED Control                  -------
	----------------------------------------------------------


    SORTER : ENTITY work.stream_sorter_0
    PORT MAP(
        ap_clk            => clk,
        ap_rst_n          => RESETN,

        strm_in_V_TDATA   => data_from_uart,
        strm_in_V_TREADY  => open,
        strm_in_V_TVALID  => data_from_uart_en,

        strm_out_V_TDATA  => data_to_uart,
        strm_out_V_TREADY => '1',
        strm_out_V_TVALID => data_to_uart_en
    );


	----------------------------------------------------------
	------                LED Control                  -------
	----------------------------------------------------------


    LED <=  
            STD_LOGIC_VECTOR( input_data  ) WHEN SW    = "01" ELSE 
            STD_LOGIC_VECTOR( output_data ) WHEN SW    = "10" ELSE
            "00000000" & dat                WHEN RESET =  '0' ELSE
            (OTHERS => '1');


	----------------------------------------------------------
	------                LED Control                  -------
	----------------------------------------------------------


	snd : ENTITY work.UART_fifoed_send
	PORT MAP(
		RESET   => RESET,
   clk_100MHz   => CLK,
     fifo_empty => uart_is_sending,
     fifo_afull => OPEN,
     fifo_full  => OPEN,
         tx     => UART_RXD_OUT,
        dat     => data_to_uart,
     dat_en     => data_to_uart_en);

end Behavioral;