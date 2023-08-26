`timescale  1 ns /  1 ps
`define CNT 10416 
`define CNT_HALF 5028 
`define IDLE 2'b00 
`define START 2'b01 
`define DATA 2'b10 
`define STOP 2'b11

module uart_rx_top(
  input  wire clock,
  input  wire resetn,
  input  wire rx,
  //output wire tx 
 output  reg led_fix,
  output  reg led_touch
    );
 
 // baudrate 9600 counters. 
reg [ 13 : 0 ] counter;
reg syncff0, syncff1;
reg rx_;
reg [ 1 : 0 ] state, next;
reg [ 7 : 0 ] rdat;
reg [ 2 : 0 ] data_cnt;

wire counter_end, start, start_end, data_end, stop_end, get_dat;

assign get_dat       = (counter ==  `CNT_HALF ); // timing of getting serial data 
assign counter_end   = (counter ==  `CNT );  // end timing of baud period 
assign start_end     = (state    ==  `START ) && (counter_end ==  1'b1 ); // 
assign data_end      = (state    ==  `DATA )   && (counter_end ==  1'b1 ) && (data_cnt==  3'd7 );
assign stop_end      = (state    ==  `STOP )   && (counter_end ==  1'b1 );

// synchronous ff for rx 
always @ ( posedge clock ) begin  
 if ( resetn ==  1'b0 ) begin  
  syncff0 <=  1'b1 ;
  syncff1 <=  1'b1 ;
 end 
 else  begin 
  syncff0 <= rx;
  syncff1 <= syncff0;
 end 
end

// start detected 
always @ ( posedge clock ) begin 
 if ( resetn ==  1'b0 ) rx_ <=  1'b1 ;
 else      rx_ <= syncff1;
end

// start 
assign start =  ~ syncff1 & rx_;

// state 
always @ ( posedge clock ) begin 
 if ( resetn ==  1'b0 ) state <=  `IDLE ;
 else       state <= next;
end

// next 
always @ ( * ) begin 
 case ( state )
   `IDLE :   if ( start ==  1'b1 ) next =  `START ;
          else                      next =  `IDLE ;
  `START :  if ( start_end ==  1'b1 ) next =  `DATA ;
          else                      next =  `START ;
  `DATA :   if ( data_end ==  1'b1 ) next=  `STOP ;
          else                      next =  `DATA ;
  `STOP :   if ( stop_end ==  1'b1 ) next =  `IDLE ;
          else                      next =  `STOP ;
  default :                          next =  `IDLE ;
 endcase 
end 

// counter of baudrate 
always @ ( posedge clock ) begin  
 if ( resetn ==  1'b0 ) begin 
  counter <=  14'd0 ;
 end 
 else  begin 
  if ( state !=  `IDLE ) begin 
   if ( counter_end ==  1'b1 ) counter <=  14'd0 ;
   else                        counter <= counter +  14'd1 ;
  end 
 end 
end

// rx data counter 
always @ ( posedge clock ) begin 
 if ( resetn ==  1'b0 ) data_cnt <=  3'b000 ;
 else  if ((state ==  `DATA ) && (counter_end ==  1'b1 )) data_cnt <= data_cnt +  3'd1 ;
end


// rx data 
always @ ( posedge clock ) begin 
 if ( resetn ==  1'b0 ) begin 
    rdat <=  8'h00 ;
 end 
 else  begin 
  if ((state ==  `DATA ) && (get_dat ==  1'b1 )) rdat <= {syncff1, rdat[ 7 : 1 ]}; 
  else                                         rdat <= rdat;
 end 
end 

// output decode 
always @ ( posedge clock) begin 
 if ( resetn ==  1'b0 ) begin 
  led_fix     <=  1'b0 ;
  led_touch   <=  1'b0 ;
 end 
 else  begin 
  if ( stop_end ==  1'b1 ) begin 
   case (rdat)
     8'h55 :   begin  // button1 push 
       led_fix    <=  ~ led_fix;
      end 
    8'h62 :   begin  // button2 down 
       led_touch   <=  1'b1 ;
      end 
    8'h63 :   begin  // button2 up 
       led_touch   <=  1'b0 ;
      end 
    default : begin 
       led_fix     <=  1'b0 ;
       led_touch   <=  1'b0 ;
      end 
   endcase 
  end 
 end 
end
 
endmodule