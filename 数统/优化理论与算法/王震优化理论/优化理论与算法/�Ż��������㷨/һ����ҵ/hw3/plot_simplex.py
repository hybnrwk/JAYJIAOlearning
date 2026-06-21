import matplotlib.pyplot as plt
import numpy as np

# 设置中文字体
plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文标签
plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号

# 创建图形
fig, ax = plt.subplots(figsize=(8, 8))

# 定义可行域的顶点
vertices = np.array([[0, 0], [2, 0], [4, 2], [0, 6], [0, 0]])

# 绘制可行域（填充）
feasible_region = plt.Polygon(vertices[:-1], alpha=0.3, color='lightblue', label='可行域')
ax.add_patch(feasible_region)

# 绘制约束线
x = np.linspace(-0.5, 7, 100)

# x1 + x2 = 6
y1 = 6 - x
ax.plot(x, y1, 'b-', linewidth=2, label='$x_1 + x_2 = 6$')

# x1 - x2 = 2
y2 = x - 2
ax.plot(x, y2, 'r-', linewidth=2, label='$x_1 - x_2 = 2$')

# 绘制坐标轴
ax.axhline(y=0, color='k', linewidth=0.5)
ax.axvline(x=0, color='k', linewidth=0.5)

# 标注顶点
points = {
    'A(0,0)': (0, 0),
    'B(2,0)': (2, 0),
    'C(4,2)': (4, 2),
    'D(0,6)': (0, 6)
}

for label, (x, y) in points.items():
    ax.plot(x, y, 'ko', markersize=8)
    if label == 'A(0,0)':
        ax.text(x-0.3, y-0.4, label, fontsize=12, fontweight='bold')
    elif label == 'B(2,0)':
        ax.text(x, y-0.5, label, fontsize=12, fontweight='bold')
    elif label == 'C(4,2)':
        ax.text(x+0.2, y+0.2, label, fontsize=12, fontweight='bold', color='red')
    else:  # D
        ax.text(x-0.6, y, label, fontsize=12, fontweight='bold')

# 绘制单纯形算法路径
path_x = [0, 2, 4]
path_y = [0, 0, 2]
ax.plot(path_x, path_y, 'g->', linewidth=3, markersize=10, label='单纯形路径')

# 添加迭代标注
ax.text(1, -0.7, '迭代1', fontsize=11, color='green', fontweight='bold')
ax.text(3, 0.5, '迭代2', fontsize=11, color='green', fontweight='bold')

# 绘制目标函数等值线（示意）
# z = -2x1 - x2, 即 2x1 + x2 = -z
for z_val in [-4, -6, -10]:
    x_line = np.linspace(0, 6, 100)
    y_line = -z_val - 2 * x_line
    ax.plot(x_line, y_line, '--', color='purple', alpha=0.5, linewidth=1)
    # 标注等值线
    if z_val == -10:
        ax.text(4.5, 1, f'z={z_val}', fontsize=10, color='purple')
    elif z_val == -6:
        ax.text(3, 0.5, f'z={z_val}', fontsize=10, color='purple')
    elif z_val == -4:
        ax.text(1.5, 1.5, f'z={z_val}', fontsize=10, color='purple')
    
    

# 设置坐标轴范围和标签
ax.set_xlim(-0.5, 7)
ax.set_ylim(-1, 7)
ax.set_xlabel('$x_1$', fontsize=14)
ax.set_ylabel('$x_2$', fontsize=14)
ax.set_title('可行域与单纯形算法路径', fontsize=16, fontweight='bold')
ax.grid(True, alpha=0.3)
ax.legend(loc='upper right', fontsize=11)

# 设置纵横比
ax.set_aspect('equal')

# 保存图形
plt.tight_layout()
plt.savefig('simplex_path.png', dpi=300, bbox_inches='tight')
print("图形已保存为 simplex_path.png")
