// Tiny Tapeout Top-Level Module: tt_um_erickespa

module tt_um_erickespa (
    input  wire [7:0] in,
    output wire [7:0] out
);

    wire clk   = in[0];
    wire reset = in[1];
    wire P     = in[2];
    wire RI    = in[3];

    wire [1:0] E;
    wire [1:0] Y;

    // Opcional: observar estados
    wire [2:0] mo_state;
    wire [1:0] me_state;

    fsm_moore_inspeccion moore (
        .clk(clk),
        .reset(reset),
        .P(P),
        .RI(RI),
        .E(E),
        .mo_current_state(mo_state)
    );

    fsm_mealy_protocolo mealy (
        .clk(clk),
        .reset(reset),
        .E(E),
        .Y(Y),
        .me_current_state(me_state)
    );

    // Salidas generales
    assign out[1:0] = E;         // Salida Moore
    assign out[3:2] = Y;         // Salida Mealy
    assign out[6:4] = mo_state;  // Estado Moore (opcional)
    assign out[7]   = me_state[0]; // Estado Mealy bit 0 (usa bit 1 si quieres más)

endmodule

// === FSM MOORE ===

typedef enum logic [2:0] {mo_S0, mo_S1, mo_S2, mo_S3, mo_S4} statetype;

module fsm_moore_inspeccion(
    input  logic clk,
    input  logic reset,
    input  logic P,
    input  logic RI,
    output logic [1:0] E,
    output statetype mo_current_state
);

    statetype state, nextstate;
    logic [1:0] e_out;

    always_ff @(posedge clk, posedge reset)
        if (reset)
            state <= mo_S0;
        else
            state <= nextstate;

    always_comb begin
        case (state)
            mo_S0: nextstate = P ? mo_S1 : mo_S0;
            mo_S1: nextstate = !P ? mo_S0 : (RI ? mo_S2 : mo_S3);
            mo_S2: nextstate = !P ? mo_S0 : (RI ? mo_S4 : mo_S3);
            mo_S3: nextstate = mo_S0;
            mo_S4: nextstate = mo_S0;
            default: nextstate = mo_S0;
        endcase
    end

    always_comb begin
        case (state)
            mo_S0: e_out = 2'b00;
            mo_S1: e_out = 2'b01;
            mo_S2: e_out = 2'b01;
            mo_S3: e_out = 2'b10;
            mo_S4: e_out = 2'b11;
            default: e_out = 2'b00;
        endcase
    end

    assign E = e_out;
    assign mo_current_state = state;

endmodule

// === FSM MEALY ===

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

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= me_S0;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = state;
        Y = 2'b00;

        case (state)
            me_S0: case (E)
                2'b00: begin next_state = me_S0; Y = 2'b00; end
                2'b01: begin next_state = me_S1; Y = 2'b00; end
                default: begin next_state = me_S0; Y = 2'b00; end
            endcase

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

            me_S2: begin next_state = me_S0; Y = 2'b10; end
            me_S3: begin next_state = me_S0; Y = 2'b11; end

            default: begin next_state = me_S0; Y = 2'b00; end
        endcase
    end

endmodule
