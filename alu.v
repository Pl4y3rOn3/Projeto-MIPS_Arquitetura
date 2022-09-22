// Verilog code for ALU
module alu(       
      input [31:0] a, //input 1  
      input [31:0] b, //input 2  
      input [3:0] alu_control,  //function sel  
      output reg [31:0] result, //result       
      output zero
   );
 
	
 always @(*)
 begin   
      case(alu_control)
		4'b0001: result = a << b; // sll  r1 #
		4'b0010: result = a >> b; // srl  r2 #
		4'b0011: result = a >>> b; // sra  r3 #
		
		4'b0100: result = b[31:0] << a[31:0]; // sllv  r4 
		4'b0101: result = b[31:0] >> a[31:0]; // srlv  r5 
		4'b0110: result = b[31:0] >>> a[31:0]; // srav  r6 ##
		
		4'b0111: result = b << 16;
      4'b1000: result = a + b; // add  r8
      4'b1001: result = a - b; // sub  r9
      4'b1010: result = a[31:0] & b[31:0]; // and  r10
      4'b1011: result = a[31:0] | b[31:0]; // or   r11
		4'b1100: result = a[31:0] ^ b[31:0]; // xor   r12
		4'b1101: result = ~(a[31:0] | b[31:0]); // nor   r13
		
      4'b1110: begin
				if (a[31] != b[31]) 
					if (a[31] > b[31]) 
						result = 32'd1;
					 else 
						result = 32'd0;
				else 
					if (a < b)
						result = 32'd1;
					else
						result = 32'd0;
					end //slt / sti r14
							
		4'b1111: begin if (a[31:0] < b[31:0]) result = 32'd1;  
                     else result = 32'd0;  
                     end // sltu / sltiu r15

		
      default:result = a + b; // add  
      endcase  
 end
 
 assign zero = (result == 32'd0) ? 1'b1: 1'b0;  
 endmodule  