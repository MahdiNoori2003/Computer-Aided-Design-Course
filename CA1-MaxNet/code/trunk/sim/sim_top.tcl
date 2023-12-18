	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"MaxNet_TB"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
	set run_time			"1 us"
	# set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Buffer.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Controller.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Datapath.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Encoder.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/F_Adder.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/F_Mul.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Finish.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/MaxNet.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Memory.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Mux_2.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Mux_4.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/PU.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Register.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Relu.v

	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.v
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
	