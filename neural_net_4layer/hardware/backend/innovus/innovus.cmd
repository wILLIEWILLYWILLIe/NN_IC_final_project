#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Sat Mar  7 15:54:28 2026                
#                                                     
#######################################################

#@(#)CDS: Innovus v16.20-p002_1 (64bit) 11/08/2016 11:31 (Linux 2.6.18-194.el5)
#@(#)CDS: NanoRoute 16.20-p002_1 NR161103-1425/16_20-UB (database version 2.30, 354.6.1) {superthreading v1.34}
#@(#)CDS: AAE 16.20-p004 (64bit) 11/08/2016 (Linux 2.6.18-194.el5)
#@(#)CDS: CTE 16.20-p008_1 () Oct 29 2016 08:26:57 ( )
#@(#)CDS: SYNTECH 16.20-p001_1 () Oct 27 2016 11:33:00 ( )
#@(#)CDS: CPE v16.20-p011
#@(#)CDS: IQRC/TQRC 15.2.5-s803 (64bit) Tue Sep 13 18:23:58 PDT 2016 (Linux 2.6.18-194.el5)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getDrawView
loadWorkspace -name Physical
win
setDesignMode -process 45
set init_verilog nn_top_syn_pg.v
set init_top_cell nn_top
set init_lef_file /vol/ece303/genus_tutorial/NangateOpenCellLibrary.lef
set init_mmmc_file nn_top.view
set init_pwr_net VDD
set init_gnd_net VSS
init_design
setDesignMode -process 45
set init_verilog nn_top_syn_pg.v
set init_top_cell nn_top
set init_lef_file /vol/ece303/genus_tutorial/NangateOpenCellLibrary.lef
set init_mmmc_file nn_top.view
set init_pwr_net VDD
set init_gnd_net VSS
init_design
floorPlan -r 1.0 0.5 5 5 5 5
fit
globalNetConnect VDD -type pgpin -pin VDD -inst *
globalNetConnect VSS -type pgpin -pin VSS -inst *
globalNetConnect VDD -type tiehi
globalNetConnect VSS -type tielo
editPin -side Left -pin {clk reset wr_en din*} -layer 3 -spreadType Center -spacing 0.5
editPin -side Right -pin {in_full inference_done predicted_class* max_score*} -layer 3 -spreadType Center -spacing 0.5
addRing -nets {VSS VDD} -type core_rings -follow io -layer {top metal5 bottom metal5 left metal4 right metal4} -width {top 1 bottom 1 left 1 right 1} -spacing {top 1 bottom 1 left 1 right 1} -offset {top 0 bottom 0 left 0 right 0} -center 0
addStripe -block_ring_top_layer_limit metal5 -max_same_layer_jog_length 1.6 -padcore_ring_bottom_layer_limit metal3 -set_to_set_distance 5 -stacked_via_top_layer metal10 -padcore_ring_top_layer_limit metal5 -spacing 1 -xleft_offset 1 -merge_stripes_value 0.095 -layer metal4 -block_ring_bottom_layer_limit metal3 -width 1 -nets {VSS VDD } -stacked_via_bottom_layer metal1
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { 1 10 } -blockPinTarget { nearestRingStripe nearestTarget } -padPinPortConnect { allPort oneGeom } -checkAlignedSecondaryPin 1 -blockPin useLef -allowJogging 1 -crossoverViaBottomLayer 1 -allowLayerChange 1 -targetViaTopLayer 10 -crossoverViaTopLayer 10 -targetViaBottomLayer 1 -nets { VDD VSS }
setPlaceMode -timingDriven 1 -clkGateAware 1
placeDesign
clockDesign -specFile Clock.ctstch -outDir clock_report
optDesign -postCTS
optDesign -postCTS -hold
setNanoRouteMode -quiet -routeTopRoutingLayer 9
routeDesign -globalDetail
verify_drc -report nn_top.drc.rpt
verifyConnectivity -type all -report nn_top.conn.rpt
verifyProcessAntenna -reportfile nn_top.antenna.rpt
saveDesign nn_top_final.enc
saveNetlist nn_top_final_nophy.v
write_sdf nn_top_final.sdf
getCTSMode -engine -quiet
report_power
report_timing
report_area
