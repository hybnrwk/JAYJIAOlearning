# 数理统计第十三讲、第十四讲完整复习笔记  
## 完备性、指数分布类、参数函数的 MVUE、多参数指数族、最小充分统计量与从属统计量

---

# 0. 这两讲在整门课里的位置

前面已经讲过：

1. 点估计：
   - 矩估计；
   - 极大似然估计；
   - 无偏性；
   - 有效性；
   - Rao-Cramer 下界；
   - MVUE 初步思想。

2. 区间估计：
   - 枢轴量；
   - 正态总体参数区间。

3. 假设检验：
   - z 检验；
   - t 检验；
   - 卡方检验；
   - F 检验；
   - LRT、Wald、Score 检验。

4. 充分统计量：
   - 充分统计量定义；
   - Neyman 分解定理；
   - Rao-Blackwell 定理。

第十三讲和第十四讲是在“充分统计量”基础上的进一步推进。

核心主线是：

> 如果找到充分统计量，只能说明它没有丢失关于参数的信息；  
> 如果它还完备，那么任何它的无偏函数就是唯一 MVUE。

也就是说：

- 充分统计量解决“信息有没有丢失”；
- 完备性解决“充分统计量的函数是否唯一”；
- Lehmann-Scheffe 定理把二者合起来，用来系统寻找 MVUE；
- 指数分布类提供了一大批自动具有完备充分统计量的分布；
- 第十四讲继续讨论参数函数、多参数指数族、最小充分性与从属统计量。

---

# 1. 第十三讲主线：为什么还需要完备性？

前面已经知道 Rao-Blackwell 定理：

如果：

$$
T
$$

是充分统计量，且：

$$
Y
$$

是参数 $\theta$ 的无偏估计量，那么：

$$
E(Y|T)
$$

仍然是 $\theta$ 的无偏估计量，并且方差不大于 $Y$。

因此，在寻找 MVUE 时，一个自然思路是：

> 先找到充分统计量 $T$，再找 $T$ 的无偏函数。

但是问题是：

> 只要一个统计量是充分统计量，那么它的任意无偏函数一定是 MVUE 吗？

答案是：

> 不一定。

所以需要引入“完备性”。

---

# 2. 反例：$U[\theta,\theta+1]$ 中充分统计量的函数未必是 MVUE

设：

$$
X_1,\dots,X_n\sim U[\theta,\theta+1]
$$

总体密度为：

$$
f(x;\theta)=
\begin{cases}
1,&\theta\le x\le \theta+1\\
0,&其他
\end{cases}
$$

样本似然函数为：

$$
L(\theta)
=
\prod_{i=1}^n I\{\theta\le X_i\le \theta+1\}
$$

这个条件等价于：

$$
\theta\le X_{(1)}
$$

且：

$$
X_{(n)}\le \theta+1
$$

也就是：

$$
X_{(n)}-1\le \theta\le X_{(1)}
$$

因此似然函数可以写成：

$$
L(\theta)=I\{X_{(n)}-1\le \theta\le X_{(1)}\}
$$

由 Neyman 分解定理，联合充分统计量为：

$$
Y=(Y_1,Y_2)^T=(X_{(1)},X_{(n)})^T
$$

其中：

$$
X_{(1)}=\min X_i,\qquad X_{(n)}=\max X_i
$$

---

## 2.1 计算 $E(Y_1)$ 与 $E(Y_2)$

令：

$$
W_i=X_i-\theta
$$

则：

$$
W_i\sim U[0,1]
$$

记：

$$
Z_1=\min W_i,\qquad Z_2=\max W_i
$$

则：

$$
Y_1=\theta+Z_1
$$

$$
Y_2=\theta+Z_2
$$

先看最小值。

$$
P(Z_1>z)=P(W_1>z,\dots,W_n>z)=(1-z)^n
$$

所以：

$$
F_{Z_1}(z)=1-(1-z)^n
$$

密度为：

$$
f_{Z_1}(z)=n(1-z)^{n-1},\qquad 0<z<1
$$

于是：

$$
E(Z_1)=\int_0^1 zn(1-z)^{n-1}dz=\frac1{n+1}
$$

所以：

$$
E(Y_1)=\theta+\frac1{n+1}
$$

再看最大值。

$$
P(Z_2\le z)=P(W_1\le z,\dots,W_n\le z)=z^n
$$

密度为：

$$
f_{Z_2}(z)=nz^{n-1}
$$

于是：

$$
E(Z_2)=\int_0^1 znz^{n-1}dz=\frac n{n+1}
$$

所以：

$$
E(Y_2)=\theta+\frac n{n+1}
$$

因此：

$$
Y_1-\frac1{n+1}
$$

和：

$$
Y_2-\frac n{n+1}
$$

都是 $\theta$ 的无偏估计量。

而且它们都是充分统计量：

$$
(Y_1,Y_2)
$$

的函数。

---

## 2.2 为什么这说明“充分”还不够？

可以算出：

$$
Var(Y_1)=Var(Y_2)=\frac{n}{(n+1)^2(n+2)}
$$

如果这两个估计量都是 MVUE，则根据 MVUE 的唯一性，它们应该几乎必然相等。

但：

$$
Y_1-\frac1{n+1}
$$

和：

$$
Y_2-\frac n{n+1}
$$

显然不可能几乎必然相等。

所以它们不可能同时都是 MVUE。

这说明：

> 即使一个估计量是充分统计量的函数，并且无偏，也不一定是 MVUE。

需要更强条件：**完备充分统计量**。

---

# 3. 完备性的定义

设随机变量 $Z$ 的分布属于分布族：

$$
\{h(z;\theta):\theta\in\Omega\}
$$

如果对于任意函数 $u(\cdot)$，只要：

$$
E_\theta[u(Z)]=0
$$

对所有：

$$
\theta\in\Omega
$$

都成立，就必然推出：

$$
P_\theta\{u(Z)=0\}=1
$$

对所有：

$$
\theta\in\Omega
$$

都成立，则称这个分布族是完备族。

简单说：

> 如果一个函数 $u(Z)$ 对所有参数值的期望都为 0，那么它只能是几乎处处为 0。

这就是完备性。

---

## 3.1 完备性的直观理解

完备性的核心是排除“非零函数却对所有参数期望为 0”的情况。

如果一个充分统计量 $T$ 是完备的，那么：

> 不可能存在两个不同的 $T$ 的函数，同时都是同一个参数函数的无偏估计。

因为如果：

$$
E[\phi_1(T)]=g(\theta)
$$

且：

$$
E[\phi_2(T)]=g(\theta)
$$

那么：

$$
E[\phi_1(T)-\phi_2(T)]=0
$$

对所有 $\theta$ 成立。

如果 $T$ 完备，则：

$$
\phi_1(T)-\phi_2(T)=0
$$

几乎必然成立。

所以：

$$
\phi_1(T)=\phi_2(T)
$$

几乎必然成立。

这就是完备性和唯一 MVUE 的关系。

---

# 4. 完备性例子一：指数分布族

设：

$$
Z\sim Exp(1/\theta)
$$

密度为：

$$
h(z;\theta)=\frac1\theta e^{-z/\theta},\qquad z>0,\theta>0
$$

若：

$$
E[u(Z)]=0
$$

对所有 $\theta>0$ 成立，则：

$$
\int_0^\infty u(z)\frac1\theta e^{-z/\theta}dz=0
$$

等价于：

$$
\int_0^\infty u(z)e^{-z/\theta}dz=0
$$

对所有 $\theta>0$ 成立。

这就是 $u(z)$ 的 Laplace 变换恒为 0。

由 Laplace 变换唯一性可知：

$$
u(z)=0
$$

几乎处处成立。

所以指数分布族是完备族。

---

# 5. 完备性例子二：Poisson 分布中 $\sum X_i$ 完备

设：

$$
X_1,\dots,X_n\sim Poisson(\theta)
$$

已知：

$$
Y=\sum_{i=1}^n X_i\sim Poisson(n\theta)
$$

其 p.m.f. 为：

$$
P(Y=y)=\frac{(n\theta)^y e^{-n\theta}}{y!},\qquad y=0,1,2,\dots
$$

假设：

$$
E[u(Y)]=0
$$

对所有 $\theta>0$ 成立。

则：

$$
0=\sum_{y=0}^\infty u(y)\frac{(n\theta)^y e^{-n\theta}}{y!}
$$

两边乘以：

$$
e^{n\theta}
$$

得到：

$$
u(0)+u(1)\frac{n\theta}{1!}
+u(2)\frac{(n\theta)^2}{2!}
+\cdots=0
$$

对所有 $\theta>0$ 成立。

先令：

$$
\theta\to 0
$$

得到：

$$
u(0)=0
$$

再除以 $\theta$ 后令 $\theta\to0$，得到：

$$
u(1)=0
$$

依此类推：

$$
u(0)=u(1)=u(2)=\cdots=0
$$

因此：

$$
u(Y)=0
$$

几乎必然成立。

所以：

$$
Y=\sum_{i=1}^nX_i
$$

属于完备族。

又因为它也是 Poisson 分布参数 $\theta$ 的充分统计量，所以它是完备充分统计量。

---

# 6. Lehmann-Scheffe 定理

这是第十三讲最核心的定理。

设：

$$
X_1,\dots,X_n
$$

来自分布：

$$
f(x;\theta)
$$

如果：

$$
T=T(X_1,\dots,X_n)
$$

是 $\theta$ 的完备充分统计量。

若：

$$
\phi(T)
$$

是 $g(\theta)$ 的无偏估计量，即：

$$
E[\phi(T)]=g(\theta)
$$

则：

$$
\phi(T)
$$

是 $g(\theta)$ 的唯一 MVUE。

---

## 6.1 这一定理为什么重要？

它给出寻找 MVUE 的标准路线：

1. 找完备充分统计量 $T$；
2. 找一个 $T$ 的函数 $\phi(T)$；
3. 证明它无偏；
4. 立刻得到它是 MVUE。

也就是说，以后不用直接比较所有无偏估计量的方差。

只要有：

$$
T\text{ 完备充分}
$$

并且：

$$
E[\phi(T)]=g(\theta)
$$

就可以直接用 Lehmann-Scheffe 定理。

---

## 6.2 和 Rao-Blackwell 定理的关系

Rao-Blackwell 定理说：

> 给一个无偏估计 $Y$，对充分统计量 $T$ 取条件期望 $E(Y|T)$，方差不会变大。

Lehmann-Scheffe 定理进一步说：

> 如果这个充分统计量还完备，那么 $E(Y|T)$ 就是唯一 MVUE。

所以常见套路是：

$$
Y\text{ 无偏}
\quad\Longrightarrow\quad
E(Y|T)\text{ 是 }T\text{ 的函数}
\quad\Longrightarrow\quad
\text{MVUE}
$$

前提是：

$$
T
$$

是完备充分统计量。

---

# 7. 完备充分统计量 CSS

如果统计量：

$$
T
$$

满足：

1. $T$ 是充分统计量；
2. $T$ 的分布族是完备族；

则称 $T$ 为完备充分统计量。

英文是：

$$
CSS=complete\ sufficient\ statistic
$$

---

# 8. 例子：$U[0,\theta]$ 中最大值是完备充分统计量

设：

$$
X_1,\dots,X_n\sim U[0,\theta]
$$

密度为：

$$
f(x;\theta)=\frac1\theta,\qquad 0\le x\le \theta
$$

样本似然函数为：

$$
L(\theta)=\theta^{-n}I\{0\le X_{(1)},X_{(n)}\le\theta\}
$$

其中：

$$
X_{(n)}=\max X_i
$$

因此：

$$
Y=X_{(n)}
$$

是充分统计量。

---

## 8.1 最大值的分布

对：

$$
0\le y\le\theta
$$

有：

$$
P(Y\le y)=P(X_1\le y,\dots,X_n\le y)
=
\left(\frac y\theta\right)^n
$$

所以密度为：

$$
g(y;\theta)=\frac{ny^{n-1}}{\theta^n},\qquad 0\le y\le\theta
$$

---

## 8.2 证明完备

假设：

$$
E[u(Y)]=0
$$

对所有 $\theta>0$ 成立。

则：

$$
\int_0^\theta u(y)\frac{ny^{n-1}}{\theta^n}dy=0
$$

等价于：

$$
\int_0^\theta u(y)y^{n-1}dy=0
$$

对 $\theta$ 求导，利用微积分基本定理：

$$
u(\theta)\theta^{n-1}=0
$$

因为：

$$
\theta>0
$$

所以：

$$
u(\theta)=0
$$

对所有 $\theta>0$ 成立。

因此：

$$
Y=X_{(n)}
$$

是完备充分统计量。

---

## 8.3 用 Lehmann-Scheffe 求 $\theta$ 的 MVUE

计算：

$$
E(Y)=\int_0^\theta y\frac{ny^{n-1}}{\theta^n}dy
=
\frac n{n+1}\theta
$$

所以：

$$
\frac{n+1}{n}Y
$$

是 $\theta$ 的无偏估计。

由于：

$$
Y
$$

是完备充分统计量，由 Lehmann-Scheffe 定理：

$$
\frac{n+1}{n}X_{(n)}
$$

是 $\theta$ 的 MVUE。

---

# 9. 正则指数分布类：一参数形式

第十三讲后半部分讲正则指数分布类。

一参数正则指数族的形式是：

$$
f(x;\theta)=\exp\{p(\theta)K(x)+H(x)+q(\theta)\},\qquad x\in S
$$

并且：

$$
f(x;\theta)=0,\qquad x\notin S
$$

其中需要满足：

1. 支撑集 $S$ 不依赖于 $\theta$；
2. $p(\theta)$ 是连续非平凡函数，也就是不是常数；
3. 若 $X$ 连续，则 $K'(x)$ 不恒等于 0，且 $H(x)$ 在支撑集上连续；
4. 若 $X$ 离散，则 $K(x)$ 是非平凡函数。

---

## 9.1 为什么支撑集不能依赖参数？

如果支撑集依赖参数，比如：

$$
X\sim U[0,\theta]
$$

则：

$$
S=[0,\theta]
$$

依赖于 $\theta$。

这时虽然可能有完备充分统计量，但不属于这里定义的“正则指数分布类”。

所以：

> 正则指数族的关键限制之一：支撑集不能含未知参数。

---

# 10. 一参数正则指数族的充分统计量与完备性

若：

$$
X_1,\dots,X_n
$$

来自一参数正则指数族：

$$
f(x;\theta)=\exp\{p(\theta)K(x)+H(x)+q(\theta)\}
$$

则样本似然函数为：

$$
L(\theta;X)
=
\prod_{i=1}^n f(X_i;\theta)
$$

$$
=
\exp\left\{
p(\theta)\sum_{i=1}^nK(X_i)+nq(\theta)
\right\}
\exp\left\{
\sum_{i=1}^nH(X_i)
\right\}
$$

由 Neyman 分解定理：

$$
Y=\sum_{i=1}^nK(X_i)
$$

是 $\theta$ 的充分统计量。

更重要的是，定理说明：

> 对正则指数分布类，$Y=\sum K(X_i)$ 是完备充分统计量。

所以以后只要识别出正则指数族，基本可以直接写：

$$
Y=\sum_{i=1}^nK(X_i)
$$

是完备充分统计量。

---

# 11. 一参数正则指数族中 $E(Y)$ 和 $Var(Y)$ 的公式

若：

$$
Y=\sum_{i=1}^nK(X_i)
$$

且：

$$
f(x;\theta)=\exp\{p(\theta)K(x)+H(x)+q(\theta)\}
$$

则讲义给出：

$$
E(Y)=
-\frac{nq'(\theta)}{p'(\theta)}
$$

并且：

$$
Var(Y)
=
\frac{
n[p''(\theta)q'(\theta)-q''(\theta)p'(\theta)]
}{
[p'(\theta)]^3
}
$$

这个公式在 HW7 Problem 2 里很有用。

做 MVUE 时，经常先用：

$$
E(Y)
$$

找到纠偏系数。

---

# 12. 常见一参数正则指数族例子

---

## 12.1 正态分布 $N(\theta,\sigma_0^2)$，$\sigma_0^2$ 已知

密度为：

$$
f(x;\theta)=
\frac1{\sigma_0\sqrt{2\pi}}
\exp\left\{
-\frac{(x-\theta)^2}{2\sigma_0^2}
\right\}
$$

展开：

$$
f(x;\theta)=
\exp\left\{
\frac{\theta}{\sigma_0^2}x
-\frac{x^2}{2\sigma_0^2}
-\frac{\theta^2}{2\sigma_0^2}
-\log\sigma_0-\frac12\log(2\pi)
\right\}
$$

所以：

$$
K(x)=x
$$

完备充分统计量为：

$$
Y=\sum_{i=1}^nX_i
$$

等价地：

$$
\bar X
$$

也是完备充分统计量，因为二者一一对应。

---

## 12.2 正态分布 $N(\mu_0,\theta)$，$\mu_0$ 已知

这里：

$$
\theta
$$

是方差。

密度为：

$$
f(x;\theta)=
\frac1{\sqrt{2\pi\theta}}
\exp\left\{
-\frac{(x-\mu_0)^2}{2\theta}
\right\}
$$

写成指数族形式：

$$
f(x;\theta)
=
\exp\left\{
-\frac1{2\theta}(x-\mu_0)^2
-\frac12\log\theta
-\frac12\log(2\pi)
\right\}
$$

所以：

$$
K(x)=(x-\mu_0)^2
$$

完备充分统计量为：

$$
Y=\sum_{i=1}^n(X_i-\mu_0)^2
$$

---

## 12.3 Bernoulli 分布

$$
f(x;\theta)=\theta^x(1-\theta)^{1-x},\qquad x=0,1
$$

写成：

$$
f(x;\theta)
=
\exp\left\{
x\log\frac{\theta}{1-\theta}
+\log(1-\theta)
\right\}
$$

所以：

$$
K(x)=x
$$

完备充分统计量为：

$$
Y=\sum_{i=1}^nX_i
$$

---

## 12.4 Binomial 分布

若：

$$
X\sim Bin(m,\theta)
$$

其中 $m$ 已知，则：

$$
f(x;\theta)=\binom mx\theta^x(1-\theta)^{m-x}
$$

写成：

$$
f(x;\theta)
=
\exp\left\{
x\log\frac{\theta}{1-\theta}
+
m\log(1-\theta)
+
\log\binom mx
\right\}
$$

所以：

$$
K(x)=x
$$

完备充分统计量为：

$$
Y=\sum X_i
$$

---

## 12.5 Poisson 分布

$$
f(x;\theta)=\frac{\theta^x e^{-\theta}}{x!}
=
\exp\{x\log\theta-\theta-\log(x!)\}
$$

所以：

$$
K(x)=x
$$

完备充分统计量为：

$$
Y=\sum X_i
$$

---

## 12.6 指数分布：速率参数

若：

$$
f(x;\theta)=\theta e^{-\theta x},\qquad x>0
$$

则：

$$
f(x;\theta)=\exp\{-\theta x+\log\theta\}
$$

所以：

$$
K(x)=x
$$

完备充分统计量为：

$$
Y=\sum X_i
$$

---

## 12.7 Gamma 分布：形状参数未知，尺度已知

设：

$$
X\sim \Gamma(\theta,\beta_0)
$$

其中 $\beta_0$ 已知，$\theta$ 未知。

密度为：

$$
f(x;\theta)=
\frac1{\Gamma(\theta)\beta_0^\theta}
x^{\theta-1}e^{-x/\beta_0}
$$

写成：

$$
f(x;\theta)
=
\exp\left\{
(\theta-1)\log x
-\frac{x}{\beta_0}
-\log\Gamma(\theta)
-\theta\log\beta_0
\right\}
$$

所以：

$$
K(x)=\log x
$$

完备充分统计量为：

$$
Y=\sum_{i=1}^n\log X_i
$$

---

## 12.8 Gamma 分布：尺度参数未知，形状已知

设：

$$
X\sim \Gamma(\alpha_0,\theta)
$$

其中 $\alpha_0$ 已知，$\theta$ 是尺度参数。

密度为：

$$
f(x;\theta)=
\frac1{\Gamma(\alpha_0)\theta^{\alpha_0}}
x^{\alpha_0-1}e^{-x/\theta}
$$

写成：

$$
f(x;\theta)
=
\exp\left\{
-\frac{x}{\theta}
+
(\alpha_0-1)\log x
-\log\Gamma(\alpha_0)
-\alpha_0\log\theta
\right\}
$$

所以：

$$
K(x)=x
$$

完备充分统计量为：

$$
Y=\sum X_i
$$

---

## 12.9 均匀分布 $U[0,\theta]$ 不是正则指数族

因为支撑集：

$$
S=[0,\theta]
$$

依赖于未知参数 $\theta$。

所以：

$$
U[0,\theta]
$$

不属于正则指数分布类。

但它仍然有完备充分统计量：

$$
X_{(n)}=\max X_i
$$

这说明：

> 不是正则指数族，不代表没有完备充分统计量；  
> 正则指数族只是提供一类方便判定的充分完备模型。

---

# 13. 第十四讲主线：如何估计参数的函数 $g(\theta)$？

第十四讲首先讨论：

> 如何找到参数函数 $g(\theta)$ 的 MVUE？

常见方法有两种：

## 方法一：Lehmann-Scheffe 直接法

步骤：

1. 找完备充分统计量 $T$；
2. 尝试构造 $T$ 的函数：

$$
\phi(T)
$$

3. 使其满足：

$$
E[\phi(T)]=g(\theta)
$$

4. 由 Lehmann-Scheffe 定理：

$$
\phi(T)
$$

就是 $g(\theta)$ 的 MVUE。

---

## 方法二：Rao-Blackwell 条件期望法

步骤：

1. 先找任意一个 $g(\theta)$ 的无偏估计量 $Y$；
2. 找完备充分统计量 $T$；
3. 计算：

$$
E(Y|T)
$$

4. 由 Rao-Blackwell 定理，它是 $T$ 的函数，且无偏；
5. 由 Lehmann-Scheffe 定理，它是 MVUE。

---

# 14. 例子：Bernoulli 中 $\theta(1-\theta)$ 的 MVUE

设：

$$
X_1,\dots,X_n\sim Bernoulli(\theta)
$$

要估计：

$$
\delta=\theta(1-\theta)
$$

完备充分统计量为：

$$
Y=\sum_{i=1}^nX_i
$$

且：

$$
Y\sim Bin(n,\theta)
$$

---

## 14.1 方法一：直接构造 $Y$ 的函数

一个自然估计是：

$$
\tilde\delta=\frac Yn\left(1-\frac Yn\right)
$$

也就是样本比例乘以：

$$
1-\text{样本比例}
$$

计算期望：

$$
E(\tilde\delta)
=
E\left[
\frac Yn-\frac{Y^2}{n^2}
\right]
$$

$$
=
\frac1nE(Y)-\frac1{n^2}E(Y^2)
$$

其中：

$$
E(Y)=n\theta
$$

$$
Var(Y)=n\theta(1-\theta)
$$

所以：

$$
E(Y^2)=Var(Y)+[E(Y)]^2
=
n\theta(1-\theta)+n^2\theta^2
$$

代入：

$$
E(\tilde\delta)
=
\theta
-
\frac1{n^2}
\{n\theta(1-\theta)+n^2\theta^2\}
$$

$$
=
\theta-\frac{\theta(1-\theta)}n-\theta^2
$$

$$
=
\frac{n-1}{n}\theta(1-\theta)
$$

因此纠偏：

$$
\hat\delta
=
\frac n{n-1}\tilde\delta
$$

即：

$$
\hat\delta
=
\frac n{n-1}
\frac Yn
\left(1-\frac Yn\right)
$$

化简：

$$
\hat\delta
=
\frac{Y(n-Y)}{n(n-1)}
$$

由于它是完备充分统计量 $Y$ 的无偏函数，所以它是 $\theta(1-\theta)$ 的 MVUE。

---

## 14.2 方法二：Rao-Blackwell

先找一个粗糙无偏估计量。

因为：

$$
X_1+X_2\sim Bin(2,\theta)
$$

所以：

$$
P(X_1+X_2=1)=2\theta(1-\theta)
$$

令：

$$
Y_2=\frac12 I\{X_1+X_2=1\}
$$

则：

$$
E(Y_2)=\theta(1-\theta)
$$

所以 $Y_2$ 是无偏估计。

计算：

$$
E(Y_2|Y=y)
=
\frac12P(X_1+X_2=1|Y=y)
$$

给定总成功次数 $Y=y$，相当于 $n$ 个位置中有 $y$ 个 1，$n-y$ 个 0。

前两个位置正好一个 1 的概率为：

$$
\frac{2y(n-y)}{n(n-1)}
$$

所以：

$$
E(Y_2|Y=y)
=
\frac12
\frac{2y(n-y)}{n(n-1)}
=
\frac{y(n-y)}{n(n-1)}
$$

于是：

$$
E(Y_2|Y)
=
\frac{Y(n-Y)}{n(n-1)}
$$

和方法一结果一致。

---

# 15. 例子：正态分布中 $\theta^2$ 的 MVUE

设：

$$
X_1,\dots,X_n\sim N(\theta,1)
$$

要求估计：

$$
\theta^2
$$

完备充分统计量为：

$$
\bar X
$$

因为：

$$
\bar X\sim N(\theta,1/n)
$$

计算：

$$
E(\bar X^2)=Var(\bar X)+[E(\bar X)]^2
=
\frac1n+\theta^2
$$

所以：

$$
\bar X^2-\frac1n
$$

是：

$$
\theta^2
$$

的无偏估计。

由于它是完备充分统计量：

$$
\bar X
$$

的函数，所以由 Lehmann-Scheffe 定理：

$$
\bar X^2-\frac1n
$$

是 $\theta^2$ 的 MVUE。

---

## 15.1 Rao-Blackwell 方法

也可以先取：

$$
Y_2=X_1^2-1
$$

因为：

$$
E(X_1^2)=\theta^2+1
$$

所以：

$$
E(Y_2)=\theta^2
$$

然后计算：

$$
E(Y_2|\bar X)
$$

已知：

$$
X_1|\bar X=\bar x\sim N\left(\bar x,\frac{n-1}{n}\right)
$$

所以：

$$
E(X_1^2|\bar X=\bar x)
=
\bar x^2+\frac{n-1}{n}
$$

因此：

$$
E(Y_2|\bar X=\bar x)
=
\bar x^2+\frac{n-1}{n}-1
=
\bar x^2-\frac1n
$$

得到同样结论：

$$
E(Y_2|\bar X)=\bar X^2-\frac1n
$$

---

# 16. 例子：正态分布中 $\Phi(c-\theta)$ 的 MVUE

设：

$$
X_1,\dots,X_n\sim N(\theta,1)
$$

要估计：

$$
P(X\le c)=\Phi(c-\theta)
$$

其中 $c$ 是已知常数。

先构造粗糙无偏估计：

$$
u(X_1)=I\{X_1\le c\}
$$

因为：

$$
E[u(X_1)]=P(X_1\le c)=\Phi(c-\theta)
$$

所以它是无偏估计。

完备充分统计量为：

$$
\bar X
$$

计算 Rao-Blackwell 改进：

$$
E[I\{X_1\le c\}|\bar X=\bar x]
=
P(X_1\le c|\bar X=\bar x)
$$

已知：

$$
X_1|\bar X=\bar x\sim N\left(\bar x,\frac{n-1}{n}\right)
$$

所以：

$$
P(X_1\le c|\bar X=\bar x)
=
\Phi\left(
\frac{c-\bar x}{\sqrt{(n-1)/n}}
\right)
$$

也就是：

$$
\Phi\left(
\sqrt{\frac n{n-1}}(c-\bar x)
\right)
$$

因此 MVUE 为：

$$
\Phi\left(
\sqrt{\frac n{n-1}}(c-\bar X)
\right)
$$

---

# 17. 例子：单个 Poisson 样本中 $e^{-2\theta}$ 的 MVUE

设：

$$
X_1\sim Poisson(\theta)
$$

只有一个样本。

由于单个样本本身就是完备充分统计量，考虑：

$$
Y=(-1)^{X_1}
$$

计算期望：

$$
E(Y)=\sum_{x=0}^\infty (-1)^x\frac{\theta^x e^{-\theta}}{x!}
$$

$$
=
e^{-\theta}\sum_{x=0}^\infty\frac{(-\theta)^x}{x!}
$$

$$
=
e^{-\theta}e^{-\theta}
=
e^{-2\theta}
$$

所以：

$$
(-1)^{X_1}
$$

是 $e^{-2\theta}$ 的无偏估计。

由于它是完备充分统计量 $X_1$ 的函数，所以它是 MVUE。

注意：

> MVUE 不一定在直觉上“好看”。这里 $(-1)^{X_1}$ 会取 $\pm1$，虽然无偏且是 MVUE，但实际估计表现未必比某些有偏估计更令人满意。

---

# 18. 例子：$U[0,\theta]$ 中一般函数 $g(\theta)$ 的 MVUE

设：

$$
X_1,\dots,X_n\sim U[0,\theta]
$$

完备充分统计量为：

$$
Y=X_{(n)}
$$

其密度为：

$$
f_Y(y;\theta)=\frac{ny^{n-1}}{\theta^n},\qquad 0\le y\le\theta
$$

要估计：

$$
g(\theta)
$$

希望找到：

$$
u(Y)
$$

使得：

$$
E[u(Y)]=g(\theta)
$$

即：

$$
g(\theta)=\int_0^\theta u(y)\frac{ny^{n-1}}{\theta^n}dy
$$

两边乘以：

$$
\theta^n
$$

得到：

$$
\theta^n g(\theta)
=
\int_0^\theta u(y)ny^{n-1}dy
$$

对 $\theta$ 求导：

$$
n\theta^{n-1}g(\theta)+\theta^ng'(\theta)
=
u(\theta)n\theta^{n-1}
$$

所以：

$$
u(\theta)=g(\theta)+\frac{\theta g'(\theta)}n
$$

因此：

$$
u(Y)=g(Y)+\frac{Yg'(Y)}n
$$

是：

$$
g(\theta)
$$

的 MVUE。

这个公式很重要：

$$
\boxed{
\widehat{g(\theta)}_{MVUE}
=
g(Y)+\frac{Yg'(Y)}n,\qquad Y=X_{(n)}
}
$$

---

# 19. 多参数情形：联合充分统计量

第十四讲第二部分把充分统计量推广到多参数。

设：

$$
\theta\in\Omega\subset R^p
$$

统计量向量：

$$
Y=(Y_1,\dots,Y_m)^T
$$

如果给定 $Y$ 后，原样本的条件分布不依赖于参数向量 $\theta$，则称：

$$
Y
$$

是联合充分统计量。

Neyman 分解形式为：

$$
\prod_{i=1}^n f(x_i;\theta)
=
k_1(Y;\theta)k_2(x_1,\dots,x_n)
$$

其中：

$$
k_2
$$

不依赖于 $\theta$。

---

# 20. 多参数例子：均匀分布中心和半径都未知

设：

$$
f(x;\theta_1,\theta_2)=\frac1{2\theta_2},
\qquad
\theta_1-\theta_2\le x\le \theta_1+\theta_2
$$

其中：

$$
-\infty<\theta_1<\infty,\qquad \theta_2>0
$$

样本联合密度为：

$$
\prod_{i=1}^n\frac1{2\theta_2}
I\{x_i\in[\theta_1-\theta_2,\theta_1+\theta_2]\}
$$

即：

$$
\frac1{(2\theta_2)^n}
I\{x_{(1)}\in[\theta_1-\theta_2,\theta_1+\theta_2]\}
I\{x_{(n)}\in[\theta_1-\theta_2,\theta_1+\theta_2]\}
$$

所以联合充分统计量为：

$$
Y=(X_{(1)},X_{(n)})^T
$$

也就是最小值和最大值。

---

# 21. 多参数例子：$N(\theta,\theta^2)$

设：

$$
X_1,\dots,X_n\sim N(\theta,\theta^2)
$$

其中：

$$
-\infty<\theta<\infty
$$

虽然只有一个参数 $\theta$，但它同时出现在均值和方差中。

密度乘积中会出现：

$$
\sum X_i
$$

和：

$$
\sum X_i^2
$$

所以联合充分统计量为：

$$
Y=
\left(
\sum_{i=1}^n X_i^2,\ \bar X
\right)^T
$$

等价地也可以写成：

$$
\left(
\sum X_i^2,\ \sum X_i
\right)^T
$$

---

# 22. 多参数指数分布类

多参数指数族形式为：

$$
f(x;\theta)
=
\exp\left\{
\sum_{j=1}^m p_j(\theta)K_j(x)+H(x)+q(\theta)
\right\},
\qquad x\in S
$$

如果满足正则条件，则称为多参数正则指数分布类。

对样本：

$$
X_1,\dots,X_n
$$

似然函数为：

$$
\prod_{i=1}^n f(X_i;\theta)
=
\exp\left\{
\sum_{j=1}^m p_j(\theta)\sum_{i=1}^nK_j(X_i)+nq(\theta)
\right\}
\exp\left\{
\sum_{i=1}^nH(X_i)
\right\}
$$

所以联合充分统计量为：

$$
Y_j=\sum_{i=1}^nK_j(X_i),
\qquad j=1,\dots,m
$$

即：

$$
Y=(Y_1,\dots,Y_m)^T
$$

在正则条件下，它还是完备充分统计量。

---

# 23. 多参数指数族例子：正态分布 $N(\theta_1,\theta_2)$

设：

$$
X_1,\dots,X_n\sim N(\theta_1,\theta_2)
$$

其中：

$$
\theta_1\in R,\qquad \theta_2>0
$$

密度为：

$$
f(x;\theta_1,\theta_2)=
\frac1{\sqrt{2\pi\theta_2}}
\exp\left\{
-\frac{(x-\theta_1)^2}{2\theta_2}
\right\}
$$

展开指数部分：

$$
-\frac{(x-\theta_1)^2}{2\theta_2}
=
-\frac{x^2}{2\theta_2}
+
\frac{\theta_1}{\theta_2}x
-
\frac{\theta_1^2}{2\theta_2}
$$

所以：

$$
K_1(x)=x^2
$$

$$
K_2(x)=x
$$

因此完备充分统计量为：

$$
Y_1=\sum_{i=1}^nX_i^2
$$

$$
Y_2=\sum_{i=1}^nX_i
$$

等价地，可换成一一对应的统计量：

$$
\bar X
$$

和：

$$
S^2=
\frac1{n-1}\sum_{i=1}^n(X_i-\bar X)^2
$$

因为：

$$
\sum X_i= n\bar X
$$

且：

$$
\sum X_i^2
=
(n-1)S^2+n\bar X^2
$$

所以：

$$
(\sum X_i,\sum X_i^2)
$$

和：

$$
(\bar X,S^2)
$$

是一一对应的。

因此：

$$
(\bar X,S^2)
$$

联合起来也是完备充分统计量。

---

# 24. 多项分布中的完备充分统计量与 MVUE

一次试验有 $k$ 类结果，概率为：

$$
p_1,\dots,p_k
$$

满足：

$$
\sum_{j=1}^k p_j=1
$$

令：

$$
X_j=I\{\text{第 }j\text{ 类发生}\}
$$

对 $n$ 次试验，令：

$$
Y_j=\sum_{i=1}^nX_{ji}
$$

表示第 $j$ 类出现次数。

由于：

$$
\sum_{j=1}^kY_j=n
$$

只需取前 $k-1$ 个：

$$
Y_1,\dots,Y_{k-1}
$$

它们联合起来是完备充分统计量。

---

## 24.1 $p_j$ 的 MVUE

因为：

$$
Y_j\sim Bin(n,p_j)
$$

所以：

$$
E\left(\frac{Y_j}{n}\right)=p_j
$$

因此：

$$
\frac{Y_j}{n}
$$

是 $p_j$ 的无偏估计。

由于它是完备充分统计量的函数，由 Lehmann-Scheffe 定理：

$$
\frac{Y_j}{n}
$$

是 $p_j$ 的 MVUE。

---

## 24.2 $p_jp_\ell$ 的 MVUE

对于：

$$
j\ne \ell
$$

作业和讲义中给出结论：

$$
E\left(\frac1{n^2}Y_jY_\ell\right)
=
\frac{n-1}{n}p_jp_\ell
$$

所以：

$$
\frac{n}{n-1}\cdot\frac{Y_jY_\ell}{n^2}
=
\frac{Y_jY_\ell}{n(n-1)}
$$

是：

$$
p_jp_\ell
$$

的无偏估计。

因此：

$$
\frac{Y_jY_\ell}{n(n-1)}
$$

是：

$$
p_jp_\ell
$$

的 MVUE。

如果讲义中采用不同记号，把比例估计写作 $Y_j/n$，结论要注意量纲：估计 $p_jp_\ell$ 时应使用 $Y_jY_\ell$ 除以 $n(n-1)$。

---

# 25. 多元正态分布的完备充分统计量

设：

$$
X_1,\dots,X_n
$$

为 $k$ 元正态分布：

$$
N(\mu,\Sigma)
$$

其中：

- $\mu$ 是 $k$ 维均值向量；
- $\Sigma$ 是 $k\times k$ 协方差矩阵。

密度可以写成指数族形式：

$$
f_X(x;\theta)
=
\exp\left\{
-\frac12x^T\Sigma^{-1}x
+
\mu^T\Sigma^{-1}x
-\frac12\mu^T\Sigma^{-1}\mu
-\frac12\log|\Sigma|
-\frac k2\log(2\pi)
\right\}
$$

其中关于样本的核心函数是：

$$
x
$$

和：

$$
xx^T
$$

因此完备充分统计量为：

$$
Y_1=\sum_{i=1}^nX_i
$$

和：

$$
Y_2=\sum_{i=1}^nX_iX_i^T
$$

因为 $Y_2$ 是对称矩阵，冗余元素不需要重复计数。

未知参数个数为：

$$
k+\frac{k(k+1)}2
$$

而统计量中非冗余元素个数也正好为：

$$
k+\frac{k(k+1)}2
$$

其中：

$$
\bar X_j
$$

是 $\mu_j$ 的 MVUE，

$$
\frac1{n-1}\sum_{i=1}^n(X_{ij}-\bar X_j)^2
$$

是对应方差分量的 MVUE。

---

# 26. 最小充分统计量

第十四讲最后讲最小充分统计量。

充分统计量可能不唯一。

例如：

$$
\sum X_i
$$

是充分统计量，那么：

$$
(\sum X_i,X_1)
$$

也包含全部信息，也可以是充分统计量，但明显不够简洁。

因此需要最小充分统计量。

---

## 26.1 定义

若一个充分统计量 $T$ 满足：

> 对任意其他充分统计量 $S$，$T$ 都可以表示成 $S$ 的函数。

则称 $T$ 是最小充分统计量。

也就是说：

$$
T=h(S)
$$

对任何充分统计量 $S$ 都成立。

直观理解：

> 最小充分统计量是在不丢失参数信息的前提下，压缩得最彻底的统计量。

---

## 26.2 最小充分统计量的维度不一定等于参数个数

如果参数是 $k$ 维，最小充分统计量的维度是否一定是 $k$？

答案：

> 不一定。

例如：

$$
X_1,\dots,X_n\sim U[\theta-1,\theta+1]
$$

只有一个参数：

$$
\theta
$$

但最小充分统计量是：

$$
(X_{(1)},X_{(n)})
$$

这是二维统计量。

因为似然函数为：

$$
L(\theta)=2^{-n}
I\{X_{(1)}\ge\theta-1\}
I\{X_{(n)}\le\theta+1\}
$$

必须同时知道最小值和最大值，才能确定 $\theta$ 的可行范围。

所以最小充分统计量维度可以大于参数维度。

---

## 26.3 MLE 与最小充分统计量

Lecture 14 提到：

如果 MLE 唯一存在，它是任意充分统计量的函数。

如果某个 MLE 本身也是充分统计量，那么它通常可以作为最小充分统计量。

常见例子：

1. 若：

$$
X_i\sim N(\theta,\sigma_0^2)
$$

且 $\sigma_0^2$ 已知，则：

$$
\hat\theta=\bar X
$$

是最小充分统计量。

2. 若：

$$
X_i\sim Poisson(\theta)
$$

则：

$$
\hat\theta=\bar X
$$

是最小充分统计量。

3. 若：

$$
X_i\sim U[0,\theta]
$$

则：

$$
\hat\theta=X_{(n)}
$$

是最小充分统计量。

4. 若：

$$
X_i\sim N(\theta_1,\theta_2)
$$

则：

$$
\hat\theta_1=\bar X
$$

和：

$$
\hat\theta_2=\frac{n-1}{n}S^2
$$

联合起来是最小充分统计量。

---

## 26.4 完备充分统计量与最小充分统计量的关系

Lehmann-Scheffe 相关结论：

> 完备充分统计量一定是最小充分统计量。

但反过来不一定。

即：

$$
CSS\Rightarrow minimal\ sufficient
$$

但：

$$
minimal\ sufficient\not\Rightarrow CSS
$$

例如：

$$
U[\theta-1,\theta+1]
$$

中的：

$$
(X_{(1)},X_{(n)})
$$

是最小充分统计量，但不是完备充分统计量。

---

# 27. 从属统计量

从属统计量也叫 ancillary statistic。

定义：

> 若统计量 $Z$ 的分布不依赖未知参数 $\theta$，则称 $Z$ 为从属统计量。

它的特点是：

> 自身不携带关于参数的信息，但可以反映样本结构或辅助检验模型。

---

## 27.1 正态位置模型中的从属统计量

若：

$$
X_1,\dots,X_n\sim N(\theta,1)
$$

则以下统计量分布都不依赖于 $\theta$：

$$
S^2
$$

$$
X_2-X_1
$$

$$
X_1-\bar X
$$

因为它们都消去了位置参数 $\theta$。

---

## 27.2 正态尺度模型中的从属统计量

若：

$$
X_1,\dots,X_n\sim N(0,\sigma^2)
$$

则：

$$
\frac{X_2}{X_1}
$$

和：

$$
\frac{X_1}{\bar X}
$$

的分布不依赖于 $\sigma$。

因为分子分母都含相同尺度 $\sigma$，比值中尺度被消掉。

---

# 四、HW7 重点题型讲解

---

# 28. HW7 Problem 1：判断是否属于正则指数分布类，并找完备充分统计量

这类题是第十三讲和第十四讲的核心题型。

标准步骤：

1. 写成：

$$
f(x;\theta)=\exp\{p(\theta)K(x)+H(x)+q(\theta)\}
$$

2. 检查支撑集是否不依赖未知参数；
3. 若属于正则指数族，则：

$$
T=\sum_{i=1}^nK(X_i)
$$

是完备充分统计量；
4. 若支撑集依赖参数，则通常不属于正则指数族。

---

## 28.1 几何分布

题目给：

$$
f(x;\theta)=(1-\theta)^x\theta,\qquad x=0,1,2,\dots
$$

其中：

$$
0<\theta<1
$$

写成指数族形式：

$$
f(x;\theta)=\exp\{x\log(1-\theta)+\log\theta\}
$$

所以：

$$
K(x)=x
$$

$$
p(\theta)=\log(1-\theta)
$$

$$
q(\theta)=\log\theta
$$

支撑集：

$$
S=\{0,1,2,\dots\}
$$

不依赖于 $\theta$。

因此属于正则指数分布类。

完备充分统计量为：

$$
T=\sum_{i=1}^nX_i
$$

---

## 28.2 拉普拉斯分布，$a=a_0$ 已知，$b$ 可变

密度为：

$$
f(x;b)=\frac1{2b}e^{-|x-a_0|/b}
$$

写成：

$$
f(x;b)
=
\exp\left\{
-\frac1b|x-a_0|-\log(2b)
\right\}
$$

所以：

$$
K(x)=|x-a_0|
$$

$$
p(b)=-\frac1b
$$

$$
q(b)=-\log(2b)
$$

支撑集为：

$$
R
$$

不依赖于 $b$。

因此属于正则指数分布类。

完备充分统计量为：

$$
T=\sum_{i=1}^n|X_i-a_0|
$$

HW7 易错点特别强调：这一问容易误判为非正则指数族。只要 $a_0$ 已知，未知参数只有 $b$，支撑集不依赖 $b$，就应判为正则指数族。

---

## 28.3 Rayleigh 分布

密度为：

$$
f(x;\theta)=\frac1{\theta^2}xe^{-x^2/(2\theta^2)},\qquad x>0
$$

写成：

$$
f(x;\theta)
=
\exp\left\{
-\frac1{2\theta^2}x^2+\log x-2\log\theta
\right\}
$$

所以：

$$
K(x)=x^2
$$

$$
p(\theta)=-\frac1{2\theta^2}
$$

$$
H(x)=\log x
$$

$$
q(\theta)=-2\log\theta
$$

完备充分统计量为：

$$
T=\sum_{i=1}^nX_i^2
$$

---

## 28.4 负二项分布

题目给：

$$
f(x;\theta)=\binom{x+r-1}{x}(1-\theta)^r\theta^x,
\qquad x=0,1,2,\dots
$$

其中 $r$ 已知。

写成：

$$
f(x;\theta)
=
\binom{x+r-1}{x}
\exp\{x\log\theta+r\log(1-\theta)\}
$$

所以：

$$
K(x)=x
$$

$$
p(\theta)=\log\theta
$$

$$
H(x)=\log\binom{x+r-1}{x}
$$

$$
q(\theta)=r\log(1-\theta)
$$

完备充分统计量为：

$$
T=\sum_{i=1}^nX_i
$$

---

## 28.5 Beta$(\theta,1)$ 分布

密度为：

$$
f(x;\theta)=\theta x^{\theta-1},\qquad 0<x<1,\theta>0
$$

写成：

$$
f(x;\theta)
=
\exp\{\log\theta+(\theta-1)\log x\}
$$

所以：

$$
K(x)=\log x
$$

$$
p(\theta)=\theta-1
$$

$$
q(\theta)=\log\theta
$$

完备充分统计量为：

$$
T=\sum_{i=1}^n\log X_i
$$

---

## 28.6 平移指数分布

密度为：

$$
f(x;\theta)=e^{-(x-\theta)},\qquad x>\theta
$$

也就是：

$$
f(x;\theta)=e^{-(x-\theta)}I\{x>\theta\}
$$

虽然可以写出指数形式，但关键问题是：

$$
S=(\theta,\infty)
$$

支撑集依赖于未知参数 $\theta$。

因此：

$$
f(x;\theta)
$$

不属于正则指数分布类。

不过它的充分统计量是：

$$
T=X_{(1)}=\min X_i
$$

但不能因为它有充分统计量就说它是正则指数族。

---

# 29. HW7 Problem 2：Gamma 型密度的 CSS 与 $\theta$ 的 MVUE

题目给：

$$
f(x;\theta)=\frac1{6\theta^4}x^3e^{-x/\theta},
\qquad x>0,\theta>0
$$

---

## 29.1 写成指数族形式

$$
f(x;\theta)
=
\frac{x^3}{6}\theta^{-4}e^{-x/\theta}
$$

写成：

$$
f(x;\theta)
=
\exp\left\{
-\frac1\theta x+3\log x-\log6-4\log\theta
\right\}
$$

所以：

$$
K(x)=x
$$

$$
p(\theta)=-\frac1\theta
$$

$$
H(x)=3\log x-\log6
$$

$$
q(\theta)=-4\log\theta
$$

因此属于正则指数分布类。

完备充分统计量为：

$$
Y=\sum_{i=1}^nX_i
$$

---

## 29.2 求 $\theta$ 的 MVUE

用指数族公式：

$$
E(Y)=
-\frac{nq'(\theta)}{p'(\theta)}
$$

这里：

$$
q'(\theta)=-\frac4\theta
$$

$$
p'(\theta)=\frac1{\theta^2}
$$

所以：

$$
E(Y)
=
-\frac{n(-4/\theta)}{1/\theta^2}
=
4n\theta
$$

因此：

$$
\frac{Y}{4n}
$$

是 $\theta$ 的无偏估计。

由于 $Y$ 是完备充分统计量，由 Lehmann-Scheffe 定理：

$$
\hat\theta_{MVUE}=\frac1{4n}\sum_{i=1}^nX_i
$$

HW7 易错点强调：

> 算出无偏还不够，必须说明 $Y$ 是完备充分统计量，并由 Lehmann-Scheffe 定理推出 MVUE。

---

# 30. HW7 Problem 3：$N(\mu_0,\theta)$ 中 $\theta$ 的 MVUE 与有效性

设：

$$
X_1,\dots,X_n\sim N(\mu_0,\theta)
$$

其中：

$$
\mu_0
$$

已知，$\theta$ 是方差。

---

## 30.1 完备充分统计量

密度写成：

$$
f(x;\theta)
=
\exp\left\{
-\frac1{2\theta}(x-\mu_0)^2
-\frac12\log(2\pi)
-\frac12\log\theta
\right\}
$$

所以：

$$
K(x)=(x-\mu_0)^2
$$

完备充分统计量为：

$$
Y=\sum_{i=1}^n(X_i-\mu_0)^2
$$

---

## 30.2 构造 MVUE

因为：

$$
\frac{Y}{\theta}\sim\chi^2(n)
$$

所以：

$$
E\left(\frac Y\theta\right)=n
$$

即：

$$
E(Y)=n\theta
$$

因此：

$$
\hat\theta=\frac Yn
=
\frac1n\sum_{i=1}^n(X_i-\mu_0)^2
$$

是 $\theta$ 的无偏估计。

由于它是完备充分统计量 $Y$ 的函数，由 Lehmann-Scheffe 定理，它是 $\theta$ 的 MVUE。

---

## 30.3 判断是否有效估计量

先求 Fisher 信息量。

单个样本对数密度：

$$
\ell(\theta)
=
-\frac12\log(2\pi)
-\frac12\log\theta
-\frac{(x-\mu_0)^2}{2\theta}
$$

一阶导：

$$
\ell'(\theta)
=
-\frac1{2\theta}
+
\frac{(x-\mu_0)^2}{2\theta^2}
$$

二阶导：

$$
\ell''(\theta)
=
\frac1{2\theta^2}
-
\frac{(x-\mu_0)^2}{\theta^3}
$$

所以：

$$
I(\theta)
=
-E[\ell''(\theta)]
$$

$$
=
-\frac1{2\theta^2}
+
\frac1{\theta^3}E[(X-\mu_0)^2]
$$

因为：

$$
E[(X-\mu_0)^2]=\theta
$$

所以：

$$
I(\theta)=\frac1{2\theta^2}
$$

注意这里是单个样本 Fisher 信息量，不要乘 $n$。

Rao-Cramer 下界：

$$
RCB=\frac1{nI(\theta)}=\frac{2\theta^2}{n}
$$

再算估计量方差：

$$
\frac{Y}{\theta}\sim\chi^2(n)
$$

所以：

$$
Var\left(\frac Y\theta\right)=2n
$$

因此：

$$
Var(Y)=2n\theta^2
$$

$$
Var\left(\frac Yn\right)
=
\frac1{n^2}Var(Y)
=
\frac{2\theta^2}{n}
$$

这正好等于 RCB。

所以：

$$
\hat\theta=\frac1n\sum_{i=1}^n(X_i-\mu_0)^2
$$

是有效估计量。

HW7 易错点强调：

> Fisher 信息量 $I(\theta)$ 应为不乘 $n$ 的结果，即 $1/(2\theta^2)$。如果写 $n/(2\theta^2)$，必须明确那是样本总信息量 $I_n(\theta)$。

---

# 31. HW7 Problem 4：Weibull 分布与 $\theta^{k_0}$ 的 MVUE

题目给 Weibull 分布：

$$
f(x;\theta)
=
\frac{k_0x^{k_0-1}}{\theta^{k_0}}
\exp\left\{
-\frac{x^{k_0}}{\theta^{k_0}}
\right\},
\qquad x>0
$$

其中：

$$
k_0
$$

已知，$\theta>0$ 未知。

---

## 31.1 写成指数族形式

$$
f(x;\theta)
=
\exp\left\{
-\frac1{\theta^{k_0}}x^{k_0}
+\log k_0+(k_0-1)\log x
-k_0\log\theta
\right\}
$$

所以：

$$
K(x)=x^{k_0}
$$

$$
p(\theta)=-\frac1{\theta^{k_0}}
$$

$$
H(x)=\log k_0+(k_0-1)\log x
$$

$$
q(\theta)=-k_0\log\theta
$$

属于正则指数分布类。

完备充分统计量为：

$$
Y=\sum_{i=1}^nX_i^{k_0}
$$

---

## 31.2 求 $\theta^{k_0}$ 的 MVUE

注意题目要求估计的是：

$$
\theta^{k_0}
$$

不是：

$$
\frac1{\theta^{k_0}}
$$

计算：

令：

$$
T=\frac{X^{k_0}}{\theta^{k_0}}
$$

则：

$$
T\sim Exp(1)
$$

所以：

$$
E(T)=1
$$

即：

$$
E(X^{k_0})=\theta^{k_0}
$$

因此：

$$
E(Y)=n\theta^{k_0}
$$

所以：

$$
\frac Yn
=
\frac1n\sum_{i=1}^nX_i^{k_0}
$$

是：

$$
\theta^{k_0}
$$

的无偏估计。

由于 $Y$ 是完备充分统计量，由 Lehmann-Scheffe 定理：

$$
\widehat{\theta^{k_0}}_{MVUE}
=
\frac1n\sum_{i=1}^nX_i^{k_0}
$$

HW7 易错点：

1. 看清题目要求的是 $\theta^{k_0}$ 的 MVUE，不是 $1/\theta^{k_0}$；
2. 若把 $X^{k_0}$ 看作一个整体，其满足指数分布时要说明参数化，不要把尺度参数和速率参数混淆。

---

# 32. HW7 Problem 5：正态分布中 $a\theta^2+b\theta+c$ 的 MVUE

设：

$$
X_1,\dots,X_n\sim N(\theta,\sigma_0^2)
$$

其中：

$$
\sigma_0^2
$$

已知。

要求估计：

$$
g(\theta)=a\theta^2+b\theta+c
$$

---

## 32.1 完备充分统计量

正态均值模型属于正则指数族，完备充分统计量为：

$$
Y=\sum_{i=1}^nX_i
$$

等价地：

$$
\bar X
$$

也是完备充分统计量。

---

## 32.2 构造 $\theta$ 与 $\theta^2$ 的无偏估计

首先：

$$
E(\bar X)=\theta
$$

所以：

$$
\bar X
$$

是 $\theta$ 的无偏估计。

其次：

$$
Var(\bar X)=\frac{\sigma_0^2}{n}
$$

所以：

$$
E(\bar X^2)=\theta^2+\frac{\sigma_0^2}{n}
$$

因此：

$$
\bar X^2-\frac{\sigma_0^2}{n}
$$

是 $\theta^2$ 的无偏估计。

于是：

$$
a\left(\bar X^2-\frac{\sigma_0^2}{n}\right)+b\bar X+c
$$

是：

$$
a\theta^2+b\theta+c
$$

的无偏估计。

由于它是完备充分统计量 $\bar X$ 的函数，由 Lehmann-Scheffe 定理，MVUE 为：

$$
\boxed{
\widehat{g(\theta)}_{MVUE}
=
a\left(\bar X^2-\frac{\sigma_0^2}{n}\right)+b\bar X+c
}
$$

---

# 33. HW7 Problem 6：Poisson 中 $P(X_1=k)$ 的 MVUE

设：

$$
X_1,\dots,X_n\sim Poisson(\theta)
$$

要估计：

$$
g(\theta)=P(X_1=k)=\frac{\theta^ke^{-\theta}}{k!}
$$

其中：

$$
k
$$

是给定非负整数。

---

## 33.1 完备充分统计量

Poisson 分布属于正则指数族：

$$
f(x;\theta)=\exp\{x\log\theta-\theta-\log(x!)\}
$$

所以：

$$
Y=\sum_{i=1}^nX_i
$$

是完备充分统计量。

且：

$$
Y\sim Poisson(n\theta)
$$

---

## 33.2 粗糙无偏估计

令：

$$
\psi(X_1)=I\{X_1=k\}
$$

则：

$$
E[\psi(X_1)]
=
P(X_1=k)
=
g(\theta)
$$

所以它是无偏估计。

---

## 33.3 Rao-Blackwell 改进

由 Rao-Blackwell 定理和 Lehmann-Scheffe 定理，MVUE 为：

$$
E[\psi(X_1)|Y]
$$

计算：

$$
E[\psi(X_1)|Y=y]
=
P(X_1=k|Y=y)
$$

由于：

$$
Y=X_1+\sum_{i=2}^nX_i
$$

且：

$$
\sum_{i=2}^nX_i\sim Poisson((n-1)\theta)
$$

若：

$$
y\ge k
$$

则：

$$
P(X_1=k,Y=y)
=
P(X_1=k)
P\left(\sum_{i=2}^nX_i=y-k\right)
$$

$$
=
\frac{\theta^ke^{-\theta}}{k!}
\cdot
\frac{[(n-1)\theta]^{y-k}e^{-(n-1)\theta}}{(y-k)!}
$$

而：

$$
P(Y=y)=\frac{(n\theta)^ye^{-n\theta}}{y!}
$$

所以：

$$
P(X_1=k|Y=y)
=
\frac{
\frac{\theta^ke^{-\theta}}{k!}
\frac{[(n-1)\theta]^{y-k}e^{-(n-1)\theta}}{(y-k)!}
}{
\frac{(n\theta)^ye^{-n\theta}}{y!}
}
$$

化简得：

$$
P(X_1=k|Y=y)
=
\binom yk
\left(\frac1n\right)^k
\left(1-\frac1n\right)^{y-k}
$$

当：

$$
y<k
$$

时，概率为 0。

因此 MVUE 为：

$$
\boxed{
\widehat{g(\theta)}_{MVUE}
=
\begin{cases}
\binom Yk
\left(\frac1n\right)^k
\left(1-\frac1n\right)^{Y-k},&Y\ge k\\
0,&Y<k
\end{cases}
}
$$

HW7 易错点：

> 这是分段函数。当 $Y<k$ 时，条件期望是 0，不能漏掉这一种情况。

---

# 34. HW7 Problem 7：$Bin(2,\theta)$ 中 $g(\theta)=\theta(1+\theta)$ 的 MVUE

设：

$$
X_1,\dots,X_n\sim Bin(2,\theta)
$$

要估计：

$$
g(\theta)=\theta(1+\theta)=\theta+\theta^2
$$

---

## 34.1 完备充分统计量

单个样本：

$$
X_i\sim Bin(2,\theta)
$$

所以：

$$
Y=\sum_{i=1}^nX_i\sim Bin(2n,\theta)
$$

且 $Y$ 是完备充分统计量。

---

## 34.2 方法一：先找依赖 $X_1$ 的无偏估计，再 Rao-Blackwell

因为：

$$
E(X_1)=2\theta
$$

$$
Var(X_1)=2\theta(1-\theta)
$$

所以：

$$
E(X_1^2)=Var(X_1)+[E(X_1)]^2
$$

$$
=
2\theta(1-\theta)+4\theta^2
=
2\theta+2\theta^2
=
2\theta(1+\theta)
$$

因此：

$$
Y_2=\frac{X_1^2}{2}
$$

是：

$$
g(\theta)=\theta(1+\theta)
$$

的无偏估计。

也可以取：

$$
Y_2=\frac12I\{X_1=1\}+2I\{X_1=2\}
$$

因为：

$$
P(X_1=1)=2\theta(1-\theta)
$$

$$
P(X_1=2)=\theta^2
$$

所以：

$$
E(Y_2)=\theta(1-\theta)+2\theta^2=\theta+\theta^2
$$

---

## 34.3 计算 Rao-Blackwell 条件期望

给定：

$$
Y=t
$$

时，等价于在：

$$
2n
$$

次 Bernoulli 试验中总共有：

$$
t
$$

次成功。

而 $X_1$ 对应其中前 2 次 Bernoulli 试验的成功个数。

所以：

$$
X_1|Y=t
$$

服从超几何分布：

$$
P(X_1=j|Y=t)
=
\frac{\binom tj\binom{2n-t}{2-j}}{\binom{2n}{2}},
\qquad j=0,1,2
$$

如果使用：

$$
Y_2=\frac{X_1^2}{2}
$$

则：

$$
E(Y_2|Y=t)
=
\frac12E(X_1^2|Y=t)
$$

计算：

$$
E(Y_2|Y=t)
=
\frac12
\left[
1^2P(X_1=1|Y=t)+2^2P(X_1=2|Y=t)
\right]
$$

$$
=
\frac12
\left[
\frac{\binom t1\binom{2n-t}1}{\binom{2n}2}
+
4\frac{\binom t2}{\binom{2n}2}
\right]
$$

化简得到：

$$
E(Y_2|Y=t)
=
\frac{t(t+2n-2)}{2n(2n-1)}
$$

因此 MVUE 为：

$$
\boxed{
\widehat{g(\theta)}_{MVUE}
=
\frac{Y(Y+2n-2)}{2n(2n-1)}
}
$$

其中：

$$
Y=\sum_{i=1}^nX_i
$$

---

## 34.4 方法二：直接构造 $Y$ 的函数

因为：

$$
Y\sim Bin(2n,\theta)
$$

有：

$$
E(Y)=2n\theta
$$

$$
Var(Y)=2n\theta(1-\theta)
$$

所以：

$$
E(Y^2)=2n\theta(1-\theta)+4n^2\theta^2
$$

设：

$$
\hat g=aY+bY^2
$$

要求：

$$
E(\hat g)=\theta+\theta^2
$$

即：

$$
aE(Y)+bE(Y^2)=\theta+\theta^2
$$

代入：

$$
a(2n\theta)
+
b[2n\theta(1-\theta)+4n^2\theta^2]
=
\theta+\theta^2
$$

整理：

$$
[2na+2nb]\theta
+
[4n^2b-2nb]\theta^2
=
\theta+\theta^2
$$

所以：

$$
2n(a+b)=1
$$

$$
b(4n^2-2n)=1
$$

得到：

$$
b=\frac1{4n^2-2n}
$$

$$
a=\frac{2(n-1)}{4n^2-2n}
$$

因此：

$$
\hat g
=
\frac{2(n-1)Y+Y^2}{4n^2-2n}
$$

化简：

$$
\hat g
=
\frac{Y(Y+2n-2)}{2n(2n-1)}
$$

与 Rao-Blackwell 方法一致。

---

# 35. HW7 Problem 8：逆高斯分布的完备充分统计量

题目给逆高斯分布：

$$
f(x;\theta_1,\theta_2)
=
\left(\frac{\theta_2}{2\pi x^3}\right)^{1/2}
\exp\left[
-\frac{\theta_2(x-\theta_1)^2}{2\theta_1^2x}
\right],
\qquad x>0
$$

要求求：

$$
(\theta_1,\theta_2)
$$

的完备充分统计量。

---

## 35.1 展开指数部分

先展开：

$$
(x-\theta_1)^2=x^2-2\theta_1x+\theta_1^2
$$

所以：

$$
\frac{(x-\theta_1)^2}{\theta_1^2x}
=
\frac{x^2-2\theta_1x+\theta_1^2}{\theta_1^2x}
$$

$$
=
\frac{x}{\theta_1^2}
-\frac2{\theta_1}
+\frac1x
$$

于是指数项为：

$$
-\frac{\theta_2}{2}
\left(
\frac{x}{\theta_1^2}
-\frac2{\theta_1}
+\frac1x
\right)
$$

$$
=
-\frac{\theta_2}{2\theta_1^2}x
+
\frac{\theta_2}{\theta_1}
-
\frac{\theta_2}{2}\frac1x
$$

再加上前面的系数：

$$
\left(\frac{\theta_2}{2\pi x^3}\right)^{1/2}
$$

取对数后有：

$$
\frac12\log\theta_2-\frac12\log(2\pi)-\frac32\log x
$$

因此密度可以写成：

$$
f(x;\theta_1,\theta_2)
=
\exp\left\{
-\frac{\theta_2}{2\theta_1^2}x
-\frac{\theta_2}{2}\frac1x
-\frac32\log x
+\frac{\theta_2}{\theta_1}
+\frac12\log\theta_2
-\frac12\log(2\pi)
\right\}
$$

---

## 35.2 识别指数族形式

可取：

$$
K_1(x)=x
$$

$$
K_2(x)=\frac1x
$$

对应：

$$
p_1(\theta)=-\frac{\theta_2}{2\theta_1^2}
$$

$$
p_2(\theta)=-\frac{\theta_2}{2}
$$

$$
H(x)=-\frac32\log x
$$

$$
q(\theta)=\frac{\theta_2}{\theta_1}+\frac12\log\theta_2-\frac12\log(2\pi)
$$

因此它属于多参数正则指数分布类。

完备充分统计量为：

$$
\boxed{
Y=
\left(
\sum_{i=1}^nX_i,\ 
\sum_{i=1}^n\frac1{X_i}
\right)^T
}
$$

---

# 五、这两讲的重点题型模板

---

# 36. 题型一：证明完备性

## 题目特征

题目会让你证明某个统计量的分布族完备。

## 做法

写：

$$
E[u(T)]=0
$$

对所有参数成立。

然后根据具体分布推导：

- 离散型常变成幂级数恒等式；
- 连续型常变成 Laplace 变换或积分恒等式；
- 均匀最大值常对积分上限求导。

## 常见例子

### Poisson

幂级数系数全为 0。

### Exponential

Laplace 变换恒为 0 推出函数为 0。

### Uniform 最大值

由：

$$
\int_0^\theta u(y)y^{n-1}dy=0
$$

对 $\theta$ 求导推出：

$$
u(\theta)=0
$$

---

# 37. 题型二：用 Lehmann-Scheffe 求 MVUE

## 标准模板

1. 找完备充分统计量：

$$
T
$$

2. 构造 $T$ 的函数：

$$
\phi(T)
$$

3. 证明：

$$
E[\phi(T)]=g(\theta)
$$

4. 写结论：

因为 $T$ 是完备充分统计量，且 $\phi(T)$ 是 $g(\theta)$ 的无偏估计，所以由 Lehmann-Scheffe 定理：

$$
\phi(T)
$$

是 $g(\theta)$ 的 MVUE。

## 易错点

不能只写“它无偏，所以是 MVUE”。

必须说明：

1. $T$ 是完备充分统计量；
2. $\phi(T)$ 是 $T$ 的函数；
3. $\phi(T)$ 无偏；
4. 所以由 Lehmann-Scheffe 定理得出 MVUE。

---

# 38. 题型三：用 Rao-Blackwell 求 MVUE

## 标准模板

1. 找一个粗糙无偏估计量：

$$
Y
$$

2. 找完备充分统计量：

$$
T
$$

3. 计算条件期望：

$$
E(Y|T)
$$

4. 最终答案必须写成 $T$ 的函数；
5. 由 Rao-Blackwell 定理说明方差不增；
6. 由 Lehmann-Scheffe 定理说明它是 MVUE。

## 常见条件期望技巧

### Bernoulli 给定总成功数

给定：

$$
\sum X_i=y
$$

时，所有含 $y$ 个 1 的排列等可能。

### Poisson 给定总和

若：

$$
X_1,\dots,X_n\sim Poisson(\theta)
$$

给定：

$$
Y=\sum X_i=y
$$

则：

$$
X_1|Y=y\sim Bin\left(y,\frac1n\right)
$$

因此：

$$
P(X_1=k|Y=y)
=
\binom yk
\left(\frac1n\right)^k
\left(1-\frac1n\right)^{y-k}
$$

### Binomial 总和

若：

$$
X_i\sim Bin(2,\theta)
$$

给定：

$$
Y=\sum X_i=t
$$

则 $X_1|Y=t$ 可看作超几何分布。

---

# 39. 题型四：判断正则指数分布类

## 标准模板

1. 写原密度或概率函数；
2. 改写成：

$$
\exp\{p(\theta)K(x)+H(x)+q(\theta)\}
$$

或多参数形式：

$$
\exp\left\{\sum_jp_j(\theta)K_j(x)+H(x)+q(\theta)\right\}
$$

3. 检查支撑集是否依赖参数；
4. 若支撑集不依赖参数且满足正则条件，则属于正则指数族；
5. 完备充分统计量为：

一参数：

$$
T=\sum K(X_i)
$$

多参数：

$$
T_j=\sum K_j(X_i)
$$

## 易错点

1. 支撑集依赖参数则不是正则指数族；
2. 不是正则指数族不等于没有充分统计量；
3. 拉普拉斯分布中如果位置 $a_0$ 已知、尺度 $b$ 未知，支撑集是全实数，不依赖 $b$，所以属于正则指数族；
4. 题目给多个分布时，要逐个写出 $K,p,H,q$，不能只写结论。

---

# 40. 题型五：参数函数 $g(\theta)$ 的 MVUE

## 常见套路

如果 $g(\theta)$ 是多项式：

- 找 $E(T)$；
- 找 $E(T^2)$；
- 线性组合构造无偏估计。

例如：

$$
g(\theta)=a\theta^2+b\theta+c
$$

就分别构造：

- $\theta$ 的无偏估计；
- $\theta^2$ 的无偏估计；
- 常数项直接保留。

如果 $g(\theta)=P(X=k)$：

- 先取指示函数：

$$
I\{X_1=k\}
$$

- 再对完备充分统计量取条件期望。

如果 $g(\theta)$ 是一般可微函数，且模型为：

$$
U[0,\theta]
$$

则可用公式：

$$
g(Y)+\frac{Yg'(Y)}n
$$

其中：

$$
Y=X_{(n)}
$$

---

# 41. 题型六：最小充分统计量与从属统计量

## 最小充分统计量判断

常见结论：

1. 若 MLE 唯一存在且本身是充分统计量，则它往往是最小充分统计量；
2. 完备充分统计量一定是最小充分统计量；
3. 最小充分统计量不一定完备；
4. 最小充分统计量维度不一定等于参数维度。

## 从属统计量判断

看统计量分布是否不依赖未知参数。

例如位置模型中：

$$
X_i=\theta+\varepsilon_i
$$

差值：

$$
X_i-X_j
$$

通常不依赖 $\theta$。

尺度模型中：

$$
X_i=\sigma Z_i
$$

比值：

$$
\frac{X_i}{X_j}
$$

通常不依赖 $\sigma$。

---

# 六、HW7 易错点总整理

---

# 42. Problem 1 易错点

## 拉普拉斯分布不要误判

若：

$$
f(x;b)=\frac1{2b}e^{-|x-a_0|/b}
$$

其中 $a_0$ 已知，$b$ 未知。

它可以写成：

$$
\exp\left\{
-\frac1b|x-a_0|-\log(2b)
\right\}
$$

所以属于正则指数族。

完备充分统计量是：

$$
\sum |X_i-a_0|
$$

不能因为看到绝对值就误判为不属于指数族。

---

# 43. Problem 2、3、4、5、6 的共同易错点

很多题中，算出一个无偏估计之后，不能直接说它是 MVUE。

必须补一句：

> 因为 $Y$ 是完备充分统计量，且该估计量是 $Y$ 的函数并且无偏，所以由 Lehmann-Scheffe 定理，它是 MVUE。

这句话经常有过程分。

---

# 44. Problem 3 易错点

Fisher 信息量：

$$
I(\theta)=\frac1{2\theta^2}
$$

这是单个样本的信息量。

如果写：

$$
\frac n{2\theta^2}
$$

必须明确这是样本总信息量：

$$
I_n(\theta)
$$

否则容易扣分。

---

# 45. Problem 4 易错点

题目要求的是：

$$
\theta^{k_0}
$$

的 MVUE，不是：

$$
\frac1{\theta^{k_0}}
$$

最终答案是：

$$
\frac1n\sum X_i^{k_0}
$$

不要写反。

---

# 46. Problem 6 易错点

Poisson 中估计：

$$
g(\theta)=P(X_1=k)
$$

的 MVUE 是分段函数：

$$
\begin{cases}
\binom Yk(1/n)^k(1-1/n)^{Y-k},&Y\ge k\\
0,&Y<k
\end{cases}
$$

不能漏掉：

$$
Y<k
$$

时为 0。

---

# 47. Problem 7 易错点

构造 $g(\theta)=\theta(1+\theta)$ 的粗糙无偏估计不唯一。

可用：

$$
Y_2=\frac{X_1^2}{2}
$$

也可用：

$$
Y_2=\frac12I\{X_1=1\}+2I\{X_1=2\}
$$

最终 MVUE 为：

$$
\frac{Y(Y+2n-2)}{2n(2n-1)}
$$

其中：

$$
Y=\sum X_i
$$

---

# 七、考前速记

---

# 48. 完备性速记

完备性：

$$
E_\theta[u(T)]=0\ \forall\theta
\Rightarrow
u(T)=0\ a.s.
$$

完备充分统计量：

$$
T\text{ 充分且分布族完备}
$$

Lehmann-Scheffe：

$$
T\text{ 完备充分},\quad E[\phi(T)]=g(\theta)
\Rightarrow
\phi(T)\text{ 是 }g(\theta)\text{ 的唯一 MVUE}
$$

---

# 49. 正则指数族速记

一参数形式：

$$
f(x;\theta)=\exp\{p(\theta)K(x)+H(x)+q(\theta)\}
$$

样本完备充分统计量：

$$
Y=\sum_{i=1}^nK(X_i)
$$

期望公式：

$$
E(Y)=
-\frac{nq'(\theta)}{p'(\theta)}
$$

方差公式：

$$
Var(Y)
=
\frac{
n[p''(\theta)q'(\theta)-q''(\theta)p'(\theta)]
}{
[p'(\theta)]^3
}
$$

---

# 50. 多参数指数族速记

多参数形式：

$$
f(x;\theta)
=
\exp\left\{
\sum_{j=1}^m p_j(\theta)K_j(x)+H(x)+q(\theta)
\right\}
$$

完备充分统计量：

$$
Y_j=\sum_{i=1}^nK_j(X_i),\qquad j=1,\dots,m
$$

---

# 51. 常见 CSS 表

| 分布 | 完备充分统计量 |
|---|---|
| $Bernoulli(\theta)$ | $\sum X_i$ |
| $Bin(m,\theta)$，$m$ 已知 | $\sum X_i$ |
| $Poisson(\theta)$ | $\sum X_i$ |
| 几何分布 | $\sum X_i$ |
| 负二项分布，$r$ 已知 | $\sum X_i$ |
| $Exp(\theta)$ 速率参数 | $\sum X_i$ |
| $Exp(1/\theta)$ 尺度参数 | $\sum X_i$ |
| $N(\theta,\sigma_0^2)$ | $\sum X_i$ 或 $\bar X$ |
| $N(\mu_0,\theta)$ | $\sum(X_i-\mu_0)^2$ |
| $N(\mu,\sigma^2)$ 两参数 | $(\sum X_i,\sum X_i^2)$ 或 $(\bar X,S^2)$ |
| $U[0,\theta]$ | $X_{(n)}$ |
| $Beta(\theta,1)$ | $\sum\log X_i$ |
| Rayleigh | $\sum X_i^2$ |
| Weibull，$k_0$ 已知 | $\sum X_i^{k_0}$ |
| 逆高斯两参数 | $(\sum X_i,\sum 1/X_i)$ |

---

# 52. 常见 MVUE 表

| 模型 | 目标 | MVUE |
|---|---|---|
| $U[0,\theta]$ | $\theta$ | $\frac{n+1}{n}X_{(n)}$ |
| $U[0,\theta]$ | $g(\theta)$ | $g(Y)+\frac{Yg'(Y)}n,\ Y=X_{(n)}$ |
| $Bernoulli(\theta)$ | $\theta(1-\theta)$ | $\frac{Y(n-Y)}{n(n-1)}$ |
| $N(\theta,1)$ | $\theta^2$ | $\bar X^2-\frac1n$ |
| $N(\theta,\sigma_0^2)$ | $a\theta^2+b\theta+c$ | $a(\bar X^2-\sigma_0^2/n)+b\bar X+c$ |
| $N(\mu_0,\theta)$ | $\theta$ | $\frac1n\sum(X_i-\mu_0)^2$ |
| Gamma 型 $x^3e^{-x/\theta}/(6\theta^4)$ | $\theta$ | $\frac1{4n}\sum X_i$ |
| Weibull | $\theta^{k_0}$ | $\frac1n\sum X_i^{k_0}$ |
| Poisson | $P(X=k)$ | $\binom Yk(1/n)^k(1-1/n)^{Y-k}$，$Y\ge k$，否则 0 |
| $Bin(2,\theta)$ | $\theta(1+\theta)$ | $\frac{Y(Y+2n-2)}{2n(2n-1)}$ |

---

# 53. 最后检查清单

每道题写完后检查：

1. 是否先找了充分统计量？
2. 是否说明它是完备充分统计量？
3. 如果使用 Lehmann-Scheffe，是否明确写了“由 Lehmann-Scheffe 定理”？
4. 如果使用 Rao-Blackwell，是否先证明了粗糙估计无偏？
5. 条件期望最终是否写成统计量，而不是具体值？
6. 判断正则指数族时，是否检查了支撑集是否依赖参数？
7. 是否正确识别 $K(x)$？
8. 是否把完备充分统计量写成 $\sum K(X_i)$？
9. 题目估计的是 $\theta$、$\theta^2$、$\theta^{k_0}$ 还是 $1/\theta^{k_0}$？
10. Fisher 信息量是否误乘了 $n$？
11. 分段条件是否漏掉，例如 Poisson 中 $Y<k$ 的情况？
12. 最小充分统计量和完备充分统计量是否混淆？
13. 从属统计量是否确认其分布不依赖未知参数？

---

# 54. 一句话总结

第十三讲的核心：

> 完备充分统计量 + 无偏函数 = 唯一 MVUE。

第十四讲的核心：

> 参数函数的 MVUE 可以用 Lehmann-Scheffe 直接构造，也可以用 Rao-Blackwell 条件期望构造；多参数指数族中，所有 $\sum K_j(X_i)$ 联合起来是完备充分统计量；最小充分统计量强调“压缩到最少”，从属统计量强调“分布不含参数”。
