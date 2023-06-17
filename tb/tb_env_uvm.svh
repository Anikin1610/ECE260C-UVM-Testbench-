class tb_env_uvm extends uvm_env;
    `uvm_component_utils(tb_env_uvm)
    
    tb_driver_uvm h_driver;
    tb_monitor_uvm h_monitor;
    tb_scoreboard_uvm h_scoreboard;
    // Sequencer???
    uvm_sequencer #(decryptor_ip_item) h_sequencer;

    coverage h_coverage;
    
    function new (string name = "tb_env_uvm", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        h_scoreboard = tb_scoreboard_uvm::type_id::create("h_scoreboard", this);
        h_monitor    = tb_monitor_uvm::type_id::create("h_monitor", this);
        h_driver     = tb_driver_uvm::type_id::create("h_driver", this);
        h_sequencer  = uvm_sequencer#(decryptor_ip_item)::type_id::create("h_sequencer", this);
        h_coverage   = coverage::type_id::create("h_coverage", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        h_monitor.mon_ap.connect(h_scoreboard.scoreboard_ap_imp);
        h_monitor.mon_cfg_ap.connect(h_coverage.analysis_export);
        h_driver.seq_item_port.connect(h_sequencer.seq_item_export);
    endfunction
    
    
endclass
