// Submodule: Data memory in Verilog 
 module data_memory  
 (   	
		input clk,
      // address input, shared by read and write port  
      input [31:0] mem_access_addr, //Address
		
      // write port  
      input [31:0] mem_write_data, //WriteData 
      input mem_write_en,  //MemWrite
      input mem_read, //MemRead
		
      // read port  
      output [31:0] mem_read_data  //ReadData
 );  
      integer i;  
      reg [31:0] ram [63:0];  
      wire [7 : 0] ram_addr = mem_access_addr[8 : 1];  
      initial begin  
           for(i=0;i<63;i=i+1)  
                ram[i] <= 32'd0;  
      end  
      always @(posedge clk) begin  
           if (mem_write_en)  
                ram[ram_addr] <= mem_write_data;  
      end  
      assign mem_read_data = (mem_read==1'b1) ? ram[ram_addr]: 32'd0;   
 endmodule   