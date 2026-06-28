# 数理统计第四讲、第五讲完整复习笔记  
## 极大似然估计、估计量评价准则、置信区间、枢轴量法

---

# 0. 这两讲在整个数理统计中的位置

前三讲已经解决了两个基础问题：

1. 样本是什么、统计量是什么；
2. 在正态总体下，常见统计量 $\bar X,S^2$ 以及由它们构造出的量服从什么分布。

第四讲和第五讲开始进入真正的统计推断。

第四讲讲的是**点估计**：

> 用一个统计量去估计未知参数。

比如：

$$
\hat\theta=\bar X
$$

就是用样本均值估计总体均值。

第四讲主要回答：

1. 怎么系统地构造估计量？
2. 什么是极大似然估计？
3. 一个估计量好不好，应该怎么评价？
4. 无偏性、有效性、均方误差、相合性分别是什么意思？

第五讲讲的是**区间估计**：

> 不只给一个点估计，而是给一个随机区间，并说明这个区间以多大概率覆盖真实参数。

比如：

$$
\left(\bar X-z_{\alpha/2}\frac{\sigma}{\sqrt n},
\bar X+z_{\alpha/2}\frac{\sigma}{\sqrt n}\right)
$$

是 $\mu$ 的一个置信区间。

第五讲主要回答：

1. 什么是置信区间？
2. 置信水平应该怎么理解？
3. 什么是枢轴量？
4. 如何用枢轴量法构造置信区间？
5. 正态总体均值、方差、两个总体均值差的置信区间怎么求？

这两讲的关系可以这样理解：

- 第四讲：给出一个估计值，比如 $\hat\theta$；
- 第五讲：给出一个估计范围，比如 $(L,U)$；
- 第四讲关注估计量的构造和评价；
- 第五讲关注估计不确定性的表达。

---

# 一、Lecture 04：极大似然估计与估计量评价准则

---

# 1. 为什么需要极大似然估计？

前面讲过矩估计。矩估计的思路是：

> 用样本矩代替总体矩。

例如：

若：

$$
X\sim Exp(\theta)
$$

且：

$$
E(X)=\frac1\theta
$$

令：

$$
\bar X=\frac1\theta
$$

得到：

$$
\hat\theta=\frac1{\bar X}
$$

矩估计的优点是直观、容易算。

但是它也有问题：

1. 有时总体矩很复杂；
2. 有时矩方程不好解；
3. 有时矩估计没有充分利用分布信息；
4. 有时不同矩的选择会产生不同结果。

极大似然估计的思想更直接：

> 哪个参数值使得“当前观测样本出现的可能性最大”，就把哪个参数值作为估计值。

这就是 maximum likelihood estimation，简称 MLE。

---

# 2. 极大似然估计的直观例子

讲义中的例子是：

罐子里有白球和黑球，已知两种球数量比例是 $1:3$，但不知道黑球多还是白球多。

所以取到黑球的概率 $p$ 只可能是：

$$
p=\frac14
$$

或者：

$$
p=\frac34
$$

现在有放回抽样 5 次，观测结果为：

$$
黑、白、黑、黑、黑
$$

令：

$$
X=
\begin{cases}
1,&取到黑球\\
0,&取到白球
\end{cases}
$$

那么：

$$
X\sim Bernoulli(p)
$$

样本观测值是：

$$
1,0,1,1,1
$$

如果：

$$
p=\frac14
$$

那么出现这个观测结果的概率为：

$$
\left(\frac14\right)^4\left(\frac34\right)
=
\frac{3}{1024}
$$

如果：

$$
p=\frac34
$$

那么出现这个观测结果的概率为：

$$
\left(\frac34\right)^4\left(\frac14\right)
=
\frac{81}{1024}
$$

显然后者更大，所以更合理的估计是：

$$
\hat p=\frac34
$$

这就是极大似然估计的基本思想。

它不是问：

> 参数本身出现的概率是多少？

而是问：

> 在不同参数值下，当前这组样本出现的可能性有多大？

---

# 3. 似然函数

设总体 $X$ 的分布含有未知参数 $\theta$。

如果 $X$ 是离散型随机变量，其 p.m.f. 为：

$$
p(x;\theta)
$$

如果 $X$ 是连续型随机变量，其 p.d.f. 为：

$$
f(x;\theta)
$$

样本为：

$$
X_1,\dots,X_n
$$

观测值为：

$$
x_1,\dots,x_n
$$

因为样本独立同分布，所以联合概率或联合密度是单个概率或密度的乘积。

离散型：

$$
L(\theta)=\prod_{i=1}^n p(x_i;\theta)
$$

连续型：

$$
L(\theta)=\prod_{i=1}^n f(x_i;\theta)
$$

这个 $L(\theta)$ 就叫似然函数。

---

## 3.1 似然函数和概率函数的区别

这点很重要。

如果把参数 $\theta$ 固定，$p(x;\theta)$ 是关于 $x$ 的概率函数。

如果把样本观测值 $x_1,\dots,x_n$ 固定，$L(\theta)$ 是关于 $\theta$ 的函数。

也就是说：

- 概率函数：参数固定，看不同样本出现的概率；
- 似然函数：样本固定，看不同参数下这组样本出现的可能性。

极大似然估计就是最大化：

$$
L(\theta)
$$

---

# 4. 极大似然估计的定义

如果：

$$
\hat\theta(x_1,\dots,x_n)
$$

满足：

$$
L(\hat\theta)=\max_{\theta\in\Theta}L(\theta)
$$

则称：

$$
\hat\theta(x_1,\dots,x_n)
$$

是 $\theta$ 的极大似然估计值。

对应的统计量：

$$
\hat\theta(X_1,\dots,X_n)
$$

称为极大似然估计量。

注意：

- 估计值是代入具体样本后得到的数；
- 估计量是样本的函数，是随机变量。

---

# 5. 对数似然函数

因为似然函数通常是很多项相乘，直接求最大值不方便，所以常取对数。

定义：

$$
l(\theta)=\log L(\theta)
$$

称为对数似然函数。

由于 $\log x$ 是严格单调递增函数，所以最大化 $L(\theta)$ 和最大化 $l(\theta)$ 得到同样的参数。

也就是说：

$$
\arg\max_\theta L(\theta)=\arg\max_\theta l(\theta)
$$

取对数的好处是：

- 乘积变成求和；
- 指数变成线性项；
- 求导更方便；
- 数值上更稳定。

---

# 6. 极大似然估计的一般步骤

对于光滑似然函数，MLE 通常按以下步骤做。

---

## 6.1 第一步：写出总体 p.m.f. 或 p.d.f.

离散型写：

$$
p(x;\theta)
$$

连续型写：

$$
f(x;\theta)
$$

注意必须写清楚参数取值范围。

例如：

$$
\theta>0
$$

或者：

$$
0<\theta<1
$$

---

## 6.2 第二步：写似然函数

独立同分布样本下：

$$
L(\theta)=\prod_{i=1}^n f(x_i;\theta)
$$

或：

$$
L(\theta)=\prod_{i=1}^n p(x_i;\theta)
$$

如果分布的支持集依赖参数，比如：

$$
0<x\le \lambda
$$

那么似然函数中必须写出约束：

$$
I\{X_{(n)}\le \lambda\}
$$

或者在文字中明确说明 $\lambda$ 必须满足：

$$
\lambda\ge X_{(n)}
$$

这是作业中特别容易错的地方。

---

## 6.3 第三步：取对数似然

$$
l(\theta)=\log L(\theta)
$$

---

## 6.4 第四步：求导并令导数为 0

如果参数是一维：

$$
\frac{dl(\theta)}{d\theta}=0
$$

如果参数是多维：

$$
\frac{\partial l(\theta)}{\partial \theta_j}=0,\qquad j=1,\dots,k
$$

---

## 6.5 第五步：解方程并检查最大值

一般课程作业里，常常只要求求导解方程，不严格检查二阶导数。

但要知道：

> 求导等于 0 只是候选点，不一定是最大值。

如果似然函数在参数空间内部光滑，通常用求导法。

如果似然函数单调，或者参数出现在支持集里，就不能机械求导，要结合参数范围判断最大值位置。

---

# 7. MLE 的不变性

极大似然估计有一个非常重要的性质：

如果：

$$
\hat\theta
$$

是 $\theta$ 的 MLE，那么：

$$
g(\hat\theta)
$$

是：

$$
g(\theta)
$$

的 MLE。

这叫 MLE 的不变性。

例如，若：

$$
\hat\lambda=\bar X
$$

是泊松分布参数 $\lambda$ 的 MLE，那么：

$$
P(X\le 2)
=
e^{-\lambda}\left(1+\lambda+\frac{\lambda^2}{2}\right)
$$

的 MLE 就是：

$$
e^{-\bar X}\left(1+\bar X+\frac{\bar X^2}{2}\right)
$$

---

# 8. 常见分布的 MLE

---

## 8.1 Bernoulli 分布的 MLE

设：

$$
X\sim Bernoulli(\theta)
$$

则：

$$
P(X=1)=\theta,\qquad P(X=0)=1-\theta
$$

样本为：

$$
X_1,\dots,X_n
$$

似然函数：

$$
L(\theta)=\prod_{i=1}^n \theta^{X_i}(1-\theta)^{1-X_i}
$$

整理：

$$
L(\theta)=\theta^{\sum X_i}(1-\theta)^{n-\sum X_i}
$$

对数似然：

$$
l(\theta)=\left(\sum_{i=1}^nX_i\right)\log\theta+
\left(n-\sum_{i=1}^nX_i\right)\log(1-\theta)
$$

求导：

$$
\frac{dl}{d\theta}
=
\frac{\sum X_i}{\theta}
-
\frac{n-\sum X_i}{1-\theta}
$$

令导数为 0：

$$
\frac{\sum X_i}{\theta}
=
\frac{n-\sum X_i}{1-\theta}
$$

解得：

$$
\hat\theta=\frac1n\sum_{i=1}^nX_i=\bar X
$$

所以 Bernoulli 分布成功概率的 MLE 是样本比例。

---

## 8.2 泊松分布的 MLE

设：

$$
X\sim Poisson(\lambda)
$$

p.m.f. 为：

$$
p(x;\lambda)=\frac{\lambda^x e^{-\lambda}}{x!},\qquad x=0,1,2,\dots
$$

样本为：

$$
X_1,\dots,X_n
$$

似然函数：

$$
L(\lambda)=\prod_{i=1}^n\frac{\lambda^{X_i}e^{-\lambda}}{X_i!}
$$

整理：

$$
L(\lambda)=
\frac{\lambda^{\sum X_i}e^{-n\lambda}}{\prod_{i=1}^n X_i!}
$$

对数似然：

$$
l(\lambda)=
\left(\sum_{i=1}^nX_i\right)\log\lambda
-n\lambda
-\sum_{i=1}^n\log(X_i!)
$$

求导：

$$
\frac{dl}{d\lambda}
=
\frac{\sum X_i}{\lambda}-n
$$

令导数为 0：

$$
\frac{\sum X_i}{\lambda}-n=0
$$

得到：

$$
\hat\lambda=\bar X
$$

---

### 作业例子：用 MLE 估计 $P(X\le 2)$

若：

$$
X\sim Poisson(\lambda)
$$

则：

$$
P(X\le 2)=P(X=0)+P(X=1)+P(X=2)
$$

分别为：

$$
P(X=0)=e^{-\lambda}
$$

$$
P(X=1)=\lambda e^{-\lambda}
$$

$$
P(X=2)=\frac{\lambda^2}{2}e^{-\lambda}
$$

所以：

$$
P(X\le 2)=e^{-\lambda}\left(1+\lambda+\frac{\lambda^2}{2}\right)
$$

由 MLE 不变性：

$$
\widehat{P(X\le 2)}
=
e^{-\bar X}\left(1+\bar X+\frac{\bar X^2}{2}\right)
$$

易错点：

> 不要漏掉 $P(X=0)$。

---

## 8.3 正态分布的 MLE

设：

$$
X\sim N(\mu,\sigma^2)
$$

其中 $\mu,\sigma^2$ 都未知。

密度为：

$$
f(x;\mu,\sigma^2)=
\frac{1}{\sqrt{2\pi\sigma^2}}
\exp\left\{-\frac{(x-\mu)^2}{2\sigma^2}\right\}
$$

样本似然函数：

$$
L(\mu,\sigma^2)=
\prod_{i=1}^n
\frac{1}{\sqrt{2\pi\sigma^2}}
\exp\left\{-\frac{(x_i-\mu)^2}{2\sigma^2}\right\}
$$

整理：

$$
L(\mu,\sigma^2)=
\left(\frac{1}{\sqrt{2\pi\sigma^2}}\right)^n
\exp\left\{-\frac{1}{2\sigma^2}\sum_{i=1}^n(x_i-\mu)^2\right\}
$$

对数似然：

$$
l(\mu,\sigma^2)=
-n\log\sqrt{2\pi}
-\frac n2\log\sigma^2
-\frac{1}{2\sigma^2}\sum_{i=1}^n(x_i-\mu)^2
$$

对 $\mu$ 求导：

$$
\frac{\partial l}{\partial \mu}
=
\frac{1}{\sigma^2}\sum_{i=1}^n(x_i-\mu)
$$

令其为 0：

$$
\sum_{i=1}^n(x_i-\mu)=0
$$

得到：

$$
\hat\mu=\bar x
$$

对 $\sigma^2$ 求导：

$$
\frac{\partial l}{\partial \sigma^2}
=
-\frac n{2\sigma^2}
+
\frac{1}{2\sigma^4}\sum_{i=1}^n(x_i-\mu)^2
$$

令其为 0，代入 $\hat\mu=\bar x$：

$$
\hat\sigma^2=
\frac1n\sum_{i=1}^n(x_i-\bar x)^2
$$

所以 MLE 为：

$$
\hat\mu=\bar X
$$

$$
\hat\sigma^2=\frac1n\sum_{i=1}^n(X_i-\bar X)^2=B_2
$$

注意：

> 正态总体方差 $\sigma^2$ 的 MLE 是 $B_2$，不是样本方差 $S^2$。

因为：

$$
S^2=\frac1{n-1}\sum_{i=1}^n(X_i-\bar X)^2
$$

而：

$$
B_2=\frac1n\sum_{i=1}^n(X_i-\bar X)^2
$$

---

## 8.4 均匀分布的 MLE

设：

$$
X\sim U[a,b]
$$

其中 $a,b$ 未知。

密度为：

$$
f(x;a,b)=
\begin{cases}
\frac1{b-a},&a\le x\le b\\
0,&其他
\end{cases}
$$

样本似然函数为：

$$
L(a,b)=
\begin{cases}
\frac1{(b-a)^n},&a\le x_i\le b,\ i=1,\dots,n\\
0,&否则
\end{cases}
$$

要使似然函数非零，必须满足：

$$
a\le x_{(1)}
$$

$$
b\ge x_{(n)}
$$

其中：

$$
x_{(1)}=\min\{x_1,\dots,x_n\}
$$

$$
x_{(n)}=\max\{x_1,\dots,x_n\}
$$

在似然非零的条件下：

$$
L(a,b)=\frac1{(b-a)^n}
$$

要让它最大，就要让区间长度 $b-a$ 尽量小。

同时要覆盖所有样本点，所以最小区间只能取：

$$
\hat a=x_{(1)}
$$

$$
\hat b=x_{(n)}
$$

因此：

$$
\hat a=X_{(1)}
$$

$$
\hat b=X_{(n)}
$$

由 MLE 不变性，若要求：

$$
E(X)=\frac{a+b}{2}
$$

的 MLE，则：

$$
\widehat{E(X)}
=
\frac{\hat a+\hat b}{2}
=
\frac{X_{(1)}+X_{(n)}}2
$$

---

### 这类题的核心

只要总体的取值范围依赖参数，比如：

$$
0<x\le \lambda
$$

或者：

$$
a\le x\le b
$$

就不能只机械求导。

必须先写出：

> 要使似然函数非零，参数必须满足什么约束。

然后在约束范围内判断似然函数如何最大。

---

## 8.5 指数分布的 MLE

讲义中这个例子写的是：

$$
X\sim Exp(1/\theta)
$$

也就是密度：

$$
f(x;\theta)=\frac1\theta e^{-x/\theta},\qquad x>0
$$

这里 $\theta$ 是尺度参数，均值为 $\theta$。

似然函数：

$$
L(\theta)=\prod_{i=1}^n\frac1\theta e^{-X_i/\theta}
$$

整理：

$$
L(\theta)=\frac1{\theta^n}\exp\left\{-\frac1\theta\sum_{i=1}^nX_i\right\}
$$

对数似然：

$$
l(\theta)=-n\log\theta-\frac1\theta\sum_{i=1}^nX_i
$$

求导：

$$
\frac{dl}{d\theta}
=
-\frac n\theta+\frac1{\theta^2}\sum_{i=1}^nX_i
$$

令其为 0：

$$
-\frac n\theta+\frac1{\theta^2}\sum_{i=1}^nX_i=0
$$

两边乘以 $\theta^2$：

$$
-n\theta+\sum_{i=1}^nX_i=0
$$

所以：

$$
\hat\theta=\bar X
$$

注意这里的参数写法是 $Exp(1/\theta)$，不是前三讲中常用的 $Exp(\theta)$。

如果 $X\sim Exp(\theta)$ 且密度为：

$$
f(x;\theta)=\theta e^{-\theta x}
$$

那么 $\theta$ 是速率参数，对应 MLE 是：

$$
\hat\theta=\frac1{\bar X}
$$

所以做题时必须先看题目给出的密度函数，不能只看 $Exp(\theta)$ 这个符号。

---

## 8.6 Laplace 型分布的 MLE

作业 2 中有一题：

$$
f(x;\theta)=\frac1{2\theta}e^{-|x|/\theta},\qquad x\in R,\quad \theta>0
$$

似然函数：

$$
L(\theta)=
\prod_{i=1}^n
\frac1{2\theta}e^{-|X_i|/\theta}
$$

整理：

$$
L(\theta)=
(2\theta)^{-n}
\exp\left\{
-\frac1\theta\sum_{i=1}^n|X_i|
\right\}
$$

对数似然：

$$
l(\theta)=
-n\log(2\theta)
-\frac1\theta\sum_{i=1}^n|X_i|
$$

求导：

$$
\frac{dl}{d\theta}
=
-\frac n\theta
+
\frac1{\theta^2}\sum_{i=1}^n|X_i|
$$

令其为 0：

$$
-\frac n\theta
+
\frac1{\theta^2}\sum_{i=1}^n|X_i|=0
$$

得到：

$$
\hat\theta=\frac1n\sum_{i=1}^n|X_i|
$$

这类题的标准过程是：

1. 写似然函数；
2. 写对数似然函数；
3. 求导；
4. 解出 MLE。

作业易错点中明确说明，这类题步骤分很重，不能只写结果。

---

## 8.7 支持集依赖参数的 MLE

作业 2 还有一类题：

$$
f(x;\lambda)=
\begin{cases}
\frac{4x^3}{\lambda^4},&0<x\le \lambda\\
0,&其他
\end{cases}
$$

样本为：

$$
X_1,\dots,X_n
$$

似然函数为：

$$
L(\lambda)=
\prod_{i=1}^n \frac{4X_i^3}{\lambda^4}
\cdot I\{0<X_i\le \lambda,\ i=1,\dots,n\}
$$

因为所有样本都必须满足：

$$
X_i\le \lambda
$$

所以必须有：

$$
\lambda\ge X_{(n)}
$$

其中：

$$
X_{(n)}=\max\{X_1,\dots,X_n\}
$$

当：

$$
\lambda\ge X_{(n)}
$$

时：

$$
L(\lambda)=
\frac{4^n\prod_{i=1}^nX_i^3}{\lambda^{4n}}
$$

它关于 $\lambda$ 单调递减。

因此在允许范围内，$\lambda$ 应取最小值：

$$
\hat\lambda=X_{(n)}
$$

这类题如果只求导，会完全错。

核心是：

> 支持集依赖参数时，先看似然函数非零的参数约束，再在约束内取最大值。

---

# 9. 估计量的评价准则

构造出估计量之后，还要评价它好不好。

第四讲主要讲四个标准：

1. 无偏性；
2. 有效性；
3. 均方误差；
4. 相合性。

---

# 10. 无偏性

## 10.1 定义

设：

$$
\hat\theta=\hat\theta(X_1,\dots,X_n)
$$

是参数 $\theta$ 的估计量。

如果：

$$
E(\hat\theta)=\theta
$$

则称 $\hat\theta$ 是 $\theta$ 的无偏估计量。

如果：

$$
E(\hat\theta)\ne \theta
$$

则称它是有偏估计量。

偏差定义为：

$$
Bias(\hat\theta)=E(\hat\theta)-\theta
$$

---

## 10.2 直观理解

无偏性的意思是：

> 重复抽样很多次，每次都算一个估计值，这些估计值的平均值等于真实参数。

无偏不表示每一次估计都准确，只表示长期平均没有系统性偏差。

---

## 10.3 典型例子：样本均值无偏

若：

$$
E(X)=\mu
$$

则：

$$
E(\bar X)=E\left(\frac1n\sum_{i=1}^nX_i\right)
$$

$$
=\frac1n\sum_{i=1}^nE(X_i)
$$

$$
=\frac1n\cdot n\mu
$$

$$
=\mu
$$

所以：

$$
\bar X
$$

是总体均值 $\mu$ 的无偏估计量。

---

## 10.4 典型例子：$B_2$ 有偏，$S^2$ 无偏

我们已经知道：

$$
B_2=\frac1n\sum_{i=1}^n(X_i-\bar X)^2
$$

满足：

$$
E(B_2)=\frac{n-1}{n}\sigma^2
$$

所以：

$$
B_2
$$

是 $\sigma^2$ 的有偏估计。

而：

$$
S^2=\frac{n}{n-1}B_2
$$

所以：

$$
E(S^2)=\frac{n}{n-1}E(B_2)=\sigma^2
$$

因此：

$$
S^2
$$

是 $\sigma^2$ 的无偏估计。

这说明：

> MLE 不一定无偏。

正态总体下 $\sigma^2$ 的 MLE 是 $B_2$，但 $B_2$ 是有偏估计量。

---

## 10.5 纠偏方法

如果某估计量满足：

$$
E(\hat\theta)=a\theta+b
$$

其中 $a\ne 0$，则：

$$
\frac{\hat\theta-b}{a}
$$

是 $\theta$ 的无偏估计量。

例如：

若：

$$
E(B_2)=\frac{n-1}{n}\sigma^2
$$

则：

$$
\frac{n}{n-1}B_2
$$

就是 $\sigma^2$ 的无偏估计量，也就是：

$$
S^2
$$

---

# 11. 有效性

## 11.1 定义

设：

$$
\hat\theta_1,\hat\theta_2
$$

都是 $\theta$ 的无偏估计量。

如果对所有 $\theta\in\Theta$：

$$
Var(\hat\theta_1)\le Var(\hat\theta_2)
$$

并且至少对某些 $\theta$ 严格小于，则称：

$$
\hat\theta_1
$$

比：

$$
\hat\theta_2
$$

更有效。

---

## 11.2 直观理解

有效性只在“无偏估计量之间”比较。

如果两个估计量都没有系统偏差，那么方差越小，说明估计值越稳定，越集中在真实参数附近。

所以：

> 无偏估计量中，方差越小越有效。

---

## 11.3 例子：前 $k$ 个样本均值估计总体均值

设：

$$
E(X)=\mu,\qquad Var(X)=\sigma^2
$$

对：

$$
1\le k\le n
$$

定义：

$$
\hat\theta_k=\frac1k(X_1+\cdots+X_k)
$$

则：

$$
E(\hat\theta_k)=\mu
$$

所以每个：

$$
\hat\theta_k
$$

都是 $\mu$ 的无偏估计。

方差为：

$$
Var(\hat\theta_k)
=
Var\left(\frac1k\sum_{i=1}^kX_i\right)
$$

由于样本独立：

$$
Var(\hat\theta_k)=\frac1{k^2}\sum_{i=1}^kVar(X_i)
$$

$$
=\frac1{k^2}\cdot k\sigma^2
$$

$$
=\frac{\sigma^2}{k}
$$

所以 $k$ 越大，方差越小。

因此使用全部样本：

$$
\hat\theta_n=\bar X
$$

最有效。

---

## 11.4 作业例子：比较两个方差估计量

设：

$$
X\sim N(\mu,\sigma^2)
$$

且 $\mu$ 已知。

比较：

$$
S^2
$$

和：

$$
\frac1n\sum_{i=1}^n(X_i-\mu)^2
$$

哪个估计 $\sigma^2$ 更有效。

第一，正态总体下：

$$
\frac{(n-1)S^2}{\sigma^2}\sim\chi^2(n-1)
$$

所以：

$$
Var(S^2)=\frac{2\sigma^4}{n-1}
$$

第二，令：

$$
Z_i=\frac{X_i-\mu}{\sigma}
$$

则：

$$
Z_i\sim N(0,1)
$$

所以：

$$
\sum_{i=1}^nZ_i^2\sim\chi^2(n)
$$

而：

$$
\frac1n\sum_{i=1}^n(X_i-\mu)^2
=
\frac{\sigma^2}{n}\sum_{i=1}^nZ_i^2
$$

所以：

$$
Var\left(\frac1n\sum_{i=1}^n(X_i-\mu)^2\right)
=
\frac{\sigma^4}{n^2}Var(\chi^2(n))
$$

$$
=\frac{\sigma^4}{n^2}\cdot 2n
$$

$$
=\frac{2\sigma^4}{n}
$$

比较：

$$
\frac{2\sigma^4}{n}
<
\frac{2\sigma^4}{n-1}
$$

所以：

$$
\frac1n\sum_{i=1}^n(X_i-\mu)^2
$$

更有效。

直观解释：

> 当 $\mu$ 已知时，不需要用 $\bar X$ 估计均值，所以不损失自由度，估计更稳定。

---

# 12. 均方误差 MSE

## 12.1 定义

设：

$$
\hat\theta
$$

是参数 $\theta$ 的估计量。

均方误差定义为：

$$
MSE(\hat\theta)=E(\hat\theta-\theta)^2
$$

MSE 衡量估计量与真实参数之间的平均平方距离。

---

## 12.2 MSE 分解公式

有重要分解：

$$
MSE(\hat\theta)=Var(\hat\theta)+[Bias(\hat\theta)]^2
$$

其中：

$$
Bias(\hat\theta)=E(\hat\theta)-\theta
$$

所以：

$$
MSE(\hat\theta)=Var(\hat\theta)+[E(\hat\theta)-\theta]^2
$$

如果估计量无偏，则：

$$
Bias(\hat\theta)=0
$$

于是：

$$
MSE(\hat\theta)=Var(\hat\theta)
$$

---

## 12.3 MSE 的意义

无偏性只看偏差，不看方差。

有效性只比较无偏估计量的方差。

MSE 同时考虑：

1. 估计是否偏；
2. 估计是否稳定。

所以 MSE 是更综合的评价标准。

有时一个估计量虽然有偏，但方差很小，整体 MSE 反而更小。

这就是 bias-variance tradeoff，偏差—方差权衡。

---

## 12.4 例子：用 MSE 比较 $S^2$ 和 $B_2$

正态总体下：

$$
S^2
$$

是 $\sigma^2$ 的无偏估计。

并且：

$$
Var(S^2)=\frac{2\sigma^4}{n-1}
$$

所以：

$$
MSE(S^2)=\frac{2\sigma^4}{n-1}
$$

另一方面：

$$
B_2=\frac{n-1}{n}S^2
$$

所以：

$$
E(B_2)=\frac{n-1}{n}\sigma^2
$$

偏差为：

$$
Bias(B_2)=E(B_2)-\sigma^2
$$

$$
=\frac{n-1}{n}\sigma^2-\sigma^2
$$

$$
=-\frac1n\sigma^2
$$

偏差平方为：

$$
[Bias(B_2)]^2=\frac{\sigma^4}{n^2}
$$

方差为：

$$
Var(B_2)=\left(\frac{n-1}{n}\right)^2Var(S^2)
$$

$$
=\frac{(n-1)^2}{n^2}\cdot\frac{2\sigma^4}{n-1}
$$

$$
=\frac{2(n-1)}{n^2}\sigma^4
$$

所以：

$$
MSE(B_2)
=
Var(B_2)+[Bias(B_2)]^2
$$

$$
=
\frac{2(n-1)}{n^2}\sigma^4
+
\frac1{n^2}\sigma^4
$$

$$
=
\frac{2n-1}{n^2}\sigma^4
$$

比较：

$$
MSE(S^2)=\frac{2\sigma^4}{n-1}
$$

$$
MSE(B_2)=\frac{2n-1}{n^2}\sigma^4
$$

当 $n>1$ 时：

$$
MSE(B_2)<MSE(S^2)
$$

所以按 MSE 准则，虽然 $B_2$ 有偏，但它优于 $S^2$。

这个例子非常重要：

> 无偏不一定代表 MSE 最小；有偏估计量有时反而更好。

---

# 13. 相合性

## 13.1 定义

设：

$$
\hat\theta_n=\hat\theta(X_1,\dots,X_n)
$$

是参数 $\theta$ 的估计量。

如果对任意：

$$
\theta\in\Theta
$$

当：

$$
n\to\infty
$$

时：

$$
\hat\theta_n \xrightarrow{P}\theta
$$

则称：

$$
\hat\theta_n
$$

是 $\theta$ 的相合估计量，也叫一致估计量。

---

## 13.2 直观理解

相合性强调的是大样本性质：

> 样本量越来越大时，估计量会以概率收敛到真实参数。

它不要求小样本时无偏，也不要求小样本方差最小。

比如：

$$
B_2
$$

虽然是 $\sigma^2$ 的有偏估计，但：

$$
E(B_2)=\frac{n-1}{n}\sigma^2
$$

当：

$$
n\to\infty
$$

时：

$$
\frac{n-1}{n}\to 1
$$

所以偏差趋于 0。它可以是相合的。

---

# 14. 第四讲重点题型总结

---

## 题型 1：常规 MLE 求导题

### 题型特征

题目给一个 p.d.f. 或 p.m.f.，参数不在支持集里，似然函数光滑。

### 做法

1. 写出 $L(\theta)$；
2. 写出 $l(\theta)=\log L(\theta)$；
3. 求导；
4. 令导数为 0；
5. 解出 $\hat\theta$。

### 常见例子

- Bernoulli：$\hat\theta=\bar X$；
- Poisson：$\hat\lambda=\bar X$；
- 正态：$\hat\mu=\bar X,\ \hat\sigma^2=B_2$；
- Laplace 型分布：$\hat\theta=\frac1n\sum |X_i|$。

---

## 题型 2：支持集依赖参数的 MLE

### 题型特征

密度中出现：

$$
0<x\le \lambda
$$

或：

$$
a\le x\le b
$$

或者其他含参数的取值范围。

### 做法

1. 写出似然函数；
2. 写出非零条件；
3. 找参数必须满足的范围；
4. 在该范围内判断似然函数单调性；
5. 取边界点。

### 常见结论

若：

$$
X\sim U[a,b]
$$

则：

$$
\hat a=X_{(1)},\qquad \hat b=X_{(n)}
$$

若：

$$
f(x;\lambda)=\frac{4x^3}{\lambda^4},\quad 0<x\le \lambda
$$

则：

$$
\hat\lambda=X_{(n)}
$$

---

## 题型 3：MLE 不变性

### 做法

如果先求出：

$$
\hat\theta
$$

然后要求：

$$
g(\theta)
$$

的 MLE，则直接写：

$$
\widehat{g(\theta)}=g(\hat\theta)
$$

### 例子

泊松分布中：

$$
\hat\lambda=\bar X
$$

所以：

$$
P(X\le 2)=e^{-\lambda}\left(1+\lambda+\frac{\lambda^2}{2}\right)
$$

的 MLE 为：

$$
e^{-\bar X}\left(1+\bar X+\frac{\bar X^2}{2}\right)
$$

---

## 题型 4：判断无偏性

### 做法

直接算：

$$
E(\hat\theta)
$$

如果：

$$
E(\hat\theta)=\theta
$$

则无偏。

如果：

$$
E(\hat\theta)=a\theta+b
$$

则可以纠偏：

$$
\frac{\hat\theta-b}{a}
$$

---

## 题型 5：比较有效性

### 做法

前提：两个估计量都无偏。

然后比较：

$$
Var(\hat\theta_1)
$$

和：

$$
Var(\hat\theta_2)
$$

方差小者更有效。

---

## 题型 6：计算 MSE

### 做法

使用公式：

$$
MSE(\hat\theta)=Var(\hat\theta)+[E(\hat\theta)-\theta]^2
$$

若估计量无偏，则：

$$
MSE(\hat\theta)=Var(\hat\theta)
$$

---

# 二、Lecture 05：区间估计

---

# 1. 为什么需要区间估计？

点估计给出一个数，比如：

$$
\hat\mu=\bar X
$$

但点估计不能表达不确定性。

比如两个样本都得到：

$$
\bar X=100
$$

但一个样本量是 $n=10$，另一个样本量是 $n=10000$，显然后者更可靠。

所以我们需要区间估计。

区间估计给出的是：

$$
(L,U)
$$

并说明：

> 这个随机区间以多大概率覆盖真实参数。

---

# 2. 置信区间的定义

设总体分布含未知参数 $\theta$。

如果统计量：

$$
L=L(X_1,\dots,X_n)
$$

和：

$$
U=U(X_1,\dots,X_n)
$$

满足：

$$
P\{L<\theta<U\}=1-\alpha
$$

则称：

$$
(L,U)
$$

为 $\theta$ 的置信水平为 $1-\alpha$ 的置信区间。

---

# 3. 如何理解置信水平？

这是第五讲最容易概念性出错的地方。

参数 $\theta$ 是固定但未知的。

区间：

$$
(L,U)
$$

是随机的，因为它由样本决定。

所以：

$$
P(L<\theta<U)=1-\alpha
$$

的意思不是：

> 对已经算出来的某个具体区间，$\theta$ 有 $1-\alpha$ 的概率在里面。

而是：

> 如果重复抽样很多次，每次都构造一个区间，那么这些区间中大约有 $1-\alpha$ 的比例会覆盖真实参数。

也就是说，随机的是区间，不是参数。

---

# 4. 单侧置信上限与下限

如果统计量 $L$ 满足：

$$
P(L<\theta)=1-\alpha
$$

则称 $L$ 为 $\theta$ 的单侧置信下限。

对应区间为：

$$
(L,\infty)
$$

如果统计量 $U$ 满足：

$$
P(\theta<U)=1-\alpha
$$

则称 $U$ 为 $\theta$ 的单侧置信上限。

对应区间为：

$$
(-\infty,U)
$$

例如，如果要给 $\sigma^2$ 的单侧上界，就是要找到 $U$，使得：

$$
P(\sigma^2<U)=1-\alpha
$$

---

# 5. 置信水平与精确度

置信区间的长度：

$$
U-L
$$

越短，估计越精确。

如果长度是随机的，可以看平均长度：

$$
E(U-L)
$$

一般来说：

> 置信水平越高，区间越长；区间越短，置信水平越低。

所以置信水平和精确度通常互相制约。

---

## 5.1 对称区间通常更短

在正态分布这类对称分布下，给定置信水平时，对称选取两端尾概率通常会得到更短的区间。

例如：

$$
(\bar X-2,\bar X+2)
$$

比同置信水平下某些非对称区间更短。

作业 3 Problem 2 的易错点就和这个有关：

> 区间长度缩短不一定置信水平就会简单比较；在相同区间长度下，正态分布的对称区间覆盖概率最大。

---

# 6. 枢轴量法

构造置信区间最重要的方法是枢轴量法。

---

## 6.1 枢轴量定义

设总体分布含未知参数 $\theta$。

如果：

$$
G=G(X_1,\dots,X_n;\theta)
$$

满足：

1. $G$ 是样本和待估参数的函数；
2. $G$ 的分布已知；
3. $G$ 的分布不依赖任何未知参数；

则称 $G$ 为枢轴量。

---

## 6.2 枢轴量与统计量的区别

统计量：

> 只能是样本的函数，不能含未知参数。

枢轴量：

> 可以含待估参数，但它的分布不能依赖未知参数。

例如：

$$
\bar X
$$

是统计量。

但如果总体：

$$
X\sim N(\mu,\sigma^2)
$$

且 $\mu,\sigma$ 都未知，则：

$$
\bar X\sim N\left(\mu,\frac{\sigma^2}{n}\right)
$$

它的分布依赖未知参数，所以 $\bar X$ 不是枢轴量。

再看：

$$
\frac{\bar X-\mu}{S/\sqrt n}
$$

它含有待估参数 $\mu$，所以不是统计量。

但是它服从：

$$
t(n-1)
$$

分布与未知参数无关，所以它是关于 $\mu$ 的枢轴量。

---

## 6.3 枢轴量法三步

第一步：找枢轴量。

找到：

$$
G=G(X_1,\dots,X_n;\theta)
$$

使其分布已知且不依赖未知参数。

第二步：找常数 $a,b$。

使得：

$$
P(a<G<b)=1-\alpha
$$

第三步：从不等式中解出参数。

把：

$$
a<G<b
$$

转化为：

$$
L<\theta<U
$$

于是得到置信区间：

$$
(L,U)
$$

---

# 7. 正态总体均值的置信区间

这是第五讲最核心的公式体系。

---

## 7.1 情况一：$\sigma^2$ 已知，估计 $\mu$

设：

$$
X_1,\dots,X_n\sim N(\mu,\sigma^2)
$$

其中 $\sigma^2$ 已知，$\mu$ 未知。

因为：

$$
\bar X\sim N\left(\mu,\frac{\sigma^2}{n}\right)
$$

所以：

$$
G=\frac{\bar X-\mu}{\sigma/\sqrt n}\sim N(0,1)
$$

这是枢轴量。

取：

$$
P(-z_{\alpha/2}<G<z_{\alpha/2})=1-\alpha
$$

即：

$$
P\left(
-z_{\alpha/2}
<
\frac{\bar X-\mu}{\sigma/\sqrt n}
<
z_{\alpha/2}
\right)=1-\alpha
$$

解出 $\mu$：

$$
\bar X-z_{\alpha/2}\frac{\sigma}{\sqrt n}
<
\mu
<
\bar X+z_{\alpha/2}\frac{\sigma}{\sqrt n}
$$

所以置信区间为：

$$
\left(
\bar X-z_{\alpha/2}\frac{\sigma}{\sqrt n},
\bar X+z_{\alpha/2}\frac{\sigma}{\sqrt n}
\right)
$$

---

## 7.2 单侧置信区间

对于 $\mu$ 的单侧下限：

$$
P\left(
\bar X-z_\alpha\frac{\sigma}{\sqrt n}<\mu
\right)=1-\alpha
$$

所以单侧下限为：

$$
\bar X-z_\alpha\frac{\sigma}{\sqrt n}
$$

对应区间：

$$
\left(
\bar X-z_\alpha\frac{\sigma}{\sqrt n},
\infty
\right)
$$

对于 $\mu$ 的单侧上限：

$$
P\left(
\mu<\bar X+z_\alpha\frac{\sigma}{\sqrt n}
\right)=1-\alpha
$$

对应区间：

$$
\left(
-\infty,
\bar X+z_\alpha\frac{\sigma}{\sqrt n}
\right)
$$

---

## 7.3 情况二：$\sigma^2$ 未知，估计 $\mu$

设：

$$
X_1,\dots,X_n\sim N(\mu,\sigma^2)
$$

其中 $\mu,\sigma^2$ 都未知。

此时不能用：

$$
\frac{\bar X-\mu}{\sigma/\sqrt n}
$$

因为 $\sigma$ 未知。

用样本标准差 $S$ 代替：

$$
G=\frac{\bar X-\mu}{S/\sqrt n}\sim t(n-1)
$$

取：

$$
P\left(
-t_{\alpha/2}(n-1)
<
G
<
t_{\alpha/2}(n-1)
\right)=1-\alpha
$$

即：

$$
P\left(
-t_{\alpha/2}(n-1)
<
\frac{\bar X-\mu}{S/\sqrt n}
<
t_{\alpha/2}(n-1)
\right)=1-\alpha
$$

解出 $\mu$：

$$
\bar X-t_{\alpha/2}(n-1)\frac{S}{\sqrt n}
<
\mu
<
\bar X+t_{\alpha/2}(n-1)\frac{S}{\sqrt n}
$$

所以置信区间为：

$$
\left(
\bar X-t_{\alpha/2}(n-1)\frac{S}{\sqrt n},
\bar X+t_{\alpha/2}(n-1)\frac{S}{\sqrt n}
\right)
$$

---

## 7.4 作业例子：$\mu$ 的 95% 置信区间

作业 3 中：

$$
X\sim N(\mu,\sigma^2)
$$

其中 $\mu,\sigma^2$ 均未知。

样本量：

$$
n=100
$$

样本均值：

$$
\bar x=15.5
$$

样本标准差：

$$
s=3.6
$$

要求 $\mu$ 的 95% 双侧置信区间。

因为 $\sigma^2$ 未知，所以用：

$$
G=\frac{\bar X-\mu}{S/\sqrt n}\sim t(n-1)
$$

这里自由度为：

$$
n-1=99
$$

95% 置信区间中：

$$
\alpha=0.05
$$

所以：

$$
\alpha/2=0.025
$$

置信区间：

$$
\left(
\bar X-t_{0.025}(99)\frac{S}{\sqrt{100}},
\bar X+t_{0.025}(99)\frac{S}{\sqrt{100}}
\right)
$$

代入：

$$
\frac{S}{\sqrt n}=\frac{3.6}{10}=0.36
$$

得到：

$$
\left(
15.5-0.36t_{0.025}(99),
15.5+0.36t_{0.025}(99)
\right)
$$

注意：

> 题目提示允许直接保留 $t_{0.025}(99)$，不一定要查表算小数。

---

# 8. 正态总体方差的置信区间

设：

$$
X_1,\dots,X_n\sim N(\mu,\sigma^2)
$$

其中 $\mu,\sigma^2$ 均未知。

要估计：

$$
\sigma^2
$$

由学生定理：

$$
G=\frac{(n-1)S^2}{\sigma^2}\sim \chi^2(n-1)
$$

这是 $\sigma^2$ 的枢轴量。

---

## 8.1 双侧置信区间

取：

$$
P(a<G<b)=1-\alpha
$$

由于卡方分布不对称，通常取：

$$
P(G<a)=\frac\alpha2
$$

$$
P(G>b)=\frac\alpha2
$$

讲义中用上分位数记号：

$$
\chi^2_\alpha(k)
$$

表示满足：

$$
P(\chi^2(k)>\chi^2_\alpha(k))=\alpha
$$

所以：

$$
a=\chi^2_{1-\alpha/2}(n-1)
$$

$$
b=\chi^2_{\alpha/2}(n-1)
$$

于是：

$$
P\left(
\chi^2_{1-\alpha/2}(n-1)
<
\frac{(n-1)S^2}{\sigma^2}
<
\chi^2_{\alpha/2}(n-1)
\right)=1-\alpha
$$

由于 $\sigma^2$ 在分母中，解不等式时上下界会反过来。

最终得到：

$$
\left(
\frac{(n-1)S^2}{\chi^2_{\alpha/2}(n-1)},
\frac{(n-1)S^2}{\chi^2_{1-\alpha/2}(n-1)}
\right)
$$

这就是 $\sigma^2$ 的双侧置信区间。

---

## 8.2 单侧置信上界

如果要找 $\sigma^2$ 的置信水平为 $1-\alpha$ 的单侧上界 $U$，即：

$$
P(\sigma^2<U)=1-\alpha
$$

从：

$$
G=\frac{(n-1)S^2}{\sigma^2}\sim\chi^2(n-1)
$$

出发。

若：

$$
\sigma^2<U
$$

等价于：

$$
\frac{(n-1)S^2}{\sigma^2}
>
\frac{(n-1)S^2}{U}
$$

为了使：

$$
P(\sigma^2<U)=1-\alpha
$$

需要：

$$
P\left(
G>
\frac{(n-1)S^2}{U}
\right)=1-\alpha
$$

所以：

$$
\frac{(n-1)S^2}{U}
=
\chi^2_{1-\alpha}(n-1)
$$

因此：

$$
U=
\frac{(n-1)S^2}{\chi^2_{1-\alpha}(n-1)}
$$

---

## 8.3 作业例子：$\sigma^2$ 的 99% 单侧置信上界

作业 3 中：

$$
n=100,\qquad s=3.6
$$

要求 $\sigma^2$ 的 99% 单侧置信上界。

这里：

$$
1-\alpha=0.99
$$

所以：

$$
\alpha=0.01
$$

自由度：

$$
n-1=99
$$

枢轴量：

$$
G=\frac{99S^2}{\sigma^2}\sim\chi^2(99)
$$

上界：

$$
U=\frac{99S^2}{\chi^2_{0.99}(99)}
$$

代入：

$$
S^2=3.6^2=12.96
$$

所以：

$$
99S^2=99\times 12.96=1283.04
$$

因此：

$$
U=\frac{1283.04}{\chi^2_{0.99}(99)}
$$

注意：

> 这里分母是 $\chi^2_{0.99}(99)$，不是 $\chi^2_{0.01}(99)$。

这是作业 3 易错点。

---

# 9. 当 $\mu$ 已知时，$\sigma^2$ 的置信区间

有时总体为：

$$
X\sim N(\mu_0,\sigma^2)
$$

其中 $\mu_0$ 已知，$\sigma^2$ 未知。

这时不能用：

$$
\frac{(n-1)S^2}{\sigma^2}
$$

因为那个公式对应的是 $\mu$ 未知、用 $\bar X$ 估计均值的情况。

当 $\mu_0$ 已知时：

$$
\frac{X_i-\mu_0}{\sigma}\sim N(0,1)
$$

所以：

$$
G=\frac{\sum_{i=1}^n(X_i-\mu_0)^2}{\sigma^2}
\sim \chi^2(n)
$$

自由度是 $n$，不是 $n-1$。

---

## 9.1 双侧置信区间

取：

$$
P\left(
\chi^2_{1-\alpha/2}(n)
<
\frac{\sum_{i=1}^n(X_i-\mu_0)^2}{\sigma^2}
<
\chi^2_{\alpha/2}(n)
\right)=1-\alpha
$$

解出：

$$
\left(
\frac{\sum_{i=1}^n(X_i-\mu_0)^2}{\chi^2_{\alpha/2}(n)},
\frac{\sum_{i=1}^n(X_i-\mu_0)^2}{\chi^2_{1-\alpha/2}(n)}
\right)
$$

注意：

> 因为 $\sigma^2$ 在分母，解不等式时上下界会反过来。

---

## 9.2 作业易错点

作业 3 Problem 6 的易错点就是：

从：

$$
P\left(a\le
\frac{\sum_{i=1}^n(X_i-\mu_0)^2}{\sigma^2}
\le b\right)
$$

转化到 $\sigma^2$ 的区间时，上下界容易反。

正确是：

$$
P\left(
\frac{\sum_{i=1}^n(X_i-\mu_0)^2}{b}
\le
\sigma^2
\le
\frac{\sum_{i=1}^n(X_i-\mu_0)^2}{a}
\right)
$$

---

# 10. 成对数据差的均值置信区间

第五讲中还讲了成对数据。

典型场景：

同一批人服药前后分别测量血压：

$$
(X_1,Y_1),\dots,(X_n,Y_n)
$$

这里 $X_i,Y_i$ 不是相互独立的，因为它们来自同一个人。

正确处理方法是做差：

$$
D_i=X_i-Y_i
$$

然后把：

$$
D_1,\dots,D_n
$$

看作来自正态总体：

$$
N(\mu_D,\sigma_D^2)
$$

的样本。

于是问题就变成单个正态总体均值的区间估计。

如果 $\sigma_D^2$ 未知，则：

$$
G=\frac{\bar D-\mu_D}{S_D/\sqrt n}\sim t(n-1)
$$

所以：

$$
\mu_D
$$

的置信水平为 $1-\alpha$ 的双侧置信区间为：

$$
\left(
\bar D-t_{\alpha/2}(n-1)\frac{S_D}{\sqrt n},
\bar D+t_{\alpha/2}(n-1)\frac{S_D}{\sqrt n}
\right)
$$

其中：

$$
\bar D=\frac1n\sum_{i=1}^nD_i
$$

$$
S_D^2=\frac1{n-1}\sum_{i=1}^n(D_i-\bar D)^2
$$

---

## 作业例子：药物降压效果

作业 3 中给出 10 名患者服药前后血压差：

$$
D=X-Y
$$

计算得到：

$$
\bar d=8
$$

$$
s_D^2=\frac{104}{9}
$$

$$
s_D\approx 3.40
$$

要构造 $\mu_D$ 的 95% 置信区间。

因为 $n=10$，自由度：

$$
n-1=9
$$

枢轴量：

$$
G=\frac{\bar D-\mu_D}{S_D/\sqrt{10}}\sim t(9)
$$

95% 置信区间为：

$$
\left(
\bar D-t_{0.025}(9)\frac{S_D}{\sqrt{10}},
\bar D+t_{0.025}(9)\frac{S_D}{\sqrt{10}}
\right)
$$

代入：

$$
t_{0.025}(9)\approx 2.2622
$$

$$
\bar d=8
$$

$$
s_D\approx 3.40
$$

得到：

$$
\left(
8-\frac{2.2622\times 3.40}{\sqrt{10}},
8+\frac{2.2622\times 3.40}{\sqrt{10}}
\right)
$$

约为：

$$
(5.57,10.43)
$$

这个区间整体大于 0，说明平均降压量为正。

---

# 11. 两个正态总体均值差的置信区间

设：

$$
X_1,\dots,X_{n_1}\sim N(\mu_1,\sigma_1^2)
$$

$$
Y_1,\dots,Y_{n_2}\sim N(\mu_2,\sigma_2^2)
$$

且两组样本独立。

如果：

$$
\sigma_1^2,\sigma_2^2
$$

已知，则：

$$
\bar X-\bar Y
\sim
N\left(
\mu_1-\mu_2,\frac{\sigma_1^2}{n_1}+\frac{\sigma_2^2}{n_2}
\right)
$$

枢轴量为：

$$
G=
\frac{(\bar X-\bar Y)-(\mu_1-\mu_2)}
{\sqrt{\sigma_1^2/n_1+\sigma_2^2/n_2}}
\sim N(0,1)
$$

所以：

$$
\mu_1-\mu_2
$$

的置信水平为 $1-\alpha$ 的双侧置信区间为：

$$
\left(
(\bar X-\bar Y)-z_{\alpha/2}
\sqrt{\frac{\sigma_1^2}{n_1}+\frac{\sigma_2^2}{n_2}},
(\bar X-\bar Y)+z_{\alpha/2}
\sqrt{\frac{\sigma_1^2}{n_1}+\frac{\sigma_2^2}{n_2}}
\right)
$$

---

# 12. 非对称区间置信水平计算

作业 3 中有一种题，不是让你求标准置信区间，而是给一个区间，让你算它的置信水平。

例如：

$$
X\sim N(\mu,\sigma^2)
$$

已知：

$$
\sigma=2,\qquad n=25
$$

给区间：

$$
(\bar X-0.8,\bar X+1.2)
$$

求置信水平。

---

## 12.1 解法

置信水平就是：

$$
P(\bar X-0.8<\mu<\bar X+1.2)
$$

把 $\mu$ 移到中间：

$$
P(-1.2<\bar X-\mu<0.8)
$$

标准化：

$$
\frac{\bar X-\mu}{\sigma/\sqrt n}
=
\frac{\bar X-\mu}{2/5}
$$

所以：

$$
P\left(
\frac{-1.2}{2/5}
<
\frac{\bar X-\mu}{2/5}
<
\frac{0.8}{2/5}
\right)
$$

即：

$$
P(-3<Z<2)
$$

其中：

$$
Z\sim N(0,1)
$$

所以置信水平为：

$$
\Phi(2)-\Phi(-3)
$$

利用：

$$
\Phi(-3)=1-\Phi(3)
$$

得到：

$$
\Phi(2)+\Phi(3)-1
$$

查表可得约：

$$
0.9759
$$

即：

$$
97.59\%
$$

---

## 12.2 区间长度减半但保持置信水平？

原区间：

$$
(\bar X-0.8,\bar X+1.2)
$$

长度为：

$$
2.0
$$

长度减半后长度为：

$$
1.0
$$

对于正态分布，在固定长度下，对称区间的覆盖概率最大。

所以长度为 1 的最佳区间是：

$$
(\bar X-0.5,\bar X+0.5)
$$

它的置信水平为：

$$
P(\bar X-0.5<\mu<\bar X+0.5)
$$

转化为：

$$
P\left(
-\frac{0.5}{2/5}
<
Z
<
\frac{0.5}{2/5}
\right)
$$

即：

$$
P(-1.25<Z<1.25)
$$

所以：

$$
2\Phi(1.25)-1
$$

约为：

$$
78.88\%
$$

小于：

$$
97.59\%
$$

所以不存在长度为原来一半但置信水平不低于原区间的置信区间。

作业易错点：

1. 题目固定了 $n=25$，不能通过改变 $n$ 来缩短区间；
2. 不能简单说区间缩短置信水平一定降低，要说明同长度下对称区间最优；
3. 要实际计算最大可能置信水平。

---

# 13. 指数分布参数的区间估计：非正态枢轴量例子

作业 3 给出：

$$
X\sim Exp(\theta)
$$

样本为：

$$
X_1,\dots,X_n
$$

令：

$$
G=\min_{1\le i\le n}\{\theta X_i\}
$$

要证明它是枢轴量并求 $\theta$ 的区间估计。

---

## 13.1 证明 $G$ 是枢轴量

若：

$$
X_i\sim Exp(\theta)
$$

且密度是：

$$
f(x;\theta)=\theta e^{-\theta x}
$$

那么：

$$
\theta X_i\sim Exp(1)
$$

因为把指数分布按比例缩放后，速率参数相应变化。

于是：

$$
\theta X_1,\dots,\theta X_n
$$

独立同分布于：

$$
Exp(1)
$$

令：

$$
G=\min_{1\le i\le n}\theta X_i
$$

计算分布函数：

$$
F_G(g)=P(G\le g)
$$

$$
=1-P(G>g)
$$

$$
=1-P(\theta X_1>g,\dots,\theta X_n>g)
$$

由于独立：

$$
=1-\prod_{i=1}^nP(\theta X_i>g)
$$

而：

$$
\theta X_i\sim Exp(1)
$$

所以：

$$
P(\theta X_i>g)=e^{-g}
$$

因此：

$$
F_G(g)=1-(e^{-g})^n
$$

$$
=1-e^{-ng},\qquad g\ge 0
$$

这说明：

$$
G\sim Exp(n)
$$

它的分布不含未知参数 $\theta$，所以 $G$ 是枢轴量。

---

## 13.2 用 $G$ 构造置信区间

希望找到 $a,b$，使得：

$$
P(a<G<b)=1-\alpha
$$

因为：

$$
G\sim Exp(n)
$$

指数分布 $Exp(n)$ 的上 $\alpha$ 分位数满足：

$$
P(G>g)=\alpha
$$

而：

$$
P(G>g)=e^{-ng}
$$

所以：

$$
e^{-ng}=\alpha
$$

解得：

$$
g=-\frac{\log\alpha}{n}
$$

因此：

$$
Exp_\alpha(n)=-\frac{\log\alpha}{n}
$$

取：

$$
a=Exp_{1-\alpha/2}(n)
=
-\frac{\log(1-\alpha/2)}{n}
$$

$$
b=Exp_{\alpha/2}(n)
=
-\frac{\log(\alpha/2)}{n}
$$

由：

$$
a<\theta\min X_i<b
$$

得到：

$$
\frac{a}{\min X_i}<\theta<\frac{b}{\min X_i}
$$

所以置信区间为：

$$
\left(
\frac{-\log(1-\alpha/2)}{n\min X_i},
\frac{-\log(\alpha/2)}{n\min X_i}
\right)
$$

---

# 14. 第五讲重点题型总结

---

## 题型 1：判断统计量还是枢轴量

### 判断统计量

看是否只含样本，不含未知参数。

### 判断枢轴量

看是否满足：

1. 是样本和待估参数的函数；
2. 分布已知；
3. 分布不依赖未知参数。

### 作业例子

若：

$$
X_i\sim U[0,\theta]
$$

$$
G=\frac{\bar X}{\theta}
$$

它不是统计量，因为含 $\theta$。

但：

$$
\frac{X_i}{\theta}\sim U[0,1]
$$

所以：

$$
G=\frac1n\sum_{i=1}^n\frac{X_i}{\theta}
$$

分布不依赖 $\theta$，因此是枢轴量。

若：

$$
X_i\sim Bernoulli(\theta)
$$

$$
G=\sum_{i=1}^nX_i
$$

它是样本的函数，不含未知参数，所以是统计量。

但：

$$
G\sim Bin(n,\theta)
$$

分布依赖 $\theta$，所以不是枢轴量。

---

## 题型 2：已知方差，求正态均值置信区间

用：

$$
\frac{\bar X-\mu}{\sigma/\sqrt n}\sim N(0,1)
$$

置信区间：

$$
\left(
\bar X-z_{\alpha/2}\frac{\sigma}{\sqrt n},
\bar X+z_{\alpha/2}\frac{\sigma}{\sqrt n}
\right)
$$

---

## 题型 3：未知方差，求正态均值置信区间

用：

$$
\frac{\bar X-\mu}{S/\sqrt n}\sim t(n-1)
$$

置信区间：

$$
\left(
\bar X-t_{\alpha/2}(n-1)\frac{S}{\sqrt n},
\bar X+t_{\alpha/2}(n-1)\frac{S}{\sqrt n}
\right)
$$

---

## 题型 4：求正态方差置信区间

若 $\mu$ 未知：

$$
\frac{(n-1)S^2}{\sigma^2}\sim\chi^2(n-1)
$$

置信区间：

$$
\left(
\frac{(n-1)S^2}{\chi^2_{\alpha/2}(n-1)},
\frac{(n-1)S^2}{\chi^2_{1-\alpha/2}(n-1)}
\right)
$$

若 $\mu=\mu_0$ 已知：

$$
\frac{\sum_{i=1}^n(X_i-\mu_0)^2}{\sigma^2}\sim\chi^2(n)
$$

置信区间：

$$
\left(
\frac{\sum_{i=1}^n(X_i-\mu_0)^2}{\chi^2_{\alpha/2}(n)},
\frac{\sum_{i=1}^n(X_i-\mu_0)^2}{\chi^2_{1-\alpha/2}(n)}
\right)
$$

---

## 题型 5：成对数据差的均值区间

先做差：

$$
D_i=X_i-Y_i
$$

再对：

$$
D_1,\dots,D_n
$$

做单样本 $t$ 区间。

公式：

$$
\left(
\bar D-t_{\alpha/2}(n-1)\frac{S_D}{\sqrt n},
\bar D+t_{\alpha/2}(n-1)\frac{S_D}{\sqrt n}
\right)
$$

---

## 题型 6：给定区间，求置信水平

### 做法

1. 写覆盖概率：

$$
P(L<\theta<U)
$$

2. 移项，把随机量放中间；
3. 标准化成 $Z$ 或 $t$ 或 $\chi^2$；
4. 用分布函数计算概率。

### 作业例子核心

区间：

$$
(\bar X-0.8,\bar X+1.2)
$$

对应：

$$
P(\bar X-0.8<\mu<\bar X+1.2)
$$

化为：

$$
P(-3<Z<2)
$$

所以置信水平为：

$$
\Phi(2)-\Phi(-3)
$$

---

## 题型 7：样本量 $n$ 的取值问题

如果区间形如：

$$
(\bar X-c_1,\bar X+c_2)
$$

且：

$$
X\sim N(\mu,\sigma^2)
$$

则置信水平一般会化成：

$$
P\left(
-\frac{c_2}{\sigma/\sqrt n}
<
Z
<
\frac{c_1}{\sigma/\sqrt n}
\right)
$$

再写成关于 $n$ 的函数，通过查表或试值找到满足条件的整数 $n$。

作业 3 Problem 4 中，正确化简是：

$$
\Phi(0.2\sqrt n)-\Phi(-0.4\sqrt n)
$$

再利用对称性写成：

$$
\Phi(0.2\sqrt n)+\Phi(0.4\sqrt n)-1
$$

最终 $n=24,25$ 都符合要求。

---

# 十五、第四、五讲最容易扣分的点

1. MLE 题不要只写最后答案，似然函数、对数似然函数、求导过程都要写。

2. 离散型似然函数用 p.m.f.，连续型似然函数用 p.d.f.

3. 具体频数已经给出时，比较似然函数不需要再乘排列组合系数。

4. 泊松分布估计 $P(X\le 2)$ 时，不要漏掉 $P(X=0)$。

5. 支持集依赖参数时，不能机械求导，要先写参数约束。

6. 正态分布 $\sigma^2$ 的 MLE 是 $B_2$，不是 $S^2$。

7. $B_2$ 有偏，但按 MSE 可能优于 $S^2$。

8. 有效性只在无偏估计量之间比较。

9. MSE 公式必须记住：

$$
MSE(\hat\theta)=Var(\hat\theta)+[Bias(\hat\theta)]^2
$$

10. 枢轴量可以含待估参数，统计量不能含未知参数。

11. 枢轴量的分布必须不依赖未知参数。

12. 置信区间中参数是固定的，区间是随机的。

13. $\sigma^2$ 在分母中时，解置信区间不等式上下界会反。

14. 正态总体均值区间中：
    - $\sigma$ 已知用 $Z$；
    - $\sigma$ 未知用 $t(n-1)$。

15. 正态总体方差区间中：
    - $\mu$ 未知用自由度 $n-1$；
    - $\mu$ 已知用自由度 $n$。

16. 单侧方差上界中，分母常常是 $\chi^2_{1-\alpha}(n-1)$，不要机械写成 $\chi^2_{\alpha}(n-1)$。

17. 成对数据不能把服药前后当成两组独立样本，应该先做差。

18. 题目要求说明理由时，只写“是统计量”或“是枢轴量”不够，必须说明是否含未知参数、分布是否依赖未知参数。

---

# 十六、复习顺序建议

## 第一轮：理解主线

先明确：

1. MLE 是通过最大化样本出现可能性来估计参数；
2. 无偏性看 $E(\hat\theta)$；
3. 有效性看无偏估计量之间的方差；
4. MSE 同时看方差和偏差；
5. 相合性看样本量趋于无穷时是否收敛到真值；
6. 置信区间不是参数随机，而是区间随机；
7. 枢轴量法是构造置信区间的核心方法。

---

## 第二轮：背核心公式

### MLE 常见结果

$$
Bernoulli(\theta):\quad \hat\theta=\bar X
$$

$$
Poisson(\lambda):\quad \hat\lambda=\bar X
$$

$$
N(\mu,\sigma^2):\quad \hat\mu=\bar X,\quad \hat\sigma^2=B_2
$$

$$
U[a,b]:\quad \hat a=X_{(1)},\quad \hat b=X_{(n)}
$$

---

### 估计量评价

$$
Bias(\hat\theta)=E(\hat\theta)-\theta
$$

$$
MSE(\hat\theta)=E(\hat\theta-\theta)^2
$$

$$
MSE(\hat\theta)=Var(\hat\theta)+[Bias(\hat\theta)]^2
$$

---

### 正态均值置信区间

$\sigma$ 已知：

$$
\left(
\bar X-z_{\alpha/2}\frac{\sigma}{\sqrt n},
\bar X+z_{\alpha/2}\frac{\sigma}{\sqrt n}
\right)
$$

$\sigma$ 未知：

$$
\left(
\bar X-t_{\alpha/2}(n-1)\frac{S}{\sqrt n},
\bar X+t_{\alpha/2}(n-1)\frac{S}{\sqrt n}
\right)
$$

---

### 正态方差置信区间

$\mu$ 未知：

$$
\left(
\frac{(n-1)S^2}{\chi^2_{\alpha/2}(n-1)},
\frac{(n-1)S^2}{\chi^2_{1-\alpha/2}(n-1)}
\right)
$$

$\mu$ 已知：

$$
\left(
\frac{\sum_{i=1}^n(X_i-\mu_0)^2}{\chi^2_{\alpha/2}(n)},
\frac{\sum_{i=1}^n(X_i-\mu_0)^2}{\chi^2_{1-\alpha/2}(n)}
\right)
$$

---

## 第三轮：按题型训练

| 题目特征                | 方法                       |
| ------------------- | ------------------------ |
| 求 MLE               | 写似然、取 log、求导             |
| 参数在支持集里             | 写非零条件，看边界                |
| 求 $g(\theta)$ 的 MLE | 用不变性 $g(\hat\theta)$     |
| 判断无偏                | 算 $E(\hat\theta)$        |
| 比较有效性               | 先确认无偏，再比方差               |
| 求 MSE               | 方差 + 偏差平方                |
| 判断统计量/枢轴量           | 看是否含未知参数、分布是否依赖未知参数      |
| 求置信区间               | 找枢轴量、找分位数、解参数            |
| 正态均值区间              | $\sigma$ 已知用 $Z$，未知用 $t$ |
| 正态方差区间              | 用卡方，注意自由度和倒数             |
| 成对数据                | 先做差，再做单样本 t 区间           |
| 给定区间求置信水平           | 写覆盖概率，标准化计算              |

---

# 十七、最后的考前速记

第四讲速记：

> MLE：样本固定，找让样本最可能出现的参数。  
> 无偏：$E(\hat\theta)=\theta$。  
> 有效：无偏估计量中方差更小。  
> MSE：$Var+Bias^2$。  
> 相合：$n\to\infty$ 时依概率收敛到真值。  

第五讲速记：

> 置信区间：随机区间覆盖固定参数的长期频率。  
> 枢轴量：含样本和参数，但分布不含未知参数。  
> 枢轴量法：找 $G$，写 $P(a<G<b)=1-\alpha$，解出参数区间。  
> 均值区间：已知 $\sigma$ 用 $Z$，未知 $\sigma$ 用 $t$。  
> 方差区间：用 $\chi^2$，参数在分母，上下界会反。  
> 成对数据：先做差。  