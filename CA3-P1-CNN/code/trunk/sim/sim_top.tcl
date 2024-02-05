	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"cnn_layer_tb"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
	set run_time			"1 us"
	# set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/adder.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/controller.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/counters.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/datapath.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/buffers.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mac.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/memory.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mul.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/muxes.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/pc.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/pe.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/register.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/shift_register.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/cnn_layer.sv

	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.sv
	onerror {break}

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================


	add wave -hex -group 	 	{TB}				sim:/$TB/*
	add wave -hex -group 	 	{top}				sim:/$TB/UUT/*
	add wave -hex -group -r		{all}				sim:/$TB/*

#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 
	