/* Modul ALU (Arithmetic Logic Unit) berikut menerima dua input data 32-bit (A dan B) dan sinyal kontrol ALUCtrl 
untuk menentukan operasi yang akan dilakukan. Hasil operasi disimpan dalam variabel ALUOut, dan terdapat output Zero 
yang bernilai 1 jika ALUOut bernilai 0 (ALUOut == 0), dan bernilai 0 jika ALUOut tidak bernilai 0 (ALUOut != 0). */

// Mendeklarasikan module ALU dengan input dan output yang diperlukan
module ALU (ALUCtrl, A, B, ALUOut, Zero);

/* Mendeklarasikan input ALUCtrl, A, dan B.
- ALUCtrl : input sinyal kontrol 4-bit yang menentukan operasi ALU
- A, B : input 2 operand yang berukuran 32-bit.
*/
	input [3:0] ALUCtrl;
	input [31:0] A,B;

/* Mendeklarasikan output ALUOut dan Zero.
- ALUOut : output hasil operasi ALU yang berukuran 32-bit
- Zero : sinyal output yang menunjukkan apakah hasil operasi ALU bernilai 0 atau tidak.
*/
	output reg [31:0] ALUOut;
	output Zero;
	assign Zero = (ALUOut == 0);

// Proses ALU dieksekusi setiap kali ada perubahan nilai pada variabel input ALUCtrl, A, atau B.
	always @(ALUCtrl, A, B) begin
		// Menggunakan statement case untuk menentukan operasi ALU berdasarkan nilai ALUCtrl.
		case (ALUCtrl)
		0: ALUOut <= A & B;		  // Operasi AND bitwise antara A dan B.
		1: ALUOut <= A | B;		  // Operasi OR bitwise antara A dan B.
		2: ALUOut <= A + B;		  // Operasi penjumlahan A + B.
		6: ALUOut <= A - B;		  // Operasi pengurangan A - B.
		7: ALUOut <= A < B ? 1:0; // Operasi perbandingan: Jika A < B, hasilnya 1, jika tidak 0.
		12: ALUOut <= ~(A | B);   // Operasi NOR bitwise (negasi dari OR).
		default: ALUOut <= 0;     // Default: Jika tidak ada kode yang cocok, hasil ALUOut adalah 0.
		endcase
	end
endmodule