class decryptor_result_item extends uvm_sequence_item;
    `uvm_object_utils(decryptor_result_item)
    logic [7 : 0] ip_clr_txt[64], op_clr_txt[64];
    int unsigned ip_str_len, pre_length;
    
    function new (string name = "decryptor_result_item");
        super.new(name);
    endfunction    
endclass
