from pathlib import Path
import math

import matplotlib.pyplot as plt
import numpy as np


BASE_DIR = Path(__file__).resolve().parent
FIG_DIR = BASE_DIR / "figures"
FIG_DIR.mkdir(exist_ok=True)


def plot_error_sequences():
    k = np.arange(1, 61)
    e_a = 1.0 / (4.0 ** np.floor(k / 2.0))

    log_e_b = 0.5 * math.log(5.0) - math.log(2.0) * (2.0 ** k)
    e_b = np.exp(np.clip(log_e_b, -745.0, 50.0))
    e_b_plot = np.maximum(e_b, 1e-16)

    e_c = 100.0 / k
    e_d = np.where(k <= 50, 1.0 / (k**2), 0.895**k)

    series = [
        (e_a, "a: 4^{-floor(k/2)}"),
        (e_b_plot, "b: sqrt(5)/2^{2^k}"),
        (e_c, "c: 100/k"),
        (e_d, "d: piecewise"),
    ]

    plt.figure(figsize=(7.2, 4.4), dpi=160)
    for values, label in series:
        plt.plot(k, values, linewidth=1.8, label=label)
    plt.xlabel("iteration k")
    plt.ylabel("error")
    plt.grid(True, alpha=0.3)
    plt.legend(fontsize=8)
    plt.tight_layout()
    plt.savefig(FIG_DIR / "hw10_2_1_linear.png")
    plt.close()

    plt.figure(figsize=(7.2, 4.4), dpi=160)
    for values, label in series:
        plt.semilogy(k, values, linewidth=1.8, label=label)
    plt.xlabel("iteration k")
    plt.ylabel("error")
    plt.ylim(1e-16, 2e2)
    plt.grid(True, which="both", alpha=0.3)
    plt.legend(fontsize=8)
    plt.tight_layout()
    plt.savefig(FIG_DIR / "hw10_2_1_semilogy.png")
    plt.close()


def f_value(x):
    x1, x2 = x
    return (
        math.exp(x1 + 3.0 * x2 - 0.1)
        + math.exp(x1 - 3.0 * x2 - 0.1)
        + math.exp(-x1 - 0.1)
    )


def grad_value(x):
    x1, x2 = x
    a = math.exp(x1 + 3.0 * x2 - 0.1)
    b = math.exp(x1 - 3.0 * x2 - 0.1)
    c = math.exp(-x1 - 0.1)
    return np.array([a + b - c, 3.0 * a - 3.0 * b], dtype=float)


def plot_backtracking_gradient_descent():
    alpha = 0.1
    beta = 0.7
    x = np.array([0.0, 0.0], dtype=float)
    f_star = 2.0 * math.sqrt(2.0) * math.exp(-0.1)

    gaps = []
    iterates = []
    for _ in range(31):
        gaps.append(max(f_value(x) - f_star, 1e-16))
        iterates.append(x.copy())

        g = grad_value(x)
        fx = f_value(x)
        t = 1.0
        gnorm2 = float(g @ g)
        while f_value(x - t * g) > fx - alpha * t * gnorm2:
            t *= beta
        x = x - t * g

    k = np.arange(31)
    plt.figure(figsize=(7.2, 4.4), dpi=160)
    plt.semilogy(k, gaps, marker="o", markersize=3, linewidth=1.6)
    plt.xlabel("iteration k")
    plt.ylabel("f(x^k)-f*")
    plt.grid(True, which="both", alpha=0.3)
    plt.tight_layout()
    plt.savefig(FIG_DIR / "hw10_3_2_semilogy.png")
    plt.close()

    final_x = iterates[-1]
    print("x_30 =", final_x)
    print("f(x_30)-f_star =", gaps[-1])


if __name__ == "__main__":
    plot_error_sequences()
    plot_backtracking_gradient_descent()
