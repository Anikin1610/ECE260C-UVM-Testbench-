class tb_driver_uvm extends uvm_driver #(decryptor_ip_item);
    `uvm_component_utils(tb_driver_uvm)
    
    virtual decryptor_bfm bfm;
    
    function new (string name = "tb_driver_uvm", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual decryptor_bfm)::get(this, "", "bfm", bfm)) begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface");
        end
    endfunction
    
    virtual task run_phase (uvm_phase phase);
        decryptor_ip_item ip_transaction;
        logic [7 : 0] enc_ip[64];
        forever begin
            seq_item_port.get_next_item(ip_transaction);
          	bfm.set_cfg(ip_transaction.ip_str_len, ip_transaction.ptrn_sel, ip_transaction.preamble_len, ip_transaction.seed, ip_transaction.addr, ip_transaction.data, ip_transaction.single_ip_mem_test);
            if(!ip_transaction.single_ip_mem_test) begin
              	`uvm_info("DRIVER", $sformatf("%s", ip_transaction.convert2string()), UVM_MEDIUM);
              	`uvm_info("DRIVER", "ENCRYPTING TRANSACTION", UVM_MEDIUM);
              	bfm.do_encryption(ip_transaction.ip_ascii, enc_ip);
              	`uvm_info("DRIVER", "WRITING TO MEMORY", UVM_MEDIUM);
                bfm.write_ip(enc_ip);
              	`uvm_info("DRIVER", "BEGIN DECRYPTION", UVM_MEDIUM);
                //if (ip_transaction.decrypt)
                bfm.do_decryption();
            	bfm.read_op();
            end
          	else begin
                `uvm_info("MEM_DRIVER", $sformatf("%s", ip_transaction.convert2string()), UVM_MEDIUM);
                `uvm_info("MEM_DRIVER", "WRITING TO MEMORY", UVM_MEDIUM);
                bfm.write_ip_addr(ip_transaction.data, ip_transaction.addr);
                `uvm_info("MEM_DRIVER", "READING FROM MEMORY", UVM_MEDIUM);
                bfm.read_op_addr(ip_transaction.addr);
            end
            seq_item_port.item_done();
        end
    endtask

endclass
