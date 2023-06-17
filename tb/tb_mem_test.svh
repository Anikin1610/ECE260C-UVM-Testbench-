class tb_mem_test extends tb_base_test;
    `uvm_component_utils(tb_mem_test)

    function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      //tb_driver_uvm::type_id::set_type_override(tb_mem_driver_uvm::get_type());
    endfunction
  	
    task run_phase(uvm_phase phase);
        mem_test_seq seq;
        seq = new("seq");
		
        phase.raise_objection(this);
        seq.start(h_sequencer);
        phase.drop_objection(this);
    endtask : run_phase
      
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new
endclass