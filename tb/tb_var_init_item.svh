class decryptor_var_init_item extends decryptor_ip_item;
    `uvm_object_utils(decryptor_var_init_item)
    
    constraint preamble_len_rng_override {preamble_len == 10;}
    constraint str_len_rng_override {ip_str_len == 35;}
    constraint ascii_rng_override {foreach(ip_ascii[i]) {ip_ascii[i] == 8'h41;}}

    function new (string name = "decryptor_var_init_item");
        super.new(name);
        $display("VAR_INIT_ITEM INITIALIZED");
    endfunction
endclass 