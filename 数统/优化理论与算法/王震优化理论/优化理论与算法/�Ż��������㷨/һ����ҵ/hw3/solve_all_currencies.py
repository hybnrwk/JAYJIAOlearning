import coptpy as cp
from coptpy import COPT

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

print("=" * 80)
print("不同起始货币的套利分析")
print("=" * 80)

results = []

# 对每种货币作为起始货币进行求解
for s in currencies:
    print(f"\n{'='*80}")
    print(f"起始货币：{currency_names[s]}")
    print(f"{'='*80}")
    
    # 创建环境和模型
    env = cp.Envr()
    model = env.createModel(f"arbitrage_from_{s}")
    
    # 决策变量：x[i,j] 表示从货币i兑换到货币j的金额
    x = {}
    for i in currencies:
        for j in currencies:
            if i != j:
                x[i, j] = model.addVar(lb=0, name=f"x_{i}_{j}")
    
    # 目标函数：最大化回到起始货币的总量
    obj_expr = cp.quicksum(x[j, s] * r[j, s] for j in currencies if j != s)
    model.setObjective(obj_expr, COPT.MAXIMIZE)
    
    # 约束1：从起始货币流出的总量为1
    model.addConstr(cp.quicksum(x[s, j] for j in currencies if j != s) == 1, 
                    name="start_flow")
    
    # 约束2：流量守恒（对于非起始货币）
    for i in currencies:
        if i != s:
            inflow = cp.quicksum(x[j, i] * r[j, i] for j in currencies if j != i)
            outflow = cp.quicksum(x[i, j] for j in currencies if j != i)
            model.addConstr(inflow == outflow, name=f"flow_conservation_{i}")
    
    # 求解模型
    if s in [2, 3]:  # 对欧元和英镑显示详细日志
        model.setParam(COPT.Param.Logging, 1)
    else:
        model.setParam(COPT.Param.Logging, 0)
    
    model.solve()
    
    print(f"\n求解状态：{model.status}")
    if model.status == COPT.INFEASIBLE:
        print("模型不可行！")
        # 尝试计算IIS
        try:
            model.computeIIS()
            print("不可行子系统（IIS）：")
            for constr in model.getConstrs():
                if constr.IISConstr:
                    print(f"  约束 {constr.name} 在IIS中")
        except:
            print("无法计算IIS")
    elif model.status == COPT.UNBOUNDED:
        print("模型无界！")
    
    if model.status == COPT.OPTIMAL:
        obj_val = model.objval
        profit = (obj_val - 1) * 100
        
        print(f"\n最优目标函数值：{obj_val:.8f}")
        print(f"套利收益：{profit:.6f}%")
        
        # 找出非零的兑换路径
        print(f"\n非零兑换路径：")
        path_found = False
        for (i, j), var in x.items():
            if var.x > 1e-6:
                path_found = True
                print(f"  {currency_names[i]} → {currency_names[j]}: {var.x:.6f} 单位{currency_names[i]}")
        
        if not path_found:
            print("  无兑换（起始货币直接回到自身）")
        
        # 保存结果
        results.append({
            'currency': currency_names[s],
            'obj_val': obj_val,
            'profit': profit,
            'has_arbitrage': obj_val > 1.0001
        })
    else:
        print(f"\n求解失败，状态码：{model.status}")
        results.append({
            'currency': currency_names[s],
            'obj_val': None,
            'profit': None,
            'has_arbitrage': False
        })

# 输出汇总结果
print("\n" + "=" * 80)
print("汇总结果")
print("=" * 80)
print(f"\n{'起始货币':<10} {'最优值':<15} {'套利收益(%)':<15} {'是否存在套利'}")
print("-" * 80)

for res in results:
    if res['obj_val'] is not None:
        arbitrage_str = "是" if res['has_arbitrage'] else "否"
        print(f"{res['currency']:<12} {res['obj_val']:<15.8f} {res['profit']:<15.6f} {arbitrage_str}")
    else:
        print(f"{res['currency']:<12} {'求解失败':<15} {'-':<15} {'否'}")

print("=" * 80)

# 结论
print("\n结论：")
print("-" * 80)
arbitrage_currencies = [res['currency'] for res in results if res['has_arbitrage']]
if arbitrage_currencies:
    print(f"存在套利机会的起始货币：{', '.join(arbitrage_currencies)}")
    max_profit_res = max([res for res in results if res['obj_val'] is not None], 
                         key=lambda x: x['profit'])
    print(f"最大套利收益：{max_profit_res['profit']:.6f}%（起始货币：{max_profit_res['currency']}）")
else:
    print("所有起始货币均不存在明显的套利机会。")
print("=" * 80)
