class tb_parallel_test extends tb_base_test;
    `uvm_component_utils(tb_parallel_test)

    mem_test_seq h_mem_test_seq;
    rand_test_seq h_rand_test_seq;

    function new(string name = "tb_parallel_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
    endfunction
    
    task run_phase(uvm_phase phase);
        h_mem_test_seq = mem_test_seq::type_id::create("h_mem_test_seq");
        h_rand_test_seq = rand_test_seq::type_id::create("h_rand_test_seq");
        phase.raise_objection(this);
        fork
            h_mem_test_seq.start(h_sequencer);
            h_rand_test_seq.start(h_sequencer);
        join
        phase.drop_objection(this);
    endtask : run_phase
    
endclass 