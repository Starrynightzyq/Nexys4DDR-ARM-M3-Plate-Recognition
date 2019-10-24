

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "AXI_DPTI" "NUM_INSTANCES" "DEVICE_ID"  "C_AXI4_Lite_BASEADDR" "C_AXI4_Lite_HIGHADDR"
}
