# 数理统计第十一讲、第十二讲完整复习笔记  
## 多参数估计与检验、充分统计量、Neyman 分解定理、Rao-Blackwell 定理、MVUE

---

# 0. 这两讲在整门课中的位置

前面第 9、10 讲已经讲了单参数情形下的：

1. Fisher 信息量；
2. Rao-Cramer 下界；
3. 有效估计量；
4. 似然比检验；
5. Wald 型检验；
6. Rao 得分型检验。

第 11 讲把这些内容推广到**多参数情形**。

也就是说，参数不再是一个数：

$$
\theta
$$

而是一个向量：

$$
\theta=(\theta_1,\theta_2,\dots,\theta_p)^T
$$

例如：

- 正态分布 $N(\mu,\sigma^2)$ 中，未知参数可以是：

$$
\theta=(\mu,\sigma^2)^T
$$

- 一般拉普拉斯分布中，未知参数可以是：

$$
\theta=(a,b)^T
$$

- 多项分布中，未知参数可以是：

$$
p=(p_1,\dots,p_{k-1})^T
$$

第 12 讲进入一个新的主题：**充分统计量与数据压缩**。

它要解决的问题是：

> 原始样本 $X_1,\dots,X_n$ 里包含很多信息，但是否可以用一个统计量 $T=T(X_1,\dots,X_n)$ 代替整组样本，而不丢失关于参数 $\theta$ 的信息？

如果可以，这个统计量就叫**充分统计量**。

第 12 讲还讲了：

1. 最小方差无偏估计量 MVUE；
2. 充分统计量的定义；
3. Neyman 分解定理；
4. Rao-Blackwell 定理；
5. 充分统计量与 MLE 的关系；
6. 如何利用充分统计量改进无偏估计。

这两讲的逻辑关系可以概括为：

- 第 11 讲：参数可能有多个，所以 Fisher 信息量从一个数变成一个矩阵；
- 第 12 讲：样本可能很复杂，所以希望用充分统计量压缩样本而不丢失参数信息；
- HW6：主要考查多参数 MLE、Fisher 信息矩阵、充分统计量判定和 Rao-Blackwell 条件期望。

---

# 一、Lecture 11：多参数估计与检验

---

# 1. 多参数情形的基本设定

设样本：

$$
X_1,\dots,X_n
$$

来自总体分布：

$$
f(x;\theta)
$$

其中参数为：

$$
\theta=(\theta_1,\theta_2,\dots,\theta_p)^T\in\Omega\subset R^p
$$

这里：

- $p=1$ 是前面单参数情形；
- $p>1$ 是第 11 讲的多参数情形。

样本似然函数仍然是：

$$
L(\theta)=\prod_{i=1}^n f(X_i;\theta)
$$

对数似然函数为：

$$
\ell(\theta)=\sum_{i=1}^n\log f(X_i;\theta)
$$

多参数 MLE 需要同时对每个参数分量求偏导。

如果似然函数光滑，则 MLE 通常满足：

$$
\frac{\partial L}{\partial \theta_k}=0,\qquad k=1,\dots,p
$$

或者等价地：

$$
\frac{\partial \ell}{\partial \theta_k}=0,\qquad k=1,\dots,p
$$

也就是要解一个方程组：

$$
\nabla \ell(\theta)=0
$$

其中：

$$
\nabla \ell(\theta)
=
\left(
\frac{\partial\ell}{\partial\theta_1},
\dots,
\frac{\partial\ell}{\partial\theta_p}
\right)^T
$$

---

# 2. 多参数 MLE 的一般步骤

多参数 MLE 和单参数 MLE 的思路一样，但计算上更复杂。

标准步骤是：

1. 写出联合似然函数：

$$
L(\theta_1,\dots,\theta_p)
$$

2. 取对数：

$$
\ell(\theta_1,\dots,\theta_p)=\log L(\theta_1,\dots,\theta_p)
$$

3. 分别求偏导：

$$
\frac{\partial \ell}{\partial \theta_1},\dots,\frac{\partial \ell}{\partial \theta_p}
$$

4. 令所有偏导数为 0：

$$
\frac{\partial \ell}{\partial \theta_j}=0,\qquad j=1,\dots,p
$$

5. 解方程组；
6. 检查参数空间、边界点和支持集限制。

多参数情形尤其要注意：

> 如果参数出现在分布支持集里，不能只机械求偏导，必须先写出似然函数非零的条件。

HW6 Problem 1 的 Pareto 分布就是这种题。

---

# 3. 例子：正态分布 $N(\mu,\sigma^2)$ 的多参数 MLE

设：

$$
X_1,\dots,X_n\sim N(\mu,\sigma^2)
$$

其中：

$$
\mu,\sigma^2
$$

均未知。

为了计算方便，记：

$$
v=\sigma^2
$$

参数向量写成：

$$
\theta=(\mu,v)^T
$$

参数空间为：

$$
\Omega=(-\infty,+\infty)\times(0,+\infty)
$$

---

## 3.1 写对数似然函数

单个样本密度为：

$$
f(x;\mu,v)
=
\frac{1}{\sqrt{2\pi v}}
\exp\left\{
-\frac{(x-\mu)^2}{2v}
\right\}
$$

样本对数似然函数为：

$$
\ell(\mu,v)
=
-\frac n2\log(2\pi)
-\frac n2\log v
-\frac1{2v}\sum_{i=1}^n(X_i-\mu)^2
$$

---

## 3.2 对 $\mu$ 求偏导

$$
\frac{\partial \ell}{\partial \mu}
=
\frac1v\sum_{i=1}^n(X_i-\mu)
$$

令其为 0：

$$
\sum_{i=1}^n(X_i-\mu)=0
$$

得到：

$$
\hat\mu=\bar X
$$

---

## 3.3 对 $v$ 求偏导

$$
\frac{\partial \ell}{\partial v}
=
-\frac n{2v}
+
\frac1{2v^2}\sum_{i=1}^n(X_i-\mu)^2
$$

令其为 0：

$$
-\frac n{2v}
+
\frac1{2v^2}\sum_{i=1}^n(X_i-\mu)^2=0
$$

两边乘以 $2v^2$：

$$
-nv+\sum_{i=1}^n(X_i-\mu)^2=0
$$

代入：

$$
\hat\mu=\bar X
$$

得到：

$$
\hat v
=
\frac1n\sum_{i=1}^n(X_i-\bar X)^2
$$

---

## 3.4 结论

正态总体中：

$$
\hat\mu=\bar X
$$

$$
\hat v=\hat\sigma^2
=
\frac1n\sum_{i=1}^n(X_i-\bar X)^2
$$

注意：

$$
\hat v
$$

是 $\sigma^2$ 的 MLE，但它是有偏估计。

因为：

$$
E(\hat v)
=
\frac{n-1}{n}\sigma^2
$$

而无偏样本方差是：

$$
S^2
=
\frac1{n-1}\sum_{i=1}^n(X_i-\bar X)^2
$$

两者关系是：

$$
\hat v=\frac{n-1}{n}S^2
$$

---

# 4. 例子：一般拉普拉斯分布的多参数 MLE

设：

$$
X_1,\dots,X_n
$$

来自一般拉普拉斯分布：

$$
f(x;a,b)=\frac1{2b}e^{-|x-a|/b},\qquad -\infty<x<+\infty
$$

其中：

$$
a\in R,\qquad b>0
$$

参数向量为：

$$
\theta=(a,b)^T
$$

---

## 4.1 对数似然函数

样本对数似然函数为：

$$
\ell(a,b)
=
-n\log 2
-n\log b
-\frac1b\sum_{i=1}^n|X_i-a|
$$

---

## 4.2 关于 $a$ 的估计

对于固定的 $b$，最大化：

$$
\ell(a,b)
$$

等价于最小化：

$$
\sum_{i=1}^n|X_i-a|
$$

这个问题的解是样本中位数。

所以：

$$
\hat a=Q_2
$$

其中：

$$
Q_2=median\{X_1,\dots,X_n\}
$$

---

## 4.3 关于 $b$ 的估计

对 $b$ 求偏导：

$$
\frac{\partial \ell}{\partial b}
=
-\frac nb
+
\frac1{b^2}\sum_{i=1}^n|X_i-a|
$$

令其为 0：

$$
-\frac nb
+
\frac1{b^2}\sum_{i=1}^n|X_i-a|=0
$$

解得：

$$
\hat b
=
\frac1n\sum_{i=1}^n|X_i-\hat a|
$$

由于：

$$
\hat a=Q_2
$$

所以：

$$
\hat b
=
\frac1n\sum_{i=1}^n|X_i-Q_2|
$$

---

## 4.4 结论

一般拉普拉斯分布中：

$$
\hat a=Q_2
$$

$$
\hat b=\frac1n\sum_{i=1}^n|X_i-Q_2|
$$

这说明：

> 对于拉普拉斯分布，位置参数估计用中位数，尺度参数估计用平均绝对偏差。

---

# 5. 多参数 Fisher 信息矩阵

单参数时 Fisher 信息量是一个数：

$$
I(\theta)
$$

多参数时，Fisher 信息量变成一个矩阵：

$$
I(\theta)
$$

它是一个：

$$
p\times p
$$

矩阵。

---

## 5.1 得分向量

单个样本的对数密度为：

$$
\log f(X;\theta)
$$

对参数向量求梯度：

$$
\nabla\log f(X;\theta)
=
\left(
\frac{\partial}{\partial\theta_1}\log f(X;\theta),
\dots,
\frac{\partial}{\partial\theta_p}\log f(X;\theta)
\right)^T
$$

这叫**得分向量**。

---

## 5.2 Fisher 信息矩阵定义

多参数 Fisher 信息矩阵定义为：

$$
I(\theta)
=
Cov\{\nabla\log f(X;\theta)\}
$$

其中第 $(j,k)$ 个元素是：

$$
I_{jk}(\theta)
=
Cov\left(
\frac{\partial}{\partial\theta_j}\log f(X;\theta),
\frac{\partial}{\partial\theta_k}\log f(X;\theta)
\right)
$$

在正则条件下，由于得分向量期望为零，也可以写成：

$$
I_{jk}(\theta)
=
E\left[
\frac{\partial}{\partial\theta_j}\log f(X;\theta)
\cdot
\frac{\partial}{\partial\theta_k}\log f(X;\theta)
\right]
$$

还可以用二阶导数公式：

$$
I_{jk}(\theta)
=
-
E\left[
\frac{\partial^2}{\partial\theta_j\partial\theta_k}
\log f(X;\theta)
\right]
$$

---

## 5.3 计算 Fisher 信息矩阵的步骤

1. 写单个样本的对数密度：

$$
\log f(X;\theta)
$$

2. 对每个参数求一阶偏导：

$$
\frac{\partial}{\partial\theta_1}\log f,\dots,
\frac{\partial}{\partial\theta_p}\log f
$$

3. 对每对参数求二阶偏导：

$$
\frac{\partial^2}{\partial\theta_j\partial\theta_k}\log f
$$

4. 取负期望：

$$
I_{jk}(\theta)
=
-
E\left[
\frac{\partial^2}{\partial\theta_j\partial\theta_k}
\log f
\right]
$$

5. 组成矩阵：

$$
I(\theta)
$$

6. 如果要求 RCB，还要计算：

$$
I^{-1}(\theta)
$$

---

# 6. 多参数 Rao-Cramer 下界

单参数时，如果 $Y$ 是 $\theta$ 的无偏估计，则：

$$
Var(Y)\ge \frac1{nI(\theta)}
$$

多参数时，如果要估计参数分量：

$$
\theta_j
$$

那么 Rao-Cramer 下界是：

$$
Var(Y_j)
\ge
\frac1n\{I^{-1}(\theta)\}_{jj}
$$

其中：

$$
\{I^{-1}(\theta)\}_{jj}
$$

表示 Fisher 信息矩阵的逆矩阵的第 $j$ 个对角元素。

---

## 6.1 为什么多参数下要用逆矩阵？

因为当参数不止一个时，参数之间可能相互影响。

例如：

$$
\theta=(\theta_1,\theta_2)^T
$$

如果 $\theta_1$ 和 $\theta_2$ 的估计相互相关，那么单独看 $I_{11}$ 不够。

需要用整个信息矩阵：

$$
I(\theta)
$$

再取逆矩阵：

$$
I^{-1}(\theta)
$$

其对角线元素给出每个参数分量估计方差的下界。

---

## 6.2 多参数有效估计量

若 $Y_j$ 是 $\theta_j$ 的无偏估计，且：

$$
Var(Y_j)
=
\frac1n\{I^{-1}(\theta)\}_{jj}
$$

则称：

$$
Y_j
$$

是 $\theta_j$ 的有效估计量。

---

## 6.3 多参数有效性

若 $Y_j$ 是 $\theta_j$ 的无偏估计，则它的有效性定义为：

$$
eff(Y_j)
=
\frac{\{I^{-1}(\theta)\}_{jj}}{nVar(Y_j)}
$$

也就是：

$$
eff(Y_j)
=
\frac{RCB}{Var(Y_j)}
$$

如果：

$$
eff(Y_j)=1
$$

说明达到 RCB。

如果：

$$
eff(Y_j)<1
$$

说明没有达到 RCB。

---

# 7. 正态分布多参数 Fisher 信息矩阵与 RCB

设：

$$
X\sim N(\mu,v)
$$

其中：

$$
v=\sigma^2
$$

参数：

$$
\theta=(\mu,v)^T
$$

单个样本对数密度为：

$$
\log f(X;\theta)
=
-\frac12\log(2\pi)
-\frac12\log v
-\frac1{2v}(X-\mu)^2
$$

---

## 7.1 求一阶偏导

对 $\mu$ 求导：

$$
\frac{\partial \log f}{\partial\mu}
=
\frac1v(X-\mu)
$$

对 $v$ 求导：

$$
\frac{\partial \log f}{\partial v}
=
-\frac1{2v}
+
\frac1{2v^2}(X-\mu)^2
$$

---

## 7.2 求二阶偏导

$$
\frac{\partial^2\log f}{\partial\mu^2}
=
-\frac1v
$$

$$
\frac{\partial^2\log f}{\partial v^2}
=
\frac1{2v^2}
-
\frac1{v^3}(X-\mu)^2
$$

$$
\frac{\partial^2\log f}{\partial\mu\partial v}
=
-\frac1{v^2}(X-\mu)
$$

---

## 7.3 取负期望得到 Fisher 信息矩阵

因为：

$$
E(X-\mu)=0
$$

$$
E[(X-\mu)^2]=v
$$

所以：

$$
I_{11}
=
-E\left[
-\frac1v
\right]
=
\frac1v
$$

$$
I_{12}
=
I_{21}
=
-E\left[
-\frac1{v^2}(X-\mu)
\right]
=
0
$$

$$
I_{22}
=
-E\left[
\frac1{2v^2}
-
\frac1{v^3}(X-\mu)^2
\right]
$$

$$
=
-\frac1{2v^2}
+
\frac1{v^3}E[(X-\mu)^2]
$$

$$
=
-\frac1{2v^2}
+
\frac{v}{v^3}
=
\frac1{2v^2}
$$

因此：

$$
I(\theta)
=
\begin{pmatrix}
1/v & 0\\
0 & 1/(2v^2)
\end{pmatrix}
$$

逆矩阵为：

$$
I^{-1}(\theta)
=
\begin{pmatrix}
v & 0\\
0 & 2v^2
\end{pmatrix}
$$

---

## 7.4 $\mu$ 的 RCB 与有效性

对于 $\mu$ 的无偏估计量：

$$
RCB_\mu
=
\frac1n\{I^{-1}(\theta)\}_{11}
=
\frac vn
$$

而：

$$
\hat\mu=\bar X
$$

满足：

$$
E(\bar X)=\mu
$$

$$
Var(\bar X)=\frac vn
$$

所以：

$$
Var(\bar X)=RCB_\mu
$$

因此：

$$
\bar X
$$

是 $\mu$ 的有效估计量。

---

## 7.5 $v$ 的 RCB 与样本方差有效性

对于 $v=\sigma^2$ 的无偏估计量：

$$
RCB_v
=
\frac1n\{I^{-1}(\theta)\}_{22}
=
\frac{2v^2}{n}
$$

MLE：

$$
\hat v
=
\frac1n\sum_{i=1}^n(X_i-\bar X)^2
$$

是有偏的，不能直接用来判断是否达到无偏估计的 RCB。

无偏样本方差是：

$$
S^2
=
\frac1{n-1}\sum_{i=1}^n(X_i-\bar X)^2
$$

由学生定理：

$$
\frac{(n-1)S^2}{v}\sim \chi^2(n-1)
$$

所以：

$$
Var(S^2)
=
\frac{v^2}{(n-1)^2}Var[\chi^2(n-1)]
$$

$$
=
\frac{v^2}{(n-1)^2}\cdot 2(n-1)
$$

$$
=
\frac{2v^2}{n-1}
$$

比较：

$$
Var(S^2)=\frac{2v^2}{n-1}
>
\frac{2v^2}{n}=RCB_v
$$

因此：

$$
S^2
$$

没有达到 RCB。

其有效性为：

$$
eff(S^2)
=
\frac{RCB_v}{Var(S^2)}
=
\frac{2v^2/n}{2v^2/(n-1)}
=
\frac{n-1}{n}
$$

所以：

$$
S^2
$$

是渐进有效的，因为：

$$
\frac{n-1}{n}\to 1
$$

---

# 8. HW6 Problem 2：正态分布中 $\sigma$ 的无偏估计 RCB

HW6 的 Problem 2 不是问 $v=\sigma^2$ 的 RCB，而是问：

$$
\sigma
$$

的无偏估计的 RCB。

这时参数向量最好写成：

$$
\theta=(\mu,\sigma)^T
$$

而不是：

$$
(\mu,\sigma^2)^T
$$

---

## 8.1 单个样本对数密度

$$
f(x;\mu,\sigma)
=
\frac1{\sqrt{2\pi\sigma^2}}
\exp\left\{
-\frac{(x-\mu)^2}{2\sigma^2}
\right\}
$$

$$
\log f(x;\mu,\sigma)
=
-\frac12\log(2\pi)
-\log\sigma
-\frac{(x-\mu)^2}{2\sigma^2}
$$

---

## 8.2 一阶偏导

对 $\mu$ 求导：

$$
\frac{\partial \log f}{\partial \mu}
=
\frac{x-\mu}{\sigma^2}
$$

对 $\sigma$ 求导：

$$
\frac{\partial \log f}{\partial \sigma}
=
-\frac1\sigma
+
\frac{(x-\mu)^2}{\sigma^3}
$$

---

## 8.3 二阶偏导

$$
\frac{\partial^2\log f}{\partial\mu^2}
=
-\frac1{\sigma^2}
$$

$$
\frac{\partial^2\log f}{\partial\mu\partial\sigma}
=
-\frac{2(x-\mu)}{\sigma^3}
$$

$$
\frac{\partial^2\log f}{\partial\sigma^2}
=
\frac1{\sigma^2}
-
\frac{3(x-\mu)^2}{\sigma^4}
$$

---

## 8.4 Fisher 信息矩阵

取负期望。

因为：

$$
E(X-\mu)=0
$$

$$
E[(X-\mu)^2]=\sigma^2
$$

得到：

$$
I_{\mu\mu}=\frac1{\sigma^2}
$$

$$
I_{\mu\sigma}=I_{\sigma\mu}=0
$$

$$
I_{\sigma\sigma}
=
-\left[
\frac1{\sigma^2}
-
\frac3{\sigma^4}E(X-\mu)^2
\right]
$$

$$
=
-\frac1{\sigma^2}
+
\frac3{\sigma^2}
=
\frac2{\sigma^2}
$$

所以：

$$
I(\mu,\sigma)
=
\begin{pmatrix}
1/\sigma^2 & 0\\
0 & 2/\sigma^2
\end{pmatrix}
$$

逆矩阵为：

$$
I^{-1}(\mu,\sigma)
=
\begin{pmatrix}
\sigma^2 & 0\\
0 & \sigma^2/2
\end{pmatrix}
$$

因此 $\sigma$ 的无偏估计量的 RCB 为：

$$
RCB_\sigma
=
\frac1n\{I^{-1}(\mu,\sigma)\}_{22}
=
\frac{\sigma^2}{2n}
$$

---

## 8.5 本题易错点

1. 这题参数是：

$$
(\mu,\sigma)
$$

不是：

$$
(\mu,\sigma^2)
$$

2. 要对 $\mu$ 和 $\sigma$ 分别求偏导；
3. 要写 Fisher 信息矩阵；
4. 要写逆矩阵；
5. RCB 取逆矩阵中对应 $\sigma$ 的对角元素；
6. 结果是：

$$
\frac{\sigma^2}{2n}
$$

不是：

$$
\frac{2\sigma^4}{n}
$$

后者是估计 $\sigma^2$ 时会出现的量。

---

# 9. Location-scale family

Lecture 11 中还讲了 location-scale family。

设：

$$
X_i=a+be_i
$$

其中：

$$
b>0
$$

且：

$$
e_i
$$

独立同分布，密度为：

$$
f(z)
$$

则 $X_i$ 的密度为：

$$
f_X(x)
=
\frac1b f\left(\frac{x-a}{b}\right)
$$

这里：

- $a$ 是位置参数；
- $b$ 是尺度参数。

---

## 9.1 对 $a$ 求偏导

令：

$$
z=\frac{x-a}{b}
$$

则：

$$
\log f_X(x)
=
-\log b+\log f(z)
$$

对 $a$ 求导：

$$
\frac{\partial \log f_X(x)}{\partial a}
=
-\frac1b
\frac{f'(z)}{f(z)}
$$

---

## 9.2 对 $b$ 求偏导

$$
\frac{\partial \log f_X(x)}{\partial b}
=
-\frac1b
\left[
1+
z\frac{f'(z)}{f(z)}
\right]
$$

---

## 9.3 Fisher 信息矩阵形式

Lecture 11 给出：

$$
I_{11}
=
\frac1{b^2}
\int_{-\infty}^{\infty}
\left[
\frac{f'(z)}{f(z)}
\right]^2
f(z)\,dz
$$

$$
I_{22}
=
\frac1{b^2}
\int_{-\infty}^{\infty}
\left[
1+
z\frac{f'(z)}{f(z)}
\right]^2
f(z)\,dz
$$

$$
I_{12}
=
\frac1{b^2}
\int_{-\infty}^{\infty}
z
\left[
\frac{f'(z)}{f(z)}
\right]^2
f(z)\,dz
$$

这部分一般不太会要求完整推导，但要理解：

> location-scale family 的 Fisher 信息矩阵通常带有共同因子 $1/b^2$。

---

# 10. 多项分布的多参数估计与 Fisher 信息矩阵

设一次试验可能出现 $k$ 种结果，概率分别为：

$$
p_1,\dots,p_k
$$

满足：

$$
\sum_{j=1}^k p_j=1
$$

由于最后一个概率：

$$
p_k=1-\sum_{j=1}^{k-1}p_j
$$

可由前 $k-1$ 个决定，所以参数向量通常取：

$$
p=(p_1,\dots,p_{k-1})^T
$$

---

## 10.1 单次试验的表示

令：

$$
X_j=I\{\text{第 }j\text{ 类结果发生}\}
$$

则：

$$
X=(X_1,\dots,X_{k-1})^T
$$

概率质量函数为：

$$
f(x;p)
=
\left(
\prod_{i=1}^{k-1}p_i^{x_i}
\right)
\left(
1-\sum_{j=1}^{k-1}p_j
\right)^{1-\sum_{j=1}^{k-1}x_j}
$$

---

## 10.2 Fisher 信息矩阵

Lecture 11 给出：

对角元：

$$
I_{ii}
=
\frac1{p_i}+\frac1{p_k}
$$

非对角元：

$$
I_{ih}
=
\frac1{p_k},\qquad i\ne h
$$

所以：

$$
I(p)=
\begin{pmatrix}
1/p_1+1/p_k & 1/p_k & \cdots & 1/p_k\\
1/p_k & 1/p_2+1/p_k & \cdots & 1/p_k\\
\vdots & \vdots & \ddots & \vdots\\
1/p_k & 1/p_k & \cdots & 1/p_{k-1}+1/p_k
\end{pmatrix}
$$

逆矩阵为：

$$
I^{-1}(p)
=
\begin{pmatrix}
p_1(1-p_1) & -p_1p_2 & \cdots & -p_1p_{k-1}\\
-p_1p_2 & p_2(1-p_2) & \cdots & -p_2p_{k-1}\\
\vdots & \vdots & \ddots & \vdots\\
-p_1p_{k-1} & -p_2p_{k-1} & \cdots & p_{k-1}(1-p_{k-1})
\end{pmatrix}
$$

---

## 10.3 多项分布的 MLE

设样本量为 $n$，令：

$$
T_j=\sum_{i=1}^n X_{ji}
$$

表示第 $j$ 类结果出现的次数。

对数似然函数可以写成：

$$
\ell(p)
=
\sum_{j=1}^{k-1}T_j\log p_j
+
\left(n-\sum_{j=1}^{k-1}T_j\right)
\log\left(1-\sum_{j=1}^{k-1}p_j\right)
$$

求偏导并令其为 0，可得：

$$
\hat p_j=\frac{T_j}{n},\qquad j=1,\dots,k-1
$$

---

## 10.4 有效性

由于：

$$
T_j\sim Bin(n,p_j)
$$

所以：

$$
E(\hat p_j)
=
E\left(\frac{T_j}{n}\right)
=
p_j
$$

并且：

$$
Var(\hat p_j)
=
\frac1{n^2}Var(T_j)
=
\frac1{n^2}np_j(1-p_j)
=
\frac{p_j(1-p_j)}n
$$

而：

$$
RCB_{p_j}
=
\frac1n\{I^{-1}(p)\}_{jj}
=
\frac{p_j(1-p_j)}n
$$

因此：

$$
\hat p_j=\frac{T_j}{n}
$$

是 $p_j$ 的有效估计。

---

# 11. 多参数情形的检验

第 10 讲讲的是单参数：

$$
H_0:\theta=\theta_0
$$

第 11 讲推广到多参数。

---

# 11.1 点假设检验：$H_0:\theta=\theta_0$

设：

$$
\theta\in R^p
$$

检验：

$$
H_0:\theta=\theta_0
$$

$$
H_1:\theta\ne\theta_0
$$

三种检验方法仍然成立。

---

## 11.1.1 多参数 LRT

似然比：

$$
\Lambda=
\frac{L(\theta_0)}{L(\hat\theta)}
$$

其中：

$$
\hat\theta
$$

是全参数空间中的 MLE。

LRT 统计量：

$$
\chi_L^2
=
-2\log\Lambda
=
2[\ell(\hat\theta)-\ell(\theta_0)]
$$

在 $H_0$ 下，大样本近似：

$$
\chi_L^2\overset{D}{\to}\chi^2(p)
$$

拒绝域：

$$
\chi_L^2\ge \chi^2_\alpha(p)
$$

---

## 11.1.2 多参数 Wald 检验

Wald 统计量：

$$
\chi_W^2
=
(\hat\theta-\theta_0)^T
\{nI(\hat\theta)\}
(\hat\theta-\theta_0)
$$

在 $H_0$ 下：

$$
\chi_W^2\overset{D}{\to}\chi^2(p)
$$

拒绝域：

$$
\chi_W^2\ge \chi^2_\alpha(p)
$$

---

## 11.1.3 多参数 Score 检验

得分向量为：

$$
\nabla\ell(\theta_0)
$$

Score 统计量为：

$$
\chi_R^2
=
\{\nabla\ell(\theta_0)\}^T
\{nI(\hat\theta_0)\}^{-1}
\{\nabla\ell(\theta_0)\}
$$

其中：

$$
\hat\theta_0
$$

表示在原假设约束下得到的估计。

在 $H_0$ 下：

$$
\chi_R^2\overset{D}{\to}\chi^2(p)
$$

拒绝域：

$$
\chi_R^2\ge\chi^2_\alpha(p)
$$

---

# 11.2 约束假设检验

更常见的多参数检验并不是检验整个参数向量等于某个固定值，而是检验参数是否满足若干约束。

例如：

$$
H_0:\mu_1=\mu_2=\cdots=\mu_r
$$

这里参数向量可能是：

$$
(\mu_1,\dots,\mu_r,\sigma^2)
$$

但原假设只是限制均值相等。

一般形式：

$$
H_0:\theta\in \omega
$$

$$
H_1:\theta\in \Omega\cap\omega^c
$$

其中 $\omega$ 由 $q$ 个约束定义：

$$
g_1(\theta)=a_1
$$

$$
\cdots
$$

$$
g_q(\theta)=a_q
$$

约束个数为：

$$
q
$$

---

## 11.2.1 约束 LRT

定义：

$$
\hat\theta=\arg\max_{\theta\in\Omega}L(\theta)
$$

是全参数空间中的 MLE。

定义：

$$
\hat\theta_0=\arg\max_{\theta\in\omega}L(\theta)
$$

是原假设约束空间中的 MLE。

似然比为：

$$
\Lambda=
\frac{\max_{\theta\in\omega}L(\theta)}
{\max_{\theta\in\Omega}L(\theta)}
=
\frac{L(\hat\theta_0)}{L(\hat\theta)}
$$

统计量：

$$
\chi_L^2=-2\log\Lambda
=
2[\ell(\hat\theta)-\ell(\hat\theta_0)]
$$

在正则条件下：

$$
\chi_L^2\overset{D}{\to}\chi^2(q)
$$

注意自由度是约束个数：

$$
q
$$

不是参数总个数 $p$。

拒绝域：

$$
\chi_L^2\ge\chi^2_\alpha(q)
$$

---

# 12. 例子：正态分布方差未知时检验均值

设：

$$
X_1,\dots,X_n\sim N(\mu,\sigma^2)
$$

其中：

$$
\sigma^2
$$

未知。

检验：

$$
H_0:\mu=\mu_0
$$

$$
H_1:\mu\ne\mu_0
$$

---

## 12.1 全参数空间下的 MLE

全参数空间：

$$
\Omega=\{(\mu,\sigma):-\infty<\mu<+\infty,\sigma>0\}
$$

全空间下：

$$
\hat\mu=\bar X
$$

$$
\hat\sigma^2
=
\frac1n\sum_{i=1}^n(X_i-\bar X)^2
$$

---

## 12.2 原假设约束下的 MLE

原假设约束空间：

$$
\omega=\{(\mu,\sigma):\mu=\mu_0,\sigma>0\}
$$

在 $\mu=\mu_0$ 的限制下，只需要估计 $\sigma^2$。

得到：

$$
\hat\mu_0=\mu_0
$$

$$
\hat\sigma_0^2
=
\frac1n\sum_{i=1}^n(X_i-\mu_0)^2
$$

---

## 12.3 似然比统计量

正态似然在 MLE 处的形式与估计的方差有关。

似然比为：

$$
\Lambda
=
\frac{L(\hat\theta_0)}{L(\hat\theta)}
=
\left(
\frac{\hat\sigma^2}{\hat\sigma_0^2}
\right)^{n/2}
$$

其中：

$$
\hat\sigma^2
=
\frac1n\sum_{i=1}^n(X_i-\bar X)^2
$$

$$
\hat\sigma_0^2
=
\frac1n\sum_{i=1}^n(X_i-\mu_0)^2
$$

由于：

$$
\sum_{i=1}^n(X_i-\mu_0)^2
=
\sum_{i=1}^n(X_i-\bar X)^2
+
n(\bar X-\mu_0)^2
$$

所以 $\hat\sigma_0^2$ 越大，说明 $\mu_0$ 越不合适。

---

## 12.4 与 t 检验的关系

拒绝域：

$$
\{\Lambda\le c\}
$$

等价于：

$$
\frac{\sum_{i=1}^n(X_i-\mu_0)^2}
{\sum_{i=1}^n(X_i-\bar X)^2}
\ge c'
$$

进一步等价于：

$$
\frac{n(\bar X-\mu_0)^2}
{\sum_{i=1}^n(X_i-\bar X)^2}
\ge c''
$$

也就是：

$$
\frac{|\bar X-\mu_0|}
{S/\sqrt n}
\ge c'''
$$

其中：

$$
S^2=\frac1{n-1}\sum_{i=1}^n(X_i-\bar X)^2
$$

因此，正态均值未知方差情形下的 LRT 最终会等价于双侧 t 检验：

$$
\left|
\frac{\bar X-\mu_0}{S/\sqrt n}
\right|
\ge
t_{\alpha/2}(n-1)
$$

---

# 13. 例子：方差分析 ANOVA 的 LRT 视角

设第 $i$ 组第 $j$ 个观测为：

$$
X_{ij}
$$

模型为：

$$
X_{ij}\sim N(\mu_i,\sigma^2)
$$

其中：

$$
i=1,\dots,r
$$

$$
j=1,\dots,n_i
$$

检验：

$$
H_0:\mu_1=\mu_2=\cdots=\mu_r
$$

$$
H_1:\mu_i\text{ 不全相等}
$$

---

## 13.1 无约束 MLE

在无约束模型下，每组都有自己的均值：

$$
\hat\mu_i=\bar X_{i\cdot}
$$

方差 MLE 为：

$$
\tilde\sigma^2
=
\frac1n
\sum_{i=1}^r\sum_{j=1}^{n_i}
(X_{ij}-\bar X_{i\cdot})^2
=
\frac{SE}{n}
$$

其中：

$$
SE
$$

是组内误差平方和。

---

## 13.2 原假设下的 MLE

在原假设下：

$$
\mu_1=\mu_2=\cdots=\mu_r=\mu
$$

共同均值估计为：

$$
\hat\mu=\bar X
$$

方差 MLE 为：

$$
\tilde\sigma'^2
=
\frac1n
\sum_{i=1}^r\sum_{j=1}^{n_i}
(X_{ij}-\bar X)^2
=
\frac{ST}{n}
$$

其中：

$$
ST
$$

是总平方和。

又有：

$$
ST=SA+SE
$$

其中：

- $SA$ 是组间平方和；
- $SE$ 是组内平方和。

---

## 13.3 LRT 统计量

Lecture 11 推出：

$$
\chi_L^2
=
n\log\left(
\frac{\tilde\sigma'^2}{\tilde\sigma^2}
\right)
$$

由于：

$$
\tilde\sigma^2=\frac{SE}{n}
$$

$$
\tilde\sigma'^2=\frac{ST}{n}=\frac{SA+SE}{n}
$$

所以：

$$
\chi_L^2
=
n\log\left(
\frac{SA+SE}{SE}
\right)
$$

也就是：

$$
\chi_L^2
=
n\log\left(
1+\frac{SA}{SE}
\right)
$$

因此：

$$
\chi_L^2
$$

越大等价于：

$$
\frac{SA}{SE}
$$

越大。

而传统 ANOVA 的 F 统计量为：

$$
F=
\frac{SA/(r-1)}{SE/(n-r)}
$$

在 $H_0$ 下：

$$
F\sim F(r-1,n-r)
$$

所以最终精确拒绝域是：

$$
F\ge F_\alpha(r-1,n-r)
$$

若使用 LRT 的渐近理论，也可以写近似拒绝域：

$$
\chi_L^2\ge \chi_\alpha^2(r-1)
$$

这里约束个数是：

$$
q=r-1
$$

因为原假设把 $r$ 个均值约束为相等，相当于减少了 $r-1$ 个自由参数。

---

# 14. HW6 Problem 1：Pareto 分布的多参数 MLE

HW6 Problem 1 是多参数 MLE 的典型题，而且参数出现在支持集里。

给定分布函数：

$$
F(x;\theta_1,\theta_2)
=
\begin{cases}
1-\left(\frac{\theta_1}{x}\right)^{\theta_2},&x\ge \theta_1\\
0,&x<\theta_1
\end{cases}
$$

其中：

$$
\theta_1>0,\qquad \theta_2>0
$$

---

## 14.1 求密度函数

对 $x$ 求导：

$$
f(x;\theta_1,\theta_2)
=
\theta_2\theta_1^{\theta_2}x^{-(\theta_2+1)},\qquad x\ge\theta_1
$$

即：

$$
f(x;\theta_1,\theta_2)
=
\begin{cases}
\theta_2\theta_1^{\theta_2}x^{-(\theta_2+1)},&x\ge\theta_1\\
0,&x<\theta_1
\end{cases}
$$

---

## 14.2 写似然函数

样本似然函数为：

$$
L(\theta_1,\theta_2)
=
\prod_{i=1}^n
\theta_2\theta_1^{\theta_2}X_i^{-(\theta_2+1)}
$$

同时必须满足：

$$
X_i\ge \theta_1,\qquad i=1,\dots,n
$$

等价于：

$$
\theta_1\le X_{(1)}
$$

其中：

$$
X_{(1)}=\min\{X_1,\dots,X_n\}
$$

因此：

$$
L(\theta_1,\theta_2)
=
\theta_2^n
\theta_1^{n\theta_2}
\left(\prod_{i=1}^n X_i\right)^{-(\theta_2+1)}
I\{\theta_1\le X_{(1)}\}
$$

---

## 14.3 求 $\hat\theta_1$

在给定 $\theta_2$ 的情况下：

$$
L(\theta_1,\theta_2)
$$

关于 $\theta_1$ 含有：

$$
\theta_1^{n\theta_2}
$$

由于：

$$
\theta_2>0
$$

所以它随 $\theta_1$ 增大而增大。

但又必须满足：

$$
\theta_1\le X_{(1)}
$$

因此最大值在边界点取得：

$$
\hat\theta_1=X_{(1)}
$$

这一步是本题的关键。

不能只对 $\theta_1$ 求导，因为 $\theta_1$ 出现在支持集约束中。

---

## 14.4 求 $\hat\theta_2$

将：

$$
\hat\theta_1=X_{(1)}
$$

代入似然函数。

关于 $\theta_2$ 的对数似然为：

$$
\log L(\theta_2)
=
n\log\theta_2
+
n\theta_2\log X_{(1)}
-
(\theta_2+1)\sum_{i=1}^n\log X_i
$$

对 $\theta_2$ 求导：

$$
\frac{\partial\log L}{\partial\theta_2}
=
\frac n{\theta_2}
+
n\log X_{(1)}
-
\sum_{i=1}^n\log X_i
$$

令其为 0：

$$
\frac n{\theta_2}
=
\sum_{i=1}^n\log X_i
-
n\log X_{(1)}
$$

所以：

$$
\hat\theta_2
=
\frac{n}{
\sum_{i=1}^n\log X_i
-
n\log X_{(1)}
}
$$

也可以写成：

$$
\hat\theta_2
=
\frac{n}{
\sum_{i=1}^n\log\left(\frac{X_i}{X_{(1)}}\right)
}
$$

---

## 14.5 本题易错点

1. 要先求密度函数；
2. 要写出似然函数非零条件：

$$
\theta_1\le X_{(1)}
$$

3. 要说明 $L$ 关于 $\theta_1$ 单调递增；
4. 不能漏掉 $\hat\theta_1=X_{(1)}$；
5. 求 $\theta_2$ 时要把 $\hat\theta_1$ 代入；
6. 对数似然函数和求导过程要写。

---

# 15. HW6 Problem 3：正态方差参数的 LRT 精确拒绝域

设：

$$
X_1,\dots,X_n\sim N(\mu,v)
$$

其中：

$$
\mu,v
$$

均未知。

检验：

$$
H_0:v=v_0
$$

$$
H_1:v\ne v_0
$$

要求：

1. 计算似然比 $\Lambda$；
2. 将拒绝域转化为 $H_0$ 下有已知精确分布的统计量区域。

---

## 15.1 全参数空间下的 MLE

联合密度为：

$$
L(\mu,v)
=
(2\pi v)^{-n/2}
\exp\left\{
-\frac1{2v}\sum_{i=1}^n(X_i-\mu)^2
\right\}
$$

全空间下：

$$
\hat\mu=\bar X
$$

$$
\hat v
=
\frac1n\sum_{i=1}^n(X_i-\bar X)^2
$$

最大似然值为：

$$
\sup_\Omega L
=
(2\pi\hat v)^{-n/2}e^{-n/2}
$$

---

## 15.2 原假设下的 MLE

在：

$$
H_0:v=v_0
$$

下，只有 $\mu$ 需要估计。

仍然有：

$$
\hat\mu_0=\bar X
$$

原假设下最大似然值为：

$$
\sup_{H_0}L
=
(2\pi v_0)^{-n/2}
\exp\left\{
-\frac1{2v_0}\sum_{i=1}^n(X_i-\bar X)^2
\right\}
$$

---

## 15.3 似然比

$$
\Lambda
=
\frac{\sup_{H_0}L}{\sup_\Omega L}
$$

代入：

$$
\Lambda
=
\frac{
(2\pi v_0)^{-n/2}
\exp\left\{
-\frac1{2v_0}\sum(X_i-\bar X)^2
\right\}
}{
(2\pi\hat v)^{-n/2}e^{-n/2}
}
$$

由于：

$$
\sum_{i=1}^n(X_i-\bar X)^2=n\hat v
$$

所以：

$$
\Lambda
=
\left(
\frac{\hat v}{v_0}
\right)^{n/2}
\exp\left\{
\frac n2-\frac{n\hat v}{2v_0}
\right\}
$$

也就是：

$$
\Lambda
=
\left[
\frac{\hat v}{v_0}
e^{1-\hat v/v_0}
\right]^{n/2}
$$

---

## 15.4 转化拒绝域

令：

$$
t=\frac{\hat v}{v_0}
=
\frac1{nv_0}\sum_{i=1}^n(X_i-\bar X)^2
$$

则：

$$
\Lambda=(te^{1-t})^{n/2}
$$

令：

$$
g(t)=te^{1-t}
$$

求导：

$$
g'(t)=e^{1-t}(1-t)
$$

所以：

- 当 $t<1$ 时，$g'(t)>0$，$g(t)$ 递增；
- 当 $t>1$ 时，$g'(t)<0$，$g(t)$ 递减；
- $t=1$ 时最大。

因此：

$$
\{\Lambda\le c\}
$$

对应两侧拒绝域：

$$
t\le c_1
$$

或者：

$$
t\ge c_2
$$

其中：

$$
c_1<1<c_2
$$

---

## 15.5 使用精确分布

在 $H_0:v=v_0$ 下：

$$
W=
\frac{\sum_{i=1}^n(X_i-\bar X)^2}{v_0}
\sim \chi^2(n-1)
$$

又：

$$
t=\frac Wn
$$

因此拒绝域可以写成：

$$
W\le nc_1
$$

或者：

$$
W\ge nc_2
$$

在显著性水平 $\alpha$ 下，取双侧尾概率各为 $\alpha/2$：

$$
nc_1=\chi^2_{1-\alpha/2}(n-1)
$$

$$
nc_2=\chi^2_{\alpha/2}(n-1)
$$

这里采用的是上分位数记号：

$$
P(\chi^2(k)\ge \chi^2_\alpha(k))=\alpha
$$

所以最终拒绝域为：

$$
\frac{\sum_{i=1}^n(X_i-\bar X)^2}{v_0}
\le
\chi^2_{1-\alpha/2}(n-1)
$$

或者：

$$
\frac{\sum_{i=1}^n(X_i-\bar X)^2}{v_0}
\ge
\chi^2_{\alpha/2}(n-1)
$$

---

## 15.6 本题易错点

1. 全参数空间下要写出 $\hat\mu,\hat v$；
2. 原假设下也要写出约束 MLE；
3. 要分别写出全空间似然最大值和原假设下似然最大值；
4. 要推导似然比；
5. 要说明函数 $g(t)=te^{1-t}$ 先增后减；
6. 要写出检验统计量：

$$
W=\frac{\sum(X_i-\bar X)^2}{v_0}
$$

7. 要写出：

$$
W\sim\chi^2(n-1)
$$

8. 要明确使用上分位数还是下分位数；
9. 最终拒绝域是两侧，不是单侧。

---

# 二、Lecture 12：充分统计量的定义与性质

---

# 16. MVUE：最小方差无偏估计量

第 12 讲一开始定义了 MVUE。

MVUE 是 minimum variance unbiased estimator，中文叫：

> 最小方差无偏估计量。

设：

$$
Y=u(X_1,\dots,X_n)
$$

是 $\theta$ 的无偏估计量。

如果对于固定的样本量 $n$，它的方差小于等于所有其他无偏估计量的方差，则称它是：

$$
\theta
$$

的 MVUE。

也就是说，MVUE 满足两点：

1. 无偏：

$$
E(Y)=\theta
$$

2. 在所有无偏估计量中方差最小。

---

## 16.1 有效估计量和 MVUE 的关系

Lecture 12 特别强调：

> 有效估计量一定是 MVUE，但 MVUE 不一定是有效估计量。

原因是：

- 有效估计量要求达到 Rao-Cramer 下界；
- 但有些情况下 Rao-Cramer 下界达不到；
- 即使达不到 RCB，也可能存在所有无偏估计中方差最小的估计量。

所以：

$$
\text{有效估计量}
\Rightarrow
\text{MVUE}
$$

但：

$$
\text{MVUE}
\not\Rightarrow
\text{有效估计量}
$$

---

# 17. 数据简化与充分统计量的思想

原始样本是：

$$
X_1,\dots,X_n
$$

它包含全部样本信息。

但有时我们不需要保留完整样本，只需要保留某个统计量：

$$
Y_1=u_1(X_1,\dots,X_n)
$$

例如 Bernoulli 分布中，样本是 0 和 1 的序列：

$$
X_1,\dots,X_n
$$

如果只关心成功概率 $\theta$，那么具体哪一次成功并不重要，重要的是成功总次数：

$$
T=\sum_{i=1}^nX_i
$$

比如：

$$
(1,0,1,1,0)
$$

和：

$$
(0,1,1,0,1)
$$

都有：

$$
T=3
$$

它们对于估计 $\theta$ 的意义相同。

这就是数据简化。

充分统计量的核心想法是：

> 如果一个统计量包含了样本中关于参数 $\theta$ 的全部信息，那么就可以用它代替原始样本。

---

# 18. 充分统计量的直观定义

统计量：

$$
Y_1=u_1(X_1,\dots,X_n)
$$

如果在给定 $Y_1$ 的值之后，原始样本的条件分布不再依赖于参数 $\theta$，那么 $Y_1$ 就是充分统计量。

形式上：

$$
(X_1,\dots,X_n)\mid Y_1
$$

的分布与 $\theta$ 无关。

直观解释：

> 一旦知道了 $Y_1$，原始样本中剩下的信息就不再包含任何关于 $\theta$ 的内容。

---

# 19. Bernoulli 分布中的充分统计量

设：

$$
X_1,\dots,X_n\sim Bernoulli(\theta)
$$

概率质量函数：

$$
f(x;\theta)=\theta^x(1-\theta)^{1-x},\qquad x=0,1
$$

令：

$$
Y_1=\sum_{i=1}^nX_i
$$

则：

$$
Y_1\sim Bin(n,\theta)
$$

其概率质量函数为：

$$
P(Y_1=y)
=
\binom ny\theta^y(1-\theta)^{n-y}
$$

---

## 19.1 条件分布计算

给定：

$$
Y_1=y_1
$$

考虑：

$$
P(X_1=x_1,\dots,X_n=x_n\mid Y_1=y_1)
$$

若：

$$
y_1=\sum_{i=1}^n x_i
$$

则：

$$
P(X_1=x_1,\dots,X_n=x_n\mid Y_1=y_1)
=
\frac{
\theta^{\sum x_i}(1-\theta)^{n-\sum x_i}
}{
\binom n{y_1}\theta^{y_1}(1-\theta)^{n-y_1}
}
$$

因为：

$$
y_1=\sum x_i
$$

所以：

$$
=
\frac1{\binom n{y_1}}
$$

与 $\theta$ 无关。

若：

$$
y_1\ne \sum x_i
$$

则条件概率为 0，也与 $\theta$ 无关。

所以：

$$
Y_1=\sum_{i=1}^nX_i
$$

是 $\theta$ 的充分统计量。

---

# 20. 充分统计量的正式定义

设：

$$
Y_1=u_1(X_1,\dots,X_n)
$$

是统计量。

若：

$$
Y_1
$$

的 p.d.f. 或 p.m.f. 为：

$$
f_{Y_1}(y;\theta)
$$

如果：

$$
\frac{
f(x_1;\theta)\cdots f(x_n;\theta)
}{
f_{Y_1}\{u_1(x_1,\dots,x_n);\theta\}
}
=
H(x_1,\dots,x_n)
$$

其中：

$$
H(x_1,\dots,x_n)
$$

不依赖于 $\theta$，则称：

$$
Y_1
$$

为 $\theta$ 的充分统计量。

这个定义本质上就是：

> 原始样本在给定充分统计量后的条件分布不依赖参数。

---

# 21. 例子：Gamma 分布的充分统计量

设：

$$
X_1,\dots,X_n\sim \Gamma(2,\theta)
$$

密度为：

$$
f(x;\theta)
=
\frac1{\Gamma(2)\theta^2}xe^{-x/\theta},\qquad x>0
$$

令：

$$
Y_1=\sum_{i=1}^nX_i
$$

由于 Gamma 分布可加性：

$$
Y_1\sim \Gamma(2n,\theta)
$$

其密度为：

$$
f_{Y_1}(y;\theta)
=
\frac1{\Gamma(2n)\theta^{2n}}
y^{2n-1}e^{-y/\theta}
$$

计算比值：

$$
\frac{
\prod_{i=1}^n f(x_i;\theta)
}{
f_{Y_1}(\sum x_i;\theta)
}
$$

其中 $\theta^{2n}$ 和 $e^{-\sum x_i/\theta}$ 会完全抵消，剩下只含 $x_i$ 的表达式：

$$
\frac{\Gamma(2n)}{\Gamma(2)^n}
\cdot
\frac{x_1x_2\cdots x_n}{(\sum_{i=1}^n x_i)^{2n-1}}
$$

它不依赖于 $\theta$。

所以：

$$
Y_1=\sum_{i=1}^nX_i
$$

是 $\theta$ 的充分统计量。

---

# 22. 例子：平移指数分布中最小值是充分统计量

设：

$$
f(x;\theta)=e^{-(x-\theta)},\qquad x>\theta
$$

也可以写作：

$$
f(x;\theta)=e^{-(x-\theta)}I\{x\in(\theta,+\infty)\}
$$

令：

$$
Y_1=\min_{1\le i\le n}X_i
$$

样本联合密度为：

$$
\prod_{i=1}^n e^{-(x_i-\theta)}I\{x_i>\theta\}
$$

即：

$$
e^{-\sum x_i+n\theta}I\{\min x_i>\theta\}
$$

参数 $\theta$ 出现在：

$$
e^{n\theta}I\{\min x_i>\theta\}
$$

中，只依赖于：

$$
\min x_i
$$

所以：

$$
Y_1=\min X_i
$$

是充分统计量。

这个例子说明：

> 如果参数出现在支持集边界里，充分统计量往往是最大值或最小值。

---

# 23. Neyman 分解定理

用条件分布定义充分统计量有时很麻烦。

Neyman 分解定理给出一个更常用的判定方法。

---

## 23.1 定理内容

设样本联合密度或联合概率为：

$$
f(x_1;\theta)\cdots f(x_n;\theta)
$$

统计量：

$$
Y_1=u_1(X_1,\dots,X_n)
$$

是 $\theta$ 的充分统计量，当且仅当可以找到两个非负函数：

$$
k_1
$$

和：

$$
k_2
$$

使得：

$$
f(x_1;\theta)\cdots f(x_n;\theta)
=
k_1\{u_1(x_1,\dots,x_n);\theta\}
\cdot
k_2(x_1,\dots,x_n)
$$

其中：

$$
k_2(x_1,\dots,x_n)
$$

不依赖于 $\theta$。

---

## 23.2 直观理解

Neyman 分解定理的意思是：

> 如果联合密度中所有与 $\theta$ 有关的部分，都可以只通过统计量 $T$ 表达，那么 $T$ 是充分统计量。

做题时常用一句话：

> 由 Neyman 分解定理，$T$ 是 $\theta$ 的充分统计量。

---

# 24. Neyman 分解定理做题模板

给定：

$$
f(x;\theta)
$$

要求找充分统计量。

标准步骤：

1. 写样本联合密度或联合概率：

$$
\prod_{i=1}^n f(x_i;\theta)
$$

2. 把其中含 $\theta$ 的部分整理出来；
3. 看含 $\theta$ 的部分依赖样本的哪些函数；
4. 这些函数构成充分统计量；
5. 写：

$$
\prod f(x_i;\theta)
=
k_1(T;\theta)k_2(x_1,\dots,x_n)
$$

6. 由 Neyman 分解定理，$T$ 是充分统计量。

---

# 25. 例子：正态分布 $N(\theta,\sigma_0^2)$，$\sigma_0$ 已知

设：

$$
X_1,\dots,X_n\sim N(\theta,\sigma_0^2)
$$

其中：

$$
\sigma_0^2
$$

已知，$\theta$ 未知。

联合密度为：

$$
\prod_{i=1}^n
\frac1{\sigma_0\sqrt{2\pi}}
\exp\left\{
-\frac{(x_i-\theta)^2}{2\sigma_0^2}
\right\}
$$

注意恒等式：

$$
\sum_{i=1}^n(x_i-\theta)^2
=
\sum_{i=1}^n(x_i-\bar x)^2
+
n(\bar x-\theta)^2
$$

所以联合密度可以写成：

$$
\left(\frac1{\sigma_0\sqrt{2\pi}}\right)^n
\exp\left\{
-\frac{n(\bar x-\theta)^2}{2\sigma_0^2}
\right\}
\exp\left\{
-\frac1{2\sigma_0^2}\sum_{i=1}^n(x_i-\bar x)^2
\right\}
$$

其中含 $\theta$ 的部分只通过：

$$
\bar x
$$

体现。

因此：

$$
\bar X
$$

是 $\theta$ 的充分统计量。

等价地：

$$
\sum_{i=1}^nX_i
$$

也是充分统计量，因为：

$$
\bar X
$$

和：

$$
\sum X_i
$$

是一一对应的。

---

# 26. 例子：Beta 型分布 $f(x;\theta)=\theta x^{\theta-1}$

设：

$$
f(x;\theta)=\theta x^{\theta-1},\qquad 0<x<1
$$

联合密度为：

$$
\prod_{i=1}^n \theta x_i^{\theta-1}
=
\theta^n
\left(\prod_{i=1}^n x_i\right)^{\theta-1}
$$

也可以写成：

$$
\theta^n
\left(\prod_{i=1}^n x_i\right)^\theta
\frac1{\prod_{i=1}^n x_i}
$$

含 $\theta$ 的部分只依赖：

$$
\prod_{i=1}^n x_i
$$

所以：

$$
T=\prod_{i=1}^nX_i
$$

是充分统计量。

因为：

$$
\prod X_i
$$

和：

$$
\sum \log X_i
$$

是一一对应的，所以也可以用：

$$
T=\sum_{i=1}^n\log X_i
$$

作为充分统计量。

---

# 27. 充分统计量的性质

---

## 27.1 充分统计量不唯一

如果：

$$
T
$$

是充分统计量，且：

$$
S=g(T)
$$

其中 $g$ 是一一对应函数，则：

$$
S
$$

也是充分统计量。

例如：

$$
T=\sum X_i
$$

是充分统计量，则：

$$
\bar X=\frac1n\sum X_i
$$

也是充分统计量。

因为两者一一对应。

---

## 27.2 不要求最简

充分统计量可以不是最简的。

例如：

如果：

$$
T=\sum X_i
$$

是充分统计量，那么：

$$
(T,X_1)
$$

也一定包含 $T$，所以也能包含全部参数信息，但它显然不是最简。

第 12 讲现在只讲充分统计量，不重点讲最小充分统计量。

---

# 28. Rao-Blackwell 定理

Rao-Blackwell 定理是第 12 讲的核心之一。

它说明：

> 如果你已经有一个无偏估计量，再对充分统计量取条件期望，就可以得到一个不更差的无偏估计量。

---

## 28.1 条件期望引理

对随机变量 $X_1,X_2$，如果方差存在，则：

$$
E(X_2)=E[E(X_2|X_1)]
$$

并且：

$$
Var(X_2)\ge Var(E(X_2|X_1))
$$

也就是说，取条件期望会降低或不增加方差。

---

## 28.2 Rao-Blackwell 定理内容

设：

$$
Y_1=u_1(X_1,\dots,X_n)
$$

是 $\theta$ 的充分统计量。

设：

$$
Y_2=u_2(X_1,\dots,X_n)
$$

是 $\theta$ 的无偏估计量。

定义：

$$
\phi(Y_1)=E(Y_2|Y_1)
$$

则：

1. $\phi(Y_1)$ 是充分统计量 $Y_1$ 的函数；
2. $\phi(Y_1)$ 仍然是 $\theta$ 的无偏估计；
3. 它的方差不大于原估计量 $Y_2$：

$$
Var(\phi(Y_1))\le Var(Y_2)
$$

---

## 28.3 为什么要求 $Y_1$ 是充分统计量？

因为要保证：

$$
E(Y_2|Y_1=y_1)
$$

不依赖未知参数 $\theta$。

如果条件期望还含有未知参数，那它就不是统计量了，不能作为估计量。

例如：

若：

$$
X_1,\dots,X_n\sim N(\mu,\sigma_0^2)
$$

令：

$$
Y_1=X_1
$$

$$
Y_2=X_2
$$

则：

$$
E(X_2|X_1)=E(X_2)=\mu
$$

这里含未知参数 $\mu$，所以它不是统计量。

如果 $Y_1$ 是充分统计量，就不会出现这种问题。

---

# 29. Rao-Blackwell 定理做题模板

题目通常会给：

1. 一个充分统计量 $Y_1$；
2. 一个粗糙的无偏估计量 $Y_2$；
3. 要求求：

$$
E(Y_2|Y_1)
$$

标准步骤：

1. 先验证或引用 $Y_1$ 是充分统计量；
2. 验证 $Y_2$ 是无偏估计；
3. 写：

$$
\phi(Y_1)=E(Y_2|Y_1)
$$

4. 计算条件期望；
5. 最终答案必须写成统计量：

$$
\phi(Y_1)
$$

而不是具体值：

$$
\phi(y)
$$

6. 说明由 Rao-Blackwell 定理，它是无偏估计，且方差不超过原估计量。

---

# 30. 例子：均匀分布 $U(0,\theta)$ 的 Rao-Blackwell 改进

设：

$$
X_1,\dots,X_n\sim U(0,\theta)
$$

密度：

$$
f(x;\theta)=\frac1\theta I\{0<x<\theta\}
$$

联合密度：

$$
L(\theta)
=
\theta^{-n}I\{0<X_i<\theta,\ i=1,\dots,n\}
$$

等价于：

$$
L(\theta)
=
\theta^{-n}I\{X_{(n)}<\theta\}
$$

所以：

$$
Y_1=X_{(n)}=\max X_i
$$

是充分统计量。

---

## 30.1 一个粗糙的无偏估计

因为：

$$
E(X_1)=\frac\theta2
$$

所以：

$$
Y_2=2X_1
$$

是 $\theta$ 的无偏估计。

---

## 30.2 Rao-Blackwell 改进

计算：

$$
\phi(Y_1)=E(2X_1|Y_1)
$$

给定最大值：

$$
Y_1=y
$$

时，$X_1$ 有：

$$
\frac1n
$$

的概率就是最大值 $y$。

如果 $X_1$ 不是最大值，则它在 $(0,y)$ 上相当于均匀分布，其期望为：

$$
\frac y2
$$

所以：

$$
E(X_1|Y_1=y)
=
\frac1n y
+
\left(1-\frac1n\right)\frac y2
$$

因此：

$$
E(2X_1|Y_1=y)
=
2\left[
\frac1n y
+
\left(1-\frac1n\right)\frac y2
\right]
$$

$$
=
\frac{n+1}{n}y
$$

于是：

$$
E(2X_1|Y_1)
=
\frac{n+1}{n}X_{(n)}
$$

由 Rao-Blackwell 定理：

$$
\frac{n+1}{n}X_{(n)}
$$

是 $\theta$ 的无偏估计，且方差不超过 $2X_1$。

---

# 31. MLE 是充分统计量的函数

Lecture 12 还讲了一个定理：

如果：

1. 参数 $\theta$ 的充分统计量：

$$
Y_1=u_1(X_1,\dots,X_n)
$$

存在；

2. $\theta$ 的 MLE：

$$
\hat\theta
$$

存在且唯一；

那么：

$$
\hat\theta
$$

一定是：

$$
Y_1
$$

的函数。

---

## 31.1 直观理解

如果 $Y_1$ 已经包含关于 $\theta$ 的全部信息，而 MLE 又是从样本中提取关于 $\theta$ 的估计，那么 MLE 不应该依赖 $Y_1$ 之外的信息。

因此：

$$
\hat\theta=g(Y_1)
$$

---

## 31.2 例子：指数分布 $Exp(\theta)$，速率参数

设：

$$
X_1,\dots,X_n\sim Exp(\theta)
$$

密度：

$$
f(x;\theta)=\theta e^{-\theta x},\qquad x>0
$$

似然函数为：

$$
L(\theta)=\theta^n e^{-\theta\sum X_i}
$$

所以：

$$
Y_1=\sum_{i=1}^nX_i
$$

是充分统计量。

MLE 为：

$$
\hat\theta=\frac1{\bar X}
=
\frac n{\sum X_i}
$$

它确实是：

$$
Y_1=\sum X_i
$$

的函数。

---

## 31.3 修正有偏 MLE 得到无偏估计

在速率参数形式下：

$$
Y_1=\sum X_i\sim \Gamma(n,1/\theta)
$$

这里按照讲义的尺度参数形式，尺度是：

$$
1/\theta
$$

MLE：

$$
\hat\theta=\frac n{Y_1}
$$

可以计算得到：

$$
E(\hat\theta)
=
\frac{n}{n-1}\theta
$$

因此：

$$
\frac{n-1}{n}\hat\theta
=
\frac{n-1}{Y_1}
$$

是 $\theta$ 的无偏估计。

即：

$$
\hat\theta_{unbiased}
=
\frac{n-1}{\sum_{i=1}^nX_i}
$$

---

## 31.4 例子：指数分布 $Exp(1/\theta)$，尺度参数

如果密度是：

$$
f(x;\theta)=\frac1\theta e^{-x/\theta},\qquad x>0
$$

则：

$$
Y_1=\sum X_i
$$

仍然是充分统计量。

MLE 为：

$$
\hat\theta=\bar X=\frac{Y_1}{n}
$$

由于：

$$
E(\bar X)=\theta
$$

所以它本身就是无偏估计。

前面 HW6 Problem 6 就使用了这一参数形式。

---
# 样本联合密度/联合概率函数 与 似然函数的区别和关系

## 1. 一句话区分

设样本观测值是：

$$
x_1,\dots,x_n
$$

总体参数是：

$$
\theta
$$

那么：

- **样本联合密度/联合概率函数**：

$$
f(x_1,\dots,x_n;\theta)
$$

是把 $\theta$ 看成固定的，把 $x_1,\dots,x_n$ 看成变量。

它回答的是：

> 在参数为 $\theta$ 的总体下，样本取到 $x_1,\dots,x_n$ 的概率或密度是多少？

- **似然函数**：

$$
L(\theta)=L(\theta;x_1,\dots,x_n)
$$

是把已经观测到的样本 $x_1,\dots,x_n$ 固定住，把 $\theta$ 看成变量。

它回答的是：

> 哪个 $\theta$ 让当前这组样本最“合理”、最“可能出现”？

所以二者的核心区别是：

$$
f(x_1,\dots,x_n;\theta)
$$

主要看作关于样本的函数；

$$
L(\theta)
$$

主要看作关于参数的函数。

---

# 2. 它们的数学表达式通常一样

如果：

$$
X_1,\dots,X_n
$$

是来自总体：

$$
f(x;\theta)
$$

的独立同分布样本，则样本联合密度或联合概率函数为：

$$
f(x_1,\dots,x_n;\theta)
=
\prod_{i=1}^n f(x_i;\theta)
$$

而似然函数定义为：

$$
L(\theta)
=
L(\theta;x_1,\dots,x_n)
=
\prod_{i=1}^n f(x_i;\theta)
$$

所以形式上：

$$
L(\theta)=f(x_1,\dots,x_n;\theta)
$$

但是理解上不同：

| 对象 | 固定什么 | 变量是什么 | 用途 |
|---|---|---|---|
| 联合密度/联合概率函数 | 固定 $\theta$ | $x_1,\dots,x_n$ | 描述样本分布 |
| 似然函数 | 固定观测样本 $x_1,\dots,x_n$ | $\theta$ | 估计参数、做 LRT |

---

# 3. 举例：Bernoulli 分布

设：

$$
X_1,\dots,X_n\sim Bernoulli(\theta)
$$

单个样本概率函数为：

$$
P(X_i=x_i)=\theta^{x_i}(1-\theta)^{1-x_i}
$$

其中：

$$
x_i=0\text{ 或 }1
$$

样本联合概率函数为：

$$
f(x_1,\dots,x_n;\theta)
=
\prod_{i=1}^n\theta^{x_i}(1-\theta)^{1-x_i}
$$

整理得：

$$
f(x_1,\dots,x_n;\theta)
=
\theta^{\sum x_i}(1-\theta)^{n-\sum x_i}
$$

如果现在样本已经观测到，例如：

$$
x_1,\dots,x_n
$$

已经固定，那么似然函数就是：

$$
L(\theta)
=
\theta^{\sum x_i}(1-\theta)^{n-\sum x_i}
$$

注意：

作为联合概率函数时，我们认为：

$$
\theta
$$

是固定的，比如 $\theta=0.6$，然后看不同样本序列出现的概率。

作为似然函数时，我们认为：

$$
x_1,\dots,x_n
$$

已经固定，然后看不同 $\theta$ 下这组数据的“支持程度”。

---

# 4. 似然函数不是概率函数

这是最容易混淆的点。

虽然：

$$
L(\theta)
$$

形式上来自概率或密度函数，但它本身不是关于 $\theta$ 的概率分布。

也就是说：

$$
L(\theta)
$$

不表示：

> 参数 $\theta$ 取某个值的概率。

它表示的是：

> 在参数为 $\theta$ 时，当前样本出现的可能性大小。

比如 Bernoulli 中：

$$
L(\theta)=\theta^{\sum x_i}(1-\theta)^{n-\sum x_i}
$$

它不需要满足：

$$
\int_0^1 L(\theta)d\theta=1
$$

也不需要满足：

$$
\sum_\theta L(\theta)=1
$$

所以不能说：

> $L(0.7)$ 是 $\theta=0.7$ 的概率。

只能说：

> 相比其他参数值，$\theta=0.7$ 对这组样本的解释能力是多少。

---

# 5. 连续型情形中，联合密度也不是概率

如果总体是连续型分布，例如：

$$
X_i\sim N(\mu,\sigma^2)
$$

则：

$$
f(x_1,\dots,x_n;\mu,\sigma^2)
$$

是联合密度，不是样本恰好等于某一点的概率。

因为连续型变量中：

$$
P(X_1=x_1,\dots,X_n=x_n)=0
$$

联合密度表示的是在样本点附近的相对密集程度。

但做最大似然估计时，仍然可以用联合密度作为似然函数：

$$
L(\mu,\sigma^2)=f(x_1,\dots,x_n;\mu,\sigma^2)
$$

然后最大化它。

---

# 6. 在 MLE 中，二者怎么用？

求极大似然估计时，通常步骤是：

## 第一步：写样本联合函数

如果独立同分布：

$$
f(x_1,\dots,x_n;\theta)
=
\prod_{i=1}^n f(x_i;\theta)
$$

## 第二步：把它看成关于 $\theta$ 的函数

也就是写：

$$
L(\theta)
=
\prod_{i=1}^n f(x_i;\theta)
$$

## 第三步：取对数

$$
\ell(\theta)=\log L(\theta)
$$

## 第四步：最大化

求：

$$
\hat\theta=\arg\max_\theta L(\theta)
$$

或等价地：

$$
\hat\theta=\arg\max_\theta \ell(\theta)
$$

所以：

> 样本联合函数是似然函数的来源；似然函数是把样本联合函数换一个视角，用来估计参数。

---

# 7. 在充分统计量里，为什么写联合函数？

在 Neyman 分解定理中，我们通常写：

$$
f(x_1,\dots,x_n;\theta)
=
k_1(T(x);\theta)k_2(x_1,\dots,x_n)
$$

这里用的是样本联合密度或联合概率函数。

原因是充分统计量研究的是：

> 原始样本中关于参数的信息能不能被统计量 $T$ 完整概括。

所以必须从整个样本的联合分布出发。

如果联合函数中所有与 $\theta$ 有关的部分都只通过：

$$
T(x_1,\dots,x_n)
$$

体现，那么 $T$ 就是充分统计量。

例如 Bernoulli：

$$
f(x_1,\dots,x_n;\theta)
=
\theta^{\sum x_i}(1-\theta)^{n-\sum x_i}
$$

所有关于 $\theta$ 的部分都只通过：

$$
\sum x_i
$$

体现，所以：

$$
T=\sum_{i=1}^nX_i
$$

是充分统计量。

---

# 8. 在似然估计里，为什么可以忽略不含 $\theta$ 的部分？

假设联合函数可以分解为：

$$
f(x_1,\dots,x_n;\theta)
=
k_1(T(x);\theta)k_2(x)
$$

其中：

$$
k_2(x)
$$

不含 $\theta$。

作为似然函数时：

$$
L(\theta)
=
k_1(T(x);\theta)k_2(x)
$$

由于样本已经固定，所以：

$$
k_2(x)
$$

只是一个常数。

最大化 $L(\theta)$ 时，不含 $\theta$ 的常数不会影响最大点。

所以：

$$
L(\theta)\propto k_1(T(x);\theta)
$$

这就是为什么求 MLE 时常说：

> 可以忽略与参数无关的项。

但是注意：

在写联合密度或概率函数时，不能随便丢项；  
在最大化似然函数时，才可以丢掉不含参数的因子。

---

# 9. 举例：正态分布

设：

$$
X_1,\dots,X_n\sim N(\mu,\sigma_0^2)
$$

其中：

$$
\sigma_0^2
$$

已知，$\mu$ 未知。

单个密度：

$$
f(x_i;\mu)
=
\frac1{\sqrt{2\pi}\sigma_0}
\exp\left\{
-\frac{(x_i-\mu)^2}{2\sigma_0^2}
\right\}
$$

样本联合密度为：

$$
f(x_1,\dots,x_n;\mu)
=
\prod_{i=1}^n
\frac1{\sqrt{2\pi}\sigma_0}
\exp\left\{
-\frac{(x_i-\mu)^2}{2\sigma_0^2}
\right\}
$$

整理：

$$
f(x_1,\dots,x_n;\mu)
=
\left(\frac1{\sqrt{2\pi}\sigma_0}\right)^n
\exp\left\{
-\frac1{2\sigma_0^2}
\sum_{i=1}^n(x_i-\mu)^2
\right\}
$$

如果作为似然函数：

$$
L(\mu)
=
\left(\frac1{\sqrt{2\pi}\sigma_0}\right)^n
\exp\left\{
-\frac1{2\sigma_0^2}
\sum_{i=1}^n(x_i-\mu)^2
\right\}
$$

由于：

$$
\left(\frac1{\sqrt{2\pi}\sigma_0}\right)^n
$$

不含 $\mu$，最大化时可以忽略。

所以最大化：

$$
L(\mu)
$$

等价于最小化：

$$
\sum_{i=1}^n(x_i-\mu)^2
$$

得到：

$$
\hat\mu=\bar x
$$

---

# 10. 最准确的关系表述

严格地说：

$$
f(x_1,\dots,x_n;\theta)
$$

是联合密度或联合概率函数。

当观测值：

$$
x_1,\dots,x_n
$$

固定后，把同一个表达式看作 $\theta$ 的函数，就得到似然函数：

$$
L(\theta;x_1,\dots,x_n)
=
f(x_1,\dots,x_n;\theta)
$$

因此：

$$
\boxed{
L(\theta;x)=f(x;\theta)\quad\text{形式相同，视角不同}
}
$$

其中：

- 联合函数：固定 $\theta$，研究 $X$ 的分布；
- 似然函数：固定 $x$，研究 $\theta$ 的相对支持度。

---

# 11. 考试中怎么写最稳？

如果是求 MLE，可以写：

$$
L(\theta)
=
f(x_1,\dots,x_n;\theta)
=
\prod_{i=1}^n f(x_i;\theta)
$$

然后：

$$
\ell(\theta)=\log L(\theta)
$$

再求导。

如果是证明充分统计量，可以写：

$$
f(x_1,\dots,x_n;\theta)
=
\prod_{i=1}^n f(x_i;\theta)
=
k_1(T;\theta)k_2(x)
$$

由 Neyman 分解定理：

$$
T
$$

是充分统计量。

---

# 12. 最后用一句话记

联合密度/联合概率函数和似然函数的关系是：

> 同一个公式，固定参数看样本，就是联合分布；固定样本看参数，就是似然函数。

也可以记成：

$$
\text{联合函数：} f(x;\theta)\text{ 是 }x\text{ 的函数}
$$

$$
\text{似然函数：} L(\theta;x)\text{ 是 }\theta\text{ 的函数}
$$
# 32. HW6 Problem 4：充分统计量判定题

HW6 Problem 4 给了六个分布，要求分别找充分统计量。

这种题最重要的是写联合密度，然后用 Neyman 分解定理。

---

## 32.1 离散均匀分布：$P(X=k)=1/\theta,\ k=1,\dots,\theta$

给定：

$$
P(X=k)=\frac1\theta,\qquad k=1,2,\dots,\theta
$$

其中：

$$
\theta\in N^+
$$

样本联合概率为：

$$
f(x_1,\dots,x_n;\theta)
=
\theta^{-n}I\{1\le x_i\le\theta,\ i=1,\dots,n\}
$$

等价于：

$$
f(x_1,\dots,x_n;\theta)
=
\theta^{-n}I\{x_{(1)}\ge1\}I\{x_{(n)}\le\theta\}
$$

其中：

$$
x_{(n)}=\max\{x_1,\dots,x_n\}
$$

含 $\theta$ 的部分通过：

$$
x_{(n)}
$$

体现。

所以充分统计量为：

$$
T=X_{(n)}=\max\{X_1,\dots,X_n\}
$$

---

## 32.2 负二项型分布

给定：

$$
P(X=x)
=
\binom{x+r-1}{r-1}\theta^r(1-\theta)^x,
\qquad x=0,1,2,\dots
$$

其中：

$$
r>0
$$

已知，$0<\theta<1$ 未知。

样本联合概率为：

$$
\prod_{i=1}^n
\binom{x_i+r-1}{r-1}
\theta^r(1-\theta)^{x_i}
$$

整理：

$$
\left[
\prod_{i=1}^n
\binom{x_i+r-1}{r-1}
\right]
\theta^{nr}
(1-\theta)^{\sum x_i}
$$

含 $\theta$ 的部分只依赖：

$$
\sum x_i
$$

所以充分统计量为：

$$
T=\sum_{i=1}^nX_i
$$

---

## 32.3 对数正态分布中 $\mu$ 已知，$\sigma^2$ 未知

给定：

$$
f(x;\mu,\sigma^2)
=
\frac1{\sqrt{2\pi}\sigma x}
\exp\left\{
-\frac{(\ln x-\mu)^2}{2\sigma^2}
\right\},
\qquad x>0
$$

其中 $\mu$ 已知，$\sigma^2$ 未知。

令：

$$
\theta=\sigma^2
$$

联合密度中含 $\theta$ 的部分为：

$$
\theta^{-n/2}
\exp\left\{
-\frac1{2\theta}
\sum_{i=1}^n(\ln x_i-\mu)^2
\right\}
$$

所以充分统计量为：

$$
T=\sum_{i=1}^n(\ln X_i-\mu)^2
$$

如果展开：

$$
(\ln X_i-\mu)^2
=
(\ln X_i)^2-2\mu\ln X_i+\mu^2
$$

由于 $\mu$ 已知，等价形式也可以写为：

$$
T=\sum_{i=1}^n[(\ln X_i)^2-2\mu\ln X_i]
$$

也可以用二维向量：

$$
\left(
\sum_{i=1}^n(\ln X_i)^2,\ 
\sum_{i=1}^n\ln X_i
\right)
$$

但若 $\mu$ 已知，最简洁的是：

$$
\sum_{i=1}^n(\ln X_i-\mu)^2
$$

---

## 32.4 拉普拉斯型分布

给定：

$$
f(x;\theta)=\frac1{2\theta}\exp\left\{-\frac{|x|}{\theta}\right\},\qquad x\in R
$$

其中：

$$
\theta>0
$$

样本联合密度为：

$$
(2\theta)^{-n}
\exp\left\{
-\frac1\theta\sum_{i=1}^n|x_i|
\right\}
$$

含 $\theta$ 的部分只依赖：

$$
\sum |x_i|
$$

所以充分统计量为：

$$
T=\sum_{i=1}^n|X_i|
$$

---

## 32.5 Pareto 型分布

给定：

$$
f(x;\theta)=\frac{\theta}{x^{\theta+1}},\qquad x>1
$$

其中：

$$
\theta>0
$$

样本联合密度为：

$$
\prod_{i=1}^n
\frac{\theta}{x_i^{\theta+1}}
=
\theta^n
\left(\prod_{i=1}^n x_i\right)^{-(\theta+1)}
$$

写成指数形式：

$$
\theta^n
\exp\left\{
-(\theta+1)\sum_{i=1}^n\ln x_i
\right\}
$$

含 $\theta$ 的部分只依赖：

$$
\sum_{i=1}^n\ln X_i
$$

所以充分统计量为：

$$
T=\sum_{i=1}^n\ln X_i
$$

等价地：

$$
T=\prod_{i=1}^nX_i
$$

也可以，因为乘积和对数和一一对应。

---

## 32.6 Rayleigh 分布

给定：

$$
f(x;\theta)
=
\frac{x}{\theta^2}
\exp\left\{
-\frac{x^2}{2\theta^2}
\right\},
\qquad x>0
$$

其中：

$$
\theta>0
$$

样本联合密度为：

$$
\left(\prod_{i=1}^nx_i\right)
\theta^{-2n}
\exp\left\{
-\frac1{2\theta^2}
\sum_{i=1}^nx_i^2
\right\}
$$

含 $\theta$ 的部分只依赖：

$$
\sum x_i^2
$$

所以充分统计量为：

$$
T=\sum_{i=1}^nX_i^2
$$

---

# 33. HW6 Problem 5：平移指数分布不同参数已知时的充分统计量

给定：

$$
f(x;a,b)=
\begin{cases}
\frac1b e^{-(x-a)/b},&x>a\\
0,&x\le a
\end{cases}
$$

其中：

$$
a\in R,\quad b>0
$$

---

## 33.1 情况一：$a=a_0$ 已知，求 $b$ 的充分统计量

密度为：

$$
f(x;b)=\frac1b e^{-(x-a_0)/b},\qquad x>a_0
$$

样本联合密度为：

$$
f(x_1,\dots,x_n;b)
=
b^{-n}
\exp\left\{
-\frac1b\sum_{i=1}^n(x_i-a_0)
\right\}
I\{x_{(1)}>a_0\}
$$

其中：

$$
x_{(1)}=\min x_i
$$

由于 $a_0$ 已知，所以：

$$
I\{x_{(1)}>a_0\}
$$

不含未知参数 $b$。

含 $b$ 的部分只依赖：

$$
\sum_{i=1}^n(x_i-a_0)
$$

因此充分统计量为：

$$
T=\sum_{i=1}^n(X_i-a_0)
$$

等价地：

$$
T=\sum_{i=1}^nX_i
$$

---

## 33.2 情况二：$b=b_0$ 已知，求 $a$ 的充分统计量

密度为：

$$
f(x;a)=\frac1{b_0}e^{-(x-a)/b_0},\qquad x>a
$$

样本联合密度为：

$$
f(x_1,\dots,x_n;a)
=
b_0^{-n}
\exp\left\{
-\frac1{b_0}\sum_{i=1}^n(x_i-a)
\right\}
I\{x_{(1)}>a\}
$$

整理：

$$
=
b_0^{-n}
\exp\left\{
-\frac1{b_0}\sum_{i=1}^nx_i
\right\}
\exp\left\{
\frac{na}{b_0}
\right\}
I\{a<x_{(1)}\}
$$

含 $a$ 的部分只通过：

$$
x_{(1)}
$$

体现。

所以充分统计量为：

$$
T=X_{(1)}=\min\{X_1,\dots,X_n\}
$$

---

# 34. HW6 Problem 6：指数分布的 Rao-Blackwell 条件期望

设：

$$
X_1,\dots,X_n\sim Exp(1/\theta)
$$

密度为：

$$
f(x;\theta)=\frac1\theta e^{-x/\theta},\qquad x>0
$$

已知：

$$
Y_1=\sum_{i=1}^nX_i
$$

是充分统计量。

又给出：

$$
Y_2=X_1
$$

因为：

$$
E(X_1)=\theta
$$

所以 $X_1$ 是 $\theta$ 的无偏估计。

要求用 Rao-Blackwell 定理计算：

$$
E(Y_2|Y_1)=E(X_1|Y_1)
$$

---

## 34.1 关键对称性

由于：

$$
X_1,\dots,X_n
$$

独立同分布，给定总和：

$$
Y_1=\sum_{i=1}^nX_i=y
$$

时，每个 $X_i$ 在条件下是对称的。

所以：

$$
E(X_1|Y_1=y)
=
E(X_2|Y_1=y)
=
\cdots
=
E(X_n|Y_1=y)
$$

又因为：

$$
X_1+\cdots+X_n=Y_1
$$

在条件 $Y_1=y$ 下：

$$
E(X_1+\cdots+X_n|Y_1=y)=y
$$

因此：

$$
nE(X_1|Y_1=y)=y
$$

所以：

$$
E(X_1|Y_1=y)=\frac yn
$$

于是：

$$
E(X_1|Y_1)=\frac{Y_1}{n}
$$

也就是：

$$
E(Y_2|Y_1)=\frac1n\sum_{i=1}^nX_i=\bar X
$$

---

## 34.2 结论

由 Rao-Blackwell 定理：

$$
\bar X
$$

是 $\theta$ 的无偏估计，且：

$$
Var(\bar X)\le Var(X_1)
$$

本题易错点：

> 最终答案必须写成统计量 $\frac{Y_1}{n}$，不能只写具体值 $\frac yn$。

因为：

$$
\frac yn
$$

是给定 $Y_1=y$ 后的具体条件期望，不是随机统计量。

---

# 35. HW6 Problem 7：几何分布、负二项分布与 Rao-Blackwell

这题考查充分统计量、负二项分布推导、无偏估计和 Rao-Blackwell。

通常设：

$$
X_1,\dots,X_n
$$

来自几何分布，参数为：

$$
\theta
$$

其中 $X_i$ 表示第一个成功出现所需试验次数，取值：

$$
1,2,\dots
$$

概率质量函数为：

$$
P(X=x)=\theta(1-\theta)^{x-1},\qquad x=1,2,\dots
$$

---

## 35.1 充分统计量

样本联合概率为：

$$
\prod_{i=1}^n
\theta(1-\theta)^{x_i-1}
=
\theta^n(1-\theta)^{\sum x_i-n}
$$

含 $\theta$ 的部分只依赖：

$$
T=\sum_{i=1}^nX_i
$$

所以由 Neyman 分解定理：

$$
T=\sum_{i=1}^nX_i
$$

是充分统计量。

---

## 35.2 $T$ 的负二项分布

由于 $X_i$ 表示一次成功所需试验次数，$n$ 个 $X_i$ 相加：

$$
T=\sum_{i=1}^nX_i
$$

表示第 $n$ 次成功发生时的总试验次数。

所以：

$$
T
$$

服从负二项分布：

$$
P(T=t)
=
\binom{t-1}{n-1}
\theta^n(1-\theta)^{t-n},
\qquad t=n,n+1,\dots
$$

解释：

- 前 $t-1$ 次试验中必须有 $n-1$ 次成功；
- 第 $t$ 次试验必须成功；
- 因此概率为：

$$
\binom{t-1}{n-1}
\theta^{n-1}(1-\theta)^{t-n}\cdot\theta
$$

即：

$$
\binom{t-1}{n-1}
\theta^n(1-\theta)^{t-n}
$$

HW6 易错点强调：不能只照抄结论，要解释这个负二项分布质量函数如何得到。

---

## 35.3 估计 $\theta^{-1}$

几何分布中：

$$
E(X_i)=\frac1\theta
$$

所以：

$$
E(T)=\sum_{i=1}^nE(X_i)=\frac n\theta
$$

因此：

$$
\frac Tn
$$

是：

$$
\theta^{-1}
$$

的无偏估计。

---

## 35.4 Rao-Blackwell 改进估计 $\theta$

定义：

$$
\psi(X_1)=I\{X_1=1\}
$$

则：

$$
E[\psi(X_1)]
=
P(X_1=1)
=
\theta
$$

所以：

$$
\psi(X_1)
$$

是 $\theta$ 的无偏估计。

由 Rao-Blackwell 定理：

$$
E[\psi(X_1)|T]
$$

是 $\theta$ 的无偏估计，且方差不超过原估计。

计算：

$$
E[\psi(X_1)|T=t]
=
P(X_1=1|T=t)
$$

在给定：

$$
T=t
$$

的条件下，满足：

$$
X_i\ge1
$$

且：

$$
\sum_{i=1}^nX_i=t
$$

的所有组合等可能。

总组合数为：

$$
\binom{t-1}{n-1}
$$

若要求：

$$
X_1=1
$$

则剩下：

$$
X_2+\cdots+X_n=t-1
$$

且每个：

$$
X_i\ge1
$$

组合数为：

$$
\binom{t-2}{n-2}
$$

所以：

$$
P(X_1=1|T=t)
=
\frac{\binom{t-2}{n-2}}{\binom{t-1}{n-1}}
=
\frac{n-1}{t-1}
$$

因此：

$$
E[\psi(X_1)|T]
=
\frac{n-1}{T-1}
$$

这是 $\theta$ 的一个无偏估计量，且方差不超过：

$$
I\{X_1=1\}
$$

易错点：

> 最终要写成 $\frac{n-1}{T-1}$，不能写成 $\frac{n-1}{t-1}$ 作为最终估计量。

---

# 36. HW6 Problem 8：Bernoulli 中估计 $g(\theta)=(1-\theta)^2$

设：

$$
X_1,\dots,X_n\sim Bernoulli(\theta)
$$

目标是估计：

$$
g(\theta)=(1-\theta)^2
$$

---

## 36.1 MLE 与 MLE 不变性

MLE 为：

$$
\hat\theta=\bar X
$$

由 MLE 不变性：

$$
g(\theta)=(1-\theta)^2
$$

的 MLE 为：

$$
g(\hat\theta)=(1-\bar X)^2
$$

但注意：

> MLE 不一定无偏。

---

## 36.2 充分统计量

样本联合概率为：

$$
f(x_1,\dots,x_n;\theta)
=
\theta^{\sum x_i}(1-\theta)^{n-\sum x_i}
$$

含 $\theta$ 的部分只依赖：

$$
Y_1=\sum_{i=1}^nX_i
$$

所以：

$$
Y_1=\sum X_i
$$

是充分统计量。

---

## 36.3 构造粗糙无偏估计

令：

$$
Y_2=I\{X_1+X_2=0\}
$$

也就是：

$$
Y_2=
\begin{cases}
1,&X_1=0,X_2=0\\
0,&其他
\end{cases}
$$

因为 $X_1,X_2$ 独立：

$$
E(Y_2)
=
P(X_1=0,X_2=0)
=
(1-\theta)^2
=
g(\theta)
$$

所以 $Y_2$ 是 $g(\theta)$ 的无偏估计。

---

## 36.4 Rao-Blackwell 改进

计算：

$$
E(Y_2|Y_1=t)
=
P(X_1+X_2=0|Y_1=t)
$$

给定：

$$
Y_1=t
$$

说明 $n$ 个 Bernoulli 变量中有 $t$ 个 1 和 $n-t$ 个 0，所有排列等可能。

要求：

$$
X_1=0,\quad X_2=0
$$

即前两个位置都从 $n-t$ 个 0 中选。

概率为：

$$
\frac{\binom{n-t}{2}}{\binom n2}
$$

化简：

$$
\frac{(n-t)(n-t-1)}{n(n-1)}
$$

因此：

$$
E(Y_2|Y_1)
=
\frac{(n-Y_1)(n-Y_1-1)}{n(n-1)}
$$

最终无偏估计量为：

$$
\frac{(n-\sum_{i=1}^nX_i)(n-\sum_{i=1}^nX_i-1)}
{n(n-1)}
$$

由 Rao-Blackwell 定理，它的方差不超过原估计量：

$$
I\{X_1+X_2=0\}
$$

---

# 三、两讲重点题型总结

---

# 37. 题型一：多参数 MLE

## 题目特征

给出含多个未知参数的分布，例如：

$$
f(x;\theta_1,\theta_2)
$$

要求求 MLE。

## 做法

1. 写联合似然函数；
2. 写对数似然函数；
3. 对每个参数求偏导；
4. 解方程组；
5. 如果支持集含参数，要先写非零条件；
6. 如果有边界，要判断单调性并取边界点。

## 典型例子

Pareto 分布：

$$
\hat\theta_1=X_{(1)}
$$

$$
\hat\theta_2=
\frac n{\sum_{i=1}^n\log(X_i/X_{(1)})}
$$

正态分布：

$$
\hat\mu=\bar X
$$

$$
\hat\sigma^2=\frac1n\sum(X_i-\bar X)^2
$$

---

# 38. 题型二：计算多参数 Fisher 信息矩阵与 RCB

## 题目特征

要求：

- 计算 Fisher 信息矩阵；
- 计算 RCB；
- 判断无偏估计是否有效。

## 做法

1. 写单个样本的对数密度：

$$
\log f(X;\theta)
$$

2. 对每个参数求一阶偏导；
3. 对每对参数求二阶偏导；
4. 使用：

$$
I_{jk}=-E\left[
\frac{\partial^2}{\partial\theta_j\partial\theta_k}\log f(X;\theta)
\right]
$$

5. 写 Fisher 信息矩阵：

$$
I(\theta)
$$

6. 求逆矩阵：

$$
I^{-1}(\theta)
$$

7. 对参数 $\theta_j$：

$$
RCB_j=\frac1n\{I^{-1}(\theta)\}_{jj}
$$

## 易错点

1. 多参数情形不能直接套单参数 Fisher 信息量；
2. 要求的是矩阵；
3. 要求 RCB 时必须取逆矩阵；
4. 估计 $\sigma$ 和估计 $\sigma^2$ 是两件事；
5. 信息矩阵是单个样本的，样本量为 $n$ 时总信息是 $nI(\theta)$。

---

# 39. 题型三：多参数 LRT

## 题目特征

要求：

- 计算似然比；
- 求 LRT；
- 把拒绝域转化为已知分布的统计量；
- 或给出渐近卡方拒绝域。

## 做法

1. 写全空间 MLE：

$$
\hat\theta
$$

2. 写原假设约束下 MLE：

$$
\hat\theta_0
$$

3. 写：

$$
\Lambda=\frac{L(\hat\theta_0)}{L(\hat\theta)}
$$

4. 写：

$$
-2\log\Lambda=2[\ell(\hat\theta)-\ell(\hat\theta_0)]
$$

5. 如果能精确化简成 $t$、$\chi^2$ 或 $F$，用精确分布；
6. 如果不能，用渐近：

$$
-2\log\Lambda\approx \chi^2(q)
$$

其中 $q$ 是约束个数。

## 易错点

1. 不是所有 LRT 都只能用渐近分布；
2. HW6 Problem 3 要求精确分布，所以必须用卡方；
3. 要说明似然比函数的单调性；
4. 要明确上分位数或下分位数。

---

# 40. 题型四：找充分统计量

## 题目特征

给出一个分布，要求找 $\theta$ 的充分统计量。

## 做法

1. 写联合密度：

$$
\prod f(x_i;\theta)
$$

2. 把含 $\theta$ 的部分整理出来；
3. 看这些部分只依赖样本的什么函数；
4. 该函数就是充分统计量；
5. 写：

$$
\prod f(x_i;\theta)=k_1(T;\theta)k_2(x)
$$

6. 由 Neyman 分解定理得出结论。

## 常见对应表

| 分布形式                                       | 充分统计量                        |
| ------------------------------------------ | ---------------------------- |
| $Bernoulli(\theta)$                        | $\sum X_i$                   |
| $Poisson(\theta)$                          | $\sum X_i$                   |
| $Exp(1/\theta)$                            | $\sum X_i$                   |
| $Exp(\theta)$ 速率参数                         | $\sum X_i$                   |
| $N(\theta,\sigma_0^2)$                     | $\bar X$ 或 $\sum X_i$        |
| $U(0,\theta)$                              | $\max X_i$                   |
| $f(x;\theta)=e^{-(x-\theta)}I\{x>\theta\}$ | $\min X_i$                   |
| $f(x;\theta)=\theta x^{\theta-1}$          | $\prod X_i$ 或 $\sum\log X_i$ |
| Rayleigh                                   | $\sum X_i^2$                 |
| Laplace scale                              | $\sum X_i$                   |

---

# 41. 题型五：Rao-Blackwell 条件期望

## 题目特征

题目给：

- 充分统计量 $Y_1$；
- 一个无偏估计量 $Y_2$；
- 要求计算：

$$
E(Y_2|Y_1)
$$

## 做法

1. 写出 $Y_2$ 的无偏性；
2. 写：

$$
\phi(Y_1)=E(Y_2|Y_1)
$$

3. 通过对称性、组合计数或条件分布计算；
4. 最终答案写成 $Y_1$ 的函数；
5. 说明它仍无偏，且方差不超过原估计量。

## 常见计算技巧

### 指数样本和

若：

$$
Y_1=\sum X_i
$$

则由对称性：

$$
E(X_1|Y_1)=\frac{Y_1}{n}
$$

### Bernoulli 给定成功总数

若：

$$
Y_1=\sum X_i=t
$$

则相当于 $n$ 个位置中有 $t$ 个 1，$n-t$ 个 0，所有排列等可能。

### 几何分布给定总和

若：

$$
T=\sum X_i=t
$$

且每个 $X_i\ge1$，则需要用正整数拆分计数。

常用组合数：

$$
\{x_1+\cdots+x_n=t,\ x_i\ge1\}
=
\binom{t-1}{n-1}
$$

---

# 四、HW6 易错点总整理

---

# 42. Problem 1：Pareto MLE

易错点：

1. 没有先求概率密度函数；
2. 没有写似然函数；
3. 没有讨论 $\theta_1$ 的约束：

$$
\theta_1\le X_{(1)}
$$

4. 没有说明似然函数关于 $\theta_1$ 单调递增；
5. 对数似然函数漏项；
6. 求 $\theta_2$ 时分母写错；
7. $\hat\theta_2$ 正确形式是：

$$
\hat\theta_2
=
\frac n{\sum_{i=1}^n\log X_i-n\log X_{(1)}}
$$

---

# 43. Problem 2：正态多参数 RCB

易错点：

1. 要参考多参数估计情形；
2. 必须对 $\mu$ 和 $\sigma$ 分别求偏导；
3. 要写二阶偏导；
4. 要写 Fisher 信息矩阵；
5. 要写逆矩阵；
6. RCB 是逆矩阵对应元素除以 $n$；
7. 最终 $\sigma$ 的 RCB 是：

$$
\frac{\sigma^2}{2n}
$$

---

# 44. Problem 3：正态方差 LRT

易错点：

1. 要写全空间 MLE；
2. 要写 $H_0$ 下的 MLE；
3. 要分别写出两个最大似然函数值；
4. 要写出似然比；
5. 要讨论函数单调性；
6. 要写检验统计量：

$$
W=\frac{\sum(X_i-\bar X)^2}{v_0}
$$

7. 要说明：

$$
W\sim\chi^2(n-1)
$$

8. 要写具体拒绝域；
9. 如果没有说明上分位数还是下分位数，默认按上分位数理解。

---

# 45. Problem 4：充分统计量

易错点：

1. 每小题都要写似然函数；
2. 只写充分统计量不写因子分解过程容易扣分；
3. 第三小题对数正态分布中，充分统计量可以写：

$$
\sum_{i=1}^n(\ln X_i-\mu)^2
$$

也可以写成：

$$
\sum_{i=1}^n[(\ln X_i)^2-2\mu\ln X_i]
$$

还可以写成二维向量：

$$
\left(
\sum(\ln X_i)^2,\sum\ln X_i
\right)
$$

但要清楚 $\mu$ 是否已知。

---

# 46. Problem 5：平移指数分布充分统计量

易错点：

1. 每小题要写密度函数；
2. 要写似然函数；
3. $a$ 已知时，充分统计量是：

$$
\sum(X_i-a_0)
$$

或：

$$
\sum X_i
$$

4. $b$ 已知时，充分统计量是：

$$
X_{(1)}=\min X_i
$$

5. 不要把两种情况混淆。

---

# 47. Problem 6：Rao-Blackwell 条件期望

易错点：

1. 必须写：

$$
E(X_1|Y_1=y)
=
\frac1n
E\left(\sum_{i=1}^nX_i\mid Y_1=y\right)
=
\frac yn
$$

2. 最终估计量必须写：

$$
E(X_1|Y_1)=\frac{Y_1}{n}
$$

3. 如果最终只写：

$$
\frac yn
$$

会扣分，因为它不是统计量。

---

# 48. Problem 7：几何分布与 Rao-Blackwell

易错点：

1. 证明负二项分布时不能只照抄提示，要解释：
   - 前 $t-1$ 次有 $n-1$ 次成功；
   - 第 $t$ 次成功；
   - 因而得到概率质量函数。

2. 估计 $\theta^{-1}$ 时要用：

$$
E(X_i)=\frac1\theta
$$

3. Rao-Blackwell 最终估计量要写成：

$$
\frac{n-1}{T-1}
$$

不能写成：

$$
\frac{n-1}{t-1}
$$

作为最终答案。

---

# 49. Problem 8：Bernoulli 中估计 $(1-\theta)^2$

易错点：

1. 要先求 $\theta$ 的 MLE；
2. 再用 MLE 不变性求：

$$
(1-\hat\theta)^2
$$

3. 充分统计量是：

$$
Y_1=\sum X_i
$$

4. 粗糙无偏估计可以取：

$$
Y_2=I\{X_1+X_2=0\}
$$

5. Rao-Blackwell 条件期望要写：

$$
E(Y_2|Y_1=t)
=
P(X_1+X_2=0|Y_1=t)
$$

6. 组合概率为：

$$
\frac{\binom{n-t}{2}}{\binom n2}
=
\frac{(n-t)(n-t-1)}{n(n-1)}
$$

7. 最终估计量要写成：

$$
\frac{(n-Y_1)(n-Y_1-1)}{n(n-1)}
$$

不能写成只含具体值 $t$ 的形式。

---

# 五、考前速记版

---

# 50. 多参数估计速记

参数向量：

$$
\theta=(\theta_1,\dots,\theta_p)^T
$$

似然函数：

$$
L(\theta)=\prod_{i=1}^nf(X_i;\theta)
$$

对数似然：

$$
\ell(\theta)=\sum_{i=1}^n\log f(X_i;\theta)
$$

MLE 方程：

$$
\frac{\partial\ell}{\partial\theta_j}=0,\qquad j=1,\dots,p
$$

Fisher 信息矩阵：

$$
I(\theta)=Cov\{\nabla\log f(X;\theta)\}
$$

元素：

$$
I_{jk}(\theta)
=
-E\left[
\frac{\partial^2}{\partial\theta_j\partial\theta_k}
\log f(X;\theta)
\right]
$$

多参数 RCB：

$$
Var(Y_j)\ge
\frac1n\{I^{-1}(\theta)\}_{jj}
$$

有效性：

$$
eff(Y_j)
=
\frac{\{I^{-1}(\theta)\}_{jj}}{nVar(Y_j)}
$$

---

# 51. 多参数检验速记

点假设：

$$
H_0:\theta=\theta_0
$$

LRT：

$$
\chi_L^2=2[\ell(\hat\theta)-\ell(\theta_0)]
\sim \chi^2(p)
$$

Wald：

$$
\chi_W^2
=
(\hat\theta-\theta_0)^T
\{nI(\hat\theta)\}
(\hat\theta-\theta_0)
\sim\chi^2(p)
$$

Score：

$$
\chi_R^2
=
\{\nabla\ell(\theta_0)\}^T
\{nI(\hat\theta_0)\}^{-1}
\{\nabla\ell(\theta_0)\}
\sim\chi^2(p)
$$

约束假设：

$$
H_0:\theta\in\omega
$$

若有 $q$ 个约束，则：

$$
\chi_L^2
=
2[\ell(\hat\theta)-\ell(\hat\theta_0)]
\sim\chi^2(q)
$$

---

# 52. 充分统计量速记

充分统计量直观定义：

> 给定 $T$ 后，原始样本的条件分布不依赖 $\theta$。

Neyman 分解定理：

$$
\prod_{i=1}^nf(x_i;\theta)
=
k_1(T(x);\theta)k_2(x)
$$

其中：

$$
k_2(x)
$$

不含 $\theta$。

则：

$$
T
$$

是充分统计量。

---

# 53. Rao-Blackwell 速记

如果：

- $T$ 是充分统计量；
- $Y$ 是 $\theta$ 的无偏估计；

则：

$$
E(Y|T)
$$

也是 $\theta$ 的无偏估计，且：

$$
Var(E(Y|T))\le Var(Y)
$$

做题时最终答案必须写成：

$$
T
$$

的函数，而不是具体值。

---

# 54. 常见充分统计量表

| 分布                              | 参数             | 充分统计量                        |
| ------------------------------- | -------------- | ---------------------------- |
| Bernoulli                       | $\theta$       | $\sum X_i$                   |
| Binomial 类                      | $\theta$       | $\sum X_i$                   |
| Poisson                         | $\theta$       | $\sum X_i$                   |
| Exponential scale               | $\theta$       | $\sum X_i$                   |
| Exponential rate                | $\theta$       | $\sum X_i$                   |
| Normal mean, variance known     | $\theta$       | $\bar X$ 或 $\sum X_i$        |
| Normal variance, mean known     | $\sigma^2$     | $\sum(X_i-\mu)^2$            |
| Uniform $(0,\theta)$            | $\theta$       | $\max X_i$                   |
| Shifted exponential             | shift $\theta$ | $\min X_i$                   |
| Beta-type $\theta x^{\theta-1}$ | $\theta$       | $\prod X_i$ 或 $\sum\log X_i$ |
| Laplace scale                   | $\theta$       | $\sum X_i$                   |
| Rayleigh                        | $\theta$       | $\sum X_i^2$                 |

---

# 55. 最后检查清单

每道题写完后检查：

1. 是否写了似然函数？
2. 多参数 MLE 是否对每个参数求偏导？
3. 参数在支持集里时，是否写了非零条件？
4. Fisher 信息量是否写成矩阵？
5. RCB 是否取了逆矩阵对应对角元？
6. 估计的是 $\sigma$ 还是 $\sigma^2$？
7. LRT 是否分别写了全空间和约束空间的 MLE？
8. LRT 拒绝域是否说明了单调性？
9. 充分统计量是否通过因子分解定理说明？
10. Rao-Blackwell 最终答案是否写成统计量，而不是具体值？
11. 条件期望计算是否写了过程？
12. 最终结论是否说明“无偏”和“方差不超过原估计量”？