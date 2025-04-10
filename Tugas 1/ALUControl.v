// Modul ALUControl menentukan sinyal kontrol ALU berdasarkan nilai ALUOp dan FuncCode
module ALUControl (ALUOp, FuncCode, ALUCtrl);

    /* Mendeklarasikan input ALUOp dan FuncCode serta output ALUCtrl.
	- ALUOp : input 2-bit dari kontrol unit yang menentukan jenis operasi ALU.
	- FuncCode : input 6-bit yang berasal dari field "funct" pada instruksi R-type yang digunakan untuk menentukan operasi spesifik dalam ALU.
	- ALUCtrl : output 4-bit yang menentukan operasi ALU yang akan dilakukan.
	*/
	input [1:0] ALUOp;
	input [5:0] FuncCode;
	output reg [3:0] ALUCtrl;
	
	// always block berikut selalu dieksekusi setiap kali ada perubahan pada variabel ALUOp atau FuncCode.
	always @(ALUOp, FuncCode) begin

	/* Jika ALUOp bernilai 0 (ALUOp == 0), maka instruksi yang sedang diproses adalah LW (Load Word) atau SW (Store Word)
	dengan mengatur ALUCtrl ke 2 (yang menunjukkan operasi penjumlahan atau ADD) untuk menghitung alamat memori.
	*/
	if(ALUOp == 0)
		ALUCtrl <= 2;   // Kode operasi ALU untuk ADD.
	/* Jika ALUOp bernilai 1 (ALUOp == 1), maka instruksi yang sedang diproses adalah BEQ (Branch if Equal)
	yang menggunakan operasi pengurangan atau SUB untuk membandingkan 2 register.
	*/
	else if(ALUOp == 1)
		ALUCtrl <= 6; // Kode operasi ALU untuk SUB.

	/* Jika ALUOp bukan 1 atau 0, maka instruksi yang sedang diproses adalah instruksi R-type,
	sehingga ALUCtrl akan ditentukan berdasarkan nilai FuncCode dari instruksi else.
	*/
	else
		case(FuncCode)
			32: ALUCtrl <= 2; // FuncCode 32 (decimal) => ADD (penjumlahan)
			34: ALUCtrl <= 6; // FuncCode 34 (decimal) => SUB (pengurangan)
			36: ALUCtrl <= 0; // FuncCode 36 (decimal) => AND (logika AND)
			37: ALUCtrl <= 1; // FuncCode 37 (decimal) => OR (logika OR)
			39: ALUCtrl <= 12; // FuncCode 39 (decimal) => NOR (logika NOR)
			42: ALUCtrl <= 7; // FuncCode 42 (decimal) => SLT (set less than)
			// Default Case untuk menangani kondisi dimana FuncCode tidak dikenali (seharusnya tidak terjadi). 
			default: ALUCtrl <= 15; // Nilai 15 menunjukkan error message atau kondisi yang tidak valid
		endcase
	end
endmodule