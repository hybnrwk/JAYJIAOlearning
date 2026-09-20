# 第 2 章 · 简单线性回归：中英对照讲义

> **材料依据：** 《高维数据分析》第二讲《简单线性回归》，袁洪松，lecture02，第 1—6 页；Sanford Weisberg, *Applied Linear Regression*, 4th ed., Chapter 2, “Simple Linear Regression”，印刷页第 21—50 页。  
> **学习定位：** 中文负责解释，英文用于标注术语；以课件的推导与统计推断主线为骨架，用教材补足假设的作用、预测区间、残差诊断和 Forbes 案例。

**阅读顺序：** 先沿第 1—10 部分理解“模型—估计—抽样分布—区间—检验—预测—评价—诊断”；第 11—13 部分用于案例串联、解题和纠错；文末附术语索引与原文对应表。

**标记说明：** “课件主线”表示 lecture02 明确讲授的内容；“教材补充”表示 Weisberg Chapter 2 的重要内容；“理解补充”表示为打通概念和纠正常见误解加入的解释。

**建议三遍法：** 第一遍只理解第 1.2 节的六步主线和 A 级公式，暂时跳过 C 级公式；第二遍补上 B 级公式之间的因果关系；第三遍用第 12.4 节过关清单查漏补缺。遇到“配图建议”时再打开教材对应页，不必预先翻完所有图片。

## 1. 先看全章逻辑地图

### 1.1 一句话抓住本章

**简单线性回归（simple linear regression）先用一条直线描述 $Y$ 的条件均值怎样随 $X$ 改变，再用概率分布刻画样本围绕直线的随机波动。**

它不是只求一条“最贴近数据”的线，而是要依次回答四个问题：

1. **模型（model）**：我们对 $Y\mid X=x$ 作了什么假设？
2. **估计（estimation）**：怎样用样本求出斜率、截距和误差方差？
3. **推断（inference）**：估计有多不确定？斜率是否可能为某个给定值？
4. **预测与诊断（prediction and diagnostics）**：怎样预测新观测？模型假设是否可信？

> **先建立一个核心画面：** 把散点图在每个 $x$ 处竖着切一刀。切片中 $Y$ 的中心由 $\beta_0+\beta_1x$ 决定，切片的厚度由 $\sigma$ 决定。OLS 负责估计“中心线”，标准误负责衡量“这条估计线会晃动多大”，残差图负责检查“直线加等厚随机波动”的想象是否合理。

### 1.2 全章只走六步

先不要背公式，只记住每一步在解决哪个问题：

| 步骤 | 要回答的问题 | 核心对象 | 后面为什么需要它 |
|---:|---|---|---|
| 1. 建模型 | $Y$ 的中心怎样随 $X$ 改变？ | $\beta_0+\beta_1x$ 与误差 $e$ | 明确我们想估计什么 |
| 2. 拟合直线 | 哪条样本直线最合适？ | $\hat\beta_0,\hat\beta_1$ | 得到中心线的样本估计 |
| 3. 估计噪声 | 点偏离直线有多严重？ | residual、RSS、$\hat\sigma^2$ | 知道数据本身有多散 |
| 4. 衡量估计不确定性 | 换一批样本，直线会晃多大？ | standard error | 区分“估计值”与“真值” |
| 5. 做统计推断 | 参数可能在哪？某个假设可信吗？ | confidence interval、$t$-test、$p$-value | 给结论加上不确定性 |
| 6. 使用并检查模型 | 怎样预测？模型是否可信？ | prediction、$R^2$、residual plot | 防止只算不检查 |

整章主线就是

$$
\boxed{
\text{模型}
\longrightarrow
\text{拟合直线}
\longrightarrow
\text{估计噪声}
\longrightarrow
\text{估计量标准误}
\longrightarrow
\text{区间 / 检验 / 预测}
\longrightarrow
\text{诊断}
}.
$$

只要你始终知道自己位于哪一步，新术语就不会堆成一团。

### 1.3 公式分成三档

> **分级说明：** 这里按“理解本章的优先级”分档，不代替任课教师的具体考试范围。A 级要求会解释、会写、会使用；B 级要求理解来源并能在给出条件时使用；C 级第一遍知道用途即可，不应成为当前学习负担。

| 等级 | 公式或结论 | 你需要达到的程度 |
|---|---|---|
| **A｜必须掌握** | 模型；$\hat\beta_1,\hat\beta_0$；residual 与 RSS；$\hat\sigma^2$；standard error；置信区间；$t$ 检验；点预测；$R^2$ | 能用自己的话解释，并能代入计算 |
| **B｜理解并会使用** | MLE 为什么导向 OLS；估计量的方差；$\chi^2$ 与 $t$ 的联系；均值区间与个体预测区间；中心化；$R^2=r^2$ | 不必逐字背证明，但要说清因果关系 |
| **C｜知道即可** | 完整似然常数和求导细节；截距与斜率协方差的精确公式；Gauss-Markov 的严格表述；同时置信带的 $F$ 公式 | 知道它解决什么问题，第一遍可跳过 |

如果时间有限，先只学 A 级。A 级打通以后，B 级会自然变成解释 A 级公式的“为什么”；C 级用于补完整性，不应打断主线。

### 1.4 A 级公式最小集

第一轮只抓下面六组，不要一开始试图记住全章所有推导：

| 用途 | 必须掌握的公式 | 先读成一句什么话 |
|---|---|---|
| 模型 | $y_i=\beta_0+\beta_1x_i+e_i$ | 观测值 = 系统趋势 + 随机误差 |
| 拟合系数 | $\hat\beta_1=S_{XY}/S_{XX}$，$\hat\beta_0=\bar y-\hat\beta_1\bar x$ | 用共同变化估斜率，再让直线通过样本中心 |
| 残差与噪声 | $\hat e_i=y_i-\hat y_i$，$\mathrm{RSS}=\sum\hat e_i^2$，$\hat\sigma^2=\mathrm{RSS}/(n-2)$ | 先量剩余误差，再估计总体噪声 |
| 系数标准误 | $\operatorname{se}(\hat\beta_1)=\hat\sigma/\sqrt{S_{XX}}$ | 噪声越大越不准，$X$ 信息越多越准 |
| 区间与检验 | $\hat\beta_j\pm t\operatorname{se}(\hat\beta_j)$，$T=(\hat\beta_j-b_j)/\operatorname{se}(\hat\beta_j)$ | 区间是“估计值 ± 误差范围”；检验是“离假设值几个标准误” |
| 预测与拟合优度 | $\hat y_0=\hat\beta_0+\hat\beta_1x_0$，$R^2=1-\mathrm{RSS}/S_{YY}$ | 用拟合线预测，再看相对均值基准减少了多少误差 |

截距标准误、两种预测区间标准误等公式仍然重要，但可以在上面最小集稳定后再学。这样不会因为同时出现十几个符号而失去主线。

### 1.5 术语按四层归位

| 层次 | 这一层在说什么 | 主要符号与术语 |
|---|---|---|
| **真实模型层** | 总体中真正存在但未知的规律 | $\beta_0,\beta_1,\sigma^2$，statistical error |
| **样本拟合层** | 用当前样本算出来的结果 | $\hat\beta_0,\hat\beta_1,\hat y_i,\hat e_i$，RSS |
| **重复抽样层** | 如果重新取样，估计结果怎样波动 | variance、standard error、degrees of freedom、$t$ distribution |
| **结论与应用层** | 怎样报告、检验、预测和诊断 | confidence interval、$p$-value、prediction interval、$R^2$、residual plot |

最容易混乱的原因，是把不同层的量放在一起比较。例如 $\sigma$ 描述“数据点围绕真实直线的波动”，而 $\operatorname{se}(\hat\beta_1)$ 描述“估计斜率在重复抽样中的波动”；二者有关，但不是同一个量。

## 2. 简单线性回归模型

### 2.1 条件分布写法与误差写法

**A 级｜必须掌握：模型本体。**

**课件主线：** 给定 $X=x$，假设

$$
Y\mid X=x\sim N\!\left(\beta_0^*+\beta_1^*x,\sigma_*^2\right).
$$

对样本 $(x_i,y_i)$，等价地写成

$$
y_i=\beta_0^*+\beta_1^*x_i+e_i,\qquad i=1,\ldots,n,
$$

$$
e_1,\ldots,e_n\overset{\mathrm{i.i.d.}}{\sim}N(0,\sigma_*^2).
$$

其中星号表示真实但未知的参数（true but unknown parameters）。教材通常省略星号，写成 $\beta_0,\beta_1,\sigma^2$。本讲义在讲“真值”时保留星号，在通用公式中也会沿用教材的无星号记法；两者含义相同，不要误以为是两套模型。

数理统计基础不牢时，尤其要分清下面三件事：

| 名称 | 例子 | 是否固定 | 含义 |
|---|---|---|---|
| 参数（parameter） | $\beta_1^*$ | 固定但未知 | 总体中的真实斜率 |
| 估计量（estimator） | $\hat\beta_1=S_{XY}/S_{XX}$ | 取样前是随机变量 | 用样本估计真斜率的规则 |
| 估计值（estimate） | Forbes 数据中 $\hat\beta_1=0.895$ | 当前样本算出后是数值 | 这一次应用估计规则得到的结果 |

所谓“$\hat\beta_1$ 有抽样分布”，不是说真斜率在随机变化，而是说换一批样本会算出另一条拟合线，因而 $\hat\beta_1$ 会变化。

这个模型同时规定了：

$$
E(Y_i\mid X=x_i)=\beta_0^*+\beta_1^*x_i,
$$

$$
\operatorname{Var}(Y_i\mid X=x_i)=\sigma_*^2.
$$

这里不需要先陷入数理统计的抽象定义：

- $E(Y\mid X=x)$ 可以先理解为“把很多个 $X=x$ 的个体放在一起时，$Y$ 的平均中心”；
- $\operatorname{Var}(Y\mid X=x)$ 可以先理解为“这些个体在中心周围散得有多厚”。

第一式是线性均值函数（linear mean function），第二式是常方差函数（constant variance function）。

### 2.2 三个参数分别说什么

| 参数 | 英文 | 含义 |
|---|---|---|
| $\beta_0^*$ | intercept | 当 $x=0$ 时，$Y$ 的条件均值 |
| $\beta_1^*$ | slope | $x$ 每增加 1 个单位，$Y$ 的条件均值平均改变多少 |
| $\sigma_*^2$ | error variance | 在给定 $x$ 后，个体围绕均值直线的波动大小 |

斜率的单位是“$Y$ 的单位 / $X$ 的单位”。若 $\beta_1^*>0$，条件均值随 $x$ 增大而增大；若 $\beta_1^*<0$，则减小。

截距只有在 $x=0$ 有实际意义、或至少接近样本的 $x$ 范围时才容易解释。若所有观测都在 $x=200$ 附近，把截距解释为现实中的“$x=0$ 时结果”通常属于外推（extrapolation）。

> **配图建议：** 看教材 Figure 2.1（教材 PDF 第 2 页，印刷页第 22 页）。先遮住公式，只看直线在 $x=0$ 处的高度和 $x$ 增加 1 后的竖直变化：前者是 intercept，后者是 slope。看完后再回到上表解释两个参数。

### 2.3 五个假设分别负责什么

**A 级｜必须掌握：会说出每个假设在保护哪个结论，不必先背抽象名称。**

1. **线性（linearity）**：$E(Y\mid X=x)=\beta_0+\beta_1x$。它保证直线确实是要估计的均值结构。
2. **零均值误差（zero-mean errors）**：$E(e_i\mid x_i)=0$。它保证系统性部分已经进入均值函数。
3. **同方差（homoscedasticity）**：$\operatorname{Var}(e_i\mid x_i)=\sigma^2$。它支撑本章的标准误公式。
4. **独立（independence）**：不同观测的误差互不提供信息。时间序列、重复测量和群组数据常会违反这一点。
5. **正态（normality）**：$e_i\mid X\sim N(0,\sigma^2)$。它主要用来得到小样本下精确的 $t$ 检验、置信区间和预测区间。

还需要一个计算前提：

$$
S_{XX}=\sum_{i=1}^n(x_i-\bar x)^2>0.
$$

若所有 $x_i$ 都相同，就没有横向变化，斜率无法估计。

> **理解检查：** 两个个体的 $X$ 相同，模型是否要求它们的 $Y$ 也相同？不要求。模型只要求它们具有相同的条件均值和条件方差，实际响应仍可因误差而不同。

### 2.4 为什么课件把 $x_i$ 当作固定数

**课件主线：** 推导时不考虑 $x_1,\ldots,x_n$ 的随机性，把随机性全部放在 $Y$ 或误差 $e$ 上。

**理解补充：** 这不要求现实中的 $X$ 永远不是随机变量。即使 $X$ 来自随机抽样，也可以在已经观察到的 $X$ 上作条件推断（conditional inference）。因此很多公式严格写作

$$
E(\hat\beta_j\mid X),\qquad
\operatorname{Var}(\hat\beta_j\mid X).
$$

含义是：“在这组已经观测到的 $x_i$ 位置上，若重复生成响应 $Y$，估计量会怎样波动？”

## 3. 普通最小二乘估计

### 3.1 从极大似然到最小二乘

**B 级｜理解结论：** 正态误差下，最大化似然等价于最小化残差平方和。下面完整的似然表达式和求导常数属于 C 级，第一遍不用背，只需盯住其中的平方和。

**课件主线：** 在正态模型下，似然函数（likelihood function）可写成

$$
L(\beta_0,\beta_1,\sigma)
=
\prod_{i=1}^n
\frac{1}{\sigma\sqrt{2\pi}}
\exp\left\{
-\frac{(y_i-\beta_0-\beta_1x_i)^2}{2\sigma^2}
\right\}.
$$

对数似然（log-likelihood）为

$$
\ell(\beta_0,\beta_1,\sigma)
=
-n\log\sigma-\frac n2\log(2\pi)
-\frac{1}{2\sigma^2}
\sum_{i=1}^n(y_i-\beta_0-\beta_1x_i)^2.
$$

当 $\sigma$ 固定时，前两项不随 $\beta_0,\beta_1$ 改变。因此最大化似然等价于最小化

$$
\mathrm{RSS}(\beta_0,\beta_1)
=
\sum_{i=1}^n(y_i-\beta_0-\beta_1x_i)^2.
$$

这就是普通最小二乘法（ordinary least squares, OLS）。

> 正态模型下，OLS 估计与极大似然估计（maximum likelihood estimation, MLE）得到同一组 $\hat\beta_0,\hat\beta_1$；但计算 OLS 本身并不要求误差正态。

### 3.2 为什么平方的是竖直距离

**A 级｜必须理解：** OLS 最小化的是响应方向上的竖直残差，因此回归具有方向性。

对任意候选直线，点 $(x_i,y_i)$ 到直线在竖直方向的差为

$$
y_i-(\beta_0+\beta_1x_i).
$$

OLS 把 $Y$ 当作响应，把 $X$ 当作已知预测变量，所以最小化的是竖直残差，而不是点到直线的垂直几何距离。这也解释了回归 $Y$ 对 $X$ 与回归 $X$ 对 $Y$ 通常不是同一条线。

> **配图建议：** 看教材 Figure 2.2（教材 PDF 第 5 页，印刷页第 25 页）。图中的竖线段就是 residual：点在线上方时为正，在线下方时为负。OLS 所做的事，就是让这些竖线段长度的平方和最小。

### 3.3 三个中心化平方和

**A 级｜必须掌握：** 会计算 $S_{XX},S_{XY},S_{YY}$，更要知道它们分别表示“$X$ 的变化”“共同变化”“$Y$ 的变化”。

先定义

$$
\bar x=\frac1n\sum_{i=1}^n x_i,\qquad
\bar y=\frac1n\sum_{i=1}^n y_i,
$$

$$
S_{XX}=\sum_{i=1}^n(x_i-\bar x)^2,
$$

$$
S_{XY}=\sum_{i=1}^n(x_i-\bar x)(y_i-\bar y),
$$

$$
S_{YY}=\sum_{i=1}^n(y_i-\bar y)^2.
$$

它们分别描述 $X$ 的总变化、$X$ 与 $Y$ 的共同变化、以及 $Y$ 的总变化。

理解 $S_{XY}$ 时，可以逐点看乘积 $(x_i-\bar x)(y_i-\bar y)$：

- 点在“右上”或“左下”时，两个偏差同号，乘积为正；
- 点在“左上”或“右下”时，两个偏差异号，乘积为负；
- 把所有乘积相加，就得到 $X$ 与 $Y$ 同向变化还是反向变化的净结果。

因此

$$
\hat\beta_1
=
\frac{\text{共同变化 }S_{XY}}
{\text{预测变量自身的变化 }S_{XX}}
$$

可以读作“每一单位 $X$ 变化对应多少 $Y$ 变化”。这比死记 $\hat\beta_1=S_{XY}/S_{XX}$ 更重要。

### 3.4 OLS 的闭式解

**A 级｜核心公式：** 这是本章最重要的一组系数公式。

令 RSS 对 $\beta_0,\beta_1$ 的偏导数为 0，得到正规方程（normal equations）：

$$
\sum_{i=1}^n(y_i-\beta_0-\beta_1x_i)=0,
$$

$$
\sum_{i=1}^n x_i(y_i-\beta_0-\beta_1x_i)=0.
$$

解为

$$
\boxed{\hat\beta_1=\frac{S_{XY}}{S_{XX}}},
$$

$$
\boxed{\hat\beta_0=\bar y-\hat\beta_1\bar x}.
$$

所以拟合均值函数（fitted mean function）是

$$
\hat y(x)=\hat\beta_0+\hat\beta_1x.
$$

对第 $i$ 个样本，拟合值（fitted value）为

$$
\hat y_i=\hat\beta_0+\hat\beta_1x_i.
$$

可以用单位检查公式：$S_{XY}$ 的单位是 $X\times Y$，$S_{XX}$ 的单位是 $X^2$，所以 $\hat\beta_1$ 的单位是 $Y/X$，正好符合斜率含义。

### 3.5 三个必会的代数性质

**B 级｜会解释即可：** 这些性质帮助理解 OLS，不必把它们当作三条孤立公式硬背。

只要模型含截距，OLS 就有：

$$
\sum_{i=1}^n\hat e_i=0,
$$

$$
\sum_{i=1}^n x_i\hat e_i=0,
$$

$$
\hat y(\bar x)=\bar y.
$$

第三式说明拟合直线一定经过样本中心 $(\bar x,\bar y)$。前两式说明残差与常数项、预测变量在样本内正交（orthogonal）；它们是 OLS 最优化条件，不是额外的数据假设。

回到 Figure 2.2，你会看到 OLS 实线可能比表示真实均值函数的虚线更贴近这一批样本。这并不矛盾：OLS 专门针对当前样本最小化 RSS，真实直线并不会追随这一批样本中的随机噪声。**样本内贴得更紧，不等于离总体真相更近。**

### 3.6 统计误差与残差不能混

**A 级｜必须区分：** error 属于未知真实模型，residual 属于当前拟合结果。

统计误差（statistical error）是

$$
e_i=y_i-(\beta_0^*+\beta_1^*x_i).
$$

真实参数未知，所以 $e_i$ 不可观测。残差（residual）是

$$
\hat e_i=y_i-\hat y_i
=y_i-(\hat\beta_0+\hat\beta_1x_i),
$$

它可以由样本计算。

| 对比 | 统计误差 $e_i$ | 残差 $\hat e_i$ |
|---|---|---|
| 参照直线 | 真实均值函数 | 样本拟合直线 |
| 是否可直接观测 | 否 | 是 |
| 是否独立 | 模型可以假设独立 | 一般不独立 |
| 和是否必为 0 | 不一定 | 含截距的 OLS 中必为 0 |

残差平方和（residual sum of squares, RSS）为

$$
\mathrm{RSS}
=
\sum_{i=1}^n\hat e_i^2.
$$

它还可写成

$$
\boxed{\mathrm{RSS}
=S_{YY}-\frac{S_{XY}^2}{S_{XX}}
=S_{YY}-\hat\beta_1^2S_{XX}}.
$$

## 4. 误差方差为什么除以 $n-2$

### 4.1 极大似然估计与无偏估计

**优先级提示：** $\tilde\sigma^2=\mathrm{RSS}/n$ 属于 C 级，知道它是 MLE 且向下有偏即可；$\hat\sigma^2=\mathrm{RSS}/(n-2)$ 属于 A 级，必须会用。

对 $\sigma$ 最大化正态似然，可得

$$
\tilde\sigma^2=\frac{\mathrm{RSS}}{n}.
$$

这是 $\sigma^2$ 的极大似然估计，但

$$
E(\tilde\sigma^2\mid X)
=\frac{n-2}{n}\sigma^2,
$$

所以它向下有偏。

无偏估计（unbiased estimator）为

$$
\boxed{\hat\sigma^2=\frac{\mathrm{RSS}}{n-2}}.
$$

教材把它称为残差均方（residual mean square）。

### 4.2 两个自由度去哪了

**A 级｜必须理解：** 记住“估计了截距和斜率两个参数，所以残差自由度是 $n-2$”，并能用两点确定一条直线的例子解释。

自由度（degrees of freedom, df）可以理解为残差中还剩多少个可以自由变化的信息方向。

我们用数据估计了两个均值参数 $\beta_0$ 与 $\beta_1$，同时强制残差满足

$$
\sum\hat e_i=0,\qquad
\sum x_i\hat e_i=0.
$$

因此 $n$ 个残差只有 $n-2$ 个独立变化方向，残差自由度为

$$
\mathrm{df}_{\mathrm{res}}=n-2.
$$

一个极端例子能帮助理解：若只有两个横坐标不同的点，一条直线可以把两点完全连起来，RSS 必为 0。但这不代表现实中完全没有噪声，而是两个点的信息已经全部用来估计截距和斜率，剩余自由度 $2-2=0$，根本无法估计误差方差。

### 4.3 回归标准误

**A 级｜必须掌握：** $\hat\sigma$ 衡量的是数据点围绕拟合线的典型竖直波动。

$$
\hat\sigma=\sqrt{\frac{\mathrm{RSS}}{n-2}}
$$

称为回归标准误（standard error of regression）或残差标准差（residual standard deviation）。它与 $Y$ 同单位，粗略表示观测点围绕拟合直线的典型竖直波动。

它不是 $\hat\beta_0$ 或 $\hat\beta_1$ 的标准误；后两者还要把 $\hat\sigma$ 与 $x$ 的分布结合起来。

## 5. 估计量的性质：估得准不准，由什么决定

### 5.1 无偏性与正态分布

**B 级｜理解抽样分布：** 想象在同一组 $x_i$ 上反复收集 $Y$，每批数据都会得到一个新的 $\hat\beta_1$；这些斜率形成的分布，就是估计量的抽样分布（sampling distribution）。

在均值模型正确、误差均值为 0 时，

$$
E(\hat\beta_1\mid X)=\beta_1^*,\qquad
E(\hat\beta_0\mid X)=\beta_0^*.
$$

这叫无偏性（unbiasedness）：若在同一组 $x_i$ 上反复采样并重新拟合，估计量的长期平均等于真参数。它不表示某一次样本的估计就一定接近真值。

若误差正态，则

$$
\hat\beta_1\mid X
\sim
N\left(\beta_1^*,\frac{\sigma_*^2}{S_{XX}}\right),
$$

$$
\hat\beta_0\mid X
\sim
N\left[
\beta_0^*,
\sigma_*^2\left(\frac1n+\frac{\bar x^2}{S_{XX}}\right)
\right].
$$

### 5.2 方差与协方差

**优先级提示：** “噪声越大越不准、$S_{XX}$ 越大斜率越准”属于 A 级直觉；两个方差公式属于 B 级；最后的协方差精确公式属于 C 级，第一遍不必背。

$$
\boxed{
\operatorname{Var}(\hat\beta_1\mid X)
=\frac{\sigma^2}{S_{XX}}
}
$$

$$
\boxed{
\operatorname{Var}(\hat\beta_0\mid X)
=\sigma^2\left(\frac1n+\frac{\bar x^2}{S_{XX}}\right)
}
$$

$$
\boxed{
\operatorname{Cov}(\hat\beta_0,\hat\beta_1\mid X)
=-\sigma^2\frac{\bar x}{S_{XX}}
}
$$

这些公式给出三个直接结论：

1. $\sigma^2$ 越大，散点越厚，斜率和截距越难估准。
2. $S_{XX}$ 越大，即 $x_i$ 覆盖范围越宽，斜率通常估得越精确。
3. 样本量增加只有在提供了新的、有效的 $x$ 信息时才真正有帮助；把许多点都堆在同一个 $x$ 附近，对斜率精度帮助有限。

### 5.3 中心化为什么有用

**B 级｜会理解：** 中心化不改变拟合质量，只让截距更容易解释，并简化截距与斜率的关系。

令

$$
z_i=x_i-\bar x.
$$

用 $z$ 回归时 $\bar z=0$，模型可以写成

$$
E(Y\mid Z=z)=\alpha+\beta_1z.
$$

此时

$$
\hat\alpha=\bar y,\qquad
\operatorname{Cov}(\hat\alpha,\hat\beta_1\mid X)=0.
$$

中心化（centering）不改变斜率、拟合值、残差、RSS 或 $R^2$，但让截距变成“在平均 $X$ 水平下的平均响应”，往往更容易解释，也消除了截距与斜率估计的协方差。

### 5.4 Gauss–Markov 定理与正态性各做什么

**C 级｜知道边界即可：** 第一遍只需记住“BLUE 不等于模型必然正确，正态性主要用于精确小样本推断”。

**教材补充：** 在均值线性、误差零均值、同方差且互不相关的条件下，OLS 是最佳线性无偏估计（best linear unbiased estimator, BLUE）。

这里的“最佳”只表示：在所有关于 $Y$ 的线性无偏估计量中，OLS 方差最小。它不表示：

- OLS 在所有可能估计方法中永远最好；
- 拟合直线一定符合真实机制；
- 模型一定有因果含义。

需要特别分开两层：

| 结论 | 是否需要正态误差 |
|---|---|
| OLS 闭式解 | 不需要 |
| 无偏性与上述方差公式 | 不需要 |
| Gauss–Markov 的 BLUE 结论 | 不需要 |
| 小样本下精确的正态、$\chi^2$、$t$ 分布 | 需要 |

## 6. 从抽样分布到置信区间

### 6.1 “回归版学生定理”

**B 级｜理解 $t$ 分布从哪里来：** 不必背完整证明，但要知道“正态分子 + 用 RSS 估计的随机分母”产生 $t$ 分布。

**课件主线：** 在正态误差模型下，

$$
\frac{\mathrm{RSS}}{\sigma_*^2}\sim\chi^2(n-2),
$$

并且 RSS 与 $\hat\beta_0,\hat\beta_1$ 独立。

这两个事实共同保证：把未知的 $\sigma_*$ 换成 $\hat\sigma$ 后，标准化统计量服从 $t$ 分布，而不是标准正态分布。

直觉上，若 $\sigma_*$ 已知，只需处理 $\hat\beta_j$ 的正态波动；现在 $\sigma_*$ 也要用样本估计，于是分母又多了一层不确定性。$t$ 分布的尾部比标准正态分布更厚，正是在为这层额外不确定性留出余量。自由度增大时，$\hat\sigma$ 更稳定，$t$ 分布也逐渐接近标准正态分布。

### 6.2 参数估计的标准误

**A 级｜核心公式：** 标准误把第 5 节的理论方差变成可从样本计算的不确定性。

把方差公式中的 $\sigma^2$ 换成 $\hat\sigma^2$：

$$
\operatorname{se}(\hat\beta_1)
=
\frac{\hat\sigma}{\sqrt{S_{XX}}},
$$

$$
\operatorname{se}(\hat\beta_0)
=
\hat\sigma
\sqrt{\frac1n+\frac{\bar x^2}{S_{XX}}}.
$$

标准误（standard error）描述的是“若重复取样，估计量会波动多大”，不是样本点围绕直线的波动。后者由 $\hat\sigma$ 描述。

斜率标准误的结构尤其值得记住：

$$
\operatorname{se}(\hat\beta_1)
=
\frac{\text{残差噪声 }\hat\sigma}
{\sqrt{\text{预测变量提供的信息 }S_{XX}}}.
$$

所以想把斜率估准，可以降低测量噪声、扩大有意义的 $X$ 覆盖范围，或增加能够带来新 $X$ 信息的样本。

### 6.3 参数置信区间

**A 级｜核心模板：**

$$
\boxed{\text{估计值}\ \pm\ \text{临界值}\times\text{标准误}}.
$$

记 $t_{\alpha/2,n-2}$ 为自由度 $n-2$ 的 $t$ 分布上侧 $\alpha/2$ 分位数，则 $\beta_j^*$ 的 $(1-\alpha)$ 置信区间为

$$
\boxed{
\hat\beta_j
\pm
t_{\alpha/2,n-2}\operatorname{se}(\hat\beta_j)
},
\qquad j=0,1.
$$

对斜率即

$$
\hat\beta_1
\pm
t_{\alpha/2,n-2}
\frac{\hat\sigma}{\sqrt{S_{XX}}}.
$$

区间变窄的主要途径是：

- 降低噪声 $\sigma$；
- 扩大有效的 $X$ 变化范围 $S_{XX}$；
- 增加能覆盖研究范围的样本。

### 6.4 置信度的正确解释

**A 级｜必须会表述：** 置信度说的是区间构造方法的长期覆盖率，不是“真参数随机落进当前区间的概率”。

“95% 置信区间”不是说固定参数有 95% 概率落入这个已经算出的区间。在频率学派（frequentist）解释中：

> 若用同一种抽样和构造区间的方法反复进行研究，长期来看约 95% 的区间会覆盖真参数。

一次研究得到区间后，参数与区间都已固定；我们只能说该区间是由一个覆盖率为 95% 的方法产生的。

## 7. 假设检验：斜率是否等于某个值

### 7.1 检验问题

**A 级｜核心模板：**

$$
\boxed{
\text{检验统计量}
=
\frac{\text{估计值}-\text{原假设值}}
{\text{估计量的标准误}}
}.
$$

对给定常数 $b_1$，考虑双侧检验（two-sided test）：

$$
H_0:\beta_1^*=b_1,
\qquad
H_1:\beta_1^*\ne b_1.
$$

检验统计量（test statistic）是

$$
\boxed{
T=
\frac{\hat\beta_1-b_1}
{\operatorname{se}(\hat\beta_1)}
}.
$$

若 $H_0$ 成立，则

$$
T\sim t(n-2).
$$

$T$ 的直观含义是：

$$
T
=
\frac{\text{估计值与原假设值的距离}}
{\text{这种估计通常会波动多大}}.
$$

例如 $T=3$ 表示估计斜率与假设斜率相差约 3 个标准误；只有把“距离”与“正常波动尺度”比较，才能判断差异是否足够大。

### 7.2 拒绝域与 $p$ 值

显著性水平（significance level）为 $\alpha$ 时，双侧拒绝域为

$$
|T|>t_{\alpha/2,n-2}.
$$

若观测到的统计量为 $t_0$，则双侧 $p$ 值为

$$
p
=
2P\left\{t(n-2)\ge |t_0|\right\}.
$$

$p$ 值衡量的是：**若 $H_0$ 真的成立，得到当前这么极端或更极端统计量的概率。** 它不是“$H_0$ 为真的概率”。

### 7.3 最常见的零斜率检验

最常见的是

$$
H_0:\beta_1^*=0.
$$

- 拒绝 $H_0$：数据对“存在非零线性趋势”提供了证据。
- 未拒绝 $H_0$：现有数据不足以排除零斜率。

> 严格来说应说“未拒绝（fail to reject）$H_0$”，而不是“接受 $H_0$”。未拒绝零斜率不等于证明 $X$ 与 $Y$ 没有关系；它也可能来自样本量小、噪声大、$X$ 范围窄，或真实关系是非线性的。

即使拒绝零斜率，也只支持统计上的线性关联（linear association），不能单凭回归证明因果关系（causality）。

### 7.4 置信区间与双侧检验是一回事的两种表达

**B 级｜理解联系：** 同一个 $\alpha$ 下，区间是否包含假设值与双侧检验是否拒绝完全对应。

在同一个显著性水平下：

$$
b_1
\notin
(1-\alpha)\text{ 置信区间}
\quad\Longleftrightarrow\quad
\text{拒绝 }H_0:\beta_1=b_1.
$$

区间还告诉我们效应的可能大小与方向，因此通常比只报告“显著 / 不显著”更有信息。

## 8. 点预测、均值区间与个体预测区间

**来源边界：** lecture02 第 6 节给出点预测；下面关于平均响应区间、个体预测区间和同时置信带的区分，来自教材第 2.6.3—2.6.4 节。

**优先级提示：** 点预测以及“平均响应和新个体不是同一目标”属于 A 级；两类区间的精确标准误公式属于 B 级；同时置信带属于 C 级。

### 8.1 点预测

**A 级｜必须掌握。**

对新的预测变量值 $x_0$，点预测（point prediction）为

$$
\boxed{
\hat y_0=\hat\beta_0+\hat\beta_1x_0
}.
$$

同一个数既可以用来估计 $x_0$ 处的条件均值，也可以作为一个新个体响应的点预测；但两者的不确定性不同。

在套区间公式前，必须先问清预测对象：

| 问题 | 目标 | 应使用 |
|---|---|---|
| “所有 $X=x_0$ 个体的平均响应是多少？” | $\mu(x_0)=E(Y\mid X=x_0)$ | 均值的置信区间 |
| “下一个 $X=x_0$ 个体的响应是多少？” | $Y_{\mathrm{new}}$ | 个体预测区间 |

### 8.2 估计平均响应

**B 级公式，A 级概念：** 先判断目标是平均响应，再使用不含额外 $1$ 的标准误。

我们若要估计

$$
\mu(x_0)=E(Y\mid X=x_0),
$$

其标准误为

$$
\operatorname{se}_{\mathrm{fit}}(x_0)
=
\hat\sigma
\sqrt{
\frac1n+\frac{(x_0-\bar x)^2}{S_{XX}}
}.
$$

点态置信区间（pointwise confidence interval）为

$$
\boxed{
\hat y_0
\pm
t_{\alpha/2,n-2}
\operatorname{se}_{\mathrm{fit}}(x_0)
}.
$$

它回答：“所有 $X=x_0$ 个体的平均响应在哪里？”

### 8.3 预测一个新个体

**B 级公式，A 级概念：** 新个体自身还带有误差，所以标准误根号内多一个 $1$。

对尚未观察到的新响应

$$
Y_{\mathrm{new}}
=
\beta_0+\beta_1x_0+e_{\mathrm{new}},
$$

预测标准误（standard error of prediction）为

$$
\operatorname{se}_{\mathrm{pred}}(x_0)
=
\hat\sigma
\sqrt{
1+\frac1n+\frac{(x_0-\bar x)^2}{S_{XX}}
}.
$$

预测区间（prediction interval）为

$$
\boxed{
\hat y_0
\pm
t_{\alpha/2,n-2}
\operatorname{se}_{\mathrm{pred}}(x_0)
}.
$$

它回答：“一个新的 $X=x_0$ 个体，其响应可能在哪里？”

### 8.4 为什么预测区间更宽

**A 级｜必须能解释，优先于死背两条公式。**

两种区间拥有相同中心 $\hat y_0$，差别只在根号内是否多了 $1$：

$$
\underbrace{
\frac1n+\frac{(x_0-\bar x)^2}{S_{XX}}
}_{\text{估计均值函数的不确定性}}
$$

与

$$
\underbrace{1}_{\text{新个体自身的随机误差}}
+
\underbrace{
\frac1n+\frac{(x_0-\bar x)^2}{S_{XX}}
}_{\text{估计均值函数的不确定性}}.
$$

因此

$$
\operatorname{se}_{\mathrm{pred}}(x_0)
>
\operatorname{se}_{\mathrm{fit}}(x_0).
$$

即使我们精确知道真实直线，新个体仍带有不可消除的误差 $e_{\mathrm{new}}$。

> **配图建议：** 看教材 Figure 2.3（教材 PDF 第 14 页，印刷页第 34 页）。外侧实线是个体 prediction interval，内侧虚线带是 fitted mean 的区间。先比较两组线的宽度，再观察它们为何在 $\bar x$ 附近最窄、向两侧张开。

用教材母女身高例子区分：

- 问“母亲身高为 65 英寸时，所有女儿的平均身高是多少”，用均值置信区间；
- 问“某位身高为 65 英寸的母亲，她女儿的身高是多少”，用个体预测区间。

### 8.5 为什么离 $\bar x$ 越远，区间越宽

两个标准误都包含

$$
\frac{(x_0-\bar x)^2}{S_{XX}}.
$$

所以在 $x_0=\bar x$ 处最窄，向样本中心两侧逐渐变宽。在样本 $X$ 范围之外进行外推时，公式虽然仍能算出数值，但模型形态是否继续成立无法由现有数据验证。

### 8.6 同时置信带

**C 级｜知道用途即可。** 若不是只询问一个固定的 $x_0$，而是要让整条均值曲线同时具有至少 $1-\alpha$ 的覆盖率，需要同时置信带（simultaneous confidence band）：

$$
\hat y(x)
\pm
\operatorname{se}_{\mathrm{fit}}(x)
\sqrt{2F_{\alpha;2,n-2}}.
$$

这里用 $F$ 分布作多点同时推断的修正。它与单个 $x_0$ 上使用 $t$ 分布的点态区间不是同一件事。

## 9. 可决系数 $R^2$：解释了多少样本变异

### 9.1 平方和分解

**A 级｜必须掌握：** 先有“总变异 = 已解释变异 + 未解释变异”，才有 $R^2$。

总平方和（total sum of squares）为

$$
S_{YY}
=
\sum_{i=1}^n(y_i-\bar y)^2.
$$

它表示完全不使用 $X$、只用 $\bar y$ 预测时的总变异。

回归平方和（sum of squares due to regression）为

$$
\mathrm{SSreg}
=
S_{YY}-\mathrm{RSS}.
$$

于是

$$
\boxed{
S_{YY}
=
\mathrm{SSreg}
+
\mathrm{RSS}
}.
$$

即

$$
\text{总变异}
=
\text{拟合直线解释的变异}
+
\text{残余未解释变异}.
$$

> **配图建议：** 看教材 Figure 2.4（教材 PDF 第 15 页，印刷页第 35 页）。把所有点到水平线 $\bar y$ 的平方距离想成 $S_{YY}$，把点到 OLS 直线的平方距离想成 RSS；直线相对于水平线减少的那部分，就是 $\mathrm{SSreg}$。因此 $R^2$ 本质上是“使用 $X$ 后，平方预测误差相对基准减少了多少比例”。

### 9.2 $R^2$ 的定义

**A 级｜核心公式。**

$$
\boxed{
R^2
=
\frac{\mathrm{SSreg}}{S_{YY}}
=
1-\frac{\mathrm{RSS}}{S_{YY}}
}.
$$

在含截距的 OLS 中，$0\le R^2\le1$。例如 $R^2=0.80$ 表示：相对于只用样本均值预测，样本中 $Y$ 的总平方变异有 80% 被这条线性回归关系解释。

### 9.3 与相关系数的联系

**B 级｜会理解：** $R^2=r_{XY}^2$ 很有用；最后把 $T$ 写成相关系数的公式知道即可，不必优先背。

简单线性回归且含截距时，

$$
\hat\beta_1
=
r_{XY}\frac{\mathrm{SD}_Y}{\mathrm{SD}_X},
$$

$$
\boxed{R^2=r_{XY}^2}.
$$

所以 $R^2$ 丢失了关系方向：$r=0.9$ 与 $r=-0.9$ 都给出 $R^2=0.81$，方向要看 $\hat\beta_1$ 或 $r$ 的符号。

零斜率检验还可以写成

$$
T
=
r_{XY}
\sqrt{\frac{n-2}{1-r_{XY}^2}}.
$$

这说明在简单线性回归中，斜率、相关、$R^2$ 与零斜率检验是同一线性关系的不同表达。

### 9.4 $R^2$ 不能替你判断什么

**A 级｜必须记住：** $R^2$ 只衡量样本内平方误差减少比例，不能检查模型假设。

高 $R^2$ 不保证：

- 均值函数真的是直线；
- 方差恒定、误差独立或没有离群点；
- 预测可以安全外推；
- $X$ 导致了 $Y$；
- 模型对研究问题有实际价值。

低 $R^2$ 也不自动表示模型无用。在噪声很大的领域，小但稳定的平均效应仍可能重要。必须把 $R^2$ 与效应大小、区间、残差图和研究语境一起看。

## 10. 残差诊断：算完不等于结束

**教材补充：** lecture02 到 $R^2$ 为止；本部分依据教材第 2.8 节补上“拟合之后如何检查假设”。

**A 级｜必须掌握：** 会认出弯曲、漏斗、成段结构和大残差，比再多背一条代数公式更重要。

### 10.1 理想残差图

教材建议画残差对拟合值图（residuals versus fitted plot）：

$$
\text{横轴：}\hat y_i,
\qquad
\text{纵轴：}\hat e_i.
$$

理想状态是一张零图（null plot）：点在 0 附近无结构地散开，竖直厚度大致稳定。

### 10.2 四种常见信号

| 残差图形态 | 可能问题 | 下一步 |
|---|---|---|
| 弯曲、U 形或倒 U 形 | 线性均值函数不合适 | 加非线性项或考虑变换 |
| 漏斗形，散布随拟合值变化 | 异方差（heteroscedasticity） | 变换、稳健标准误或更合适的方差模型 |
| 连续正负成段、随时间有规律 | 误差相关 | 检查时间、群组或重复测量结构 |
| 少数残差特别大 | 离群点或数据错误 | 核查原始记录并做敏感性分析 |

残差图没有明显结构，只表示“没有发现明显的这些问题”，不是对模型正确性的证明。

> **配图建议：** 对照教材 Figure 2.5 与 Figure 2.6（均在教材 PDF 第 17 页，印刷页第 37 页）。Figure 2.5 的点云在 0 附近近似随机，接近 null plot；Figure 2.6 中编号 12 的点明显远离其他残差。先自己指出差异，再看第 10.3 节的数值影响。

### 10.3 Forbes 第 12 个观测告诉我们什么

**教材例证：** Forbes 数据中，第 12 个观测的残差绝对值约为第二大残差的 4 倍。删除前后：

| 量 | 全部 17 个观测 | 删除第 12 个观测 |
|---|---:|---:|
| $\hat\beta_0$ | $-42.138$ | $-41.308$ |
| $\hat\beta_1$ | $0.895$ | $0.891$ |
| $\operatorname{se}(\hat\beta_0)$ | $3.340$ | $1.001$ |
| $\operatorname{se}(\hat\beta_1)$ | $0.016$ | $0.005$ |
| $\hat\sigma$ | $0.379$ | $0.113$ |
| $R^2$ | $0.995$ | 接近 $1.000$ |

斜率点估计几乎不变，但标准误约缩小到原来的三分之一。这说明异常点未必明显改变拟合线，却可能显著放大不确定性和预测区间。

正确做法不是看到大残差就自动删除，而是：

1. 核查测量、录入和实验记录；
2. 分别报告保留与删除后的结果；
3. 说明结论对该观测是否敏感；
4. 依据研究过程，而不是依据“删后更显著”，决定最终分析。

> **配表建议：** 看教材 Table 2.2（教材 PDF 第 18 页，印刷页第 38 页）。重点不是只比较 $\hat\beta_1$，还要同时比较 $\operatorname{se}(\hat\beta_1)$ 与 $\hat\sigma$：第 12 个观测几乎没改变斜率，却显著改变了不确定性。

## 11. Forbes 数据：把全章公式串成一次完整分析

**A 级练习：** 不需要背案例中的数值；需要学会每个数为什么在这一步出现，以及它流向下一步的哪个公式。

### 11.1 数据与模型

响应是

$$
Y=\mathrm{lpres}=100\log_{10}(\mathrm{pres}),
$$

预测变量是沸点

$$
X=\mathrm{bp}.
$$

拟合简单线性模型

$$
E(\mathrm{lpres}\mid\mathrm{bp}=x)
=
\beta_0+\beta_1x.
$$

教材给出的汇总量为

$$
n=17,\qquad
\bar x=202.9529,\qquad
\bar y=139.6053,
$$

$$
S_{XX}=530.7824,\qquad
S_{XY}=475.3122,\qquad
S_{YY}=427.7942.
$$

### 11.2 求回归线

$$
\hat\beta_1
=
\frac{475.3122}{530.7824}
\approx0.895,
$$

$$
\hat\beta_0
=
139.6053-0.895(202.9529)
\approx-42.138.
$$

因此

$$
\widehat{E}(\mathrm{lpres}\mid\mathrm{bp}=x)
=
-42.138+0.895x.
$$

斜率表示：在研究范围内，沸点每增加 $1^\circ\mathrm{F}$，$100\log_{10}(\mathrm{pres})$ 的条件均值估计增加约 $0.895$。

截距对应 $\mathrm{bp}=0$，远离样本约 $194$ 到 $212^\circ\mathrm{F}$ 的范围，因此没有实用物理解释。

### 11.3 估计误差方差

$$
\mathrm{RSS}
=
S_{YY}-\frac{S_{XY}^2}{S_{XX}}
\approx2.1549,
$$

$$
\hat\sigma^2
=
\frac{2.1549}{17-2}
\approx0.1436,
$$

$$
\hat\sigma
\approx0.379.
$$

### 11.4 斜率推断

$$
\operatorname{se}(\hat\beta_1)
=
\frac{0.379}{\sqrt{530.7824}}
\approx0.0165.
$$

教材给出的 95% 斜率置信区间约为

$$
[0.86,0.93].
$$

它既显示斜率明显为正，也给出了效应大小的合理范围。

### 11.5 拟合优度与诊断

$$
R^2
=
1-\frac{2.1549}{427.7942}
\approx0.995.
$$

样本内线性拟合非常强，但残差图仍暴露了第 12 个观测。这个例子正好说明：

> **高 $R^2$ 与“需要检查异常观测”可以同时成立；拟合优度不能代替诊断。**

## 12. 一套可直接复用的解题流程

### 12.1 建模前

1. 明确响应变量 $Y$ 与预测变量 $X$。
2. 画散点图，检查线性、方差、特殊点和样本范围。
3. 写清研究目标：解释平均趋势、检验斜率，还是预测新个体。

### 12.2 手算主线

1. 计算 $\bar x,\bar y,S_{XX},S_{XY},S_{YY}$。
2. 求 $\hat\beta_1=S_{XY}/S_{XX}$。
3. 求 $\hat\beta_0=\bar y-\hat\beta_1\bar x$。
4. 写拟合线 $\hat y=\hat\beta_0+\hat\beta_1x$，并按单位解释斜率。
5. 求 $\mathrm{RSS}=S_{YY}-S_{XY}^2/S_{XX}$。
6. 求 $\hat\sigma^2=\mathrm{RSS}/(n-2)$。
7. 根据任务求标准误、置信区间、检验或预测区间。
8. 求 $R^2=1-\mathrm{RSS}/S_{YY}$，但不在这里停止。
9. 检查残差图并说明模型限制。

### 12.3 写结论的顺序

建议用四句话完成报告：

1. **方向与大小**：$X$ 每增加 1 单位，$Y$ 的条件均值估计改变多少。
2. **不确定性**：报告标准误或置信区间。
3. **证据强度**：报告检验统计量、自由度与 $p$ 值，不只写“显著”。
4. **适用边界**：说明样本范围、诊断结果和能否外推；不要擅自写成因果结论。

### 12.4 学会本章的过关标准

先合上正文，检查自己能否用口头语言回答：

- [ ] 为什么回归直线描述的是 $E(Y\mid X=x)$，而不是要求每个点都在线上？
- [ ] 为什么 $\hat\beta_1=S_{XY}/S_{XX}$，分子和分母分别表示什么？
- [ ] 为什么拟合线必过 $(\bar x,\bar y)$，且 $\sum\hat e_i=0$？
- [ ] 为什么 $\hat\sigma^2$ 除以 $n-2$，而不是 $n$？
- [ ] $\hat\sigma$、$\operatorname{se}(\hat\beta_1)$ 和 prediction standard error 分别衡量什么？
- [ ] $T=(\text{estimate}-\text{null})/\text{SE}$ 为什么能用于检验？
- [ ] 为什么个体预测区间比平均响应置信区间宽？
- [ ] 为什么 $R^2$ 很高时仍必须看残差图？
- [ ] $p>0.05$ 能说什么、不能说什么？
- [ ] 在什么情况下截距没有现实意义，预测又为什么不能随意外推？

若其中某一问说不清，就回看对应的第 2、3、4、6、7、8、9 或 10 部分；能不看公式解释清楚，再能从逻辑推出公式，才算真正掌握。

## 13. 高频易错点

1. **把模型写成 $\hat y=\beta_0+\beta_1x$。**  
   模型用真参数：$E(Y\mid X=x)=\beta_0+\beta_1x$；拟合结果才用帽子：$\hat y=\hat\beta_0+\hat\beta_1x$。

2. **把误差 $e_i$ 当作残差 $\hat e_i$。**  
   误差依赖真实直线、不可观测；残差依赖拟合直线、可计算。

3. **认为 OLS 必须正态才能计算。**  
   OLS 的求解不需要正态；正态主要保证小样本下精确的 $\chi^2$ 与 $t$ 推断。

4. **用 $\mathrm{RSS}/n$ 当作课件中的无偏方差估计。**  
   $\mathrm{RSS}/n$ 是正态模型下的 MLE，但无偏估计是 $\mathrm{RSS}/(n-2)$。

5. **看到 $p>0.05$ 就说“证明无线性关系”。**  
   正确说法是“现有数据未提供足够证据拒绝零斜率”。

6. **把零斜率等同于完全独立。**  
   零斜率只针对线性均值趋势；非线性依赖仍可能存在。

7. **把统计显著当作实际重要。**  
   样本很大时，极小斜率也可能显著。必须结合单位、置信区间和应用语境。

8. **把高 $R^2$ 当作模型正确。**  
   $R^2$ 看不到弯曲、异方差、相关误差和异常点，必须结合残差图。

9. **混淆均值置信区间与个体预测区间。**  
   个体预测区间多了不可约的新个体误差，因此一定更宽。

10. **在样本范围外机械外推。**  
    公式能给出数值，不等于现实机制在范围外仍保持线性。

11. **删掉异常点只因为结果更显著。**  
    删除必须有数据质量或研究设计依据，并应报告敏感性分析。

---

## 术语索引 · Terminology

第一次阅读只主动掌握这条术语链：

$$
\text{parameter}
\longrightarrow
\text{estimator}
\longrightarrow
\text{fitted value / residual}
\longrightarrow
\text{RSS / standard error}
\longrightarrow
\text{confidence interval / test / prediction}.
$$

其余术语先把本表当作查阅词典，不需要一次全部背下。

| 中文 | English | 本章中的意思 |
|---|---|---|
| 简单线性回归 | simple linear regression | 一个预测变量、线性条件均值的回归模型 |
| 条件均值 | conditional mean | $E(Y\mid X=x)$ |
| 条件方差 | conditional variance | $\operatorname{Var}(Y\mid X=x)$ |
| 截距 | intercept | $x=0$ 时的条件均值 |
| 斜率 | slope | $x$ 增加 1 单位时条件均值的变化 |
| 统计误差 | statistical error | 观测值与真实条件均值之差 |
| 独立同分布 | independent and identically distributed, i.i.d. | 误差彼此独立且服从同一分布 |
| 同方差 | homoscedasticity | 误差方差不随 $x$ 改变 |
| 异方差 | heteroscedasticity | 误差方差随 $x$ 改变 |
| 似然函数 | likelihood function | 把观测数据视为固定后，关于参数的函数 |
| 极大似然估计 | maximum likelihood estimation, MLE | 使似然最大的参数估计方法 |
| 普通最小二乘 | ordinary least squares, OLS | 使残差平方和最小的估计方法 |
| 正规方程 | normal equations | RSS 一阶导数为 0 得到的方程 |
| 拟合值 | fitted value | $\hat y_i=\hat\beta_0+\hat\beta_1x_i$ |
| 残差 | residual | $\hat e_i=y_i-\hat y_i$ |
| 残差平方和 | residual sum of squares, RSS | $\sum\hat e_i^2$ |
| 自由度 | degrees of freedom, df | 扣除估计约束后可独立变化的信息数 |
| 残差均方 | residual mean square | $\mathrm{RSS}/(n-2)$ |
| 回归标准误 | standard error of regression | $\hat\sigma=\sqrt{\mathrm{RSS}/(n-2)}$ |
| 标准误 | standard error | 估计量抽样波动的估计标准差 |
| 无偏估计 | unbiased estimator | 重复抽样下期望等于真参数的估计量 |
| 最佳线性无偏估计 | best linear unbiased estimator, BLUE | 线性无偏类中方差最小的估计量 |
| 置信区间 | confidence interval | 由具有给定长期覆盖率的方法产生的区间 |
| 假设检验 | hypothesis test | 用样本评价某个参数假设 |
| 检验统计量 | test statistic | 在原假设下分布已知或可求的统计量 |
| $p$ 值 | p-value | 原假设下得到同样或更极端统计量的概率 |
| 点预测 | point prediction | 对目标响应给出的单个预测值 |
| 预测区间 | prediction interval | 新个体响应的可能范围 |
| 同时置信带 | simultaneous confidence band | 对整条均值曲线同时保证覆盖率的带 |
| 总平方和 | total sum of squares | $S_{YY}=\sum(y_i-\bar y)^2$ |
| 回归平方和 | sum of squares due to regression | $\mathrm{SSreg}=S_{YY}-\mathrm{RSS}$ |
| 可决系数 | coefficient of determination | $R^2=1-\mathrm{RSS}/S_{YY}$ |
| 残差图 | residual plot | 用残差检查模型假设的图 |
| 外推 | extrapolation | 在样本 $X$ 范围之外使用拟合模型 |

## 原文对应 · Reading map

### lecture02《第二讲 简单线性回归》

| PDF 页 | 主题 | 本讲义对应 |
|---:|---|---|
| 1 | 正态简单线性回归模型；似然函数 | 第 2、3.1 部分 |
| 2 | OLS 推导；$\hat\beta_0,\hat\beta_1$；残差与 RSS | 第 3 部分 |
| 3—4 | 参数估计的分布、方差与协方差；$\chi^2$ 结论；$\hat\sigma^2$ 与标准误 | 第 4—6 部分 |
| 5 | 参数置信区间；假设检验的建立 | 第 6—7 部分 |
| 6 | $t$ 检验与 $p$ 值；点预测；$R^2$ | 第 7—9 部分 |

### *Applied Linear Regression*, Chapter 2

| PDF 页 | 印刷页 | 主题 | 本讲义对应 |
|---:|---:|---|---|
| 1—2 | 21—22 | 模型、误差假设与正态性的作用 | 第 2 部分 |
| 2—5 | 22—25 | OLS 记号、残差、平方和与估计公式 | 第 3 部分 |
| 6 | 26 | 误差方差、残差自由度与 $\chi^2$ 分布 | 第 4、6 部分 |
| 7—9 | 27—29 | OLS 性质、估计量方差、Gauss–Markov 与标准误 | 第 5—6 部分 |
| 10—14 | 30—34 | 参数区间、$t$ 检验、预测区间、均值区间与同时置信带 | 第 6—8 部分 |
| 15—16 | 35—36 | $R^2$ 与平方和分解 | 第 9 部分 |
| 16—18 | 36—38 | 残差诊断与 Forbes 第 12 个观测 | 第 10—11 部分 |
| 19—30 | 39—50 | 练习题与延伸应用 | 可用第 12 部分流程作答 |

> 页码说明：lecture02 的 PDF 页码与页面下方页码一致；教材节选的 PDF 第 1 页对应印刷页第 21 页，即“印刷页 = PDF 页 + 20”。
