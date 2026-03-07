# Innovus Physical Design (APR) Notes

This document records the steps and critical decisions made during the **Auto Place & Route (APR)** process using Cadence Innovus.

## 1. Important Steps & Significance

| Step | Importance | Purpose |
| :--- | :--- | :--- |
| **Design Import** | Critical | Loads the Netlist, LEF (physical info), and MMMC (timing constraints). |
| **Floorplan** | High | Defines the chip size and IO pin placement. Impacts area and wire length. |
| **Power Planning** | High | Creates Power Rings and Stripes to ensure stable voltage distribution. |
| **Placement** | High | Automatically places standard cells. Determines final timing and congestion. |
| **Clock Tree Synthesis (CTS)** | **Critical** | Builds the clock distribution network. Minimizes skew and ensures timing closure. |
| **Routing** | High | Automatically connects all signals using metal layers. |
| **Verification (DRC/LVS)** | **Critical** | Checks for physical design rule violations (shorts, spacing, etc.). |

## 2. Methodology
We follow the standard RTL-to-GDSII flow adapted for the **Nangate 45nm** technology:
- **Library**: `NangateOpenCellLibrary` (LEF/LIB)
- **Constraints**: 100MHz target (10ns period)

## 3. Execution Guide

To run the full APR flow, follow these steps in the `hardware/backend/innovus` directory:

1. **Environment Setup**:
   ```bash
   source /vol/ece303/genus_tutorial/cadence.env
   ```

2. **Prepare Netlist** (Add VDD/VSS pins):
   ```bash
   python3 add_pg_pins.py ../genus/nn_top_syn.v nn_top_syn_pg.v
   ```

3. **Run Innovus (Automated)**:
   ```bash
   innovus -files run_innovus.tcl
   ```
   *Note: If you want to see the GUI, run `innovus` then `source run_innovus.tcl` inside the tool.*

## 4. Progress Tracker
- [x] Design Import (Scripts Ready)
- [x] Floorplan & Pin Assignment (Scripted)
- [x] Power Planning (Scripted)
- [x] Placement & Optimization
- [x] Clock Tree Synthesis (CTS)
- [x] Routing
- [x] Physical Verification (DRC/Antenna)
- [x] Post-Route Timing Analysis

## 5. Critical Commands for Reference
- `editPin`: Used to place IO pins on specific sides.
- `addRing / addStripe`: Essential for power grid stability.
- `clockDesign`: Performs CTS based on the `.ctstch` spec.
- `verify_drc / verifyConnectivity`: Ensures the chip can be manufactured.

## 6. Final Post-Route Results (PPA)
- **Timing (Setup)**: WNS = **+1.356ns**, Violating Paths = 0 (Timing Met!)
- **Timing (Hold)**: WNS = **+0.049ns**, Violating Paths = 0
- **Power**: Total = **71.47 mW** (Internal: 32.72 mW, Switching: 30.75 mW, Leakage: 8.00 mW)
- **Area (Density)**: **63.43%** utilization.
- **Connectivity**: 0 problems or warnings.
- **DRC Violations**: 1000+ Violations (Metal Shorts/Spacing due to congestion).

## 7. Proposals to Fix DRC Congestion
The dense logic array in `u_input_fifo` generates severe local congestion. To achieve a DRC-clean layout for tape-out, consider these physical design adjustments:
1. **Increase Total Area / Reduce Density**: 
   - Expand the floorplan margins or target lower utilization (e.g., 40-50%). This allows standard cells to spread further apart, granting the router more tracks per cell.
2. **Increase Available Routing Layers**: 
   - Currently, routing is artificially restricted: `setNanoRouteMode -routeTopRoutingLayer 6`. 
   - *Fix:* Nangate 45nm supports M10. Change the script to `-routeTopRoutingLayer 8` or `10`. This is the most direct way to eliminate congestion.
3. **Module Placement Halos**: 
   - Add placement Halos around highly congested modules like the lookup tables to force empty spaces, allowing wires to pass through unobstructed.

## 8. Useful Innovus GUI & Analysis Commands
If you want to view your placed and routed chip or analyze specific metrics, start the GUI:
```bash
innovus
```
Then use the console (`innovus>`) to run these commands:

- **Restore a Saved Design:**
  ```tcl
  # Loads the final database into the GUI for viewing
  restoreDesign nn_top_final.enc.dat nn_top
  ```
- **Report Power:**
  ```tcl
  # Reports internal, switching, and leakage power
  report_power -outfile timingReports/nn_top_power.rpt
  ```
- **Report Timing:**
  ```tcl
  report_timing -machine_readable -max_paths 50
  ```

## 9. Git & File Size Management
The generated `.sdf` (Standard Delay Format) file is very large (~180MB) and will cause `git push` to fail due to GitHub's 100MB file limit. 
- **Action Taken:** `*.sdf` has been added to `.gitignore`.
- **Zip Workaround:** The SDF file is compressed as `nn_top_final.sdf.zip` to save space. 
- **⚠️ Important Next Step:** Before running Gate-Level Simulation (GLS), you MUST unzip it:
  ```bash
  unzip nn_top_final.sdf.zip
  ```
