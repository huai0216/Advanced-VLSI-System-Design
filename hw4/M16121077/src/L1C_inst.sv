
module L1C_inst(
  input clk,
  input rst,
  // Core to CPU wrapper
  input [`DATA_BITS-1:0] core_addr,
  input core_req,	// im_OE
  input [`DATA_BITS-1:0] I_out,
  input I_wait,
  input rvalid_m0_i,	
  input core_wait_CD_i,
  input [31:0] BWEB,
  // CPU wrapper to core
  output logic [`DATA_BITS-1:0] core_out,	// im_DO
  output logic core_wait,	// ON when L1CI_state is not IDLE
  // CPU wrapper to Mem
  output logic I_req,	// ON when L1CI_state is READ_MISS, like im_OE
  output logic [`DATA_BITS-1:0] I_addr // when L1CI_state is READ_MISS, send to wrapper

);

  logic [`CACHE_INDEX_BITS-1:0] index;
  logic [`CACHE_DATA_BITS-1:0] DA_out;	// 128 bits
  logic [`CACHE_DATA_BITS-1:0] DA_in;	// 128 bits
  logic [`CACHE_WRITE_BITS-1:0] DA_write;	// write signal to data array: 16bits?
  logic DA_read;
  logic [2*`CACHE_TAG_BITS-1:0] TA_out;
  logic [`CACHE_TAG_BITS-1:0] TA_in;
  logic TA_write;
  logic TA_read;
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

enum logic [3:0] {
	s_addr = 4'b0001,
	s_data = 4'b0010,
	s_miss = 4'b0100,
	s_missdata = 4'b1000
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
			if(read_cs == s_data && hit && (!I_wait) && (!core_wait_CD_i))begin
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
			s_data : begin
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
					if(hit && (!core_wait_CD_i)) out_reg <= block_data;
					if(!core_wait_CD_i)address_reg <= core_addr;
				end
				s_miss : begin
					da_reg <= (rvalid_m0_i) ? {I_out, da_reg[127:32]} : da_reg;
				end
				
				s_missdata : begin
					da_reg <= {I_out, da_reg[127:32]};
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
				if(!hit)begin
					read_ns = s_miss;
				end else if(!core_wait_CD_i)begin
					read_ns = s_addr;
				end else begin
					read_ns = s_data;
				end
				/*
				if(hit && (!core_wait_CD_i))begin
					read_ns = s_addr;
				end else if(hit)begin
					read_ns = s_data;
				end else begin
					read_ns = s_miss;
				end
				*/
			end			
			s_miss : begin
				if(I_wait || rvalid_m0_i) read_ns = s_miss;
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
		TA_in = core_addr[31:9];
		DA_in = {I_out, da_reg[127:32]};
		core_out = out_reg;
		I_addr = {core_addr[31:4],4'd0};
		case(read_cs)
			s_addr : begin
				index = core_addr[8:4];
				
				core_wait = core_req;
				I_req = 1'b0;
				TA_write = 1'b1;
				TA_read = 1'b0;
				DA_write = 16'h0;
				DA_WEB = 1'b1;
				DA_read = 1'b0;
			end
			s_data : begin
				core_wait = ~hit;
				I_req = ~hit;
				TA_read = hit1;
				DA_read = hit1;
				index = set_index;
				TA_write = 1'b1;
				DA_write = 16'b0;
				DA_WEB = 1'b1;
			end
			s_miss : begin
				index = set_index;
				DA_WEB = I_wait;
				TA_write = I_wait;
				I_req = I_wait;
				DA_write = {16{~I_wait}};
				TA_read = LRU[index];
				DA_read = LRU[index];
				core_wait = 1'b1;
			end
			
			s_missdata : begin
				index = set_index;
				core_wait = 1'b1;
				TA_write = 1'b1;
				DA_write = 16'b0;
				DA_WEB = 1'b1;
				I_req = 1'b0;
				TA_read = 1'b0;
				DA_read = 1'b0;
			end
			default : begin
				index = core_addr[8:4];
				core_wait = 1'b0;
				I_req = 1'b0;
				TA_write = 1'b1;
				TA_read = 1'b0;
				DA_write = 16'h0;
				DA_WEB = 1'b1;
				DA_read = 1'b0;
			end
			
		endcase
	end
  
  data_array_wrapper DA(
    .A(core_addr[8:4]),
    .DO(DA_out),
    .DI(DA_in),
    .CK(clk),
    .WEB(DA_WEB),
    .BWEB(~DA_write),	// each bit control 1 byte, 128=16*8 bits
    .OE(DA_read),
    .CS(1'b0)
  );

   
  tag_array_wrapper  TA(
    .A(core_addr[8:4]),
    .DO(TA_out),
    .DI(TA_in),
    .CK(clk),
    .WEB(TA_write),
    .BWEB(1'd0),
    .OE(TA_read),
    .CS(1'b0)
  );

 

endmodule

