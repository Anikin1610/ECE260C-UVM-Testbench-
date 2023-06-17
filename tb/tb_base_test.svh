virtual class tb_base_test extends uvm_test;
    `uvm_component_utils(tb_base_test)
    
    tb_env_uvm h_env;
    uvm_sequencer #(decryptor_ip_item) h_sequencer;
    
    function new (string name = "tb_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
   virtual function void build_phase(uvm_phase phase);
      h_env = tb_env_uvm::type_id::create("h_env",this);
   endfunction : build_phase
    
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        h_sequencer = h_env.h_sequencer;
    endfunction
    
    /*task run_phase(uvm_phase phase);
    // TEMPORARY TEST
        string test_str = "Mr_Watson_come_here_I_want_to_see_you";
        int str_len = test_str.len;
        int preamble_len = 10;
        int ptrn_sel = 2;
        logic [5 : 0] seed = 6'h01;
        logic [7 : 0] str_clr_txt[64];
        for(int i = 0; i < str_len; i++)
            str_clr_txt[i] = byte'(test_str[i]);
         
    endtask*/
endclass
