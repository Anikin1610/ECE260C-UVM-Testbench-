class coverage extends uvm_subscriber #(decryptor_cfg_item);
    `uvm_component_utils(coverage)

    int unsigned  ptrn_sel;
    int unsigned  preamble_len;
    logic [5 : 0] seed;
    int unsigned  ip_str_len;
    logic [7 : 0] addr;
    logic [7 : 0] data;

    real mem_coverage;
    real polyn_coverage;
    real preamble_coverage;
    real seed_coverage;
    real str_len_coverage;
    //  Covergroup: cg_ptrn_sel
    //
    covergroup cg_polyn_coverage;
        coverpoint ptrn_sel {
            bins ptrn_sel_bins[] = {[0 : 5]}; // 6 separate bins for each value of ptrn_sel
        }
    endgroup

    covergroup cg_preamble_cov;
        coverpoint preamble_len {
            bins preamble_len_bins[] = {[7 : 12]};
        }
    endgroup

    covergroup cg_seed_cov;
        coverpoint seed {
            bins seed_bins[] = {[1 : $]}; 
        }
    endgroup
    
    covergroup cg_str_len_cov;
        coverpoint ip_str_len {
            bins ip_str_len_bins[] = {[0 : 57]};
        }
    endgroup

    covergroup cg_mem_test ;
        coverpoint addr {
            bins addr_bins[] = {[0 : $]}; 
        }

        coverpoint data {
            bins data_bins[] = {[0 : $]};
        }
    endgroup: cg_mem_test

    function new(string name = "coverage", uvm_component parent);
        super.new(name, parent);
        cg_polyn_coverage = new();
        cg_preamble_cov   = new();
        cg_seed_cov       = new();
        cg_str_len_cov    = new();
        cg_mem_test       = new();
    endfunction

    function void write(decryptor_cfg_item cfg_item);
        ptrn_sel     = cfg_item.ptrn_sel;
        preamble_len = cfg_item.preamble_len;
        seed         = cfg_item.seed;
        ip_str_len   = cfg_item.ip_str_len;
        addr         = cfg_item.addr;
        data         = cfg_item.data;
        
        if (cfg_item.single_ip_mem_test) begin
            cg_mem_test.sample();
            //$display("COVERAGE: addr = %8h, data = %8h", addr, data);
        end
        else begin
            cg_polyn_coverage.sample();  
            cg_preamble_cov.sample();  
            cg_seed_cov.sample();      
            cg_str_len_cov.sample();     
        end
    endfunction

    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        polyn_coverage = cg_polyn_coverage.get_coverage();
        preamble_coverage = cg_preamble_cov.get_coverage();
        seed_coverage = cg_seed_cov.get_coverage();
        str_len_coverage = cg_str_len_cov.get_coverage();
        mem_coverage = cg_mem_test.get_coverage();
    endfunction: extract_phase

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_name(), $sformatf("\nPolynomial Coverage = %f\nPreamble Coverage = %f\nSeed Coverage = %f\nString Length Coverage = %f\nMemory Functional Coverage = %f", polyn_coverage, preamble_coverage, seed_coverage, str_len_coverage, mem_coverage), UVM_NONE)
    endfunction: report_phase
endclass
