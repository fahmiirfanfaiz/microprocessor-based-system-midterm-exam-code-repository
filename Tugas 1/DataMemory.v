/* Modul Data Memory berfungsi sebagai memori data yang digunakan dalam prosesor untuk membaca dan menulis data 
dari atau ke memori berdasarkan sinyal kontrol MemRead dan MemWrite. */
module DataMemory (clock, address, MemWrite, MemRead, WriteData, ReadData);

/* Mendeklarasikan input clock, address, MemWrite, MemRead, WriteData dan output ReadData
 - clock : sinyal clock yang mengatur kapan memori dibaca / ditulis.
 - address : alamat memori 7-bit yang mengacu pada lokasi data di memori.
 - MemWrite : sinyal kontrol untuk menulis data ke memori.
 - MemRead : sinyal kontrol untuk membaca data dari memori.
 - WriteData : data 32-bit yang akan ditulis ke memori jika MemWrite aktif (MemWrite = 1).
 - ReadData : data 32-bit yang dibaca dari memori jika MemRead aktif (MemRead = 1).
*/
	input clock;
	input [6:0] address;
	input MemWrite, MemRead;
	input [31:0] WriteData; 
	output reg [31:0] ReadData; // output register 32-bit untuk menyimpan hasil pembacaan dari memori.

/* Mendeklarasikan array "Mem" sebagai memori dengan 128 lokasi (dari indeks 0 hingga 127), 
di mana setiap lokasi menyimpan data sebesar 32-bit.
*/
	reg [31:0] Mem[0:127]; 

// Menginisialisasi memori dengan mengatur nilai awal untuk beberapa lokasi dalam memori.
	initial begin
		Mem[0] = 5; // Lokasi memori ke-0 berisi nilai 5
		Mem[1] = 6; // Lokasi memori ke-1 berisi nilai 6
		Mem[2] = 7; // Lokasi memori ke-2 berisi nilai 7
		            // Sisanya tidak diinisialisasi secara eksplisit (default-nya tidak ditentukan).
	end
	
// Proses Penulisan ke Memori (Write Operation)
// Penulisan ke memori terjadi pada saat clock mengalami transisi dari 0 ke 1 (posedge clock).
/* Hanya bit [6:2] dari alamat yang digunakan untuk mengakses memori karena:
    * Memori bekerja dalam satuan word (32-bit), bukan byte (8-bit).
    * Dengan hanya menggunakan address[6:2], kita memastikan bahwa setiap word 
	  diakses dengan kelipatan 4 byte, sesuai dengan lebar data 32-bit.
*/
	always @ (posedge clock) begin
	 // Jika MemWrite = 1, maka data WriteData akan disimpan ke alamat yang diberikan.
		if (MemWrite == 1)
			Mem[address[6:2]] <= WriteData;
	end

// Proses Pembacaan dari Memori (Read Operation)
// Pembacaan data dilakukan saat clock mengalami transisi dari 1 ke 0 (negedge clock).
	always @(negedge clock) begin
		// Jika MemRead = 1, data di alamat yang diberikan akan disimpan ke ReadData.
		if (MemRead == 1)
			ReadData <= Mem[address[6:2]];
	end	
endmodule







