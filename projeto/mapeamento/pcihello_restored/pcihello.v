
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module pcihello(

	//////////// CLOCK //////////
	CLOCK_50, 	// BANK 4
	CLOCK2_50, 	// BANK 7
	CLOCK3_50, 	// BANK 3A

	//////////// LED (High Active) //////////
	LEDG,
	LEDR,

	//////////// KEY (Active Low) //////////
	KEY,

	// switches
   SW,
	
	//////////// SEG7 (Low Active) //////////
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7,

	//////////// PCIe //////////
	PCIE_PERST_N,
	PCIE_REFCLK_P,
	PCIE_RX_P,
	PCIE_TX_P,
	PCIE_WAKE_N,

	//////////// Fan Control //////////
	FAN_CTRL 
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input 		          		CLOCK_50;
input 		          		CLOCK2_50;
input 		          		CLOCK3_50;

//////////// LED (High Active) //////////
output		     [8:0]		LEDG;
output		    [17:0]		LEDR;

//////////// KEY (Active Low) //////////
input 		     [3:0]		KEY;
input            [17:0]	   SW;

//////////// SEG7 (Low Active) //////////
output		     [6:0]		HEX0;
output		     [6:0]		HEX1;
output		     [6:0]		HEX2;
output		     [6:0]		HEX3;
output		     [6:0]		HEX4;
output		     [6:0]		HEX5;
output		     [6:0]		HEX6;
output		     [6:0]		HEX7;

//////////// PCIe //////////
input 		          		PCIE_PERST_N;
input 		          		PCIE_REFCLK_P;
input 		     [1:0]		PCIE_RX_P;
output		     [1:0]		PCIE_TX_P;
output		          		PCIE_WAKE_N;

//////////// Fan Control //////////
inout 		          		FAN_CTRL;


//=======================================================
//  REG/WIRE declarations
//=======================================================

wire fan;
wire [15:0] inbus;
wire [31:0] hexbus;
wire [31:0] hexbus2;
wire [31:0] buttons;
wire [31:0] ledsr;
wire [31:0] ledsg;


//=======================================================
//  Structural coding
//=======================================================

    pcihellocore u0 (
        .pcie_hard_ip_0_rx_in_rx_datain_0       (PCIE_RX_P[0]),       //     pcie_hard_ip_0_rx_in.rx_datain_0
        .pcie_hard_ip_0_tx_out_tx_dataout_0     (PCIE_TX_P[0]),     //    pcie_hard_ip_0_tx_out.tx_dataout_0
        .pcie_hard_ip_0_powerdown_pll_powerdown (PCIE_WAKE_N), // pcie_hard_ip_0_powerdown.pll_powerdown
        .pcie_hard_ip_0_powerdown_gxb_powerdown (PCIE_WAKE_N), //                         .gxb_powerdown
        .pcie_hard_ip_0_refclk_export           (PCIE_REFCLK_P),           //    pcie_hard_ip_0_refclk.export
        .pcie_hard_ip_0_pcie_rstn_export        (PCIE_PERST_N),
        .hexport_external_connection_export     (hexbus),      // hexport_external_connection.export
		  .hexport2_external_connection_export    (hexbus2),     // hexport2_external_connection.export
		  .button_external_connection_export      (buttons),     // button_external_connection.export
		  .ledr_external_connection_export        (ledsr),     // ledr_external_connection.export
		  .ledg_external_connection_export        (ledsg),     // ledg_external_connection.export
        .inport_external_connection_export      (inbus)        //  inport_external_connection.export
    );


	//////////// FAN Control //////////
assign FAN_CTRL = 1'b1; // turn off FAN

assign HEX0 = hexbus[6:0];
assign HEX1 = hexbus[14:8];
assign HEX2 = hexbus[22:16];
assign HEX3 = hexbus[30:24];
assign HEX4 = hexbus2[6:0];
assign HEX5 = hexbus2[14:8];
assign HEX6 = hexbus2[22:16];
assign HEX7 = hexbus2[30:24];

assign buttons = KEY[3:0];

assign LEDG = ledsg[8:0];

assign LEDR = ledsr[17:0];

assign inbus = SW[15:0];

endmodule
