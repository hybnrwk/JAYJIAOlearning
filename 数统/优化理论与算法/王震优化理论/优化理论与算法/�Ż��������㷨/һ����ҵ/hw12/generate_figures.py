from pathlib import Path
import time

import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt
import numpy as np


BASE_DIR = Path(__file__).resolve().parent
FIG_DIR = BASE_DIR / "figures"
FIG_DIR.mkdir(exist_ok=True)


def exp_objective(x):
    x1, x2 = x
    z = np.array([x1 + 2.0 * x2 - 0.1, x1 - 3.0 * x2 - 0.1, -x1 - 0.1])
    if np.max(z) > 700.0:
        return np.inf
    return float(np.exp(z).sum())


def exp_grad(x):
    x1, x2 = x
    e1 = np.exp(x1 + 2.0 * x2 - 0.1)
    e2 = np.exp(x1 - 3.0 * x2 - 0.1)
    e3 = np.exp(-x1 - 0.1)
    return np.array([e1 + e2 - e3, 2.0 * e1 - 3.0 * e2], dtype=float)


def exp_hess(x):
    x1, x2 = x
    e1 = np.exp(x1 + 2.0 * x2 - 0.1)
    e2 = np.exp(x1 - 3.0 * x2 - 0.1)
    e3 = np.exp(-x1 - 0.1)
    return np.array(
        [[e1 + e2 + e3, 2.0 * e1 - 3.0 * e2], [2.0 * e1 - 3.0 * e2, 4.0 * e1 + 9.0 * e2]],
        dtype=float,
    )


def exp_solution():
    x2 = 0.2 * np.log(1.5)
    x1 = 0.5 * np.log(0.6) - x2
    x = np.array([x1, x2], dtype=float)
    return x, exp_objective(x)


def backtracking(f, grad, x, d, alpha=0.1, beta=0.5):
    t = 1.0
    fx = f(x)
    gtd = float(grad(x) @ d)
    while f(x + t * d) > fx + alpha * t * gtd:
        t *= beta
        if t < 1e-14:
            break
    return t


def damped_newton_exp(x0, f_star, mode="full", reuse_period=3, tol=1e-10, max_iter=100):
    x = np.array(x0, dtype=float)
    gaps = []
    points = []
    hess_evals = 0
    cached_h = None
    start = time.perf_counter()
    for k in range(max_iter + 1):
        gaps.append(max(exp_objective(x) - f_star, 0.0))
        points.append(x.copy())
        if gaps[-1] < tol:
            break
        g = exp_grad(x)
        if mode == "full":
            h = exp_hess(x)
            hess_evals += 1
            d = -np.linalg.solve(h, g)
        elif mode == "reuse":
            if cached_h is None or k % reuse_period == 0:
                cached_h = exp_hess(x)
                hess_evals += 1
            d = -np.linalg.solve(cached_h, g)
        elif mode == "diag":
            h = exp_hess(x)
            hess_evals += 1
            d = -g / np.diag(h)
        else:
            raise ValueError(mode)
        if float(g @ d) >= 0.0:
            d = -g
        t = backtracking(exp_objective, exp_grad, x, d)
        x = x + t * d
    elapsed = time.perf_counter() - start
    return {
        "x": x,
        "gaps": np.array(gaps),
        "points": np.array(points),
        "iters": len(gaps) - 1,
        "hess_evals": hess_evals,
        "elapsed": elapsed,
    }


def wolfe_line_search(f, grad, x, d, c1=1e-4, c2=0.9, max_iter=80):
    t = 1.0
    low = 0.0
    high = np.inf
    fx = f(x)
    g0d = float(grad(x) @ d)
    if g0d >= 0.0:
        return 0.0
    for _ in range(max_iter):
        xt = x + t * d
        if f(xt) > fx + c1 * t * g0d:
            high = t
            t = 0.5 * (low + high)
        elif float(grad(xt) @ d) < c2 * g0d:
            low = t
            if np.isinf(high):
                t = 2.0 * low
            else:
                t = 0.5 * (low + high)
        else:
            return t
    return t


def bfgs(f, grad, x0, f_star, max_iter=100, tol=1e-10):
    x = np.array(x0, dtype=float)
    n = x.size
    inv_h = np.eye(n)
    gaps = []
    points = []
    start = time.perf_counter()
    for k in range(max_iter + 1):
        gaps.append(max(f(x) - f_star, 0.0))
        points.append(x.copy())
        if gaps[-1] < tol:
            break
        g = grad(x)
        d = -inv_h @ g
        if float(g @ d) >= 0.0:
            inv_h = np.eye(n)
            d = -g
        t = wolfe_line_search(f, grad, x, d)
        if t == 0.0:
            break
        x_next = x + t * d
        g_next = grad(x_next)
        s = x_next - x
        y = g_next - g
        ys = float(y @ s)
        if ys > 1e-12:
            rho = 1.0 / ys
            i = np.eye(n)
            inv_h = (i - rho * np.outer(s, y)) @ inv_h @ (i - rho * np.outer(y, s)) + rho * np.outer(s, s)
        else:
            inv_h = np.eye(n)
        x = x_next
    elapsed = time.perf_counter() - start
    return {"x": x, "gaps": np.array(gaps), "points": np.array(points), "iters": len(gaps) - 1, "elapsed": elapsed}


def gradient_descent_wolfe(f, grad, x0, f_star, max_iter=100):
    x = np.array(x0, dtype=float)
    gaps = []
    points = []
    for _ in range(max_iter + 1):
        gaps.append(max(f(x) - f_star, 0.0))
        points.append(x.copy())
        g = grad(x)
        if np.linalg.norm(g) < 1e-10:
            break
        d = -g
        t = wolfe_line_search(f, grad, x, d)
        if t == 0.0:
            break
        x = x + t * d
    return {"x": x, "gaps": np.array(gaps), "points": np.array(points), "iters": len(gaps) - 1}


def f_abs_quad(x):
    return float(abs(x[0]) + 3.0 * x[1] ** 2)


def grad_abs_quad(x):
    return np.array([np.sign(x[0]), 6.0 * x[1]], dtype=float)


def f_abs3(x):
    return float(abs(x[0]) ** 3 + x[1] + 0.5 * x[1] ** 2)


def grad_abs3(x):
    return np.array([3.0 * x[0] * abs(x[0]), 1.0 + x[1]], dtype=float)


def newton_abs3(x0, f_star=-0.5, max_iter=80):
    x = np.array(x0, dtype=float)
    gaps = []
    points = []
    for _ in range(max_iter + 1):
        gaps.append(max(f_abs3(x) - f_star, 0.0))
        points.append(x.copy())
        g = grad_abs3(x)
        if np.linalg.norm(g) < 1e-10:
            break
        d = np.array([0.0, -(1.0 + x[1])], dtype=float)
        if abs(x[0]) > 1e-14:
            d[0] = -g[0] / (6.0 * abs(x[0]))
        else:
            d[0] = 0.0
        if float(g @ d) >= 0.0:
            d = -g
        t = backtracking(f_abs3, grad_abs3, x, d)
        x = x + t * d
    return {"x": x, "gaps": np.array(gaps), "points": np.array(points), "iters": len(gaps) - 1}


def prox_abs3_scalar(z, step):
    a = abs(float(z))
    if a == 0.0:
        return 0.0
    r = (-1.0 + np.sqrt(1.0 + 12.0 * step * a)) / (6.0 * step)
    return np.sign(z) * r


def proximal_gradient_abs3(x0, f_star=-0.5, step=0.5, max_iter=80):
    x = np.array(x0, dtype=float)
    gaps = []
    points = []
    for _ in range(max_iter + 1):
        gaps.append(max(f_abs3(x) - f_star, 0.0))
        points.append(x.copy())
        y = np.array([x[0], x[1] - step * (1.0 + x[1])], dtype=float)
        x = np.array([prox_abs3_scalar(y[0], step), y[1]], dtype=float)
    return {"x": x, "gaps": np.array(gaps), "points": np.array(points), "iters": len(gaps) - 1}


def plot_gaps(results, title, ylabel, filename):
    fig, ax = plt.subplots(figsize=(6.2, 4.0), dpi=180)
    for label, result in results.items():
        gaps = np.maximum(result["gaps"], 1e-16)
        ax.semilogy(np.arange(gaps.size), gaps, marker="o", markersize=3, linewidth=1.7, label=label)
    ax.set_xlabel("iteration k")
    ax.set_ylabel(ylabel)
    ax.set_title(title)
    ax.grid(True, which="both", alpha=0.3)
    ax.legend()
    fig.tight_layout()
    fig.savefig(FIG_DIR / filename)
    plt.close(fig)


def main():
    x_star, f_star = exp_solution()
    x0_exp = np.array([5.0, 2.0])

    newton_results = {
        "standard Newton": damped_newton_exp(x0_exp, f_star, "full"),
        "reuse Hessian, N=3": damped_newton_exp(x0_exp, f_star, "reuse", reuse_period=3),
        "diagonal Hessian": damped_newton_exp(x0_exp, f_star, "diag"),
    }
    plot_gaps(newton_results, "Damped Newton variants on problem 3.2", r"$f(x^k)-f^\star$", "hw12_3_2_newton_variants.png")

    bfgs_exp = bfgs(exp_objective, exp_grad, x0_exp, f_star, max_iter=100)
    plot_gaps(
        {"Newton": newton_results["standard Newton"], "BFGS with Wolfe": bfgs_exp},
        "Newton and BFGS on problem 3.2",
        r"$f(x^k)-f^\star$",
        "hw12_4_1a_bfgs_vs_newton.png",
    )

    rng = np.random.default_rng(20260531)
    x0_abs = rng.uniform(low=np.array([1.0, -2.0]), high=np.array([3.0, -0.5]))
    abs_results = {
        "GD with Wolfe": gradient_descent_wolfe(f_abs_quad, grad_abs_quad, x0_abs, 0.0, max_iter=60),
        "BFGS with Wolfe": bfgs(f_abs_quad, grad_abs_quad, x0_abs, 0.0, max_iter=60, tol=1e-12),
    }
    plot_gaps(abs_results, r"$f(u,v)=|u|+3v^2$", r"$f(x^k)-f^\star$", "hw12_4_1b_abs_quad.png")

    x0_abs3 = x0_abs.copy()
    abs3_results = {
        "GD with Wolfe": gradient_descent_wolfe(f_abs3, grad_abs3, x0_abs3, -0.5, max_iter=80),
        "prox-gradient": proximal_gradient_abs3(x0_abs3, -0.5, step=0.5, max_iter=80),
        "Newton": newton_abs3(x0_abs3, -0.5, max_iter=80),
        "BFGS with Wolfe": bfgs(f_abs3, grad_abs3, x0_abs3, -0.5, max_iter=80, tol=1e-12),
    }
    plot_gaps(abs3_results, r"$f(u,v)=|u|^3+v+\frac{1}{2}v^2$", r"$f(x^k)-f^\star$", "hw12_4_1c_abs3.png")

    print("problem 3.2 optimum")
    print(f"x_star = [{x_star[0]:.10f}, {x_star[1]:.10f}], f_star = {f_star:.10f}")
    print("problem 3.2 Newton variants")
    for label, result in newton_results.items():
        print(
            f"{label:20s}: iters={result['iters']:3d}, hess_evals={result['hess_evals']:3d}, "
            f"final_gap={result['gaps'][-1]:.3e}, x=[{result['x'][0]:.8f}, {result['x'][1]:.8f}]"
        )
    print("problem 4.1(a)")
    print(
        f"BFGS with Wolfe      : iters={bfgs_exp['iters']:3d}, final_gap={bfgs_exp['gaps'][-1]:.3e}, "
        f"x=[{bfgs_exp['x'][0]:.8f}, {bfgs_exp['x'][1]:.8f}]"
    )
    print(f"nonsmooth initial x0 = [{x0_abs[0]:.8f}, {x0_abs[1]:.8f}]")
    print("problem 4.1(b)")
    for label, result in abs_results.items():
        print(f"{label:20s}: iters={result['iters']:3d}, final_gap={result['gaps'][-1]:.3e}, x={result['x']}")
    print("problem 4.1(c)")
    for label, result in abs3_results.items():
        print(f"{label:20s}: iters={result['iters']:3d}, final_gap={result['gaps'][-1]:.3e}, x={result['x']}")


if __name__ == "__main__":
    main()
