`default_nettype none

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
    // Definición de estados moore
    parameter [2:0]
        mo_S0 = 3'd0,
        mo_S1 = 3'd1,
        mo_S2 = 3'd2,
        mo_S3 = 3'd3,
        mo_S4 = 3'd4;
        
    // Definición de estados mealy
    parameter [1:0]
        me_S0 = 2'd0,
        me_S1 = 2'd1,
        me_S2 = 2'd2,
        me_S3 = 2'd3;
        
    // Registros de estado moore
    reg [2:0] mo_state, mo_nextstate;
    
    // Registros de estado mealy
    reg [1:0] me_state, me_next_state;
    
    // Salida interna
    reg [1:0] e_out;
    reg [1:0] Y;
    
        // Registro de estado moore
 always @(posedge clk or negedge rst_n) begin
    if (!rst_n)                   
        mo_state <= mo_S0;
    else
        mo_state <= mo_nextstate;
end
    
        // Registro de estado mealy
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            me_state <= me_S0;
        else
            me_state <= me_next_state;
    end
    
    
     // Lógica de transición de estados moore
    always @(*) begin
        mo_nextstate = mo_state;
        case (mo_state)
            mo_S0: begin
                if (ui_in[0])
                    mo_nextstate = mo_S1;
                else
                    mo_nextstate = mo_S0;
            end
            mo_S1: begin
                if (!ui_in[0])
                    mo_nextstate = mo_S0;
                else if (ui_in[1])
                    mo_nextstate = mo_S2;
                else
                    mo_nextstate = mo_S3;
            end
            mo_S2: begin
                if (!ui_in[0])
                    mo_nextstate = mo_S0;
                else if (ui_in[1])
                    mo_nextstate = mo_S4;
                else
                    mo_nextstate = mo_S3;
            end
            mo_S3: mo_nextstate = mo_S0;
            mo_S4: mo_nextstate = mo_S0;
            default: mo_nextstate = mo_S0;
        endcase
    end
    
    
        // Lógica de salida (Moore)
    always @(*) begin
        case (mo_state)
            mo_S0: e_out = 2'b00; // Nada
            mo_S1: e_out = 2'b01; // Avanzar
            mo_S2: e_out = 2'b01; // Avanzar
            mo_S3: e_out = 2'b10; // Rechazado
            mo_S4: e_out = 2'b11; // Aprobado
            default: e_out = 2'b00;
        endcase
    end
    
    
        // Lógica combinacional mealy
    always @(*) begin
        me_next_state = me_state;
        Y = 2'b00;

        case (me_state)
            me_S0: begin
                case (e_out)
                    2'b00: begin
                        me_next_state = me_S0;
                        Y = 2'b00;
                    end
                    2'b01: begin
                        me_next_state = me_S1;
                        Y = 2'b00;
                    end
                    default: begin
                        me_next_state = me_S0;
                        Y = 2'b00;
                    end
                endcase
            end

            me_S1: begin
                Y = 2'b01;
                case (e_out)
                    2'b00: me_next_state = me_S0;
                    2'b01: me_next_state = me_S1;
                    2'b10: me_next_state = me_S2;
                    2'b11: me_next_state = me_S3;
                    default: me_next_state = me_S0;
                endcase
            end

            me_S2: begin
                me_next_state = me_S0;
                Y = 2'b10;
            end

            me_S3: begin
                me_next_state = me_S0;
                Y = 2'b11;
            end

            default: begin
                me_next_state = me_S0;
                Y = 2'b00;
            end
        endcase
    end
    
        // Asignación de salida
    assign uo_out = {6'b000000, Y};
    assign uio_out = 0;
    assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in, ui_in[7:2], 1'b0};

endmodule
