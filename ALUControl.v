
//ALU Control
 module ALUControl( ALU_Control, ALUOp, Function);  
 output reg[3:0] ALU_Control;  
 input [2:0] ALUOp;  
 input [5:0] Function;  
 wire [8:0] ALUControlIn;
 
 assign ALUControlIn = {ALUOp,Function};  
 
 //case dentro do outro fazendo dois checks 1x
 
 always @(ALUControlIn)
 case (ALUOp)
	3'b000 : begin //Instruções do tipo R 000
			casex (ALUControlIn)
			9'b000000000: ALU_Control=4'b0001;  //r1 sll
			9'b000000010: ALU_Control=4'b0010;  //r2 srl
			9'b000000011: ALU_Control=4'b0011;  //r3 sra
			9'b000000100: ALU_Control=4'b0100;  //r4 sllv
			9'b000000110: ALU_Control=4'b0101;  //r5 srlv
			9'b000000111: ALU_Control=4'b0110;  //r6 srav
			9'b000100000: ALU_Control=4'b1000;  //r8 add
			9'b000100010: ALU_Control=4'b1001;  //r9 sub
			9'b000100100: ALU_Control=4'b1010;  //r10 and
			9'b000100101: ALU_Control=4'b1011;  //r11 or
			9'b000100110: ALU_Control=4'b1100;  //r12 xor
			9'b000100111: ALU_Control=4'b1101;  //r13 nor
			9'b000101010: ALU_Control=4'b1110;  //r14 slt
			9'b000101011: ALU_Control=4'b1111;  //r15 sltu
			default: ALU_Control = 4'b0000;
			endcase
			end
			
	3'b001:begin
			casex (ALUControlIn)
			9'b001xxxxxx: ALU_Control= 4'b0111;  //lui
			endcase
			end
	
	3'b010:begin
			casex (ALUControlIn)
			9'b010xxxxxx: ALU_Control= 4'b1110;  //r4 slti
			endcase
			end
			
	3'b011:begin
			casex (ALUControlIn)
			9'b011xxxxxx: ALU_Control= 4'b1000;  //r3 addi
			endcase
			end
	
	3'b100:begin
			casex (ALUControlIn)
			9'b100xxxxxx: ALU_Control= 4'b1111;  //r5 sltiu
			endcase
			end
			
	3'b101:begin
			casex (ALUControlIn)
			9'b101xxxxxx: ALU_Control= 4'b1010;  //r6 andi
			endcase
			end
	
	3'b110:begin
			casex (ALUControlIn)
			9'b110xxxxxx: ALU_Control= 4'b1011;  //r7 ori
			endcase
			end
	
	3'b111:begin
			casex (ALUControlIn)
			9'b111xxxxxx: ALU_Control= 4'b1100;  //r8 xori
			endcase
			end
 default: ALU_Control = 4'b0000;	
 endcase
 endmodule
 
//JR control unit r7 jr
module JR_Control( input[2:0] alu_op, 
       input [5:0] funct,
       output JRControl
    );
assign JRControl = ({alu_op,funct}==9'b000001000) ? 1'b1 : 1'b0;
endmodule

