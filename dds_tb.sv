`timescale 1ns/1ps

module tb_digital_door_lock;

    logic       clk;
    logic       reset;
    logic       enter;
    logic [3:0] sw;

    logic       door_unlock;
    logic       door_lock;
    logic       alarm;


    // --------------------------------
    // DUT
    // --------------------------------
    digital_door_lock DUT (

        .clk(clk),
        .reset(reset),
        .enter(enter),
        .sw(sw),

        .door_unlock(door_unlock),
        .door_lock(door_lock),
        .alarm(alarm)

    );


    // --------------------------------
    // CLOCK
    // 10 ns clock period
    // --------------------------------
    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    // --------------------------------
    // TEST
    // --------------------------------
    initial begin

        // Initial values
        reset = 1'b1;
        enter = 1'b0;
        sw    = 4'b0000;


        // Reset
        #10;
        reset = 1'b0;


        // =================================
        // TEST 1 : 0000
        // =================================

        #10;

        sw = 4'b0000;
        enter = 1'b1;

        #10;
        enter = 1'b0;

        #10;

        $display("-------------------------------------");
        $display("Password = %b", sw);
        $display("Unlock   = %b", door_unlock);
        $display("Lock     = %b", door_lock);
        $display("Alarm    = %b", alarm);


        // =================================
        // TEST 2 : 0101
        // =================================

        #10;

        sw = 4'b0101;
        enter = 1'b1;

        #10;
        enter = 1'b0;

        #10;

        $display("-------------------------------------");
        $display("Password = %b", sw);
        $display("Unlock   = %b", door_unlock);
        $display("Lock     = %b", door_lock);
        $display("Alarm    = %b", alarm);


        // =================================
        // TEST 3 : 1010
        // =================================

        #10;

        sw = 4'b1010;
        enter = 1'b1;

        #10;
        enter = 1'b0;

        #10;

        $display("-------------------------------------");
        $display("Password = %b", sw);
        $display("Unlock   = %b", door_unlock);
        $display("Lock     = %b", door_lock);
        $display("Alarm    = %b", alarm);


        // =================================
        // TEST 4 : 1111
        // Correct Password
        // =================================

        #10;

        sw = 4'b1111;
        enter = 1'b1;

        #10;
        enter = 1'b0;

        // Wait for FSM to reach OPEN
        #20;

        $display("-------------------------------------");
        $display("CORRECT PASSWORD TEST");
        $display("Password = %b", sw);
        $display("Unlock   = %b", door_unlock);
        $display("Lock     = %b", door_lock);
        $display("Alarm    = %b", alarm);

        if (door_unlock == 1'b1)
            $display(">>> DOOR UNLOCKED <<<");
        else
            $display(">>> DOOR LOCKED <<<");


        $display("-------------------------------------");


        // Finish simulation
        #30;

        $finish;

    end

endmodule