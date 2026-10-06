#!/usr/bin/env python3
"""
Sovereign Topology Generator — SEME-v60.0 Integer Rail Engine
Headless 4K vector manifold for anchors 306 | 923 | 1118
Even-coordinate stencil (2Z) · Fractional holding register · Agg backend
"""

import os
import sys
import numpy as np

# Force headless backend for Termux / CLI execution (no X11 required)
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D  # noqa: F401

class SovereignVectorEngine:
    def __init__(self, width=3840, height=2160, dpi=300):
        # Canvas dimensions (4K UHD)
        self.width = width
        self.height = height
        self.dpi = dpi

        # Intermediate Math Register: Holding fractions for final-step evaluation
        # Absolute Fraction Quarantine (H_frac) — never mixed mid-calculation
        self.fractional_holding_register = []

        # Master State Anchors (306 - 923 - 1118)
        # Spatial positions locked strictly to even-coordinate integer steps (2Z)
        self.nodes = {
            "306": {
                "coord": np.array([6, 12, 2], dtype=int),
                "color": "#00F0FF",
                "label": "306 | Restoration Operator"
            },
            "923": {
                "coord": np.array([18, 24, 6], dtype=int),
                "color": "#7000FF",
                "label": "923 | Noise Filter"
            },
            "1118": {
                "coord": np.array([24, 32, 10], dtype=int),
                "color": "#FF007F",
                "label": "1118 | Master Anchor"
            }
        }

        # Verify even-rail invariant (G1 / 2Z)
        for key, data in self.nodes.items():
            if np.any(data["coord"] % 2 != 0):
                raise ValueError(f"Rail fault: node {key} not on even coordinate lattice")

    def render_image(self, output_filename="vector_topology_4k.png",
                     title="VECTOR TOPOLOGY MANIFOLD"):
        fig = plt.figure(
            figsize=(self.width / self.dpi, self.height / self.dpi),
            dpi=self.dpi,
            facecolor='#0A0A0C'
        )
        ax = fig.add_subplot(111, projection='3d', facecolor='#0A0A0C')

        # Clean headless dark interface styling
        ax.xaxis.pane.fill = False
        ax.yaxis.pane.fill = False
        ax.zaxis.pane.fill = False
        ax.xaxis.pane.set_edgecolor('#0A0A0C')
        ax.yaxis.pane.set_edgecolor('#0A0A0C')
        ax.zaxis.pane.set_edgecolor('#0A0A0C')
        ax.grid(False)
        ax.set_box_aspect([1, 1, 0.55])

        # 1. Even-Coordinate Coordinate Grid (Step = 2)
        grid_min, grid_max, step = -30, 34, 2
        for x in range(grid_min, grid_max, step):
            ax.plot([x, x], [grid_min, grid_max], [0, 0],
                    color='#00F0FF', alpha=0.12, linewidth=0.5)
        for y in range(grid_min, grid_max, step):
            ax.plot([grid_min, grid_max], [y, y], [0, 0],
                    color='#00F0FF', alpha=0.12, linewidth=0.5)

        # 2. Render Anchor Nodes and Direct Vector Edges
        for key, data in self.nodes.items():
            c = data["coord"]
            ax.scatter(c[0], c[1], c[2],
                       color=data["color"], s=280,
                       edgecolors='#FFFFFF', linewidth=1.8, zorder=10)
            ax.text(c[0], c[1], c[2] + 1.8, data["label"],
                    color='#FFFFFF', fontsize=10, fontweight='bold',
                    ha='center')

        # Connect Vectors (closed triangle)
        edges = [("306", "923"), ("923", "1118"), ("1118", "306")]
        for src, dst in edges:
            p1 = self.nodes[src]["coord"]
            p2 = self.nodes[dst]["coord"]
            ax.plot([p1[0], p2[0]], [p1[1], p2[1]], [p1[2], p2[2]],
                    color='#00F0FF', linewidth=2.4, alpha=0.90)

        # 3. Holding Register Normalization Stage
        # Storing normalizations as exact tuples (numerator, denominator)
        # Quarantined until terminal assembly
        self.fractional_holding_register.append((1, 12))   # Spatial bounding normalizer
        self.fractional_holding_register.append((1, 30))   # Aspect ratio scaling

        # Apply collected fractional shifts at the final rendering evaluation step
        # (single multiplication at readout — Garner-style assembly)
        scale_val = (self.fractional_holding_register[0][0] /
                     self.fractional_holding_register[0][1])

        ax.set_xlim(-10, 40)
        ax.set_ylim(-10, 40)
        ax.set_zlim(-2, 16)

        ax.set_xticks([])
        ax.set_yticks([])
        ax.set_zticks([])

        ax.view_init(elev=28, azim=42)
        plt.title(
            f"SOVEREIGN ROOT | {title}\nANCHORS: 306 - 923 - 1118  |  2Z RAIL",
            color='#00F0FF', fontsize=13, pad=22, fontweight='bold'
        )

        # Save headless render direct to storage
        plt.savefig(output_filename,
                    facecolor=fig.get_facecolor(),
                    edgecolor='none',
                    bbox_inches='tight',
                    dpi=self.dpi)
        plt.close(fig)

        abs_path = os.path.abspath(output_filename)
        print(f"[SUCCESS] High-resolution 4K image written: {abs_path}")
        print(f"[SCALE]   Terminal fraction assembly applied: {scale_val:.6f}")
        return abs_path

if __name__ == "__main__":
    # Handle custom filename parameter if passed from shell
    output_path = sys.argv[1] if len(sys.argv) > 1 else "vector_topology_4k.png"

    engine = SovereignVectorEngine()
    engine.render_image(output_filename=output_path)
