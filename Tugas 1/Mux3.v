/* Modul Mux3 berfungsi sebagai multiplexer 2 input yang memilih data yang akan ditulis ke register tujuan (WriteData), 
berdasarkan sinyal kontrol MemtoReg.
- Jika MemtoReg = 0 => data berasal dari hasil ALU (ALUOut)
- Jika MemtoReg = 1 => data berasal dari memori (ReadData) */

// Mendeklarasikan modul Mux3 untuk memilih antara data dari memori atau data hasil ALU
module Mux3 (
	ReadData,    // Data hasil pembacaan dari memori (output dari memory)
	ALUOut,      // Data hasil operasi dari ALU
	MemtoReg,    // Sinyal kontrol untuk memilih sumber data yang akan ditulis ke register
	WriteData    // Output : data akhir yang akan ditulis ke register tujuan
);

	// Mendeklarasikan input ReadData dan ALUOut 32-bit dan input MemtoReg 1-bit
	input [31:0] ReadData;     // Input : data 32-bit dari memory (hasil Load Word)
	input [31:0] ALUOut;       // Input : data 32-bit dari ALU (hasil operasi aritmatika/logika)
	input MemtoReg;            // Input 1-bit sinyal kontrol dari MainControl
	
	// Mendeklarasikan output WriteData 32-bit
	output reg [31:0] WriteData; // Output : data 32-bit yang akan ditulis ke Register File
	
	// Mendeklarasikan blok kode always sensitif terhadap semua perubahan sinyal (combinational logic)
	always @(*) begin
		case (MemtoReg)
			1'b0: WriteData <= ALUOut;    // Jika MemtoReg = 0 => tulis hasil dari ALU ke register
			1'b1: WriteData <= ReadData;  // Jika MemtoReg = 1 => tulis data dari memori ke register
		endcase
	end
endmodule
