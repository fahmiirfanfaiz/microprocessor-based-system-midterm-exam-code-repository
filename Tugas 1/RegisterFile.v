/* modul Register File adalah modul yang berfungsi untuk menyimpan dan mengelola register-register dalam arsitektur komputer.
   Register File ini memiliki 32 register, masing-masing berukuran 32-bit. Modul ini juga menyediakan fungsi untuk membaca 
   dan menulis data ke register-register tersebut. */

// Mendeklarasikan modul RegisterFile dengan input dan output yang diperlukan
module RegisterFile(clock, RegWrite, ReadReg1, ReadReg2, WriteReg, WriteData, ReadData1, ReadData2);

    // Input clock: sinyal jam untuk sinkronisasi penulisan data
    input clock;

    // Input RegWrite: sinyal kontrol penulisan. Jika 1, maka data akan ditulis ke register saat clock naik.
    input RegWrite;

    // Input ReadReg1, ReadReg2, WriteReg: alamat register untuk dibaca (read) dan ditulis (write).
    // 5-bit digunakan karena jumlah register adalah 32 (2^5 = 32)
    input [4:0] ReadReg1, ReadReg2, WriteReg;

    // Input WriteData: data 32-bit yang akan ditulis ke register WriteReg
    input [31:0] WriteData;

    // Output ReadData1 dan ReadData2: data hasil pembacaan dari register ReadReg1 dan ReadReg2
    output [31:0] ReadData1, ReadData2;

    // reg_mem adalah array 32 elemen, masing-masing 32-bit, menyimpan isi dari 32 register
    reg [31:0] reg_mem [0:31];

    // Inisialisasi awal: register 0 di-set ke 0.
    // Biasanya pada arsitektur seperti MIPS, register 0 adalah register konstan dengan nilai 0.
    initial begin
        reg_mem[0] <= 0;
    end

    // Pembacaan data dari register (operasi kombinatorial)
    // Data langsung tersedia tanpa menunggu clock
    assign ReadData1 = reg_mem[ReadReg1];
    assign ReadData2 = reg_mem[ReadReg2];

    // Penulisan data ke register (operasi sinkron terhadap rising edge clock)
    always @(posedge clock) begin
        // Jika sinyal RegWrite aktif (bernilai 1), maka lakukan penulisan
        if (RegWrite == 1)
            // Data WriteData ditulis ke register dengan alamat WriteReg
            reg_mem[WriteReg] <= WriteData;
    end

endmodule
