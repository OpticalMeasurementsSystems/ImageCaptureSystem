# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {HDL-1065} -limit 10000
create_project -in_memory -part xc7z020clg400-2

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir E:/oms/VideoControlIP/image_capture/image_capture.cache/wt [current_project]
set_property parent.project_path E:/oms/VideoControlIP/image_capture/image_capture.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths {
  e:/oms/VideoControlIP/ip_repo/linescanner_image_capture_ip_1.0
  e:/oms/VideoControlIP/ip_repo/image_capture_manger
} [current_project]
read_verilog -library xil_defaultlib {
  E:/oms/VideoControlIP/image_capture/src/image_capture_manager_S00_AXI.v
  E:/oms/VideoControlIP/image_capture/src/image_capture_manager.v
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}

synth_design -top image_capture_manager -part xc7z020clg400-2


write_checkpoint -force -noxdef image_capture_manager.dcp

catch { report_utilization -file image_capture_manager_utilization_synth.rpt -pb image_capture_manager_utilization_synth.pb }