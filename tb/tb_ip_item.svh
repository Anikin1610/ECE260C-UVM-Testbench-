class decryptor_ip_item extends uvm_sequence_item;
    `uvm_object_utils(decryptor_ip_item)
    rand int unsigned ptrn_sel;
    rand int unsigned preamble_len;
    rand logic [5 : 0] seed;
    rand int unsigned ip_str_len;
    rand logic [7 : 0] ip_ascii[64];
  
    constraint ptrn_rng {ptrn_sel inside {[0 : 5]};}
    constraint preamble_len_rng {preamble_len inside {[7 : 12]};}
    constraint str_len_rng {0 <= ip_str_len; ip_str_len <= 64 - preamble_len; solve preamble_len before ip_str_len;}
    constraint seed_rng {seed inside {[6'h01 : 6'h3F]};}
    constraint ascii_rng {foreach(ip_ascii[i]) {ip_ascii[i] inside {[8'h20 : 8'h5E], [8'h60 : 8'h7F]} ;}}
    
    randc logic [7 : 0] addr;
    rand logic [7 : 0] data;
    constraint addr_rng {addr inside {[8'h00 : 8'hFF]};}
    constraint data_rng {data inside {[8'h00 : 8'hFF]};}
    
    bit single_ip_mem_test;

    function new (string name = "decryptor_ip_item");
        super.new(name);
    endfunction
  
    function string convert2string();
      string s;
      string ip_str = "";
      for(int i = 0; i < ip_str_len; i++)
        ip_str = {ip_str, string'(ip_ascii[i])};
      s = $sformatf("ptrn_sel= %1d, preamble_len: %2d, seed= %6b, ip_str_len = %2d, addr = %h, data = %h, ip_str = %s", ptrn_sel, preamble_len, seed, ip_str_len, addr, data, ip_str);
      return s;
   endfunction
    
    /*`uvm_object_utils_begin(decryptor_ip_item)
  	     `uvm_field_int (ptrn_sel, UVM_DEFAULT)
  	     `uvm_field_int (preamble_len, UVM_DEFAULT)
  	     `uvm_field_int (seed, UVM_DEFAULT)
  	     `uvm_field_array_int (ip_ascii, UVM_DEFAULT)
  	     `uvm_field_int (ip_str_len, UVM_DEFAULT)
    `uvm_object_utils_end*/
endclass
