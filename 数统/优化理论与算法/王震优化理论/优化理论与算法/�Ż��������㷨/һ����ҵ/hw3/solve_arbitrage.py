import coptpy as cp
from coptpy import COPT

# 创建环境和模型
env = cp.Envr()
model = env.createModel("currency_arbitrage")

# 货币编号：1=美元，2=欧元，3=英镑，4=日元
currencies = [1, 2, 3, 4]
currency_names = {1: "美元", 2: "欧元", 3: "英镑", 4: "日元"}

# 汇率矩阵 r[i][j] 表示从货币i兑换到货币j的汇率
r = {
    (1, 2): 1.1486, (1, 3): 0.7003, (1, 4): 133.38,
    (2, 1): 0.8706, (2, 3): 0.6097, (2, 4): 116.12,
    (3, 1): 1.4279, (3, 2): 1.6401, (3, 4): 190.45,
    (4, 1): 0.00750, (4, 2): 0.00861, (4, 3): 0.00525
}

# 决策变量：x[i,j] 表示从货币i兑换到货币j的金额
x = {}
for i in currencies:
    for j in currencies:
        if i != j:
            x[i, j] = model.addVar(lb=0, name=f"x_{i}_{j}")

# 目标函数：最大化回到美元的总量
s = 1  # 起始货币为美元
obj_expr = cp.quicksum(x[j, s] * r[j, s] for j in currencies if j != s)
model.setObjective(obj_expr, COPT.MAXIMIZE)

# 约束1：从起始货币流出的总量为1
model.addConstr(cp.quicksum(x[s, j] for j in currencies if j != s) == 1, name="start_flow")

# 约束2：流量守恒（对于非起始货币）
for i in currencies:
    if i != s:
        inflow = cp.quicksum(x[j, i] * r[j, i] for j in currencies if j != i)
        outflow = cp.quicksum(x[i, j] for j in currencies if j != i)
        model.addConstr(inflow == outflow, name=f"flow_conservation_{i}")

# 求解模型
model.solve()

# 输出结果
print("=" * 60)
print("外汇套利问题求解结果")
print("=" * 60)

if model.status == COPT.OPTIMAL:
    print(f"\n最优目标函数值：{model.objval:.6f}")
    
    if model.objval > 1.0001:  # 考虑数值误差
        print("\n结论：存在套利机会！")
        print(f"套利收益：{(model.objval - 1) * 100:.4f}%")
    else:
        print("\n结论：不存在明显的套利机会。")
    
    print("\n最优兑换方案：")
    print("-" * 60)
    
    # 找出所有变量的解
    print("\n所有决策变量的值：")
    print("-" * 60)
    for (i, j), var in sorted(x.items()):
        print(f"x_{i}{j} = {var.x:.8f}")
    
    print("\n非零兑换路径：")
    print("-" * 60)
    paths = []
    for (i, j), var in x.items():
        if var.x > 1e-6:  # 只显示非零的兑换
            paths.append((i, j, var.x))
            print(f"{currency_names[i]} → {currency_names[j]}: {var.x:.6f} 单位{currency_names[i]}")
    
    # 追踪套利路径
    print("\n套利路径追踪：")
    print("-" * 60)
    
    # 从美元开始追踪
    current = s
    amount = 1.0
    path_str = f"起始：1.0000 {currency_names[current]}"
    visited = set()
    
    while True:
        if current in visited and current == s:
            break
        visited.add(current)
        
        # 找到从current出发的最大流量
        next_currency = None
        max_flow = 0
        for (i, j), var in x.items():
            if i == current and var.x > max_flow:
                max_flow = var.x
                next_currency = j
        
        if next_currency is None or max_flow < 1e-6:
            break
        
        # 计算兑换后的金额
        amount = max_flow * r[current, next_currency]
        path_str += f" → {amount:.6f} {currency_names[next_currency]}"
        current = next_currency
        
        if current == s:
            break
    
    print(path_str)
    print(f"\n最终回到{currency_names[s]}：{model.objval:.6f} 单位")
    
else:
    print(f"\n求解失败，状态码：{model.status}")

print("=" * 60)
