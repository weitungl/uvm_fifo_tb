// Environment 
class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)

    fifo_write_agent    w_agent;
    fifo_read_agent     r_agent;
    fifo_scoreboard     scb;
    fifo_coverage       cov;

    function new(string name = "fifo_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        w_agent = fifo_write_agent::type_id::create("w_agent", this);
        r_agent = fifo_read_agent::type_id::create("r_agent", this);
        scb     = fifo_scoreboard::type_id::create("scb", this);
        cov     = fifo_coverage::type_id::create("cov", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        w_agent.mon.analysis_port.connect(scb.write_export);
        r_agent.mon.analysis_port.connect(scb.read_export);

        w_agent.drv.drv_ap.connect(cov.analysis_export);
        r_agent.drv.drv_ap.connect(cov.analysis_export);
    endfunction

endclass