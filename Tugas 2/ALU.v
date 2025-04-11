/* Modul ALU : Arithmetic Logic Unit 32-bit yang
   menerima dua input data 32-bit dan satu sinyal kontrol ALU untuk menentukan operasi */
module ALU (
    ALUCtl,   // Sinyal kontrol 4-bit yang menentukan jenis operasi ALU
    A,        // Operand pertama (input 32-bit)
    B,        // Operand kedua (input 32-bit)
    ALUOut,   // Output hasil operasi ALU
    Zero      // Output 1-bit, bernilai 1 jika hasil ALU adalah nol
);

// -------------------- [ INPUT ] ----------------------

// Input sinyal kontrol ALU 4-bit: menentukan operasi logika/arithmetic
input [3:0] ALUCtl;

// Dua input 32-bit: biasanya data dari register file
input [31:0] A, B;

// -------------------- [ OUTPUT ] ----------------------

// Output hasil ALU bertipe reg 32-bit
output reg [31:0] ALUOut;

// Output sinyal Zero: bernilai 1 jika hasil operasi ALU adalah nol
output Zero;

/* Penugasan langsung (combinational assignment) untuk sinyal Zero
   Jika hasil ALU (ALUOut) adalah nol, maka Zero = 1, sebaliknya Zero = 0 */
assign Zero = (ALUOut == 0);

// -------------------- [ LOGIKA OPERASI ALU ] ----------------------

/* Blok always dijalankan saat terjadi perubahan pada ALUCtl, A, atau B
   Menentukan hasil ALUOut berdasarkan sinyal kontrol ALUCtl */
always @(ALUCtl, A, B) begin
    case (ALUCtl)
        4'b0000: ALUOut <= A & B;             // Operasi AND bitwise
        4'b0001: ALUOut <= A | B;             // Operasi OR bitwise
        4'b0010: ALUOut <= A + B;             // Penjumlahan (ADD)
        4'b0110: ALUOut <= A - B;             // Pengurangan (SUB)
        4'b0111: ALUOut <= (A < B) ? 1 : 0;   // Operasi Set on Less Than (SLT): jika A < B, hasil 1, else 0
        4'b1100: ALUOut <= ~(A | B);          // Operasi NOR bitwise (negasi dari OR)
        
        // Default: jika ALUCtl tidak dikenali, maka hasilkan 0
        default: ALUOut <= 0;
    endcase
end

endmodule
