transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+design_5  -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.design_5 xil_defaultlib.glbl

do {design_5.udo}

run 1000ns

endsim

quit -force
