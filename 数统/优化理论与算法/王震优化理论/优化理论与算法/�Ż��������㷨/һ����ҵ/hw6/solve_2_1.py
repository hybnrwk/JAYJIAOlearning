"""
Problem 2.1: Maximum Flow and Minimum Cut using COPT solver
Network: s -> 1, s -> 2, 1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4, 3 -> t, 4 -> t
"""
import coptpy as cp
from coptpy import COPT

# ---------------------------------------------------------------
# Part 1: Maximum Flow LP
# ---------------------------------------------------------------
env = cp.Envr()
print("=" * 55)
print("Part 1 & 2: Maximum Flow Model (LP)")
print("=" * 55)

model = env.createModel("MaxFlow")
model.setParam(COPT.Param.Logging, 0)

# Variables: flow on each edge
xs1 = model.addVar(lb=0, ub=15, name="x_s1")
xs2 = model.addVar(lb=0, ub=5,  name="x_s2")
x12 = model.addVar(lb=0, ub=5,  name="x_12")
x13 = model.addVar(lb=0, ub=10, name="x_13")
x24 = model.addVar(lb=0, ub=8,  name="x_24")
x34 = model.addVar(lb=0, ub=7,  name="x_34")
x3t = model.addVar(lb=0, ub=6,  name="x_3t")
x4t = model.addVar(lb=0, ub=12, name="x_4t")
v   = model.addVar(lb=0, name="v")

# Objective
model.setObjective(v, COPT.MAXIMIZE)

# Flow conservation
model.addConstr(xs1 + xs2 == v,           name="source")
model.addConstr(xs1 == x12 + x13,         name="node1")
model.addConstr(xs2 + x12 == x24,         name="node2")
model.addConstr(x13 == x34 + x3t,         name="node3")
model.addConstr(x24 + x34 == x4t,         name="node4")
model.addConstr(x3t + x4t == v,           name="sink")

model.solve()

print(f"\nMax Flow value v = {model.objval:.4f}")
print("\nEdge flow assignments:")
for var in [xs1, xs2, x12, x13, x24, x34, x3t, x4t]:
    print(f"  {var.name:6s} = {var.x:.4f}")

# ---------------------------------------------------------------
# Part 2: Minimum Cut LP (continuous potential formulation)
# Variables: z_i (node potentials), y_ij (edge cut indicators)
# y_ij = max{z_i - z_j, 0}  linearized as:
#   y_ij >= z_i - z_j,  y_ij >= 0  (objective minimization handles the max)
# ---------------------------------------------------------------
print()
print("=" * 55)
print("Part 2: Minimum Cut Model (LP, continuous potentials)")
print("=" * 55)

mc = env.createModel("MinCut")
mc.setParam(COPT.Param.Logging, 0)

# Node potentials z_i in [0,1]
zs = mc.addVar(lb=0, ub=1, name="z_s")
z1 = mc.addVar(lb=0, ub=1, name="z_1")
z2 = mc.addVar(lb=0, ub=1, name="z_2")
z3 = mc.addVar(lb=0, ub=1, name="z_3")
z4 = mc.addVar(lb=0, ub=1, name="z_4")
zt = mc.addVar(lb=0, ub=1, name="z_t")

# Edge cut indicators y_ij >= 0
ys1 = mc.addVar(lb=0, name="y_s1")
ys2 = mc.addVar(lb=0, name="y_s2")
y12 = mc.addVar(lb=0, name="y_12")
y13 = mc.addVar(lb=0, name="y_13")
y24 = mc.addVar(lb=0, name="y_24")
y34 = mc.addVar(lb=0, name="y_34")
y3t = mc.addVar(lb=0, name="y_3t")
y4t = mc.addVar(lb=0, name="y_4t")

# Objective: minimize cut capacity
mc.setObjective(15*ys1 + 5*ys2 + 5*y12 + 10*y13 + 8*y24 + 7*y34 + 6*y3t + 12*y4t,
                COPT.MINIMIZE)

# Fix source and sink potentials
mc.addConstr(zs == 1, name="fix_s")
mc.addConstr(zt == 0, name="fix_t")

# y_ij >= z_i - z_j  (linearization of max{z_i - z_j, 0})
mc.addConstr(ys1 >= zs - z1, name="cut_s1")
mc.addConstr(ys2 >= zs - z2, name="cut_s2")
mc.addConstr(y12 >= z1 - z2,  name="cut_12")
mc.addConstr(y13 >= z1 - z3,  name="cut_13")
mc.addConstr(y24 >= z2 - z4,  name="cut_24")
mc.addConstr(y34 >= z3 - z4,  name="cut_34")
mc.addConstr(y3t >= z3 - zt,  name="cut_3t")
mc.addConstr(y4t >= z4 - zt,  name="cut_4t")

mc.solve()

print(f"\nMin Cut value = {mc.objval:.4f}")
print("\nNode potentials (z_s=1 fixed, z_t=0 fixed):")
for var in [zs, z1, z2, z3, z4, zt]:
    print(f"  {var.name:5s} = {var.x:.4f}")

print("\nEdge cut indicators y_ij = max{z_i - z_j, 0}:")
for yvar, cap, ename in [
    (ys1, 15, "(s,1)"), (ys2, 5, "(s,2)"), (y12, 5, "(1,2)"),
    (y13, 10, "(1,3)"), (y24, 8, "(2,4)"), (y34, 7, "(3,4)"),
    (y3t, 6, "(3,t)"),  (y4t, 12, "(4,t)")
]:
    mark = "  [IN CUT]" if yvar.x > 1e-6 else ""
    print(f"  {ename}  cap={cap:2d}  y={yvar.x:.4f}{mark}")

print()
print("=" * 55)
print("Max-Flow Min-Cut Theorem Verification")
print("=" * 55)
print(f"  Max flow value  = {model.objval:.4f}")
print(f"  Min cut value   = {mc.objval:.4f}")
equal = abs(model.objval - mc.objval) < 1e-6
print(f"  Equal? {'YES -- theorem holds!' if equal else 'NO -- check models'}")

# ---------------------------------------------------------------
# Part 3a: Modify capacity of (1,3) from 10 to 5
# ---------------------------------------------------------------
print()
print("=" * 55)
print("Part 3(a): Capacity of (1,3) changed from 10 to 5")
print("=" * 55)

m3a = env.createModel("MaxFlow_3a")
m3a.setParam(COPT.Param.Logging, 0)

xs1a = m3a.addVar(lb=0, ub=15, name="x_s1")
xs2a = m3a.addVar(lb=0, ub=5,  name="x_s2")
x12a = m3a.addVar(lb=0, ub=5,  name="x_12")
x13a = m3a.addVar(lb=0, ub=5,  name="x_13")   # changed: 10 -> 5
x24a = m3a.addVar(lb=0, ub=8,  name="x_24")
x34a = m3a.addVar(lb=0, ub=7,  name="x_34")
x3ta = m3a.addVar(lb=0, ub=6,  name="x_3t")
x4ta = m3a.addVar(lb=0, ub=12, name="x_4t")
va   = m3a.addVar(lb=0, name="v")

m3a.setObjective(va, COPT.MAXIMIZE)
m3a.addConstr(xs1a + xs2a == va)
m3a.addConstr(xs1a == x12a + x13a)
m3a.addConstr(xs2a + x12a == x24a)
m3a.addConstr(x13a == x34a + x3ta)
m3a.addConstr(x24a + x34a == x4ta)
m3a.addConstr(x3ta + x4ta == va)
m3a.solve()

print(f"\nNew Max Flow value v = {m3a.objval:.4f}")
print("\nEdge flow assignments:")
for var in [xs1a, xs2a, x12a, x13a, x24a, x34a, x3ta, x4ta]:
    print(f"  {var.name:6s} = {var.x:.4f}")

# ---------------------------------------------------------------
# Part 3b: Add edge (2,3) with capacity 6
# ---------------------------------------------------------------
print()
print("=" * 55)
print("Part 3(b): Add edge (2,3) with capacity 6")
print("=" * 55)

m3b = env.createModel("MaxFlow_3b")
m3b.setParam(COPT.Param.Logging, 0)

xs1b = m3b.addVar(lb=0, ub=15, name="x_s1")
xs2b = m3b.addVar(lb=0, ub=5,  name="x_s2")
x12b = m3b.addVar(lb=0, ub=5,  name="x_12")
x13b = m3b.addVar(lb=0, ub=10, name="x_13")
x23b = m3b.addVar(lb=0, ub=6,  name="x_23")   # new edge
x24b = m3b.addVar(lb=0, ub=8,  name="x_24")
x34b = m3b.addVar(lb=0, ub=7,  name="x_34")
x3tb = m3b.addVar(lb=0, ub=6,  name="x_3t")
x4tb = m3b.addVar(lb=0, ub=12, name="x_4t")
vb   = m3b.addVar(lb=0, name="v")

m3b.setObjective(vb, COPT.MAXIMIZE)
m3b.addConstr(xs1b + xs2b == vb)
m3b.addConstr(xs1b == x12b + x13b)
m3b.addConstr(xs2b + x12b == x24b + x23b)      # node 2 now has outflow to 3 as well
m3b.addConstr(x13b + x23b == x34b + x3tb)      # node 3 receives from 1 and 2
m3b.addConstr(x24b + x34b == x4tb)
m3b.addConstr(x3tb + x4tb == vb)
m3b.solve()

print(f"\nNew Max Flow value v = {m3b.objval:.4f}")
print("\nEdge flow assignments:")
for var in [xs1b, xs2b, x12b, x13b, x23b, x24b, x34b, x3tb, x4tb]:
    print(f"  {var.name:6s} = {var.x:.4f}")
