import numpy as np
import matplotlib.pyplot as plt
from coptpy import COPT, Envr

plt.rcParams['font.sans-serif'] = ['SimHei', 'Microsoft YaHei', 'SimSun']
plt.rcParams['axes.unicode_minus'] = False

np.random.seed(456)

A = np.random.uniform(0, 3.5, (10, 2))
B = np.random.uniform(2, 5.5, (10, 2))

print("A集合的点：")
print(A)
print("\nB集合的点：")
print(B)

# 创建COPT环境和模型
env = Envr()
model = env.createModel("SVM")

# 决策变量
a1 = model.addVar(lb=-COPT.INFINITY, ub=COPT.INFINITY, name="a1")
a2 = model.addVar(lb=-COPT.INFINITY, ub=COPT.INFINITY, name="a2")
b = model.addVar(lb=-COPT.INFINITY, ub=COPT.INFINITY, name="b")

# 松弛变量
delta = []
for i in range(len(A)):
    delta.append(model.addVar(lb=0, name=f"delta_{i}"))

sigma = []
for j in range(len(B)):
    sigma.append(model.addVar(lb=0, name=f"sigma_{j}"))

# 目标函数
model.setObjective(sum(delta) + sum(sigma), COPT.MINIMIZE)

# 约束条件
for i in range(len(A)):
    model.addConstr(a1 * A[i][0] + a2 * A[i][1] + b + delta[i] >= 1, name=f"A_constraint_{i}")

for j in range(len(B)):
    model.addConstr(a1 * B[j][0] + a2 * B[j][1] + b - sigma[j] <= -1, name=f"B_constraint_{j}")

model.solve()

if model.status == COPT.OPTIMAL:
    a1_opt = a1.x
    a2_opt = a2.x
    b_opt = b.x
    
    print(f"\n最优解：")
    print(f"a1 = {a1_opt:.4f}")
    print(f"a2 = {a2_opt:.4f}")
    print(f"b = {b_opt:.4f}")
    print(f"目标函数值（总分类错误）= {model.objval:.4f}")
    
    print(f"\n分隔线方程：{a1_opt:.4f} * x1 + {a2_opt:.4f} * x2 + {b_opt:.4f} = 0")
    
    # 绘制图像
    plt.figure(figsize=(10, 8))
    
    # 绘制A集合的点（蓝色圆圈）
    plt.scatter(A[:, 0], A[:, 1], c='blue', marker='o', s=100, label='A集合', edgecolors='black')
    
    # 绘制B集合的点（红色叉号）
    plt.scatter(B[:, 0], B[:, 1], c='red', marker='x', s=100, label='B集合', linewidths=2)
    
    # 绘制分隔线 a1*x1 + a2*x2 + b = 0
    x1_range = np.linspace(-1, 8, 100)
    if abs(a2_opt) > 1e-6:
        x2_line = -(a1_opt * x1_range + b_opt) / a2_opt
        plt.plot(x1_range, x2_line, 'g-', linewidth=2,
                label=f'分隔线: {a1_opt:.2f}x1 + {a2_opt:.2f}x2 + {b_opt:.2f} = 0')
        
        # 绘制支持向量边界
        x2_upper = -(a1_opt * x1_range + b_opt - 1) / a2_opt
        x2_lower = -(a1_opt * x1_range + b_opt + 1) / a2_opt
        plt.plot(x1_range, x2_upper, 'g--', linewidth=1, alpha=0.5, label='边界线')
        plt.plot(x1_range, x2_lower, 'g--', linewidth=1, alpha=0.5)
    
    plt.xlabel('x1', fontsize=12)
    plt.ylabel('x2', fontsize=12)
    plt.title('不完全可分情况下的支持向量机', fontsize=14, fontweight='bold')
    plt.legend(fontsize=10)
    plt.grid(True, alpha=0.3)
    plt.axis('equal')
    plt.xlim(-1, 8)
    plt.ylim(-1, 8)
    
    plt.savefig('svm_result.png', dpi=300, bbox_inches='tight')
    print("\n图像已保存为 svm_result.png")
    
    plt.show()
else:
    print(f"求解失败，状态码：{model.status}")
