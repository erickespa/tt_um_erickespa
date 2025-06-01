module tt_um_erickespa (
    input  logic [7:0] in,      // Entradas de usuario
    output logic [7:0] out,     // Salidas de usuario
    input  logic clk,           // Reloj
    input  logic rst_n          // Reset activo bajo
);

    // Señales internas
    logic reset;
    logic [1:0] E;               // Salida de Moore, entrada de Mealy
    logic [1:0] Y;               // Salida de Mealy
    statetype mo_current_state; // Estado Moore
    state_t me_current_state;   // Estado Mealy

    // Reset activo alto para módulos internos
    assign reset = ~rst_n;

    // Asignar entradas
    logic P = in[0];
    logic RI = in[1];

    // Instancia FSM Moore
    fsm_moore_inspeccion moore_inst (
        .clk(clk),
        .reset(reset),
        .P(P),
        .RI(RI),
        .E(E),
        .mo_current_state(mo_current_state)
    );

    // Instancia FSM Mealy
    fsm_mealy_protocolo mealy_inst (
        .clk(clk),
        .reset(reset),
        .E(E),
        .Y(Y),
        .me_current_state(me_current_state)
    );

    // Salidas
    assign out[1:0] = E;                  // Salida de la Moore
    assign out[3:2] = Y;                  // Salida de la Mealy
    assign out[6:4] = mo_current_state;   // Estado Moore (debug)
    assign out[7]   = me_current_state[0]; // Estado Mealy (bit bajo, debug simple)

endmodule
