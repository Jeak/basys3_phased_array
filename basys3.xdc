## set up the 100mhz clock
set_property PACKAGE_PIN W5 [get_ports {CLK}]						
set_property IOSTANDARD LVCMOS33 [get_ports {CLK}]
create_clock -period 10.00 -name sys_clk_pin -waveform {0 5} -add [get_ports {CLK}]

## do anodes
set_property PACKAGE_PIN U2 [get_ports {ANODE[0]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {ANODE[0]}]

set_property PACKAGE_PIN U4 [get_ports {ANODE[1]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {ANODE[1]}]

set_property PACKAGE_PIN V4 [get_ports {ANODE[2]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {ANODE[2]}]

set_property PACKAGE_PIN W4 [get_ports {ANODE[3]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {ANODE[3]}]

## now do cathodes

set_property PACKAGE_PIN W7 [get_ports {CATHODE[7]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[7]}]

set_property PACKAGE_PIN W6 [get_ports {CATHODE[6]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[6]}]

set_property PACKAGE_PIN U8 [get_ports {CATHODE[5]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[5]}]

set_property PACKAGE_PIN V8 [get_ports {CATHODE[4]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[4]}]

set_property PACKAGE_PIN U5 [get_ports {CATHODE[3]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[3]}]

set_property PACKAGE_PIN V5 [get_ports {CATHODE[2]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[2]}]

set_property PACKAGE_PIN U7 [get_ports {CATHODE[1]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[1]}]

set_property PACKAGE_PIN V7 [get_ports {CATHODE[0]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[0]}]

## now set up the elements

set_property PACKAGE_PIN J1 [get_ports {ELEMENT[0]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {ELEMENT[0]}]

set_property PACKAGE_PIN L2 [get_ports {ELEMENT[1]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {ELEMENT[1]}]

set_property PACKAGE_PIN J2 [get_ports {ELEMENT[2]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {ELEMENT[2]}]

set_property PACKAGE_PIN G2 [get_ports {ELEMENT[3]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {ELEMENT[3]}]

set_property PACKAGE_PIN H1 [get_ports {ELEMENT[4]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {ELEMENT[4]}]

set_property PACKAGE_PIN K2 [get_ports {ELEMENT[5]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {ELEMENT[5]}]

set_property PACKAGE_PIN H2 [get_ports {ELEMENT[6]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {ELEMENT[6]}]

set_property PACKAGE_PIN G3 [get_ports {ELEMENT[7]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {ELEMENT[7]}]

set_property PACKAGE_PIN A14 [get_ports {ELEMENT[8]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {ELEMENT[8]}]

set_property PACKAGE_PIN A16 [get_ports {ELEMENT[9]}]						
set_property IOSTANDARD LVCMOS33 [get_ports {ELEMENT[9]}]

## now do the buttons

set_property PACKAGE_PIN W19 [get_ports {BUTTON_LEFT}]						
set_property IOSTANDARD LVCMOS33 [get_ports {BUTTON_LEFT}]

set_property PACKAGE_PIN T17 [get_ports {BUTTON_RIGHT}]						
set_property IOSTANDARD LVCMOS33 [get_ports {BUTTON_RIGHT}]

set_property PACKAGE_PIN U18 [get_ports {BUTTON_CENTER}]						
set_property IOSTANDARD LVCMOS33 [get_ports {BUTTON_CENTER}]

## set up an LED for negative

set_property PACKAGE_PIN U16 [get_ports {NEG}]						
set_property IOSTANDARD LVCMOS33 [get_ports {NEG}]