# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt
import time

# ==============================================================================
# 1. 生成模拟定位数据：m个锚点A，n个待求未知节点X_true，带噪声距离D
# ==============================================================================
def generate_data(m=100, n=50, sigma=0.1, seed=42):
    rng = np.random.default_rng(seed)
    A = rng.uniform(0, 10, size=(m, 2))
    X_true = rng.uniform(0, 10, size=(n, 2))
    # 真实距离矩阵 D_true[m,n]
    D_true = ((A[:, None, :] - X_true[None, :, :]) ** 2).sum(axis=2)
    # 加高斯噪声
    D = D_true + rng.normal(0, sigma, size=(m, n))
    # 初始猜测 X0
    X0 = rng.uniform(0, 10, size=(n, 2))
    return A, X_true, D, X0, rng

# ==============================================================================
# 2. 目标函数：平均最小二乘损失
# ==============================================================================
def objective_loc(X, A, D):
    # R_{i,j} = ||A_i - X_j||^2 - D_{i,j}
    R = ((A[:, None, :] - X[None, :, :]) ** 2).sum(axis=2) - D
    return np.mean(R ** 2)

# ==============================================================================
# 3. 全梯度（精确梯度）
# ==============================================================================
def full_grad_loc(X, A, D):
    m, n = D.shape
    R = ((A[:, None, :] - X[None, :, :]) ** 2).sum(axis=2) - D
    # grad_j = 4/(mn) * sum_{i} R_{i,j} (X_j - A_i)
    G = (4.0 / (m * n)) * np.einsum('ij,ijd->jd', R, X[None, :, :] - A[:, None, :])
    return G

# ==============================================================================
# 4. 小批量梯度（采样(i,j)对）
# ==============================================================================
def batch_grad_loc(X, A, D, pairs):
    m, n = D.shape
    G = np.zeros_like(X)
    for i, j in pairs:
        r = np.sum((A[i] - X[j]) ** 2) - D[i, j]
        G[j] += 4.0 * r * (X[j] - A[i])
    return G / len(pairs)

# ==============================================================================
# 5. 运行四种优化算法：SGD / Momentum / SVRG / Adam
# ==============================================================================
def run_sgd_methods(max_iter=2500, batch_size=256, seed=42):
    A, X_true, D, X0, rng = generate_data(seed=seed)
    m, n = D.shape
    # 生成全部(i,j)配对索引
    all_pairs = np.array([(i, j) for i in range(m) for j in range(n)])
    methods = {}

    # 记录损失与定位误差
    def record(name, X, hist):
        hist['loss'].append(objective_loc(X, A, D))
        # 每个节点平均欧式误差
        node_err = np.sqrt(np.sum((X - X_true) ** 2, axis=1))
        hist['err'].append(np.mean(node_err))

    # -------------------------- SGD --------------------------
    X = X0.copy()
    hist = {'loss': [], 'err': []}
    eta0 = 0.03
    for k in range(max_iter):
        idx = rng.integers(0, len(all_pairs), size=batch_size)
        G = batch_grad_loc(X, A, D, all_pairs[idx])
        eta = eta0 / np.sqrt(1 + k / 200)
        X -= eta * G
        if k % 25 == 0:
            record('SGD', X, hist)
    methods['SGD'] = hist

    # -------------------------- SGD + Momentum --------------------------
    X = X0.copy()
    V = np.zeros_like(X)
    hist = {'loss': [], 'err': []}
    eta0 = 0.025
    gamma = 0.9
    for k in range(max_iter):
        idx = rng.integers(0, len(all_pairs), size=batch_size)
        G = batch_grad_loc(X, A, D, all_pairs[idx])
        eta = eta0 / np.sqrt(1 + k / 250)
        V = gamma * V + G
        X -= eta * V
        if k % 25 == 0:
            record('Momentum', X, hist)
    methods['SGD+Momentum'] = hist

    # -------------------------- SVRG --------------------------
    X = X0.copy()
    hist = {'loss': [], 'err': []}
    eta = 0.04
    epochs = 25
    inner = max_iter // epochs
    for e in range(epochs):
        X_tilde = X.copy()
        G_tilde = full_grad_loc(X_tilde, A, D)
        for k in range(inner):
            idx = rng.integers(0, len(all_pairs), size=batch_size)
            pairs = all_pairs[idx]
            # SVRG 梯度估计器
            G = batch_grad_loc(X, A, D, pairs) - batch_grad_loc(X_tilde, A, D, pairs) + G_tilde
            X -= eta * G
            if (e * inner + k) % 25 == 0:
                record('SVRG', X, hist)
    methods['SVRG'] = hist

    # -------------------------- Adam --------------------------
    X = X0.copy()
    M = np.zeros_like(X)
    V = np.zeros_like(X)
    hist = {'loss': [], 'err': []}
    eta = 0.08
    b1 = 0.9
    b2 = 0.999
    eps = 1e-8
    for k in range(1, max_iter + 1):
        idx = rng.integers(0, len(all_pairs), size=batch_size)
        G = batch_grad_loc(X, A, D, all_pairs[idx])
        M = b1 * M + (1 - b1) * G
        V = b2 * V + (1 - b2) * (G ** 2)
        M_hat = M / (1 - b1 ** k)
        V_hat = V / (1 - b2 ** k)
        X -= eta * M_hat / (np.sqrt(V_hat) + eps)
        if k % 25 == 0:
            record('Adam', X, hist)
    methods['Adam'] = hist

    return methods

# ==============================================================================
# 绘图：使用 semilogy 对数纵坐标，放大低数值收敛差异
# ==============================================================================
def plot_results(methods):
    plt.rcParams['font.sans-serif'] = ['SimHei']
    plt.rcParams['axes.unicode_minus'] = False
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))
    labels = list(methods.keys())
    colors = ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728']
    for i, name in enumerate(labels):
        hist = methods[name]
        # 半对数坐标绘制y轴
        ax1.semilogy(hist['loss'], label=name, color=colors[i], linewidth=1.2)
        ax2.semilogy(hist['err'], label=name, color=colors[i], linewidth=1.2)

    ax1.set_title('目标MSE损失收敛曲线（半对数坐标semilogy）')
    ax1.set_xlabel('迭代记录点（每25步记录一次）')
    ax1.set_ylabel('MSE损失 (log尺度)')
    ax1.legend()
    ax1.grid(alpha=0.3, which="both")

    ax2.set_title('未知节点平均定位误差（半对数坐标semilogy）')
    ax2.set_xlabel('迭代记录点（每25步记录一次）')
    ax2.set_ylabel('平均欧式误差 (log尺度)')
    ax2.legend()
    ax2.grid(alpha=0.3, which="both")

    plt.tight_layout()
    plt.show()

# ==============================================================================
# 主执行入口
# ==============================================================================
if __name__ == "__main__":
    start = time.time()
    res = run_sgd_methods(max_iter=2500, batch_size=256, seed=42)
    print(f"运行耗时: {time.time() - start:.2f} s")
    plot_results(res)