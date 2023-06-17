class tb_smoketest extends tb_base_test;
    `uvm_component_utils(tb_smoketest)

    task run_phase(uvm_phase phase);
        def_sequence seq;
        seq = new("seq");

        phase.raise_objection(this);
        seq.start(h_sequencer);
        //#10000;
        phase.drop_objection(this);
    endtask : run_phase
      
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new
endclass
