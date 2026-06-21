import coptpy as cp
from coptpy import COPT
import numpy as np

# 货币编号：1=美元，2=欧元，3=英镑，4=日元
currencies = [1, 2, 3, 4]
currency_names = {1: "美元", 2: "欧元", 3: "英镑", 4: "日元"}

# 时期数
T = 4

# 汇率矩阵 r[i][j] 表示从货币i兑换到货币j的汇率
r = {
    (1, 2): 1.1486, (1, 3): 0.7003, (1, 4): 133.38,
    (2, 1): 0.8706, (2, 3): 0.6097, (2, 4): 116.12,
    (3, 1): 1.4279, (3, 2): 1.6401, (3, 4): 190.45,
    (4, 1): 0.00750, (4, 2): 0.00861, (4, 3): 0.00525
}

print("=" * 70)
print("多时期外汇套利问题 - 不同初始货币分析")
print("=" * 70)
print(f"时期数: T = {T}\n")

# 为每个货币作为起始货币进行求解
results = {}

for s in currencies:
    print(f"\n{'='*70}")
    print(f"初始货币: {currency_names[s]}")
    print(f"{'='*70}")
    
    # 创建环境和模型
    env = cp.Envr()
    model = env.createModel(f"multiperiod_arbitrage_start_{s}")
    
    # 决策变量
    x = {}
    for i in currencies:
        for j in currencies:
            if i != j:
                for t in range(T):
                    x[i, j, t] = model.addVar(lb=0, name=f"x_{i}_{j}_{t}")
    
    # 状态变量
    y = {}
    for i in currencies:
        for t in range(T + 1):
            y[i, t] = model.addVar(lb=0, name=f"y_{i}_{t}")
    
    # 初始条件
    model.addConstr(y[s, 0] == 1, name="initial_s")
    for i in currencies:
        if i != s:
            model.addConstr(y[i, 0] == 0, name=f"initial_{i}")
    
    # 目标函数：最大化最终回到起始货币的总量
    obj_expr = y[s, T]
    model.setObjective(obj_expr, COPT.MAXIMIZE)
    
    # 约束
    # 1. 流量约束
    for i in currencies:
        for t in range(T):
            outflow = cp.quicksum(x[i, j, t] for j in currencies if j != i)
            model.addConstr(outflow <= y[i, t], name=f"flow_limit_{i}_{t}")
    
    # 2. 动态方程
    for i in currencies:
        for t in range(T):
            outflow = cp.quicksum(x[i, j, t] for j in currencies if j != i)
            inflow = cp.quicksum(x[j, i, t] * r[j, i] for j in currencies if j != i)
            model.addConstr(y[i, t+1] == y[i, t] - outflow + inflow, 
                           name=f"dynamics_{i}_{t}")
    
    # 求解模型
    model.solve()
    
    if model.status == COPT.OPTIMAL:
        obj_val = model.objVal
        profit = obj_val - 1
        profit_rate = profit * 100
        
        results[s] = {
            'status': 'OPTIMAL',
            'obj_val': obj_val,
            'profit': profit,
            'profit_rate': profit_rate
        }
        
        print(f"求解状态: 最优")
        print(f"最优目标函数值: {obj_val:.10f}")
        print(f"套利收益: {profit:.10f}")
        print(f"套利收益率: {profit_rate:.6f}%")
        
        # 输出非零的兑换活动（简要版本）
        print(f"\n兑换活动（非零项）:")
        for t in range(T):
            has_activity = False
            for i in currencies:
                for j in currencies:
                    if i != j and (i, j, t) in x:
                        x_val = x[i, j, t].X
                        if x_val > 1e-6:
                            if not has_activity:
                                print(f"  时期 t={t}:")
                                has_activity = True
                            print(f"    {currency_names[i]} → {currency_names[j]}: {x_val:.6f}")
    
    elif model.status == COPT.UNBOUNDED:
        results[s] = {
            'status': 'UNBOUNDED',
            'obj_val': float('inf'),
            'profit': float('inf'),
            'profit_rate': float('inf')
        }
        print(f"求解状态: 无界 - 存在无限套利机会")
    
    else:
        results[s] = {
            'status': str(model.status),
            'obj_val': None,
            'profit': None,
            'profit_rate': None
        }
        print(f"求解状态: {model.status}")

# 汇总结果表
print(f"\n{'='*70}")
print("汇总结果")
print(f"{'='*70}\n")

print(f"{'初始货币':<10} {'最优解':<18} {'套利收益':<15} {'收益率':<12}")
print("-" * 70)

for s in currencies:
    name = currency_names[s]
    if results[s]['status'] == 'OPTIMAL':
        obj_val = results[s]['obj_val']
        profit = results[s]['profit']
        profit_rate = results[s]['profit_rate']
        print(f"{name:<10} {obj_val:<18.10f} {profit:<15.10f} {profit_rate:>10.6f}%")
    else:
        print(f"{name:<10} {results[s]['status']:<18} {'--':<15} {'--':>10}")

print("\n")
