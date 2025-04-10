/* Modul Main Control berfungsi untuk menghasilkan sinyal kontrol utama untuk prosesor,
berdasarkan nilai Opcode dari instruksi yang sedang dijalankan. */
module MainControl(
	input [5:0] Opcode, // Input 6-bit Opcode dari instruksi
	
	// Output sinyal kontrol yang akan digunakan oleh komponen lain
	output reg RegDst, RegWrite, ALUSrc,
	output reg MemtoReg, MemRead, MemWrite,
	output reg Branch,
	output reg [1:0] ALUOp // Output 2-bit ALUOp yang akan digunakan oleh ALU Control
);

	/* Blok always dengan sensitivitas ke semua sinyal (*),
	berarti blok ini akan dieksekusi ulang setiap kali ada perubahan nilai sinyal input. */
	always @(*) begin
		// Pemilihan sinyal kontrol berdasarkan nilai Opcode
		case(Opcode)
			// R-type instruction (Opcode = 0)
			0: begin
				RegDst 		<= 1;		// Tujuan register ditentukan oleh field rd
				ALUSrc 		<= 0;		// Operan kedua ALU berasal dari register, bukan immediate
				MemtoReg	<= 0;		// Data yang ditulis ke register berasal dari ALU, bukan dari memory
				RegWrite	<= 1;		// Aktifkan penulisan ke register
				MemRead		<= 0;		// Tidak membaca dari memory
				MemWrite	<= 0;		// Tidak menulis ke memory
				Branch		<= 0;		// Bukan instruksi branch
				ALUOp		<= 2'b10;	// Kode ALU untuk R-type (akan dikontrol oleh funct)
			end
			
			// LW (Load Word, Opcode = 35)
			35: begin
				RegDst 		<= 0;		// Tujuan register adalah rt
				ALUSrc 		<= 1;		// Operan kedua ALU berasal dari immediate
				MemtoReg	<= 1;		// Data yang ditulis ke register berasal dari memory
				RegWrite	<= 1;		// Aktifkan penulisan ke register
				MemRead		<= 1;		// Aktifkan pembacaan dari memory
				MemWrite	<= 0;		// Tidak menulis ke memory
				Branch		<= 0;		// Bukan instruksi branch
				ALUOp		<= 2'b00;	// Kode ALU untuk operasi penjumlahan (digunakan untuk address calculation)
			end

			// SW (Store Word, Opcode = 43)
			43: begin
				RegDst 		<= 0;		// Tidak digunakan
				ALUSrc 		<= 1;		// Operan kedua ALU berasal dari immediate
				MemtoReg	<= 0;		// Tidak digunakan
				RegWrite	<= 0;		// Tidak menulis ke register
				MemRead		<= 0;		// Tidak membaca dari memory
				MemWrite	<= 1;		// Aktifkan penulisan ke memory
				Branch		<= 0;		// Bukan instruksi branch
				ALUOp		<= 2'b00;	// Kode ALU untuk penjumlahan (digunakan untuk address calculation)
			end

			// BEQ (Branch if Equal, Opcode = 4)
			4: begin
				RegDst 		<= 0;		// Tidak digunakan
				ALUSrc 		<= 0;		// Operan kedua ALU berasal dari register
				MemtoReg	<= 0;		// Tidak digunakan
				RegWrite	<= 0;		// Tidak menulis ke register
				MemRead		<= 0;		// Tidak membaca dari memory
				MemWrite	<= 0;		// Tidak menulis ke memory
				Branch		<= 1;		// Aktifkan branching
				ALUOp		<= 2'b01;	// Kode ALU untuk operasi pengurangan (digunakan untuk membandingkan kesamaan)
			end
		endcase
	end
endmodule
