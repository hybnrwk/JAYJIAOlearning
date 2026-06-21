import coptpy as cp
from coptpy import COPT
import numpy as np

# 创建环境和模型
env = cp.Envr()
model = env.createModel("multiperiod_currency_arbitrage")

# 货币编号：1=美元，2=欧元，3=英镑，4=日元
currencies = [1, 2, 3, 4]
currency_names = {1: "美元", 2: "欧元", 3: "英镑", 4: "日元"}

# 时期数
T = 4  # 总共T个时期，t = 0, 1, ..., T-1

# 汇率矩阵 r[i][j] 表示从货币i兑换到货币j的汇率
r = {
    (1, 2): 1.1486, (1, 3): 0.7003, (1, 4): 133.38,
    (2, 1): 0.8706, (2, 3): 0.6097, (2, 4): 116.12,
    (3, 1): 1.4279, (3, 2): 1.6401, (3, 4): 190.45,
    (4, 1): 0.00750, (4, 2): 0.00861, (4, 3): 0.00525
}

# 决策变量
# x[i,j,t] 表示在时期t从货币i兑换到货币j的金额
x = {}
for i in currencies:
    for j in currencies:
        if i != j:
            for t in range(T):
                x[i, j, t] = model.addVar(lb=0, name=f"x_{i}_{j}_{t}")

# 状态变量
# y[i,t] 表示在时期t末尾持有货币i的金额
y = {}
for i in currencies:
    for t in range(T + 1):
        y[i, t] = model.addVar(lb=0, name=f"y_{i}_{t}")

# 起始货币
s = 1

# 初始条件
model.addConstr(y[s, 0] == 1, name="initial_s")
for i in currencies:
    if i != s:
        model.addConstr(y[i, 0] == 0, name=f"initial_{i}")

# 目标函数：最大化最终回到起始货币的总量
obj_expr = y[s, T]
model.setObjective(obj_expr, COPT.MAXIMIZE)

# 约束
# 1. 流量约束：某一时期内兑换金额不能超过当前持有量
for i in currencies:
    for t in range(T):
        outflow = cp.quicksum(x[i, j, t] for j in currencies if j != i)
        model.addConstr(outflow <= y[i, t], name=f"flow_limit_{i}_{t}")

# 2. 动态方程：y[i,t+1] = y[i,t] - 出流 + 进流
for i in currencies:
    for t in range(T):
        outflow = cp.quicksum(x[i, j, t] for j in currencies if j != i)
        inflow = cp.quicksum(x[j, i, t] * r[j, i] for j in currencies if j != i)
        model.addConstr(y[i, t+1] == y[i, t] - outflow + inflow, 
                       name=f"dynamics_{i}_{t}")

# 求解模型
model.solve()

# 输出结果
print("=" * 70)
print("多时期外汇套利问题求解结果")
print("=" * 70)
print(f"时期数: T = {T}")
print(f"起始货币: {currency_names[s]}")
print()

if model.status == COPT.OPTIMAL:
    print(f"最优目标函数值: z* = {model.objVal:.10f}")
    print()
    
    # 输出各时期持有的货币金额
    print("各时期货币持有量:")
    print("-" * 70)
    for t in range(T + 1):
        print(f"时期 t={t}:")
        for i in currencies:
            y_val = y[i, t].X
            if y_val > 1e-6:
                print(f"  {currency_names[i]}: {y_val:.10f}")
    print()
    
    # 输出非零的兑换活动
    print("各时期兑换活动:")
    print("-" * 70)
    for t in range(T):
        print(f"时期 t={t}:")
        has_activity = False
        for i in currencies:
            for j in currencies:
                if i != j and (i, j, t) in x:
                    x_val = x[i, j, t].X
                    if x_val > 1e-6:
                        print(f"  {currency_names[i]} → {currency_names[j]}: {x_val:.10f} {currency_names[i]}")
                        print(f"    兑换得到: {x_val * r[i, j]:.10f} {currency_names[j]}")
                        has_activity = True
        if not has_activity:
            print(f"  无兑换活动")
    print()
    
    # 计算套利收益
    profit_rate = (model.objVal - 1) * 100
    print(f"套利收益: {model.objVal - 1:.10f}")
    print(f"套利收益率: {profit_rate:.6f}%")
    print()
    
elif model.status == COPT.UNBOUNDED:
    print("模型无界 - 存在无限套利机会！")
    
elif model.status == COPT.INFEASIBLE:
    print("模型不可行")
    
else:
    print(f"求解状态: {model.status}")
