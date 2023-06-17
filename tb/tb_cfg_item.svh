class decryptor_cfg_item extends uvm_sequence_item;
    `uvm_object_utils(decryptor_cfg_item);

    int unsigned ptrn_sel;
    int unsigned preamble_len;
    logic [5 : 0] seed;
    int unsigned ip_str_len;
    logic [7 : 0] addr;
  	logic [7 : 0] data;

    logic single_ip_mem_test;

    function new(string name = "decryptor_cfg_item");
        super.new(name);
    endfunction: new

    function string convert2string();
        string s;
        s = $sformatf("ptrn_sel= %1d, preamble_len: %2d, seed= %6b, ip_str_len = %2d, addr = %h, data = %h", ptrn_sel, preamble_len, seed, ip_str_len, addr, data);
        return s;
    endfunction
endclass
