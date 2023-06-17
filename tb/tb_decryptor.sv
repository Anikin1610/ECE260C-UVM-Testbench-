`timescale 1ns / 1ps

module tb_decryptor;

import uvm_pkg::*;
`include "uvm_macros.svh"
//`include "decryptor_bfm.sv"
  
  decryptor_bfm bfm();
  
  top_level_4_260 DUT (.init(bfm.init), 
                       .wr_en(bfm.wr_en), 
                       .raddr(bfm.raddr), 
                	   .clk(bfm.clk), 
                       .waddr(bfm.waddr), 
                       .data_in(bfm.data_in), 
                       .done(bfm.done), 
                       .data_out(bfm.data_out));
  
  string        str2;
  int           str_len;
  logic [7 : 0] str_clr_txt[64], enc_txt[64];
  
  initial begin
    $dumpvars(0);
    $dumpfile("dump.vcd");
  end
  
  initial begin 
  	str2 = "Mr_Watson_come_here_I_want_to_see_you";   
    str_len = str2.len;
    
    for(int i = 0; i < str_len; i++)
      str_clr_txt[i] = byte'(str2[i]);
    
    for(int i = 0; i < str_len; i++)
      $display("%s", string'(str_clr_txt[i]));
    
    bfm.do_encryption(str_clr_txt, str_len, 2, 10, 6'h01, enc_txt);
    bfm.write_ip(enc_txt);
    //bfm.do_decryption();
    bfm.read_op();
    #100;
    $finish;
  end

endmodule
