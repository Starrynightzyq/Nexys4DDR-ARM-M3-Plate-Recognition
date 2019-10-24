`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2017/08/02 15:17:37
// Design Name:
// Module Name: test_axis_tb
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


module test_axis_tb ();

    reg             aclk                = 0;
    reg             aresetn             = 1;
    wire            s_axis_tvalid          ;
    wire [  24-1:0] s_axis_tdata           ;
    wire [24/8-1:0] s_axis_tkeep           ;
    wire            s_axis_tlast           ;
    wire [   1-1:0] s_axis_tuser           ;
    reg             s_axis_tready       = 1;
    wire            example_master_done    ;

    axis_switch_0_example_master #(.C_MASTER_ID(1)) inst_axis_switch_0_example_master_0 (
        .aclk         (aclk               ),
        .aresetn      (aresetn            ),
        .m_axis_tvalid(s_axis_tvalid      ),
        .m_axis_tdata (s_axis_tdata       ),
        .m_axis_tkeep (s_axis_tkeep       ),
        .m_axis_tlast (s_axis_tlast       ),
        .m_axis_tuser (s_axis_tuser       ),
        .m_axis_tready(s_axis_tready      ),
        .done         (example_master_done)
    );
    always #5 aclk=~aclk;
    initial begin
        #100 s_axis_tready=0;
        #60 s_axis_tready=1;
    end
    initial begin

        #10 aresetn=0;
        #20 aresetn=1;
    end
endmodule