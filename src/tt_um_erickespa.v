module tt_um_erickespa (
    input  wire       clk,     // Clock (1 MHz)
    input  wire       rst_n,   // Active-low reset
    input  wire       ena,     // Global enable
    input  wire [7:0] ui,      // User inputs
    output wire [7:0] uo,      // User outputs
    inout  wire [7:0] uio      // Bidirectional pins (not used here)
);

    // Entradas asignadas desde ui
    wire P  = ui[0];  // Producto
    wire RI = ui[1];  // Resultado de inspección

    // Salidas internas
    wire [1:0] E;  // Salida de FSM Moore
    wire [1:0] Y;  // Salida de FSM Mealy

    // Reset activo en alto
    wire reset = ~rst_n;

    // FSM Moore
    fsm_moore_inspeccion moore (
        .clk(clk),
        .reset(reset),
        .P(P),
        .RI(RI),
        .E(E),
        .mo_current_state()  // Se ignora en top
    );

    // FSM Mealy
    fsm_mealy_protocolo mealy (
        .clk(clk),
        .reset(reset),
        .E(E),
        .Y(Y),
        .me_current_state()  // Se ignora en top
    );

    // Asignación de salidas protegida por enable
    assign uo[1:0] = ena ? E : 2'b00;
    assign uo[3:2] = ena ? Y : 2'b00;
    assign uo[7:4] = 4'b0000; // No usados
    assign uio     = 8'bzzzz_zzzz; // Pines no usados

endmodule
