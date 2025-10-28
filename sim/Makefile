#==========================================================================================
# Author: Van Le
# vanleatwork@yahoo.com
# Phone: VN: 0396221156, US: 5125841843
# 
# To run simulation in a sim directory, must run the following
#   source env.sh
#   cd sim
#
# To compile for the MUX TB:
#   make compile_mux
#
# To run MUX demo test using Siemens Questa tool:
#   make run test_name=mux_demo_test
#   make coverage test_name=mux_demo_test
#   vcover dump top.ucdb > log
#   make vopt_gui test_name=mux_demo_test
#   make vopt_run test_name=mux_demo_test
#   make vis_run test_name=mux_demo_test cmd_args=10
#
# To run MUX demo test using Cadence tool:
#   make compile_mux tool=Cadence
#   make run test_name=mux_demo_test tool=Cadence
#   make coverage test_name=mux_demo_test tool=Cadence
# To dump UCD file using Cadence tool:
#   imc -gui
#     merge test1 test2 -out all
#     load -run all
#     report -html/detailsummary-metrics -out path
#   Maybe the command line version
#     imc -execcmd "merge test1 test2 -out all"
#==========================================================================================
#
# make must be run where in the same directory as Makefile
#
UVM_SRC = $(UVM_HOME)/src
#
# To override the test name, use the command line argument: test_name=<test_name>
#
test_name = demo_test
cmd_args ?= 
# To run the mux_demo_test with a value of 6 for NUM_WRITE (default value is 4), use
# cmd_args="NUM_WRITE=6"
test_config = base_config
tool = DEFAULT
TOP = top
VOPT_TOP = vopt_top
VSIM_CMD = vsim -sv_lib uvm_dpi 
VOPT_CMD = vopt +acc ${TOP} -o ${VOPT_TOP} +designfile

#
# To override default values in `define, specify a file name with: 
#         make defines=<file name>
#
ifeq (${tool},DEFAULT)
	VLOG_CMD = vlog 
else
	VLOG_CMD = xrun -c -uvm 
endif

init:
	ln -s $(UVM_TB_DIR)/sim/Makefile
	ln -s $(UVM_TB_DIR)/sim/sim.do
	ln -s $(UVM_TB_DIR)/sim/wave.do
	ln -s $(UVM_TB_DIR)/sim/cov.do

DUT_DIR = $(UVM_TB_DIR)/dut
IF_DIR = $(UVM_TB_DIR)/inf
TB_DIR  = $(UVM_TB_DIR)/tb
SIM_DIR = $(UVM_TB_DIR)/sim
AGT_MUX_IN_DIR  = $(TB_DIR)/agt/mux_in
AGT_MUX_OUT_DIR  = $(TB_DIR)/agt/mux_out
CFG_DIR = $(TB_DIR)/cfg
TLM_DIR = $(TB_DIR)/tlm
CHK_DIR = $(TB_DIR)/chk
COV_DIR = $(TB_DIR)/cov
ENV_DIR = $(TB_DIR)/env
TST_DIR = $(TB_DIR)/tst

ifeq (${tool},DEFAULT)
compile_mux: mux_udf mux_dut mux_if tlm_mux cfg_mux seq_mux agt_mux chk_mux cov_mux env_mux tst_mux mux_top vopt
mux_top:
	${VLOG_CMD} -sv +incdir+$(UVM_SRC)\
		+incdir+$(UVM_HOME)\
		+incdir+$(ENV_DIR)\
		+incdir+$(TST_DIR)\
		+incdir+$(DUT_DIR)\
		+incdir+$(IF_DIR)\
		$(ENV_DIR)/mux_top.sv
else
compile_mux: mux_udf mux_dut mux_if tlm_mux cfg_mux agt_mux seq_mux chk_mux cov_mux env_mux tst_mux mux_top 
mux_top:
	${VLOG_CMD} +incdir+$(ENV_DIR) +incdir+$(TST_DIR) +incdir+$(DUT_DIR) +incdir+$(IF_DIR) $(ENV_DIR)/mux_top.sv
endif
uvm:
	test -e work || vlib work
	${VLOG_CMD} +incdir+$(UVM_SRC) $(UVM_SRC)/uvm_pkg.sv
	mkdir -p $UVM_HOME/lib
	#g++ -m64 -fPIC -DQUESTA -g -W -shared -I$(QUESTA_HOME)/include $(UVM_HOME)/src/dpi/uvm_dpi.cc -o $(UVM_HOME)/lib/uvm_dpi.so
	g++ -m64 -fPIC -DQUESTA -g -W -shared -I$(QUESTA_HOME)/include $(UVM_HOME)/src/dpi/uvm_dpi.cc -o uvm_dpi.so

mux_udf:
	${VLOG_CMD} +incdir+$(UVM_SRC) +incdir+$(ENV_DIR) $(ENV_DIR)/uvm_tb_udf_pkg.svh
mux_dut:
	${VLOG_CMD} -sv $(DUT_DIR)/mux.sv
mux_if:
	${VLOG_CMD} +incdir+$(ENV_DIR) $(IF_DIR)/clk_rst_if.sv
	${VLOG_CMD} +incdir+$(ENV_DIR) $(IF_DIR)/mux_in_if.sv
	${VLOG_CMD} +incdir+$(ENV_DIR) $(IF_DIR)/mux_out_if.sv
tlm_mux:
	${VLOG_CMD} +incdir+$(UVM_SRC) +incdir+$(TLM_DIR) +incdir+$(ENV_DIR) $(TLM_DIR)/mux_in_tlm_pkg.svh
cfg_mux:
	${VLOG_CMD} +incdir+$(UVM_SRC) +incdir+$(ENV_DIR) +incdir+$(CFG_DIR) $(CFG_DIR)/mux_cfg_pkg.svh
seq_mux:
	${VLOG_CMD} +incdir+$(UVM_SRC) +incdir+$(AGT_MUX_IN_DIR)/seq +incdir+$(ENV_DIR) $(AGT_MUX_IN_DIR)/seq/mux_in_seq_pkg.svh
agt_mux:
	${VLOG_CMD} +incdir+$(UVM_SRC) +incdir+$(AGT_MUX_IN_DIR) +incdir+$(ENV_DIR) $(AGT_MUX_IN_DIR)/mux_in_agent_pkg.svh
	${VLOG_CMD} +incdir+$(UVM_SRC) +incdir+$(AGT_MUX_OUT_DIR) +incdir+$(ENV_DIR) $(AGT_MUX_OUT_DIR)/mux_out_agent_pkg.svh
chk_mux:
	${VLOG_CMD} +incdir+$(UVM_SRC) +incdir+$(TLM_DIR) +incdir+$(ENV_DIR) +incdir+$(CHK_DIR) $(CHK_DIR)/uvm_tb_ap_queue_pkg.svh
	${VLOG_CMD} +incdir+$(UVM_SRC) +incdir+$(TLM_DIR) +incdir+$(ENV_DIR) +incdir+$(CHK_DIR) $(CHK_DIR)/mux_chk_pkg.svh
cov_mux:
	${VLOG_CMD} +incdir+$(UVM_SRC) +incdir+$(COV_DIR) $(COV_DIR)/mux_in_cov_pkg.svh
env_mux:
	${VLOG_CMD} +incdir+$(UVM_SRC) +incdir+$(ENV_DIR) $(ENV_DIR)/mux_env_pkg.svh
tst_mux:
	${VLOG_CMD} +incdir+$(UVM_SRC) +incdir+$(ENV_DIR) +incdir+$(TST_DIR) $(TST_DIR)/mux_test_pkg.svh
vopt:
	${VOPT_CMD}
vopt_run:
	${VSIM_CMD} -c ${VOPT_TOP} -do sim.do +UVM_TESTNAME=${test_name} ${cmd_args}
vopt_random:
	${VSIM_CMD} -sv_seed random -c ${VOPT_TOP} -do sim.do +UVM_TESTNAME=${test_name} ${cmd_args}
vopt_gui:
	${VSIM_CMD} ${VOPT_TOP} +UVM_TESTNAME=${test_name} 
ifeq (${tool},DEFAULT)
run:
	vsim -c top -do sim.do +UVM_TESTNAME=${test_name}
else
run:
	xrun -uvm -top worklib.top +UVM_TESTNAME=${test_name}
endif

ifeq (${tool},DEFAULT)
coverage:
	${VSIM_CMD} -c -sv_seed random -coverage ${VOPT_TOP} -do cov.do +UVM_TESTNAME=${test_name}
else
coverage:
	xrun -uvm -top worklib.top -coverage u +UVM_TESTNAME=${test_name}
endif

wave:
	${VSIM_CMD} -voptargs="+acc" $(TOP} +UVM_TESTNAME=${test_name}

vis_run:
	${VSIM_CMD} -c ${VOPT_TOP} -do sim.do +UVM_TESTNAME=${test_name} +NUM_WRITE=${cmd_args} -qwavedb=+signal+class

clean:
	rm -rf  *.wlf *.ucdb transcript work design.* xrun.* xcelium.d cov_work

tar:
	rm -rf  *.wlf log transcript work
	tar cvf ../uvm_tb.tar ../*
	
