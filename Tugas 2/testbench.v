// Include semua modul eksternal yang dibutuhkan dalam simulasi
`include "ALU.v"
`include "DataMemory.v"
`include "MainControl.v"
`include "RegisterFile.v"
`include "Mux2.v"
`include "Mux3.v"
`include "ALUControl.v"

// Definisikan time scale untuk simulasi: 1 ns step dan 1 ps precision
`timescale 1ns / 1ps

module testbench;
    // -------------------- [ DEFINISI INPUT UNTUK MODUL ] --------------------
    reg clock;
    reg [5:0] Opcode;               // Opcode untuk menentukan jenis instruksi
    reg [3:0] ALUCtl;               // Sinyal kontrol ALU
    reg [4:0] ReadReg1, ReadReg2;   // Register sumber
    reg [4:0] WriteReg;             // Register tujuan
    reg [31:0] Immediate;           // Nilai immediate untuk instruksi I-type
    
    // -------------------- [ OUTPUT YANG AKAN DIPANTAU ] ---------------------
    wire [31:0] ReadData1, ReadData2; // Nilai dari register file
    wire [31:0] ALUOut;               // Output dari ALU
    wire Zero;                        // Flag hasil ALU = 0
    reg RegWrite;                     // Sinyal write ke register
    wire [31:0] WriteData;            // Data yang akan ditulis ke register
    
    // -------------------- [ SIGNAL UNTUK DATA MEMORY ] ----------------------
    reg MemWrite_data;
    reg MemRead_data;
    reg [6:0] address_data;           // Alamat memori
    wire [31:0] ReadData_data;        // Data yang dibaca dari memori

    // -------------------- [ MUX UNTUK PEMILIH B_INPUT ] ---------------------
    // Jika ALUSrc = 1 (immediate mode), maka input B dari ALU adalah Immediate
    wire [31:0] B_input;
    Mux2 mux_imm(
        .ALUSrc(Opcode[5]),       // Bit 5 dari opcode digunakan untuk kontrol ALUSrc
        .ReadData2(ReadData2),    // Input dari register
        .Extend32(Immediate),     // Nilai immediate
        .ALU_B(B_input)           // Output ke input B ALU
    );

    // -------------------- [ MENGHUBUNGKAN ALU KE REGISTER FILE ] -----------
    assign WriteData = ALUOut; // Hasil ALU akan ditulis ke register file

    // -------------------- [ INSTANSIASI MODUL REGISTER FILE ] --------------
    RegFile reg_file(
        .clock(clock),
        .RegWrite(RegWrite),
        .ReadReg1(ReadReg1),
        .ReadReg2(ReadReg2),
        .WriteReg(WriteReg),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // -------------------- [ INSTANSIASI MODUL ALU ] ------------------------
    ALU alu(
        .ALUCtl(ALUCtl),
        .A(ReadData1), // Operand A dari register file
        .B(B_input),   // Operand B dari Mux2 (ReadData2 atau Immediate)
        .ALUOut(ALUOut),
        .Zero(Zero)
    );

    // -------------------- [ INSTANSIASI MODUL DATA MEMORY ] ----------------
    DataMemory data_mem(
        .clock(clock),
        .address(address_data),
        .MemWrite(MemWrite_data),
        .MemRead(MemRead_data),
        .WriteData(WriteData),
        .ReadData(ReadData_data)
    );

    // -------------------- [ GENERATOR CLOCK (frekuensi 100MHz) ] -----------
    always #5 clock = ~clock; // Clock toggle setiap 5ns => periode 10ns

    // -------------------- [ PROSES SIMULASI ] ------------------------------
    initial begin
        // Inisialisasi clock dan file output
        clock = 0;
        $dumpfile("testbench.vcd");      // File output untuk waveform
        $dumpvars(0, testbench);         // Simpan semua sinyal untuk pemantauan

        // Inisialisasi sinyal kontrol
        RegWrite = 1;                    // Aktifkan write ke register
        ALUCtl = 4'b0010;                // Operasi ADD
        Opcode = 6'b100000;             // Immediate mode (bit ke-5 = 1)

        $display("\n=== Simulasi Dimulai ===");
        $display("Time(ns)\tOperation\t\tResult");
        $display("-----------------------------------------");

        // -------------------- [ SIMULASI LOAD IMMEDIATE KE REGISTER ] -------
        // Instruksi "Load Immediate" (bukan instruksi MIPS asli) untuk mengisi register
        Immediate = 32'd5; 
        ReadReg1 = 0; ReadReg2 = 0; WriteReg = 1;
        #10; $display("%8t\tLI $1 = %0d", $time, reg_file.reg_mem[1]);

        Immediate = 32'd2; WriteReg = 2;
        #10; $display("%8t\tLI $2 = %0d", $time, reg_file.reg_mem[2]);

        Immediate = 32'd0; WriteReg = 3;
        #10; $display("%8t\tLI $3 = %0d", $time, reg_file.reg_mem[3]);

        Immediate = 32'd5; WriteReg = 4;
        #10; $display("%8t\tLI $4 = %0d", $time, reg_file.reg_mem[4]);

        Immediate = 32'd6; WriteReg = 5;
        #10; $display("%8t\tLI $5 = %0d", $time, reg_file.reg_mem[5]);

        Immediate = 32'd3; WriteReg = 6;
        #10; $display("%8t\tLI $6 = %0d\n", $time, reg_file.reg_mem[6]);

        // -------------------- [ PROSES PENJUMLAHAN (R-TYPE)] ----------------
        Opcode = 6'b000000; // R-type, bit ke-5 = 0 → gunakan ReadData2
        // ADD $1 + $2 → $7
        ReadReg1 = 1; ReadReg2 = 2; WriteReg = 7;
        #10 $display("%8t\tADD $1 + $2\t\t$7 = %0d", $time, ALUOut);

        // ADD $7 + $3 → $8
        ReadReg1 = 7; ReadReg2 = 3; WriteReg = 8;
        #10 $display("%8t\tADD $7 + $3\t\t$8 = %0d", $time, ALUOut);

        // ADD $8 + $4 → $9
        ReadReg1 = 8; ReadReg2 = 4; WriteReg = 9;
        #10 $display("%8t\tADD $8 + $4\t\t$9 = %0d", $time, ALUOut);

        // ADD $9 + $5 → $10
        ReadReg1 = 9; ReadReg2 = 5; WriteReg = 10;
        #10 $display("%8t\tADD $9 + $5\t\t$10 = %0d", $time, ALUOut);

        // ADD $10 + $6 → $31
        ReadReg1 = 10; ReadReg2 = 6; WriteReg = 31;
        #10 $display("%8t\tADD $10 + $6\t\t$31 = %0d\n", $time, ALUOut);

        // -------------------- [ SIMPAN NILAI AKHIR KE DATA MEMORY ] ---------
        MemWrite_data = 1;             // Aktifkan penulisan ke memori
        address_data = 0;              // Tulis ke alamat memori 0

        ReadReg1 = 31;                 // Ambil data dari $31
        ReadReg2 = 0; ALUCtl = 4'b0010; // ALU tetap dalam mode ADD (tidak penting di sini)
        #10;
        $display("%8t\tDataMemory[0] = %0d (Dari Register $31)", $time, data_mem.Mem[0]);
        $display("%8t\tRegister $31 = %0d", $time, data_mem.Mem[0]);

        // -------------------- [ AKHIR SIMULASI ] ----------------------------
        #10 $display("-----------------------------------------");
        $display("=== Simulasi Selesai ===");
        $finish;
    end
endmodule
