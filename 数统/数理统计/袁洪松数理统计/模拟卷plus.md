# 上海财经大学《数理统计》期末模拟卷（强化版）

> 难度：偏大  
> 覆盖范围：MLE、Fisher 信息量、Rao-Cramer 下界、有效性、LRT、Wald 检验、Score 检验、充分统计量、完备性、正则指数族、MVUE、Rao-Blackwell、Lehmann-Scheffe、Neyman-Pearson、UMP  
> 说明：多参数部分只在判断/选择中做概念考察，计算题不考多参数计算。

---

# 一、判断题（每小题 2 分，共 30 分）

判断下列命题是否正确，并给出简要理由。

## 1. Fisher 信息量一定非负。

答案：T

解析：

Fisher 信息量可以写成：

$$
I(\theta)
=
E_\theta\left[
\left(
\frac{\partial}{\partial\theta}\log f(X;\theta)
\right)^2
\right].
$$

它是平方项的期望，因此一定非负。

---

## 2. 若估计的是参数函数 $g(\theta)$，则其无偏估计量的 Rao-Cramer 下界一定是 $1/[nI(\theta)]$。

答案：F

解析：

如果估计的是 $g(\theta)$，Rao-Cramer 下界为：

$$
RCB
=
\frac{[g'(\theta)]^2}{nI(\theta)}.
$$

只有当：

$$
g(\theta)=\theta
$$

时，才有：

$$
RCB=\frac{1}{nI(\theta)}.
$$

---

## 3. Rao-Cramer 下界适用于所有估计量，包括有偏估计量。

答案：F

解析：

课程中使用的 Rao-Cramer 下界通常是无偏估计量的方差下界，即：

$$
\operatorname{Var}(\hat\theta)\geq RCB.
$$

它不保证约束所有有偏估计量。有偏估计量的方差可以低于 Rao-Cramer 下界。

---

## 4. 有效估计量一定是 MVUE，但 MVUE 不一定是有效估计量。

答案：T

解析：

有效估计量是指无偏估计量达到 Rao-Cramer 下界。如果一个无偏估计量已经达到理论下界，那么它一定是所有无偏估计量中方差最小的，所以一定是 MVUE。

但是 MVUE 只是无偏估计中方差最小，并不保证达到 Rao-Cramer 下界。

---

## 5. 如果 $T$ 是充分统计量，那么 $T^2$ 一定也是充分统计量。

答案：F

解析：

充分统计量经过一一变换后仍充分。但 $T^2$ 不一定是 $T$ 的一一函数。

例如 $T$ 可以取正负值时，$T^2$ 会丢失符号信息，因此不一定充分。

---

## 6. 如果 $T$ 是充分统计量，且 $h$ 是一一函数，则 $h(T)$ 也是充分统计量。

答案：T

解析：

一一函数不会损失 $T$ 中的信息。既然 $T$ 已经包含关于参数的全部信息，$h(T)$ 也包含同样的信息。

---

## 7. 一个参数模型不一定存在一维充分统计量。

答案：T

解析：

只有一个参数并不意味着一定存在一维充分统计量。常见单参数正则指数族往往存在形如

$$
T=\sum_{i=1}^n K(X_i)
$$

的一维充分统计量，但一般单参数模型不一定有这种结构。

---

## 8. 若 $T$ 是完备充分统计量，且 $\varphi(T)$ 是 $g(\theta)$ 的无偏估计量，则 $\varphi(T)$ 是 $g(\theta)$ 的 MVUE。

答案：T

解析：

这是 Lehmann-Scheffe 定理：

如果 $T$ 是完备充分统计量，并且

$$
E_\theta[\varphi(T)]=g(\theta),
$$

则 $\varphi(T)$ 是 $g(\theta)$ 的唯一 MVUE。

---

## 9. 若 $T$ 是完备族中的统计量，只要 $E_{\theta_0}[u(T)]=0$ 对某一个 $\theta_0$ 成立，就能推出 $u(T)=0$ 几乎必然成立。

答案：F

解析：

完备性的条件必须是：

$$
E_\theta[u(T)]=0,\quad \forall \theta\in\Theta.
$$

只有对所有 $\theta$ 都成立，才能推出：

$$
u(T)=0 \quad a.s.
$$

只对某一个 $\theta_0$ 成立是不够的。

---

## 10. 单参数正则指数分布类通常可以找到完备充分统计量。

答案：T

解析：

若密度可写成：

$$
f(x;\theta)=\exp\{Q(\theta)K(x)+C(\theta)+D(x)\},
$$

且支撑集不依赖 $\theta$，则样本的完备充分统计量通常为：

$$
T=\sum_{i=1}^n K(X_i).
$$

---

## 11. 支撑集依赖参数的分布一定没有充分统计量。

答案：F

解析：

支撑集依赖参数通常意味着它不是正则指数族，但仍然可能存在充分统计量。

例如：

$$
X_i\sim U(0,\theta)
$$

时，支撑集依赖 $\theta$，但

$$
X_{(n)}=\max_i X_i
$$

是充分统计量。

---

## 12. 似然比检验中，拒绝域总是取 $\Lambda$ 很大的区域。

答案：F

解析：

似然比统计量一般定义为：

$$
\Lambda=
\frac{\sup_{\theta\in\Theta_0}L(\theta)}
{\sup_{\theta\in\Theta}L(\theta)}.
$$

当原假设下的最大似然相对于全参数空间最大似然太小时，说明原假设不支持样本，因此拒绝域通常是：

$$
\Lambda\leq c.
$$

也就是 $\Lambda$ 很小的区域。

---

## 13. 对简单假设 $H_0:\theta=\theta_0$ 和简单备择 $H_1:\theta=\theta_1$，Neyman-Pearson 引理给出的最优拒绝域可以写成 $L(\theta_0)/L(\theta_1)\leq k$。

答案：T

解析：

Neyman-Pearson 引理说明，对于简单原假设和简单备择假设，显著水平给定时，最优拒绝域可以由似然比构造：

$$
C=
\left\{
\frac{L(\theta_0)}{L(\theta_1)}\leq k
\right\}.
$$

---

## 14. 如果 $\hat\theta$ 是 $\theta$ 的 MVUE，那么 $g(\hat\theta)$ 一定是 $g(\theta)$ 的 MVUE。

答案：F

解析：

非线性函数一般不保持无偏性。

即使：

$$
E(\hat\theta)=\theta,
$$

通常也不能推出：

$$
E[g(\hat\theta)]=g(\theta).
$$

例如：

$$
E(\hat\theta^2)\neq \theta^2
$$

一般成立。

---

## 15. 双侧检验问题一般不一定存在 UMP 检验。

答案：T

解析：

单侧检验中，如果具有单调似然比结构，经常可以构造 UMP 检验。

但双侧检验通常需要同时照顾两个方向的备择，最优拒绝域往往依赖具体备择方向，因此一般不存在 UMP 检验。

---

# 二、单选题（每小题 3 分，共 45 分）

每题只有一个正确答案。

---

## 1. 若 $X_1,\dots,X_n$ 的 Fisher 信息量为 $I(\theta)$，则估计 $g(\theta)$ 的无偏估计量的 Rao-Cramer 下界为：

A. $\dfrac{1}{I(\theta)}$

B. $\dfrac{1}{nI(\theta)}$

C. $\dfrac{[g'(\theta)]^2}{nI(\theta)}$

D. $\dfrac{g(\theta)^2}{nI(\theta)}$

答案：C

解析：

估计参数函数 $g(\theta)$ 时：

$$
RCB=\frac{[g'(\theta)]^2}{nI(\theta)}.
$$

---

## 2. 设 $X_1,\dots,X_n\sim N(\mu_0,\theta)$，其中 $\mu_0$ 已知，$\theta$ 未知。下列哪个统计量是 $\theta$ 的充分统计量？

A. $\sum_{i=1}^n X_i$

B. $\bar X$

C. $\sum_{i=1}^n X_i^2$

D. $\sum_{i=1}^n (X_i-\mu_0)^2$

答案：D

解析：

均值已知、方差未知时，似然函数中关于 $\theta$ 的部分依赖于：

$$
\sum_{i=1}^n (X_i-\mu_0)^2.
$$

所以充分统计量是 D。

---

## 3. 下列分布中，属于正则指数分布类的是：

A. $U(0,\theta)$

B. 平移指数分布 $f(x;\theta)=e^{-(x-\theta)},x>\theta$

C. 瑞利分布 $f(x;\theta)=\dfrac{x}{\theta^2}e^{-x^2/(2\theta^2)},x>0$

D. $U(\theta,\theta+1)$

答案：C

解析：

瑞利分布可写为：

$$
f(x;\theta)=\exp\left\{
-\frac{1}{2\theta^2}x^2+\log x-2\log\theta
\right\},
\quad x>0.
$$

支撑集不依赖 $\theta$，属于正则指数分布类。

A、B、D 的支撑集都依赖参数。

---

## 4. 若 $X_1,\dots,X_n\sim N(\theta,1)$，则 $\theta^2$ 的 MVUE 是：

A. $\bar X^2$

B. $\bar X^2-\dfrac{1}{n}$

C. $\bar X^2+\dfrac{1}{n}$

D. $X_1^2$

答案：B

解析：

因为：

$$
E(\bar X)=\theta,
\qquad
\operatorname{Var}(\bar X)=\frac{1}{n}.
$$

所以：

$$
E(\bar X^2)=\theta^2+\frac{1}{n}.
$$

因此：

$$
\bar X^2-\frac{1}{n}
$$

是 $\theta^2$ 的无偏估计。

又 $\bar X$ 是完备充分统计量的函数，所以它是 MVUE。

---

## 5. 若 $X_1,\dots,X_n\sim Bernoulli(\theta)$，令 $S=\sum_{i=1}^n X_i$。则 $\theta(1-\theta)$ 的 MVUE 是：

A. $\bar X(1-\bar X)$

B. $\dfrac{S(n-S)}{n^2}$

C. $\dfrac{S(n-S)}{n(n-1)}$

D. $\dfrac{S(S-1)}{n(n-1)}$

答案：C

解析：

Bernoulli 样本中：

$$
S\sim Bin(n,\theta).
$$

已知：

$$
E\left[
\frac{S(n-S)}{n(n-1)}
\right]
=
\theta(1-\theta).
$$

它是完备充分统计量 $S$ 的函数，因此是 MVUE。

---

## 6. 若 $X_1,\dots,X_n\sim Po(\theta)$，令 $S=\sum X_i$。则 $e^{-\theta}$ 的 MVUE 是：

A. $I_{\{X_1=0\}}$

B. $\left(\dfrac{n-1}{n}\right)^S$

C. $e^{-\bar X}$

D. $\left(\dfrac{1}{n}\right)^S$

答案：B

解析：

首先：

$$
I_{\{X_1=0\}}
$$

是 $e^{-\theta}$ 的无偏估计。

因为：

$$
X_1\mid S=s\sim Bin\left(s,\frac1n\right),
$$

所以：

$$
E[I_{\{X_1=0\}}\mid S=s]
=
P(X_1=0\mid S=s)
=
\left(1-\frac1n\right)^s.
$$

因此 MVUE 为：

$$
\left(\frac{n-1}{n}\right)^S.
$$

---

## 7. 若 $X_1,\dots,X_n\sim Exp(1/\theta)$，其中 $\theta$ 为均值参数，则 $\theta$ 的 MLE 和 Rao-Cramer 下界分别是：

A. $\hat\theta=\bar X,\quad RCB=\theta^2/n$

B. $\hat\theta=1/\bar X,\quad RCB=\theta^2/n$

C. $\hat\theta=\bar X,\quad RCB=1/(n\theta^2)$

D. $\hat\theta=1/\bar X,\quad RCB=1/(n\theta^2)$

答案：A

解析：

指数分布均值参数为 $\theta$ 时：

$$
E(X)=\theta,
\qquad
I(\theta)=\frac{1}{\theta^2}.
$$

MLE 为：

$$
\hat\theta=\bar X.
$$

Rao-Cramer 下界为：

$$
RCB=\frac{1}{nI(\theta)}
=
\frac{\theta^2}{n}.
$$

---

## 8. 若 $X_1,\dots,X_n\sim \Gamma(c,\theta)$，其中 $c$ 已知，$\theta$ 为尺度参数。考虑 $H_0:\theta=\theta_0$ vs $H_1:\theta\neq\theta_0$ 的 LRT。令 $Y=\sum X_i$，则拒绝域形如：

A. $Y\geq c_1$

B. $Y\leq c_1$

C. $Y\leq c_1$ 或 $Y\geq c_2$

D. $c_1\leq Y\leq c_2$

答案：C

解析：

LRT 统计量可写成 $Y$ 的函数，并且该函数在 $Y=nc\theta_0$ 处取最小值，两侧偏离越大越拒绝。

因此拒绝域是双尾区域：

$$
Y\leq c_1
\quad \text{或}\quad
Y\geq c_2.
$$

---

## 9. 若 $X_1,\dots,X_n\sim Exp(1/\theta)$，即均值参数为 $\theta$。对检验 $H_0:\theta=\theta_0$ vs $H_1:\theta=\theta_1$，其中 $\theta_1>\theta_0$，Neyman-Pearson 最优拒绝域形如：

A. $\sum X_i\geq c$

B. $\sum X_i\leq c$

C. $\bar X=c$

D. $\sum X_i^2\geq c$

答案：A

解析：

均值参数越大，样本和 $\sum X_i$ 越倾向于偏大。

由 Neyman-Pearson 引理可推出最优拒绝域形如：

$$
\sum_{i=1}^n X_i\geq c.
$$

---

## 10. 关于完备性，下列说法正确的是：

A. 若 $E_{\theta_0}[u(T)]=0$ 对某一个 $\theta_0$ 成立，则 $u(T)=0$ 几乎必然成立

B. 若 $E_\theta[u(T)]=0$ 对所有 $\theta$ 成立，则 $u(T)=0$ 几乎必然成立

C. 充分统计量一定完备

D. 完备统计量一定充分

答案：B

解析：

完备性的定义就是：

$$
E_\theta[u(T)]=0,\quad \forall \theta
$$

推出：

$$
u(T)=0\quad a.s.
$$

---

## 11. 若 $X_1,\dots,X_n\sim Bernoulli(\theta)$，参数空间限制为 $0\leq \theta\leq 1/3$，则 $\theta$ 的 MLE 是：

A. $\bar X$

B. $\max\{\bar X,1/3\}$

C. $\min\{\bar X,1/3\}$

D. $1/3$

答案：C

解析：

无约束情况下 MLE 为：

$$
\bar X.
$$

但参数空间限制为：

$$
0\leq\theta\leq \frac13.
$$

所以：

$$
\hat\theta=\min\left\{\bar X,\frac13\right\}.
$$

---

## 12. 若 $T$ 是充分统计量，下列说法正确的是：

A. 任意函数 $h(T)$ 都是充分统计量

B. 只有线性函数 $aT+b$ 才一定保持充分性

C. 若 $h$ 是一一函数，则 $h(T)$ 是充分统计量

D. $T^2$ 一定是充分统计量

答案：C

解析：

充分统计量经过一一变换不会损失信息，因此仍然充分。

任意函数不一定保持充分性，因为可能丢失信息。

---

## 13. 下列估计量一定不是 $\theta$ 的 MVUE 的是：

A. $X_i\sim Po(\theta)$，估计量 $\bar X$

B. $X_i\sim Bernoulli(\theta)$，估计量 $\bar X$

C. $X_i\sim N(\theta,\sigma_0^2)$，估计量 $\bar X$

D. $X_i\sim Exp(\theta)$，其中 $\theta$ 为率参数，估计量 $\bar X$

答案：D

解析：

若 $Exp(\theta)$ 中 $\theta$ 是率参数，则：

$$
E(X)=\frac1\theta.
$$

所以：

$$
E(\bar X)=\frac1\theta,
$$

它不是 $\theta$ 的无偏估计，因此不可能是 $\theta$ 的 MVUE。

---

## 14. 在常规正则条件下，对一维参数的假设 $H_0:\theta=\theta_0$，LRT、Wald 型检验和 Score 型检验统计量的渐近分布通常是：

A. $N(0,1)$

B. $\chi^2(1)$

C. $t(n-1)$

D. $F(1,n-1)$

答案：B

解析：

在常规正则条件下，一维参数的 LRT、Wald、Score 检验统计量在原假设下都有渐近分布：

$$
\chi^2(1).
$$

---

## 15. 若 $X_1,\dots,X_n\sim N(\theta,1)$，考虑 $H_0:\theta=\theta_0$ vs $H_1:\theta\neq\theta_0$。关于 UMP 检验，下列说法正确的是：

A. 存在 UMP，拒绝域为 $\sum X_i\geq c$

B. 存在 UMP，拒绝域为 $\sum X_i\leq c$

C. 存在 UMP，拒绝域为 $|\bar X-\theta_0|\geq c$

D. 一般不存在 UMP

答案：D

解析：

正态均值的双侧检验可以用 LRT 或 z 检验构造合理拒绝域，但对于双侧备择，一般不存在 UMP 检验。

---

# 三、计算题（共 125 分）

---

# 1. 几何分布：MLE、Fisher 信息量与有效性（15 分）

设 $X_1,\dots,X_n$ 来自几何分布：

$$
P(X=x;\theta)
=
\frac{1}{\theta}
\left(1-\frac{1}{\theta}\right)^{x-1},
\qquad x=1,2,\dots,\quad \theta>1.
$$

已知：

$$
E(X)=\theta,
\qquad
\operatorname{Var}(X)=\theta(\theta-1).
$$

1. 求 $\theta$ 的 MLE；
2. 求 Fisher 信息量 $I(\theta)$；
3. 判断 MLE 是否有效，并计算有效性。

---

## 标准答案

### 1）求 MLE

样本似然函数为：

$$
L(\theta)
=
\prod_{i=1}^n
\frac{1}{\theta}
\left(1-\frac{1}{\theta}\right)^{X_i-1}.
$$

对数似然函数为：

$$
\ell(\theta)
=
-n\log\theta
+
\sum_{i=1}^n(X_i-1)
\log\left(1-\frac1\theta\right).
$$

注意：

$$
1-\frac1\theta=\frac{\theta-1}{\theta}.
$$

对 $\theta$ 求导：

$$
\ell'(\theta)
=
-\frac{n}{\theta}
+
\left(\sum_{i=1}^n X_i-n\right)
\frac{1}{\theta(\theta-1)}.
$$

令 $\ell'(\theta)=0$：

$$
-\frac{n}{\theta}
+
\frac{\sum X_i-n}{\theta(\theta-1)}
=0.
$$

两边乘以 $\theta(\theta-1)$：

$$
-n(\theta-1)+\sum X_i-n=0.
$$

整理得：

$$
\sum_{i=1}^n X_i=n\theta.
$$

所以：

$$
\boxed{
\hat\theta=\bar X
}
$$

---

### 2）求 Fisher 信息量

单个样本的对数概率为：

$$
\log f(X;\theta)
=
-\log\theta+(X-1)\log\left(1-\frac1\theta\right).
$$

得分函数为：

$$
S(\theta)
=
\frac{\partial}{\partial\theta}\log f(X;\theta)
=
-\frac1\theta+\frac{X-1}{\theta(\theta-1)}.
$$

通分：

$$
S(\theta)
=
\frac{X-\theta}{\theta(\theta-1)}.
$$

因此：

$$
I(\theta)
=
\operatorname{Var}[S(\theta)]
=
\frac{\operatorname{Var}(X)}
{\theta^2(\theta-1)^2}.
$$

又因为：

$$
\operatorname{Var}(X)=\theta(\theta-1),
$$

所以：

$$
\boxed{
I(\theta)=\frac{1}{\theta(\theta-1)}
}
$$

注意：这是单个总体分布的 Fisher 信息量，不是样本总信息量。

---

### 3）有效性

估计 $\theta$ 本身，Rao-Cramer 下界为：

$$
RCB
=
\frac{1}{nI(\theta)}
=
\frac{\theta(\theta-1)}{n}.
$$

而：

$$
\hat\theta=\bar X,
$$

所以：

$$
\operatorname{Var}(\hat\theta)
=
\operatorname{Var}(\bar X)
=
\frac{\theta(\theta-1)}{n}.
$$

因此：

$$
\operatorname{Var}(\hat\theta)=RCB.
$$

所以 $\bar X$ 是有效估计量，有效性为：

$$
\boxed{
e(\hat\theta)=1
}
$$

---

# 2. Gamma 分布：精确似然比检验（15 分）

设 $X_1,\dots,X_n\sim \Gamma(c,\theta)$，其中 $c>0$ 已知，$\theta>0$ 未知，密度为：

$$
f(x;\theta)
=
\frac{1}{\Gamma(c)\theta^c}
x^{c-1}e^{-x/\theta},
\qquad x>0.
$$

考虑检验：

$$
H_0:\theta=\theta_0
\quad vs\quad
H_1:\theta\neq\theta_0.
$$

令：

$$
Y=\sum_{i=1}^n X_i.
$$

已知：

$$
Y\sim \Gamma(nc,\theta).
$$

1. 写出似然比统计量 $\Lambda$；
2. 将拒绝域转化为关于 $Y$ 的区域；
3. 写出显著水平为 $\alpha$ 的精确拒绝域。

---

## 标准答案

### 1）似然函数与 MLE

似然函数为：

$$
L(\theta)
=
\prod_{i=1}^n
\frac{1}{\Gamma(c)\theta^c}
X_i^{c-1}e^{-X_i/\theta}.
$$

整理得：

$$
L(\theta)
=
\frac{1}{\Gamma(c)^n}
\left(\prod_{i=1}^n X_i^{c-1}\right)
\theta^{-nc}
\exp\left(-\frac{Y}{\theta}\right).
$$

对数似然为：

$$
\ell(\theta)
=
C
-
nc\log\theta
-
\frac{Y}{\theta},
$$

其中 $C$ 与 $\theta$ 无关。

求导：

$$
\ell'(\theta)
=
-\frac{nc}{\theta}
+
\frac{Y}{\theta^2}.
$$

令导数为 0：

$$
-\frac{nc}{\theta}+\frac{Y}{\theta^2}=0.
$$

得到：

$$
\hat\theta=\frac{Y}{nc}.
$$

似然比统计量为：

$$
\Lambda
=
\frac{L(\theta_0)}{L(\hat\theta)}.
$$

代入可得：

$$
\Lambda
=
\left(
\frac{\hat\theta}{\theta_0}
\right)^{nc}
\exp\left(
-\frac{Y}{\theta_0}
+\frac{Y}{\hat\theta}
\right).
$$

因为：

$$
\hat\theta=\frac{Y}{nc},
\qquad
\frac{Y}{\hat\theta}=nc,
$$

所以：

$$
\boxed{
\Lambda
=
\left(
\frac{Y}{nc\theta_0}
\right)^{nc}
\exp\left(
nc-\frac{Y}{\theta_0}
\right)
}
$$

等价地，可以写：

$$
-2\log\Lambda
=
2\left[
\frac{Y}{\theta_0}
-
nc
-
nc\log\left(
\frac{Y}{nc\theta_0}
\right)
\right].
$$

---

### 2）拒绝域关于 $Y$ 的形式

LRT 拒绝域为：

$$
\Lambda\leq k.
$$

令：

$$
t=\frac{Y}{nc\theta_0}.
$$

则：

$$
\Lambda=t^{nc}e^{nc(1-t)}.
$$

$\Lambda$ 在 $t=1$ 即

$$
Y=nc\theta_0
$$

处最大，向左右两侧偏离时变小。

所以：

$$
\Lambda\leq k
$$

等价于：

$$
Y\leq a
\quad \text{或}\quad
Y\geq b,
$$

其中：

$$
a<nc\theta_0<b.
$$

---

### 3）显著水平为 $\alpha$ 的精确拒绝域

在 $H_0$ 下：

$$
Y\sim \Gamma(nc,\theta_0).
$$

记 $\Gamma_\beta(nc,\theta_0)$ 为该分布的上 $\beta$ 分位数，即：

$$
P(Y\geq \Gamma_\beta(nc,\theta_0))=\beta.
$$

则可以取双尾拒绝域：

$$
\boxed{
Y\leq \Gamma_{1-\alpha/2}(nc,\theta_0)
\quad \text{或}\quad
Y\geq \Gamma_{\alpha/2}(nc,\theta_0)
}
$$

也就是：

$$
\boxed{
\sum_{i=1}^n X_i\leq \Gamma_{1-\alpha/2}(nc,\theta_0)
\quad \text{或}\quad
\sum_{i=1}^n X_i\geq \Gamma_{\alpha/2}(nc,\theta_0)
}
$$

---

# 3. 瑞利分布：正则指数族、MLE、RCB 与有效性（15 分）

设 $X_1,\dots,X_n$ 来自瑞利分布：

$$
f(x;\sigma)
=
\frac{x}{\sigma^2}
\exp\left(
-\frac{x^2}{2\sigma^2}
\right),
\qquad x>0,\quad \sigma>0.
$$

令：

$$
\eta=\sigma^2.
$$

1. 判断该分布是否属于正则指数分布类，并写出完备充分统计量；
2. 求 $\eta$ 的 MLE；
3. 求 $\eta$ 的 Rao-Cramer 下界，并判断 MLE 是否有效。

---

## 标准答案

### 1）指数族形式与完备充分统计量

将密度写成关于 $\eta$ 的形式：

$$
f(x;\eta)
=
\frac{x}{\eta}
\exp\left(
-\frac{x^2}{2\eta}
\right),
\qquad x>0.
$$

取指数形式：

$$
f(x;\eta)
=
\exp\left\{
-\frac{1}{2\eta}x^2
+
\log x
-
\log\eta
\right\}.
$$

因此它属于正则指数分布类，其中：

$$
K(x)=x^2.
$$

支撑集 $x>0$ 不依赖于 $\eta$。

所以完备充分统计量为：

$$
\boxed{
T=\sum_{i=1}^n X_i^2
}
$$

---

### 2）求 $\eta$ 的 MLE

似然函数为：

$$
L(\eta)
=
\prod_{i=1}^n
\frac{X_i}{\eta}
\exp\left(
-\frac{X_i^2}{2\eta}
\right).
$$

对数似然为：

$$
\ell(\eta)
=
\sum_{i=1}^n\log X_i
-
n\log\eta
-
\frac{1}{2\eta}
\sum_{i=1}^n X_i^2.
$$

求导：

$$
\ell'(\eta)
=
-\frac{n}{\eta}
+
\frac{1}{2\eta^2}
\sum_{i=1}^n X_i^2.
$$

令导数为 0：

$$
-\frac{n}{\eta}
+
\frac{T}{2\eta^2}
=0.
$$

得到：

$$
\boxed{
\hat\eta
=
\frac{T}{2n}
=
\frac{1}{2n}\sum_{i=1}^n X_i^2
}
$$

也就是：

$$
\widehat{\sigma^2}
=
\frac{1}{2n}\sum_{i=1}^n X_i^2.
$$

---

### 3）RCB 与有效性

单个样本的对数密度为：

$$
\log f(X;\eta)
=
\log X-\log\eta-\frac{X^2}{2\eta}.
$$

得分函数为：

$$
\frac{\partial}{\partial\eta}\log f(X;\eta)
=
-\frac1\eta+\frac{X^2}{2\eta^2}.
$$

瑞利分布中：

$$
X^2\sim Exp\left(\text{均值 }2\eta\right).
$$

所以：

$$
E(X^2)=2\eta,
\qquad
\operatorname{Var}(X^2)=4\eta^2.
$$

Fisher 信息量为：

$$
I(\eta)
=
\operatorname{Var}
\left(
-\frac1\eta+\frac{X^2}{2\eta^2}
\right)
=
\frac{1}{4\eta^4}\operatorname{Var}(X^2).
$$

代入：

$$
I(\eta)
=
\frac{1}{4\eta^4}\cdot 4\eta^2
=
\frac{1}{\eta^2}.
$$

因此：

$$
RCB
=
\frac{1}{nI(\eta)}
=
\frac{\eta^2}{n}.
$$

再计算 MLE 的方差：

$$
\hat\eta=\frac{T}{2n}.
$$

由于：

$$
\operatorname{Var}(T)
=
n\operatorname{Var}(X^2)
=
4n\eta^2,
$$

所以：

$$
\operatorname{Var}(\hat\eta)
=
\frac{1}{4n^2}\operatorname{Var}(T)
=
\frac{1}{4n^2}\cdot 4n\eta^2
=
\frac{\eta^2}{n}.
$$

因此：

$$
\operatorname{Var}(\hat\eta)=RCB.
$$

所以：

$$
\boxed{
\hat\eta=\frac{1}{2n}\sum X_i^2
\text{ 是 } \eta=\sigma^2 \text{ 的有效估计量}
}
$$

有效性为：

$$
\boxed{
e(\hat\eta)=1
}
$$

---

# 4. Beta$(\theta,1)$ 分布：MLE、RCB、纠偏与最优拒绝域（18 分）

设 $X_1,\dots,X_n$ 来自分布：

$$
f(x;\theta)=\theta x^{\theta-1},
\qquad 0<x<1,\quad \theta>0.
$$

1. 判断它是否属于正则指数分布类，并写出完备充分统计量；
2. 求 $\theta$ 的 MLE；
3. 求 Fisher 信息量和 $\theta$ 的 RCB；
4. 判断 MLE 是否无偏。若有偏，请构造一个无偏估计并计算其有效性；
5. 对检验 $H_0:\theta=\theta_0$ vs $H_1:\theta=\theta_1$，其中 $\theta_1>\theta_0$，给出 Neyman-Pearson 最优拒绝域的形式。

---

## 标准答案

### 1）正则指数族与完备充分统计量

密度可写为：

$$
f(x;\theta)
=
\theta x^{\theta-1}
=
\exp\{\log\theta+(\theta-1)\log x\}.
$$

进一步：

$$
f(x;\theta)
=
\exp\{
\theta\log x+\log\theta-\log x
\}.
$$

这是正则指数族形式，且支撑集 $(0,1)$ 不依赖 $\theta$。

因此完备充分统计量可以取：

$$
T=\sum_{i=1}^n \log X_i.
$$

也可以取：

$$
W=-\sum_{i=1}^n \log X_i.
$$

下面使用：

$$
\boxed{
W=-\sum_{i=1}^n\log X_i
}
$$

---

### 2）求 MLE

对数似然函数为：

$$
\ell(\theta)
=
n\log\theta
+
(\theta-1)\sum_{i=1}^n\log X_i.
$$

求导：

$$
\ell'(\theta)
=
\frac{n}{\theta}
+
\sum_{i=1}^n\log X_i.
$$

令 $\ell'(\theta)=0$：

$$
\frac{n}{\theta}
+
\sum_{i=1}^n\log X_i=0.
$$

所以：

$$
\hat\theta
=
-\frac{n}{\sum_{i=1}^n\log X_i}
=
\frac{n}{W}.
$$

即：

$$
\boxed{
\hat\theta=\frac{n}{W}
}
$$

---

### 3）Fisher 信息量和 RCB

单个样本的对数密度为：

$$
\log f(X;\theta)
=
\log\theta+(\theta-1)\log X.
$$

一阶导数为：

$$
\frac{\partial}{\partial\theta}\log f(X;\theta)
=
\frac1\theta+\log X.
$$

二阶导数为：

$$
\frac{\partial^2}{\partial\theta^2}\log f(X;\theta)
=
-\frac{1}{\theta^2}.
$$

所以：

$$
I(\theta)
=
-
E\left[
\frac{\partial^2}{\partial\theta^2}\log f(X;\theta)
\right]
=
\frac{1}{\theta^2}.
$$

因此：

$$
RCB
=
\frac{1}{nI(\theta)}
=
\frac{\theta^2}{n}.
$$

即：

$$
\boxed{
RCB=\frac{\theta^2}{n}
}
$$

---

### 4）MLE 的无偏性、纠偏与有效性

令：

$$
W=-\sum_{i=1}^n\log X_i.
$$

对于 $X\sim Beta(\theta,1)$，有：

$$
-\log X\sim Exp(\text{rate } \theta).
$$

所以：

$$
W\sim Gamma(n,\text{rate } \theta).
$$

已知当 $n>2$ 时：

$$
E\left(\frac1W\right)=\frac{\theta}{n-1},
$$

$$
E\left(\frac1{W^2}\right)
=
\frac{\theta^2}{(n-1)(n-2)}.
$$

MLE 为：

$$
\hat\theta=\frac{n}{W}.
$$

因此：

$$
E(\hat\theta)
=
nE\left(\frac1W\right)
=
\frac{n\theta}{n-1}.
$$

所以 MLE 有偏。

构造无偏估计：

$$
\tilde\theta=\frac{n-1}{W}.
$$

因为：

$$
E(\tilde\theta)
=
(n-1)E\left(\frac1W\right)
=
\theta.
$$

再计算方差：

$$
E(\tilde\theta^2)
=
(n-1)^2E\left(\frac1{W^2}\right)
=
(n-1)^2
\cdot
\frac{\theta^2}{(n-1)(n-2)}.
$$

所以：

$$
E(\tilde\theta^2)
=
\frac{n-1}{n-2}\theta^2.
$$

因此：

$$
\operatorname{Var}(\tilde\theta)
=
E(\tilde\theta^2)-[E(\tilde\theta)]^2
=
\frac{n-1}{n-2}\theta^2-\theta^2.
$$

整理得：

$$
\operatorname{Var}(\tilde\theta)
=
\frac{\theta^2}{n-2}.
$$

有效性为：

$$
e(\tilde\theta)
=
\frac{RCB}{\operatorname{Var}(\tilde\theta)}
=
\frac{\theta^2/n}{\theta^2/(n-2)}
=
\frac{n-2}{n}.
$$

所以：

$$
\boxed{
\tilde\theta=\frac{n-1}{-\sum_{i=1}^n\log X_i}
}
$$

是 $\theta$ 的无偏估计，有效性为：

$$
\boxed{
e(\tilde\theta)=\frac{n-2}{n}
}
$$

---

### 5）Neyman-Pearson 最优拒绝域

似然函数为：

$$
L(\theta)
=
\theta^n
\prod_{i=1}^n X_i^{\theta-1}.
$$

似然比为：

$$
\frac{L(\theta_0)}{L(\theta_1)}
=
\left(\frac{\theta_0}{\theta_1}\right)^n
\prod_{i=1}^n X_i^{\theta_0-\theta_1}.
$$

因为：

$$
\theta_1>\theta_0,
$$

所以：

$$
\theta_0-\theta_1<0.
$$

令：

$$
W=-\sum_{i=1}^n\log X_i.
$$

则：

$$
\prod X_i^{\theta_0-\theta_1}
=
\exp\left\{
(\theta_0-\theta_1)\sum \log X_i
\right\}
=
\exp\left\{
(\theta_1-\theta_0)W
\right\}.
$$

因此：

$$
\frac{L(\theta_0)}{L(\theta_1)}
$$

关于 $W$ 单调递增。

Neyman-Pearson 拒绝域为：

$$
\frac{L(\theta_0)}{L(\theta_1)}\leq k.
$$

所以等价于：

$$
W\leq c.
$$

即：

$$
\boxed{
-\sum_{i=1}^n\log X_i\leq c
}
$$

也可以写为：

$$
\boxed{
\prod_{i=1}^n X_i\geq c'
}
$$

---

# 5. 指数分布与均匀分布：参数函数的 MVUE（16 分）

## 5.1 指数分布

设：

$$
X_1,\dots,X_n\sim Exp(1/\theta),
$$

其中 $\theta>0$ 是均值参数。求：

$$
g(\theta)=a\theta^2+b\theta+c
$$

的 MVUE，其中 $a,b,c$ 为已知常数。

---

## 标准答案

对于均值参数为 $\theta$ 的指数分布：

$$
E(X)=\theta,
\qquad
\operatorname{Var}(X)=\theta^2.
$$

完备充分统计量为：

$$
T=\sum_{i=1}^n X_i.
$$

首先：

$$
E(\bar X)=\theta.
$$

所以 $\bar X$ 是 $\theta$ 的无偏估计，且是 $T$ 的函数，因此是 $\theta$ 的 MVUE。

其次：

$$
E(\bar X^2)
=
[E(\bar X)]^2+\operatorname{Var}(\bar X).
$$

由于：

$$
\operatorname{Var}(\bar X)
=
\frac{\theta^2}{n},
$$

所以：

$$
E(\bar X^2)
=
\theta^2+\frac{\theta^2}{n}
=
\frac{n+1}{n}\theta^2.
$$

因此：

$$
\frac{n}{n+1}\bar X^2
$$

是 $\theta^2$ 的无偏估计，又是 $T$ 的函数，所以是 $\theta^2$ 的 MVUE。

于是：

$$
\boxed{
\widehat{g(\theta)}_{MVUE}
=
a\frac{n}{n+1}\bar X^2
+
b\bar X
+
c
}
$$

---

## 5.2 均匀分布

设：

$$
X_1,\dots,X_n\sim U(0,\theta).
$$

求：

$$
g(\theta)=a\theta^2+b\theta+c
$$

的 MVUE。

提示：$Y=X_{(n)}=\max_i X_i$ 是完备充分统计量，且密度为：

$$
f_Y(y;\theta)=\frac{ny^{n-1}}{\theta^n},
\qquad 0<y<\theta.
$$

---

## 标准答案

首先计算：

$$
E(Y)
=
\int_0^\theta y\frac{ny^{n-1}}{\theta^n}\,dy
=
\frac{n}{\theta^n}
\int_0^\theta y^n\,dy.
$$

所以：

$$
E(Y)
=
\frac{n}{\theta^n}\cdot \frac{\theta^{n+1}}{n+1}
=
\frac{n}{n+1}\theta.
$$

因此：

$$
\frac{n+1}{n}Y
$$

是 $\theta$ 的无偏估计。

再计算：

$$
E(Y^2)
=
\int_0^\theta y^2\frac{ny^{n-1}}{\theta^n}\,dy
=
\frac{n}{\theta^n}
\int_0^\theta y^{n+1}\,dy.
$$

所以：

$$
E(Y^2)
=
\frac{n}{\theta^n}\cdot \frac{\theta^{n+2}}{n+2}
=
\frac{n}{n+2}\theta^2.
$$

因此：

$$
\frac{n+2}{n}Y^2
$$

是 $\theta^2$ 的无偏估计。

由于它们都是完备充分统计量 $Y$ 的函数，所以由 Lehmann-Scheffe 定理可知，所求 MVUE 为：

$$
\boxed{
\widehat{g(\theta)}_{MVUE}
=
a\frac{n+2}{n}Y^2
+
b\frac{n+1}{n}Y
+
c
}
$$

其中：

$$
Y=X_{(n)}.
$$

---

# 6. $Bin(2,\theta)$ 分布：Rao-Blackwell 与直接构造 MVUE（16 分）

设：

$$
X_1,\dots,X_n\sim Bin(2,\theta).
$$

令：

$$
S=\sum_{i=1}^n X_i.
$$

求：

$$
g(\theta)=\theta+\theta^2
$$

的 MVUE。

要求：

1. 先构造一个只依赖于 $X_1$ 的无偏估计，再 Rao-Blackwell 化；
2. 再用 $S$ 的矩直接构造一次。

---

## 标准答案

### 方法一：Rao-Blackwell 化

对于：

$$
X_1\sim Bin(2,\theta),
$$

有：

$$
P(X_1=0)=(1-\theta)^2,
$$

$$
P(X_1=1)=2\theta(1-\theta),
$$

$$
P(X_1=2)=\theta^2.
$$

构造：

$$
U=
\frac12 I_{\{X_1=1\}}
+
2I_{\{X_1=2\}}.
$$

则：

$$
E(U)
=
\frac12 P(X_1=1)+2P(X_1=2).
$$

代入：

$$
E(U)
=
\frac12\cdot 2\theta(1-\theta)+2\theta^2.
$$

所以：

$$
E(U)
=
\theta(1-\theta)+2\theta^2
=
\theta+\theta^2.
$$

因此 $U$ 是 $g(\theta)$ 的无偏估计。

由于：

$$
S=\sum_{i=1}^n X_i\sim Bin(2n,\theta),
$$

所以 $S$ 是完备充分统计量。

由 Rao-Blackwell 定理和 Lehmann-Scheffe 定理，MVUE 为：

$$
E(U\mid S).
$$

给定 $S=s$，相当于在总共 $2n$ 次 Bernoulli 试验中有 $s$ 次成功，而 $X_1$ 是前 2 次试验中的成功次数。因此：

$$
X_1\mid S=s
$$

服从超几何分布。

有：

$$
P(X_1=1\mid S=s)
=
\frac{\binom21\binom{2n-2}{s-1}}{\binom{2n}{s}},
$$

$$
P(X_1=2\mid S=s)
=
\frac{\binom22\binom{2n-2}{s-2}}{\binom{2n}{s}}.
$$

所以：

$$
E(U\mid S=s)
=
\frac12P(X_1=1\mid S=s)
+
2P(X_1=2\mid S=s).
$$

第一项：

$$
\frac12P(X_1=1\mid S=s)
=
\frac{\binom{2n-2}{s-1}}{\binom{2n}{s}}.
$$

化简：

$$
\frac{\binom{2n-2}{s-1}}{\binom{2n}{s}}
=
\frac{s(2n-s)}{2n(2n-1)}.
$$

第二项：

$$
2P(X_1=2\mid S=s)
=
2\frac{\binom{2n-2}{s-2}}{\binom{2n}{s}}.
$$

化简：

$$
2\frac{\binom{2n-2}{s-2}}{\binom{2n}{s}}
=
\frac{2s(s-1)}{2n(2n-1)}.
$$

因此：

$$
E(U\mid S=s)
=
\frac{s(2n-s)+2s(s-1)}{2n(2n-1)}.
$$

整理分子：

$$
s(2n-s)+2s(s-1)
=
2ns-s^2+2s^2-2s
=
s^2+2(n-1)s.
$$

所以：

$$
E(U\mid S=s)
=
\frac{s^2+2(n-1)s}{2n(2n-1)}.
$$

于是：

$$
\boxed{
\widehat{g(\theta)}_{MVUE}
=
\frac{S^2+2(n-1)S}{2n(2n-1)}
}
$$

---

### 方法二：直接构造

由于：

$$
S\sim Bin(2n,\theta),
$$

所以：

$$
E(S)=2n\theta.
$$

因此：

$$
\frac{S}{2n}
$$

是 $\theta$ 的无偏估计。

又因为二项分布中：

$$
E[S(S-1)]=2n(2n-1)\theta^2.
$$

所以：

$$
\frac{S(S-1)}{2n(2n-1)}
$$

是 $\theta^2$ 的无偏估计。

因此：

$$
\theta+\theta^2
$$

的无偏估计为：

$$
\frac{S}{2n}
+
\frac{S(S-1)}{2n(2n-1)}.
$$

通分：

$$
\frac{S}{2n}
=
\frac{S(2n-1)}{2n(2n-1)}.
$$

所以：

$$
\frac{S}{2n}
+
\frac{S(S-1)}{2n(2n-1)}
=
\frac{S(2n-1)+S(S-1)}{2n(2n-1)}.
$$

整理：

$$
=
\frac{S^2+2(n-1)S}{2n(2n-1)}.
$$

由于它是完备充分统计量 $S$ 的函数，所以是 MVUE。

最终：

$$
\boxed{
\widehat{g(\theta)}_{MVUE}
=
\frac{S^2+2(n-1)S}{2n(2n-1)}
}
$$

---

# 7. Poisson 分布：复杂参数函数的 MVUE（15 分）

设：

$$
X_1,\dots,X_n\sim Po(\theta),
\qquad n\geq 3.
$$

令：

$$
S=\sum_{i=1}^n X_i.
$$

求：

$$
g(\theta)=e^{-2\theta}+\theta e^{-2\theta}
$$

的 MVUE。

---

## 标准答案

### 第一步：找一个粗糙无偏估计

注意：

$$
X_1+X_2\sim Po(2\theta).
$$

令：

$$
Z=X_1+X_2.
$$

则：

$$
P(Z=0)=e^{-2\theta},
$$

$$
P(Z=1)=2\theta e^{-2\theta}.
$$

因此：

$$
\frac12 P(Z=1)=\theta e^{-2\theta}.
$$

构造：

$$
U=I_{\{Z=0\}}+\frac12 I_{\{Z=1\}}.
$$

则：

$$
E(U)
=
P(Z=0)+\frac12P(Z=1).
$$

所以：

$$
E(U)
=
e^{-2\theta}+\theta e^{-2\theta}
=
g(\theta).
$$

因此 $U$ 是 $g(\theta)$ 的无偏估计。

---

### 第二步：找完备充分统计量

Poisson 样本中：

$$
S=\sum_{i=1}^n X_i
$$

是 $\theta$ 的完备充分统计量。

所以由 Rao-Blackwell 定理和 Lehmann-Scheffe 定理，MVUE 为：

$$
E(U\mid S).
$$

---

### 第三步：计算条件期望

给定：

$$
S=s,
$$

由于 Poisson 分裂性质：

$$
Z=X_1+X_2\mid S=s
\sim
Bin\left(s,\frac2n\right).
$$

因此：

$$
P(Z=0\mid S=s)
=
\left(1-\frac2n\right)^s.
$$

以及：

$$
P(Z=1\mid S=s)
=
\binom{s}{1}
\frac2n
\left(1-\frac2n\right)^{s-1}.
$$

所以：

$$
E(U\mid S=s)
=
P(Z=0\mid S=s)
+
\frac12P(Z=1\mid S=s).
$$

代入：

$$
E(U\mid S=s)
=
\left(1-\frac2n\right)^s
+
\frac12
\cdot
s\frac2n
\left(1-\frac2n\right)^{s-1}.
$$

整理得：

$$
E(U\mid S=s)
=
\left(1-\frac2n\right)^s
+
\frac{s}{n}
\left(1-\frac2n\right)^{s-1}.
$$

因此：

$$
\boxed{
\widehat{g(\theta)}_{MVUE}
=
\left(1-\frac2n\right)^S
+
\frac{S}{n}
\left(1-\frac2n\right)^{S-1}
}
$$

其中：

$$
S=\sum_{i=1}^n X_i.
$$

---

# 8. Bernoulli 分布：LRT、Wald 型与 Score 型检验统计量（15 分）

设：

$$
X_1,\dots,X_n\sim Bernoulli(\theta).
$$

考虑检验：

$$
H_0:\theta=\theta_0
\quad vs\quad
H_1:\theta\neq \theta_0,
$$

其中：

$$
0<\theta_0<1.
$$

令：

$$
\hat\theta=\bar X.
$$

1. 写出似然比检验统计量；
2. 写出 Wald 型检验统计量；
3. 写出 Score 型检验统计量；
4. 给出三者的大样本拒绝规则。

---

## 标准答案

### 1）似然比检验统计量

Bernoulli 样本对数似然函数为：

$$
\ell(\theta)
=
\sum_{i=1}^n
\left[
X_i\log\theta+(1-X_i)\log(1-\theta)
\right].
$$

令：

$$
\bar X=\frac1n\sum_{i=1}^nX_i.
$$

则：

$$
\ell(\theta)
=
n\bar X\log\theta
+
n(1-\bar X)\log(1-\theta).
$$

MLE 为：

$$
\hat\theta=\bar X.
$$

似然比检验统计量为：

$$
\chi_L^2
=
2[\ell(\hat\theta)-\ell(\theta_0)].
$$

代入：

$$
\ell(\hat\theta)
=
n\bar X\log\bar X
+
n(1-\bar X)\log(1-\bar X),
$$

$$
\ell(\theta_0)
=
n\bar X\log\theta_0
+
n(1-\bar X)\log(1-\theta_0).
$$

所以：

$$
\boxed{
\chi_L^2
=
2n\left[
\bar X\log\left(\frac{\bar X}{\theta_0}\right)
+
(1-\bar X)
\log\left(\frac{1-\bar X}{1-\theta_0}\right)
\right]
}
$$

其中 $0\log 0$ 按极限理解为 0。

---

### 2）Wald 型检验统计量

单个 Bernoulli 分布的 Fisher 信息量为：

$$
I(\theta)=\frac{1}{\theta(1-\theta)}.
$$

Wald 型统计量为：

$$
\chi_W^2
=
nI(\hat\theta)(\hat\theta-\theta_0)^2.
$$

代入：

$$
I(\hat\theta)
=
\frac{1}{\hat\theta(1-\hat\theta)}
=
\frac{1}{\bar X(1-\bar X)}.
$$

得到：

$$
\boxed{
\chi_W^2
=
\frac{n(\bar X-\theta_0)^2}{\bar X(1-\bar X)}
}
$$

---

### 3）Score 型检验统计量

样本对数似然的一阶导数为：

$$
\ell'(\theta)
=
\frac{\sum X_i}{\theta}
-
\frac{n-\sum X_i}{1-\theta}.
$$

因为：

$$
\sum X_i=n\bar X,
$$

所以：

$$
\ell'(\theta)
=
\frac{n\bar X}{\theta}
-
\frac{n(1-\bar X)}{1-\theta}.
$$

代入 $\theta_0$：

$$
\ell'(\theta_0)
=
\frac{n\bar X}{\theta_0}
-
\frac{n(1-\bar X)}{1-\theta_0}.
$$

通分得：

$$
\ell'(\theta_0)
=
\frac{n(\bar X-\theta_0)}
{\theta_0(1-\theta_0)}.
$$

Score 型统计量为：

$$
\chi_R^2
=
\frac{[\ell'(\theta_0)]^2}{nI(\theta_0)}.
$$

又：

$$
I(\theta_0)
=
\frac{1}{\theta_0(1-\theta_0)}.
$$

所以：

$$
nI(\theta_0)
=
\frac{n}{\theta_0(1-\theta_0)}.
$$

因此：

$$
\chi_R^2
=
\frac{
\left[
\dfrac{n(\bar X-\theta_0)}
{\theta_0(1-\theta_0)}
\right]^2
}
{
\dfrac{n}{\theta_0(1-\theta_0)}
}.
$$

化简：

$$
\boxed{
\chi_R^2
=
\frac{n(\bar X-\theta_0)^2}
{\theta_0(1-\theta_0)}
}
$$

---

### 4）大样本拒绝规则

在 $H_0$ 下，三种统计量都有渐近分布：

$$
\chi^2(1).
$$

所以显著性水平为 $\alpha$ 时，拒绝域为：

$$
\boxed{
\chi_L^2>\chi^2_{1,\alpha}
}
$$

或：

$$
\boxed{
\chi_W^2>\chi^2_{1,\alpha}
}
$$

或：

$$
\boxed{
\chi_R^2>\chi^2_{1,\alpha}
}
$$

其中 $\chi^2_{1,\alpha}$ 表示自由度为 1 的卡方分布上 $\alpha$ 分位数。

---

# 四、答案速查

## 判断题答案

| 题号 | 答案 |
|---|---|
| 1 | T |
| 2 | F |
| 3 | F |
| 4 | T |
| 5 | F |
| 6 | T |
| 7 | T |
| 8 | T |
| 9 | F |
| 10 | T |
| 11 | F |
| 12 | F |
| 13 | T |
| 14 | F |
| 15 | T |

---

## 单选题答案

| 题号 | 答案 |
|---|---|
| 1 | C |
| 2 | D |
| 3 | C |
| 4 | B |
| 5 | C |
| 6 | B |
| 7 | A |
| 8 | C |
| 9 | A |
| 10 | B |
| 11 | C |
| 12 | C |
| 13 | D |
| 14 | B |
| 15 | D |

---

# 五、这套卷子的复习指向

这套卷子的重点不是单纯套公式，而是考察以下能力：

1. 能否区分 Fisher 信息量 $I(\theta)$ 与样本总信息量 $nI(\theta)$。
2. 能否正确使用 Rao-Cramer 下界：
   $$
   RCB=\frac{[g'(\theta)]^2}{nI(\theta)}.
   $$
3. 能否判断一个分布是否属于正则指数族，并写出：
   $$
   T=\sum K(X_i).
   $$
4. 能否区分充分、完备充分、最小充分、一一变换。
5. 能否用 Lehmann-Scheffe 定理判断 MVUE。
6. 能否先构造粗糙无偏估计，再用：
   $$
   E(U\mid T)
   $$
   做 Rao-Blackwell 化。
7. 能否正确写 LRT：
   $$
   \Lambda=\frac{L(\theta_0)}{L(\hat\theta)}
   $$
   并判断拒绝域方向。
8. 能否使用 Neyman-Pearson 引理将似然比拒绝域化成关于充分统计量的区域。
9. 能否掌握 Bernoulli、Poisson、Exponential、Gamma、Uniform、Rayleigh、Beta、Binomial 等经典模型的常见推导。