`ifndef TVIP_AXI_SAMPLE_WRITE_READ_SEQUENCE_HAYK_SVH
`define TVIP_AXI_SAMPLE_WRITE_READ_SEQUENCE_HAYK_SVH
class tvip_axi_sample_write_read_sequence_hayk extends tvip_axi_master_sequence_base;
  tvip_axi_address  address_mask[int];

  function new(string name = "tvip_axi_sample_write_read_sequence_hayk");
    super.new(name);
    set_automatic_phase_objection(1);
  endfunction

  task body();
  
  //for (int i = 0;i < 20;++i) begin
  //    fork
  //      automatic int ii  = i;
  
  $display("%t: tvip_axi_sample_write_read_sequence_hayk: calling do_write_read_access_by_sequence", $time);
        do_write_read_access_by_sequence(1);
  //    join_none
  //  end
  //  wait fork;
 
 //   for (int i = 0;i < 20;++i) begin
 //     fork
 //       automatic int ii  = i;
 //       do_write_read_access_by_item(ii);
 //     join_none
 //   end
 //   wait fork;
  endtask

  task do_write_read_access_by_sequence(int index);
    tvip_axi_master_write_sequence  write_sequence;
    tvip_axi_master_read_sequence   read_sequence;
	
	$display("%t: do_write_read_access_by_sequence...", $time);
	
	$display("%t: \t WRITING...", $time);
    `tue_do_with(write_sequence, {
      address >= (64'h0001_0000_0000_0000 * (index + 0) - 0);
      address <= (64'h0001_0000_0000_0000 * (index + 1) - 1);
      (address + burst_size * burst_length) <= (64'h0001_0000_0000_0000 * (index + 1) - 1);
    })
	
	$display("%t: \t address=%h, burst_size=%h, burst_length=%h", $time,write_sequence.address, write_sequence.burst_size,write_sequence.burst_length );
	
	$display("%t: \t READING...", $time);
    `tue_do_with(read_sequence, {
      address      == write_sequence.address;
      burst_size   == write_sequence.burst_size;
      burst_length >= write_sequence.burst_length;
    })
	
	$display("%t: \t address=%h, burst_size=%h, burst_length=%h", $time,read_sequence.address, read_sequence.burst_size,read_sequence.burst_length );

	$display("%t: \t COMAPRING ...", $time);
    for (int i = 0;i < write_sequence.burst_length;++i) begin
      if (!compare_data(
        i,
        write_sequence.address, write_sequence.burst_size,
        write_sequence.strobe, write_sequence.data,
        read_sequence.data
      )) begin
        `uvm_error("CMPDATA", "write and read data are mismatched !!")
      end
    end
	
	$display("%t: \t PASS - write&read data is the same ...", $time);
	
  endtask

  task do_write_read_access_by_item(int index);
    tvip_axi_master_item  write_item;
    tvip_axi_master_item  read_item;

    `tue_do_with(write_item, {
      access_type == TVIP_AXI_WRITE_ACCESS;
      address >= (64'h0001_0000_0000_0000 * (index + 0) - 0);
      address <= (64'h0001_0000_0000_0000 * (index + 1) - 1);
      (address + burst_size * burst_length) <= (64'h0001_0000_0000_0000 * (index + 1) - 1);
    })
    write_item.write_data_end_event.wait_on();

    `tue_do_with(read_item, {
      access_type  == TVIP_AXI_READ_ACCESS;
      address      == write_item.address;
      burst_size   == write_item.burst_size;
      burst_length == write_item.burst_length;
      wait_for_end == 1;
    })

    for (int i = 0;i < write_item.burst_length;++i) begin
      if (!compare_data(
        i,
        write_item.address, write_item.burst_size,
        write_item.strobe, write_item.data,
        read_item.data
      )) begin
        `uvm_error("CMPDATA", "write and read data are mismatched !!")
      end
    end
  endtask

  function bit compare_data(
    input int               index,
    input tvip_axi_address  address,
    input int               burst_size,
    ref   tvip_axi_strobe   strobe[],
    ref   tvip_axi_data     write_data[],
    ref   tvip_axi_data     read_data[]
  );
    int byte_width;
    int byte_offset;

    byte_width  = configuration.data_width / 8;
    byte_offset = ((address & get_address_mask(burst_size)) + (burst_size * index)) % byte_width;
	
    for (int i = 0;i < burst_size;++i) begin
      int   byte_index  = byte_offset + i;
      byte  write_byte;
      byte  read_byte;

      if (!strobe[index][byte_index]) begin
        continue;
      end

      write_byte  = write_data[index][8*byte_index+:8];
      read_byte   = read_data[index][8*byte_index+:8];
	  $display("\t\t %t: compare_data: write_byte=%h : read_byte=%h", $time, write_byte, read_byte);
	  
      if (write_byte != read_byte) begin
        return 0;
      end
    end

    return 1;
  endfunction

  function tvip_axi_address get_address_mask(int burst_size);
    if (!address_mask.exists(burst_size)) begin
      tvip_axi_address  mask;
      mask                      = '1;
      mask                      = (mask >> $clog2(burst_size)) << $clog2(burst_size);
      address_mask[burst_size]  = mask;
    end
    return address_mask[burst_size];
  endfunction

  `uvm_object_utils(tvip_axi_sample_write_read_sequence_hayk)
endclass
`endif
