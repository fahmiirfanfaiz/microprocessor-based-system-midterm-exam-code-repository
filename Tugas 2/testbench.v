`include "ALU.v"
`include "DataMemory.v"
`include "MainControl.v"
`include "RegisterFile.v"
`include "Mux2.v"
`include "Mux3.v"
`include "ALUControl.v"

`timescale 1ns / 1ps

module testbench;
    // Inputs
    reg clock;
    reg [5:0] Opcode;
    reg [3:0] ALUCtl;
    reg [4:0] ReadReg1, ReadReg2, WriteReg;
    reg [31:0] Immediate;
    
    // Outputs
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] ALUOut;
    wire Zero;
    reg RegWrite;
    wire [31:0] WriteData;
    
    // DataMemory signals
    reg MemWrite_data;
    reg MemRead_data;
    reg [6:0] address_data;
    wire [31:0] ReadData_data;
    
    // Mux untuk immediate value
    wire [31:0] B_input;
    Mux2 mux_imm(
        .ALUSrc(Opcode[5]),       // Kontrol immediate
        .ReadData2(ReadData2),
        .Extend32(Immediate),
        .ALU_B(B_input)
    );
    
    // Koneksi ALU ke Register File
    assign WriteData = ALUOut;
    
    // Instantiate modules
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
    
    ALU alu(
        .ALUCtl(ALUCtl),
        .A(ReadData1),
        .B(B_input),
        .ALUOut(ALUOut),
        .Zero(Zero)
    );
    
    DataMemory data_mem(
        .clock(clock),
        .address(address_data),
        .MemWrite(MemWrite_data),
        .MemRead(MemRead_data),
        .WriteData(WriteData),
        .ReadData(ReadData_data)
    );

    // Clock Generation (10ns period)
    always #5 clock = ~clock;
    
    // Test Sequence
    initial begin
        clock = 0;
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
        
        // Initialize control signals
        RegWrite = 1;
        ALUCtl = 4'b0010; // ADD operation
        Opcode = 6'b100000; // Immediate mode
        
        $display("\n=== Simulasi Dimulai ===");
        $display("Time(ns)\tOperation\t\tResult");
        $display("-----------------------------------------");
        
        // Load NIU 520563 ke register menggunakan immediate
        // -------------------------------------------------
        // Load $1 = 5
        Immediate = 32'd5; 
        ReadReg1 = 0;   // Baca register $0 (nilai 0)
        ReadReg2 = 0;   // Tidak digunakan
        WriteReg = 1;   // Tulis ke $1
        #10; // Tunggu 1 clock cycle
        $display("%8t\tLI $1 = %0d", $time, reg_file.reg_mem[1]);
        
        // Load $2 = 2
        Immediate = 32'd2;
        WriteReg = 2;
        #10;
        $display("%8t\tLI $2 = %0d", $time, reg_file.reg_mem[2]);
        
        // Load $3 = 0
        Immediate = 32'd0;
        WriteReg = 3;
        #10;
        $display("%8t\tLI $3 = %0d", $time, reg_file.reg_mem[3]);
        
        // Load $4 = 5
        Immediate = 32'd5;
        WriteReg = 4;
        #10;
        $display("%8t\tLI $4 = %0d", $time, reg_file.reg_mem[4]);
        
        // Load $5 = 6
        Immediate = 32'd6;
        WriteReg = 5;
        #10;
        $display("%8t\tLI $5 = %0d", $time, reg_file.reg_mem[5]);
        
        // Load $6 = 3
        Immediate = 32'd3;
        WriteReg = 6;
        #10;
        $display("%8t\tLI $6 = %0d\n", $time, reg_file.reg_mem[6]);
        
        // Proses penjumlahan (R-type)
        Opcode = 6'b000000; // Non-immediate mode
        // -------------------------------------------------
        // $1 + $2 = $7
        ReadReg1 = 1; ReadReg2 = 2; WriteReg = 7;
        #10 $display("%8t\tADD $1 + $2\t\t$7 = %0d", $time, ALUOut);
        
        // $7 + $3 = $8
        ReadReg1 = 7; ReadReg2 = 3; WriteReg = 8;
        #10 $display("%8t\tADD $7 + $3\t\t$8 = %0d", $time, ALUOut);
        
        // $8 + $4 = $9
        ReadReg1 = 8; ReadReg2 = 4; WriteReg = 9;
        #10 $display("%8t\tADD $8 + $4\t\t$9 = %0d", $time, ALUOut);
        
        // $9 + $5 = $10
        ReadReg1 = 9; ReadReg2 = 5; WriteReg = 10;
        #10 $display("%8t\tADD $9 + $5\t\t$10 = %0d", $time, ALUOut);
        
        // $10 + $6 = $31
        ReadReg1 = 10; ReadReg2 = 6; WriteReg = 31;
        #10 $display("%8t\tADD $10 + $6\t\t$31 = %0d\n", $time, ALUOut);
        
        // Simpan ke Data Memory
        MemWrite_data = 1;
        address_data = 0;

        ReadReg1 = 31; // Baca register 31
        ReadReg2 = 0;  // Tidak digunakan
        ALUCtl = 4'b0010;
        #10;
        $display("%8t\tDataMemory[0] = %0d (Dari Register $31)", $time, data_mem.Mem[0]);
        $display("%8t\tRegister $31 = %0d", $time, data_mem.Mem[0]);

        // Finish
        #10 $display("-----------------------------------------");
        $display("=== Simulasi Selesai ===");
        $finish;
    end
endmodule