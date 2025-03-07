							
module L1C_data(
  input clk,
  input rst,
  // Core to CPU wrapper
  input [`DATA_BITS-1:0] core_addr,
  input core_req,
  input core_write,	// DM_wen from CPU
  input [`DATA_BITS-1:0] core_in,
  // Mem to CPU wrapper
  input [`DATA_BITS-1:0] D_out,
  input D_wait, // unused
  input rvalid_m1_i,	// NEW
  input core_wait_CI_i,
  // CPU wrapper to core
  output logic [`DATA_BITS-1:0] core_out,
  output logic core_wait,
  // CPU wrapper to Mem
  output logic D_req,
  //output logic [`DATA_BITS-1:0] D_addr,
  output logic D_write,
  output logic [`DATA_BITS-1:0] D_in,
  output logic [3:0] D_type	// DM_wen to CPU wrapper
);



  //--------------- complete this part by yourself -----------------//

  logic [`CACHE_INDEX_BITS-1:0] index;
  logic [`CACHE_DATA_BITS-1:0] DA_out;	// 128 bits
  logic [`CACHE_DATA_BITS-1:0] DA_in;	// 128 bits
  logic [`CACHE_WRITE_BITS-1:0] DA_write;	// write signal to data array: 16bits?
  logic DA_sel;
  logic [2*`CACHE_TAG_BITS-1:0] TA_out;
  logic [`CACHE_TAG_BITS-1:0] TA_in;
  logic TA_write;
  logic TA_sel;
  logic [`CACHE_LINES-1:0] valid;
  logic [`CACHE_LINES-1:0] valid2;
  
  logic [`DATA_BITS-1:0] core_addr_t;
  logic [`DATA_BITS-1:0] core_addr_t_n;

logic [22:0] tag;
logic [1:0] byte_offset, block_offset;
logic [4:0] set_index;
logic [31:0] LRU;
logic hit, hit0, hit1;
logic [31:0] out_reg;
logic [127:0] da_reg;
logic DA_WEB;
logic [31:0] block_data;
logic [31:0] address_reg;



enum logic [4:0] {
	s_addr = 5'b00001,
	s_data = 5'b00010,
	s_write = 5'b00100,
	s_miss = 5'b01000,
	s_missdata = 5'b10000
} read_cs, read_ns;
/*
logic [31:0] hit_cnt, req_cnt;

	always_ff@(posedge clk)begin
		if(rst)begin
			req_cnt <= 32'd0;
			hit_cnt <= 32'd0;
		end else begin
			if(read_cs == s_addr && core_req)begin
				req_cnt <= req_cnt + 32'd1;
			end else if(read_cs == s_missdata)begin
				req_cnt <= req_cnt - 32'd1;
			end
			if(read_cs == s_data && hit && (!D_wait) && (!core_wait_CI_i))begin
				hit_cnt <= hit_cnt + 32'd1;
			end else if (read_cs == s_missdata)begin
				hit_cnt <= hit_cnt - 32'd1;
				
			end
		end
	end
*/

	
	always_comb begin
		set_index = address_reg[8:4];
		block_offset = address_reg[3:2];
		byte_offset = address_reg[1:0];
		tag = address_reg[31:9];
		case(read_cs)
			s_data, s_write : begin
				hit0 = (tag == TA_out[22:0]) && (valid[set_index] == 1'b1);
				hit1 = (tag == TA_out[45:23]) && (valid2[set_index] == 1'b1);
				hit = hit0 | hit1;
			end
			default : begin
				hit0 = 1'b0;
				hit1 = 1'b0;
				hit = 1'b0;
			end
		endcase
		case(core_addr[3:2])
			2'b00 : block_data = DA_out[31:0];
			2'b01 : block_data = DA_out[63:32];
			2'b10 : block_data = DA_out[95:64];
			2'b11 : block_data = DA_out[127:96];
		endcase
	end

	always_ff@(posedge clk)begin
		if(rst)begin
			valid <= 32'd0;
			valid2 <= 32'd0;
			LRU <= 32'd0;
			out_reg <= 32'd0;
			address_reg <= 32'd0;
		end else begin
			
			case(read_cs)
				s_addr : begin
					if(core_req)begin
						address_reg <= core_addr;
					end
				end
				s_data : begin
					if(hit && (!core_wait_CI_i) && (!core_write)) out_reg <= block_data;
					if(!core_wait_CI_i)address_reg <= core_addr;
				end
				s_miss : begin
					da_reg <= (rvalid_m1_i) ? {D_out, da_reg[127:32]} : da_reg;
				end
				s_missdata : begin
					da_reg <= {D_out, da_reg[127:32]};
					valid[set_index] <= LRU[set_index] ? valid[set_index] : 1'b1;
					valid2[set_index] <= LRU[set_index] ? 1'b1 : valid2[set_index];
					LRU[set_index] <= ~LRU[set_index];
				end
				default : begin
					valid <= valid;
					valid2 <= valid2;
					LRU <= LRU;
					out_reg <= out_reg;
					address_reg <= address_reg;
				end
				
				
			endcase

			
		end
	end
 
	always_ff@(posedge clk)begin
		if(rst)begin
			read_cs <= s_addr;
		end else begin
			read_cs <= read_ns;
		end
	end

	always_comb begin
		case(read_cs)
			s_addr : begin
				read_ns = (core_req) ? s_data : s_addr;
			end
			s_data : begin
				if(core_write )begin
					read_ns = s_write;
				end else if(!hit)begin
					read_ns = s_miss;
				end else if(!core_wait_CI_i) begin
					read_ns = s_addr;
				end else begin
					read_ns = s_data;
				end
				/*
				end else if( hit && (!core_wait_CI_i)) begin
					read_ns = s_addr;
				end else if(!hit)begin
					read_ns = s_miss;
				end else begin
					read_ns = s_data;
				end
				*/
				
			end		
			s_write : begin
				if(D_wait || core_wait_CI_i)begin
					read_ns = s_write;
				end else begin
					read_ns = s_addr;
				end
				/*
				if((!D_wait) && (!core_wait_CI_i))begin
					read_ns = s_addr;
				end else begin
					read_ns = s_write;
				end
				*/
			end	
			s_miss : begin
				if(D_wait || rvalid_m1_i ) read_ns = s_miss;
				else read_ns = s_missdata;
			end
			
			s_missdata : begin
				read_ns = s_addr;
			end
			
			default : begin
				read_ns = read_cs;
			end
		endcase
	end

	always_comb begin
		core_out = out_reg;
		TA_in = core_addr[31:9];
		D_write = core_write;
		case(read_cs)
			s_addr : begin
				index = core_addr[8:4];
				D_req = core_write;
				core_wait = core_req;
				TA_write = 1'b1;
				TA_sel = 1'b0;
				DA_write = 16'hffff;
				DA_WEB = 1'b1;
				DA_sel = 1'b0;
				DA_in= da_reg;
			end
			s_data : begin 
				D_req = core_write || ((!core_write) && (!hit));
				core_wait = core_write || ((!core_write) && (!hit));
				TA_sel = hit1;
				DA_sel = hit1;
				DA_write = 16'hffff;
				DA_in = 128'd0;
				//DA_WEB = ~(core_write && hit);
				DA_WEB = 1'b1;
				index = set_index;
				TA_write = 1'b1;
			end
			s_write : begin
				case(core_addr[3:2])
					2'b00 : begin
						DA_write = 16'hfff0;
						DA_in = {96'd0, core_in};
					end 
					2'b01 : begin
						DA_write = 16'hff0f;
						DA_in = {64'd0, core_in, 32'd0};
					end
					2'b10 : begin
						DA_write = 16'hf0ff;
						DA_in = {32'd0, core_in, 64'd0};
					end
					2'b11 : begin
						DA_write = 16'h0fff;
						DA_in = {core_in, 96'd0};
					end
				endcase
				TA_sel = hit1;
				DA_sel = hit1;
				D_req = D_wait;
				core_wait = D_wait;
				DA_WEB = 1'b0;
				index = set_index;
				TA_write = 1'b1;
			end
			s_miss : begin
				index = set_index;
				DA_write = {16{(D_wait )}};
				TA_write = D_wait;
				DA_WEB = D_wait;
				D_req = D_wait;
				TA_sel = LRU[index];
				DA_sel = LRU[index];
				core_wait = 1'b1;
				DA_in = {D_out, da_reg[127:32]};
			end
			
			s_missdata : begin
				index = set_index;
				core_wait = 1'b1;
				TA_write = 1'b1;
				DA_write = 16'hffff;
				DA_WEB = 1'b1;
				D_req = 1'b0;
				TA_sel = 1'b0;
				DA_sel = 1'b0;
				DA_in = da_reg;
			end
			default : begin
				index = set_index;
				core_wait = 1'b0;
				TA_write = 1'b1;
				DA_write = 16'hffff;
				DA_WEB = 1'b1;
				TA_sel = 1'b0;
				DA_sel = 1'b0;
				D_req = 1'b0;
				DA_in = da_reg;
			end
		endcase
	end
  
  data_array_wrapper DA(
    .A(core_addr[8:4]),
    .DO(DA_out),
    .DI(DA_in),
    .CK(clk),
    .WEB(DA_WEB),
    .BWEB(DA_write),	// each bit control 1 byte, 128=16*8 bits
    .OE(DA_sel),
    .CS(1'b0)
  );

   
  tag_array_wrapper  TA(
    .A(core_addr[8:4]),
    .DO(TA_out),
    .DI(TA_in),
    .CK(clk),
    .WEB(TA_write),
    .BWEB(1'b0),
    .OE(TA_sel),
    .CS(1'b0)
  );
  
 
endmodule

