class tb_monitor_uvm extends uvm_monitor;
    `uvm_component_utils(tb_monitor_uvm)
    
    virtual decryptor_bfm bfm;
    
    uvm_analysis_port #(decryptor_result_item) mon_ap;
    uvm_analysis_port #(decryptor_cfg_item) mon_cfg_ap;

    
    function new (string name = "tb_monitor_uvm", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual decryptor_bfm)::get(this, "", "bfm", bfm)) begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface");
        end
        mon_ap = new("mon_ap", this);
        mon_cfg_ap = new("mon_cfg_ap", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        decryptor_result_item item  = decryptor_result_item::type_id::create("item");
        decryptor_cfg_item cfg_item = decryptor_cfg_item::type_id::create("cfg_item");
        super.run_phase(phase);
        forever begin
            @(posedge bfm.read_done) begin
                item.ip_str_len = bfm.str_len;   
                item.pre_length = bfm.pre_length;   
                item.ip_clr_txt = bfm.msg_input;
                item.op_clr_txt = bfm.msg_decryp2;
                mon_ap.write(item);

                cfg_item.ptrn_sel = bfm.ptrn_sel;
                cfg_item.preamble_len = bfm.pre_length;
                cfg_item.seed = bfm.LFSR_init;
                cfg_item.ip_str_len = bfm.str_len;
                cfg_item.addr = bfm.addr;
                cfg_item.data = bfm.data;
                cfg_item.single_ip_mem_test = bfm.single_ip_mem_test;
                mon_cfg_ap.write(cfg_item);
            end
        end
    endtask
    
endclass
