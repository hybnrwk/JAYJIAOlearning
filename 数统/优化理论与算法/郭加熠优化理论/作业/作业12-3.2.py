import numpy as np
import matplotlib.pyplot as plt

# 目标函数
def f(x):
    x1, x2 = x
    return np.exp(x1 + 2*x2 - 0.1) + np.exp(x1 - 3*x2 - 0.1) + np.exp(-x1 - 0.1)

# 梯度
def grad_f(x):
    x1, x2 = x
    g1 = np.exp(x1 + 2*x2 - 0.1) + np.exp(x1 - 3*x2 - 0.1) - np.exp(-x1 - 0.1)
    g2 = 2 * np.exp(x1 + 2*x2 - 0.1) - 3 * np.exp(x1 - 3*x2 - 0.1)
    return np.array([g1, g2])

# 海森矩阵
def hess_f(x):
    x1, x2 = x
    e1 = np.exp(x1 + 2*x2 - 0.1)
    e2 = np.exp(x1 - 3*x2 - 0.1)
    e3 = np.exp(-x1 - 0.1)
    h11 = e1 + e2 + e3
    h12 = 2 * e1 - 3 * e2
    h22 = 4 * e1 + 9 * e2
    return np.array([[h11, h12], [h12, h22]])

# 理论最优解与最优值
x_star = np.array([(3/10)*np.log(3/5) + (2/10)*np.log(2/5), (1/5)*np.log(3/2)])
f_star = f(x_star)
tol = 1e-10
x0 = np.array([5.0, 2.0])
alpha = 0.1
beta = 0.5

# 回溯线搜索
def backtracking(x, d):
    t = 1.0
    while f(x + t * d) > f(x) + alpha * t * np.dot(grad_f(x), d):
        t *= beta
    return t

# 标准阻尼牛顿法
def damped_newton(x_init, f_opt, tolerance):
    x = x_init.copy()
    hist = []
    while True:
        err = f(x) - f_opt
        hist.append(err)
        if err < tolerance:
            break
        g = grad_f(x)
        H = hess_f(x)
        d = -np.linalg.solve(H, g)
        step = backtracking(x, d)
        x += step * d
    return hist

# 重复利用海森矩阵 (每N次更新一次H)
def newton_reuse_hess(x_init, f_opt, tolerance, N=5):
    x = x_init.copy()
    hist = []
    H = None
    k = 0
    while True:
        err = f(x) - f_opt
        hist.append(err)
        if err < tolerance:
            break
        g = grad_f(x)
        if k % N == 0 or H is None:
            H = hess_f(x)
        d = -np.linalg.solve(H, g)
        step = backtracking(x, d)
        x += step * d
        k += 1
    return hist

# 海森矩阵对角近似
def newton_diag_hess(x_init, f_opt, tolerance):
    x = x_init.copy()
    hist = []
    while True:
        err = f(x) - f_opt
        hist.append(err)
        if err < tolerance:
            break
        g = grad_f(x)
        H_full = hess_f(x)
        H_diag = np.diag(np.diag(H_full))
        d = -np.linalg.solve(H_diag, g)
        step = backtracking(x, d)
        x += step * d
    return hist

# 运行三种算法
hist_full = damped_newton(x0, f_star, tol)
hist_reuse = newton_reuse_hess(x0, f_star, tol, N=5)
hist_diag = newton_diag_hess(x0, f_star, tol)

# 绘图
plt.figure(figsize=(10, 6))
plt.semilogy(range(len(hist_full)), hist_full, label='Full Hessian matrix', linewidth=2)
plt.semilogy(range(len(hist_reuse)), hist_reuse, label='Reuse Hessian matrix, N=5', linewidth=2)
plt.semilogy(range(len(hist_diag)), hist_diag, label='diag approx Hessian matrix', linewidth=2)
plt.xlabel('iteration numbers')
plt.ylabel(r'$f(x_k)-f^*$')
plt.title('Convergence curve of Different Hessian matrix method')
plt.legend()
plt.grid(True, which="both", linestyle='--')
plt.show()