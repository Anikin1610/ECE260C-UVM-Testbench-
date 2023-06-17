class def_sequence extends uvm_sequence #(decryptor_ip_item);
    `uvm_object_utils(def_sequence)
    
    function new (string name = "def_sequence");
        super.new(name);
    endfunction
    
    task body();
        logic [7 : 0] str_clr_txt[64];
        string tst_str = "Mr_Watson_come_here_I_want_to_see_you";
        int str_len = tst_str.len;
        int ptrn_sel = 2;
        int preamble_len = 10;
        logic [5: 0] seed = 6'h01;
        decryptor_ip_item command;
        
        command = decryptor_ip_item::type_id::create("command");
        for(int i = 0; i < str_len; i++)
            str_clr_txt[i] = byte'(tst_str[i]);
         
        `uvm_info("SMOKETEST", "SEQUENCE INITIATED", UVM_MEDIUM);
        start_item(command);
        command.ptrn_sel = ptrn_sel;
        command.preamble_len = preamble_len;
        command.seed = seed;
        command.ip_ascii = str_clr_txt;
        command.ip_str_len = str_len;
      	command.single_ip_mem_test = 'b0;
        finish_item(command);
       `uvm_info("SMOKETEST", $sformatf("SEQUENCE COMPLETE"), UVM_MEDIUM);
    endtask : body
endclass
