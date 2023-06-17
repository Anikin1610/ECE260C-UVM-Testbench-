class tb_var_len_test extends tb_rand_test;
    `uvm_component_utils(tb_var_len_test)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        decryptor_ip_item::type_id::set_type_override(decryptor_var_len_item::get_type());
        $display("VAR_LEN_TEST BUILD_PHASE");
    endfunction

endclass