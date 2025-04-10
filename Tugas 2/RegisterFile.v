// Modul RegFile adalah implementasi 32 general-purpose register (32-bit) Register File seperti pada arsitektur prosesor MIPS
module RegFile(
    input clock,                 // Sinyal clock untuk sinkronisasi penulisan data
    input RegWrite,              // Sinyal kontrol: aktif (1) jika ingin menulis ke register
    input [4:0] ReadReg1,        // Alamat register pertama untuk dibaca (5-bit = 32 register)
    input [4:0] ReadReg2,        // Alamat register kedua untuk dibaca
    input [4:0] WriteReg,        // Alamat register tujuan penulisan data
    input [31:0] WriteData,      // Data yang akan ditulis ke register
    output [31:0] ReadData1,     // Data hasil pembacaan dari ReadReg1
    output [31:0] ReadData2      // Data hasil pembacaan dari ReadReg2
);

    // Deklarasi array reg 32 elemen, masing-masing 32-bit yang merepresentasikan 32 register
    reg [31:0] reg_mem [0:31];

    /* Inisialisasi awal : register ke-0 di-set ke 0 sesuai konvensi MIPS 
    Register 0 bersifat konstan dan tidak boleh berubah */
    initial reg_mem[0] = 0;

    /* Blok pembacaan register : asynchronous (tidak tergantung clock)
       Jika register yang dibaca adalah R0 (index 0), maka hasil pembacaannya selalu 0.
       Selain itu, data diambil langsung dari array reg_mem */
    assign ReadData1 = (ReadReg1 == 0) ? 0 : reg_mem[ReadReg1];
    assign ReadData2 = (ReadReg2 == 0) ? 0 : reg_mem[ReadReg2];

    /* Blok penulisan register : synchronous (bergantung pada clock)
       Penulisan hanya terjadi saat sinyal RegWrite aktif (1)
       dan alamat register tujuan bukan R0 (WriteReg != 0),
       untuk menjaga agar register 0 tetap tidak bisa ditulis */
    always @(posedge clock) begin
        if(RegWrite && (WriteReg != 0)) begin
            reg_mem[WriteReg] <= WriteData;  // Menulis data ke register tujuan
        end
    end

endmodule
