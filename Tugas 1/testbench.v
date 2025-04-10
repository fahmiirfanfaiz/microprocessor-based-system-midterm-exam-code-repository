`include "ALU.v"              // Menyertakan file ALU untuk operasi aritmatika dan logika
`include "DataMemory.v"       // Menyertakan file DataMemory untuk simulasi memori data
`include "MainControl.v"      // Menyertakan file MainControl untuk mengatur sinyal kontrol
`include "RegisterFile.v"     // Menyertakan file RegisterFile untuk menyimpan dan membaca register
`include "Mux2.v"             // Menyertakan file Mux2 untuk memilih antara ReadData2 dan Extend32
`include "Mux3.v"             // Menyertakan file Mux3 untuk memilih data yang akan ditulis ke register
`include "ALUControl.v"       // Menyertakan file ALUControl untuk menentukan operasi ALU

`timescale 1ns / 1ps          // Menentukan satuan waktu simulasi (1 nanosecond) dan presisi (1 picosecond)

module testbench;

    // Deklarasi input berupa register
    reg clock;                                // Sinyal clock
    reg [5:0] Opcode;                         // Opcode instruksi
    reg [3:0] ALUCtrl;                        // Sinyal kontrol untuk ALU
    reg [4:0] ReadReg1, ReadReg2, WriteReg;   // Register sumber dan tujuan
    reg [6:0] MemAddress;                     // Alamat untuk akses memori
    reg [31:0] Extend32;                      // Nilai immediate yang telah diperluas

    // Deklarasi output berupa wire
    wire [31:0] ReadData1, ReadData2;         // Data hasil pembacaan dari register
    wire [31:0] ALUOut;                       // Hasil operasi ALU
    wire Zero;                                // Sinyal zero dari ALU
    wire RegDst, RegWrite, ALUSrc, MemtoReg, Branch; // Sinyal kontrol utama
    wire [1:0] ALUOp;                         // Sinyal operasi ALU dari MainControl
    wire [31:0] MemReadData;                  // Data yang dibaca dari memori
    wire MemWrite, MemRead;                   // Sinyal kontrol memori
    wire [31:0] WriteData;                    // Data yang akan ditulis ke register
    wire [31:0] ALU_B;                        // Operand kedua untuk ALU

    // Instansiasi modul MainControl
    MainControl main_ctrl(
        .Opcode(Opcode),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    // Instansiasi modul RegisterFile
    RegisterFile reg_file(
        .clock(clock),
        .RegWrite(RegWrite),
        .ReadReg1(ReadReg1),
        .ReadReg2(ReadReg2),
        .WriteReg(WriteReg),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // Instansiasi modul ALU
    ALU alu(
        .ALUCtrl(ALUCtrl),
        .A(ReadData1),
        .B(ReadData2),
        .ALUOut(ALUOut),
        .Zero(Zero)
    );

    // Instansiasi modul DataMemory
    DataMemory data_mem(
        .clock(clock),
        .address(MemAddress),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .WriteData(WriteData),
        .ReadData(MemReadData)
    );

    // Instansiasi Mux2 untuk memilih input kedua ALU
    Mux2 mux2(
        .ALUSrc(ALUSrc), 
        .ReadData2(ReadData2), 
        .Extend32(Extend32), 
        .ALU_B(ALU_B)
    );

    // Instansiasi Mux3 untuk memilih data yang ditulis ke register
    Mux3 mux3(
        .ReadData(MemReadData), 
        .ALUOut(ALUOut), 
        .MemtoReg(MemtoReg), 
        .WriteData(WriteData)
    );

    // Membalik sinyal clock setiap 5ns (periode clock = 10ns)
    always #5 clock = ~clock;

    // Blok utama untuk test case
    initial begin
        clock = 0;              // Inisialisasi clock
        Opcode = 6'b000000;     // Opcode default
        ALUCtrl = 4'b0000;      // Operasi ALU default
        ReadReg1 = 0;
        ReadReg2 = 0;
        WriteReg = 0;
        MemAddress = 0;
        Extend32 = 0;

        $dumpfile("testbench.vcd");   // File output VCD untuk waveform
        $dumpvars(0, testbench);      // Menyimpan semua variabel dalam testbench

        // Inisialisasi isi register
        reg_file.reg_mem[1] = 32'd20; // Register 1 diisi dengan 20
        reg_file.reg_mem[2] = 32'd15; // Register 2 diisi dengan 15

        // Menampilkan nilai awal register
        $display("Initial Register Values:");
        $display("Register 1: %2d", reg_file.reg_mem[1]);
        $display("Register 2: %2d", reg_file.reg_mem[2]);

        // Monitoring output selama simulasi berjalan
        $monitor("Time: %0d | ReadData1: %b | ReadData2: %b | ALU Result: %b | RegWrite: %b | MemWrite: %b | MemRead: %b | ALU Ctrl: %b", 
                 $time, ReadData1, ReadData2, ALUOut, RegWrite, MemWrite, MemRead, ALUCtrl);

        // Test 1: SUB (sub $3, $1, $2)
        ReadReg1 = 5'd1;         // Mengakses register 1
        ReadReg2 = 5'd2;         // Mengakses register 2
        WriteReg = 5'd3;         // Hasil akan ditulis ke register 3
        ALUCtrl = 4'b0110;       // Operasi SUB
        #10;                     // Tunggu 10ns

        // Tampilkan hasil SUB di register 3
        $display("After SUB Operation: Register 3 = %2d ", reg_file.reg_mem[3]);

        // Test 2: OR (or $4, $1, $2)
        ReadReg1 = 5'd1;         // Mengakses register 1
        ReadReg2 = 5'd2;         // Mengakses register 2
        WriteReg = 5'd4;         // Hasil akan ditulis ke register 4
        ALUCtrl = 4'b0001;       // Operasi OR
        #10;                     // Tunggu 10ns

        // Tampilkan hasil OR di register 4
        $display("After OR Operation: Register 4 = %2d", reg_file.reg_mem[4]);

        $finish;                 // Akhiri simulasi
    end
endmodule
