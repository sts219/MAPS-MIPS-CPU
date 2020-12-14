module mips_cpu_bus_tb;
	timeunits 1ns/10ps;

parameter TIMEOUT_CYCLES = 10000;
    parameter TESTCASE_ID = "ORI_1";
    parameter INSTRUCTION = "ORI"


    logic clk;
    logic reset;
    logic active;
    logic[31:0] register_v0;

    logic[31:0] address;
    logic write;
    logic read;
    logic waitrequest;
    logic[31:0] writedata;
    logic[3:0] byteenable;
    logic[31:0] readdata;

    mips_cpu_bus cpuInst(clk, reset, active, register_v0, address, write, read, waitrequest, writedata, byteenable, readdata);

    initial begin
        clk=0;

        repeat (TIMEOUT_CYCLES) begin
            #10;
            clk = !clk;
            #10;
            clk = !clk;
        end

        $fatal(100, "%s %s Fail Simulation did not finish within %d cycles.", TESTCASE_ID, INSTRUCTION, TIMEOUT_CYCLES);
    end

    /*
    Assembly code:
		lui v1 0xbfc0
    lw t1 0x4(v1)
    ori  v0 v1 0x00
    */
	initial begin
        clk=0;

        repeat (TIMEOUT_CYCLES) begin
            #10;
            clk = !clk;
            #10;
            clk = !clk;
        end

        $fatal(100, "%s %s Fail Simulation did not finish within %d cycles.", TESTCASE_I
         initial begin
        reset <= 0;

        @(posedge clk);
        reset <= 1;

        @(posedge clk); //fetch
        reset <= 0;

        @(negedge clk);
        assert(active==1) else $fatal(101, "%s %s Fail CPU incorrectly set active." TESTCASE_ID, INSTRUCTION);
        assert(address==32'hBFC00000) else $fatal(102, "%s %s Fail CPU accessing incorrect address %h", TESTCASE_ID, INSTRUCTION, address);
        assert(read==1) else $fatal(103, "%s %s Fail CPU has read set incorrectly." TESTCASE_ID, INSTRUCTION);
        assert(write==0) else $fatal(104, "%s %s Fail CPU has write set incorrectly." TESTCASE_ID, INSTRUCTION);
        assert(byteenable==4'b1111) else $fatal(105, "%s %s Fail CPU incorrectly set byteenable %b." TESTCASE_ID, INSTRUCTION, byteenable);

        @(posedge clk); //exec
        readdata <= 32'h8C030001; //lw v1 0x1(zero) (loads value at address == 1)
        // Use https://www.eg.bucknell.edu/~csci320/mips_web/ to convert assembly to hex
        waitrequest <= 0;

        @(negedge clk);
        assert(address==32'd1) else $fatal(102, "%s %s Fail CPU accessing incorrect address %h", TESTCASE_ID, INSTRUCTION, address);
        //cba checking other variables

        @(posedge clk); //mem_access
        readdata <= 32'd192; //value accessed by load word

        @(posedge clk); //fetch

        @(negedge clk);
        assert(address==32'hBFC00004) else $fatal(102, "%s %s Fail CPU accessing incorrect address %h", TESTCASE_ID, INSTRUCTION, address);

        @(posedge clk); //exec
        readdata <= 32'h00000008 // jr zero

        @(posedge clk); //fetch

        @(negedge clk);
        assert(address==32'hBFC00008) else $fatal(102, "%s %s Fail CPU accessing incorrect address %h", TESTCASE_ID, INSTRUCTION, address);

        @(posedge clk); //exec
        readdata <= 32'h24430000; //ori v1 v0 0x0

        @(negedge clk);
        assert(register_v0==32'd192) assert(write==0) else $fatal(106, "%s %s Fail Incorrect value %d stored in v0." TESTCASE_ID, INSTRUCTION, register_v0);



        @(posedge clk); //pc == 0 => cpu should halt

        @(negedge clk);
        assert(active==0) else $fatal(101, "%s %s Fail CPU incorrectly set active." TESTCASE_ID, INSTRUCTION);

        $display("%s %s Pass #ORI 0", TESTCASE_ID, INSTRUCTION);
        $finish;
    end

endmodule
