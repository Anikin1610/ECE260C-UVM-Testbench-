class decryptor_var_len_item extends decryptor_ip_item;
    `uvm_object_utils(decryptor_var_len_item)
    
    constraint ptrn_rng_override {ptrn_sel == 3;}
    constraint seed_rng_override {seed == 6'h1F;}
    constraint preamble_len_override {preamble_len == 7;}
    constraint ascii_rng {foreach(ip_ascii[i]) ip_ascii[i] inside {8'h41};}

    function new (string name = "decryptor_var_len_item");
        super.new(name);
        $display("VAR_LEN_ITEM INITIALIZED");
    endfunction
endclass 