/* Modul Mux2 adalah modul multiplexer 2 input untuk memilih operand kedua ALU (ALU_B).
   Pilihan ditentukan berdasarkan sinyal kontrol ALUSrc : 
   - Jika ALUSrc = 0 => gunakan data register (ReadData2)
   - Jika ALUSrc = 1 => gunakan immediate (Extend32) */

module Mux2 (
	ALUSrc,        // Sinyal Kontrol: memilih antara data register atau immediate.
	ReadData2,     // Data dari register sumber kedua (rs atau rt).
	Extend32,      // Hasil sign-extend dari immediate (16-bit menjadi 32-bit).
	ALU_B          // Output : operand kedua untuk ALU
);

// Mendeklarasikan input ALUSrc, ReadData2, Extend32 dan output ALU_B
	input ALUSrc;               // Input ALUSrc 1-bit sebagai sinyal kontrol mux
	input [31:0] ReadData2;     // Input ReadData32 32-bit dari register file (operand kedua jika R-type)
	input [31:0] Extend32;      // Input Extend32 32-bit hasil sign-extension (operand kedua jika I-type)
	
	output reg [31:0] ALU_B;    // Output ALU_B 32-bit : operand kedua yang dipilih untuk ALU
	
	// Mendeklarasikan blok kode always yang dipicu saat ada perubahan pada ALUSrc, ReadData2, atau Extend32
	always @(ALUSrc, ReadData2, Extend32) begin
		case (ALUSrc)
			1'b0: ALU_B <= ReadData2;   // Jika ALUSrc = 0 => operand kedua berasal dari register
			1'b1: ALU_B <= Extend32;    // Jika ALUSrc = 1 => operand kedua berasal dari immediate
		endcase
	end
endmodule
