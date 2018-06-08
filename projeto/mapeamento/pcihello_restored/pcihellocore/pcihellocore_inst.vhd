	component pcihellocore is
		port (
			button_external_connection_export      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			fan_external_connection_in_port        : in  std_logic                     := 'X';             -- in_port
			fan_external_connection_out_port       : out std_logic;                                        -- out_port
			hexport2_external_connection_export    : out std_logic_vector(31 downto 0);                    -- export
			hexport_external_connection_export     : out std_logic_vector(31 downto 0);                    -- export
			inport_external_connection_export      : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			ledg_external_connection_export        : out std_logic_vector(31 downto 0);                    -- export
			ledr_external_connection_export        : out std_logic_vector(31 downto 0);                    -- export
			pcie_hard_ip_0_pcie_rstn_export        : in  std_logic                     := 'X';             -- export
			pcie_hard_ip_0_powerdown_pll_powerdown : in  std_logic                     := 'X';             -- pll_powerdown
			pcie_hard_ip_0_powerdown_gxb_powerdown : in  std_logic                     := 'X';             -- gxb_powerdown
			pcie_hard_ip_0_refclk_export           : in  std_logic                     := 'X';             -- export
			pcie_hard_ip_0_rx_in_rx_datain_0       : in  std_logic                     := 'X';             -- rx_datain_0
			pcie_hard_ip_0_tx_out_tx_dataout_0     : out std_logic                                         -- tx_dataout_0
		);
	end component pcihellocore;

	u0 : component pcihellocore
		port map (
			button_external_connection_export      => CONNECTED_TO_button_external_connection_export,      --   button_external_connection.export
			fan_external_connection_in_port        => CONNECTED_TO_fan_external_connection_in_port,        --      fan_external_connection.in_port
			fan_external_connection_out_port       => CONNECTED_TO_fan_external_connection_out_port,       --                             .out_port
			hexport2_external_connection_export    => CONNECTED_TO_hexport2_external_connection_export,    -- hexport2_external_connection.export
			hexport_external_connection_export     => CONNECTED_TO_hexport_external_connection_export,     --  hexport_external_connection.export
			inport_external_connection_export      => CONNECTED_TO_inport_external_connection_export,      --   inport_external_connection.export
			ledg_external_connection_export        => CONNECTED_TO_ledg_external_connection_export,        --     ledg_external_connection.export
			ledr_external_connection_export        => CONNECTED_TO_ledr_external_connection_export,        --     ledr_external_connection.export
			pcie_hard_ip_0_pcie_rstn_export        => CONNECTED_TO_pcie_hard_ip_0_pcie_rstn_export,        --     pcie_hard_ip_0_pcie_rstn.export
			pcie_hard_ip_0_powerdown_pll_powerdown => CONNECTED_TO_pcie_hard_ip_0_powerdown_pll_powerdown, --     pcie_hard_ip_0_powerdown.pll_powerdown
			pcie_hard_ip_0_powerdown_gxb_powerdown => CONNECTED_TO_pcie_hard_ip_0_powerdown_gxb_powerdown, --                             .gxb_powerdown
			pcie_hard_ip_0_refclk_export           => CONNECTED_TO_pcie_hard_ip_0_refclk_export,           --        pcie_hard_ip_0_refclk.export
			pcie_hard_ip_0_rx_in_rx_datain_0       => CONNECTED_TO_pcie_hard_ip_0_rx_in_rx_datain_0,       --         pcie_hard_ip_0_rx_in.rx_datain_0
			pcie_hard_ip_0_tx_out_tx_dataout_0     => CONNECTED_TO_pcie_hard_ip_0_tx_out_tx_dataout_0      --        pcie_hard_ip_0_tx_out.tx_dataout_0
		);

