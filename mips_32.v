// Verilog code for 32 bit single cycle MIPS CPU  
 module mips_32( input clk,reset,  
                 output[31:0] pc_out, alu_result
                             ); 
									  
 reg[31:0] pc_current;  
 wire signed[31:0] pc_next,pc2;  
 wire [31:0] instr;
 wire [2:0] alu_op;
 wire [1:0] reg_dst,mem_to_reg;  
 wire jump,branch,mem_read,mem_write,alu_src,reg_write;  
 
 wire [4:0] reg_write_dest;  
 wire [31:0] reg_write_data;
 
 wire [4:0] reg_read_addr_1;  
 wire [31:0] reg_read_data_1;
 
 wire [4:0] reg_read_addr_2;  
 wire [31:0] reg_read_data_2;
 
 wire [31:0] sign_ext_im,read_data2,zero_ext_im,imm_ext;  
 wire JRControl;
 
 wire [3:0] ALU_Control;  
 wire [31:0] ALU_out;  
 wire zero_flag;
 
 wire signed[31:0] im_shift_1, PC_j, PC_beq, PC_4beq,PC_4beqj,PC_jr;  
 wire beq_control; //Sinais de Jump
 
 wire [30:0] jump_shift_1;
 wire [31:0] mem_read_data;  
 wire [31:0] no_sign_ext;  
 wire sign_or_zero;
 
 // PC   
 always @(posedge clk or posedge reset)  
 begin   
      if(reset)   
           pc_current <= 32'd0;  
      else  
           pc_current <= pc_next;  
 end  
 // PC + 2   
 assign pc2 = pc_current + 32'd2;
 
 // instruction memory  
 instr_mem instrucion_memory(.pc(pc_current),.instruction(instr));
 
 // jump shift left 1  
 assign jump_shift_1 = {instr[29:0],1'b0};
 
 // control unit  
 control control_unit(.reset(reset),.opcode(instr[31:26]),.reg_dst(reg_dst)
                ,.mem_to_reg(mem_to_reg),.alu_op(alu_op),.jump(jump),.branch(branch),.mem_read(mem_read),  
                .mem_write(mem_write),.alu_src(alu_src),.reg_write(reg_write),.sign_or_zero(sign_or_zero));
 
 // multiplexer regdest  
 assign reg_write_dest = (reg_dst == 2'b10) ? 5'b11111: ((reg_dst==2'b01) ? instr[15:11] :instr[20:16]);
 //verificando se é função de Jal e escrevendo na memoria o endereço certo, ou o do registrador ou o da instrução
 
 // register file  
 assign reg_read_addr_1 = instr[25:21]; //rs
 assign reg_read_addr_2 = instr[20:16]; //rt
 register_file reg_file(.clk(clk),.rst(reset),.reg_write_en(reg_write),  
 .reg_write_dest(reg_write_dest),  
 .reg_write_data(reg_write_data),  
 .reg_read_addr_1(reg_read_addr_1),  
 .reg_read_data_1(reg_read_data_1),  
 .reg_read_addr_2(reg_read_addr_2),  
 .reg_read_data_2(reg_read_data_2));
 
 // sign extend  
 assign sign_ext_im = {{16{instr[15]}},instr[15:0]}; //Address/immediate signed
 assign zero_ext_im = {{16{1'b0}},instr[15:0]};     //Address/immediate unsigned
 assign imm_ext = (sign_or_zero==1'b1) ? sign_ext_im : zero_ext_im;
 
 // JR control  
 JR_Control JRControl_unit(.alu_op(alu_op),.funct(instr[5:0]),.JRControl(JRControl));
 
 // ALU control unit  
 ALUControl ALU_Control_unit(.ALUOp(alu_op),
 .Function(instr[5:0]),
 .ALU_Control(ALU_Control));
 
 // multiplexer alu_src  
 assign read_data2 = (alu_src == 1'b1) ? imm_ext : reg_read_data_2; //seleciona read_data2 do reg ou do immediat
 
 // ALU   
 alu alu_unit(.a(reg_read_data_1),
 .b(read_data2),
 .alu_control(ALU_Control),
 .result(ALU_out),
 .zero(zero_flag));
 
 // immediate shift 1  
 assign im_shift_1 = {imm_ext[30:0], 1'b0};
 
 //  
 assign no_sign_ext = ~(im_shift_1) + 1'b1; 
 
 // PC beq add  
 assign PC_beq = (im_shift_1[31] == 1'b1) ? (pc2 - no_sign_ext): (pc2 + im_shift_1);
 
 // beq control  
 assign beq_control = branch & zero_flag;
 
 // PC_beq  
 assign PC_4beq = (beq_control == 1'b1) ? PC_beq : pc2; 
 
 // PC_j  
 assign PC_j = {pc2[31],jump_shift_1};
 
 // PC_4beqj  
 assign PC_4beqj = (jump == 1'b1) ? PC_j : PC_4beq;
 
 // PC_jr  
 assign PC_jr = reg_read_data_1;  
 
 // PC_next  
 assign pc_next = (JRControl == 1'b1) ? PC_jr : PC_4beqj; 
 
 // data memory  
 data_memory datamem(.clk(clk),
 .mem_access_addr(ALU_out),  
 .mem_write_data(reg_read_data_2),
 .mem_write_en(mem_write),
 .mem_read(mem_read),  
 .mem_read_data(mem_read_data));
 
 // write back  
 assign reg_write_data = (mem_to_reg == 2'b10) ? pc2:((mem_to_reg == 2'b01)? mem_read_data: ALU_out);
 //verificando se vem mem_to_reg vem do Jal, do lw ou de outro
 
 // output  
 assign pc_out = pc_current;  
 assign alu_result = ALU_out;  
 endmodule 