//=============================================================================
// Module: secded_2z
// Description: (22,16) SECDED Encoder/Decoder with 2Z Rail Verification
// Payload: 16 bits [15:0], Code Word: 22 bits [21:0] (16 data + 6 parity)
// Bit 0 enforced as even-rail parity bit (data[0] == 0)
//=============================================================================

module secded_2z (
    input  logic [15:0] data_in,      // 16-bit input payload
    input  logic [21:0] rx_code_word, // 22-bit received code word for decoding
    output logic [5:0]  ecc_gen,      // Generated 6-bit parity for transmission
    output logic [15:0] data_out,     // Corrected 16-bit output payload
    output logic        single_error, // Single error detected and corrected
    output logic        double_error, // Double error detected (uncorrectable)
    output logic        rail_fault    // 2Z Rail parity violation flag (LSB != 0)
);

    //-------------------------------------------------------------------------
    // 1. SECDED ENCODER: Generate Parity Bits p0..p4 (Hamming) + p5 (Overall)
    //-------------------------------------------------------------------------
    logic p0, p1, p2, p3, p4, p5;

    // Bitwise Hamming parity equations over 16-bit payload
    assign p0 = data_in[0]  ^ data_in[1]  ^ data_in[3]  ^ data_in[4]  ^ 
                data_in[6]  ^ data_in[8]  ^ data_in[10] ^ data_in[11] ^ 
                data_in[13] ^ data_in[15];

    assign p1 = data_in[0]  ^ data_in[2]  ^ data_in[3]  ^ data_in[5]  ^ 
                data_in[6]  ^ data_in[9]  ^ data_in[10] ^ data_in[12] ^ 
                data_in[13];

    assign p2 = data_in[1]  ^ data_in[2]  ^ data_in[3]  ^ data_in[7]  ^ 
                data_in[8]  ^ data_in[9]  ^ data_in[10] ^ data_in[14] ^ 
                data_in[15];

    assign p3 = data_in[4]  ^ data_in[5]  ^ data_in[6]  ^ data_in[7]  ^ 
                data_in[8]  ^ data_in[9]  ^ data_in[10];

    assign p4 = data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ 
                data_in[15];

    // Overall parity bit p5 for SECDED extension
    assign p5 = p0 ^ p1 ^ p2 ^ p3 ^ p4 ^ 
                data_in[0]  ^ data_in[1]  ^ data_in[2]  ^ data_in[3]  ^ 
                data_in[4]  ^ data_in[5]  ^ data_in[6]  ^ data_in[7]  ^ 
                data_in[8]  ^ data_in[9]  ^ data_in[10] ^ data_in[11] ^ 
                data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15];

    assign ecc_gen = {p5, p4, p3, p2, p1, p0};

    //-------------------------------------------------------------------------
    // 2. SECDED DECODER: Syndrome Matrix & Error Correction
    //-------------------------------------------------------------------------
    logic [4:0] syndrome;
    logic       overall_parity_check;
    logic [15:0] rx_data;
    logic [5:0]  rx_ecc;

    assign rx_data = rx_code_word[15:0];
    assign rx_ecc  = rx_code_word[21:16];

    // Recalculate Hamming syndrome bits
    assign syndrome[0] = rx_ecc[0] ^ rx_data[0]  ^ rx_data[1]  ^ rx_data[3]  ^ 
                         rx_data[4]  ^ rx_data[6]  ^ rx_data[8]  ^ rx_data[10] ^ 
                         rx_data[11] ^ rx_data[13] ^ rx_data[15];

    assign syndrome[1] = rx_ecc[1] ^ rx_data[0]  ^ rx_data[2]  ^ rx_data[3]  ^ 
                         rx_data[5]  ^ rx_data[6]  ^ rx_data[9]  ^ rx_data[10] ^ 
                         rx_data[12] ^ rx_data[13];

    assign syndrome[2] = rx_ecc[2] ^ rx_data[1]  ^ rx_data[2]  ^ rx_data[3]  ^ 
                         rx_data[7]  ^ rx_data[8]  ^ rx_data[9]  ^ rx_data[10] ^ 
                         rx_data[14] ^ rx_data[15];

    assign syndrome[3] = rx_ecc[3] ^ rx_data[4]  ^ rx_data[5]  ^ rx_data[6]  ^ 
                         rx_data[7]  ^ rx_data[8]  ^ rx_data[9]  ^ rx_data[10];

    assign syndrome[4] = rx_ecc[4] ^ rx_data[11] ^ rx_data[12] ^ rx_data[13] ^ 
                         rx_data[14] ^ rx_data[15];

    // Check overall parity across all 22 bits
    assign overall_parity_check = ^rx_code_word;

    // Error Classification Logic
    assign single_error = (syndrome != 5'b00000) && overall_parity_check;
    assign double_error = (syndrome != 5'b00000) && !overall_parity_check;

    // Correct payload data based on syndrome position map
    always_comb begin
        data_out = rx_data;
        if (single_error) begin
            case (syndrome)
                5'b00011: data_out[0]  = ~rx_data[0];
                5'b00101: data_out[1]  = ~rx_data[1];
                5'b00110: data_out[2]  = ~rx_data[2];
                5'b00111: data_out[3]  = ~rx_data[3];
                5'b01001: data_out[4]  = ~rx_data[4];
                5'b01010: data_out[5]  = ~rx_data[5];
                5'b01011: data_out[6]  = ~rx_data[6];
                5'b01100: data_out[7]  = ~rx_data[7];
                5'b01101: data_out[8]  = ~rx_data[8];
                5'b01110: data_out[9]  = ~rx_data[9];
                5'b01111: data_out[10] = ~rx_data[10];
                5'b10001: data_out[11] = ~rx_data[11];
                5'b10010: data_out[12] = ~rx_data[12];
                5'b10011: data_out[13] = ~rx_data[13];
                5'b10100: data_out[14] = ~rx_data[14];
                5'b10101: data_out[15] = ~rx_data[15];
                default:  data_out     = rx_data;
            endcase
        end
    end

    // 2Z Rail Verification: Check that LSB of output remains strictly even (0)
    assign rail_fault = (data_out[0] != 1'b0);

endmodule
