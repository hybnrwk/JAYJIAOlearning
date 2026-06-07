# Week 4 讲解讲义：决策树、随机森林与 XGBoost

> 这份讲义主要依据 `英文字幕/` 中 Week 4 的讲课顺序来写，并结合 practice quiz 与 `7.Practice lab decision trees/` 中的编程实验。整体以中文讲解为主，关键术语保留中英双语，便于你之后阅读英文资料、论文、库文档和竞赛代码。

---

## 1. Week 4 在第二课中的位置

第二课 `Advanced Learning Algorithms` 的前几周主要讲：

```text
Week 1: Neural network inference
Week 2: Neural network training
Week 3: Advice for applying machine learning
Week 4: Decision trees and tree ensembles
```

Week 4 是第二课的最后一周，主题从神经网络转到另一类非常重要的监督学习算法：

```text
decision trees 决策树
tree ensembles 树集成
random forest 随机森林
XGBoost 梯度提升树
```

决策树在很多商业应用、表格数据任务、机器学习竞赛中都非常常用。

如果说神经网络尤其擅长处理：

```text
image 图像
audio 音频
text 文本
video 视频
```

那么决策树和树集成尤其擅长处理：

```text
tabular data / structured data 表格数据 / 结构化数据
```

例如：

- 房价预测。
- 信用风险评分。
- 客户流失预测。
- 欺诈检测。
- 商品销量预测。
- 用户是否点击广告。
- 医疗表格指标预测。

---

## 2. 决策树要解决什么问题

课程用一个简单的二分类例子引入：

> 根据动物的特征判断它是不是猫。

训练数据中有几个特征：

| Feature | 含义 | 可能取值 |
|---|---|---|
| ear shape | 耳朵形状 | pointy / floppy |
| face shape | 脸型 | round / not round |
| whiskers | 是否有胡须 | present / absent |
| label | 是否是猫 | cat / not cat |

这是一个 binary classification 二分类问题：

```text
y = 1: cat
y = 0: not cat
```

这一开始的特征都是 categorical features 类别特征。

也就是说，特征值不是连续数字，而是几个离散类别。

---

## 3. 什么是 Decision Tree

decision tree 决策树是一种像树一样的模型。

它由几类节点组成：

| 英文 | 中文 | 作用 |
|---|---|---|
| root node | 根节点 | 最上面的起点 |
| decision node | 决策节点 | 根据某个特征做判断 |
| branch | 分支 | 根据判断结果走向下一节点 |
| leaf node | 叶节点 | 给出最终预测 |

一个简单决策树可能长这样：

```text
Root: ear shape?
    pointy:
        face shape?
            round -> cat
            not round -> not cat
    floppy:
        whiskers?
            present -> cat
            absent -> not cat
```

预测一个新样本时，从 root node 开始，沿着特征判断一路往下走，直到 leaf node。

例如：

```text
ear shape = floppy
face shape = round
whiskers = present
```

路径是：

```text
ear shape?
    floppy -> whiskers?
        present -> cat
```

所以模型预测为 cat。

---

## 4. 决策树模型的特点

决策树的一个重要特点是：

> 它不是通过线性组合或神经网络层来计算输出，而是通过一系列 if-else 规则来预测。

例如：

```text
if ear_shape == "pointy":
    if face_shape == "round":
        predict cat
    else:
        predict not cat
else:
    if whiskers == "present":
        predict cat
    else:
        predict not cat
```

这也是为什么小型决策树具有一定 interpretability 可解释性。

你可以直接看出模型在用哪些规则做判断。

但注意：

> 单棵小树可能容易解释；包含上百棵树的 tree ensemble 就不再容易人工解释。

---

## 5. 决策树学习算法要决定什么

训练决策树时，核心问题是：

```text
在每个节点上，应该选择哪个特征来分裂？
```

例如在 root node，可以选：

```text
ear shape
face shape
whiskers
```

不同选择会产生不同的树。

决策树学习算法的目标是：

> 选择能让分裂后的子集更“纯”的特征。

所谓 pure / purity 纯度高，意思是：

```text
一个节点里的样本尽可能属于同一类
```

例如：

```text
5 只全是 cat:
    非常纯

5 只全是 not cat:
    也非常纯

2 只 cat + 3 只 not cat:
    不纯

50% cat + 50% not cat:
    最不纯
```

---

## 6. Entropy 熵：衡量不纯度

课程使用 entropy 熵来衡量一个节点的 impurity 不纯度。

设：

```text
p1 = 节点中正类样本的比例
p0 = 节点中负类样本的比例 = 1 - p1
```

对于猫分类例子：

```text
p1 = cat 的比例
p0 = not cat 的比例
```

entropy 定义为：

$$
H(p_1)
=
-p_1\log_2(p_1)
-p_0\log_2(p_0)
$$

因为：

$$
p_0=1-p_1
$$

所以也可以写成：

$$
H(p_1)
=
-p_1\log_2(p_1)
-
(1-p_1)\log_2(1-p_1)
$$

---

## 7. Entropy 的直觉

entropy 的取值规律：

| 节点组成 | `p1` | Entropy | 解释 |
|---|---:|---:|---|
| 全是负类 | 0 | 0 | 完全纯 |
| 负类多，正类少 | 1/3 | 约 0.92 | 较不纯 |
| 正负各一半 | 1/2 | 1 | 最不纯 |
| 正类多，负类少 | 5/6 | 约 0.65 | 较纯 |
| 全是正类 | 1 | 0 | 完全纯 |

关键记忆：

```text
Entropy = 0:
    节点完全纯

Entropy = 1:
    二分类中正负各一半，最不纯
```

也就是说，决策树每次分裂都希望：

> 让分裂后的子节点 entropy 尽可能低。

---

## 8. 为什么 `0 log(0)` 当作 0

entropy 公式中可能出现：

$$
0\log_2(0)
$$

数学上 `log(0)` 未定义，但在 entropy 的计算中约定：

$$
0\log(0)=0
$$

所以当：

```text
p1 = 0 或 p1 = 1
```

entropy 直接设为 0。

在代码实现时也要特别处理这个情况，否则会出现数值错误。

---

## 9. 信息增益 Information Gain

有了 entropy 后，下一步是衡量：

> 选择某个特征分裂后，不纯度降低了多少。

这个降低量叫：

```text
information gain 信息增益
```

信息增益越大，说明这个特征越适合作为当前节点的分裂特征。

直觉：

```text
分裂前:
    一个节点里 cat / not cat 混在一起

分裂后:
    左右子节点尽量各自更纯

entropy 降低越多:
    这个 split 越好
```

---

## 10. Weighted Entropy 加权熵

假设一个节点分裂成 left branch 和 right branch。

设：

```text
w_left = 进入左分支的样本比例
w_right = 进入右分支的样本比例
p1_left = 左分支中正类比例
p1_right = 右分支中正类比例
```

分裂后的加权不纯度是：

$$
w^{left}H(p_1^{left})
+
w^{right}H(p_1^{right})
$$

为什么要加权？

因为：

> 一个包含很多样本的子节点如果很不纯，比一个只包含少量样本的子节点不纯更严重。

所以左右两边的 entropy 要按样本数量比例加权。

---

## 11. Information Gain 公式

完整公式：

$$
\text{Information Gain}
=
H(p_1^{root})
-
\left[
w^{left}H(p_1^{left})
+
w^{right}H(p_1^{right})
\right]
$$

其中：

- `H(p1_root)` 是分裂前当前节点的 entropy。
- 后面一项是分裂后的 weighted entropy。

所以：

```text
information gain = 分裂前不纯度 - 分裂后加权不纯度
```

决策树算法选择：

```text
information gain 最大的特征
```

---

## 12. 一个信息增益例子

假设 root node 有：

```text
5 cats
5 not cats
```

则：

$$
p_1^{root}=0.5
$$

$$
H(0.5)=1
$$

如果按 `ear shape` 分裂：

```text
left branch:  5 个样本，其中 4 个 cat
right branch: 5 个样本，其中 1 个 cat
```

那么：

$$
p_1^{left}=4/5
$$

$$
p_1^{right}=1/5
$$

$$
w^{left}=5/10,\quad w^{right}=5/10
$$

信息增益：

$$
IG
=
H(0.5)
-
\left[
\frac{5}{10}H(4/5)
+
\frac{5}{10}H(1/5)
\right]
$$

课程中这个值约为：

$$
0.28
$$

如果其他特征的信息增益更小，就选择 `ear shape`。

---

## 13. 决策树学习流程

整体流程：

```text
1. 把所有训练样本放在 root node
2. 对每个可选特征计算 information gain
3. 选择 information gain 最大的特征分裂
4. 根据特征值把样本送到 left / right branch
5. 对每个子节点重复这个过程
6. 直到满足 stopping criteria
```

这个过程是 recursive 递归的。

所谓递归，就是：

> 构建一棵大树的问题，被拆成构建左子树和右子树的小问题。

在代码里通常会写成一个函数，它在内部再次调用自己。

---

## 14. Stopping Criteria 停止分裂条件

如果一直分裂下去，决策树可能变得非常复杂，甚至记住训练集中的噪声。

所以需要 stopping criteria。

常见停止条件：

```text
1. 当前节点已经完全纯
   例如全是 cat 或全是 not cat

2. 树已经达到 maximum depth 最大深度

3. 继续分裂带来的 information gain 太小

4. 当前节点中的样本数量低于阈值
```

quiz 中也强调了两个常见停止条件：

```text
number of examples in a node is below a threshold
tree has reached maximum depth
```

注意：

```text
节点 50% 一类、50% 另一类
```

不是停止条件。

这反而是 entropy 最高、最不纯的情况。

---

## 15. Maximum Depth 最大深度

树的 depth 深度指从 root node 到某个节点经过多少条边。

```text
root node: depth 0
root 的子节点: depth 1
再下一层: depth 2
```

`max_depth` 控制树的最大复杂度。

直觉上：

```text
max_depth 小:
    树简单
    可能 underfit

max_depth 大:
    树复杂
    更容易 overfit
```

这和前面学过的模型复杂度类似：

```text
高阶多项式 degree 越大 -> 模型越复杂
神经网络越大 -> 模型越复杂
决策树 max_depth 越大 -> 模型越复杂
```

可以用 cross-validation 来选择 `max_depth`。

---

## 16. 多类别离散特征：One-Hot Encoding

前面的例子里，每个特征只有两个取值：

```text
ear shape: pointy / floppy
face shape: round / not round
whiskers: present / absent
```

但现实中，categorical feature 可能有多个取值。

例如：

```text
ear shape: pointy / floppy / oval
```

一种处理方法是 one-hot encoding 独热编码。

把一个三分类特征变成三个二值特征：

| 原始 ear shape | pointy ears | floppy ears | oval ears |
|---|---:|---:|---:|
| pointy | 1 | 0 | 0 |
| floppy | 0 | 1 | 0 |
| oval | 0 | 0 | 1 |

如果某个动物耳朵是 oval，则表示为：

```text
[0, 0, 1]
```

---

## 17. One-Hot Encoding 的一般形式

如果一个 categorical feature 有 `k` 个可能取值：

```text
value_1, value_2, ..., value_k
```

就把它变成 `k` 个 binary features：

```text
is_value_1
is_value_2
...
is_value_k
```

每一行中只有一个位置为 1。

这也是 one-hot 这个名字的来源：

> exactly one feature is hot.

one-hot encoding 不只适用于决策树，也适用于：

- logistic regression
- neural networks
- linear models
- many tabular ML models

因为这些模型通常需要数值输入。

---

## 18. 连续值特征 Continuous-Valued Features

现实中很多特征不是类别，而是连续数值。

例如：

```text
weight = 8.2 lbs
size = 1200 square feet
age = 15 years
income = 80000
```

如果在决策树中使用连续特征，就需要把它变成判断条件：

```text
weight <= threshold ?
```

例如：

```text
weight <= 9 lbs
```

如果满足条件走左分支，否则走右分支。

---

## 19. 如何选择连续特征的 Threshold

对于连续特征，算法会尝试多个 possible thresholds。

课程推荐的做法：

```text
1. 按连续特征值从小到大排序训练样本
2. 取相邻样本值之间的 midpoint 中点作为候选阈值
3. 对每个候选阈值计算 information gain
4. 选择 information gain 最大的阈值
```

如果有 10 个样本，就有 9 个相邻中点候选阈值。

例如权重排序后：

```text
7.2, 7.6, 8.0, 10.2, 11.0, ...
```

候选阈值可以是：

```text
(7.2 + 7.6)/2
(7.6 + 8.0)/2
(8.0 + 10.2)/2
...
```

quiz 中也强调：

> 对 10 个样本的连续特征，推荐选择 9 个 midpoints 作为候选 split，并选择 information gain 最高者。

---

## 20. 连续特征的信息增益计算

假设考虑：

```text
weight <= 9
```

就把样本分成：

```text
left branch: weight <= 9
right branch: weight > 9
```

然后照常计算：

$$
IG
=
H(p_1^{root})
-
\left[
w^{left}H(p_1^{left})
+
w^{right}H(p_1^{right})
\right]
$$

所以连续特征没有改变决策树的核心逻辑。

它只是把一个特征变成多个候选阈值：

```text
feature + threshold
```

再从中选信息增益最大的。

---

## 21. Regression Trees 回归树

前面的决策树用于 classification 分类。

optional 视频讲了 regression tree 回归树。

回归树用于预测连续数值：

```text
y = weight
y = house price
y = sales
y = temperature
```

预测时，样本同样从 root node 一路走到 leaf node。

但 leaf node 不再预测类别，而是预测一个数字。

这个数字通常是：

> 落入该叶节点的训练样本 `y` 值的平均数。

例如某叶节点里的训练样本权重是：

```text
7.2, 7.6, 10.2, 8.4
```

则该叶节点预测：

$$
\frac{7.2+7.6+10.2+8.4}{4}
$$

---

## 22. 回归树如何选择 Split

分类树选择 split 时，是为了减少 entropy。

回归树选择 split 时，是为了减少 variance。

对于回归树：

```text
节点内 y 值越集中，说明越纯
节点内 y 值越分散，说明越不纯
```

所以用 variance 方差衡量不纯度。

一个 split 的质量可以用：

$$
\text{Variance Reduction}
=
\text{Variance}_{root}
-
\left[
w^{left}\text{Variance}_{left}
+
w^{right}\text{Variance}_{right}
\right]
$$

选择：

```text
variance reduction 最大的 split
```

这和分类树的信息增益完全对应：

| 分类树 | 回归树 |
|---|---|
| entropy | variance |
| information gain | variance reduction |
| 叶节点预测类别 | 叶节点预测平均值 |

---

## 23. 单棵决策树的问题：对数据变化很敏感

单棵决策树的一个弱点是：

> 对训练数据的小变化非常敏感。

课程中举例：

只改变一个训练样本，root node 上信息增益最大的特征可能就从：

```text
ear shape
```

变成：

```text
whiskers
```

一旦 root split 变了，后面的左右子树也可能完全不同。

这意味着：

```text
单棵树 variance 较高
稳定性不够
```

解决方法：

> 不只训练一棵树，而是训练很多棵树，让它们投票。

这就是：

```text
tree ensemble 树集成
```

---

## 24. Tree Ensemble 树集成

tree ensemble 是多棵决策树组成的模型。

预测时：

```text
每棵树都给出一个预测
然后投票或平均
```

分类任务中用 majority vote 多数投票：

```text
Tree 1 -> cat
Tree 2 -> not cat
Tree 3 -> cat

final prediction -> cat
```

回归任务中通常取平均：

```text
Tree 1 -> 10.2
Tree 2 -> 11.0
Tree 3 -> 9.8

final prediction -> average
```

为什么有效？

> 多棵树投票可以减少单棵树对训练数据偶然扰动的敏感性。

---

## 25. Sampling With Replacement 有放回抽样

为了训练多棵不同的树，需要构造多个略有不同的训练集。

这就用到：

```text
sampling with replacement 有放回抽样
```

过程：

```text
1. 从原训练集中随机抽一个样本
2. 记录下来
3. 把它放回去
4. 再随机抽下一个样本
5. 重复 m 次
```

如果原训练集有 `m` 个样本，那么抽样后也得到 `m` 个样本。

但新训练集可能：

```text
有些样本重复出现
有些原始样本一次都没出现
```

这正是有放回抽样的特点。

quiz 中也强调：

> sampling with replacement 是抽下一个样本前，把之前抽出的样本放回可抽样集合中。

---

## 26. Bagged Decision Trees

基于有放回抽样，可以构造 bagged decision trees。

算法：

```text
Given training set of size m

for b = 1 to B:
    1. 用 sampling with replacement 生成一个大小为 m 的新训练集
    2. 在这个新训练集上训练一棵 decision tree

预测时:
    让 B 棵树投票或平均
```

这里 `B` 是树的数量。

常见取值：

```text
64 到 128
100 左右很常见
```

`B` 增大通常不会让性能变差，但超过一定程度后收益递减。

例如从 100 棵增加到 1000 棵，可能只是训练和预测更慢，性能提升有限。

---

## 27. Random Forest 随机森林

random forest 在 bagged decision trees 的基础上又加了一层随机性。

问题是：

> 即使用有放回抽样，不同树仍可能在靠近 root node 的地方选择相同特征，导致树之间仍然相似。

随机森林的改进：

```text
在每个节点选择 split 时，不从全部 n 个特征中选
而是随机抽取 k 个特征
只在这 k 个特征中选择 information gain 最大的
```

如果总特征数是 `n`，常见选择：

$$
k \approx \sqrt{n}
$$

这种做法让不同树更不一样。

最终投票时，多样性更高，整体模型更 robust 稳健。

---

## 28. Random Forest 的直觉

random forest 有两个随机来源：

```text
1. 数据随机
   每棵树用 sampling with replacement 得到不同训练集

2. 特征随机
   每个节点只在随机特征子集中选择 split
```

这样做的效果：

```text
每棵树都略有不同
单棵树可能不稳定
但很多树投票后整体更稳定
```

可以把它理解为：

> 让模型主动探索训练数据的许多小扰动，然后对这些扰动平均。

这降低了某个训练样本或某个特征选择对最终预测的过度影响。

---

## 29. Boosted Trees 提升树

random forest 的每棵树大体是“平行”训练出来的。

boosting 的思想不同：

> 后一棵树更关注前面模型还做不好的样本。

课程用 deliberate practice 刻意练习类比：

如果你练钢琴，不一定每次都从头到尾弹一遍。

更高效的做法是：

```text
找出自己弹不好的小节
反复练那些地方
```

boosting 也是类似：

```text
1. 先训练一棵树
2. 看它哪些样本预测错
3. 下一棵树更关注这些错样本
4. 重复这个过程
```

这样模型会逐步补足前面模型的不足。

---

## 30. XGBoost 是什么

XGBoost 全称：

```text
Extreme Gradient Boosting
```

它是 boosted decision trees 的高效开源实现。

课程强调：

> XGBoost 是目前最常用、最有效的树集成实现之一，在 Kaggle 竞赛和商业应用中非常常见。

XGBoost 的优点：

```text
1. 训练速度快
2. 默认设置通常不错
3. 内置 regularization，能减少 overfitting
4. 支持 classification 和 regression
5. 在结构化表格数据上表现强
```

课程没有要求手写 XGBoost 的数学细节。

实际使用时通常直接调用库。

---

## 31. XGBoost 的代码使用

分类任务：

```python
from xgboost import XGBClassifier

model = XGBClassifier()
model.fit(X_train, y_train)

y_pred = model.predict(X_test)
```

回归任务：

```python
from xgboost import XGBRegressor

model = XGBRegressor()
model.fit(X_train, y_train)

y_pred = model.predict(X_test)
```

虽然底层细节复杂，但使用接口很直接。

这也是课程建议的实践态度：

> 理解核心思想，但工程中使用成熟开源库。

---

## 32. Decision Trees vs Neural Networks

课程最后比较了：

```text
decision trees / tree ensembles
neural networks
```

### 决策树和树集成适合

```text
tabular data / structured data
```

也就是像表格一样的数据：

| size | bedrooms | floors | age | price |
|---:|---:|---:|---:|---:|
| 1200 | 3 | 2 | 10 | 300000 |
| 900 | 2 | 1 | 30 | 200000 |

优点：

```text
1. 对表格数据效果强
2. 训练通常很快
3. 小决策树可解释
4. XGBoost 在实际项目中很常用
```

缺点：

```text
1. 不太适合图像、音频、文本等非结构化数据
2. 大型 tree ensemble 不容易人工解释
3. 很难像神经网络一样端到端组合多个模型一起训练
```

---

## 33. 神经网络适合

neural networks 适合：

```text
unstructured data 非结构化数据
```

例如：

- image
- video
- audio
- text

也适合 mixed data 混合数据。

神经网络的优点：

```text
1. 对图像、语音、文本效果强
2. 支持 transfer learning
3. 可以把多个网络串起来端到端训练
4. 对非结构化数据是首选
```

缺点：

```text
1. 训练可能更慢
2. 需要更多计算资源
3. 调参和架构设计可能更复杂
```

---

## 34. 怎么选择模型

一个实用选择表：

| 数据类型 | 推荐优先尝试 |
|---|---|
| 表格数据 / 结构化数据 | XGBoost、random forest、decision tree |
| 图像 | neural network |
| 音频 | neural network |
| 文本 | neural network |
| 视频 | neural network |
| 表格 + 图像混合 | neural network 或组合模型 |
| 小型可解释规则需求 | small decision tree |
| 竞赛表格数据 | XGBoost 常常很强 |

一个简单经验：

```text
如果数据像 spreadsheet:
    优先试 tree ensemble，尤其 XGBoost

如果数据像 image/audio/text:
    优先试 neural network
```

---

## 35. Practice Lab：蘑菇是否可食用

week4 practice lab 让你从零实现一个简单决策树，用来判断蘑菇是否 edible 可食用。

数据集有 10 个样本。

原始特征：

| Feature | 含义 | 取值 |
|---|---|---|
| Cap Color | 菌盖颜色 | Brown / Red |
| Stalk Shape | 菌柄形状 | Tapering / Enlarging |
| Solitary | 是否单生 | Yes / No |
| Edible | 是否可食用 | 1 / 0 |

为了方便实现，实验把特征 one-hot / binary 化：

| Feature | 解释 |
|---|---|
| Brown Cap | 1 表示 Brown，0 表示 Red |
| Tapering Stalk Shape | 1 表示 Tapering，0 表示 Enlarging |
| Solitary | 1 表示 Yes，0 表示 No |

标签：

```text
y = 1: edible
y = 0: poisonous
```

实验提醒：

> 这个数据集只是教学用，不应用作真实蘑菇可食用判断。

---

## 36. Practice Lab 1：`compute_entropy`

实验第一个函数是计算节点 entropy。

目标：

```python
def compute_entropy(y):
    ...
```

其中 `y` 是当前节点样本的标签数组。

实现逻辑：

```python
def compute_entropy(y):
    entropy = 0.

    if len(y) != 0:
        p1 = len(y[y == 1]) / len(y)

        if p1 != 0 and p1 != 1:
            entropy = -p1 * np.log2(p1) - (1 - p1) * np.log2(1 - p1)
        else:
            entropy = 0.

    return entropy
```

要点：

```text
1. 先计算 p1
2. p1 为 0 或 1 时 entropy = 0
3. 其他情况套用 entropy 公式
4. 空节点返回 0
```

root node 中 5 个 edible、5 个 poisonous：

$$
p_1=0.5
$$

所以：

$$
H(0.5)=1
$$

---

## 37. Practice Lab 2：`split_dataset`

第二个函数是根据某个 feature 把当前节点样本分成左右两支。

```python
def split_dataset(X, node_indices, feature):
    ...
```

规则：

```text
如果 X[i][feature] == 1:
    进入 left_indices

如果 X[i][feature] == 0:
    进入 right_indices
```

实现：

```python
def split_dataset(X, node_indices, feature):
    left_indices = []
    right_indices = []

    for i in node_indices:
        if X[i][feature] == 1:
            left_indices.append(i)
        else:
            right_indices.append(i)

    return left_indices, right_indices
```

这个函数只负责“按某个特征分开”，还不判断这个分裂好不好。

分裂好不好由 information gain 决定。

---

## 38. Practice Lab 3：`compute_information_gain`

第三个函数是计算某个 feature 的 information gain。

```python
def compute_information_gain(X, y, node_indices, feature):
    ...
```

步骤：

```text
1. 用 split_dataset 得到 left_indices 和 right_indices
2. 取出当前节点 y_node
3. 取出左分支 y_left
4. 取出右分支 y_right
5. 计算 node entropy
6. 计算 left entropy 和 right entropy
7. 计算 w_left 和 w_right
8. 计算 weighted entropy
9. information gain = node entropy - weighted entropy
```

实现：

```python
def compute_information_gain(X, y, node_indices, feature):
    left_indices, right_indices = split_dataset(X, node_indices, feature)

    X_node, y_node = X[node_indices], y[node_indices]
    X_left, y_left = X[left_indices], y[left_indices]
    X_right, y_right = X[right_indices], y[right_indices]

    node_entropy = compute_entropy(y_node)
    left_entropy = compute_entropy(y_left)
    right_entropy = compute_entropy(y_right)

    w_left = len(X_left) / len(X_node)
    w_right = len(X_right) / len(X_node)

    weighted_entropy = w_left * left_entropy + w_right * right_entropy
    information_gain = node_entropy - weighted_entropy

    return information_gain
```

实验中 root node 三个特征的信息增益大约是：

```text
Brown Cap:              0.03485
Tapering Stalk Shape:   0.12451
Solitary:               0.27807
```

所以 root node 最适合按：

```text
Solitary
```

分裂。

---

## 39. Practice Lab 4：`get_best_split`

第四个函数是遍历所有特征，找 information gain 最大的特征。

```python
def get_best_split(X, y, node_indices):
    ...
```

实现：

```python
def get_best_split(X, y, node_indices):
    num_features = X.shape[1]
    best_feature = -1
    max_info_gain = 0

    for feature in range(num_features):
        info_gain = compute_information_gain(X, y, node_indices, feature)

        if info_gain > max_info_gain:
            max_info_gain = info_gain
            best_feature = feature

    return best_feature
```

注意：

```text
best_feature 初始为 -1
```

如果当前节点已经很纯，所有 feature 的 information gain 都是 0，那么返回 `-1`，表示没有必要继续分裂。

---

## 40. Practice Lab 5：递归建树

实验中给了一个递归建树函数：

```python
def build_tree_recursive(
    X,
    y,
    node_indices,
    branch_name,
    max_depth,
    current_depth
):
    ...
```

核心逻辑：

```text
如果 current_depth == max_depth:
    停止分裂，创建 leaf node

否则:
    选择 best_feature
    根据 best_feature 分裂数据
    递归构建左子树
    递归构建右子树
```

简化逻辑：

```python
if current_depth == max_depth:
    return

best_feature = get_best_split(X, y, node_indices)
left_indices, right_indices = split_dataset(X, node_indices, best_feature)

build_tree_recursive(X, y, left_indices, "Left", max_depth, current_depth + 1)
build_tree_recursive(X, y, right_indices, "Right", max_depth, current_depth + 1)
```

实验中设：

```python
max_depth = 2
```

所以树最多分裂到 depth 2。

这体现了课程讲的 stopping criteria。

---

## 41. Quiz 高频考点

week4 quiz 重点如下。

### 1. 如何沿着决策树预测

从 root node 开始，根据样本特征走分支，直到 leaf node。

例如：

```text
floppy ears
whiskers present
```

可能走到 `cat` 的叶节点。

### 2. 最纯的分裂

如果分裂结果是：

```text
left: 10/10 spam
right: 0/10 spam
```

这是最纯的。

因为两个子节点都只有单一类别。

### 3. Entropy 公式

如果：

```text
p1 = 0.6
p0 = 0.4
```

则：

$$
H(p_1)
=
-(0.6)\log_2(0.6)
-
(0.4)\log_2(0.4)
$$

### 4. Information Gain 公式

如果 root 是 5 正 5 负，分裂后：

```text
left: 7 个样本，其中 4 个正类
right: 3 个样本，其中 1 个正类
```

信息增益：

$$
H(0.5)
-
\left[
\frac{7}{10}H(4/7)
+
\frac{3}{10}H(1/3)
\right]
$$

### 5. One-hot

`oval ears` 在 `[pointy, floppy, oval]` 中表示为：

```text
[0, 0, 1]
```

### 6. 连续特征

10 个样本的连续特征，推荐取 9 个相邻 midpoint 作为候选阈值。

### 7. 停止条件

常见停止条件包括：

```text
节点样本数低于阈值
达到 maximum depth
```

### 8. Random forest

为了让每棵树不同，使用：

```text
sampling with replacement
```

### 9. 图像分类

如果输入是 `100x100` 图像，属于 unstructured data。

通常优先选择：

```text
neural network
```

---

## 42. Week 4 关键词表

| 英文 | 中文 | 解释 |
|---|---|---|
| decision tree | 决策树 | 用树状规则进行预测的模型 |
| root node | 根节点 | 决策树最顶部节点 |
| decision node | 决策节点 | 根据特征选择分支 |
| leaf node | 叶节点 | 输出最终预测 |
| branch | 分支 | 判断后通往下一个节点的路径 |
| categorical feature | 类别特征 | 取离散类别值的特征 |
| continuous feature | 连续特征 | 取连续数值的特征 |
| entropy | 熵 | 衡量节点不纯度 |
| purity | 纯度 | 节点中样本是否属于同一类 |
| impurity | 不纯度 | 节点中类别混杂程度 |
| information gain | 信息增益 | 分裂前后 entropy 的降低量 |
| weighted entropy | 加权熵 | 左右子节点 entropy 的加权平均 |
| one-hot encoding | 独热编码 | 把类别特征变成多个二值特征 |
| threshold | 阈值 | 连续特征分裂的切分点 |
| recursive algorithm | 递归算法 | 函数调用自身来构建子树 |
| stopping criteria | 停止条件 | 决定何时不再分裂 |
| max depth | 最大深度 | 控制树复杂度的参数 |
| regression tree | 回归树 | 用决策树预测连续数值 |
| variance reduction | 方差降低 | 回归树中选择 split 的指标 |
| tree ensemble | 树集成 | 多棵树组合成一个模型 |
| bagging | 装袋法 | 用有放回抽样训练多棵树 |
| sampling with replacement | 有放回抽样 | 抽样后放回再抽 |
| random forest | 随机森林 | bagging 加特征随机选择 |
| boosting | 提升法 | 后续模型关注前面模型做错的样本 |
| XGBoost | 极端梯度提升 | 高效的 boosted trees 实现 |
| structured data | 结构化数据 | 表格型数据 |
| unstructured data | 非结构化数据 | 图像、音频、文本等 |

---

## 43. 本周内容的逻辑闭环

Week 4 的逻辑可以串成一条线：

```text
想用规则预测类别
    ↓
构建 decision tree
    ↓
每个节点选择一个特征来 split
    ↓
用 entropy 衡量节点不纯度
    ↓
用 information gain 衡量 split 的好坏
    ↓
递归地构建左右子树
    ↓
用 stopping criteria 防止树过深、过拟合
    ↓
用 one-hot 处理多类别离散特征
    ↓
用候选 threshold 处理连续值特征
    ↓
如果是回归问题，用 variance reduction 替代 information gain
    ↓
单棵树不够稳定
    ↓
用 random forest 或 XGBoost 构建 tree ensemble
    ↓
表格数据优先考虑 tree ensembles，非结构化数据优先考虑 neural networks
```

---

## 44. 一张总表：决策树核心算法

| 步骤 | 要做什么 | 对应概念 |
|---|---|---|
| 1 | 从 root node 放入所有训练样本 | root node |
| 2 | 计算当前节点 entropy | impurity |
| 3 | 对每个候选特征计算 split 后 weighted entropy | weighted entropy |
| 4 | 用分裂前 entropy 减去分裂后 weighted entropy | information gain |
| 5 | 选择 information gain 最大的特征 | best split |
| 6 | 把样本分到 left / right branches | split_dataset |
| 7 | 对左右子节点重复 | recursion |
| 8 | 满足停止条件时创建 leaf node | stopping criteria |

---

## 45. 一张总表：不同树模型的区别

| 模型 | 核心思想 | 优点 | 注意点 |
|---|---|---|---|
| Single decision tree | 一棵树做预测 | 简单、可解释、训练快 | 对数据变化敏感，容易 overfit |
| Bagged trees | 有放回抽样训练多棵树 | 比单棵树更稳 | 树之间仍可能相似 |
| Random forest | bagging + 每个节点随机选特征子集 | 稳定、泛化好 | 模型解释性下降 |
| XGBoost | boosting，关注前面做错的样本 | 表格数据强、竞赛常用、内置正则化 | 算法细节复杂，通常用库 |

---

## 46. 最后一遍总括

第二课 Week 4 的核心是 decision trees and tree ensembles。决策树通过一系列特征判断把样本送到叶节点，并在叶节点输出预测。训练决策树时，最关键的问题是每个节点选哪个特征分裂。课程用 entropy 衡量节点不纯度，用 information gain 衡量一次分裂让不纯度降低了多少，选择信息增益最大的特征。

决策树通过递归方式构建：先在 root node 选择最佳 split，再分别对左右子节点重复同样过程。为了避免树太复杂，需要设置停止条件，例如节点已经完全纯、达到最大深度、信息增益太小或节点样本数太少。多类别离散特征可以用 one-hot encoding，连续值特征可以枚举相邻样本中点作为候选阈值。回归树则把 entropy 换成 variance，通过降低方差来选择 split，叶节点预测训练样本目标值的平均数。

单棵决策树对数据扰动敏感，所以实际中常使用 tree ensemble。random forest 通过 sampling with replacement 和随机特征子集训练多棵不同的树，再用投票或平均提升稳定性。XGBoost 则是 boosted trees 的高效实现，会让后续树更关注前面模型做错的样本，并且内置正则化，在结构化表格数据上非常强。

最后，在模型选择上可以记住：如果数据是 tabular / structured data，优先考虑 XGBoost、random forest 等树集成；如果数据是 image、audio、text、video 等 unstructured data，通常优先考虑 neural networks。
