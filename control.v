// Submodule: Control Unit in Verilog 
 module control( input[5:0] opcode,  
                           input reset,
									output reg[2:0] alu_op,
                           output reg[1:0] reg_dst,mem_to_reg,
                           output reg jump,branch,mem_read,mem_write,alu_src,reg_write,sign_or_zero                      
   );  
 always @(*)  
 begin  
      if(reset == 1'b1) begin  
                reg_dst = 2'b00;  
                mem_to_reg = 2'b00;  
                alu_op = 3'b000;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b0;  
                reg_write = 1'b0;  
                sign_or_zero = 1'b1;  
      end  
      else begin  
      case(opcode)   
      6'b000000: begin // Intruções tipo R 
                reg_dst = 2'b01;  
                mem_to_reg = 2'b00;  
                alu_op = 3'b000;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b0;  
                reg_write = 1'b1;  
                sign_or_zero = 1'b1;  
                end
		6'b000100: begin // beq  
                reg_dst = 2'b00;  
                mem_to_reg = 2'b00;  
                alu_op = 3'b001;  
                jump = 1'b0;  
                branch = 1'b1;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b0;  
                reg_write = 1'b0;  
                sign_or_zero = 1'b1;  
                end
		6'b000101: begin // bne  ###
                reg_dst = 2'b00;  
                mem_to_reg = 2'b00;  
                alu_op = 3'b001;  
                jump = 1'b0;  
                branch = 1'b1;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b0;  
                reg_write = 1'b0;
                sign_or_zero = 1'b1;
                end
		6'b001000: begin // addi  
                reg_dst = 2'b00;  
                mem_to_reg = 2'b00;  
                alu_op = 3'b011;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b1;  
                reg_write = 1'b1;  
                sign_or_zero = 1'b1;  
                end 
      6'b001010: begin // slti  
                reg_dst = 2'b00;  
                mem_to_reg = 2'b00;  
                alu_op = 3'b010;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b1;  
                reg_write = 1'b1;  
                sign_or_zero = 1'b1;  
                end
		6'b001011: begin // sltiu  
                reg_dst = 2'b00;  
                mem_to_reg = 2'b00;  
                alu_op = 3'b100;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b1;  
                reg_write = 1'b1;  
                sign_or_zero = 1'b0;  
                end
		6'b001100: begin // andi  
                reg_dst = 2'b00;  
                mem_to_reg = 2'b00;  
                alu_op = 3'b101;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b1;  
                reg_write = 1'b1;  
                sign_or_zero = 1'b0;  
                end
		6'b001101: begin // ori  
                reg_dst = 2'b00;  
                mem_to_reg = 2'b00;  
                alu_op = 3'b110;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b1;  
                reg_write = 1'b1;  
                sign_or_zero = 1'b0;  
                end
		6'b001110: begin // xori  
                reg_dst = 2'b00;  
                mem_to_reg = 2'b00;  
                alu_op = 3'b111;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b1;  
                reg_write = 1'b1;  
                sign_or_zero = 1'b0;  
                end
		6'b001111: begin // lui 
                reg_dst = 2'b00;  
                mem_to_reg = 2'b00;  
                alu_op = 3'b001;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b1;  
                reg_write = 1'b1;  
                sign_or_zero = 1'b0;  
                end
		6'b100011: begin // lw  
                reg_dst = 2'b00;  
                mem_to_reg = 2'b01;  
                alu_op = 3'b011;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b1;  
                mem_write = 1'b0;  
                alu_src = 1'b1;  
                reg_write = 1'b1;  
                sign_or_zero = 1'b1;  
                end  
      6'b101011: begin // sw  
                reg_dst = 2'b00;  
                mem_to_reg = 2'b00;  
                alu_op = 3'b011;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b1;  
                alu_src = 1'b1;  
                reg_write = 1'b0;  
                sign_or_zero = 1'b1;  
                end
      6'b000010: begin // j  
                reg_dst = 2'b00;  
                mem_to_reg = 2'b00;  
                alu_op = 3'b000;  
                jump = 1'b1;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b0;  
                reg_write = 1'b0;  
                sign_or_zero = 1'b1;  
                end  
      6'b000011: begin // jal  
                reg_dst = 2'b10;  
                mem_to_reg = 2'b10;  
                alu_op = 3'b000;  
                jump = 1'b1;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b0;  
                reg_write = 1'b1;  
                sign_or_zero = 1'b1;  
                end     
      default: begin  
                reg_dst = 2'b01;  
                mem_to_reg = 2'b00;  
                alu_op = 3'b000;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b0;  
                reg_write = 1'b1;  
                sign_or_zero = 1'b1;  
                end  
      endcase  
      end  
 end  
 endmodule  