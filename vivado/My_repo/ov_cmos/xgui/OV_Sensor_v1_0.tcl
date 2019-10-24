# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "RBG_CHANGE" -parent ${Page_0}


}

proc update_PARAM_VALUE.RBG_CHANGE { PARAM_VALUE.RBG_CHANGE } {
	# Procedure called to update RBG_CHANGE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RBG_CHANGE { PARAM_VALUE.RBG_CHANGE } {
	# Procedure called to validate RBG_CHANGE
	return true
}


proc update_MODELPARAM_VALUE.RBG_CHANGE { MODELPARAM_VALUE.RBG_CHANGE PARAM_VALUE.RBG_CHANGE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RBG_CHANGE}] ${MODELPARAM_VALUE.RBG_CHANGE}
}

