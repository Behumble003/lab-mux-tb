//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//
// This is a simple mux design that has a 2-bit selector and 4 32-bit inputs.
// The mux takes 4 clock cycles to send the valid data out at the output. The
// input is buffered with a 3-entry queue. There is a control signal req, when
// high, indicating the input is valid. There is an output control signal valid,
// when high, indicating that the output data is valid.
//***************************************************************************************************************
//`timescale 1ns/10ps

parameter QUEUE_MAX	= 3;

typedef logic [2:0] ptr_t;

typedef enum logic [3:0] {
	RESET = 4'h1,
	IDLE = 4'h4,
	DRIVE_DATA = 4'h2,
	DRIVE_DATA_CNT_DWN = 4'h3 //drive data and count down
	} state_t;

module dut (input logic in_req,
            input logic [1:0] in_chan,
            input logic [31:0] in_data,
            input logic rst,
            input logic clk,
            output logic q_full,
            output logic [1:0] out_chan,
            output logic [7:0] out_data0,
            output logic [7:0] out_data1,
            output logic [7:0] out_data2,
            output logic [7:0] out_data3,
            output logic valid
            );

	logic [31:0] data_q [QUEUE_MAX:0];
	logic [1:0] chan_q [QUEUE_MAX:0];
	ptr_t head;
	ptr_t tail;
	wire [31:0] head_data;
	wire [1:0] head_chan;
	wire [7:0] sel_data;
		
	state_t st;
	state_t next_st;
	logic [1:0] cnt;
	
	event fire_a3;
	
	assign head_data = (head == tail) ? 'hz : data_q[head];
	assign head_chan = (head == tail) ? 'hz : chan_q[head];
	assign sel_data = (head == tail) ? 'hz : ((cnt == 3) ? head_data[31:24] : (
																					 	(cnt == 2) ? head_data[23:16] : (
																					 	(cnt == 1) ? head_data[15:8] : (
																					 	(cnt == 0) ? head_data[7:0] : 'hz ) ) ) );
																					 	
	function ptr_t incr_ptr(ptr_t in_ptr); //increase the ptr
		if (in_ptr == QUEUE_MAX) begin
			incr_ptr = 0;
		end
		else begin
			incr_ptr = in_ptr + 1;
		end
	endfunction
	
	// This function returns 1 if the h_ptr is only one entry from the t_ptr. Otherwise
	// it returns 0
	function bit chk_nxt_ptr(ptr_t h_ptr, ptr_t t_ptr);
		if (h_ptr == QUEUE_MAX) begin
			if (t_ptr == 0) begin
				chk_nxt_ptr = 1;
			end
			else begin
				chk_nxt_ptr = 0;
			end
		end
		else begin
			if (h_ptr + 1 == t_ptr) begin
				chk_nxt_ptr = 1;
			end
			else begin
				chk_nxt_ptr = 0;
			end
		end
	endfunction
	
	always_comb begin //use this instead "always @(*)" cause it prevent latch
		if (rst) begin //reset conditions
				out_chan = 0;
			out_data3 = 0;
			out_data2 = 0;
			out_data1 = 0;
			out_data0 = 0;
			q_full = 0;
		end
		else begin
			if (chk_nxt_ptr(tail,head) == 1) begin
				q_full = 1;
			end
			else begin
				q_full = 0;
			end
			if (head != tail) begin
				out_chan = head_chan;
				out_data3 = 0;	// to avoid infereed latch
				out_data2 = 0;
				out_data1 = 0;
				out_data0 = 0;
				unique case (head_chan)
					3: out_data3 = sel_data;
					2: out_data2 = sel_data;
					1: out_data1 = sel_data;
					0: out_data0 = sel_data;
				endcase
			end
			else begin
				out_chan = 0;
				out_data3 = 0;
				out_data2 = 0;
				out_data1 = 0;
				out_data0 = 0;
			end
		end
	end
	
	always_ff @(posedge clk) begin
		if (rst) begin
			head <= 0;
			tail <= 0;
			st <= RESET;
			cnt <= 0;
			valid <= 0;
		end
		else begin
			if ((in_req == 1) && (chk_nxt_ptr(tail,head) != 1)) begin
				data_q[tail] <= in_data;
				chan_q[tail] <= in_chan;
				tail <= incr_ptr(tail);
			end
			case (st)
				RESET: if (!rst) st <= IDLE;
				IDLE: begin
					if (head != tail) begin
						cnt <= 3;
						valid <= 1;
						st <= DRIVE_DATA;
					end
				end
				DRIVE_DATA: begin
					if (cnt == 0) begin
						head <= incr_ptr(head);
						if (chk_nxt_ptr(head,tail)) begin
							st <= IDLE;
							valid <= 0;
						end
						else begin
							cnt <= 3;
						end
					end
					else begin
						cnt <= cnt - 1;
					end
				end
			endcase
		end		
	end
	
	// When queue is full, req should never assert
	property p1;
		@(posedge clk) disable iff (rst) !(in_req && q_full);
	endproperty
	a1: assert property(p1);
	
	// If the next incrment value of tail pointer is equal to head pointer, the queue is full
	property p2;
		@(posedge clk) disable iff (rst) chk_nxt_ptr(tail,head) |-> q_full;
	endproperty
	a2: assert property(p2);

	// Verify that cnt is decremented by 1 at each clock	
	property p3;
		@(posedge clk) disable iff (rst) (st == DRIVE_DATA and cnt != 3) |-> cnt == $past(cnt) - 1'b1;
	endproperty
	a3: assert property(p3) 
	-> fire_a3;
	
endmodule

