class mem_test_seq extends uvm_sequence #(decryptor_ip_item);
    `uvm_object_utils(mem_test_seq)
    
    function new (string name = "mem_test_seq");
        super.new(name);
    endfunction
    
    task body();
        decryptor_ip_item command;
        command = decryptor_ip_item::type_id::create("command");
      
      	command.ptrn_rng.constraint_mode(0);
    	command.preamble_len_rng.constraint_mode(0);
    	command.str_len_rng.constraint_mode(0);
    	command.seed_rng.constraint_mode(0);
    	command.ascii_rng.constraint_mode(0);
      
        `uvm_info("MEM_TEST", "SEQUENCE INITIATED", UVM_MEDIUM);
      repeat (1000) begin      
              start_item(command);
              command.randomize();
              command.ptrn_sel = 0;
              command.preamble_len = 0;
              command.seed = 'd0;
              command.ip_str_len = 1;
              foreach(command.ip_ascii[i])
                  command.ip_ascii[i] = 'd0;
              command.single_ip_mem_test = 'b1;
              finish_item(command);
          end
      	`uvm_info("MEM_TEST", $sformatf("SEQUENCE COMPLETE"), UVM_MEDIUM);
    endtask : body
endclass