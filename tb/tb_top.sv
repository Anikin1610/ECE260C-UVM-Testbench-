module tb_top;
    import uvm_pkg::*;
    import tb_decryptor_pkg::*;
    `include "uvm_macros.svh"
  
    decryptor_bfm bfm();
    
    top_level_4_260 DUT (.init(bfm.init), 
                        .wr_en(bfm.wr_en), 
                        .raddr(bfm.raddr), 
                        .clk(bfm.clk), 
                        .waddr(bfm.waddr), 
                        .data_in(bfm.data_in), 
                        .done(bfm.done), 
                        .data_out(bfm.data_out));
                        
    initial begin
        uvm_config_db #(virtual decryptor_bfm)::set(null, "*", "bfm", bfm);
        run_test();
    end      
  
    /*initial begin
        $dumpfile("dump.vcd");  
        $dumpvars;
    end*/
endmodule
