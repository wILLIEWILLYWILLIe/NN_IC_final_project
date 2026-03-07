# ============================================================
# Innovus Automation Script for NPU
# ============================================================

# 1. Setup Design Mode and Import
setDesignMode -process 45

set init_verilog "nn_top_syn_pg.v"
set init_top_cell "nn_top"
set init_lef_file "/vol/ece303/genus_tutorial/NangateOpenCellLibrary.lef"
set init_mmmc_file "nn_top.view"
set init_pwr_net "VDD"
set init_gnd_net "VSS"

init_design

# 2. Floorplan
# Aspect Ratio 1.0, 63% density, 2um margins
floorPlan -r 1.0 0.63 2 2 2 2
fit

# 3. Global Net Connections
globalNetConnect VDD -type pgpin -pin VDD -inst *
globalNetConnect VSS -type pgpin -pin VSS -inst *
globalNetConnect VDD -type tiehi
globalNetConnect VSS -type tielo

# 4. Pin Placement (Simple distribution for automation)
# In professional design, this is often done via a .io file or script.
# We'll use editPin to place some pins on the left and right.
editPin -side Left -pin {clk reset wr_en din*} -layer 3 -spreadType Center -spacing 0.5
editPin -side Right -pin {in_full inference_done predicted_class* max_score*} -layer 3 -spreadType Center -spacing 0.5

# 5. Power Planning (Ring and Stripes)
addRing -nets {VSS VDD} -type core_rings -follow io -layer {top metal5 bottom metal5 left metal4 right metal4} \
        -width {top 1 bottom 1 left 1 right 1} -spacing {top 1 bottom 1 left 1 right 1} \
        -offset {top 0 bottom 0 left 0 right 0} -center 0

addStripe -block_ring_top_layer_limit metal5 -max_same_layer_jog_length 1.6 \
          -padcore_ring_bottom_layer_limit metal3 -set_to_set_distance 5 \
          -stacked_via_top_layer metal10 -padcore_ring_top_layer_limit metal5 \
          -spacing 1 -xleft_offset 1 -merge_stripes_value 0.095 -layer metal4 \
          -block_ring_bottom_layer_limit metal3 -width 1 -nets {VSS VDD } \
          -stacked_via_bottom_layer metal1

sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { 1 10 } \
       -blockPinTarget { nearestRingStripe nearestTarget } -padPinPortConnect { allPort oneGeom } \
       -checkAlignedSecondaryPin 1 -blockPin useLef -allowJogging 1 -crossoverViaBottomLayer 1 \
       -allowLayerChange 1 -targetViaTopLayer 10 -crossoverViaTopLayer 10 -targetViaBottomLayer 1 -nets { VDD VSS }

# 6. Placement
setPlaceMode -timingDriven 1 -clkGateAware 1
placeDesign

# 7. Clock Tree Synthesis (CTS)
clockDesign -specFile Clock.ctstch -outDir clock_report

# 8. Post-CTS Optimization
optDesign -postCTS
optDesign -postCTS -hold

# 9. Routing
setNanoRouteMode -quiet -routeTopRoutingLayer 9
routeDesign -globalDetail

# 10. Verification
verify_drc -report nn_top.drc.rpt
verifyConnectivity -type all -report nn_top.conn.rpt
verifyProcessAntenna -reportfile nn_top.antenna.rpt

# 11. Save Design and Netlist
saveDesign nn_top_final.enc
saveNetlist nn_top_final_nophy.v
write_sdf nn_top_final.sdf

puts "Innovus Physical Design Flow Finished Successfully"
