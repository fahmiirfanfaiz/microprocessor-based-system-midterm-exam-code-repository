/* Modul ALUControl menentukan sinyal kontrol untuk ALU berdasarkan nilai ALUOp dan FuncCode.
   Modul ini biasanya digunakan dalam datapath arsitektur prosesor MIPS untuk instruksi R-type dan lainnya */
module ALUControl (ALUOp, FuncCode, ALUCtl);

    // ALUOp adalah sinyal kontrol 2-bit dari unit kontrol utama yang menunjukkan jenis operasi
    input [1:0] ALUOp;

    // FuncCode adalah kode fungsi dari field "funct" pada instruksi R-type (6-bit)
    input [5:0] FuncCode;

    /* ALUCtl adalah sinyal kontrol output ke ALU untuk menentukan operasi apa yang akan dilakukan.
       Output 4-bit ini bisa bernilai kode seperti 0000 (AND), 0010 (ADD), 0110 (SUB), dsb. */
    output reg [3:0] ALUCtl;

    // Blok always akan mengevaluasi ulang ketika nilai ALUOp atau FuncCode berubah
    always @(ALUOp, FuncCode) begin

        /* Jika ALUOp = 00 => instruksi adalah LW atau SW, maka
           ALU harus melakukan penjumlahan (untuk menghitung alamat: base + offset) */
        if(ALUOp == 2'b00)
            ALUCtl <= 4'b0010;  // Kode 2: ADD

        /* Jika ALUOp = 01 => instruksi adalah BEQ, maka
           ALU harus melakukan pengurangan untuk membandingkan apakah dua register sama */
        else if(ALUOp == 2'b01)
            ALUCtl <= 4'b0110;  // Kode 6: SUB

        /* Jika ALUOp = 10 => instruksi adalah R-type,
           maka operasi ditentukan oleh field funct (FuncCode) */
        else begin
            case(FuncCode)
                6'd32: ALUCtl <= 4'b0010; // ADD  (funct = 32) => kode ALU 2
                6'd34: ALUCtl <= 4'b0110; // SUB  (funct = 34) => kode ALU 6
                6'd36: ALUCtl <= 4'b0000; // AND  (funct = 36) => kode ALU 0
                6'd37: ALUCtl <= 4'b0001; // OR   (funct = 37) => kode ALU 1
                6'd39: ALUCtl <= 4'b1100; // NOR  (funct = 39) => kode ALU 12
                6'd42: ALUCtl <= 4'b0111; // SLT  (funct = 42) => kode ALU 7
                default: ALUCtl <= 4'b1111; // nilai default jika FuncCode tidak dikenali (error)
            endcase
        end
    end

endmodule
