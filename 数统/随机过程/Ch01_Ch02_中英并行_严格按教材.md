# Ross《Introduction to Probability Models》第13版  
# Ch1 + Ch2 中英并行精讲笔记（严格按教材顺序）

> **使用说明**
>
> - 本笔记严格按照 Ross 第13版教材 **Chapter 1: Introduction to Probability Theory（概率论导论）** 与 **Chapter 2: Random Variables（随机变量）** 的章节顺序组织。
> - 讲解以中文为主；每个重要英文专业术语都在首次出现时给出中文对应，后续仍尽量保留中英并列，方便阅读英文教材、论文和课程讲义。
> - 行内公式使用 `$...$`；需要独立展示的公式统一使用 `$$...$$`。
> - 重点不是逐字翻译教材，而是沿着教材的逻辑，把定义、直觉、公式、典型例子和前后联系讲清楚。

---

# 0. Ch1 → Ch2 的整体逻辑

Ross 前两章的逻辑非常清楚：

**Chapter 1: Introduction to Probability Theory（概率论导论）** 先回答：

> 一个随机试验可能发生什么？某个事件发生的概率是多少？已知一些信息后，概率如何改变？

然后 **Chapter 2: Random Variables（随机变量）** 再回答：

> 我们如何把随机试验的结果“数值化”，进而研究随机变量的分布、期望、方差、联合关系和极限规律？

因此主线是：

```text
随机试验 random experiment
        ↓
样本空间 sample space
        ↓
事件 event
        ↓
概率 probability
        ↓
条件概率 conditional probability
        ↓
独立性 independence
        ↓
随机变量 random variable
        ↓
概率分布 probability distribution
        ↓
期望 expectation / 方差 variance
        ↓
联合分布 joint distribution
        ↓
矩母函数 moment generating function
        ↓
极限定理 limit theorems
        ↓
随机过程 stochastic process
```

这两章是后面 **Ch3 条件期望（conditional expectation）**、**Ch4 马尔可夫链（Markov chains）**、**Ch5 泊松过程（Poisson process）** 的基础。

---

# Chapter 1 — Introduction to Probability Theory（概率论导论）

---

# 1.1 Introduction（引言）

Ross 从一个最基本的事实出发：

现实世界中的很多现象存在 **随机性（randomness）**，也就是说结果在发生之前通常不能被完全预测。

例如：

- 掷骰子的结果；
- 某个用户是否点击推荐内容；
- 某段时间会有多少顾客到达；
- 一台设备何时发生故障。

为了描述这种不确定性，需要建立 **概率模型（probability model）**。

教材中的思想可以概括为：

> 一个现实模型如果存在不可预测的随机变化，就需要用概率模型来刻画。

这里有三个基础词：

- **试验（experiment）**：我们进行的随机过程或操作；
- **结果（outcome）**：一次试验最终发生的具体结果；
- **概率模型（probability model）**：描述所有可能结果及其概率规律的数学模型。

这一节本身公式不多，但它给后面的整本书定了基调：

> Ross 不是单纯讲抽象概率论，而是强调怎样用概率去建立和分析随机模型。

---

# 1.2 Sample Space and Events（样本空间与事件）

## 1.2.1 Sample Space（样本空间）

如果一个试验的结果事先无法确定，但所有可能的结果都可以列出来，那么所有可能结果组成的集合称为 **样本空间（sample space）**，通常记作 $S$。

例如，抛一枚硬币：

$S=\{H,T\}$

其中：

- $H$ = head（正面）
- $T$ = tail（反面）

掷一个骰子：

$S=\{1,2,3,4,5,6\}$

抛两枚硬币：

$S=\{(H,H),(H,T),(T,H),(T,T)\}$

这里的每一个具体元素称为一个 **结果（outcome）**，也可以理解成一个 **样本点（sample point）**。

### 关键理解

样本空间不是“随机变量的取值集合”，而是：

> **原始随机试验所有可能结果的集合。**

例如掷两个骰子：

- 原始 outcome 可以是 $(2,5)$；
- 如果我们之后定义 $X=$ 两个骰子点数之和，那么 $X=7$。

所以：

> outcome（结果）属于 sample space（样本空间）；  
> random variable（随机变量）是后来定义在 sample space 上的函数。

这一点是 Ch1 到 Ch2 的关键连接。

---

## 1.2.2 Event（事件）

**事件（event）** 是样本空间 $S$ 的一个子集。

例如掷一个骰子：

- “掷出偶数”对应事件 $E=\{2,4,6\}$；
- “掷出大于4”对应事件 $F=\{5,6\}$。

如果一次试验的实际结果属于 $E$，我们就说：

> 事件 $E$ 发生（the event $E$ occurs）。

因此：

- **outcome（结果）**：一次试验的具体结果；
- **event（事件）**：我们关心的一组结果。

---

## 1.2.3 Union（并集）

两个事件 $E$ 和 $F$ 的 **并集（union）** 记为 $E\cup F$。

它表示：

> $E$ 发生，或者 $F$ 发生，或者二者同时发生。

数学中的 “or（或）” 通常是 **inclusive or（包含性或）**。

例如：

$E=\{1,3,5\}$，$F=\{1,2,3\}$，

则：

$E\cup F=\{1,2,3,5\}$。

---

## 1.2.4 Intersection（交集）

两个事件 $E$ 和 $F$ 的 **交集（intersection）** 记作 $E\cap F$。

Ross 教材也经常直接写成 $EF$。

因此在 Ross 书里：

$EF=E\cap F$

表示：

> $E$ 和 $F$ 同时发生。

例如：

$E=\{1,3,5\}$，$F=\{1,2,3\}$，

则：

$EF=\{1,3\}$。

后面看到类似 $E_1E_2E_3$，要读成：

> $E_1\cap E_2\cap E_3$，即三个事件同时发生。

---

## 1.2.5 Null Event（空事件）

如果某个事件中没有任何 outcome（结果），它称为 **空事件（null event / empty event）**，Ross 记作 $\varnothing$。

它是不可能发生的事件。

例如抛一枚硬币：

- $E=\{H\}$
- $F=\{T\}$

则：

$EF=\varnothing$。

---

## 1.2.6 Mutually Exclusive（互斥）

如果两个事件不能同时发生，即 $EF=\varnothing$，则称它们 **互斥（mutually exclusive）**。

例如掷一次骰子：

- $E=$“点数为1”
- $F=$“点数为2”

显然二者不能同时发生，因此 mutually exclusive（互斥）。

### 特别注意：互斥不等于独立

这是非常容易混淆的一点：

- **互斥（mutually exclusive）**：两个事件不能一起发生；
- **独立（independent）**：一个事件是否发生不会改变另一个事件发生的概率。

如果两个概率都大于0的事件互斥，那么它们反而一定不是独立的。

---

## 1.2.7 Complement（补集）

事件 $E$ 的 **补集（complement）** 记作 $E^c$。

它表示：

> 所有不属于 $E$ 的结果。

也就是：

> $E^c$ 发生，当且仅当 $E$ 不发生。

例如掷骰子：

- $E=$“点数为偶数”
- $E^c=$“点数为奇数”

此外，整个样本空间 $S$ 的补集显然为空：

$S^c=\varnothing$。

---

# 1.3 Probabilities Defined on Events（定义在事件上的概率）

现在有了事件，下一步就是给事件赋予概率。

对每个事件 $E$，定义一个数 $P(E)$，称为 **事件 $E$ 的概率（probability of event $E$）**。

Ross 给出三条概率公理。

---

## 1.3.1 Probability Axioms（概率公理）

### 公理1：非负性（nonnegativity）

$0\le P(E)\le 1$

任何事件的概率都在0和1之间。

### 公理2：规范化（normalization）

$P(S)=1$

整个样本空间一定发生。

### 公理3：可列可加性（countable additivity）

如果 $E_1,E_2,\dots$ 两两互斥（mutually exclusive），那么：

$$
P\left(\bigcup_{n=1}^{\infty}E_n\right)
=
\sum_{n=1}^{\infty}P(E_n)
$$

这条公理的直觉是：

> 对互斥事件，整体发生的概率等于各部分概率之和。

---

## 1.3.2 Complement Rule（补事件公式）

因为 $E$ 与 $E^c$ 互斥，且 $E\cup E^c=S$，所以：

$$
P(E^c)=1-P(E)
$$

这是概率计算中最常用的技巧之一。

例如：

> 至少一个人成功（at least one success）

往往比直接计算更容易的方法是：

$P(\text{at least one})=1-P(\text{none})$。

---

## 1.3.3 Addition Rule（加法公式）

对于任意两个事件 $E,F$：

$$
P(E\cup F)=P(E)+P(F)-P(EF)
$$

其中 $EF=E\cap F$。

为什么要减去 $P(EF)$？

因为在 $P(E)+P(F)$ 中，交集 $EF$ 被算了两次。

如果 $E$ 与 $F$ 互斥，则 $P(EF)=0$，于是：

$P(E\cup F)=P(E)+P(F)$。

---

## 1.3.4 Inclusion–Exclusion Identity（容斥公式）

对于三个事件：

$$
P(E\cup F\cup G)
=
P(E)+P(F)+P(G)
-P(EF)-P(EG)-P(FG)
+P(EFG)
$$

这称为 **容斥恒等式（inclusion–exclusion identity）**。

一般的 $n$ 个事件也遵循同样规律：

> 先加单个事件概率，再减两两交集，再加三重交集，交替进行。

教材后面的帽子匹配问题、coupon 问题等都会再次用到这个思路。

---

# 1.4 Conditional Probabilities（条件概率）

这一节是 Ch1 的核心。

**条件概率（conditional probability）** 研究的是：

> 当我们已经知道某些信息以后，原来的概率应该如何更新？

---

## 1.4.1 Definition of Conditional Probability（条件概率定义）

如果 $P(F)>0$，则在事件 $F$ 已经发生的条件下，事件 $E$ 发生的概率定义为：

$$
P(E\mid F)=\frac{P(EF)}{P(F)}
$$

英文阅读中经常看到：

- **given that $F$ occurs**：给定 $F$ 发生；
- **conditional on $F$**：以 $F$ 为条件；
- **the conditional probability of $E$ given $F$**：给定 $F$ 时 $E$ 的条件概率。

---

## 1.4.2 条件概率的核心直觉：缩小样本空间

教材用“掷两个骰子，已知第一个骰子是4”来解释条件概率。

原来有36个等可能结果。

一旦知道第一个骰子是4，剩下可能的 outcome（结果）只有：

$(4,1),(4,2),(4,3),(4,4),(4,5),(4,6)$。

于是原来的 sample space（样本空间）实际上缩小成事件 $F$。

因此：

> 条件概率的本质就是：在已知条件下，把条件事件当作新的样本空间重新计算概率。

这比单纯背公式更重要。

---

## 1.4.3 Multiplication Rule（乘法公式）

由条件概率定义直接得到：

$$
P(EF)=P(F)P(E\mid F)
$$

也可以写成：

$$
P(EF)=P(E)P(F\mid E)
$$

教材在“无放回抽球（without replacement）”例子中使用：

第一球黑的概率 × 已知第一球黑后第二球仍为黑的条件概率。

这种结构以后会非常常见。

---

## 1.4.4 Chain Rule（概率链式分解）

教材习题中进一步给出多个事件的乘法展开：

$$
P(E_1E_2\cdots E_n)
=
P(E_1)
P(E_2\mid E_1)
P(E_3\mid E_1E_2)
\cdots
P(E_n\mid E_1\cdots E_{n-1})
$$

常见英文称为 **概率链式法则（chain rule of probability）**。

后面 HMM（Hidden Markov Model，隐马尔可夫模型）、序列模型（sequential models）等都会不断使用这种分解思想。

---

# 1.5 Independent Events（独立事件）

## 1.5.1 Definition of Independence（独立性的定义）

事件 $E$ 和 $F$ **独立（independent）**，如果：

$$
P(EF)=P(E)P(F)
$$

如果 $P(F)>0$，这个条件等价于：

$P(E\mid F)=P(E)$。

意思是：

> 知道 $F$ 已经发生，并不会改变 $E$ 发生的概率。

如果不满足独立条件，则称两个事件 **依赖（dependent）**。

---

## 1.5.2 “独立”不是“没有关系”的口语概念

真正判断独立，要看概率能否分解。

例如教材中掷两个骰子：

- $E_1=$“总和为6”
- $F=$“第一个骰子为4”

有：

$P(E_1F)\neq P(E_1)P(F)$，

所以不独立。

但对于：

- $E_2=$“总和为7”
- $F=$“第一个骰子为4”

教材算出：

$P(E_2F)=P(E_2)P(F)$，

因此二者独立。

这说明独立性必须用概率结构判断，不能只靠直觉。

---

## 1.5.3 Pairwise Independent vs Jointly Independent（两两独立与联合独立）

多个事件时要特别小心。

如果 $E,F,G$ 满足：

- $E$ 与 $F$ 独立；
- $E$ 与 $G$ 独立；
- $F$ 与 $G$ 独立；

那么称它们 **两两独立（pairwise independent）**。

但这还不足以保证：

$P(EFG)=P(E)P(F)P(G)$。

如果所有子集都满足乘积关系，才叫：

- **相互独立（mutually independent）**
- 或 **联合独立（jointly independent）**

教材 Example 1.10 专门展示了：

> pairwise independent（两两独立）不一定 jointly independent（联合独立）。

---

## 1.5.4 Independent Trials（独立试验）

如果一系列 success/failure（成功/失败）试验中，任意若干次成功事件都满足乘积关系，那么这些试验称为 **独立试验（independent trials）**。

这一概念直接为 Ch2 的 Bernoulli、Binomial、Geometric 分布做准备。

---

# 1.6 Bayes' Formula（贝叶斯公式）

这一节实际上把三个概念串起来：

1. conditional probability（条件概率）；
2. conditioning（条件化/按情况拆分）；
3. Bayes' formula（贝叶斯公式）。

---

## 1.6.1 先理解“按情况拆分概率”

对事件 $E$ 和 $F$：

$E$ 可以拆成两个互斥部分：

$E=EF\cup EF^c$。

因此：

$$
P(E)
=
P(E\mid F)P(F)
+
P(E\mid F^c)P(F^c)
$$

Ross 强调，这相当于：

> $P(E)$ 是不同条件下 $P(E\mid F)$ 和 $P(E\mid F^c)$ 的加权平均（weighted average）。

权重就是各条件本身发生的概率。

---

## 1.6.2 Law of Total Probability（全概率公式）

如果 $F_1,\dots,F_n$ 两两互斥，且恰好覆盖整个样本空间：

$\bigcup_{i=1}^nF_i=S$，

则：

$$
P(E)=\sum_{i=1}^{n}P(E\mid F_i)P(F_i)
$$

这通常称为 **全概率公式（law of total probability）**。

直觉：

> 一个事件 $E$ 可能通过多种互斥的“路径”发生，把各路径概率加总即可。

---

## 1.6.3 Bayes' Formula（贝叶斯公式）

如果已经观察到 $E$，现在想反过来判断是哪一个 $F_j$ 发生了，则：

$$
P(F_j\mid E)
=
\frac{P(E\mid F_j)P(F_j)}
{\sum_{i=1}^{n}P(E\mid F_i)P(F_i)}
$$

这就是 **贝叶斯公式（Bayes' formula / Bayes' rule）**。

### 方向一定不要弄反

$P(E\mid F)$：

> 已知 $F$，求 $E$。

而：

$P(F\mid E)$：

> 已知 $E$，反推 $F$。

两者通常完全不同。

教材的疾病检测例子就是为了强调这个区别。

---

## 1.6.4 从现代统计角度认识 Bayes 术语

虽然 Ross 这一节主要以事件形式讲，但以后统计/机器学习中经常看到：

- **先验概率（prior probability）**：$P(F_j)$；
- **似然（likelihood）**：$P(E\mid F_j)$；
- **后验概率（posterior probability）**：$P(F_j\mid E)$；
- **边际概率/证据（marginal probability / evidence）**：$P(E)$。

因此 Bayes 的核心可以记成：

> prior（先验） + evidence（证据） → posterior（后验）。

---

# 1.7 Probability Is a Continuous Event Function（概率作为连续的事件函数）

这一节的重点是：

> 如果一列事件逐渐逼近某个极限事件，那么这些事件的概率也会逼近极限事件的概率。

这对后面 branching process（分枝过程）、hitting event（到达事件）、recurrence（常返）等非常重要。

---

## 1.7.1 Increasing Sequence of Events（递增事件列）

如果：

$A_n\subseteq A_{n+1}$，

称 $A_1,A_2,\dots$ 为 **递增事件列（increasing sequence of events）**。

其极限定义为：

$$
\lim_{n\to\infty}A_n
=
\bigcup_{i=1}^{\infty}A_i
$$

---

## 1.7.2 Decreasing Sequence of Events（递减事件列）

如果：

$A_{n+1}\subseteq A_n$，

称为 **递减事件列（decreasing sequence of events）**。

其极限定义为：

$$
\lim_{n\to\infty}A_n
=
\bigcap_{i=1}^{\infty}A_i
$$

---

## 1.7.3 Continuity Property of Probability（概率连续性）

教材 Proposition 1.1：

如果 $A_n$ 是递增或递减事件列，那么：

$$
P\left(\lim_{n\to\infty}A_n\right)
=
\lim_{n\to\infty}P(A_n)
$$

### 为什么重要？

教材 Example 1.16 用 population extinction（种群灭绝）解释：

设 $A_n=$“第 $n$ 代已经灭绝”。

因为一旦灭绝以后就不会重新出现，所以：

$A_n\subseteq A_{n+1}$。

于是：

$$
\lim_{n\to\infty}P(A_n)
=
P(\text{population eventually dies out})
$$

也就是：

> “第 $n$ 代时已经灭绝”的概率极限，就是“最终灭绝”的概率。

这一思想后面 Ch4、Ch7 会反复出现。

---

# Chapter 1 结构总结

Ch1 的知识链可以压缩成：

```text
Sample Space（样本空间）
    ↓
Event（事件）
    ↓
Probability Axioms（概率公理）
    ↓
Conditional Probability（条件概率）
    ↓
Independence（独立性）
    ↓
Bayes' Formula（贝叶斯公式）
    ↓
Continuity of Probability（概率连续性）
```

Ch1 最需要熟练的不是复杂计算，而是：

- 会把文字问题写成事件；
- 会正确理解条件概率；
- 能区分 mutually exclusive（互斥）与 independent（独立）；
- 能使用 conditioning（条件化）和 Bayes（贝叶斯）重新组织问题。

---

# Chapter 2 — Random Variables（随机变量）

---

# 2.1 Random Variables（随机变量）

教材从一个非常自然的问题开始：

> 做随机试验时，我们通常并不真正关心原始 outcome，而更关心 outcome 的某个数值函数。

例如掷两个骰子，我们可能不关心具体是 $(1,6)$ 还是 $(2,5)$，只关心：

> 两个骰子的点数和是否为7。

于是引出 **随机变量（random variable）**。

---

## 2.1.1 Definition of Random Variable（随机变量定义）

Ross 的表述是：

> random variable（随机变量）是定义在 sample space（样本空间）上的 real-valued function（实值函数）。

也就是说：

$$
X:S\to\mathbb{R}
$$

例如掷两个骰子，定义：

$X=$ 两个骰子的点数和。

那么：

$X(1,6)=7$，$X(2,5)=7$。

### 核心直觉

random variable（随机变量）不是“随机的变量”这么简单。

它本质上是：

> **把原始随机结果 outcome 映射成数值的函数。**

---

## 2.1.2 教材 Examples 2.1–2.3：为什么要引入随机变量

### Example 2.1：两个骰子的和

$X$ 可以取 $2,3,\dots,12$。

每一个 $X=x$ 对应一组原始 outcome。

例如：

$P(X=7)=6/36$。

### Example 2.2：两枚硬币中正面的个数

定义：

$Y=$ 正面数（number of heads）。

那么：

$Y\in\{0,1,2\}$。

### Example 2.3：直到第一次正面所需的抛掷次数

定义：

$N=$ 第一次出现 head（正面）之前总共抛了多少次。

如果正面概率是 $p$：

$P(N=n)=(1-p)^{n-1}p$。

这个例子后面会直接变成 geometric random variable（几何随机变量）。

---

## 2.1.3 Indicator Random Variable（示性随机变量）

教材 Example 2.4：

如果只关心某个事件 $E$ 是否发生，可以定义：

$$
I=
\begin{cases}
1,&E\text{ occurs（事件 }E\text{ 发生）}\\
0,&\text{otherwise（否则）}
\end{cases}
$$

这种随机变量称为：

**示性随机变量（indicator random variable / indicator variable）**。

特别重要的关系：

$P(I=1)=P(E)$。

之后再学期望时会得到：

$E[I]=P(E)$。

indicator（示性变量）是 Ross 全书非常常用的工具。

---

## 2.1.4 Discrete vs Continuous Random Variables（离散与连续随机变量）

如果随机变量只能取有限个或可数多个值，称为：

**离散随机变量（discrete random variable）**。

例如：

- Bernoulli（伯努利）
- Binomial（二项）
- Geometric（几何）
- Poisson（泊松）

如果随机变量可以在一个连续区间上取值，称为：

**连续随机变量（continuous random variable）**。

例如：

- Uniform（均匀）
- Exponential（指数）
- Gamma（伽马）
- Normal（正态）

---

## 2.1.5 Cumulative Distribution Function, CDF（累积分布函数）

对任意随机变量 $X$，定义：

$$
F(b)=P(X\le b)
$$

这叫：

**累积分布函数（cumulative distribution function, CDF）**，教材也简称 **distribution function（分布函数）**。

教材给出三个基本性质：

1. $F(b)$ 是 **单调不减（nondecreasing）**；
2. 当 $b\to+\infty$ 时，$F(b)\to1$；
3. 当 $b\to-\infty$ 时，$F(b)\to0$。

利用 CDF：

$P(a<X\le b)=F(b)-F(a)$。

### CDF 为什么重要？

因为它是最统一的分布描述：

- 离散随机变量有 CDF；
- 连续随机变量也有 CDF。

因此教材强调：

> 关于 $X$ 的概率问题原则上都可以通过 CDF 回答。

---

# 2.2 Discrete Random Variables（离散随机变量）

---

## 2.2.1 Probability Mass Function, PMF（概率质量函数）

如果 $X$ 是离散随机变量，定义：

$$
p(a)=P(X=a)
$$

称为：

**概率质量函数（probability mass function, PMF）**。

必须满足：

- $p(x)\ge0$；
- 所有可能取值概率之和为1。

即：

$$
\sum_i p(x_i)=1
$$

CDF 与 PMF 的关系是：

$$
F(a)=\sum_{x_i\le a}p(x_i)
$$

教材 Fig. 2.1 展示了离散随机变量的 CDF 是典型的 **阶梯函数（step function）**。

---

# 2.2.1 The Bernoulli Random Variable（伯努利随机变量）

进行一次只有 success（成功）/failure（失败）的试验：

$$
X=
\begin{cases}
1,&\text{success（成功）}\\
0,&\text{failure（失败）}
\end{cases}
$$

若成功概率为 $p$，则：

$P(X=1)=p$，$P(X=0)=1-p$。

称：

$X$ 是参数为 $p$ 的 **Bernoulli random variable（伯努利随机变量）**。

示性变量 $I\{A\}$ 本质上就是 Bernoulli random variable。

---

# 2.2.2 The Binomial Random Variable（二项随机变量）

如果进行 $n$ 次 independent trials（独立试验），每次：

- success 概率为 $p$；
- failure 概率为 $1-p$；

定义 $X=$ 成功次数，则：

$X$ 是参数为 $(n,p)$ 的 **二项随机变量（binomial random variable）**。

其 PMF：

$$
P(X=i)
=
\binom{n}{i}p^i(1-p)^{n-i},
\qquad i=0,1,\dots,n
$$

### 为什么有组合数？

固定某一种“$i$ 次成功、$n-i$ 次失败”的具体顺序，概率是：

$p^i(1-p)^{n-i}$。

这样的顺序一共有：

$\binom{n}{i}$

种，所以相乘得到二项分布公式。

---

# 2.2.3 The Geometric Random Variable（几何随机变量）

不断做独立试验，每次成功概率为 $p>0$。

定义：

$X=$ 第一次成功出现时的试验次数。

则：

$$
P(X=n)=(1-p)^{n-1}p,\qquad n=1,2,\dots
$$

称为：

**几何随机变量（geometric random variable）**。

理解这个公式只需要一句话：

> 前 $n-1$ 次全部失败，第 $n$ 次成功。

---

# 2.2.4 The Poisson Random Variable（泊松随机变量）

若：

$$
P(X=i)=e^{-\lambda}\frac{\lambda^i}{i!},
\qquad i=0,1,2,\dots
$$

其中 $\lambda>0$，则称 $X$ 为参数 $\lambda$ 的：

**泊松随机变量（Poisson random variable）**。

后面会证明：

$E[X]=\lambda$，$\operatorname{Var}(X)=\lambda$。

---

## Poisson Approximation to Binomial（二项分布的泊松近似）

教材强调一个重要性质：

当：

- $n$ 很大（large $n$）；
- $p$ 很小（small $p$）；
- 令 $\lambda=np$；

则：

$$
\operatorname{Binomial}(n,p)
\approx
\operatorname{Poisson}(\lambda)
$$

也就是：

$$
P(X=i)
\approx
e^{-\lambda}\frac{\lambda^i}{i!}
$$

这是一种典型的 **稀有事件近似（rare-event approximation）**。

---

# 2.3 Continuous Random Variables（连续随机变量）

对连续随机变量，不能再用 $P(X=x)$ 来描述，因为单点概率会等于0。

因此引入：

**概率密度函数（probability density function, PDF）**。

---

## 2.3.1 Probability Density Function, PDF（概率密度函数）

如果存在非负函数 $f(x)$，使得对任意集合 $B$：

$$
P(X\in B)=\int_B f(x)\,dx
$$

则 $X$ 称为 continuous random variable（连续随机变量），$f(x)$ 称为 PDF（概率密度函数）。

PDF 必须满足：

$$
\int_{-\infty}^{\infty}f(x)\,dx=1
$$

对于区间：

$$
P(a\le X\le b)=\int_a^bf(x)\,dx
$$

---

## 连续随机变量为什么 $P(X=a)=0$？

因为：

$$
P(X=a)=\int_a^a f(x)\,dx=0
$$

所以一定要区分：

- $f(a)$：density（密度）；
- $P(X=a)$：单点概率。

连续情况下：

> $f(a)$ 不是 $P(X=a)$。

教材给出的局部近似是：

$$
P\left(a-\frac{\varepsilon}{2}\le X\le a+\frac{\varepsilon}{2}\right)
\approx
\varepsilon f(a)
$$

因此 $f(a)$ 可以理解成：

> $X$ 在 $a$ 附近出现的“概率密度”。

---

## CDF 与 PDF 的关系

$$
F(a)=\int_{-\infty}^{a}f(x)\,dx
$$

若可导，则：

$$
f(a)=F'(a)
$$

也就是：

> CDF 是 PDF 的积分，PDF 是 CDF 的导数。

---

# 2.3.1 The Uniform Random Variable（均匀随机变量）

如果 $X$ 在区间 $(\alpha,\beta)$ 上均匀分布：

**uniform random variable（均匀随机变量）**

其 PDF：

$$
f(x)=
\begin{cases}
\dfrac{1}{\beta-\alpha},&\alpha<x<\beta\\
0,&\text{otherwise}
\end{cases}
$$

它的核心含义是：

> 在区间内，同样长度的子区间具有相同概率。

例如：

$P(a<X<b)$ 只由区间长度 $b-a$ 决定。

教材进一步推导 CDF：

$$
F(a)=
\begin{cases}
0,&a\le\alpha\\
\dfrac{a-\alpha}{\beta-\alpha},&\alpha<a<\beta\\
1,&a\ge\beta
\end{cases}
$$

---

# 2.3.2 Exponential Random Variables（指数随机变量）

参数为 $\lambda>0$ 的 **指数随机变量（exponential random variable）**：

$$
f(x)=
\begin{cases}
\lambda e^{-\lambda x},&x\ge0\\
0,&x<0
\end{cases}
$$

其 CDF：

$F(a)=1-e^{-\lambda a}$，其中 $a\ge0$。

Ch5 会进一步系统学习 exponential distribution（指数分布），尤其是：

- memoryless property（无记忆性）；
- Poisson process（泊松过程）中的 interarrival time（到达间隔）。

---

# 2.3.3 Gamma Random Variables（伽马随机变量）

参数为 $\alpha>0,\lambda>0$ 的 **伽马随机变量（gamma random variable）**：

$$
f(x)=
\begin{cases}
\dfrac{\lambda e^{-\lambda x}(\lambda x)^{\alpha-1}}{\Gamma(\alpha)},&x\ge0\\
0,&x<0
\end{cases}
$$

其中：

**Gamma function（伽马函数）**

定义为：

$$
\Gamma(\alpha)=\int_0^\infty e^{-x}x^{\alpha-1}\,dx
$$

当 $\alpha=n$ 是正整数时：

$\Gamma(n)=(n-1)!$。

后面会看到：

> 独立同分布的 exponential random variables（指数随机变量）之和与 Gamma distribution（伽马分布）密切相关。

---

# 2.3.4 Normal Random Variables（正态随机变量）

如果 $X$ 的密度为：

$$
f(x)=
\frac{1}{\sqrt{2\pi}\sigma}
\exp\left(
-\frac{(x-\mu)^2}{2\sigma^2}
\right),
\qquad -\infty<x<\infty
$$

则称：

$X$ 服从参数 $(\mu,\sigma^2)$ 的 **正态分布（normal distribution）**。

记作：

$X\sim N(\mu,\sigma^2)$。

其中：

- $\mu$：mean（均值）
- $\sigma^2$：variance（方差）
- $\sigma$：standard deviation（标准差）

教材 Fig. 2.2 展示了经典的 bell-shaped curve（钟形曲线）。

---

## Linear Transformation of Normal Variables（正态变量的线性变换）

若：

$X\sim N(\mu,\sigma^2)$，

则：

$Y=\alpha X+\beta$

仍然服从正态分布，且：

$E[Y]=\alpha\mu+\beta$，

$\operatorname{Var}(Y)=\alpha^2\sigma^2$。

特别地，标准化（standardization）：

$$
Z=\frac{X-\mu}{\sigma}
$$

得到：

$Z\sim N(0,1)$。

称为：

**standard normal distribution（标准正态分布）**。

---

# 2.4 Expectation of a Random Variable（随机变量的期望）

---

# 2.4.1 The Discrete Case（离散情形）

若离散随机变量 $X$ 的 PMF 为 $p(x)$，则：

$$
E[X]=\sum_{x:p(x)>0}xp(x)
$$

称为：

- **期望（expectation）**
- **期望值（expected value）**
- 后面也称 **均值（mean）**

### 核心直觉

期望是：

> 所有可能取值按其概率加权后的平均。

但期望不一定是随机变量实际能够取得的值。

---

## 教材中的几个重要期望

### Bernoulli

$E[X]=p$。

### Binomial

$E[X]=np$。

### Geometric

$E[X]=1/p$。

### Poisson

$E[X]=\lambda$。

这些结论后面都要熟练。

---

# 2.4.2 The Continuous Case（连续情形）

若 $X$ 连续，PDF 为 $f(x)$：

$$
E[X]=\int_{-\infty}^{\infty}xf(x)\,dx
$$

教材进一步得到：

- Uniform$(\alpha,\beta)$：$E[X]=(\alpha+\beta)/2$；
- Exponential$(\lambda)$：$E[X]=1/\lambda$；
- Normal$(\mu,\sigma^2)$：$E[X]=\mu$。

---

# 2.4.3 Expectation of a Function of a Random Variable（随机变量函数的期望）

如果想求 $E[g(X)]$，并不一定要先求 $Y=g(X)$ 的完整分布。

教材 Proposition 2.1：

离散情况下：

$$
E[g(X)]
=
\sum_x g(x)p(x)
$$

连续情况下：

$$
E[g(X)]
=
\int_{-\infty}^{\infty}g(x)f(x)\,dx
$$

这个结论非常重要。

---

## Linearity of Expectation（期望的线性性）

教材 Corollary 2.2：

$E[aX+b]=aE[X]+b$。

进一步对多个随机变量：

$$
E[a_1X_1+\cdots+a_nX_n]
=
a_1E[X_1]+\cdots+a_nE[X_n]
$$

### 最重要的点

> 期望的线性性不需要随机变量之间独立。

这是后面使用 indicator variables（示性变量）的基础。

---

## Indicator Method（示性变量法）

教材 Example 2.30“帽子匹配”：

令：

$$
X_i=
\begin{cases}
1,&\text{第 }i\text{ 个人拿到自己的帽子}\\
0,&\text{否则}
\end{cases}
$$

总匹配人数：

$X=X_1+\cdots+X_N$。

由于每个人拿到自己帽子的概率是 $1/N$：

$E[X_i]=1/N$。

于是：

$$
E[X]
=
\sum_{i=1}^NE[X_i]
=
N\cdot\frac1N
=
1
$$

这说明：

> 无论总人数 $N$ 是多少，平均恰好有1个人拿到自己的帽子。

这里根本不需要各 $X_i$ 独立。

---

## Mean and Moments（均值与矩）

教材指出：

$E[X]$ 也叫：

- **mean（均值）**
- **first moment（一阶矩）**

而：

$E[X^n]$

称为：

**nth moment（$n$ 阶矩）**。

---

## Variance（方差）

定义：

$$
\operatorname{Var}(X)
=
E[(X-E[X])^2]
$$

它衡量：

> 随机变量相对于均值的波动大小。

常用恒等式：

$$
\operatorname{Var}(X)
=
E[X^2]-(E[X])^2
$$

---

## Proposition 2.2 与 Tail-Sum Formula（尾和公式）

教材进一步给出一个很有用的结果。

如果 $X$ 是非负整数值随机变量（nonnegative integer-valued random variable），则：

$$
E[X]
=
\sum_{i=1}^{\infty}P(X\ge i)
$$

这可以理解成把：

$X$

写成很多 indicator variables（示性变量）之和：

$X=I\{X\ge1\}+I\{X\ge2\}+\cdots$。

这一公式以后研究 waiting time（等待时间）、hitting time（首达时间）时很有用。

---

# 2.5 Jointly Distributed Random Variables（联合分布的随机变量）

前面研究的是一个随机变量。

现实问题中经常需要同时研究多个随机变量，例如：

- 身高与体重；
- 用户活跃度与点击率；
- 两个等待时间；
- 多个时间点的系统状态。

于是需要 joint distribution（联合分布）。

---

# 2.5.1 Joint Distribution Functions（联合分布函数）

两个随机变量 $X,Y$ 的 **联合累积分布函数（joint cumulative distribution function）** 定义为：

$$
F(a,b)=P(X\le a,Y\le b)
$$

从联合分布可以得到单个变量的分布。

例如：

$F_X(a)=F(a,\infty)$，

$F_Y(b)=F(\infty,b)$。

这些单个变量的分布称为：

**边际分布（marginal distribution）**。

---

## Joint PMF（联合概率质量函数）

如果 $X,Y$ 都是离散随机变量：

$$
p(x,y)=P(X=x,Y=y)
$$

则边际 PMF：

$$
p_X(x)=\sum_y p(x,y)
$$

$$
p_Y(y)=\sum_x p(x,y)
$$

---

## Joint PDF（联合概率密度函数）

若 $X,Y$ jointly continuous（联合连续），定义：

**联合概率密度函数（joint probability density function）** $f(x,y)$。

满足：

$$
P(X\in A,Y\in B)
=
\int_B\int_A f(x,y)\,dx\,dy
$$

边际密度：

$$
f_X(x)
=
\int_{-\infty}^{\infty}f(x,y)\,dy
$$

$$
f_Y(y)
=
\int_{-\infty}^{\infty}f(x,y)\,dx
$$

---

## Expectation of a Function of Two Variables（两个随机变量函数的期望）

离散：

$$
E[g(X,Y)]
=
\sum_y\sum_x g(x,y)p(x,y)
$$

连续：

$$
E[g(X,Y)]
=
\int_{-\infty}^{\infty}
\int_{-\infty}^{\infty}
g(x,y)f(x,y)\,dx\,dy
$$

这直接推出：

$E[X+Y]=E[X]+E[Y]$。

---

# 2.5.2 Independent Random Variables（独立随机变量）

随机变量 $X,Y$ 独立，如果对任意 $a,b$：

$$
P(X\le a,Y\le b)
=
P(X\le a)P(Y\le b)
$$

等价地：

$F(a,b)=F_X(a)F_Y(b)$。

离散情况下：

$$
p(x,y)=p_X(x)p_Y(y)
$$

连续情况下：

$$
f(x,y)=f_X(x)f_Y(y)
$$

---

## 独立带来的重要结论

教材 Proposition 2.3：

如果 $X,Y$ 独立，那么：

$$
E[g(X)h(Y)]
=
E[g(X)]E[h(Y)]
$$

特别地：

$E[XY]=E[X]E[Y]$。

后面 covariance（协方差）会直接用到这个结论。

---

# 2.5.3 Covariance and Variance of Sums of Random Variables（协方差与随机变量和的方差）

---

## Covariance（协方差）

定义：

$$
\operatorname{Cov}(X,Y)
=
E[(X-E[X])(Y-E[Y])]
$$

化简：

$$
\operatorname{Cov}(X,Y)
=
E[XY]-E[X]E[Y]
$$

直观上：

- $\operatorname{Cov}(X,Y)>0$：$X$ 较大时，$Y$ 倾向也较大；
- $\operatorname{Cov}(X,Y)<0$：$X$ 较大时，$Y$ 倾向较小。

如果 $X,Y$ 独立，则：

$\operatorname{Cov}(X,Y)=0$。

### 注意

教材这里给出的是：

> independence（独立） ⇒ zero covariance（零协方差）。

反向一般不能直接成立。

---

## Properties of Covariance（协方差的性质）

教材列出：

1. $\operatorname{Cov}(X,X)=\operatorname{Var}(X)$；
2. $\operatorname{Cov}(X,Y)=\operatorname{Cov}(Y,X)$；
3. $\operatorname{Cov}(cX,Y)=c\operatorname{Cov}(X,Y)$；
4. $\operatorname{Cov}(X,Y+Z)=\operatorname{Cov}(X,Y)+\operatorname{Cov}(X,Z)$。

进一步：

$$
\operatorname{Cov}
\left(
\sum_iX_i,\sum_jY_j
\right)
=
\sum_i\sum_j\operatorname{Cov}(X_i,Y_j)
$$

---

## Variance of a Sum（和的方差）

一般情况下：

$$
\operatorname{Var}
\left(
\sum_{i=1}^nX_i
\right)
=
\sum_{i=1}^n\operatorname{Var}(X_i)
+
2\sum_{i<j}\operatorname{Cov}(X_i,X_j)
$$

如果 $X_1,\dots,X_n$ 独立：

$$
\operatorname{Var}
\left(
\sum_{i=1}^nX_i
\right)
=
\sum_{i=1}^n\operatorname{Var}(X_i)
$$

因此一定要区分：

- expectation（期望）可加：不需要独立；
- variance（方差）直接可加：通常需要协方差为0，独立是最常见的充分条件。

---

## Sample Mean（样本均值）

如果 $X_1,\dots,X_n$ **独立同分布（independent and identically distributed, i.i.d.）**，定义：

$$
\bar X
=
\frac1n\sum_{i=1}^nX_i
$$

称为：

**样本均值（sample mean）**。

若：

$E[X_i]=\mu$，$\operatorname{Var}(X_i)=\sigma^2$，

则：

$E[\bar X]=\mu$，

$\operatorname{Var}(\bar X)=\sigma^2/n$。

这解释了一个核心统计规律：

> 样本越多，样本均值越稳定。

---

## Hypergeometric Distribution（超几何分布）

教材 Example 2.37 从有限总体不放回抽样引入 **超几何分布（hypergeometric distribution）**。

如果总体中：

- 总数 $N$；
- 其中 $Np$ 个“成功”对象；
- 不放回抽取 $n$ 个；

抽到 $k$ 个成功对象的概率为：

$$
P(X=k)
=
\frac{
\binom{Np}{k}
\binom{N-Np}{n-k}
}{
\binom{N}{n}
}
$$

与 binomial（二项）相比，关键差别是：

> hypergeometric 是 without replacement（不放回抽样），所以各次抽样之间不独立。

---

## Convolution（卷积）

如果 $X,Y$ 独立，要求 $X+Y$ 的分布，就会出现 **卷积（convolution）**。

连续情况下：

$$
f_{X+Y}(a)
=
\int_{-\infty}^{\infty}
f_X(a-y)f_Y(y)\,dy
$$

教材 Example 2.38：

两个独立 $U(0,1)$ 相加，得到分段三角形密度。

教材 Example 2.39：

如果：

$X\sim\operatorname{Poisson}(\lambda_1)$，

$Y\sim\operatorname{Poisson}(\lambda_2)$，

且独立，则：

$$
X+Y
\sim
\operatorname{Poisson}(\lambda_1+\lambda_2)
$$

---

## Order Statistics（次序统计量）

如果 $X_1,\dots,X_n$ 是 i.i.d. continuous random variables（独立同分布连续随机变量），将它们从小到大排列：

$X_{(1)},X_{(2)},\dots,X_{(n)}$，

称为：

**次序统计量（order statistics）**。

其中：

- $X_{(1)}$：minimum（最小值）；
- $X_{(n)}$：maximum（最大值）；
- 中间位置可以对应 median（中位数）。

教材给出：

$$
P(X_{(i)}\le x)
=
\sum_{k=i}^{n}
\binom{n}{k}
F(x)^k
(1-F(x))^{n-k}
$$

为什么？

因为：

> 第 $i$ 小的值不超过 $x$  
> 等价于至少有 $i$ 个样本不超过 $x$。

---

# 2.5.4 Joint Probability Distribution of Functions of Random Variables（随机变量函数的联合分布）

这一节研究变量变换。

例如：

$Y_1=g_1(X_1,X_2)$，

$Y_2=g_2(X_1,X_2)$。

如果变换可逆，并满足一定可微条件，就可以通过：

**Jacobian determinant（雅可比行列式）**

求新变量的联合密度。

教材公式：

$$
f_{Y_1,Y_2}(y_1,y_2)
=
f_{X_1,X_2}(x_1,x_2)
|J(x_1,x_2)|^{-1}
$$

这里 $J$ 是：

$$
J(x_1,x_2)
=
\begin{vmatrix}
\dfrac{\partial g_1}{\partial x_1} &
\dfrac{\partial g_1}{\partial x_2}\\
\dfrac{\partial g_2}{\partial x_1} &
\dfrac{\partial g_2}{\partial x_2}
\end{vmatrix}
$$

---

## 教材 Example 2.41：Gamma → Gamma + Beta

若 $X,Y$ 是独立 Gamma 随机变量，定义：

$U=X+Y$，

$V=X/(X+Y)$。

教材通过 Jacobian transformation（雅可比变换）证明：

- $U$ 与 $V$ 独立；
- $U$ 仍服从 Gamma；
- $V$ 服从 **Beta distribution（贝塔分布）**。

这个例子主要是帮助理解：

> 多变量密度经过变量变换后，如何通过 Jacobian 得到新的联合分布。

---

# 2.6 Moment Generating Functions（矩母函数）

---

## 2.6.1 Definition of MGF（矩母函数定义）

随机变量 $X$ 的 **矩母函数（moment generating function, MGF）** 定义为：

$$
\phi(t)=E[e^{tX}]
$$

离散情况下：

$$
\phi(t)
=
\sum_x e^{tx}p(x)
$$

连续情况下：

$$
\phi(t)
=
\int_{-\infty}^{\infty}
e^{tx}f(x)\,dx
$$

---

## 为什么叫 Moment Generating Function（矩母函数）？

因为通过对 $\phi(t)$ 求导可以产生 moments（矩）。

例如：

$\phi'(0)=E[X]$，

$\phi''(0)=E[X^2]$。

一般：

$$
\phi^{(n)}(0)=E[X^n]
$$

---

## 教材常见分布的 MGF

### Binomial$(n,p)$

$$
\phi(t)
=
(pe^t+1-p)^n
$$

### Poisson$(\lambda)$

$$
\phi(t)
=
\exp\{\lambda(e^t-1)\}
$$

### Exponential$(\lambda)$

$$
\phi(t)
=
\frac{\lambda}{\lambda-t},
\qquad t<\lambda
$$

### Normal$(\mu,\sigma^2)$

$$
\phi(t)
=
\exp\left(
\mu t+\frac{\sigma^2t^2}{2}
\right)
$$

教材 Table 2.1 和 Table 2.2 专门汇总了这些分布的：

- PMF / PDF；
- MGF；
- mean（均值）；
- variance（方差）。

---

## MGF of a Sum of Independent Random Variables（独立随机变量之和的矩母函数）

如果 $X,Y$ 独立：

$$
\phi_{X+Y}(t)
=
\phi_X(t)\phi_Y(t)
$$

原因：

$$
E[e^{t(X+Y)}]
=
E[e^{tX}e^{tY}]
=
E[e^{tX}]E[e^{tY}]
$$

最后一步使用 independence（独立性）。

---

## MGF Uniquely Determines the Distribution（矩母函数唯一决定分布）

教材强调：

> moment generating function uniquely determines the distribution.

即在相应条件下：

> 如果两个随机变量的 MGF 相同，那么它们的分布相同。

因此 MGF 不仅能算矩，还能用来识别 distribution（分布）。

---

## 教材 Examples 2.46–2.48：用 MGF 求和分布

### 独立 Binomial 相加

如果：

$X\sim\operatorname{Binomial}(n,p)$，

$Y\sim\operatorname{Binomial}(m,p)$，

且独立，则：

$X+Y\sim\operatorname{Binomial}(n+m,p)$。

### 独立 Poisson 相加

如果：

$X\sim\operatorname{Poisson}(\lambda_1)$，

$Y\sim\operatorname{Poisson}(\lambda_2)$，

则：

$X+Y\sim\operatorname{Poisson}(\lambda_1+\lambda_2)$。

### 独立 Normal 相加

如果：

$X\sim N(\mu_1,\sigma_1^2)$，

$Y\sim N(\mu_2,\sigma_2^2)$，

则：

$$
X+Y
\sim
N(\mu_1+\mu_2,\sigma_1^2+\sigma_2^2)
$$

---

## Poisson Paradigm（泊松范式）

教材 Example 2.49 把之前的 Poisson approximation（泊松近似）进一步推广。

如果有很多 trial（试验）：

- 每次成功概率都很小；
- 试验独立，或者依赖非常弱（weakly dependent）；

那么成功总次数往往近似服从 Poisson distribution（泊松分布）。

这称为：

**Poisson paradigm（泊松范式）**。

教材甚至用帽子匹配说明：

> 即使事件不是完全独立，只要依赖足够弱，仍可能表现出 Poisson 近似。

---

## Laplace Transform（拉普拉斯变换）

对于非负随机变量 $X$，教材定义：

$$
g(t)=E[e^{-tX}]=\phi(-t)
$$

称为：

**拉普拉斯变换（Laplace transform）**。

如果 $X\ge0$ 且 $t\ge0$：

$0\le e^{-tX}\le1$。

所以 Laplace transform 在非负随机变量中非常自然。

后面 queueing theory（排队论）、renewal theory（更新理论）里会经常见到。

---

## Joint Moment Generating Function（联合矩母函数）

对于 $X_1,\dots,X_n$：

$$
\phi(t_1,\dots,t_n)
=
E[
e^{t_1X_1+\cdots+t_nX_n}
]
$$

称为：

**联合矩母函数（joint moment generating function）**。

它唯一决定 joint distribution（联合分布）。

---

## Multivariate Normal Distribution（多元正态分布）

教材 Example 2.50：

如果 $X_1,\dots,X_m$ 是若干 independent standard normals（独立标准正态变量）的线性组合，则它们具有：

**多元正态分布（multivariate normal distribution）**。

教材的关键结论：

> 多元正态分布完全由各变量的 mean（均值）和 covariance（协方差）决定。

这是后面 Gaussian process（高斯过程）等内容的重要基础。

---

# 2.6.1 The Joint Distribution of the Sample Mean and Sample Variance from a Normal Population  
# 正态总体中样本均值与样本方差的联合分布

这是 Ch2 中统计学味道最强的一节。

假设：

$X_1,\dots,X_n$

是 i.i.d. normal random variables（独立同分布正态随机变量），均值 $\mu$，方差 $\sigma^2$。

定义：

**样本均值（sample mean）**

$$
\bar X=\frac1n\sum_{i=1}^nX_i
$$

**样本方差（sample variance）**

$$
S^2
=
\frac{
\sum_{i=1}^{n}(X_i-\bar X)^2
}{
n-1
}
$$

---

## Sample Variance Is Unbiased（样本方差无偏）

教材先证明：

$E[S^2]=\sigma^2$。

这意味着 $S^2$ 是 $\sigma^2$ 的：

**无偏估计量（unbiased estimator）**。

---

## Chi-Squared Random Variable（卡方随机变量）

如果：

$Z_1,\dots,Z_n$

是 independent standard normal random variables（独立标准正态变量），则：

$$
\sum_{i=1}^{n}Z_i^2
$$

称为：

**卡方随机变量（chi-squared random variable）**，

其 **自由度（degrees of freedom）** 为 $n$。

记作：

$\chi_n^2$。

---

## Proposition 2.5：正态样本的三个核心结论

如果：

$X_i\overset{i.i.d.}{\sim}N(\mu,\sigma^2)$，

那么：

### 1. 样本均值的分布

$$
\bar X
\sim
N\left(\mu,\frac{\sigma^2}{n}\right)
$$

### 2. 样本均值与样本方差独立

$\bar X$ 与 $S^2$ independent（独立）。

### 3. 样本方差的卡方关系

$$
\frac{(n-1)S^2}{\sigma^2}
\sim
\chi_{n-1}^2
$$

这三条是后续 mathematical statistics（数理统计）中非常核心的结论。

---

# 2.7 Limit Theorems（极限定理）

这一节从“有限样本的概率”开始进入：

> 当样本数 $n$ 很大时，会出现什么稳定规律？

---

## 2.7.1 Markov's Inequality（Markov 不等式）

如果 $X\ge0$，且 $a>0$：

$$
P(X\ge a)
\le
\frac{E[X]}{a}
$$

意义：

> 只知道一个非负随机变量的均值，也能给出尾部概率上界。

它通常比较粗，但适用条件很弱。

---

## 2.7.2 Chebyshev's Inequality（Chebyshev 不等式）

如果：

$E[X]=\mu$，

$\operatorname{Var}(X)=\sigma^2$，

那么对任意 $k>0$：

$$
P(|X-\mu|\ge k)
\le
\frac{\sigma^2}{k^2}
$$

意义：

> 只知道均值和方差，就能控制随机变量偏离均值的概率。

教材强调：

Markov 和 Chebyshev 的价值在于：

> 即使不知道完整分布，也能得到 probability bound（概率界）。

---

## Strong Law of Large Numbers, SLLN（强大数定律）

教材 Theorem 2.1：

如果 $X_1,X_2,\dots$ independent（独立），且具有相同分布，$E[X_i]=\mu$，那么：

$$
\frac{X_1+\cdots+X_n}{n}
\to
\mu
$$

with probability 1（以概率1）。

通常也称：

**almost surely（几乎必然）收敛**。

写作：

$\bar X_n\to\mu$ almost surely。

---

## 大数定律的频率解释

如果每次试验事件 $E$ 是否发生，用 indicator variable（示性变量）表示：

$$
X_i=
\begin{cases}
1,&E\text{ occurs}\\
0,&E\text{ does not occur}
\end{cases}
$$

则：

$E[X_i]=P(E)$。

因此：

$$
\frac{X_1+\cdots+X_n}{n}
\to
P(E)
$$

左边就是：

> 前 $n$ 次试验中事件 $E$ 的经验频率（empirical frequency）。

所以大数定律说明：

> 长期经验频率趋近理论概率。

---

## Central Limit Theorem, CLT（中心极限定理）

教材 Theorem 2.2：

如果 $X_1,X_2,\dots$ i.i.d.，均值 $\mu$，方差 $\sigma^2$，则：

$$
\frac{
X_1+\cdots+X_n-n\mu
}{
\sigma\sqrt n
}
$$

的分布趋近于：

$N(0,1)$。

也可以用样本均值写成：

$$
\frac{
\bar X_n-\mu
}{
\sigma/\sqrt n
}
\overset{d}{\longrightarrow}
N(0,1)
$$

其中：

**converges in distribution（依分布收敛）**。

---

## SLLN 和 CLT 的区别

### SLLN（强大数定律）

回答：

> 样本均值最终靠近哪里？

答案：

$\mu$。

### CLT（中心极限定理）

回答：

> 样本均值围绕 $\mu$ 的随机波动长什么样？

答案：

> 经过标准化以后近似 Normal（正态）。

因此可以理解为：

- LLN：讲 **长期稳定位置（long-run location）**；
- CLT：讲 **围绕稳定位置的波动分布（fluctuation distribution）**。

---

## Normal Approximation to the Binomial（二项分布的正态近似）

如果：

$X\sim\operatorname{Binomial}(n,p)$，

那么：

$E[X]=np$，

$\operatorname{Var}(X)=np(1-p)$。

当 $n$ 足够大时：

$$
X
\approx
N(np,np(1-p))
$$

教材给出经验条件：

$np(1-p)\ge10$

时，正态近似通常较好。

---

## Continuity Correction（连续性修正）

教材 Example 2.52 中，为了用连续 Normal 去近似离散 Binomial：

原本：

$P(X=20)$

改写为：

$P(19.5<X<20.5)$。

这种处理通常称为：

**连续性修正（continuity correction）**。

---

## 教材的 CLT Heuristic Proof（中心极限定理启发式证明）

教材后面给了一个基于 MGF 的 heuristic proof（启发式证明）：

对于均值0、方差1的 i.i.d. $X_i$，考虑：

$$
\frac{X_1+\cdots+X_n}{\sqrt n}
$$

其 MGF 为：

$$
\left(
E[e^{tX/\sqrt n}]
\right)^n
$$

再对 $e^{tX/\sqrt n}$ 做 Taylor expansion（泰勒展开）：

$$
e^{tX/\sqrt n}
\approx
1+\frac{tX}{\sqrt n}
+\frac{t^2X^2}{2n}
$$

利用 $E[X]=0$、$E[X^2]=1$，得到：

$$
E[e^{tX/\sqrt n}]
\approx
1+\frac{t^2}{2n}
$$

于是：

$$
\left(
1+\frac{t^2}{2n}
\right)^n
\to
e^{t^2/2}
$$

而 $e^{t^2/2}$ 正是 standard normal（标准正态）的 MGF。

这说明：

> 标准化和的 MGF 趋近标准正态 MGF，从而解释 CLT 为什么会出现正态分布。

---

# 2.8 Proof of the Strong Law of Large Numbers（强大数定律的证明）

这一节比前面理论性更强。

如果当前目标是随机过程应用，可以掌握证明主线，不必逐行背细节。

---

## Borel–Cantelli Lemma（Borel–Cantelli 引理）

设 $A_1,A_2,\dots$ 是事件序列。

如果：

$$
\sum_{i=1}^{\infty}P(A_i)<\infty
$$

那么：

> 只有有限多个 $A_i$ 会发生，几乎不会出现“无限多个事件发生”。

教材写成：

$P(N=\infty)=0$，

其中 $N$ 表示发生的事件总数。

常见英文表达：

**infinitely often（无限多次发生）**。

---

## 用 Borel–Cantelli 证明 SLLN 的困难

我们想证明：

$\bar X_n\to\mu$。

也就是对任意 $\varepsilon>0$：

$|\bar X_n-\mu|>\varepsilon$

最终只发生有限次。

自然想用：

$$
\sum_{n=1}^{\infty}
P(|\bar X_n-\mu|>\varepsilon)
<\infty
$$

但是用 Chebyshev：

$$
P(|\bar X_n-\mu|>\varepsilon)
\le
\frac{\sigma^2}{n\varepsilon^2}
$$

于是：

$$
\sum_{n=1}^{\infty}
\frac1n
=
\infty
$$

所以直接用 Borel–Cantelli 不行。

---

## 教材证明的核心技巧：Subsequence（子序列）

Ross 先选：

$n_j\approx\alpha^j$，其中 $\alpha>1$。

因为：

$$
\sum_j\frac1{n_j}
<\infty
$$

所以可以先证明：

$\bar X_{n_j}\to\mu$。

然后再利用夹逼，把子序列结论推广到所有 $n$。

因此这一节最值得记住的证明结构是：

> **Chebyshev inequality（Chebyshev 不等式）  
> → Borel–Cantelli lemma（Borel–Cantelli 引理）  
> → subsequence（子序列）  
> → squeeze argument（夹逼思想）  
> → SLLN（强大数定律）**

---

## Converse to Borel–Cantelli Lemma（Borel–Cantelli 逆向结果）

如果：

- $\sum_iP(A_i)=\infty$；
- 各 $A_i$ independent（独立）；

那么：

> 无限多个 $A_i$ 发生的概率为1。

教材随后用这个结果和 SLLN 分析一个“随机探索 + 当前最优选择”的 drug selection（药物选择）策略。

这个例子说明：

> 极限定理不仅是纯理论，也可以分析长期决策策略的行为。

---

# 2.9 Stochastic Processes（随机过程）

这一节是 Ch2 的终点，也是后面整本 stochastic processes（随机过程）内容的入口。

---

## 2.9.1 Definition of a Stochastic Process（随机过程定义）

教材定义：

$$
\{X(t),t\in T\}
$$

是一族 random variables（随机变量）。

称为：

**随机过程（stochastic process）**。

其中：

- $t$：index（指标），通常解释为 time（时间）；
- $T$：index set（指标集）；
- $X(t)$：state at time $t$（时刻 $t$ 的状态）。

---

## Discrete-Time Process（离散时间随机过程）

如果 index set $T$ 是可数集合，例如：

$T=\{0,1,2,\dots\}$，

那么：

$\{X_n,n=0,1,2,\dots\}$

称为：

**离散时间随机过程（discrete-time stochastic process）**。

---

## Continuous-Time Process（连续时间随机过程）

如果 $T$ 是实数区间，例如：

$T=[0,\infty)$，

那么：

$\{X(t),t\ge0\}$

称为：

**连续时间随机过程（continuous-time stochastic process）**。

---

## State Space（状态空间）

所有 $X(t)$ 可能取到的值组成：

**状态空间（state space）**。

例如：

$X(t)=$ 时刻 $t$ 超市中的顾客人数。

那么状态空间可以是：

$\{0,1,2,\dots\}$。

---

## 随机变量 vs 随机过程

一个 random variable（随机变量）：

> 对一次随机试验给出一个随机数值。

一个 stochastic process（随机过程）：

> 对每一个时间 $t$ 都有一个随机变量 $X(t)$。

所以随机过程可以理解成：

> 一个随时间演化的随机系统。

---

## 教材 Example 2.56：Circle Random Walk（环上的随机游走）

教材考虑一个粒子在 $m+1$ 个环形节点上移动。

每一步：

- clockwise（顺时针）概率 $1/2$；
- counterclockwise（逆时针）概率 $1/2$。

如果 $X_n$ 是第 $n$ 步后的位置，则：

$$
P(X_{n+1}=i+1\mid X_n=i)
=
P(X_{n+1}=i-1\mid X_n=i)
=
\frac12
$$

这已经在为 Ch4 的 **Markov chain（马尔可夫链）** 做铺垫。

教材进一步把它与：

**gambler's ruin（赌徒破产问题）**

联系起来，得到：

$$
P(\text{gambler is up }k\text{ before being down }n)
=
\frac{n}{n+k}
$$

这一结果以后还会在 Ch4.5 重新出现。

---

# Ch1 + Ch2 的核心知识网络

```text
事件层面 Event Level
────────────────────────────
Sample Space 样本空间
→ Event 事件
→ Probability 概率
→ Conditional Probability 条件概率
→ Independence 独立
→ Bayes' Formula 贝叶斯公式
→ Continuity of Probability 概率连续性

随机变量层面 Random-Variable Level
────────────────────────────
Random Variable 随机变量
→ PMF / PDF / CDF
→ Common Distributions 常见分布
→ Expectation 期望
→ Variance 方差
→ Joint Distribution 联合分布
→ Independence 独立
→ Covariance 协方差
→ Convolution 卷积
→ Transformation / Jacobian 变量变换 / 雅可比
→ MGF 矩母函数
→ Limit Theorems 极限定理
→ Stochastic Process 随机过程
```

---

# Ch1 + Ch2 最重要的概念区别

## 1. Outcome（结果） vs Event（事件）

- outcome：一次具体结果；
- event：一组结果组成的集合。

## 2. Mutually Exclusive（互斥） vs Independent（独立）

- 互斥：不能同时发生；
- 独立：一个事件发生不改变另一个事件概率。

## 3. PMF（概率质量函数） vs PDF（概率密度函数）

- PMF：$p(x)=P(X=x)$；
- PDF：$f(x)$ 不是 $P(X=x)$，概率要通过积分得到。

## 4. Expectation（期望） vs Variance（方差）

- expectation：中心位置；
- variance：围绕中心的波动程度。

## 5. Independent（独立） vs Zero Covariance（零协方差）

- 独立一定推出协方差为0；
- 一般情况下零协方差不能反推出独立。

## 6. LLN（大数定律） vs CLT（中心极限定理）

- LLN：样本均值趋向 $\mu$；
- CLT：标准化波动趋向 Normal。

## 7. Random Variable（随机变量） vs Stochastic Process（随机过程）

- random variable：一个随机数值；
- stochastic process：随 index/time 变化的一族随机变量。

---

# 英文术语总表

| 中文 | English |
|---|---|
| 概率模型 | probability model |
| 试验 | experiment |
| 结果 | outcome |
| 样本点 | sample point |
| 样本空间 | sample space |
| 事件 | event |
| 并集 | union |
| 交集 | intersection |
| 空事件 | null event / empty event |
| 互斥 | mutually exclusive |
| 补集 | complement |
| 概率 | probability |
| 概率公理 | probability axioms |
| 非负性 | nonnegativity |
| 可列可加性 | countable additivity |
| 容斥公式 | inclusion–exclusion identity |
| 条件概率 | conditional probability |
| 给定…… | given that... |
| 以……为条件 | conditional on... |
| 独立事件 | independent events |
| 依赖事件 | dependent events |
| 两两独立 | pairwise independent |
| 联合独立 | jointly independent |
| 相互独立 | mutually independent |
| 独立试验 | independent trials |
| 全概率公式 | law of total probability |
| 贝叶斯公式 | Bayes' formula / Bayes' rule |
| 递增事件列 | increasing sequence of events |
| 递减事件列 | decreasing sequence of events |
| 概率连续性 | continuity of probability |
| 随机变量 | random variable |
| 实值函数 | real-valued function |
| 示性变量 | indicator variable / indicator random variable |
| 离散随机变量 | discrete random variable |
| 连续随机变量 | continuous random variable |
| 累积分布函数 | cumulative distribution function, CDF |
| 分布函数 | distribution function |
| 概率质量函数 | probability mass function, PMF |
| 伯努利随机变量 | Bernoulli random variable |
| 二项随机变量 | binomial random variable |
| 几何随机变量 | geometric random variable |
| 泊松随机变量 | Poisson random variable |
| 泊松近似 | Poisson approximation |
| 概率密度函数 | probability density function, PDF |
| 均匀随机变量 | uniform random variable |
| 指数随机变量 | exponential random variable |
| 伽马随机变量 | gamma random variable |
| 伽马函数 | gamma function |
| 正态随机变量 | normal random variable |
| 标准正态分布 | standard normal distribution |
| 标准化 | standardization |
| 期望 | expectation / expected value |
| 均值 | mean |
| 矩 | moment |
| 方差 | variance |
| 标准差 | standard deviation |
| 尾和公式 | tail-sum formula |
| 联合分布 | joint distribution |
| 联合累积分布函数 | joint cumulative distribution function |
| 边际分布 | marginal distribution |
| 联合概率质量函数 | joint probability mass function |
| 联合概率密度函数 | joint probability density function |
| 独立随机变量 | independent random variables |
| 协方差 | covariance |
| 样本均值 | sample mean |
| 独立同分布 | independent and identically distributed, i.i.d. |
| 超几何分布 | hypergeometric distribution |
| 卷积 | convolution |
| 次序统计量 | order statistics |
| 变量变换 | transformation of random variables |
| 雅可比行列式 | Jacobian determinant |
| 贝塔分布 | beta distribution |
| 矩母函数 | moment generating function, MGF |
| 拉普拉斯变换 | Laplace transform |
| 泊松范式 | Poisson paradigm |
| 联合矩母函数 | joint moment generating function |
| 多元正态分布 | multivariate normal distribution |
| 样本方差 | sample variance |
| 无偏估计量 | unbiased estimator |
| 卡方随机变量 | chi-squared random variable |
| 自由度 | degrees of freedom |
| 极限定理 | limit theorems |
| Markov不等式 | Markov's inequality |
| Chebyshev不等式 | Chebyshev's inequality |
| 强大数定律 | strong law of large numbers, SLLN |
| 以概率1 | with probability 1 |
| 几乎必然 | almost surely |
| 中心极限定理 | central limit theorem, CLT |
| 依分布收敛 | convergence in distribution |
| 正态近似 | normal approximation |
| 连续性修正 | continuity correction |
| 泰勒展开 | Taylor expansion |
| Borel–Cantelli引理 | Borel–Cantelli lemma |
| 子序列 | subsequence |
| 随机过程 | stochastic process |
| 指标集 | index set |
| 状态 | state |
| 状态空间 | state space |
| 离散时间随机过程 | discrete-time stochastic process |
| 连续时间随机过程 | continuous-time stochastic process |
| 随机游走 | random walk |
| 赌徒破产问题 | gambler's ruin problem |

---

# 学完 Ch1 + Ch2 后的自检清单

你应该能够做到：

1. 用 sample space（样本空间）和 event（事件）描述一个随机问题；
2. 正确使用 union（并）、intersection（交）、complement（补）；
3. 区分 mutually exclusive（互斥）与 independent（独立）；
4. 熟练使用 conditional probability（条件概率）；
5. 会用 total probability（全概率）和 Bayes' formula（贝叶斯公式）；
6. 理解 increasing/decreasing events（递增/递减事件列）和 probability continuity（概率连续性）；
7. 知道 random variable（随机变量）是 sample space 上的实值函数；
8. 会区分 PMF、PDF、CDF；
9. 识别 Bernoulli、Binomial、Geometric、Poisson；
10. 识别 Uniform、Exponential、Gamma、Normal；
11. 会计算 expectation 和 variance；
12. 会使用 indicator variable 与 expectation linearity；
13. 会从 joint distribution 求 marginal distribution；
14. 会判断 independent random variables；
15. 会计算 covariance 和 variance of sums；
16. 理解 convolution、order statistics、Jacobian transformation；
17. 理解 MGF 的定义、求矩作用和独立和的乘积性质；
18. 掌握正态样本中 $\bar X$、$S^2$、$\chi^2$ 的关系；
19. 区分 Markov inequality、Chebyshev inequality、SLLN、CLT；
20. 知道 stochastic process、index set、state space 的含义。

---

# 最后：进入 Ch3 前最需要真正熟练的内容

Ross 在 Ch3 会正式进入 **conditional probability and conditional expectation（条件概率与条件期望）**。

所以 Ch1 + Ch2 中最重要的前置知识不是平均分布的，而是：

**第一优先级**

- conditional probability（条件概率）
- independence（独立性）
- expectation（期望）
- variance（方差）
- joint distribution（联合分布）
- indicator variable（示性变量）

**第二优先级**

- Bernoulli / Binomial / Geometric / Poisson
- Exponential / Gamma / Normal
- covariance（协方差）
- MGF（矩母函数）

**第三优先级**

- Jacobian 复杂推导
- SLLN 的完整严格证明细节

最核心的学习逻辑是：

> **Ch1 学会“对事件做条件化”；  
> Ch2 学会“把随机现象数值化并研究其分布”；  
> Ch3 再把二者结合成 conditional expectation（条件期望）。**
