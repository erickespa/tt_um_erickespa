`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2025 03:09:28 PM
// Design Name: 
// Module Name: fsm_moore_inspeccion
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
typedef enum logic [2:0] {mo_S0, mo_S1, mo_S2, mo_S3, mo_S4} statetype;

module fsm_moore_inspeccion(
    input  logic clk,
    input  logic reset,
    input  logic P,        // Producto
    input  logic RI,       // Resultado de inspección
    output logic [1:0] E,    // Salida     
    output statetype mo_current_state
);

    //estados
    
    statetype state, nextstate;
    
    

    // Salida interna
    logic [1:0] e_out;

    // Registro de estado
    always_ff @(posedge clk, posedge reset)
        if (reset)
            state <= mo_S0;
        else
            state <= nextstate;

    //transición de estados
    always_comb begin
        case (state)
            mo_S0: begin
                if (P)
                    nextstate = mo_S1;
                else
                    nextstate = mo_S0;
            end
            mo_S1: begin
                if (!P)
                    nextstate = mo_S0;
                else if (RI)
                    nextstate = mo_S2;
                else
                    nextstate = mo_S3;
            end
            mo_S2: begin
                if (!P)
                    nextstate = mo_S0;
                else if (RI)
                    nextstate = mo_S4;
                else
                    nextstate = mo_S3;
            end
            mo_S3: nextstate = mo_S0;
            mo_S4: nextstate = mo_S0;
            default: nextstate = mo_S0;
        endcase
    end

    // salida
    always_comb begin
        case (state)
            mo_S0: e_out = 2'b00; // Nada
            mo_S1: e_out = 2'b01; // Avanzar
            mo_S2: e_out = 2'b01; // Avanzar
            mo_S3: e_out = 2'b10; // Rechazado
            mo_S4: e_out = 2'b11; // Aprobado
            default: e_out = 2'b00;
        endcase
    end

    // Asignación salida
    assign E = e_out;
    assign mo_current_state = state;

endmodule
