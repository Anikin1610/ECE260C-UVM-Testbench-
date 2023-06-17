class rand_test_seq extends uvm_sequence #(decryptor_ip_item);
    `uvm_object_utils(rand_test_seq)

    decryptor_ip_item command;

    function new (string name = "rand_test_seq");
        super.new(name);
    endfunction
  
  	virtual function void item_override_cnstrs(decryptor_ip_item h_command);
  		/*h_command.ptrn_rng.constraint_mode(0);
    	h_command.preamble_len_rng.constraint_mode(0);
    	h_command.str_len_rng.constraint_mode(0);
    	h_command.seed_rng.constraint_mode(0);
    	h_command.ascii_rng.constraint_mode(0);*/
      	return;
    endfunction
  	
  	virtual function void item_set_val(decryptor_ip_item h_command);
        /*h_command.ptrn_sel = 0;
        h_command.preamble_len = 0;
        h_command.seed = 'd0;
        h_command.ip_str_len = 1;
        foreach(h_command.ip_ascii[i])
          h_command.ip_ascii[i] = 'd0;*/
      	return;
    endfunction
    
    task body();
        command = decryptor_ip_item::type_id::create("command");
        `uvm_info("RAND_TEST", "SEQUENCE INITIATED", UVM_MEDIUM);
        repeat (1000) begin      
            start_item(command);
            if(!command.randomize())
                `uvm_fatal(get_name(), "RANDOMIZATION FAILED")
                
            //item_set_val(command);
            command.single_ip_mem_test = 'b0;
            finish_item(command);
        end
      	`uvm_info("RAND TEST", $sformatf("SEQUENCE COMPLETE"), UVM_MEDIUM);
    endtask : body
endclass