`timescale 1ns / 1ps
//`include ".\src\linescanner2stream_convertor_M00_AXIS.v"
`define PIXELS_BUFFER_SIZE 4
`define BYTE_SIZE 8
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2016 09:44:53
// Design Name: 
// Module Name: linescanner2stream_convertor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module linescanner2stream_convertor #
(
    // Users to add parameters here

    // User parameters ends
    // Do not modify the parameters beyond this line   
    parameter integer C_M00_AXIS_TDATA_WIDTH = 32,
    parameter integer C_M00_AXIS_START_COUNT = 32 
    // Parameters of Axi Master Bus Interface M00_AXIS
)
(
    // Users to add ports here
    input wire enable,
    input wire [7:0] input_data,
    input wire pixel_captured,
    // output wire data_ready,
    // User ports ends
    // Do not modify the ports beyond this line

     // Ports of Axi Master Bus Interface M00_AXIS
     input wire  m00_axis_aclk,
     input wire  m00_axis_aresetn,
     output wire  m00_axis_tvalid,
     output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
     output wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
     output wire  m00_axis_tlast,
     input wire  m00_axis_tready
);

	// Add user logic here
	wire data_ready_net;
	reg log1_rised = 0;
	reg data_ready_value = 0;
	reg[7:0] pixel_counter = 0;
	reg[C_M00_AXIS_TDATA_WIDTH - 1 : 0] output_data;
	reg[7:0] pixel_data_ready_delay;
	
	integer int_buffer;
	
	initial data_ready_value = 0;
	initial pixel_counter = 0;
	initial output_data = 0;
	 	
	assign data_ready_net = data_ready_value;
	
    // Instantiation of Axi Bus Interface M00_AXIS
    linescanner2stream_convertor_M00_AXIS # (.C_M_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH), .C_M_START_COUNT(C_M00_AXIS_START_COUNT)) 
         linescanner2stream_convertor_M00_AXIS_inst (
            .DATA_SOURCE(output_data),
            .DATA_READY(data_ready_net),
            .M_AXIS_ACLK(m00_axis_aclk),
            .M_AXIS_ARESETN(m00_axis_aresetn),
            .M_AXIS_TVALID(m00_axis_tvalid),
            .M_AXIS_TDATA(m00_axis_tdata),
            .M_AXIS_TSTRB(m00_axis_tstrb),
            .M_AXIS_TLAST(m00_axis_tlast),
            .M_AXIS_TREADY(m00_axis_tready)
        );   
	always @(posedge m00_axis_aclk)
	begin
	    if(!m00_axis_aresetn)
        begin
           data_ready_value <= 0;
           pixel_counter <= 0;
           output_data <= 0;
           log1_rised <= 0;
        end
        else
        begin
           if(enable)
           begin
               if(pixel_captured)
               begin
                   if(~log1_rised)
                   begin
                       log1_rised <= 1;
                       int_buffer = input_data;
                       output_data <= pack_pixel_data(pixel_counter, input_data);
                       if(pixel_counter == `PIXELS_BUFFER_SIZE - 1)
                           data_ready_value <= 1;
                   end
               end
               else if(~pixel_captured)
               begin
                   if(log1_rised)
                   begin
                       log1_rised <= 0;
                       data_ready_value <= 0;
                       pixel_counter <= pixel_counter + 1;
                       if(pixel_counter == `PIXELS_BUFFER_SIZE - 1)
                          pixel_counter <= 0;
                   end
               end
           end
        end
	end
	
	function [31:0] pack_pixel_data;
	
	input wire [7:0] pixel_counter_arg;
	input wire [7:0] input_data_arg;

	reg [31:0] result;
    begin
    
        //$display("pixel_counter, %h", pixel_counter_arg);
        //$display("input_data, %h", input_data_arg [7:0]);
        if(pixel_counter_arg == 0)
            result [7:0]  =  input_data_arg [7:0];
        else if(pixel_counter_arg == 1)
            result [15:8]  =  input_data_arg [7:0];
        else if(pixel_counter_arg == 2)
            result [23:16]  =  input_data_arg [7:0];
        else if(pixel_counter_arg == 3)
            result [31:24]  =  input_data_arg [7:0];
        //$display("result inside, %h", result);
        pack_pixel_data = result;
    end
	endfunction
	
	// User logic ends
endmodule
