`timescale 1ps/1ps

`default_nettype none

module axis_switch_0_example_master #(parameter integer C_MASTER_ID = 0) (
    /**************** Stream Signals ****************/
    output reg             m_axis_tvalid  = 0,
    input  wire            m_axis_tready,
    output wire [  24-1:0] m_axis_tdata ,
    output wire [24/8-1:0] m_axis_tkeep ,
    output reg             m_axis_tlast   = 0,
    output wire [   1-1:0] m_axis_tuser ,
    /**************** System Signals ****************/
    input  wire            aclk         ,
    input  wire            aresetn      ,
    /**************** Done Signal ****************/
    output reg             done           = 0
);

    /**************** Local Parameters ****************/
    localparam integer                                            P_M_TDATA_BYTES            = 24 / 8                                        ;
    localparam integer                                            P_M_TUSER_BYTES            = 1                                             ;
    localparam            [                                8-1:0] P_M_PACKET_SIZE            = (16 - 1)                                      ;
    localparam            [                               16-1:0] P_M_PACKET_NUM             = 16                                            ;
    localparam            [                               16-1:0] P_M_SINGLES_NUM            = 256                                           ;
    localparam            [                               17-1:0] P_M_DONE_NUM               = 272                                           ;
    localparam integer                                            P_M_NUM_MI_SLOTS           = 2                                             ;
    localparam integer                                            P_M_NUM_SI_SLOTS           = 1                                             ;
    localparam            [P_M_NUM_MI_SLOTS*P_M_NUM_SI_SLOTS-1:0] P_M_CONNECTIVITY_ARRAY     = 2'b11                                         ;
    localparam            [              32*P_M_NUM_SI_SLOTS-1:0] P_M_NUM_CONNECTED_MI_ARRAY = {32'd2}                                       ;
    localparam integer                                            P_M_NUM_CONNECTED_MI       = P_M_NUM_CONNECTED_MI_ARRAY[C_MASTER_ID*32+:32];

    /**************** Internal Wires/Regs ****************/
    genvar  i;
    generate
        for(i=0; i<P_M_TDATA_BYTES; i=i+1) begin: tdata_g
            reg [8-1:0] tdata_i = 8'h00;
        end
    endgenerate
    generate
        for(i=0; (i<P_M_TUSER_BYTES-1); i=i+1) begin: tuser_g
            reg [8-1:0] tuser_i = 8'h00;
        end
    endgenerate
    reg  [(1-(8*(P_M_TUSER_BYTES-1))-1):0]    tuser_i              ;
    reg  [                         16-1:0]    pcnt_i     = 16'h0000;
    reg  [                         16-1:0]    tcnt_i     = 16'h0000;
    wire                                      done_i               ;
    wire                                      transfer_i           ;
    wire                                      areset     = ~aresetn;
    reg  [                          2-1:0]    areset_i   = 2'b00   ;

    /**************** Assign Signals ****************/
    assign m_axis_tkeep = {P_M_TDATA_BYTES{1'b1}};
    generate
        for(i=0; i<P_M_TDATA_BYTES; i=i+1) begin: tdata_assign_g
            assign m_axis_tdata[8*i+:8] = tdata_g[i].tdata_i[7:0];
        end
    endgenerate
    generate
        for(i=0; i<P_M_TUSER_BYTES; i=i+1) begin: tuser_assign_g
            if(i == (P_M_TUSER_BYTES - 1)) begin: tuser_assign_upper_g
                assign m_axis_tuser[1-1:8*i] = tuser_i;
            end
            else begin: tuser_assign_lower_g
                assign m_axis_tuser[8*i+:8] = tuser_g[i].tuser_i[7:0];
            end
        end
    endgenerate
    assign transfer_i = m_axis_tready && m_axis_tvalid;

    generate
        if(!P_M_NUM_CONNECTED_MI) begin: unconnected_master_g
            assign done_i = 1'b1;
        end
        else begin: connected_master_g
            assign done_i = (transfer_i && (pcnt_i == P_M_DONE_NUM - 1'b1) && (tcnt_i == P_M_PACKET_SIZE));
        end
    endgenerate


    // Register Reset
    always @(posedge aclk) begin
        areset_i <= {areset_i[0], areset};
    end

    //**********************************************
    // TDATA
    //**********************************************
    generate
        for(i=0; i<P_M_TDATA_BYTES; i=i+1) begin: tdata_incr_g
            always @(posedge aclk) begin
                if(areset) begin
                    tdata_g[i].tdata_i <= 8'h00;
                end
                else
                    begin
                        tdata_g[i].tdata_i <= (transfer_i) ? (tdata_g[i].tdata_i + 1'b1) : (tdata_g[i].tdata_i);
                    end
            end
        end
    endgenerate

    //**********************************************
    // TUSER
    //**********************************************
    generate
        for(i=0; (i<P_M_TUSER_BYTES-1); i=i+1) begin: tuser_incr_g
            always @(posedge aclk) begin
                if(areset) begin
                    tuser_g[i].tuser_i <= {(1 - (8*i)){1'b1}};
                end
                else
                    begin
                        tuser_g[i].tuser_i <= (transfer_i) ? (tuser_g[i].tuser_i - 1'b1) : (tuser_g[i].tuser_i);
                    end
            end
        end
    endgenerate

    always @(posedge aclk) begin
        if(areset) begin
            tuser_i <= {(1 - (8*(P_M_TUSER_BYTES-1))){1'b1}};
        end
        else
            begin
                tuser_i <= (transfer_i) ? (tuser_i - 1'b1) : tuser_i;
            end
    end


    //**********************************************
    // TVALID
    //**********************************************
    always @(posedge aclk) begin
        if(areset) begin
            m_axis_tvalid <= 1'b0;
        end
        else
            begin
                // TVALID
                if(done_i) begin
                    m_axis_tvalid <= 1'b0;
                end
                else if(areset_i == 2'b10) begin
                    m_axis_tvalid <= 1'b1;
                end
                else begin
                    m_axis_tvalid <= m_axis_tvalid;
                end
            end
    end

    //**********************************************
    // TLAST
    //**********************************************
    always @(posedge aclk) begin
        if(areset) begin
            m_axis_tlast <= 1'b0;
        end
        else
            begin
                // TLAST
                if(areset_i == 2'b10) begin
                    m_axis_tlast <= 1'b1;
                end
                else if((pcnt_i >= (P_M_SINGLES_NUM - 1'b1)) && transfer_i && m_axis_tlast) begin
                    m_axis_tlast <= 1'b0;
                end
                else if(tcnt_i == (P_M_PACKET_SIZE - 1'b1) && transfer_i) begin
                    m_axis_tlast <= 1'b1;
                end
                else begin
                    m_axis_tlast <= m_axis_tlast;
                end
            end
    end


    //**********************************************
    // PCNT, TCNT, DONE
    //**********************************************
    always @(posedge aclk) begin
        if(areset) begin
            pcnt_i <= 16'h0000;
            tcnt_i <= 16'h0000;
            done   <= 1'b0;
        end
        else
            begin
                // DONE
                done <= (done_i) ? 1'b1 : done;

                // Increment counters
                tcnt_i <= (transfer_i) ? (m_axis_tlast ? 16'h0000 : (tcnt_i + 1'b1)) : tcnt_i;
                pcnt_i <= (transfer_i && m_axis_tlast) ? (pcnt_i + 1'b1) : pcnt_i;
            end
    end

endmodule

`default_nettype wire