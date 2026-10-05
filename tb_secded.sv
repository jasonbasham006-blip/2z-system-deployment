module tb_secded;
    logic [15:0] data_in;
    logic [21:0] rx_code_word;
    logic [5:0]  ecc_gen;
    logic [15:0] data_out;
    logic        single_error, double_error, rail_fault;

    secded_2z dut (
        .data_in(data_in),
        .rx_code_word(rx_code_word),
        .ecc_gen(ecc_gen),
        .data_out(data_out),
        .single_error(single_error),
        .double_error(double_error),
        .rail_fault(rail_fault)
    );

    initial begin
        $display("--- STARTING SECDED 2Z HARDWARE VERIFICATION ---");
        // Test Case 1: Pure 2Z even word (306)
        data_in = 16'd306;
        #10;
        $display("[ENC] Input 2Z Word: %d | ECC Generated: %b", data_in, ecc_gen);

        // Test Case 2: Inject Single Bit Fault at Payload Bit 4
        rx_code_word = {ecc_gen, data_in} ^ (22'b1 << 4);
        #10;
        $display("[DEC-FAULT1] Injected 1-Bit Fault | Single Err Flag: %b | Corrected Output: %d", 
                 single_error, data_out);

        if (data_out == 16'd306)
            $display("[PASS] SECDED Corrected 1-Bit Fault Successfully.");
        else
            $display("[FAIL] SECDED Failed 1-Bit Correction.");

        $display("--- SECDED VERIFICATION COMPLETE ---");
        $finish;
    end
endmodule
