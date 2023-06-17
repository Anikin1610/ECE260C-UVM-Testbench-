interface decryptor_bfm;
  logic clk, init;
  
  // MEMORY SIGNALS
  logic wr_en;
  logic [7:0] raddr,
              waddr,
              data_in,
  			  data_out;

  logic done;

  static int decryption_pending;
  static int read_done;
  
  // Config data
  int           ptrn_sel;
  int 			pre_length;
  int           str_len; 
  logic [5 : 0] LFSR_init;

  logic single_ip_mem_test;

  logic [7 : 0] addr, data;
  
  // Testbench data
  logic [7 : 0] msg_input[64],
                msg_padded2[64],  // original message, plus pre- and post-padding
              	msg_crypto2[64],  // encrypted message according to the DUT
              	msg_decryp2[64];  // recovered decrypted message from DUT
  logic [7 : 0] msg_expected[64]; // Expected result for the scoreboard
  
  logic [5 : 0] lfsr2[64];        // states of program 2 decrypting LFSR         
  
  //string     	str_input[64], str_enc[64], str_expected[64];
    
  typedef enum logic [5 : 0] {
  	ptrn0 = 6'h21,
    ptrn1 = 6'h2D,
    ptrn2 = 6'h30,
    ptrn3 = 6'h33,
    ptrn4 = 6'h36,
    ptrn5 = 6'h39
  } e_lfsr_polynm;
  
  e_lfsr_polynm lfsr_ptrn;
  
  initial begin
      clk = 'b0;
      wr_en = 'b0; 
      init = 'b1;
      data_in = 'd0;
      waddr = 'd0;
      raddr = 'd0;
      read_done = 'd0;
      decryption_pending = 'd1;
      fork
         forever begin
            #10; clk = ~clk;
         end
      join_none
   end
    
  task set_cfg(input int ip_str_len, input int ip_polyn_sel, input int ip_pre_length, input logic [5 : 0] ip_seed, input logic [7 : 0] ip_addr, input logic [7 : 0] ip_data, input logic ip_single_ip_mem_test);
    str_len = ip_str_len;
    ptrn_sel = ip_polyn_sel;
    pre_length = ip_pre_length;
    LFSR_init = ip_seed;
    addr = ip_addr;
    data = ip_data;
    single_ip_mem_test = ip_single_ip_mem_test;
  endtask
  
  task do_encryption(input logic [7 : 0] ip_str_byte[64], output logic [7 : 0] op_str_enc[64]);
    
  	//str_input = ip_str;
    //str_len = ip_str_len;
    automatic string s = "";
    
    case (ptrn_sel)
      0: lfsr_ptrn = ptrn0;
      1: lfsr_ptrn = ptrn1;
      2: lfsr_ptrn = ptrn2;
      3: lfsr_ptrn = ptrn3;
      4: lfsr_ptrn = ptrn4;
      5: lfsr_ptrn = ptrn5;
      default: lfsr_ptrn = ptrn0;
    endcase
    
    //lfsr_ptrn = e_lfsr_polynm[ip_polynm_sel];
    //pre_length = ip_pre_length;
    //LFSR_init = ip_seed;
    
    //$display("LFSR_PATTERN = %h", lfsr_ptrn);
    //for(int i = 0; i < ip_str_len; i++)
      //$display("%s", string'(ip_str_byte[i]));
	
    for(int j = 0; j < 64; j++) begin
      //str_input[j] = string'(ip_str_byte[j]);
      msg_input[j] = ip_str_byte[j];
    end
    
    lfsr2[0] = LFSR_init;
    
    for(int j = 0; j < 64; j++) 			   // pre-fill message_padded with ASCII _ characters
      msg_padded2[j] = 8'h5f;         
    
    for(int l = 0; l < str_len; l++)  		   // overwrite up to 60 of these spaces w/ message itself
	  msg_padded2[pre_length+l] = ip_str_byte[l]; 
    
    
    for(int j = 0; j < 64; j++)
      s = {s, string'(msg_padded2[j])};
    $display("PADDED INPUT = %s", s);
    
    /*$display("PADDED MSG:");
    for(int j = 0; j < 64; j++) 
      $display("%s", string'(msg_padded2[j]));
    $display("END PADDED MSG");*/
    
	// compute the LFSR sequence
    for (int ii=0;ii<63;ii++) begin :lfsr_loop
      lfsr2[ii+1] = (lfsr2[ii]<<1)+(^(lfsr2[ii]&lfsr_ptrn));//{LFSR[6:0],(^LFSR[5:3]^LFSR[7])}; 
    end	  :lfsr_loop
	
    // encrypt the message
    for (int i=0; i<64; i++) begin		           // testbench will change on falling clocks
      msg_crypto2[i] = msg_padded2[i] ^ lfsr2[i];  //{1'b0,LFSR[6:0]};	   // encrypt 7 LSBs
      //str_enc[i]     = string'(msg_crypto2[i]);
    end
    
    //str_expected = str_enc;
    op_str_enc = msg_crypto2;
    /*$display("ENCRYPTED MEMORY CONTENTS:");
    for (int i = 0; i < 64; i++)
      $display("%s", str_expected[i]);*/
    
    decryption_pending = 1;
    read_done = 0;
  endtask
  
  task write_ip(input logic [7 : 0] msg_crypto2[64]);
    for(int qp=0; qp<64; qp++) begin
      @(posedge clk);
      wr_en   <= 'b1;                   // turn on memory write enable
      waddr   <= qp+64;                 // write encrypted message to mem [64:127]
      data_in <= msg_crypto2[qp];
    end
    
    @(posedge clk)
    wr_en   <= 'b0;
    read_done = 0;
  endtask
  
  task write_ip_addr(input logic [7 : 0] t_data_in, input logic [7 : 0] t_waddr);
    @(posedge clk);
    wr_en   <= 'b1;                   // turn on memory write enable
    waddr   <= t_waddr;                 // write encrypted message to mem [64:127]
    data_in <= t_data_in;
    msg_input[0] <= t_data_in;
    @(posedge clk)
    wr_en   <= 'b0;
    
    read_done = 0;
  endtask
  
  
  task do_decryption();
    //str_expected = str_input;
    decryption_pending = 0;
    
    /*for (int i = 0; i < 64; i++)
      $display("%s", str_expected[i]);*/
        
    @(posedge clk);
    init <= 0;
    wait(done);
    @(posedge clk);
    init <= 1;
  endtask
  
  task read_op();
    @(posedge clk);
    //for(int n = 0; n < str_len + 1; n++) begin
    for(int n = 0; n < 64 + 1; n++) begin  
      @(posedge clk);
      raddr          <= n + decryption_pending * 64;
      @(posedge clk);
      msg_decryp2[n] <= data_out;
    end
     
    /*$display("MEMORY READ:");
    for (int i = 0; i < 64; i++)
      $display("%s", string'(msg_decryp2[i]));
    $display("%h", msg_decryp2[63]);*/
    
    read_done = 1;
  endtask 
  
  task read_op_addr(logic [7 : 0] t_raddr);
    @(posedge clk) #1;
    //for(int n = 0; n < str_len + 1; n++) begin
    raddr <= t_raddr;
    @(posedge clk);
    msg_decryp2[0] <= data_out;
    //$display("BFM OP: data_out = %h", data_out);
    @(posedge clk);
    read_done = 1;
  endtask  
endinterface