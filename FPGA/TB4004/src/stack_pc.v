module stack_pc (
    input wire clk,
    input wire reset,
    input wire push,
    input wire pop,
    input wire [11:0] data_in,
    output wire [11:0] pc_out
);

    // 8段のスタック
    reg [11:0] stack [0:7];
    reg [2:0] sp;  // スタックポインタ（0～7）

    // PCはスタックの最上位に位置づける（stack[0]）
    assign pc_out = stack[0];

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sp <= 0;
            for (i = 0; i < 8; i = i + 1)
                stack[i] <= 12'd0;
        end else begin
            if (push && sp < 7) begin
                // スタックを上にずらす
                for (i = 7; i > 0; i = i - 1)
                    stack[i] <= stack[i-1];
                stack[0] <= data_in;
                sp <= sp + 1;
            end else if (pop && sp > 0) begin
                // スタックを下にずらす
                for (i = 0; i < 7; i = i + 1)
                    stack[i] <= stack[i+1];
                stack[7] <= 12'd0;
                sp <= sp - 1;
            end
        end
    end

endmodule
