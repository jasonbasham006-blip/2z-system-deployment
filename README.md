# 2Z Ring Buffer & Patent Processing System

**Polarization Root:** `923_1118`  
**Integer Rail Engine (IRE)** with Adèlic-Galois Extension \\(\\mathbb{A}_{\\mathbb{Q},2\\mathbb{Z}}\\)

## Components

| File | Description |
|------|-------------|
| `secded_2z.sv` | (22,16) SECDED Encoder/Decoder with 2Z rail verification (LSB == 0) |
| `tb_secded.sv` | SystemVerilog testbench for single-bit fault injection (word 306) |
| `rns_patent_map.smt2` | SMT-LIB2 RNS patent index constraints (moduli 17/19/23, gates 923/1118/306) |
| `ring_buffer.rs` | Rust 2Z ring-buffer engine with HoldingRegister quarantine |
| `metes_bounds_plat.py` | Metes-and-bounds survey → PLY point-cloud mesh generator |
| `sovereign_topology_generator.py` | **NEW** Headless 4K Agg 3D vector manifold for anchors 306-923-1118 |
| `deploy_2z_system.sh` | Automated Termux/Linux deployment & verification script |

## Quick Start (Termux / Linux)

```bash
bash deploy_2z_system.sh
```

### Topology Generator (4K PNG)
```bash
pip install numpy matplotlib   # if needed
python3 sovereign_topology_generator.py
# or custom name:
python3 sovereign_topology_generator.py custom_node_manifold.png
```

## Mathematical Anchors (SEME-v60.0)

- **G1 Occupied Zero:** \\(S(0)=1\\)
- **2Z Rail:** All payload LSBs / spatial coords forced even
- **RNS Moduli:** \\(\\{17,19,23\\}\\)
- **Filter Constants:** 306, 923, 1118
- **CRT Coordinate:** \\(X_{\\rm CRT}=3398738\\)

## Verification Status

All modules pass local integer-rail and parity checks under the active polarization key.
Topology generator produces 4K PNG under pure Agg backend (no X11 required).
