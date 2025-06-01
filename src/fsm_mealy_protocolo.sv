`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2025 02:13:39 PM
// Design Name: 
// Module Name: fsm_mealy_protocolo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
typedef enum logic [1:0] {
    me_S0 = 2'd0,
    me_S1 = 2'd1,
    me_S2 = 2'd2,
    me_S3 = 2'd3
} state_t;

module fsm_mealy_protocolo (
    input  logic        clk,
    input  logic        reset,
    input  logic [1:0]  E,
    output logic [1:0]  Y,
    output state_t      me_current_state
);

    state_t state, next_state;

    assign me_current_state = state; 

    // Registro de estado
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= me_S0;
        else
            state <= next_state;
    end

    // Lógica
    always_comb begin
        next_state = state;
        Y = 2'b00;

        case (state)
            me_S0: begin
                case (E)
                    2'b00: begin
                        next_state = me_S0;
                        Y = 2'b00;
                    end
                    2'b01: begin
                        next_state = me_S1;
                        Y = 2'b00;
                    end
                    default: begin
                        next_state = me_S0;
                        Y = 2'b00;
                    end
                endcase
            end

            me_S1: begin
                Y = 2'b01;
                case (E)
                    2'b00: next_state = me_S0;
                    2'b01: next_state = me_S1;
                    2'b10: next_state = me_S2;
                    2'b11: next_state = me_S3;
                    default: next_state = me_S0;
                endcase
            end

            me_S2: begin
                next_state = me_S0;
                Y = 2'b10;
            end

            me_S3: begin
                next_state = me_S0;
                Y = 2'b11;
            end

            default: begin
                next_state = me_S0;
                Y = 2'b00;
            end
        endcase
    end

endmodule

