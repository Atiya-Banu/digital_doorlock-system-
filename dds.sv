`timescale 1ns/1ps

module digital_door_lock (
    input  logic       clk,
    input  logic       reset,
    input  logic       enter,
    input  logic [3:0] sw,

    output logic       door_unlock,
    output logic       door_lock,
    output logic       alarm
);

    // Password Register
    logic [3:0] password_reg;

    // Correct Password
    localparam logic [3:0] PASSWORD = 4'b1111;

    
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        CHECK = 2'b01,
        OPEN  = 2'b10,
        WRONG = 2'b11
    } state_t;

    state_t state;


   
    always_ff @(posedge clk or posedge reset) begin

        if (reset)
            password_reg <= 4'b0000;

        else if (enter)
            password_reg <= sw;

    end


    // --------------------------------
    // FSM
    // --------------------------------
    always_ff @(posedge clk or posedge reset) begin

        if (reset)
            state <= IDLE;

        else begin

            case (state)

                // Waiting for password
                IDLE: begin
                    if (enter)
                        state <= CHECK;
                end


                // Check password
                CHECK: begin

                    if (password_reg == PASSWORD)
                        state <= OPEN;

                    else
                        state <= WRONG;

                end


                // Correct password
                OPEN: begin
                    state <= OPEN;
                end


                // Wrong password
                WRONG: begin
                    state <= IDLE;
                end


                default: begin
                    state <= IDLE;
                end

            endcase

        end

   end


    // --------------------------------
    // OUTPUT LOGIC
    // --------------------------------
    always_comb begin

        // Default values
        door_unlock = 1'b0;
        door_lock   = 1'b1;
        alarm       = 1'b0;


        case (state)

            
            OPEN: begin
                door_unlock = 1'b1;
                door_lock   = 1'b0;
                alarm       = 1'b0;
            end


          
            WRONG: begin
                door_unlock = 1'b0;
                door_lock   = 1'b1;
                alarm       = 1'b1;
            end
 

            
            default: begin
                door_unlock = 1'b0;
                door_lock   = 1'b1;
                alarm       = 1'b0;
            end

        endcase

    end

endmodule