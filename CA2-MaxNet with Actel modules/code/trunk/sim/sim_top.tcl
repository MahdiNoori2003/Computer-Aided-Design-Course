	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"Max_NetTB"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
	set run_time			"1 us"
#	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/actels.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/ands.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/controller.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/datapath.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Max_Net.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mul.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/muxes.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/ors.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/pu.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/saving_utils.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/sum_utils.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/utils.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/relu.v

		
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
	