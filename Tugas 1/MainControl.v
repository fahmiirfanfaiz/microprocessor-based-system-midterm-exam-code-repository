/* Modul Main Control berfungsi untuk menghasilkan sinyal kontrol berdasarkan nilai opcode melalui seleksi case-statement 
dari instruksi yang sedang diproses. */
module MainControl(
	// Mendeklarasikan variabel input Opcode dan variabel output RegDst, RegWrite, ALUSrc, MemtoReg, MemRead, MemWrite, Branch, ALUOp untuk sinyal kontrol
	input [5:0] Opcode, // Variabel input 6-bit untuk kode operasi dari instruksi (Opcode).

	// Mendeklarasikan output dari Main Control Unit yang berupa sinyal-sinyal kontrol 
	output reg RegDst,      // Menentukan register tujuan: 1 untuk R-type, sedangkan 0 untuk I-type
	output reg RegWrite,    // Mengaktifkan penulisan ke register
	output reg ALUSrc,      // Menentukan sumber operand kedua ALU: 1 untuk immediate, sedangkan 0 untuk register
	output reg MemtoReg,    // Menentukan sumber data untuk ditulis ke register: 1 dari memory, sedangkan 0 dari ALU
	output reg MemRead,     // Mengaktifkan pembacaan data dari memory
	output reg MemWrite,    // Mengaktifkan penulisan data ke memory
	output reg Branch,      // Mengaktifkan cabang (branch), jika hasil ALU = 0
	output reg [1:0] ALUOp  // Menentukan operasi ALU (dikodekan), digunakan oleh ALU Control
);

// Mendeklarasikan blok kode always yang sensitif terhadap semua perubahan sinyal (combinational logic)
always @(*) begin
	case(Opcode)
		0: begin // Opcode 0: R-type instructions (misal: ADD, SUB, AND, OR, SLT)
			RegDst    <= 1;        // Register tujuan dari field rd (R-type)
			ALUSrc    <= 0;        // Operand kedua berasal dari register
			MemtoReg  <= 0;        // Data untuk register berasal dari output ALU
			RegWrite  <= 1;        // Aktifkan penulisan ke register
			MemRead   <= 0;        // Tidak membaca dari memory
			MemWrite  <= 0;        // Tidak menulis ke memory
			Branch    <= 0;        // Tidak melakukan percabangan
			ALUOp     <= 2'b10;    // Operasi ditentukan oleh instruksi fungsi ALU (function field)
		end

		35: begin // Opcode 35 (decimal): instruksi LW (Load Word)
			RegDst    <= 0;        // Register tujuan dari field rt (I-type)
			ALUSrc    <= 1;        // Operand kedua berasal dari immediate (offset)
			MemtoReg  <= 1;        // Data untuk register berasal dari memory
			RegWrite  <= 1;        // Aktifkan penulisan ke register
			MemRead   <= 1;        // Aktifkan pembacaan dari memory
			MemWrite  <= 0;        // Tidak menulis ke memory
			Branch    <= 0;        // Tidak melakukan percabangan
			ALUOp     <= 2'b00;    // ALU digunakan untuk penjumlahan (menentukan alamat memory)
		end

		43: begin // Opcode 43 (decimal): instruksi SW (Store Word)
			RegDst    <= 0;        // Tidak digunakan karena tidak ada penulisan ke register
			ALUSrc    <= 1;        // Operand kedua berasal dari immediate (offset)
			MemtoReg  <= 0;        // Tidak digunakan karena tidak ada penulisan ke register
			RegWrite  <= 0;        // Tidak menulis ke register
			MemRead   <= 0;        // Tidak membaca dari memory
			MemWrite  <= 1;        // Aktifkan penulisan ke memory
			Branch    <= 0;        // Tidak melakukan percabangan
			ALUOp     <= 2'b00;    // ALU digunakan untuk penjumlahan (menentukan alamat memory)
		end

		4: begin // Opcode 4 (decimal): instruksi BEQ (Branch if Equal)
			RegDst    <= 0;        // Tidak digunakan
			ALUSrc    <= 0;        // Operand kedua berasal dari register
			MemtoReg  <= 0;        // Tidak digunakan
			RegWrite  <= 0;        // Tidak menulis ke register
			MemRead   <= 0;        // Tidak membaca dari memory
			MemWrite  <= 0;        // Tidak menulis ke memory
			Branch    <= 1;        // Aktifkan sinyal branch
			ALUOp     <= 2'b01;    // ALU digunakan untuk pengurangan (membandingkan dua register)
		end

		// Jika Opcode tidak dikenali, maka sinyal kontrol tetap tidak berubah.
		// Bisa juga ditambahkan default block untuk menginisialisasi semua sinyal ke 0.
	endcase
end

endmodule
