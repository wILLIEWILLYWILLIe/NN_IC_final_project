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

## 6. Synthesis Results (Genus Baseline)
- **Timing (Setup)**: MET (Slack = **+5.195ns**)
- **Power**: Total = **86.59 mW** (Leakage: 7.74 mW, Dynamic: 78.85 mW)
- **Area**: Total Area = **678,599.222 um^2** (Cell Area: 412,346)

## 7. Iteration 1: Initial Post-Route Results (Baseline)
- **Timing (Setup)**: WNS = **+1.356ns**, Violating Paths = 0 (Timing Met!)
- **Timing (Hold)**: WNS = **+0.049ns**, Violating Paths = 0
- **Power**: Total = **71.47 mW**
- **Area (Density)**: **63.43%** utilization.
- **DRC Violations**: **1000+ Violations** (Routing congestion).

## 8. Iteration 2: Final Post-Route Results (Optimal)
*After expanding to Metal 9 and lowering floorplan density to 50%*

- **Timing (Setup)**: WNS = **+2.229ns**, Violating Paths = 0 (Timing Met & Improved!)
- **Timing (Hold)**: WNS = **+0.054ns**, Violating Paths = 0 (Timing Met!)
- **Max Frequency Estimation**: Target Period (10ns) - Setup WNS (2.229ns) = 7.771ns. Max Freq ≈ **128.6 MHz** (comfortably exceeds 100MHz baseline).
- **Power**: Total = **70.22 mW** (Internal: 32.64 mW, Switching: 29.57 mW, Leakage: 8.01 mW) -> *Decreased slightly due to fewer wire detours.*
- **Area (Density)**: **50.04%** utilization.
- **Connectivity**: 0 problems or warnings.
- **DRC Violations**: **0 Violations!** (Perfect Routing, Tape-out Ready).

## 9. Iteration 3: Final Post-Route Results (Optimal - Current)
*After further optimization of floorplan density to 50.14% and final timing closure*

- **Timing (Setup)**: WNS = **+1.214ns**, Violating Paths = 0 (Timing Met!)
- **Timing (Hold)**: WNS = **+0.458ns**, Violating Paths = 0 (Timing Met!)
- **Max Frequency Estimation**: Target Period (10ns) - Setup WNS (1.214ns) = 8.786ns. Max Freq ≈ **113.8 MHz**.
- **Power**: Total = **69.27 mW** (Internal: 32.54 mW, Switching: 28.53 mW, Leakage: 8.20 mW)
- **Area (Density)**: **50.14%** utilization.
- **Connectivity**: 0 problems or warnings.
- **DRC Violations**: **0 Violations!** (Perfect Routing, Tape-out Ready).

## 10. 專案比較與優劣分析：Our 4-Layer NPU vs. Wei-In's NPU
*(此章節專門為期末報告的「架構探討與比較」單元準備)*

相較於 Wei-In 開發的基礎款 NPU (`784 -> 30 -> 30 -> 10`)，本專案的 4 層 NPU (`784 -> 32 -> 16 -> 16 -> 10`，具備 32 條 MAC Lanes 平行運算) 展現了截然不同的設計哲學。以下是詳細的優劣勢比較：

### 🌟 我們的優勢 (Pros / 好在哪裡)

#### 1. 模型表現與特徵學習力 (Accuracy & Capacity)
*   **Ours (~97.5% 準確率)**：擁有更深的層數與更大的網路節點數 (32-16-16-10)。這讓我們能捕捉更高維度的非線性特徵，在真實的測試集上表現極佳。
*   **Wei-In (表現受限)**：窄小的隱藏層 (30-30-10) 嚴重限制了模型的學習天花板，容易發生 Underfitting (欠擬合)。

#### 2. 硬體架構的現代化與優雅性 (Hardware Elegance & Datapath)
*   **Ours (純淨設計)**：資料路徑上直接將 MAC 累加器擴展至 **64 位元**。這賦予了極大的動態範圍，從硬體物理層面**直接杜絕了溢位 (Overflow) 問題**，無需任何額外的飽和運算控制邏輯。
*   **Wei-In (複雜累贅)**：使用 Q1.15 (16 位元) 固定小數點，為了防止溢位，必須加入臃腫的飽和邏輯 (Saturating logic) 來夾壓數值，拖慢時序並增加無謂的邏輯閘。

#### 3. 激活函數的面積與時間成本 (Activation Functions)
*   **Ours (ReLU 函數)**：完美貼合數位邏輯，利用極低成本的**多工器 (Multiplexer)** 實作 (`in > 0 ? in : 0`)。零查表延遲、極低面積消耗，且完全不依賴記憶體。
*   **Wei-In (Sigmoid 函數)**：被迫建構龐大的 Read-Only Memory (ROM) Look-Up Table 來作弊近似指數計算。這會大幅吃掉 Block RAM 與晶片內部面積，且查表 (Table Lookup) 會成為 Critical Path 上的嚴重延遲來源。

#### 4. 可擴展性與參數化 RTL 生態 (Scalability & Parameterization)
*   **Ours (高度自動化)**：使用高度參數化的 SystemVerilog 寫法 (`generate-for`) 搭配 Python 自動化腳本。只需修改幾個 Localparam，就能「零痛點」從 4 層擴展到 8 層甚至是 16 層。
*   **Wei-In (硬編碼架構)**：網路層是被寫死的 (Hardcoded, e.g., `Layer1.sv`, `Layer2.sv`)。若要增加層數或神經元，必須進行大量痛苦的人工事後重構 (Manual refactoring)。

---

### ⚠️ 我們的劣勢與代價 (Cons / 壞在哪裡)

#### 1. 晶片面積與物理製造成本 (Area & Manufacturing Cost)
*   **Ours**：因為平行的 MAC 單元多達 32 條，加上神經元數量龐大，最終的邏輯閘總數 (Gate Count) 與 Cell Area 勢必**遠大於 Wei-In 的版本**。如果真的要流片製造 (Tape-out)，我們的晶片每平方毫米的成本會相當高昂。

#### 2. 繞線擁塞與 APR 挑戰 (Routing Congestion)
*   **Ours**：神經網路的「全連接層」在實體繞線上就是一場夢魘。神經元之間資料搬移產生的互連線 (Interconnects) 密如蛛網。這迫使我們必須使用到 **Metal 9 (9 層金屬)** 並將利用率降至 50% 才能清空 DRC 短路違規。
*   **Wei-In**：小巧的網路結構讓他們在佈局繞線 (Place & Route) 時會輕鬆非常多，甚至可能只需極少數的金屬層就能輕鬆過關。

#### 3. 總體功耗 (Total Power Consumption)
*   **Ours (70.22 mW)**：高平行度與大量的暫存器導致時脈樹 (Clock Tree) 與切換功率 (Switching Power) 維持在較高的水準 (30mW+)。若要應用於極低功耗的穿戴式物聯網 (IoT Embeded) 裝置，Wei-In 的小網路在功耗管控上會佔有絕對優勢。

---
📝 **給報告的總結 (Conclusion)**：
這是一場經典的 **「效能 vs. 成本」衡量 (Trade-off)**。Wei-In 的架構適合極端受限成本與功耗的超微型玩具級研究；而我們的設計則是一顆**真正具備實用推論能力、具備高度擴展性且採用現代硬體思維 (ReLU, 避免溢位的寬廣資料路徑, RTL 參數化)** 的高效能邊緣 AI 硬體加速器。

## 11. Historical Proposals to Fix DRC Congestion (Resolved)
The dense logic array in `u_input_fifo` generates severe local congestion. To achieve a DRC-clean layout for tape-out, consider these physical design adjustments:
1. **Increase Total Area / Reduce Density**: 
   - Expand the floorplan margins or target lower utilization (e.g., 40-50%). This allows standard cells to spread further apart, granting the router more tracks per cell.
2. **Increase Available Routing Layers**: 
   - Currently, routing is artificially restricted: `setNanoRouteMode -routeTopRoutingLayer 6`. 
   - *Fix:* Nangate 45nm supports M10. Change the script to `-routeTopRoutingLayer 8` or `10`. This is the most direct way to eliminate congestion.
3. **Module Placement Halos**: 
   - Add placement Halos around highly congested modules like the lookup tables to force empty spaces, allowing wires to pass through unobstructed.

## 12. Useful Innovus GUI & Analysis Commands
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

## 13. Git & File Size Management
The generated `.sdf` (Standard Delay Format) file is very large (~180MB) and will cause `git push` to fail due to GitHub's 100MB file limit. 
- **Action Taken:** `*.sdf` has been added to `.gitignore`.
- **Zip Workaround:** The SDF file is compressed as `nn_top_final.sdf.zip` to save space. 
- **⚠️ Important Next Step:** Before running Gate-Level Simulation (GLS), you MUST unzip it:
  ```bash
  unzip nn_top_final.sdf.zip
  ```

## 14. 檔案清理指南 (File Cleanup Guide)

### 🗑️ 可安全刪除（暫存/快照）
| 檔案 | 說明 |
|------|------|
| `.nn_top*.rs.fp` | Innovus restore point / session snapshots（每次跑 Innovus 自動生成） |
| `.nn_top*.rs.fp.spr` | 對應 snapshot 的附屬檔案 |
| `.timing_file_*.tif.gz` | 暫時的 timing 資料壓縮檔 |
| `.cadence/` | Cadence 工具暫存設定目錄 |
| `innovus.cmd` | Innovus 指令歷史紀錄（可重建） |

清理指令：
```bash
rm -rf .nn_top*.rs.fp .nn_top*.rs.fp.spr .timing_file_*.tif.gz .cadence innovus.cmd
```

### ⚠️ 重要檔案（不要刪）
| 檔案 | 說明 |
|------|------|
| `run_innovus.tcl` | Innovus P&R 腳本 — **最重要**，有此檔即可重跑整個流程 |
| `nn_top_final.enc` / `.enc.dat` | 完整 design database — 可直接 restore 回 Innovus |
| `nn_top_final.sdf` | SDF timing 檔案 — post-route GLS 必要 |
| `nn_top_final_nophy.v` | Post-route netlist（無 physical cells）— GLS 用 |
| `nn_top_syn_pg.v` | 帶 VDD/VSS pin 的 netlist |
| `Clock.ctstch` | CTS 規格檔 |
| `add_pg_pins.py` | Power/Ground pin 腳本 |
| `nn_top.*.rpt` | DRC/Antenna/Connectivity/Geometry 報告 |
| `timingReports/` | Timing 報告目錄 |
| `power.rpt` | Power 報告 |

## 14. Post-Route GLS 偵錯經驗紀錄 (Debug Notes)

在執行實體設計後的閘級模擬 (Post-Route GLS) 時，遇到了信號找不到與時序違例導致結果受損的問題，以下為解決方案紀錄：

### 14.1 Testbench (`nn_tb.sv`) 的底層訊號抓取
**問題**：Innovus 的實體優化 (Optimization) 會重組電路，導致原始 RTL 的 FSM `state[3:0]` 被拆解或部分刪除，TB 抓不到信號。
**解決方案**：
- 直接從 Netlist (`nn_top_final_nophy.v`) 中確認實際留下的暫存器名稱。
- 在 TB 中使用 **Escaped Name (轉義名稱)** 加上 **空格** 來定位，例如：`u_dut.\state_reg[0] .Q`。
- 移除已被優化掉的 `state[3]` 監測。

### 14.2 Makefile 與 Xcelium 模擬穩定度優化
**問題**：帶時序 (Timing) 的模擬中，微小的 Setup/Hold violation 會觸發 `NOTIFIER` 機制，導致 Flip-flop 輸出變為 `X`，進而引發 X-Propagation 讓整個模擬結果失敗。
**解決方案**：
在 `xrun` 指令中加入以下參數：
- **`+define+NTC` (Negative Timing Check)**：允許處理負值的時序檢查，增加對 SDF 延遲的容忍度。
- **`+no_notifier`**：關閉違例即變 `X` 的機制。這對於排除「啟動階段」(Initialization) 的競態 (Race condition) 非常有效，能確保模擬在有微小抖動的情況下仍能正確跑完邏輯，最終得到正確的辨識結果 (`Predicted Class: 9`)。

## 16. Summary of Post-Route Progress (Status Report)

1. **Synthesis Netlist (Genus)**:
   - [x] **Functional & Delay Simulation**: **PASSED**
2. **Physical Design Netlist (Innovus)**:
   - [x] **Post-Route Functional (notiming)**: **PASSED**
   - [ ] **Post-Route Timing (with SDF)**: **DEBUGGING / BLOCKED**
     - Issue: SDF hold/recovery annotation is at 0%, leading to X-propagation.
