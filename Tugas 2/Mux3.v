// Modul bernama Mux3 adalah modul multiplexer 2 ke 1 dengan lebar data 32-bit
module Mux3 (
    ReadData,    // Input data dari memori (biasanya hasil pembacaan dari data memory)
    ALUOut,      // Input data dari ALU (hasil operasi aritmatika / logika)
    MemtoReg,    // Sinyal kontrol untuk memilih antara ReadData atau ALUOut
    WriteData    // Output yang akan ditulis ke register
);

// Input 32-bit : ReadData dari memory dan ALUOut dari ALU
input [31:0] ReadData, ALUOut;

// Input kontrol 1-bit : MemtoReg menentukan sumber data yang dipilih
input MemtoReg;

// Output 32-bit bertipe reg : WriteData adalah data akhir yang akan ditulis ke register file
output reg [31:0] WriteData;

// Blok always dengan sensitivitas terhadap semua sinyal (* berarti semua input dipantau)
// Digunakan untuk mendeskripsikan perilaku multiplexer secara combinational (tanpa clock)
always @(*) begin
    // Pemilihan nilai WriteData berdasarkan nilai MemtoReg
    case (MemtoReg)
        0: WriteData <= ALUOut;    // Jika MemtoReg = 0, pilih output dari ALU
        1: WriteData <= ReadData;  // Jika MemtoReg = 1, pilih output dari memory (ReadData)
    endcase
end

endmodule
