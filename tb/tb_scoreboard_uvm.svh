class tb_scoreboard_uvm extends uvm_scoreboard;
    `uvm_component_utils(tb_scoreboard_uvm)
    
    uvm_analysis_imp #(decryptor_result_item, tb_scoreboard_uvm) scoreboard_ap_imp;
    static int unsigned lowest_str_len, lowest_msg_len, lowest_pre_length, max_pre_length;
    
    function new (string name = "tb_scoreboard_uvm", uvm_component parent = null);
        super.new(name, parent);
        lowest_str_len = 999999;
        lowest_msg_len = 999999;
        lowest_pre_length = 999999;
        max_pre_length = 0;
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scoreboard_ap_imp = new("scoreboard_ap_imp", this);
    endfunction
    
    function void write(decryptor_result_item res_item);
		string s = "";
        bit fail = 'b0;
      	`uvm_info(get_type_name(), $sformatf("INSIDE SCOREBOARD:"), UVM_MEDIUM);
      	for(int i = 0; i < res_item.ip_str_len; i++)
        	s = {s, string'(res_item.op_clr_txt[i])};
      	`uvm_info(get_type_name(), $sformatf("OP: %s", s), UVM_MEDIUM);
        for(int i = 0; i < res_item.ip_str_len; i++) begin
            if (res_item.ip_clr_txt[i] != res_item.op_clr_txt[i])
                fail = 'b1;
        end
        if(fail) begin
            `uvm_error(get_type_name(), $sformatf("Error! Expected output and actual output does not match. String length = %2d", res_item.ip_str_len + res_item.pre_length))
            if (res_item.ip_str_len + res_item.pre_length < lowest_str_len)
                lowest_str_len = res_item.ip_str_len + res_item.pre_length;
            if (res_item.ip_str_len < lowest_msg_len)
                lowest_msg_len = res_item.ip_str_len;
            if (res_item.pre_length < lowest_pre_length)
                lowest_pre_length = res_item.pre_length;
            if (res_item.pre_length > max_pre_length)
                max_pre_length = res_item.pre_length;
        end
        else
            `uvm_info(get_type_name(), $sformatf("Test passed!"), UVM_LOW);
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCOREBOARD REPORT", $sformatf("\nLowest Failing string length = %2d\nLowest Failing message length = %2d\nLowest Failing preamble length = %2d\nHighest Failing preamble length = %2d", lowest_str_len, lowest_msg_len, lowest_pre_length, max_pre_length), UVM_NONE)
    endfunction: report_phase
endclass
