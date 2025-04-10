/* Modul Data Memory digunakan untuk menyimulasikan memori data dalam arsitektur prosesor.
 Modul ini mendukung operasi baca (read) dan tulis (write) data ke/dari memory. */
module DataMemory (clock, address, MemWrite, MemRead, WriteData, ReadData);

    // Deklarasi input
    input clock;                     // Sinyal clock sebagai pemicu operasi baca/tulis
    input [6:0] address;             // Alamat 7-bit (128 lokasi memory)
    input MemWrite, MemRead;         // Sinyal kontrol untuk operasi tulis dan baca
    input [31:0] WriteData;          // Data 32-bit yang akan ditulis ke memori
    
    // Deklarasi output
    output reg [31:0] ReadData;      // Data 32-bit hasil pembacaan dari memory

    // Deklarasi memory 128 entri, masing-masing 32 bit
    reg [31:0] Mem[0:127]; // 32-bit memory array sebanyak 128 slot

    // Blok inisialisasi awal
    initial begin
        Mem[0] = 0; // Inisialisasi alamat memori ke-0 dengan nilai 0
    end

    // Blok tulis ke memory yang dipicu oleh **sisi naik (posedge)** dari clock
    always @ (posedge clock) begin
        if (MemWrite == 1)                     // Jika sinyal MemWrite aktif
            Mem[address[6:2]] <= WriteData;    // Tulis WriteData ke alamat tertentu
                                               // address[6:2] digunakan agar word-aligned (4-byte aligned)
    end

    // Blok baca dari memory yang dipicu oleh **sisi turun (negedge)** dari clock
    always @(negedge clock) begin
        if (MemRead == 1)                      // Jika sinyal MemRead aktif
            ReadData <= Mem[address[6:2]];     // Baca data dari memory ke ReadData
    end    

endmodule
