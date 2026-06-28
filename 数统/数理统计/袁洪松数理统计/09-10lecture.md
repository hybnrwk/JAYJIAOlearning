# 数理统计第九讲、第十讲完整复习笔记
## Rao-Cramer 下界、Fisher 信息量、有效估计量、极大似然检验、Wald 检验、Score 检验

---

# 0. 这两讲在整门课里的位置

前面几讲已经讲了：

1. 点估计：
   - 矩估计；
   - 极大似然估计；
   - 无偏性；
   - 有效性；
   - MSE；
   - 相合性。

2. 区间估计：
   - 置信区间；
   - 枢轴量法；
   - 正态总体均值和方差的置信区间。

3. 假设检验：
   - 原假设和备择假设；
   - 拒绝域；
   - 显著性水平；
   - p 值；
   - z 检验、t 检验、卡方检验、F 检验；
   - 拟合优度检验；
   - 方差分析。

第九讲和第十讲是在前面内容上的进一步理论化。

第九讲主要回答：

> 对于无偏估计量，它的方差最小能小到什么程度？

这个问题的答案就是 **Rao-Cramer 下界**，也叫 **Cramer-Rao lower bound**，简称 **RCB**。

第十讲主要回答：

> 面对一个参数假设检验问题，能不能不用直觉构造检验统计量，而是从似然函数出发系统地构造检验？

这个问题的答案就是：

1. 极大似然检验；
2. 似然比检验；
3. Wald 型检验；
4. Rao 得分型检验，也叫 Score test。

这两讲可以用一条主线串起来：

> 似然函数不仅可以用来做估计，还可以用来衡量估计量好不好，并且可以系统地构造假设检验方法。

第九讲偏“估计理论”：

- 得分函数；
- Fisher 信息量；
- Rao-Cramer 下界；
- 有效估计量；
- 有效性。

第十讲偏“检验理论”：

- 似然比统计量；
- LRT 拒绝域；
- $-2\log\Lambda$ 的渐近卡方分布；
- Wald 型检验；
- 得分型检验。

---

# 一、Lecture 09：估计的 Rao-Cramer 下界与有效性

---

# 1. 极大似然估计回顾

设总体有密度函数或概率质量函数：

$$
f(x;\theta),\qquad \theta\in\Omega
$$

样本为：

$$
X_1,\dots,X_n
$$

因为样本独立同分布，所以似然函数为：

$$
L(\theta)=\prod_{i=1}^n f(X_i;\theta)
$$

对数似然函数为：

$$
\ell(\theta)=\sum_{i=1}^n \log f(X_i;\theta)
$$

极大似然估计量定义为：

$$
\hat\theta=\arg\max_{\theta\in\Omega}L(\theta)
$$

由于对数函数单调递增，所以也可以写成：

$$
\hat\theta=\arg\max_{\theta\in\Omega}\ell(\theta)
$$

通常求 MLE 的步骤是：

1. 写出单个样本密度或概率质量函数；
2. 写出似然函数；
3. 取对数；
4. 对参数求导；
5. 令导数为 0；
6. 解出参数；
7. 检查参数范围、边界点和单调性。

---

# 2. 为什么第九讲还要回顾 MLE？

因为第九讲后面讲的 Fisher 信息量、Rao-Cramer 下界和有效性，都和对数似然函数的导数密切相关。

前面求 MLE 时已经多次用过：

$$
\ell'(\theta)
$$

也就是对数似然函数关于参数的导数。

第九讲把这个导数正式命名为 **得分函数**，并用它定义 Fisher 信息量。

---

# 3. MLE 不一定有显式解

前面很多 MLE 题可以直接求导解出参数，例如：

- Bernoulli 分布；
- Poisson 分布；
- 指数分布；
- 正态分布；
- Gamma 分布中某些参数已知的情况。

但第九讲提醒：并不是所有 MLE 都能显式写出来。

---

## 3.1 Laplace 分布的 MLE：样本中位数

设：

$$
X_1,\dots,X_n
$$

来自 Laplace 分布：

$$
f(x;\theta)=\frac12 e^{-|x-\theta|},\qquad x\in R,\ \theta\in R
$$

对数似然函数为：

$$
\ell(\theta)=-n\log 2-\sum_{i=1}^n |X_i-\theta|
$$

最大化 $\ell(\theta)$ 等价于最小化：

$$
\sum_{i=1}^n |X_i-\theta|
$$

这就是最小绝对偏差问题。

其解为样本中位数：

$$
\hat\theta=Q_2
$$

其中 $Q_2$ 表示样本中位数。

直观解释：

> 平均数最小化平方损失，中位数最小化绝对损失。

Laplace 分布的 MLE 是中位数，而不是样本均值，这一点很重要。

---

## 3.2 Logistic 分布的 MLE：通常没有显式解

设：

$$
f(x;\theta)=
\frac{\exp\{-(x-\theta)\}}
{[1+\exp\{-(x-\theta)\}]^2},
\qquad x\in R,\ \theta\in R
$$

对数似然函数为：

$$
\ell(\theta)
=
n\theta-n\bar X
-
2\sum_{i=1}^n
\log[1+\exp\{-(X_i-\theta)\}]
$$

求导得：

$$
\ell'(\theta)
=
n
-
2\sum_{i=1}^n
\frac{\exp\{-(X_i-\theta)\}}
{1+\exp\{-(X_i-\theta)\}}
$$

令：

$$
\ell'(\theta)=0
$$

一般无法得到显式解，只能用数值方法求解。

这说明：

> MLE 的定义很简单，但具体求解不一定总有闭式表达式。

---

## 3.3 Bernoulli 分布带限制条件的 MLE

设：

$$
X_1,\dots,X_n\sim Bernoulli(\theta)
$$

概率质量函数为：

$$
f(x;\theta)=\theta^x(1-\theta)^{1-x},\qquad x=0,1
$$

对数似然函数为：

$$
\ell(\theta)
=
\sum_{i=1}^n X_i\log\theta
+
\sum_{i=1}^n(1-X_i)\log(1-\theta)
$$

求导：

$$
\ell'(\theta)
=
\frac{1}{\theta}\sum_{i=1}^nX_i
-
\frac{1}{1-\theta}\sum_{i=1}^n(1-X_i)
$$

令导数为 0，可以得到无约束 MLE：

$$
\hat\theta=\bar X
$$

如果参数空间限制为：

$$
0\le \theta\le \frac13
$$

则需要结合参数范围。

如果：

$$
\bar X\le \frac13
$$

那么：

$$
\hat\theta=\bar X
$$

如果：

$$
\bar X>\frac13
$$

由于无约束最大点落在参数空间外，且在区间：

$$
0\le \theta\le \frac13
$$

内似然函数随 $\theta$ 增大而增大，所以最大值在右端点取得：

$$
\hat\theta=\frac13
$$

因此：

$$
\hat\theta=\min\{\bar X,\frac13\}
$$

这个例子说明：

> MLE 不能只机械求导，还必须考虑参数空间。

---

# 4. MLE 不变性

若：

$$
\hat\theta
$$

是 $\theta$ 的 MLE，并且：

$$
\eta=g(\theta)
$$

则：

$$
\hat\eta=g(\hat\theta)
$$

是 $\eta$ 的 MLE。

例如：

若：

$$
\hat\theta=\bar X
$$

是 $\theta$ 的 MLE，则：

$$
\theta^2
$$

的 MLE 是：

$$
\hat\theta^2=\bar X^2
$$

注意：

> MLE 不变性只说明怎么求变换后参数的 MLE，不保证它无偏，也不保证它达到 Rao-Cramer 下界。

---

# 5. Fisher 信息量

---

## 5.1 得分函数

对单个样本 $X$，定义：

$$
U(\theta)
=
\frac{\partial}{\partial\theta}\log f(X;\theta)
$$

称为得分函数，英文是 score function。

直观上：

> 得分函数表示对数密度对参数的敏感程度。

如果：

$$
\frac{\partial}{\partial\theta}\log f(X;\theta)
$$

的波动很大，说明样本对参数变化很敏感，同样的样本中携带的关于参数的信息更多。

---

## 5.2 Fisher 信息量的定义

Fisher 信息量定义为：

$$
I(\theta)
=
E\left[
\left\{
\frac{\partial}{\partial\theta}\log f(X;\theta)
\right\}^2
\right]
$$

也就是：

$$
I(\theta)=E[U(\theta)^2]
$$

注意：

> 这里的 $I(\theta)$ 是单个观测 $X$ 中包含的 Fisher 信息量。

如果样本量为 $n$，并且样本独立同分布，则样本总信息量为：

$$
I_n(\theta)=nI(\theta)
$$

这是 HW5 易错点中特别强调的地方。

按照讲义写法：

- 单个总体分布的 Fisher 信息量写作：

$$
I(\theta)
$$

- 样本总信息量可以写作：

$$
nI(\theta)
$$

不要把：

$$
I(\theta)
$$

直接写成：

$$
\frac{n}{\theta^2}
$$

除非你明确写的是：

$$
I_n(\theta)
$$

---

## 5.3 Fisher 信息量的三个等价公式

在一定正则条件下，Fisher 信息量有三个常用计算公式。

---

### 方法一：平方期望公式

$$
I(\theta)
=
E\left[
\left\{
\frac{\partial}{\partial\theta}\log f(X;\theta)
\right\}^2
\right]
$$

这是定义式。

步骤：

1. 写：

$$
\log f(X;\theta)
$$

2. 对 $\theta$ 求导，得到得分函数：

$$
U(\theta)
$$

3. 求：

$$
E[U(\theta)^2]
$$

---

### 方法二：方差公式

在正则条件下：

$$
E[U(\theta)]=0
$$

所以：

$$
I(\theta)=Var[U(\theta)]
$$

也就是：

$$
I(\theta)
=
Var\left[
\frac{\partial}{\partial\theta}\log f(X;\theta)
\right]
$$

这个方法常常比方法一更快，因为常数项不影响方差。

---

### 方法三：二阶导数公式

在正则条件下：

$$
I(\theta)
=
-E\left[
\frac{\partial^2}{\partial\theta^2}
\log f(X;\theta)
\right]
$$

这个方法通常最省事，尤其当二阶导数比较简单时。

---

## 5.4 三个公式为什么相等？

核心原因是正则条件下可以交换积分和求导，并且：

$$
\int f(x;\theta)\,dx=1
$$

对 $\theta$ 求导：

$$
\frac{\partial}{\partial\theta}
\int f(x;\theta)\,dx
=
\frac{\partial}{\partial\theta}1=0
$$

如果可以交换求导与积分：

$$
\int \frac{\partial}{\partial\theta}f(x;\theta)\,dx=0
$$

又因为：

$$
\frac{\partial}{\partial\theta}\log f(x;\theta)
=
\frac{\frac{\partial}{\partial\theta}f(x;\theta)}{f(x;\theta)}
$$

所以：

$$
E[U(\theta)]
=
\int
\frac{\partial}{\partial\theta}\log f(x;\theta)
f(x;\theta)\,dx
$$

$$
=
\int
\frac{\partial f(x;\theta)}{\partial\theta}
\,dx
=
0
$$

因此：

$$
I(\theta)=E[U(\theta)^2]=Var[U(\theta)]
$$

再对：

$$
E[U(\theta)]=0
$$

继续求导，可以得到：

$$
I(\theta)
=
-E[\ell''_1(\theta)]
$$

其中：

$$
\ell_1(\theta)=\log f(X;\theta)
$$

表示单个样本的对数似然。

---

# 6. Fisher 信息量计算例子

---

## 6.1 Bernoulli 分布

设：

$$
X\sim Bernoulli(\theta)
$$

其概率质量函数为：

$$
f(x;\theta)=\theta^x(1-\theta)^{1-x},\qquad x=0,1
$$

对数概率质量函数：

$$
\log f(x;\theta)
=
x\log\theta+(1-x)\log(1-\theta)
$$

得分函数：

$$
U(\theta)
=
\frac{x}{\theta}
-
\frac{1-x}{1-\theta}
$$

化简：

$$
U(\theta)
=
\frac{x-\theta}{\theta(1-\theta)}
$$

因为：

$$
E(X)=\theta
$$

$$
Var(X)=\theta(1-\theta)
$$

所以用方差公式：

$$
I(\theta)
=
Var\left[
\frac{X-\theta}{\theta(1-\theta)}
\right]
$$

$$
=
\frac{1}{\theta^2(1-\theta)^2}Var(X)
$$

$$
=
\frac{1}{\theta^2(1-\theta)^2}\theta(1-\theta)
$$

$$
=
\frac{1}{\theta(1-\theta)}
$$

因此：

$$
I(\theta)=\frac{1}{\theta(1-\theta)}
$$

如果样本量为 $n$，样本总信息量为：

$$
nI(\theta)=\frac{n}{\theta(1-\theta)}
$$

---

## 6.2 Poisson 分布

设：

$$
X\sim Poisson(\theta)
$$

概率质量函数：

$$
f(x;\theta)=\frac{\theta^x e^{-\theta}}{x!}
$$

对数概率质量函数：

$$
\log f(x;\theta)
=
x\log\theta-\theta-\log(x!)
$$

得分函数：

$$
U(\theta)
=
\frac{x}{\theta}-1
=
\frac{x-\theta}{\theta}
$$

用方差公式：

$$
I(\theta)
=
Var\left(\frac{X-\theta}{\theta}\right)
$$

$$
=
\frac{1}{\theta^2}Var(X)
$$

由于：

$$
Var(X)=\theta
$$

所以：

$$
I(\theta)=\frac{1}{\theta}
$$

---

## 6.3 指数分布 $Exp(1/\theta)$

这里一定注意参数化。

若：

$$
X\sim Exp(1/\theta)
$$

则密度为：

$$
f(x;\theta)=\frac1\theta e^{-x/\theta},\qquad x>0
$$

这里 $\theta$ 是尺度参数，也是均值：

$$
E(X)=\theta
$$

$$
Var(X)=\theta^2
$$

对数密度：

$$
\log f(X;\theta)
=
-\log\theta-\frac{X}{\theta}
$$

得分函数：

$$
U(\theta)
=
-\frac1\theta+\frac{X}{\theta^2}
$$

方法一：

$$
I(\theta)
=
E\left[
\left(
-\frac1\theta+\frac{X}{\theta^2}
\right)^2
\right]
$$

展开：

$$
I(\theta)
=
E\left[
\frac1{\theta^2}
-\frac{2X}{\theta^3}
+\frac{X^2}{\theta^4}
\right]
$$

由于：

$$
E(X)=\theta
$$

且：

$$
E(X^2)=Var(X)+[E(X)]^2=\theta^2+\theta^2=2\theta^2
$$

所以：

$$
I(\theta)
=
\frac1{\theta^2}
-\frac{2\theta}{\theta^3}
+\frac{2\theta^2}{\theta^4}
$$

$$
=
\frac1{\theta^2}
$$

方法二：

$$
I(\theta)
=
Var\left(
-\frac1\theta+\frac{X}{\theta^2}
\right)
$$

常数不影响方差：

$$
I(\theta)
=
\frac1{\theta^4}Var(X)
=
\frac1{\theta^4}\theta^2
=
\frac1{\theta^2}
$$

方法三：

二阶导数：

$$
\frac{\partial^2}{\partial\theta^2}\log f(X;\theta)
=
\frac1{\theta^2}
-\frac{2X}{\theta^3}
$$

所以：

$$
I(\theta)
=
-E\left[
\frac1{\theta^2}
-\frac{2X}{\theta^3}
\right]
$$

$$
=
-\frac1{\theta^2}
+
\frac{2E(X)}{\theta^3}
$$

$$
=
-\frac1{\theta^2}
+
\frac{2\theta}{\theta^3}
=
\frac1{\theta^2}
$$

---

## 6.4 双参数指数分布，但 $\mu_0$ 已知

设：

$$
f(x;\theta)=
\begin{cases}
\frac1\theta e^{-(x-\mu_0)/\theta},&x>\mu_0\\
0,&x\le \mu_0
\end{cases}
$$

其中 $\mu_0$ 已知，$\theta>0$ 未知。

令：

$$
Y=X-\mu_0
$$

则：

$$
Y\sim Exp(1/\theta)
$$

所以：

$$
E(Y)=\theta
$$

$$
Var(Y)=\theta^2
$$

密度中关于 $\theta$ 的部分与指数分布 $Exp(1/\theta)$ 完全一样，所以：

$$
I(\theta)=\frac1{\theta^2}
$$

这类题的核心是：

> 如果平移量 $\mu_0$ 已知，令 $Y=X-\mu_0$，问题就变成普通指数分布。

---

## 6.5 Gamma 分布 $\Gamma(\alpha_0,\theta)$，其中 $\alpha_0$ 已知

设：

$$
X\sim \Gamma(\alpha_0,\theta)
$$

密度为：

$$
f(x;\theta)
=
\frac{1}{\Gamma(\alpha_0)\theta^{\alpha_0}}
x^{\alpha_0-1}e^{-x/\theta},
\qquad x>0
$$

其中 $\alpha_0$ 已知，$\theta$ 是尺度参数。

对数密度：

$$
\log f(X;\theta)
=
-\log\Gamma(\alpha_0)
-\alpha_0\log\theta
+(\alpha_0-1)\log X
-\frac{X}{\theta}
$$

得分函数：

$$
U(\theta)
=
-\frac{\alpha_0}{\theta}
+
\frac{X}{\theta^2}
$$

因为：

$$
E(X)=\alpha_0\theta
$$

$$
Var(X)=\alpha_0\theta^2
$$

用方差公式：

$$
I(\theta)
=
Var\left(
-\frac{\alpha_0}{\theta}
+
\frac{X}{\theta^2}
\right)
$$

$$
=
\frac1{\theta^4}Var(X)
$$

$$
=
\frac1{\theta^4}\alpha_0\theta^2
$$

$$
=
\frac{\alpha_0}{\theta^2}
$$

因此：

$$
I(\theta)=\frac{\alpha_0}{\theta^2}
$$

---

## 6.6 正态分布 $N(\mu_0,\theta)$，其中 $\mu_0$ 已知，$\theta$ 是方差

注意这里：

$$
\theta
$$

是方差，不是标准差。

设：

$$
X\sim N(\mu_0,\theta)
$$

密度：

$$
f(x;\theta)
=
\frac1{\sqrt{2\pi\theta}}
\exp\left\{
-\frac{(x-\mu_0)^2}{2\theta}
\right\}
$$

对数密度：

$$
\log f(X;\theta)
=
-\frac12\log(2\pi\theta)
-
\frac{(X-\mu_0)^2}{2\theta}
$$

一阶导数：

$$
\frac{\partial}{\partial\theta}\log f(X;\theta)
=
-\frac1{2\theta}
+
\frac{(X-\mu_0)^2}{2\theta^2}
$$

二阶导数：

$$
\frac{\partial^2}{\partial\theta^2}\log f(X;\theta)
=
\frac1{2\theta^2}
-
\frac{(X-\mu_0)^2}{\theta^3}
$$

使用二阶导公式：

$$
I(\theta)
=
-E\left[
\frac1{2\theta^2}
-
\frac{(X-\mu_0)^2}{\theta^3}
\right]
$$

因为：

$$
E[(X-\mu_0)^2]=\theta
$$

所以：

$$
I(\theta)
=
-\frac1{2\theta^2}
+
\frac{\theta}{\theta^3}
$$

$$
=
-\frac1{2\theta^2}
+
\frac1{\theta^2}
=
\frac1{2\theta^2}
$$

因此：

$$
I(\theta)=\frac1{2\theta^2}
$$

---

# 7. Location family 的 Fisher 信息量

第九讲还讲了 location family。

设：

$$
X_i=\theta+e_i
$$

其中：

$$
e_i
$$

独立同分布，密度为：

$$
f(e)
$$

则 $X$ 的密度为：

$$
f_X(x;\theta)=f(x-\theta)
$$

这种模型称为 location family。

对数密度：

$$
\log f_X(x;\theta)=\log f(x-\theta)
$$

其 Fisher 信息量为：

$$
I(\theta)
=
E\left[
\left\{
\frac{\partial}{\partial\theta}
\log f_X(X;\theta)
\right\}^2
\right]
$$

经过变量替换 $z=x-\theta$ 后可得：

$$
I(\theta)
=
\int_{-\infty}^{\infty}
\left[
\frac{f'(z)}{f(z)}
\right]^2
f(z)\,dz
$$

这个表达式不含 $\theta$。

所以 location family 的 Fisher 信息量通常与位置参数 $\theta$ 无关。

---

## 7.1 Laplace location family 的 Fisher 信息量

Laplace 误差密度为：

$$
f(z)=\frac12 e^{-|z|}
$$

有：

$$
\frac{f'(z)}{f(z)}=-sgn(z)
$$

平方后：

$$
\left[
\frac{f'(z)}{f(z)}
\right]^2=1
$$

所以：

$$
I(\theta)=\int_{-\infty}^{\infty} f(z)\,dz=1
$$

因此 Laplace location family 中：

$$
I(\theta)=1
$$

---

# 8. Rao-Cramer 下界

---

## 8.1 为什么需要 Rao-Cramer 下界？

前面讲有效性时，我们比较两个无偏估计量：

$$
\hat\theta_1,\hat\theta_2
$$

谁的方差更小。

但是会出现一个更本质的问题：

> 无偏估计量的方差有没有理论下限？

Rao-Cramer 下界回答：

> 在正则条件下，任何无偏估计量的方差都不能低于某个下界。

这个下界由 Fisher 信息量决定。

---

## 8.2 Rao-Cramer 下界的一般形式

设：

$$
X_1,\dots,X_n
$$

独立同分布，密度为：

$$
f(x;\theta)
$$

设统计量：

$$
Y=u(X_1,\dots,X_n)
$$

满足：

$$
E(Y)=k(\theta)
$$

则在正则条件下：

$$
Var(Y)
\ge
\frac{[k'(\theta)]^2}{nI(\theta)}
$$

这就是 Rao-Cramer 下界。

如果 $Y$ 是 $k(\theta)$ 的无偏估计量，那么它的方差不能小于：

$$
\frac{[k'(\theta)]^2}{nI(\theta)}
$$

---

## 8.3 特殊情况：估计 $\theta$ 本身

如果：

$$
E(Y)=\theta
$$

则：

$$
k(\theta)=\theta
$$

所以：

$$
k'(\theta)=1
$$

因此 Rao-Cramer 下界变成：

$$
Var(Y)\ge \frac1{nI(\theta)}
$$

这是最常用的形式。

---

## 8.4 特殊情况：估计 $k(\theta)$

如果估计的目标不是 $\theta$，而是：

$$
k(\theta)
$$

则不能直接写：

$$
\frac1{nI(\theta)}
$$

而应该写：

$$
\frac{[k'(\theta)]^2}{nI(\theta)}
$$

这是 HW5 Problem 6 的核心。

例如，如果估计目标是：

$$
k(\theta)=\theta^2
$$

则：

$$
k'(\theta)=2\theta
$$

Rao-Cramer 下界为：

$$
\frac{(2\theta)^2}{nI(\theta)}
$$

不能漏掉 $k'(\theta)$。

---

# 9. 有效估计量与有效性

---

## 9.1 有效估计量

如果 $Y$ 是 $\theta$ 的无偏估计量，并且：

$$
Var(Y)=\frac1{nI(\theta)}
$$

则称 $Y$ 是有效估计量。

也可以说：

> $Y$ 达到了 Rao-Cramer 下界。

简写为：

> 达到 RCB。

如果估计目标是 $k(\theta)$，则达到下界指：

$$
Var(Y)
=
\frac{[k'(\theta)]^2}{nI(\theta)}
$$

---

## 9.2 有效性

若 $Y$ 是 $\theta$ 的无偏估计量，则讲义定义其有效性为：

$$
eff(Y)
=
\frac{1}{nI(\theta)Var(Y)}
$$

也就是：

$$
eff(Y)
=
\frac{RCB}{Var(Y)}
$$

如果估计目标是 $k(\theta)$，则应该写成：

$$
eff(Y)
=
\frac{[k'(\theta)]^2/[nI(\theta)]}{Var(Y)}
$$

性质：

1. 若 $eff(Y)=1$，说明达到 RCB，是有效估计量；
2. 若 $eff(Y)<1$，说明没有达到 RCB；
3. 对无偏估计量来说，方差越接近 RCB，有效性越高。

---

# 10. 判断一个估计量是否达到 RCB 的标准流程

这是 HW5 的核心题型。

---

## 10.1 标准步骤

给定总体分布和估计量 $\hat\theta$，判断是否达到 RCB，一般按以下步骤：

### 第一步：计算 Fisher 信息量

先算单个样本的 Fisher 信息量：

$$
I(\theta)
$$

不要误写成样本总信息量。

常用三种方法：

$$
I(\theta)=E[U(\theta)^2]
$$

$$
I(\theta)=Var[U(\theta)]
$$

$$
I(\theta)=-E[\ell_1''(\theta)]
$$

其中：

$$
U(\theta)=\frac{\partial}{\partial\theta}\log f(X;\theta)
$$

---

### 第二步：写 Rao-Cramer 下界

如果估计目标是 $\theta$：

$$
RCB=\frac1{nI(\theta)}
$$

如果估计目标是 $k(\theta)$：

$$
RCB=\frac{[k'(\theta)]^2}{nI(\theta)}
$$

---

### 第三步：证明估计量无偏

计算：

$$
E(\hat\theta)
$$

若：

$$
E(\hat\theta)=\theta
$$

则无偏。

若估计目标是 $k(\theta)$，则要证明：

$$
E(\hat k)=k(\theta)
$$

---

### 第四步：计算估计量方差

计算：

$$
Var(\hat\theta)
$$

或者：

$$
Var(\hat k)
$$

---

### 第五步：比较方差与 RCB

如果：

$$
Var(\hat\theta)=RCB
$$

则达到 RCB，是有效估计量。

如果：

$$
Var(\hat\theta)>RCB
$$

则没有达到 RCB。

有效性为：

$$
eff=\frac{RCB}{Var(\hat\theta)}
$$

---

# 11. HW5 典型例题讲解

---

## 11.1 Rayleigh 分布的 MLE

设：

$$
f(x;\sigma)=\frac{x}{\sigma^2}e^{-x^2/(2\sigma^2)},\qquad x>0
$$

其中：

$$
\sigma>0
$$

样本为：

$$
x_1,\dots,x_n
$$

似然函数：

$$
L(\sigma)
=
\prod_{i=1}^n
\frac{x_i}{\sigma^2}e^{-x_i^2/(2\sigma^2)}
$$

整理：

$$
L(\sigma)
=
\left(\prod_{i=1}^n x_i\right)
\sigma^{-2n}
\exp\left\{
-\frac1{2\sigma^2}
\sum_{i=1}^n x_i^2
\right\}
$$

对数似然：

$$
\ell(\sigma)
=
\sum_{i=1}^n\log x_i
-
2n\log\sigma
-
\frac1{2\sigma^2}
\sum_{i=1}^n x_i^2
$$

求导：

$$
\ell'(\sigma)
=
-\frac{2n}{\sigma}
+
\frac{1}{\sigma^3}
\sum_{i=1}^n x_i^2
$$

令导数为 0：

$$
-\frac{2n}{\sigma}
+
\frac{1}{\sigma^3}
\sum_{i=1}^n x_i^2=0
$$

两边乘 $\sigma^3$：

$$
-2n\sigma^2+\sum_{i=1}^n x_i^2=0
$$

所以：

$$
\hat\sigma^2
=
\frac1{2n}\sum_{i=1}^n x_i^2
$$

因此：

$$
\hat\sigma
=
\sqrt{
\frac1{2n}\sum_{i=1}^n x_i^2
}
$$

HW5 数据中：

$$
\sum_{i=1}^{10}x_i^2=47.82
$$

所以：

$$
\hat\sigma
=
\sqrt{\frac{47.82}{20}}
=
\sqrt{2.391}
\approx 1.546
$$

易错点：

1. 必须先算样本平方和；
2. 不要直接把样本均值代进去；
3. 最终要求的是 $\sigma$，不是 $\sigma^2$；
4. 不能漏掉开方。

---

## 11.2 指数分布 $Exp(1/\theta)$ 的 Fisher 信息、MLE、无偏性、RCB

设：

$$
X_1,\dots,X_n\sim Exp(1/\theta)
$$

密度为：

$$
f(x;\theta)=\frac1\theta e^{-x/\theta},\qquad x>0
$$

前面已经算出：

$$
I(\theta)=\frac1{\theta^2}
$$

似然函数：

$$
L(\theta)
=
\prod_{i=1}^n
\frac1\theta e^{-X_i/\theta}
$$

$$
=
\theta^{-n}
\exp\left\{
-\frac1\theta\sum_{i=1}^nX_i
\right\}
$$

对数似然：

$$
\ell(\theta)
=
-n\log\theta
-
\frac1\theta\sum_{i=1}^nX_i
$$

求导：

$$
\ell'(\theta)
=
-\frac n\theta
+
\frac1{\theta^2}\sum_{i=1}^nX_i
$$

令导数为 0：

$$
-\frac n\theta
+
\frac1{\theta^2}\sum_{i=1}^nX_i=0
$$

得到：

$$
\hat\theta=\bar X
$$

无偏性：

$$
E(\hat\theta)=E(\bar X)=E(X)=\theta
$$

所以 $\bar X$ 是无偏估计。

Rao-Cramer 下界：

$$
RCB=\frac1{nI(\theta)}
=
\frac1{n\cdot 1/\theta^2}
=
\frac{\theta^2}{n}
$$

估计量方差：

$$
Var(\hat\theta)=Var(\bar X)
=
\frac{Var(X)}{n}
=
\frac{\theta^2}{n}
$$

所以：

$$
Var(\hat\theta)=RCB
$$

因此：

$$
\hat\theta=\bar X
$$

是有效估计量，达到 RCB。

---

## 11.3 平移指数分布：$\mu_0$ 已知

设：

$$
f(x;\theta)=
\begin{cases}
\frac1\theta e^{-(x-\mu_0)/\theta},&x>\mu_0\\
0,&x\le \mu_0
\end{cases}
$$

令：

$$
Y=X-\mu_0
$$

则：

$$
Y\sim Exp(1/\theta)
$$

所以：

$$
I(\theta)=\frac1{\theta^2}
$$

样本似然函数：

$$
L(\theta)
=
\prod_{i=1}^n
\frac1\theta
e^{-(X_i-\mu_0)/\theta}
$$

$$
=
\theta^{-n}
\exp\left\{
-\frac1\theta
\sum_{i=1}^n(X_i-\mu_0)
\right\}
$$

对数似然：

$$
\ell(\theta)
=
-n\log\theta
-
\frac1\theta
\sum_{i=1}^n(X_i-\mu_0)
$$

求导：

$$
\ell'(\theta)
=
-\frac n\theta
+
\frac1{\theta^2}
\sum_{i=1}^n(X_i-\mu_0)
$$

令导数为 0：

$$
\hat\theta
=
\frac1n\sum_{i=1}^n(X_i-\mu_0)
$$

也就是：

$$
\hat\theta=\bar X-\mu_0
$$

无偏性：

$$
E(\hat\theta)
=
E(\bar X-\mu_0)
=
E(X)-\mu_0
$$

由于：

$$
X=\mu_0+Y,\qquad E(Y)=\theta
$$

所以：

$$
E(X)=\mu_0+\theta
$$

因此：

$$
E(\hat\theta)=\theta
$$

方差：

$$
Var(\hat\theta)
=
Var\left(
\frac1n\sum_{i=1}^nY_i
\right)
=
\frac{\theta^2}{n}
$$

RCB：

$$
\frac1{nI(\theta)}=\frac{\theta^2}{n}
$$

所以达到 RCB。

---

## 11.4 Gamma 分布 $\Gamma(\alpha_0,\theta)$ 的有效估计

设：

$$
X_1,\dots,X_n\sim \Gamma(\alpha_0,\theta)
$$

其中 $\alpha_0$ 已知，$\theta$ 未知。

已知：

$$
E(X)=\alpha_0\theta
$$

$$
Var(X)=\alpha_0\theta^2
$$

Fisher 信息量：

$$
I(\theta)=\frac{\alpha_0}{\theta^2}
$$

似然函数推导得到：

$$
\hat\theta
=
\frac1{n\alpha_0}
\sum_{i=1}^nX_i
=
\frac{\bar X}{\alpha_0}
$$

无偏性：

$$
E(\hat\theta)
=
\frac{E(\bar X)}{\alpha_0}
=
\frac{\alpha_0\theta}{\alpha_0}
=
\theta
$$

方差：

$$
Var(\hat\theta)
=
Var\left(\frac{\bar X}{\alpha_0}\right)
=
\frac1{\alpha_0^2}Var(\bar X)
$$

而：

$$
Var(\bar X)=\frac{Var(X)}{n}
=
\frac{\alpha_0\theta^2}{n}
$$

所以：

$$
Var(\hat\theta)
=
\frac1{\alpha_0^2}
\cdot
\frac{\alpha_0\theta^2}{n}
=
\frac{\theta^2}{n\alpha_0}
$$

RCB：

$$
\frac1{nI(\theta)}
=
\frac1{n\cdot \alpha_0/\theta^2}
=
\frac{\theta^2}{n\alpha_0}
$$

因此：

$$
Var(\hat\theta)=RCB
$$

所以 $\hat\theta$ 是有效估计量。

---

## 11.5 正态分布 $N(\mu_0,\theta)$ 中方差参数的有效估计

设：

$$
X_1,\dots,X_n\sim N(\mu_0,\theta)
$$

其中 $\mu_0$ 已知，$\theta$ 是方差。

前面得到：

$$
I(\theta)=\frac1{2\theta^2}
$$

MLE 为：

$$
\hat\theta
=
\frac1n
\sum_{i=1}^n(X_i-\mu_0)^2
$$

无偏性：

因为：

$$
E[(X_i-\mu_0)^2]=\theta
$$

所以：

$$
E(\hat\theta)
=
\frac1n\sum_{i=1}^nE[(X_i-\mu_0)^2]
=
\theta
$$

RCB：

$$
\frac1{nI(\theta)}
=
\frac1{n\cdot 1/(2\theta^2)}
=
\frac{2\theta^2}{n}
$$

计算方差。

由于：

$$
\frac{(X_i-\mu_0)^2}{\theta}\sim \chi^2(1)
$$

所以：

$$
\sum_{i=1}^n\frac{(X_i-\mu_0)^2}{\theta}\sim \chi^2(n)
$$

记：

$$
Q=\sum_{i=1}^n\frac{(X_i-\mu_0)^2}{\theta}
$$

则：

$$
Var(Q)=2n
$$

而：

$$
\hat\theta=\frac{\theta}{n}Q
$$

所以：

$$
Var(\hat\theta)
=
\frac{\theta^2}{n^2}Var(Q)
=
\frac{\theta^2}{n^2}\cdot 2n
=
\frac{2\theta^2}{n}
$$

因此：

$$
Var(\hat\theta)=RCB
$$

所以该 MLE 是无偏且有效的。

---

## 11.6 样本方差 $S^2$ 的有效性

仍设：

$$
X_1,\dots,X_n\sim N(\mu_0,\theta)
$$

其中 $\mu_0$ 已知。

我们知道样本方差：

$$
S^2
=
\frac1{n-1}
\sum_{i=1}^n(X_i-\bar X)^2
$$

也是 $\theta$ 的无偏估计量。

但是它没有用已知的 $\mu_0$，而是用了 $\bar X$，损失了一个自由度。

由学生定理：

$$
\frac{\sum_{i=1}^n(X_i-\bar X)^2}{\theta}
=
\frac{(n-1)S^2}{\theta}
\sim \chi^2(n-1)
$$

所以：

$$
S^2
=
\frac{\theta}{n-1}\chi^2(n-1)
$$

因此：

$$
Var(S^2)
=
\frac{\theta^2}{(n-1)^2}
Var[\chi^2(n-1)]
$$

$$
=
\frac{\theta^2}{(n-1)^2}
\cdot 2(n-1)
$$

$$
=
\frac{2\theta^2}{n-1}
$$

而 RCB 为：

$$
\frac{2\theta^2}{n}
$$

所以有效性为：

$$
eff(S^2)
=
\frac{RCB}{Var(S^2)}
=
\frac{2\theta^2/n}{2\theta^2/(n-1)}
=
\frac{n-1}{n}
$$

因此：

$$
S^2
$$

没有达到 RCB，其有效性为：

$$
\frac{n-1}{n}
$$

HW5 易错点强调：这题不能只写结果，必须写出：

$$
\frac{(n-1)S^2}{\theta}\sim \chi^2(n-1)
$$

并由此推出：

$$
Var(S^2)=\frac{2\theta^2}{n-1}
$$

---

## 11.7 估计 $k(\theta)=\theta^2$：Poisson 例子

设：

$$
X_1,X_2\sim Poisson(\theta)
$$

独立同分布。

估计目标是：

$$
k(\theta)=\theta^2
$$

估计量为：

$$
Y=X_1X_2
$$

---

### 第一步：证明无偏

由于独立：

$$
E(X_1X_2)=E(X_1)E(X_2)
$$

而：

$$
E(X_1)=E(X_2)=\theta
$$

所以：

$$
E(X_1X_2)=\theta^2
$$

因此：

$$
X_1X_2
$$

是 $\theta^2$ 的无偏估计。

---

### 第二步：计算 Fisher 信息量

对 Poisson 分布：

$$
I(\theta)=\frac1\theta
$$

---

### 第三步：计算 RCB

这里估计目标是：

$$
k(\theta)=\theta^2
$$

所以：

$$
k'(\theta)=2\theta
$$

由于样本量：

$$
n=2
$$

所以 Rao-Cramer 下界为：

$$
RCB=
\frac{[k'(\theta)]^2}{nI(\theta)}
=
\frac{(2\theta)^2}{2\cdot 1/\theta}
$$

$$
=
\frac{4\theta^2}{2/\theta}
=
2\theta^3
$$

---

### 第四步：计算估计量方差

$$
Var(X_1X_2)
=
E[(X_1X_2)^2]-[E(X_1X_2)]^2
$$

由于独立：

$$
E[(X_1X_2)^2]=E(X_1^2)E(X_2^2)
$$

Poisson 分布中：

$$
Var(X)=\theta
$$

$$
E(X)=\theta
$$

所以：

$$
E(X^2)=Var(X)+[E(X)]^2=\theta+\theta^2
$$

因此：

$$
E[(X_1X_2)^2]
=
(\theta+\theta^2)^2
$$

又：

$$
[E(X_1X_2)]^2=(\theta^2)^2=\theta^4
$$

所以：

$$
Var(X_1X_2)
=
(\theta+\theta^2)^2-\theta^4
$$

$$
=
\theta^2+2\theta^3+\theta^4-\theta^4
$$

$$
=
\theta^2+2\theta^3
$$

---

### 第五步：计算有效性

$$
eff(X_1X_2)
=
\frac{RCB}{Var(X_1X_2)}
=
\frac{2\theta^3}{2\theta^3+\theta^2}
$$

因此：

$$
X_1X_2
$$

没有达到 RCB，除非在某些极限意义下有效性趋近于 1。

这一题的关键点是：

> 估计目标是 $\theta^2$，所以 RCB 必须用 $[k'(\theta)]^2$，不能直接用 $1/[nI(\theta)]$。

---

# 12. 第九讲重点题型总结

---

## 题型 1：计算 Fisher 信息量

### 题目特征

题目通常说：

> 计算 Fisher 信息量 $I(\theta)$。

有时要求：

> 用三种方法计算。

### 做法

先写：

$$
\log f(X;\theta)
$$

再写得分函数：

$$
U(\theta)=\frac{\partial}{\partial\theta}\log f(X;\theta)
$$

然后选择方法：

方法一：

$$
I(\theta)=E[U(\theta)^2]
$$

方法二：

$$
I(\theta)=Var[U(\theta)]
$$

方法三：

$$
I(\theta)=-E[\ell_1''(\theta)]
$$

其中：

$$
\ell_1(\theta)=\log f(X;\theta)
$$

### 易错点

1. $I(\theta)$ 是单个观测的 Fisher 信息量；
2. 样本总信息量才是 $nI(\theta)$；
3. 如果题目要求三种方法，只写一种会扣过程分；
4. 计算时要看清楚参数化，例如 $Exp(\theta)$ 和 $Exp(1/\theta)$ 不一样；
5. 正态分布里如果 $\theta$ 是方差，不是标准差，公式要重新推。

---

## 题型 2：求 MLE 并证明无偏

### 做法

1. 写似然函数：

$$
L(\theta)=\prod_{i=1}^n f(X_i;\theta)
$$

2. 写对数似然函数：

$$
\ell(\theta)=\log L(\theta)
$$

3. 求导：

$$
\ell'(\theta)=0
$$

4. 解出：

$$
\hat\theta
$$

5. 证明：

$$
E(\hat\theta)=\theta
$$

---

## 题型 3：判断估计量是否达到 RCB

### 做法

1. 算 $I(\theta)$；
2. 写 RCB；
3. 证明无偏；
4. 算估计量方差；
5. 比较方差和 RCB。

若估计目标是 $\theta$：

$$
RCB=\frac1{nI(\theta)}
$$

若估计目标是 $k(\theta)$：

$$
RCB=\frac{[k'(\theta)]^2}{nI(\theta)}
$$

---

## 题型 4：求估计量有效性

若估计目标是 $\theta$：

$$
eff(\hat\theta)
=
\frac{1/[nI(\theta)]}{Var(\hat\theta)}
$$

若估计目标是 $k(\theta)$：

$$
eff(\hat k)
=
\frac{[k'(\theta)]^2/[nI(\theta)]}{Var(\hat k)}
$$

---

# 二、Lecture 10：极大似然检验

---

# 13. 为什么需要极大似然检验？

前面讲假设检验时，很多检验统计量是根据直觉构造的。

例如：

- 检验正态均值时，用 $\bar X$；
- 检验方差时，用 $S^2$；
- 检验两组方差时，用 $S_1^2/S_2^2$。

但是更一般的问题是：

> 能否从似然函数出发，系统地构造检验？

Lecture 10 的回答是：

> 可以。用似然比检验。

核心思想：

如果原假设 $H_0$ 为真，那么在 $\theta=\theta_0$ 处的似然函数值应该接近最大似然函数值。

如果：

$$
L(\theta_0)
$$

远小于：

$$
L(\hat\theta)
$$

说明数据更支持其他参数值，而不是 $\theta_0$，于是拒绝 $H_0$。

---

# 14. 似然比统计量

考虑双边检验：

$$
H_0:\theta=\theta_0
$$

$$
H_1:\theta\ne\theta_0
$$

设：

$$
\hat\theta
$$

是全参数空间中的 MLE。

定义似然比统计量：

$$
\Lambda
=
\frac{L(\theta_0)}{L(\hat\theta)}
$$

因为：

$$
L(\hat\theta)=\max_{\theta\in\Omega}L(\theta)
$$

所以：

$$
0\le \Lambda\le 1
$$

如果 $H_0$ 为真，通常：

$$
L(\theta_0)
$$

会接近：

$$
L(\hat\theta)
$$

所以：

$$
\Lambda\approx 1
$$

如果 $H_0$ 不真，$\theta_0$ 处的似然值会明显小于最大似然值，因此：

$$
\Lambda
$$

会变小。

因此似然比检验的拒绝域形式是：

$$
\{\Lambda\le c\}
$$

其中 $c$ 由显著性水平 $\alpha$ 决定。

---

# 15. LRT 的一般步骤

---

## 15.1 标准步骤

### 第一步：写似然函数

$$
L(\theta)=\prod_{i=1}^n f(X_i;\theta)
$$

---

### 第二步：求全空间 MLE

求：

$$
\hat\theta=\arg\max_{\theta\in\Omega}L(\theta)
$$

---

### 第三步：计算似然比

$$
\Lambda=\frac{L(\theta_0)}{L(\hat\theta)}
$$

或者用对数形式：

$$
-2\log\Lambda
=
2[\ell(\hat\theta)-\ell(\theta_0)]
$$

---

### 第四步：把拒绝域化简成常见统计量

一般要把：

$$
\{\Lambda\le c\}
$$

转化为：

- $\bar X$ 的两侧；
- 某个标准正态统计量的两侧；
- 某个卡方统计量的两侧；
- 或者某个渐近卡方统计量的右尾。

---

### 第五步：确定临界值

如果有精确分布，使用精确分布。

如果没有精确分布，使用渐近分布：

$$
-2\log\Lambda\approx \chi^2(1)
$$

---

# 16. LRT 例子一：指数分布 $Exp(1/\theta)$

设：

$$
X_1,\dots,X_n\sim Exp(1/\theta)
$$

密度为：

$$
f(x;\theta)=\frac1\theta e^{-x/\theta},\qquad x>0
$$

检验：

$$
H_0:\theta=\theta_0
$$

$$
H_1:\theta\ne\theta_0
$$

---

## 16.1 写似然函数

$$
L(\theta)
=
\prod_{i=1}^n
\frac1\theta e^{-X_i/\theta}
$$

$$
=
\theta^{-n}
\exp\left\{
-\frac1\theta\sum_{i=1}^nX_i
\right\}
$$

也可以写成：

$$
L(\theta)
=
\theta^{-n}
e^{-n\bar X/\theta}
$$

MLE 为：

$$
\hat\theta=\bar X
$$

---

## 16.2 写似然比

$$
\Lambda
=
\frac{L(\theta_0)}{L(\hat\theta)}
$$

$$
=
\frac{
\theta_0^{-n}e^{-n\bar X/\theta_0}
}{
\bar X^{-n}e^{-n\bar X/\bar X}
}
$$

因为：

$$
e^{-n\bar X/\bar X}=e^{-n}
$$

所以：

$$
\Lambda
=
e^n
\left(\frac{\bar X}{\theta_0}\right)^n
e^{-n\bar X/\theta_0}
$$

令：

$$
t=\frac{\bar X}{\theta_0}
$$

则：

$$
\Lambda=e^n t^n e^{-nt}
$$

记：

$$
g(t)=t^n e^{-nt}
$$

则：

$$
\Lambda=e^n g(t)
$$

---

## 16.3 为什么拒绝域是两侧？

求导：

$$
g'(t)=ne^{-nt}t^{n-1}(1-t)
$$

所以：

- 当 $0<t<1$ 时，$g'(t)>0$，$g(t)$ 递增；
- 当 $t>1$ 时，$g'(t)<0$，$g(t)$ 递减。

因此 $g(t)$ 在 $t=1$ 处最大。

也就是说：

$$
\Lambda
$$

在：

$$
\bar X=\theta_0
$$

附近最大。

如果：

$$
\bar X
$$

比 $\theta_0$ 小很多，或者大很多，$\Lambda$ 都会变小。

所以拒绝域：

$$
\{\Lambda\le c\}
$$

等价于两侧拒绝域：

$$
\left\{
\frac{\bar X}{\theta_0}\le c_1
\right\}
\cup
\left\{
\frac{\bar X}{\theta_0}\ge c_2
\right\}
$$

这就是双边检验。

---

## 16.4 用卡方分布确定拒绝域

在 $H_0$ 下：

$$
X_i\sim Exp(1/\theta_0)
$$

所以：

$$
\sum_{i=1}^n X_i\sim \Gamma(n,\theta_0)
$$

于是：

$$
\frac{2}{\theta_0}\sum_{i=1}^nX_i
\sim \Gamma(n,2)
=
\chi^2(2n)
$$

因此显著性水平为 $\alpha$ 的双边拒绝域可取：

$$
\left\{
\frac{2}{\theta_0}\sum_{i=1}^nX_i
\le
\chi^2_{1-\alpha/2}(2n)
\right\}
$$

或者：

$$
\left\{
\frac{2}{\theta_0}\sum_{i=1}^nX_i
\ge
\chi^2_{\alpha/2}(2n)
\right\}
$$

合并写作：

$$
\left\{
\frac{2}{\theta_0}\sum_{i=1}^nX_i
\le
\chi^2_{1-\alpha/2}(2n)
\right\}
\cup
\left\{
\frac{2}{\theta_0}\sum_{i=1}^nX_i
\ge
\chi^2_{\alpha/2}(2n)
\right\}
$$

这里仍然采用上分位数记号：

$$
P(\chi^2(k)>\chi^2_\alpha(k))=\alpha
$$

所以左尾临界值对应：

$$
\chi^2_{1-\alpha/2}(k)
$$

右尾临界值对应：

$$
\chi^2_{\alpha/2}(k)
$$

---

# 17. LRT 例子二：正态分布，方差已知

设：

$$
X_1,\dots,X_n\sim N(\theta,\sigma_0^2)
$$

其中：

$$
\sigma_0
$$

已知。

检验：

$$
H_0:\theta=\theta_0
$$

$$
H_1:\theta\ne\theta_0
$$

---

## 17.1 MLE

由于正态均值的 MLE 是样本均值，所以：

$$
\hat\theta=\bar X
$$

---

## 17.2 似然函数

$$
L(\theta)
=
\prod_{i=1}^n
\frac1{\sigma_0\sqrt{2\pi}}
\exp\left\{
-\frac{(X_i-\theta)^2}{2\sigma_0^2}
\right\}
$$

---

## 17.3 似然比

$$
\Lambda
=
\frac{L(\theta_0)}{L(\hat\theta)}
$$

由于：

$$
\sum_{i=1}^n(X_i-\theta_0)^2
=
\sum_{i=1}^n(X_i-\bar X)^2
+
n(\bar X-\theta_0)^2
$$

所以似然比化简为：

$$
\Lambda
=
\exp\left\{
-\frac{n}{2\sigma_0^2}
(\bar X-\theta_0)^2
\right\}
$$

---

## 17.4 拒绝域

因为指数函数单调递增，而前面有负号：

$$
\Lambda\le c
$$

等价于：

$$
(\bar X-\theta_0)^2\ge c_1
$$

也就是：

$$
|\bar X-\theta_0|\ge c_2
$$

在显著性水平 $\alpha$ 下，取：

$$
c_2=
\frac{\sigma_0}{\sqrt n}z_{\alpha/2}
$$

所以拒绝域为：

$$
\left\{
|\bar X-\theta_0|
\ge
\frac{\sigma_0}{\sqrt n}z_{\alpha/2}
\right\}
$$

等价于：

$$
\left\{
\left|
\frac{\bar X-\theta_0}{\sigma_0/\sqrt n}
\right|
\ge z_{\alpha/2}
\right\}
$$

这正是普通的双边 z 检验。

---

## 17.5 HW5 易错提醒

HW5 中类似题要求说明：

1. 为什么拒绝域与 $|W|$ 有关；
2. 为什么 $W$ 在 $H_0$ 下服从标准正态分布。

设：

$$
W=
\frac{\bar X-\mu_0}{\sigma_0/\sqrt n}
$$

在 $H_0$ 下：

$$
W\sim N(0,1)
$$

由于：

$$
\Lambda
=
\exp\left\{
-\frac12 W^2
\right\}
$$

所以：

$$
\Lambda\le c
$$

等价于：

$$
W^2\ge c'
$$

也就是：

$$
|W|\ge c''
$$

因此显著性水平为 $\alpha$ 的拒绝域为：

$$
\{W\le -z_{\alpha/2}\}\cup\{W\ge z_{\alpha/2}\}
$$

如果不说明这些步骤，容易丢过程分。

---

# 18. $-2\log\Lambda$ 的渐近分布

---

## 18.1 为什么要研究 $-2\log\Lambda$？

很多情况下，LRT 的精确分布不好求。

这时可以使用大样本近似。

Lecture 10 给出重要结论：

在正则条件下，如果：

$$
H_0:\theta=\theta_0
$$

成立，则：

$$
-2\log\Lambda
\overset{D}{\longrightarrow}
\chi^2(1)
$$

即：

$$
-2\log\Lambda
$$

渐近服从自由度为 1 的卡方分布。

---

## 18.2 似然比卡方统计量

定义：

$$
\chi_L^2
=
-2\log\Lambda
$$

由于：

$$
\Lambda=
\frac{L(\theta_0)}{L(\hat\theta)}
$$

所以：

$$
-2\log\Lambda
=
2[\ell(\hat\theta)-\ell(\theta_0)]
$$

因此：

$$
\chi_L^2
=
2[\ell(\hat\theta)-\ell(\theta_0)]
$$

在 $H_0$ 成立时，大样本下：

$$
\chi_L^2
\approx
\chi^2(1)
$$

---

## 18.3 LRT 的渐近拒绝域

显著性水平为 $\alpha$ 时：

$$
\left\{
\chi_L^2
\ge
\chi^2_\alpha(1)
\right\}
$$

也就是：

$$
\left\{
-2\log\Lambda
\ge
\chi^2_\alpha(1)
\right\}
$$

注意：

> 这里是右尾拒绝，因为 $\chi_L^2$ 越大，表示 $L(\hat\theta)$ 相比 $L(\theta_0)$ 优势越明显，越不支持原假设。

---

# 19. Wald 型检验

---

## 19.1 Wald 检验的思想

Wald 检验直接比较：

$$
\hat\theta
$$

和：

$$
\theta_0
$$

的距离。

如果：

$$
\hat\theta
$$

离：

$$
\theta_0
$$

太远，就拒绝：

$$
H_0:\theta=\theta_0
$$

---

## 19.2 Wald 统计量

大样本理论给出：

$$
\sqrt{nI(\theta_0)}(\hat\theta-\theta_0)
\overset{D}{\longrightarrow}
N(0,1)
$$

Wald 型检验通常使用：

$$
\chi_W^2
=
nI(\hat\theta)(\hat\theta-\theta_0)^2
$$

在 $H_0$ 成立时：

$$
\chi_W^2
\approx
\chi^2(1)
$$

拒绝域为：

$$
\left\{
\chi_W^2
\ge
\chi^2_\alpha(1)
\right\}
$$

注意：

> Wald 型统计量最终是平方形式，服从自由度 1 的卡方近似分布。

HW5 易错点特别强调：Wald 统计量不能漏平方；如果只写成标准正态型但拒绝域没有正确转换，会扣分。

---

## 19.3 Wald 检验的做题步骤

1. 求全空间 MLE：

$$
\hat\theta
$$

2. 计算 Fisher 信息量：

$$
I(\theta)
$$

3. 代入：

$$
I(\hat\theta)
$$

4. 构造：

$$
\chi_W^2
=
nI(\hat\theta)(\hat\theta-\theta_0)^2
$$

5. 写拒绝域：

$$
\chi_W^2\ge \chi^2_\alpha(1)
$$

---

# 20. Rao 得分型检验 / Score test

---

## 20.1 得分检验的思想

Score test 不直接看：

$$
\hat\theta-\theta_0
$$

而是看在原假设点：

$$
\theta_0
$$

处对数似然函数的斜率。

如果：

$$
\ell'(\theta_0)
$$

很大，说明在 $\theta_0$ 处似然函数还明显有上升方向，因此 $\theta_0$ 不太可能是真实参数。

所以拒绝原假设。

---

## 20.2 Score 统计量

在 $H_0$ 下：

$$
\ell'(\theta_0)
$$

近似服从均值 0、方差 $nI(\theta_0)$ 的正态分布。

所以标准化：

$$
\frac{\ell'(\theta_0)}{\sqrt{nI(\theta_0)}}
\approx N(0,1)
$$

平方后：

$$
\chi_R^2
=
\left[
\frac{\ell'(\theta_0)}{\sqrt{nI(\theta_0)}}
\right]^2
\approx \chi^2(1)
$$

拒绝域：

$$
\left\{
\chi_R^2
\ge
\chi^2_\alpha(1)
\right\}
$$

---

## 20.3 Score 检验的做题步骤

1. 写对数似然函数：

$$
\ell(\theta)
$$

2. 求得分函数总和：

$$
\ell'(\theta)
$$

3. 代入原假设参数：

$$
\ell'(\theta_0)
$$

4. 计算 Fisher 信息量：

$$
I(\theta_0)
$$

5. 构造：

$$
\chi_R^2
=
\left[
\frac{\ell'(\theta_0)}{\sqrt{nI(\theta_0)}}
\right]^2
$$

6. 写拒绝域：

$$
\chi_R^2\ge \chi^2_\alpha(1)
$$

易错点：

> Score 统计量最终也要平方，不能只写标准化得分。

---

# 21. LRT、Wald、Score 三种检验的区别

这三种检验都基于似然函数，但看似然函数的角度不同。

---

## 21.1 LRT 看“高度差”

LRT 比较：

$$
\ell(\hat\theta)
$$

和：

$$
\ell(\theta_0)
$$

即：

$$
\chi_L^2=2[\ell(\hat\theta)-\ell(\theta_0)]
$$

它看的是：

> 原假设点的似然高度和最大似然高度之间差多少。

---

## 21.2 Wald 看“横向距离”

Wald 检验看：

$$
\hat\theta-\theta_0
$$

即估计值离原假设值有多远。

统计量：

$$
\chi_W^2
=
nI(\hat\theta)(\hat\theta-\theta_0)^2
$$

---

## 21.3 Score 看“原假设点斜率”

Score 检验看：

$$
\ell'(\theta_0)
$$

即在原假设点处似然函数的斜率。

统计量：

$$
\chi_R^2
=
\left[
\frac{\ell'(\theta_0)}{\sqrt{nI(\theta_0)}}
\right]^2
$$

---

## 21.4 三者关系

在大样本下，三者通常渐近等价：

$$
\chi_L^2,\quad \chi_W^2,\quad \chi_R^2
\overset{approx}{\sim}
\chi^2(1)
$$

但在小样本中三者可能不同。

直观比较：

| 检验 | 用到的信息 | 统计量核心 |
|---|---|---|
| LRT | $\ell(\hat\theta)$ 和 $\ell(\theta_0)$ | 似然高度差 |
| Wald | $\hat\theta-\theta_0$ | 参数估计距离 |
| Score | $\ell'(\theta_0)$ | 原假设点斜率 |

---

# 22. Lecture 10 例题：Beta 分布 $\beta(\theta,1)$

设：

$$
X_1,\dots,X_n\sim beta(\theta,1)
$$

密度：

$$
f(x;\theta)=\theta x^{\theta-1},\qquad 0<x<1
$$

检验：

$$
H_0:\theta=1
$$

$$
H_1:\theta\ne 1
$$

当：

$$
\theta=1
$$

时，分布就是：

$$
U(0,1)
$$

---

## 22.1 对数似然函数

似然函数：

$$
L(\theta)
=
\prod_{i=1}^n
\theta X_i^{\theta-1}
$$

对数似然：

$$
\ell(\theta)
=
n\log\theta
+
(\theta-1)\sum_{i=1}^n\log X_i
$$

也可以写为：

$$
\ell(\theta)
=
\theta\sum_{i=1}^n\log X_i
-
\sum_{i=1}^n\log X_i
+
n\log\theta
$$

---

## 22.2 MLE

求导：

$$
\ell'(\theta)
=
\sum_{i=1}^n\log X_i+\frac n\theta
$$

令导数为 0：

$$
\sum_{i=1}^n\log X_i+\frac n\theta=0
$$

所以：

$$
\hat\theta
=
-\frac{n}{\sum_{i=1}^n\log X_i}
$$

---

## 22.3 LRT 统计量

因为原假设下：

$$
\theta_0=1
$$

此时：

$$
\ell(1)=0
$$

所以：

$$
\chi_L^2
=
2[\ell(\hat\theta)-\ell(1)]
=
2\ell(\hat\theta)
$$

代入：

$$
\hat\theta=-\frac{n}{\sum_{i=1}^n\log X_i}
$$

可得：

$$
\chi_L^2
=
2\left[
-n-\sum_{i=1}^n\log X_i
+
n\log\left(
-\frac{n}{\sum_{i=1}^n\log X_i}
\right)
\right]
$$

拒绝域：

$$
\chi_L^2\ge \chi^2_\alpha(1)
$$

---

## 22.4 Wald 统计量

对该分布：

$$
I(\theta)=\frac1{\theta^2}
$$

Wald 统计量：

$$
\chi_W^2
=
nI(\hat\theta)(\hat\theta-1)^2
$$

因为：

$$
I(\hat\theta)=\frac1{\hat\theta^2}
$$

所以：

$$
\chi_W^2
=
n\frac{(\hat\theta-1)^2}{\hat\theta^2}
$$

也可以写为：

$$
\chi_W^2
=
n\left(1-\frac1{\hat\theta}\right)^2
$$

拒绝域：

$$
\chi_W^2\ge \chi^2_\alpha(1)
$$

---

## 22.5 Score 统计量

Score 统计量为：

$$
\chi_R^2
=
\left[
\frac{\ell'(\theta_0)}{\sqrt{nI(\theta_0)}}
\right]^2
$$

这里：

$$
\theta_0=1
$$

$$
I(1)=1
$$

又：

$$
\ell'(1)=\sum_{i=1}^n\log X_i+n
$$

所以：

$$
\chi_R^2
=
\left[
\frac{\sum_{i=1}^n\log X_i+n}{\sqrt n}
\right]^2
$$

也可以用：

$$
\hat\theta=-\frac n{\sum_{i=1}^n\log X_i}
$$

改写为：

$$
\chi_R^2
=
n\left(1-\frac1{\hat\theta}\right)^2
$$

拒绝域：

$$
\chi_R^2\ge \chi^2_\alpha(1)
$$

---

# 23. Lecture 10 例题：Laplace location family

设：

$$
X_i=\theta+e_i
$$

其中 $e_i$ 独立同分布于 Laplace 分布：

$$
f(e)=\frac12e^{-|e|}
$$

则：

$$
X_i
$$

的密度为：

$$
f(x;\theta)=\frac12e^{-|x-\theta|}
$$

检验：

$$
H_0:\theta=\theta_0
$$

$$
H_1:\theta\ne\theta_0
$$

---

## 23.1 MLE

对数似然函数：

$$
\ell(\theta)
=
-\sum_{i=1}^n|X_i-\theta|-n\log 2
$$

最大化 $\ell(\theta)$ 等价于最小化：

$$
\sum_{i=1}^n|X_i-\theta|
$$

所以 MLE 是样本中位数：

$$
\hat\theta=Q_2
$$

---

## 23.2 LRT 统计量

$$
\chi_L^2
=
2[\ell(Q_2)-\ell(\theta_0)]
$$

代入：

$$
\ell(Q_2)
=
-\sum_{i=1}^n|X_i-Q_2|-n\log 2
$$

$$
\ell(\theta_0)
=
-\sum_{i=1}^n|X_i-\theta_0|-n\log 2
$$

所以：

$$
\chi_L^2
=
2\left[
\sum_{i=1}^n|X_i-\theta_0|
-
\sum_{i=1}^n|X_i-Q_2|
\right]
$$

拒绝域：

$$
\chi_L^2\ge \chi^2_\alpha(1)
$$

---

## 23.3 Wald 统计量

前面得到 Laplace location family：

$$
I(\theta)=1
$$

所以：

$$
\chi_W^2
=
nI(Q_2)(Q_2-\theta_0)^2
=
n(Q_2-\theta_0)^2
$$

拒绝域：

$$
\chi_W^2\ge \chi^2_\alpha(1)
$$

---

## 23.4 Score 统计量

对数似然导数为：

$$
\ell'(\theta)
=
\sum_{i=1}^n sgn(X_i-\theta)
$$

或者根据符号约定可能写作差一个负号。由于最后要平方，符号不影响最终统计量。

在：

$$
\theta=\theta_0
$$

处：

$$
\ell'(\theta_0)
=
\sum_{i=1}^n sgn(X_i-\theta_0)
$$

而：

$$
I(\theta_0)=1
$$

所以：

$$
\chi_R^2
=
\left[
\frac{\ell'(\theta_0)}{\sqrt n}
\right]^2
=
\frac1n
\left[
\sum_{i=1}^n sgn(X_i-\theta_0)
\right]^2
$$

拒绝域：

$$
\chi_R^2\ge \chi^2_\alpha(1)
$$

---

# 24. HW5 典型例题：Bernoulli 分布检验 $\theta=1/3$

设：

$$
X_1,\dots,X_n\sim Bernoulli(\theta)
$$

概率质量函数：

$$
p(x;\theta)=\theta^x(1-\theta)^{1-x},\qquad x=0,1
$$

检验：

$$
H_0:\theta=\frac13
$$

$$
H_1:\theta\ne \frac13
$$

---

## 24.1 MLE

似然函数：

$$
L(\theta)
=
\prod_{i=1}^n
\theta^{X_i}(1-\theta)^{1-X_i}
$$

$$
=
\theta^{\sum X_i}
(1-\theta)^{n-\sum X_i}
$$

令：

$$
\bar X=\frac1n\sum_{i=1}^nX_i
$$

无约束 MLE：

$$
\hat\theta=\bar X
$$

---

## 24.2 似然比统计量

$$
\Lambda
=
\frac{L(1/3)}{L(\hat\theta)}
$$

原假设下：

$$
L(1/3)
=
(1/3)^{n\bar X}
(2/3)^{n(1-\bar X)}
$$

全空间 MLE 下：

$$
L(\hat\theta)
=
\bar X^{n\bar X}
(1-\bar X)^{n(1-\bar X)}
$$

所以：

$$
\Lambda
=
\frac{
(1/3)^{n\bar X}
(2/3)^{n(1-\bar X)}
}{
\bar X^{n\bar X}
(1-\bar X)^{n(1-\bar X)}
}
$$

---

## 24.3 $-2\log\Lambda$

$$
-2\log\Lambda
=
2[\ell(\hat\theta)-\ell(1/3)]
$$

化简为：

$$
-2\log\Lambda
=
2n\left[
\bar X\log(3\bar X)
+
(1-\bar X)
\log\left(
\frac32(1-\bar X)
\right)
\right]
$$

似然比检验的渐近拒绝域：

$$
-2\log\Lambda\ge \chi^2_\alpha(1)
$$

---

## 24.4 Wald 型检验

Bernoulli 分布的 Fisher 信息量为：

$$
I(\theta)=\frac1{\theta(1-\theta)}
$$

Wald 统计量：

$$
\chi_W^2
=
nI(\hat\theta)(\hat\theta-\theta_0)^2
$$

这里：

$$
\theta_0=\frac13
$$

$$
\hat\theta=\bar X
$$

所以：

$$
\chi_W^2
=
n\frac{(\bar X-1/3)^2}{\bar X(1-\bar X)}
$$

拒绝域：

$$
\chi_W^2\ge \chi^2_\alpha(1)
$$

---

## 24.5 Score 统计量

对数似然函数：

$$
\ell(\theta)
=
\sum_{i=1}^nX_i\log\theta
+
\left(n-\sum_{i=1}^nX_i\right)\log(1-\theta)
$$

得分函数：

$$
\ell'(\theta)
=
\frac{\sum X_i}{\theta}
-
\frac{n-\sum X_i}{1-\theta}
$$

在：

$$
\theta_0=\frac13
$$

处：

$$
\ell'(1/3)
=
3\sum X_i
-
\frac32
\left(n-\sum X_i\right)
$$

令：

$$
\sum X_i=n\bar X
$$

则：

$$
\ell'(1/3)
=
3n\bar X
-
\frac32n(1-\bar X)
$$

$$
=
\frac32n(3\bar X-1)
$$

Fisher 信息量：

$$
I(1/3)
=
\frac1{(1/3)(2/3)}
=
\frac92
$$

所以：

$$
nI(1/3)=\frac92 n
$$

Score 统计量：

$$
\chi_R^2
=
\left[
\frac{\ell'(1/3)}{\sqrt{nI(1/3)}}
\right]^2
$$

$$
=
\frac{
\left[
\frac32n(3\bar X-1)
\right]^2
}{
\frac92 n
}
$$

$$
=
\frac n2(3\bar X-1)^2
$$

也可以写成：

$$
\chi_R^2
=
\frac{9n}{2}
\left(\bar X-\frac13\right)^2
$$

拒绝域：

$$
\chi_R^2\ge \chi^2_\alpha(1)
$$

---

# 25. 第十讲重点题型总结

---

## 题型 1：构造似然比检验 LRT

### 做法

1. 写似然函数：

$$
L(\theta)
$$

2. 求无约束 MLE：

$$
\hat\theta
$$

3. 写：

$$
\Lambda=\frac{L(\theta_0)}{L(\hat\theta)}
$$

4. 化简：

$$
-2\log\Lambda=2[\ell(\hat\theta)-\ell(\theta_0)]
$$

5. 若能求精确分布，就用精确分布；
6. 若不能求精确分布，大样本下用：

$$
-2\log\Lambda\approx \chi^2(1)
$$

7. 写拒绝域：

$$
-2\log\Lambda\ge \chi^2_\alpha(1)
$$

---

## 题型 2：由 $\Lambda$ 推拒绝域

### 做法

如果：

$$
\Lambda
$$

可以写成某个统计量 $T$ 的函数：

$$
\Lambda=h(T)
$$

就需要分析 $h(T)$ 的单调性。

常见情况：

1. $h(T)$ 单调递减，则 $\Lambda\le c$ 等价于 $T\ge c'$；
2. $h(T)$ 先增后减，则 $\Lambda\le c$ 对应两侧拒绝域；
3. $h(T)=e^{-T^2/2}$，则 $\Lambda\le c$ 等价于 $|T|\ge c'$。

HW5 易错点强调：

> 求拒绝域时如果需要用函数单调性，就必须求导或说明单调趋势。

---

## 题型 3：Wald 型检验

### 做法

1. 求 MLE：

$$
\hat\theta
$$

2. 算 Fisher 信息量：

$$
I(\theta)
$$

3. 构造：

$$
\chi_W^2=nI(\hat\theta)(\hat\theta-\theta_0)^2
$$

4. 写拒绝域：

$$
\chi_W^2\ge\chi^2_\alpha(1)
$$

### 易错点

统计量要平方，且必须写拒绝域。

---

## 题型 4：Score 型检验

### 做法

1. 写对数似然函数：

$$
\ell(\theta)
$$

2. 求得分函数：

$$
\ell'(\theta)
$$

3. 代入：

$$
\theta_0
$$

4. 计算：

$$
I(\theta_0)
$$

5. 构造：

$$
\chi_R^2
=
\left[
\frac{\ell'(\theta_0)}{\sqrt{nI(\theta_0)}}
\right]^2
$$

6. 写拒绝域：

$$
\chi_R^2\ge\chi^2_\alpha(1)
$$

### 易错点

Score 统计量也要平方。

---

# 三、两章综合题型与解题模板

---

# 26. 综合题型 A：Fisher 信息量 + MLE + RCB

这是 HW5 前半部分最核心题型。

---

## 26.1 题目特征

题目通常给一个分布：

$$
f(x;\theta)
$$

要求：

1. 计算 Fisher 信息量；
2. 找 MLE；
3. 证明无偏；
4. 判断是否达到 RCB。

---

## 26.2 标准解题模板

### 第一步：写单个样本的对数密度

$$
\ell_1(\theta)=\log f(X;\theta)
$$

### 第二步：计算 Fisher 信息量

任选或按题目要求使用三种方法：

$$
I(\theta)=E[\ell_1'(\theta)^2]
$$

$$
I(\theta)=Var[\ell_1'(\theta)]
$$

$$
I(\theta)=-E[\ell_1''(\theta)]
$$

### 第三步：写样本似然函数

$$
L(\theta)=\prod_{i=1}^n f(X_i;\theta)
$$

### 第四步：写样本对数似然

$$
\ell(\theta)=\sum_{i=1}^n \log f(X_i;\theta)
$$

### 第五步：求导求 MLE

$$
\ell'(\theta)=0
$$

解出：

$$
\hat\theta
$$

### 第六步：证明无偏性

算：

$$
E(\hat\theta)
$$

### 第七步：写 RCB

如果估计 $\theta$：

$$
RCB=\frac1{nI(\theta)}
$$

如果估计 $k(\theta)$：

$$
RCB=\frac{[k'(\theta)]^2}{nI(\theta)}
$$

### 第八步：计算方差并比较

如果：

$$
Var(\hat\theta)=RCB
$$

则达到 RCB。

否则有效性为：

$$
eff=\frac{RCB}{Var(\hat\theta)}
$$

---

# 27. 综合题型 B：求某估计量的有效性

---

## 27.1 题目特征

题目给一个无偏估计量：

$$
Y
$$

要求求有效性。

---

## 27.2 做法

1. 明确估计目标是 $\theta$ 还是 $k(\theta)$；
2. 计算 Fisher 信息量 $I(\theta)$；
3. 写 RCB；
4. 计算 $Var(Y)$；
5. 写：

$$
eff(Y)=\frac{RCB}{Var(Y)}
$$

---

# 28. 综合题型 C：似然比检验

---

## 28.1 题目特征

题目说：

> 用极大似然检验；
> 求似然比统计量；
> 求 $\Lambda$；
> 求 $-2\log\Lambda$；
> 求拒绝域。

---

## 28.2 做法

1. 写 $L(\theta)$；
2. 求 $\hat\theta$；
3. 写：

$$
\Lambda=\frac{L(\theta_0)}{L(\hat\theta)}
$$

4. 化简；
5. 若需要，设中间变量 $W$ 或 $T$；
6. 判断 $\Lambda$ 关于该变量的单调性；
7. 得到拒绝域；
8. 说明在 $H_0$ 下统计量的分布。

---

# 29. 综合题型 D：Wald 型检验与 Score 型检验

---

## 29.1 Wald 型检验模板

$$
\chi_W^2=nI(\hat\theta)(\hat\theta-\theta_0)^2
$$

拒绝域：

$$
\chi_W^2\ge\chi^2_\alpha(1)
$$

---

## 29.2 Score 型检验模板

$$
\chi_R^2=
\left[
\frac{\ell'(\theta_0)}{\sqrt{nI(\theta_0)}}
\right]^2
$$

拒绝域：

$$
\chi_R^2\ge\chi^2_\alpha(1)
$$

---

## 29.3 两者最容易混淆的地方

| 检验 | 用哪个点的信息量 | 是否需要 MLE |
|---|---|---|
| Wald | $I(\hat\theta)$ | 需要 |
| Score | $I(\theta_0)$ | 不一定需要 |
| LRT | $\ell(\hat\theta)-\ell(\theta_0)$ | 需要 |

---

# 四、HW5 易错点总整理

---

# 30. Fisher 信息量相关易错点

1. Fisher 信息量 $I(\theta)$ 按讲义是单个总体分布携带的信息，不是样本总信息量。
2. 样本总信息量才是：

$$
nI(\theta)
$$

3. 如果直接把：

$$
I(\theta)
$$

写成：

$$
\frac{n}{\theta^2}
$$

通常会被扣分。

4. 如果写：

$$
I_n(\theta)=\frac{n}{\theta^2}
$$

则表示样本总信息量，形式上可以理解，但考试中最好严格区分。

5. 如果题目要求三种方法计算 Fisher 信息量，只写一种会扣过程分。

---

# 31. RCB 相关易错点

1. 估计目标是 $\theta$ 时：

$$
RCB=\frac1{nI(\theta)}
$$

2. 估计目标是 $k(\theta)$ 时：

$$
RCB=\frac{[k'(\theta)]^2}{nI(\theta)}
$$

3. 不要看到 Rao-Cramer 下界就机械写：

$$
\frac1{nI(\theta)}
$$

4. 判断是否达到 RCB，必须先证明估计量无偏。

---

# 32. 方差计算易错点

1. 求样本方差 $S^2$ 的有效性时，必须写：

$$
\frac{(n-1)S^2}{\theta}\sim\chi^2(n-1)
$$

2. 然后推出：

$$
Var(S^2)=\frac{2\theta^2}{n-1}
$$

3. 不能只写最终结果，否则过程分会丢。

---

# 33. LRT 拒绝域易错点

1. 求拒绝域时，不能只写：

$$
\Lambda\le c
$$

还要把它转化成可操作的统计量形式。

2. 如果需要判断某个函数先增后减，必须求导或说明理由。

3. 正态例子中，要说明为什么拒绝域与 $|W|$ 有关。

4. 还要说明：

$$
W\sim N(0,1)
$$

是在 $H_0$ 下成立的。

---

# 34. Wald 和 Score 检验易错点

1. Wald 型统计量最终应服从自由度为 1 的卡方分布，所以必须平方：

$$
\chi_W^2=nI(\hat\theta)(\hat\theta-\theta_0)^2
$$

2. Score 型统计量也必须平方：

$$
\chi_R^2=
\left[
\frac{\ell'(\theta_0)}{\sqrt{nI(\theta_0)}}
\right]^2
$$

3. 写出统计量后，还要写拒绝域：

$$
\chi^2\ge\chi^2_\alpha(1)
$$

4. 不能只写统计量不写决策规则。

---

# 35. 过程分易错点

HW5 易错点最后特别强调：

> 能写过程就写过程，即使最终答案错了，如果过程正确也有分；不写过程，即使答案对了也会扣过程分。

所以考试或作业中至少要写：

1. 似然函数；
2. 对数似然函数；
3. 求导；
4. Fisher 信息量计算；
5. RCB 表达式；
6. 方差计算；
7. 拒绝域；
8. 最终结论。

---

# 五、考前公式速记

---

# 36. Fisher 信息量

得分函数：

$$
U(\theta)=\frac{\partial}{\partial\theta}\log f(X;\theta)
$$

三种计算方法：

$$
I(\theta)=E[U(\theta)^2]
$$

$$
I(\theta)=Var[U(\theta)]
$$

$$
I(\theta)=-E[\ell_1''(\theta)]
$$

样本总信息量：

$$
nI(\theta)
$$

---

# 37. Rao-Cramer 下界

估计 $k(\theta)$：

$$
Var(Y)\ge
\frac{[k'(\theta)]^2}{nI(\theta)}
$$

估计 $\theta$：

$$
Var(Y)\ge
\frac1{nI(\theta)}
$$

有效性：

$$
eff(Y)=\frac{RCB}{Var(Y)}
$$

---

# 38. 常见 Fisher 信息量

| 分布 | 参数含义 | Fisher 信息量 |
|---|---|---|
| $Bernoulli(\theta)$ | 成功概率 | $\frac1{\theta(1-\theta)}$ |
| $Poisson(\theta)$ | 均值 | $\frac1\theta$ |
| $Exp(1/\theta)$ | 尺度参数/均值 | $\frac1{\theta^2}$ |
| $\Gamma(\alpha_0,\theta)$ | $\alpha_0$ 已知，$\theta$ 为尺度 | $\frac{\alpha_0}{\theta^2}$ |
| $N(\theta,\sigma_0^2)$ | 均值参数，方差已知 | $\frac1{\sigma_0^2}$ |
| $N(\mu_0,\theta)$ | 方差参数，均值已知 | $\frac1{2\theta^2}$ |
| Laplace location | 位置参数 | $1$ |

---

# 39. LRT

似然比：

$$
\Lambda=\frac{L(\theta_0)}{L(\hat\theta)}
$$

对数形式：

$$
-2\log\Lambda=2[\ell(\hat\theta)-\ell(\theta_0)]
$$

渐近分布：

$$
-2\log\Lambda\overset{D}{\to}\chi^2(1)
$$

拒绝域：

$$
-2\log\Lambda\ge\chi^2_\alpha(1)
$$

---

# 40. Wald 检验

$$
\chi_W^2=nI(\hat\theta)(\hat\theta-\theta_0)^2
$$

拒绝域：

$$
\chi_W^2\ge\chi^2_\alpha(1)
$$

---

# 41. Score 检验

$$
\chi_R^2=
\left[
\frac{\ell'(\theta_0)}{\sqrt{nI(\theta_0)}}
\right]^2
$$

拒绝域：

$$
\chi_R^2\ge\chi^2_\alpha(1)
$$

---

# 六、最后复习路线

## 第一轮：先理解概念

先弄清：

1. Fisher 信息量是什么；
2. $I(\theta)$ 和 $nI(\theta)$ 的区别；
3. RCB 是无偏估计量方差的下界；
4. 有效估计量是达到 RCB 的无偏估计量；
5. LRT 是比较 $L(\theta_0)$ 和 $L(\hat\theta)$；
6. Wald 是看 $\hat\theta-\theta_0$；
7. Score 是看 $\ell'(\theta_0)$。

---

## 第二轮：背公式

必须背：

$$
I(\theta)=E[U^2]=Var(U)=-E[\ell_1''(\theta)]
$$

$$
RCB=\frac{[k'(\theta)]^2}{nI(\theta)}
$$

$$
\Lambda=\frac{L(\theta_0)}{L(\hat\theta)}
$$

$$
-2\log\Lambda=2[\ell(\hat\theta)-\ell(\theta_0)]
$$

$$
\chi_W^2=nI(\hat\theta)(\hat\theta-\theta_0)^2
$$

$$
\chi_R^2=
\left[
\frac{\ell'(\theta_0)}{\sqrt{nI(\theta_0)}}
\right]^2
$$

---

## 第三轮：刷题型

看到题目先判断：

| 题目要求 | 方法 |
|---|---|
| 计算 Fisher 信息量 | 三种方法之一或全部 |
| 判断估计量是否有效 | 算 RCB，算方差，比较 |
| 求 MLE | 写似然、取 log、求导 |
| 求 $\theta^2$ 这类函数的 RCB | 用 $[k'(\theta)]^2/[nI(\theta)]$ |
| 求 LRT | 写 $\Lambda=L(\theta_0)/L(\hat\theta)$ |
| 求渐近 LRT | 用 $-2\log\Lambda\sim\chi^2(1)$ |
| 求 Wald 检验 | 用 $nI(\hat\theta)(\hat\theta-\theta_0)^2$ |
| 求 Score 检验 | 用 $[\ell'(\theta_0)/\sqrt{nI(\theta_0)}]^2$ |
| 求拒绝域 | 写 $\chi^2\ge\chi^2_\alpha(1)$ 或转成精确分布 |

---

## 第四轮：检查易错点

每道题写完后检查：

1. $I(\theta)$ 有没有误写成 $nI(\theta)$？
2. 题目要求三种方法时有没有写全？
3. RCB 是否看清楚估计目标是 $\theta$ 还是 $k(\theta)$？
4. MLE 是否考虑了参数范围？
5. 无偏性是否证明？
6. 方差计算是否有过程？
7. Wald 统计量有没有平方？
8. Score 统计量有没有平方？
9. 是否写了拒绝域？
10. LRT 拒绝域是否说明了单调性或等价变形？
11. 结论是否写完整？