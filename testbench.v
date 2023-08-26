`timescale  1 ns /  1 ps
module testbench();

reg clock, resetn, rx;
wire led_fix, led_touch;

integer i;
uart_rx_top dut (
 .clock ( clock ),
 .resetn ( resetn ),
 .rx ( rx ),
 .led_fix ( led_fix ),
 .led_touch ( led_touch )
);

initial  begin
 $dumpfile("testbench.vcd");
 $dumpvars(0, testbench)  ;
 clock   =  1'b0 ;
 resetn =  1'b1 ;
 rx      =  1'b1 ;
end 

always  begin 
 # 5 ; clock =  ~ clock;
end

initial  begin 
   #100 ; resetn = 1'b1 ;
 # 100 ; resetn =  1'b0 ;
 # 100 ; resetn =  1'b1 ;
 # 100; rx      =  1'b0 ; // Start
 // baudrate at 9600. 
 // time unit is in (ns) 
 for ( i =  0 ; i <=  7 ; i = i +  1 ) begin 
  # 104170 ; rx =  ~ rx;
 end
# 104170 ; rx =  1'b1 ; // stop
# 1000000 ;
 $finish ;
end

endmodule
