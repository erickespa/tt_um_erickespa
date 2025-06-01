module tt_um_erickespa (
    input  wire [7:0] ui_in,      // Entradas externas
    output wire [7:0] uo_out,     // Salidas externas
    input  wire       clk,        // Reloj del sistema
    input  wire       rst         // Reset
);

    // Entradas asignadas
    wire P     = ui_in[0];  // Producto
    wire RI    = ui_in[1];  // Resultado de inspección

    // Salidas internas
    wire [1:0] E;  // Salida de Moore
    wire [1:0] Y;  // Salida de Mealy

    // FSM Moore
    fsm_moore_inspeccion moore (
        .clk(clk),
        .reset(rst),
        .P(P),
        .RI(RI),
        .E(E),
        .mo_current_state()  // No se usa en top
    );

    // FSM Mealy
    fsm_mealy_protocolo mealy (
        .clk(clk),
        .reset(rst),
        .E(E),
        .Y(Y),
        .me_current_state()  // No se usa en top
    );

    // Salida a los pines
    assign uo_out[1:0] = E;  // Salida Moore (opcional)
    assign uo_out[3:2] = Y;  // Salida Mealy
    assign uo_out[7:4] = 4'b0000; // No usado

endmodule
