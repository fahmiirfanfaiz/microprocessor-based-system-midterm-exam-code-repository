// Modul Mux2 adalah modul Multiplexer 2 input yang memilih antara ReadData2 dan Extend32
module Mux2(
    // Mendeklarasikan input ALUSrc, ReadData2, dan Extend32 serta output ALU_B
    input ALUSrc,                // Sinyal kontrol untuk memilih input ke ALU_B
    input [31:0] ReadData2,      // Input pertama dari register file (biasanya operand kedua)
    input [31:0] Extend32,       // Input kedua hasil sign-extend immediate
    output reg [31:0] ALU_B      // Output yang akan digunakan sebagai input kedua ALU
);

    // Mendeklarasikan always block yang sensitif terhadap perubahan sinyal apa pun (*)
    always @(*) begin
        // Gunakan case untuk memilih input berdasarkan nilai ALUSrc
        case(ALUSrc)
            0: ALU_B = ReadData2;  // Jika ALUSrc = 0, gunakan data dari register (ReadData2)
            1: ALU_B = Extend32;   // Jika ALUSrc = 1, gunakan immediate yang sudah diperluas (Extend32)
        endcase
    end

endmodule
