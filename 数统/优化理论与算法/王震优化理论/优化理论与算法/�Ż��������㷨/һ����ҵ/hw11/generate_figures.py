from pathlib import Path

import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt
import numpy as np


BASE_DIR = Path(__file__).resolve().parent
FIG_DIR = BASE_DIR / "figures"
FIG_DIR.mkdir(exist_ok=True)


def build_problem(seed=20260514):
    rng = np.random.default_rng(seed)
    n = 80
    m = 100
    density = 0.08

    mask = rng.random((m, n)) < density
    B = rng.normal(size=(m, n)) * mask / np.sqrt(m * density)
    D = np.diag(np.linspace(0.05, 1.0, n))
    A = B.T @ B + D
    b = rng.uniform(-1.0, 1.0, n)
    L = float(np.linalg.eigvalsh(A).max())
    return A, b, L


def objective(A, b, lam, x):
    return 0.5 * float(x @ A @ x) + float(b @ x) + lam * float(np.linalg.norm(x, 1))


def grad(A, b, x):
    return A @ x + b


def soft_threshold(z, tau):
    return np.sign(z) * np.maximum(np.abs(z) - tau, 0.0)


def subgradient_descent(A, b, L, lam, iterations):
    x = np.zeros_like(b)
    values = []
    for k in range(iterations + 1):
        values.append(objective(A, b, lam, x))
        if k == iterations:
            break
        alpha = 0.8 / (L * np.sqrt(k + 1.0))
        subgrad = grad(A, b, x) + lam * np.sign(x)
        x = x - alpha * subgrad
    return np.array(values)


def proximal_gradient(A, b, L, lam, iterations):
    x = np.zeros_like(b)
    step = 1.0 / L
    values = []
    for k in range(iterations + 1):
        values.append(objective(A, b, lam, x))
        if k == iterations:
            break
        x = soft_threshold(x - step * grad(A, b, x), step * lam)
    return np.array(values)


def fista(A, b, L, lam, iterations):
    x = np.zeros_like(b)
    y = x.copy()
    q = 1.0
    step = 1.0 / L
    values = []
    for k in range(iterations + 1):
        values.append(objective(A, b, lam, x))
        if k == iterations:
            break
        x_next = soft_threshold(y - step * grad(A, b, y), step * lam)
        q_next = 0.5 * (1.0 + np.sqrt(1.0 + 4.0 * q * q))
        y = x_next + ((q - 1.0) / q_next) * (x_next - x)
        x = x_next
        q = q_next
    return np.array(values)


def descent_fista(A, b, L, lam, iterations):
    x = np.zeros_like(b)
    y = x.copy()
    q = 1.0
    step = 1.0 / L
    values = []
    for k in range(iterations + 1):
        values.append(objective(A, b, lam, x))
        if k == iterations:
            break
        candidate = soft_threshold(y - step * grad(A, b, y), step * lam)
        if objective(A, b, lam, candidate) <= objective(A, b, lam, x):
            x_next = candidate
        else:
            x_next = x.copy()
        q_next = 0.5 * (1.0 + np.sqrt(1.0 + 4.0 * q * q))
        y = x_next + ((q - 1.0) / q_next) * (x_next - x)
        x = x_next
        q = q_next
    return np.array(values)


def restart_fista(A, b, L, lam, iterations):
    x = np.zeros_like(b)
    y = x.copy()
    q = 1.0
    step = 1.0 / L
    values = []
    for k in range(iterations + 1):
        values.append(objective(A, b, lam, x))
        if k == iterations:
            break
        x_next = soft_threshold(y - step * grad(A, b, y), step * lam)
        if objective(A, b, lam, x_next) > objective(A, b, lam, x):
            q = 1.0
            y = x.copy()
            x_next = soft_threshold(y - step * grad(A, b, y), step * lam)
        q_next = 0.5 * (1.0 + np.sqrt(1.0 + 4.0 * q * q))
        y = x_next + ((q - 1.0) / q_next) * (x_next - x)
        x = x_next
        q = q_next
    return np.array(values)


def plot_for_lambda(A, b, L, lam, iterations=300):
    methods = [
        ("subgradient", subgradient_descent(A, b, L, lam, iterations)),
        ("prox-gradient", proximal_gradient(A, b, L, lam, iterations)),
        ("FISTA", fista(A, b, L, lam, iterations)),
        ("descent FISTA", descent_fista(A, b, L, lam, iterations)),
        ("restart FISTA", restart_fista(A, b, L, lam, iterations)),
    ]

    k = np.arange(iterations + 1)
    styles = {
        "subgradient": dict(color="#1f77b4", linestyle="-", linewidth=1.9),
        "prox-gradient": dict(color="#ff7f0e", linestyle="--", linewidth=2.0),
        "FISTA": dict(color="#2ca02c", linestyle="-.", linewidth=2.0),
        "descent FISTA": dict(color="#d62728", linestyle=":", linewidth=2.2),
        "restart FISTA": dict(color="#9467bd", linestyle=(0, (5, 1)), linewidth=1.9),
    }

    f_ref = min(float(np.min(values)) for _, values in methods)
    gap_floor = 1e-12

    fig, axes = plt.subplots(1, 2, figsize=(10.2, 4.2), dpi=180)
    for label, values in methods:
        axes[0].plot(k, values, label=label, **styles[label])
    axes[0].set_xlabel("iteration")
    axes[0].set_ylabel("objective value")
    axes[0].set_title("objective value")
    axes[0].grid(True, alpha=0.3)

    zoom_end = min(120, iterations)
    zoom = k <= zoom_end
    for label, values in methods:
        gaps = np.maximum(values - f_ref, gap_floor)
        axes[1].semilogy(k[zoom], gaps[zoom], label=label, **styles[label])
    axes[1].set_xlabel("iteration")
    axes[1].set_ylabel(r"$f(x^k)-f_{\rm ref}$")
    axes[1].set_title(f"objective gap, first {zoom_end} iterations")
    axes[1].grid(True, which="both", alpha=0.3)

    handles, labels = axes[0].get_legend_handles_labels()
    fig.legend(handles, labels, loc="lower center", ncol=5, fontsize=8)
    fig.suptitle(f"lambda = {lam:.2f}", y=0.98)
    fig.tight_layout(rect=(0.0, 0.14, 1.0, 0.92))
    file_name = f"hw11_lambda_{lam:.2f}".replace(".", "_") + ".png"
    fig.savefig(FIG_DIR / file_name)
    plt.close()

    print(f"lambda={lam:.2f}")
    for label, values in methods:
        print(f"  {label:14s}: final objective = {values[-1]:.6f}")


def main():
    A, b, L = build_problem()
    print(f"L = {L:.6f}")
    for lam in (0.02, 0.10, 0.50):
        plot_for_lambda(A, b, L, lam)


if __name__ == "__main__":
    main()
