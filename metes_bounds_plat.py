import math

class HoldingRegister:
    def __init__(self):
        self.stack = []

    def push(self, num: int, den: int):
        self.stack.append((num, den))

    def evaluate(self) -> float:
        n, d = 1, 1
        for num, den in self.stack:
            n *= num
            d *= den
        return float(n) / float(d)

def generate_mesh():
    holding = HoldingRegister()
    holding.push(1, 100)  # 1 link = 1/100 chain
    holding.push(66, 1)   # 1 chain = 66 ft

    survey_data = [
        {'quadrant': 'NE', 'deg': 45, 'min': 0, 'chains': 10, 'links': 25},
        {'quadrant': 'SE', 'deg': 30, 'min': 15, 'chains': 14, 'links': 50},
        {'quadrant': 'SW', 'deg': 60, 'min': 45, 'chains': 8, 'links': 75},
        {'quadrant': 'NW', 'deg': 15, 'min': 30, 'chains': 12, 'links': 10}
    ]

    scale = holding.evaluate()
    x, y = 0.0, 0.0
    points = [(0.0, 0.0, 0.0)]

    for call in survey_data:
        total_links = (call['chains'] * 100) + call['links']
        angle_rad = math.radians(call['deg'] + call['min']/60.0)
        
        dx = total_links * math.sin(angle_rad) * (1 if 'E' in call['quadrant'] else -1)
        dy = total_links * math.cos(angle_rad) * (1 if 'N' in call['quadrant'] else -1)
        
        x += dx * scale
        y += dy * scale
        points.append((x, y, 0.0))

    with open("land_patent_plat.ply", "w") as f:
        f.write(f"ply\nformat ascii 1.0\nelement vertex {len(points)}\n")
        f.write("property float x\nproperty float y\nproperty float z\nend_header\n")
        for pt in points:
            f.write(f"{pt[0]:.6f} {pt[1]:.6f} {pt[2]:.6f}\n")

    print(f"[PLY] Successfully exported {len(points)} nodes to land_patent_plat.ply")

if __name__ == "__main__":
    generate_mesh()
