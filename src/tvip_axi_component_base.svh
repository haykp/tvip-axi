`ifndef TVIP_AXI_COMPONENT_BASE_SVH
`define TVIP_AXI_COMPONENT_BASE_SVH
virtual class tvip_axi_component_base #(
  type  BASE  = uvm_component
) extends BASE;
  protected bit           write_component;
  protected tvip_axi_vif  vif;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    vif = configuration.vif;
  endfunction

// There is a write or read operation. For each operation its component exists. So this return true if write component.
  protected function bit is_write_component();
    return write_component;
  endfunction

// There is a write or read operation. For each operation its component exists. So this return true if read component.
  protected function bit is_read_component();
    return !write_component;
  endfunction

  virtual function void begin_address(tvip_axi_item item);
    void'(begin_tr(item));
    item.begin_address();
  endfunction

  virtual function void end_address(tvip_axi_item item);
    item.end_address();
  endfunction

  virtual function void begin_write_data(tvip_axi_item item);
    if (item.is_write()) begin
      item.begin_write_data();
    end
  endfunction

  virtual function void end_write_data(tvip_axi_item item);
    if (item.is_write()) begin
      item.end_write_data();
    end
  endfunction

  virtual function void begin_response(tvip_axi_item item);
    item.begin_response();
  endfunction

  virtual function void end_response(tvip_axi_item item);
    item.end_response();
    end_tr(item);
  endfunction

// returns awvalid or arvalid value
  protected function bit get_address_valid();
    return (write_component) ? vif.monitor_cb.awvalid : vif.monitor_cb.arvalid;
  endfunction

// returns awready signal or arready signal, depending on component type
  protected function bit get_address_ready();
    return (write_component) ? vif.monitor_cb.awready : vif.monitor_cb.arready;
  endfunction

// returns awack signal
  protected function bit get_address_ack();
    return (write_component) ? vif.monitor_cb.awack : vif.monitor_cb.arack;
  endfunction

// return wvalid signal
  protected function bit get_write_data_valid();
    return (write_component) ? vif.monitor_cb.wvalid : '0;
  endfunction

// returns wready signal for write component
  protected function bit get_write_data_ready();
    return (write_component) ? vif.monitor_cb.wready : '0;
  endfunction

// returns wack value for write component
  protected function bit get_write_data_ack();
    return (write_component) ? vif.monitor_cb.wack : '0;
  endfunction

// returns bvalid or rvalid
  protected function bit get_response_valid();
    return (write_component) ? vif.monitor_cb.bvalid : vif.monitor_cb.rvalid;
  endfunction

// returns bready or rready signals
  protected function bit get_response_ready();
    return (write_component) ? vif.monitor_cb.bready : vif.monitor_cb.rready;
  endfunction

  // returns back or rack signals from vif
  protected function bit get_response_ack();
    return (write_component) ? vif.monitor_cb.back : vif.monitor_cb.rack;
  endfunction

// returns awid or arid signals
  protected function tvip_axi_id get_address_id();
    if (configuration.protocol == TVIP_AXI4) begin
      return (write_component) ? vif.monitor_cb.awid : vif.monitor_cb.arid;
    end
    else begin
      return 0;
    end
  endfunction

// returns awaddr or araddr vif signal value, depending on component type - write or read
  protected function tvip_axi_address get_address();
    return (write_component) ? vif.monitor_cb.awaddr : vif.monitor_cb.araddr;
  endfunction

// returns the value of awlen or arlen, depending on component type - write or read
  protected function int get_burst_length();
    if (configuration.protocol == TVIP_AXI4) begin
      tvip_axi_burst_length burst_length;
      burst_length  = (write_component) ? vif.monitor_cb.awlen : vif.monitor_cb.arlen;
      return unpack_burst_length(burst_length);
    end
    else begin
      return 1;
    end
  endfunction
  
// returns the value of awsize or arsize, depending on component type - write or read
  protected function int get_burst_size();
    if (configuration.protocol == TVIP_AXI4) begin
      tvip_axi_burst_size burst_size;
      burst_size  = (write_component) ? vif.monitor_cb.awsize : vif.monitor_cb.arsize;
      return unpack_burst_size(burst_size);
    end
    else begin
      return configuration.data_width / 8;
    end
  endfunction

// returns the value of awburst or arburst, depending on component type - write or read
  protected function tvip_axi_burst_type get_burst_type();
    if (configuration.protocol == TVIP_AXI4) begin
      return (write_component) ? vif.monitor_cb.awburst : vif.monitor_cb.arburst;
    end
    else begin
      return TVIP_AXI_FIXED_BURST;
    end
  endfunction

// returns the value of awqos or arqos, depending on component type - write or read
  protected function tvip_axi_qos get_qos();
    return (write_component) ? vif.monitor_cb.awqos : vif.monitor_cb.arqos;
  endfunction

// returns the value of wdata for write component or 0
  protected function tvip_axi_data get_write_data();
    return (write_component) ? vif.monitor_cb.wdata : '0;
  endfunction

// returns the value of wdata for wstrb component or 0
  protected function tvip_axi_strobe get_strobe();
    return (write_component) ? vif.monitor_cb.wstrb : '0;
  endfunction
  
// returns the value of wdata for write component or 0
  protected function bit get_write_data_last();
    if (configuration.protocol == TVIP_AXI4) begin
      return (write_component) ? vif.monitor_cb.wlast : '0;
    end
    else begin
      return (write_component) ? 1 : '0;
    end
  endfunction
  
// returns the value of bid or rid, depending on component type - write or read
  protected function tvip_axi_id get_response_id();
    if (configuration.protocol == TVIP_AXI4) begin
      return (write_component) ? vif.monitor_cb.bid : vif.monitor_cb.rid;
    end
    else begin
      return 0;
    end
  endfunction

  
// returns the value of bresp or rresp, depending on component type - write or read
  protected function tvip_axi_response get_response();
    return (write_component) ? vif.monitor_cb.bresp : vif.monitor_cb.rresp;
  endfunction

// returns the value of rdata for read component or 0
  protected function tvip_axi_data get_read_data();
    return (write_component) ? '0 : vif.monitor_cb.rdata;
  endfunction

// returns the value of rlast for read component or 0
  protected function bit get_response_last();
    if (configuration.protocol == TVIP_AXI4) begin
      return (write_component) ? '1 : vif.monitor_cb.rlast;
    end
    else begin
      return '1;
    end
  endfunction

  `tue_component_default_constructor(tvip_axi_component_base)
endclass
`endif
