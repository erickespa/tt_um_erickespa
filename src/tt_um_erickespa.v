module tt_um_erickespa (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Entradas asignadas desde ui
    wire P  = ui_in[0];  // Producto
    wire RI = ui_in[1];  // Resultado de inspección

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
        
    );

    // FSM Mealy
    fsm_mealy_protocolo mealy (
        .clk(clk),
        .reset(reset),
        .E(E),
        .Y(Y),
        
    );

    // Asignación de salidas protegida por enable
    assign uo_out[1:0] = E;
    assign uo_out[3:2] = Y;
    assign uo_out[7:4] = 0;
    assign uio_out = 0;
    assign uio_oe  = 0;

      // List all unused inputs to prevent warnings
    wire _unused = &{ena, uio_in, ui_in[7:2], 1'b0};

endmodule
