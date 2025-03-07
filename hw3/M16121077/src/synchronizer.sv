
module synchronizer(
	input D, 
	output logic Q, 
	input clk, 
	input rst_n);
 
   
  reg A1,A2;
  
  assign Q = A2;
  
  always@(posedge clk )
  begin
    if(!rst_n)
	  A1 <= 1'b0;
	else
	  A1 <= D;  
  end
  
  always@(posedge clk )
  begin
    if(!rst_n)
	  A2 <= 1'b0;
	else
	  A2 <= A1;  
  end

endmodule
