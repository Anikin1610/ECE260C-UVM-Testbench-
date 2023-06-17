class tb_rand_test extends tb_base_test;
    `uvm_component_utils(tb_rand_test)

    rand_test_seq seq;

    virtual function void build_phase (uvm_phase phase);
      super.build_phase(phase);
    endfunction
  	
    task run_phase(uvm_phase phase);
        
        //seq = rand_test_seq::type_id::create("seq");
        seq = new("seq");
        phase.raise_objection(this);
        seq.start(h_sequencer);
        phase.drop_objection(this);
    endtask : run_phase
      
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new
endclass