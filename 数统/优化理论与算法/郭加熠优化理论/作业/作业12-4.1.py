import numpy as np
import matplotlib.pyplot as plt

# ===================== 通用工具：Wolfe 线搜索 =====================
def wolfe_line_search(f, grad_f, x, d, c1=0.01, c2=0.9):
    t = 1.0
    alpha = 0.0
    beta = np.inf
    fx = f(x)
    gx = grad_f(x)
    gtd = np.dot(gx, d)
    while True:
        x_new = x + t * d
        ft = f(x_new)
        # 充分下降条件
        if ft > fx + c1 * t * gtd:
            beta = t
            t = 0.5 * (alpha + beta)
        else:
            gt = grad_f(x_new)
            gtd_t = np.dot(gt, d)
            # 曲率条件
            if gtd_t < c2 * gtd:
                alpha = t
                if beta == np.inf:
                    t = 2 * alpha
                else:
                    t = 0.5 * (alpha + beta)
            else:
                break
    return t

# ===================== (a) 问题函数：3.2 指数函数 =====================
def f_exp(x):
    x1, x2 = x
    return np.exp(x1 + 2*x2 - 0.1) + np.exp(x1 - 3*x2 - 0.1) + np.exp(-x1 - 0.1)

def grad_exp(x):
    x1, x2 = x
    e1 = np.exp(x1 + 2*x2 - 0.1)
    e2 = np.exp(x1 - 3*x2 - 0.1)
    e3 = np.exp(-x1 - 0.1)
    g1 = e1 + e2 - e3
    g2 = 2*e1 - 3*e2
    return np.array([g1, g2])

def hess_exp(x):
    x1, x2 = x
    e1 = np.exp(x1 + 2*x2 - 0.1)
    e2 = np.exp(x1 - 3*x2 - 0.1)
    e3 = np.exp(-x1 - 0.1)
    h11 = e1 + e2 + e3
    h12 = 2*e1 - 3*e2
    h22 = 4*e1 + 9*e2
    return np.array([[h11, h12], [h12, h22]])

# BFGS 算法
def bfgs(f, grad_f, x0, f_star, tol=1e-10, max_iter=200):
    n = len(x0)
    x = x0.copy()
    H = np.eye(n)
    hist = []
    for _ in range(max_iter):
        err = f(x) - f_star
        hist.append(err)
        if err < tol:
            break
        g = grad_f(x)
        d = -H @ g
        t = wolfe_line_search(f, grad_f, x, d)
        s = t * d
        x_new = x + s
        g_new = grad_f(x_new)
        y = g_new - g
        # BFGS 更新公式
        rho = 1.0 / np.dot(y, s)
        I = np.eye(n)
        H = (I - rho * np.outer(s, y)) @ H @ (I - rho * np.outer(y, s)) + rho * np.outer(s, s)
        x = x_new
    return hist

# 标准牛顿法
def newton_method(f, grad_f, hess_f, x0, f_star, tol=1e-10, max_iter=200):
    x = x0.copy()
    hist = []
    for _ in range(max_iter):
        err = f(x) - f_star
        hist.append(err)
        if err < tol:
            break
        g = grad_f(x)
        H = hess_f(x)
        d = -np.linalg.solve(H, g)
        t = wolfe_line_search(f, grad_f, x, d)
        x = x + t * d
    return hist

# ===================== (b) 非光滑凸函数 f(u,v) = |u| + 3v² =====================
def f_abs(x):
    u, v = x
    return np.abs(u) + 3 * v**2

def grad_abs(x):
    u, v = x
    du = 1.0 if u > 0 else -1.0
    dv = 6 * v
    return np.array([du, dv])

# 梯度下降（Wolfe线搜索）
def gradient_descent(f, grad_f, x0, f_star, tol=1e-10, max_iter=200):
    x = x0.copy()
    hist = []
    for _ in range(max_iter):
        err = f(x) - f_star
        hist.append(err)
        if err < tol:
            break
        g = grad_f(x)
        d = -g
        t = wolfe_line_search(f, grad_f, x, d)
        x = x + t * d
    return hist

# ===================== (c) 函数 f(u,v) = |u|³ + v + 0.5v² + 近端梯度 =====================
def f_cubic(x):
    u, v = x
    return np.abs(u)**3 + v + 0.5 * v**2

def grad_cubic(x):
    u, v = x
    du = 3 * (np.abs(u)**2) * np.sign(u)
    dv = 1.0 + v
    return np.array([du, dv])

def hess_cubic(x):
    u, v = x
    h11 = 6 * np.abs(u)
    h12 = 0.0
    h22 = 1.0
    return np.array([[h11, h12], [h12, h22]])

# 近端算子
def prox_th(x, t):
    u = x[0]
    v = x[1]
    abs_u = np.abs(u)
    if abs_u < 1e-12:
        u_new = 0.0
    else:
        sqrt_term = np.sqrt(1 + 12 * t * abs_u)
        u_new = np.sign(u) * (-1 + sqrt_term) / (6 * t)
    return np.array([u_new, v])

# 近端梯度法
def proximal_gradient(f, grad_g, x0, f_star, step=0.1, tol=1e-10, max_iter=200):
    x = x0.copy()
    hist = []
    for _ in range(max_iter):
        err = f(x) - f_star
        hist.append(err)
        if err < tol:
            break
        g = grad_g(x)
        x_temp = x - step * g
        x = prox_th(x_temp, step)
    return hist

# ===================== 主运行 & 绘图 =====================
if __name__ == "__main__":
    # -------- 4.1(a) BFGS vs 牛顿法 --------
    x0_exp = np.array([5.0, 2.0])
    x_star_exp = np.array([0.3*np.log(3/5)+0.2*np.log(2/5), 0.2*np.log(3/2)])
    f_star_exp = f_exp(x_star_exp)
    hist_n = newton_method(f_exp, grad_exp, hess_exp, x0_exp, f_star_exp)
    hist_bfgs_a = bfgs(f_exp, grad_exp, x0_exp, f_star_exp)

    plt.figure(figsize=(10,5))
    plt.semilogy(range(len(hist_n)), hist_n, label="Newton method")
    plt.semilogy(range(len(hist_bfgs_a)), hist_bfgs_a, label="BFGS with Wolfe line search")
    plt.xlabel("Iteration")
    plt.ylabel(r"$f(x_k)-f^*$")
    plt.title("BFGS vs Newton Method (Exponential Function)")
    plt.legend()
    plt.grid(True, which="both", ls="--")
    plt.show()

    # -------- 4.1(b) |u|+3v² : 梯度下降 vs BFGS --------
    x0_abs = np.array([2.0, 1.5])
    x_star_abs = np.array([0.0, 0.0])
    f_star_abs = f_abs(x_star_abs)
    hist_gd_b = gradient_descent(f_abs, grad_abs, x0_abs, f_star_abs, max_iter=100)
    hist_bfgs_b = bfgs(f_abs, grad_abs, x0_abs, f_star_abs, max_iter=100)

    plt.figure(figsize=(10,5))
    plt.semilogy(range(len(hist_gd_b)), hist_gd_b, label="Gradient Descent")
    plt.semilogy(range(len(hist_bfgs_b)), hist_bfgs_b, label="BFGS")
    plt.xlabel("Iteration")
    plt.ylabel(r"$f(x_k)-f^*$")
    plt.title(r"$f(u,v)=|u|+3v^2$: GD vs BFGS")
    plt.legend()
    plt.grid(True, which="both", ls="--")
    plt.show()

    # -------- 4.1(c) |u|³+v+0.5v²: 四种方法对比 --------
    x0_cubic = np.array([1.2, 0.8])
    x_star_cubic = np.array([0.0, -1.0])
    f_star_cubic = f_cubic(x_star_cubic)
    hist_gd_c = gradient_descent(f_cubic, grad_cubic, x0_cubic, f_star_cubic)
    hist_pg = proximal_gradient(f_cubic, grad_cubic, x0_cubic, f_star_cubic, step=0.08)
    hist_n_c = newton_method(f_cubic, grad_cubic, hess_cubic, x0_cubic, f_star_cubic)
    hist_bfgs_c = bfgs(f_cubic, grad_cubic, x0_cubic, f_star_cubic)

    plt.figure(figsize=(10,5))
    plt.semilogy(range(len(hist_gd_c)), hist_gd_c, label="Gradient method")
    plt.semilogy(range(len(hist_pg)), hist_pg, label="Proximal gradient")
    plt.semilogy(range(len(hist_n_c)), hist_n_c, label="Newton method")
    plt.semilogy(range(len(hist_bfgs_c)), hist_bfgs_c, label="BFGS")
    plt.xlabel("Iteration")
    plt.ylabel(r"$f(x_k)-f^*$")
    plt.title(r"$f(u,v)=|u|^3+v+\frac12 v^2$")
    plt.legend()
    plt.grid(True, which="both", ls="--")
    plt.show()