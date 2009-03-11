v 20081231 1
C 40000 44900 1 0 0 ft245rl.sym
{
T 41245 49255 5 10 1 1 0 0 1
refdes=U1
T 41645 48555 5 10 0 1 0 0 1
footprint=SSOP28
T 41845 49255 5 10 1 1 0 0 1
device=FT245RL
}
C 51700 41000 1 0 0 xc2c-vq44-bank2.sym
{
T 52200 43800 5 10 1 1 0 0 1
device=XC2C VQ44
T 52300 43600 5 10 1 1 0 0 1
comment=I/O bank 2
T 52450 41700 5 10 1 1 0 0 1
refdes=U2
T 51700 41000 5 10 0 0 0 0 1
footprint=LQFP44_10
}
C 45500 40300 1 0 0 xc2c-vq44-power.sym
{
T 45950 40800 5 10 1 1 0 0 1
comment=Power+JTAG
T 45950 42500 5 10 1 1 0 0 1
device=XC2C VQ44
T 46150 41300 5 10 1 1 0 0 1
refdes=U2
T 45500 40300 5 10 0 0 0 0 1
footprint=LQFP44_10
}
C 55800 48100 1 0 0 txo-1.sym
{
T 56100 49100 5 10 1 1 0 0 1
refdes=U4
T 56000 50100 5 10 0 0 0 0 1
device=VTXO
T 56600 48900 5 10 0 1 0 0 1
footprint=osc7x5
}
C 40800 41000 1 0 0 cat6221.sym
{
T 41500 42700 5 10 1 1 0 0 1
device=CAT6221
T 41800 42500 5 10 1 1 0 0 1
refdes=U3
T 40800 41000 5 10 0 0 0 0 1
footprint=sot23-6
}
C 53800 47200 1 0 1 xc2c-vq44-bank1.sym
{
T 53300 50000 5 10 1 1 0 6 1
device=XC2C VQ44
T 53200 49800 5 10 1 1 0 6 1
comment=I/O bank 1
T 52900 47900 5 10 1 1 0 6 1
refdes=U2
T 53800 47200 5 10 0 0 0 6 1
footprint=LQFP44_10
}
N 41300 44900 42500 44900 4
C 39600 49700 1 0 0 capacitor.sym
{
T 39600 50400 5 10 0 0 0 0 1
device=CAPACITOR
T 39600 50200 5 10 1 1 0 0 1
refdes=C5
T 39600 50600 5 10 0 0 0 0 1
symversion=0.1
T 39600 49700 5 10 0 1 0 0 1
footprint=0603
}
C 41000 41000 1 90 0 capacitor.sym
{
T 40300 41000 5 10 0 0 90 0 1
device=CAPACITOR
T 40600 41500 5 10 1 1 180 0 1
refdes=C1
T 40100 41000 5 10 0 0 90 0 1
symversion=0.1
T 41000 41000 5 10 0 1 0 0 1
footprint=0805
}
C 43800 42500 1 90 0 capacitor.sym
{
T 43100 42500 5 10 0 0 90 0 1
device=CAPACITOR
T 43500 43000 5 10 1 1 180 0 1
refdes=C2
T 42900 42500 5 10 0 0 90 0 1
symversion=0.1
T 43800 42500 5 10 0 1 0 0 1
footprint=0805
}
C 43400 41700 1 90 0 capacitor.sym
{
T 42700 41700 5 10 0 0 90 0 1
device=CAPACITOR
T 43100 41800 5 10 1 1 180 0 1
refdes=C3
T 42500 41700 5 10 0 0 90 0 1
symversion=0.1
T 43400 41700 5 10 0 1 0 0 1
footprint=0805
}
C 45400 41700 1 90 0 capacitor.sym
{
T 44700 41700 5 10 0 0 90 0 1
device=CAPACITOR
T 45100 42200 5 10 1 1 180 0 1
refdes=C6
T 44500 41700 5 10 0 0 90 0 1
symversion=0.1
T 45400 41700 5 10 0 1 0 0 1
footprint=0603
}
C 53000 46600 1 0 1 capacitor.sym
{
T 53000 47300 5 10 0 0 0 6 1
device=CAPACITOR
T 52800 47100 5 10 1 1 0 6 1
refdes=C8
T 53000 47500 5 10 0 0 0 6 1
symversion=0.1
T 53000 46600 5 10 0 1 0 6 1
footprint=0603
}
C 52400 40400 1 0 0 capacitor.sym
{
T 52400 41100 5 10 0 0 0 0 1
device=CAPACITOR
T 52700 40800 5 10 1 1 0 0 1
refdes=C10
T 52400 41300 5 10 0 0 0 0 1
symversion=0.1
T 52400 40400 5 10 0 1 0 0 1
footprint=0603
}
C 58000 48100 1 90 0 capacitor.sym
{
T 57300 48100 5 10 0 0 90 0 1
device=CAPACITOR
T 57700 48200 5 10 1 1 180 0 1
refdes=C12
T 57100 48100 5 10 0 0 90 0 1
symversion=0.1
T 58000 48100 5 10 0 1 0 0 1
footprint=0603
}
C 47300 42900 1 0 0 vcc-1.sym
C 51200 40600 1 0 0 vcc-1.sym
C 39900 50200 1 0 0 vcc-1.sym
C 39600 45900 1 0 0 capacitor.sym
{
T 39600 46600 5 10 0 0 0 0 1
device=CAPACITOR
T 39600 46400 5 10 1 1 0 0 1
refdes=C4
T 39600 46800 5 10 0 0 0 0 1
symversion=0.1
T 39600 45900 5 10 0 1 0 0 1
footprint=0603
}
C 41800 44600 1 0 0 gnd-1.sym
C 39500 45800 1 0 0 gnd-1.sym
C 37200 47500 1 0 0 gnd-1.sym
C 47900 42400 1 0 0 gnd-1.sym
C 57100 47800 1 0 0 gnd-1.sym
C 52900 39700 1 0 0 gnd-1.sym
C 52500 45600 1 0 1 gnd-1.sym
N 43000 42200 45600 42200 4
N 43000 43000 43600 43000 4
N 43600 41000 43600 42500 4
N 43200 41700 43200 41000 4
N 44600 41000 44600 41700 4
N 44600 41700 45600 41700 4
N 40800 43000 40800 41500 4
N 40800 41000 44600 41000 4
N 47500 42200 47500 42900 4
N 53000 47200 53000 46200 4
N 53000 46800 53400 46800 4
C 53600 46800 1 0 1 vcc-1.sym
N 52400 47200 52400 45900 4
N 53000 41000 53000 40000 4
N 53000 40000 52900 40000 4
N 56600 49600 57800 49600 4
N 57800 49600 57800 48600 4
C 36500 48000 1 0 0 connector4.sym
{
T 38300 48900 5 10 0 0 0 0 1
device=CONNECTOR_4
T 36500 49400 5 10 1 1 0 0 1
refdes=CONN1
T 36600 48700 5 10 0 1 0 0 1
footprint=conn_usb
}
N 39000 49100 40100 49100 4
N 40100 48800 37300 48800 4
N 40100 48500 37300 48500 4
N 37300 47800 37300 48200 4
C 39500 49600 1 0 0 gnd-1.sym
N 40100 50200 40100 49400 4
C 57000 49600 1 0 0 vcc-1.sym
N 39000 49100 39000 43000 4
N 39000 43000 40800 43000 4
C 38100 48900 1 0 0 diode-1.sym
{
T 38500 49500 5 10 0 0 0 0 1
device=DIODE
T 38400 49400 5 10 1 1 0 0 1
refdes=D1
T 38100 48900 5 10 0 1 0 0 1
footprint=do214
}
N 37300 49100 38100 49100 4
C 57500 41100 1 0 0 connector6.sym
{
T 59300 42900 5 10 0 0 0 0 1
device=CONNECTOR_6
T 57600 43100 5 10 1 1 0 0 1
refdes=CONN4
T 57500 41100 5 10 0 1 0 0 1
footprint=JUMPER6
}
C 38100 42800 1 0 0 diode-1.sym
{
T 38500 43400 5 10 0 0 0 0 1
device=DIODE
T 38400 43300 5 10 1 1 0 0 1
refdes=D2
T 38100 42800 5 10 0 1 0 0 1
footprint=do214
}
C 37900 43000 1 0 0 vcc-1.sym
C 53000 46000 1 0 1 capacitor.sym
{
T 53000 46700 5 10 0 0 0 6 1
device=CAPACITOR
T 52800 46500 5 10 1 1 0 6 1
refdes=C9
T 53000 46900 5 10 0 0 0 6 1
symversion=0.1
T 53000 46000 5 10 0 1 0 6 1
footprint=0603
}
N 52500 46800 52400 46800 4
N 52500 46200 52400 46200 4
C 52400 39800 1 0 0 capacitor.sym
{
T 52400 40500 5 10 0 0 0 0 1
device=CAPACITOR
T 52700 40200 5 10 1 1 0 0 1
refdes=C11
T 52400 40700 5 10 0 0 0 0 1
symversion=0.1
T 52400 39800 5 10 0 1 0 0 1
footprint=0603
}
N 52900 40600 53000 40600 4
N 52400 39500 52400 41000 4
C 47500 42500 1 0 0 capacitor.sym
{
T 47500 43200 5 10 0 0 0 0 1
device=CAPACITOR
T 47900 42900 5 10 1 1 0 0 1
refdes=C7
T 47500 43400 5 10 0 0 0 0 1
symversion=0.1
T 47500 42500 5 10 0 1 0 0 1
footprint=0603
}
C 43100 40700 1 0 0 gnd-1.sym
C 39000 47900 1 0 0 capacitor.sym
{
T 39000 48600 5 10 0 0 0 0 1
device=CAPACITOR
T 39400 48200 5 10 1 1 0 0 1
refdes=C13
T 39000 48800 5 10 0 0 0 0 1
symversion=0.1
T 39000 47900 5 10 0 1 0 0 1
footprint=0603
}
C 39400 47800 1 0 0 gnd-1.sym
N 46400 48200 46400 47900 4
N 46000 48500 46400 48500 4
N 46300 48500 46300 47600 4
N 46300 47600 46400 47600 4
N 46400 47300 46200 47300 4
N 46200 47300 46200 48800 4
N 43700 49100 46400 49100 4
N 46100 47000 46400 47000 4
N 43700 49400 45900 49400 4
N 45900 49400 45900 48100 4
N 45900 48100 46400 48100 4
N 43700 48200 46000 48200 4
N 46000 48200 46000 48500 4
N 43700 48800 46400 48800 4
N 46100 47000 46100 49100 4
N 47700 47000 48300 47000 4
N 47700 47300 48400 47300 4
N 47700 47600 48500 47600 4
N 47700 47900 48600 47900 4
N 48600 47900 48600 41000 4
N 48600 41000 47500 41000 4
N 47500 41300 48500 41300 4
N 48500 41300 48500 47600 4
N 47500 41600 48400 41600 4
N 48400 41600 48400 47300 4
N 47500 41900 48300 41900 4
N 48300 41900 48300 47000 4
C 46400 46600 1 0 0 switch-dip8-1.sym
{
T 47800 49175 5 8 0 0 0 0 1
device=SWITCH_DIP8
T 46700 49350 5 10 1 1 0 0 1
refdes=U5
T 46400 46600 5 10 0 0 0 0 1
footprint=DIP16
}
N 47700 48200 51800 48200 4
N 47700 49100 47900 49100 4
N 47900 49100 47900 48400 4
N 47900 48400 51800 48400 4
N 51800 48600 47800 48600 4
N 47800 48600 47800 48800 4
N 47800 48800 47700 48800 4
N 51800 48800 51500 48800 4
N 51500 48800 51500 48500 4
N 51500 48500 47700 48500 4
N 43700 47300 45000 47300 4
N 45000 47300 45000 45400 4
N 45000 45400 53900 45400 4
N 53900 45400 53900 48000 4
N 53900 48000 53600 48000 4
N 43700 47900 44900 47900 4
N 44900 47900 44900 45300 4
N 44900 45300 54000 45300 4
N 54000 45300 54000 48200 4
N 54000 48200 53600 48200 4
N 43700 47600 44800 47600 4
N 44800 47600 44800 45200 4
N 44800 45200 54100 45200 4
N 54100 45200 54100 48400 4
N 54100 48400 53600 48400 4
N 57400 47200 57400 48800 4
N 57400 47200 54200 47200 4
N 54200 47200 54200 48600 4
N 54200 48600 53600 48600 4
N 53600 49200 55800 49200 4
N 55800 49200 55800 48800 4
N 43700 48500 44400 48500 4
N 44400 48500 44400 51000 4
N 44400 51000 54500 51000 4
N 54500 51000 54500 49400 4
N 54500 49400 53600 49400 4
N 43700 45800 44300 45800 4
N 44300 45800 44300 51100 4
N 44300 51100 54600 51100 4
N 54600 51100 54600 49600 4
N 54600 49600 53600 49600 4
N 43700 46400 49600 46400 4
N 49600 46400 49600 43400 4
N 49600 43400 51800 43400 4
N 43700 46100 49500 46100 4
N 49500 46100 49500 43200 4
N 49500 43200 51800 43200 4
N 53600 42200 56700 42200 4
N 53600 42400 55500 42400 4
N 55500 42400 55500 42500 4
N 53600 42600 55500 42600 4
N 55500 42600 55500 42800 4
N 55500 42500 56700 42500 4
N 55500 42800 56700 42800 4
N 56700 41600 54400 41600 4
N 56700 41300 54800 41300 4
C 54300 41300 1 0 0 gnd-1.sym
C 52400 40500 1 90 0 jumper-1.sym
{
T 51900 40800 5 8 0 0 90 0 1
device=JUMPER
T 51900 40800 5 10 1 1 90 0 1
refdes=J1
T 52400 40500 5 10 0 0 0 0 1
footprint=HEADER2_1
}
N 53800 39500 52400 39500 4
N 54800 39500 54800 41300 4
C 54800 39400 1 90 0 jumper-1.sym
{
T 54300 39700 5 8 0 0 90 0 1
device=JUMPER
T 54300 39700 5 10 1 1 90 0 1
refdes=J2
T 54200 39500 5 10 0 1 0 0 1
footprint=HEADER2_1
}
C 44400 43000 1 0 0 vcc-1.sym
C 44600 42900 1 90 0 jumper-1.sym
{
T 44100 43200 5 8 0 0 90 0 1
device=JUMPER
T 44100 43200 5 10 1 1 90 0 1
refdes=J3
T 44600 42900 5 10 0 0 0 0 1
footprint=HEADER2_1
}
C 56300 41100 1 0 1 connector6.sym
{
T 54500 42900 5 10 0 0 0 6 1
device=CONNECTOR_6
T 56500 43100 5 10 1 1 0 6 1
refdes=CONN2
T 56200 42400 5 10 0 1 0 6 1
footprint=JUMPER6
}
C 57500 41100 1 0 1 connector6.sym
{
T 55700 42900 5 10 0 0 0 6 1
device=CONNECTOR_6
T 57400 43100 5 10 1 1 0 6 1
refdes=CONN3
T 57500 41100 5 10 0 1 0 0 1
footprint=JUMPER6
}
N 51800 49000 51700 49000 4
N 51700 49000 51700 50900 4
N 51700 50900 44500 50900 4
N 44500 50900 44500 47000 4
N 44500 47000 43700 47000 4
C 56600 44900 1 0 0 led-3.sym
{
T 57550 45550 5 10 0 0 0 0 1
device=LED
T 57050 45450 5 10 1 1 0 0 1
refdes=D5
T 56600 44900 5 10 0 1 0 0 1
footprint=T1.75_LED
}
C 55700 45000 1 0 0 resistor-1.sym
{
T 56000 45400 5 10 0 0 0 0 1
device=RESISTOR
T 55900 45300 5 10 1 1 0 0 1
refdes=R3
T 55700 45000 5 10 0 1 0 0 1
footprint=0603
}
N 51000 44400 55700 44400 4
N 50900 44500 55700 44500 4
N 55700 44500 55700 45100 4
N 50800 44600 55600 44600 4
N 55600 44600 55600 45800 4
N 55600 45800 55700 45800 4
C 57300 45800 1 0 0 vcc-1.sym
N 57500 45800 57500 44400 4
N 50800 44600 50800 42200 4
N 50800 42200 51800 42200 4
N 51800 42400 50900 42400 4
N 50900 42400 50900 44500 4
N 51800 42600 51000 42600 4
N 51000 42600 51000 44400 4
C 55700 44300 1 0 0 resistor-1.sym
{
T 56000 44700 5 10 0 0 0 0 1
device=RESISTOR
T 55900 44600 5 10 1 1 0 0 1
refdes=R1
T 55700 44300 5 10 0 1 0 0 1
footprint=0603
}
C 56600 44200 1 0 0 led-3.sym
{
T 57550 44850 5 10 0 0 0 0 1
device=LED
T 57050 44750 5 10 1 1 0 0 1
refdes=D3
T 56600 44200 5 10 0 1 0 0 1
footprint=T1.75_LED
}
C 55700 45700 1 0 0 resistor-1.sym
{
T 56000 46100 5 10 0 0 0 0 1
device=RESISTOR
T 55900 46000 5 10 1 1 0 0 1
refdes=R4
T 55700 45700 5 10 0 1 0 0 1
footprint=0603
}
C 56600 45600 1 0 0 led-3.sym
{
T 57550 46250 5 10 0 0 0 0 1
device=LED
T 57050 46150 5 10 1 1 0 0 1
refdes=D6
T 56600 45600 5 10 0 1 0 0 1
footprint=T1.75_LED
}
C 54100 48900 1 0 0 resistor-1.sym
{
T 54400 49300 5 10 0 0 0 0 1
device=RESISTOR
T 54300 49200 5 10 1 1 0 0 1
refdes=R2
T 54100 48900 5 10 0 0 0 0 1
footprint=0603
}
N 53600 49000 54100 49000 4
N 53600 48800 55000 48800 4
N 55000 48800 55000 49000 4
N 54100 49000 54100 48800 4
C 38000 47200 1 0 0 resistor-1.sym
{
T 38300 47600 5 10 0 0 0 0 1
device=RESISTOR
T 38400 47000 5 10 1 1 0 0 1
refdes=R5
T 38000 47200 5 10 0 1 0 0 1
footprint=0603
}
C 37900 47000 1 0 0 gnd-1.sym
N 38900 47600 40100 47600 4
C 38000 47500 1 0 0 resistor-1.sym
{
T 38300 47900 5 10 0 0 0 0 1
device=RESISTOR
T 38100 47800 5 10 1 1 0 0 1
refdes=R6
T 38000 47500 5 10 0 1 0 0 1
footprint=0603
}
N 38000 47600 38000 49100 4
N 38900 47600 38900 47300 4
N 53600 42000 55500 42000 4
N 55500 42000 55500 41900 4
N 55500 41900 56700 41900 4
C 44800 41700 1 90 0 capacitor.sym
{
T 44100 41700 5 10 0 0 90 0 1
device=CAPACITOR
T 44500 42200 5 10 1 1 180 0 1
refdes=C14
T 43900 41700 5 10 0 0 90 0 1
symversion=0.1
T 44800 41700 5 10 0 1 0 0 1
footprint=0603
}
C 58600 48100 1 90 0 capacitor.sym
{
T 57900 48100 5 10 0 0 90 0 1
device=CAPACITOR
T 58300 48200 5 10 1 1 180 0 1
refdes=C15
T 57700 48100 5 10 0 0 90 0 1
symversion=0.1
T 58600 48100 5 10 0 1 0 0 1
footprint=0603
}
N 57800 48600 58400 48600 4
N 56600 48100 58400 48100 4
