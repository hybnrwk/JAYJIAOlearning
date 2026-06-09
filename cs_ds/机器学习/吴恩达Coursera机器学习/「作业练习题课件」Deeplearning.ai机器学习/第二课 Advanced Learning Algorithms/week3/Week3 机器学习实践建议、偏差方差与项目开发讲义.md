# Week 3 讲解讲义：机器学习实践建议、偏差方差与项目开发

> 这份讲义主要依据 `英文字幕/` 中 Week 3 的讲课顺序来写，并结合 practice quiz、`8.Practice Lab Advice for applying machine learning/` 和 `work/` 中的编程实验。整体以中文讲解为主，关键机器学习术语保留中英双语，便于你之后阅读英文字幕、论文、TensorFlow 文档和项目资料。

---

## 1. Week 3 在整门课中的位置

第二课前两周主要在学习 neural network 本身：

```text
Week 1: 神经网络如何做 inference / prediction
Week 2: 神经网络如何训练，如何用 activation、softmax、Adam
Week 3: 当模型效果不好时，下一步应该做什么
```

Week 3 的核心不再是“再学一个模型公式”，而是学习 **机器学习项目的实践决策方法**。

也就是说，前面你已经会训练模型了，但真实项目中常见的问题是：

```text
模型效果不好
    ↓
我应该收集更多数据吗？
    ↓
我应该换更复杂的模型吗？
    ↓
我应该加特征还是删特征？
    ↓
我应该调正则化参数 lambda 吗？
    ↓
我怎么知道这些方向哪一个最值得做？
```

Andrew 在本周强调的核心思想是：

> 做机器学习项目时，最浪费时间的不是训练模型本身，而是错误地选择下一步方向。

所以 Week 3 的主题可以概括为：

> 用 systematic diagnostics 系统性诊断，指导机器学习项目的下一步行动。

---

## 2. “下一步做什么”为什么是一个严肃问题

假设你已经训练了一个 regularized linear regression 模型来预测房价：

$$
J(w,b)=
\frac{1}{2m}\sum_{i=1}^{m}
\left(f_{w,b}(x^{(i)})-y^{(i)}\right)^2
+
\frac{\lambda}{2m}\sum_{j=1}^{n}w_j^2
$$

但训练完后，你发现预测误差很大。

你可能想到很多办法：

```text
1. 收集更多训练样本
2. 使用更少的特征
3. 添加更多特征
4. 添加 polynomial features 多项式特征
5. 减小 lambda
6. 增大 lambda
```

这些想法本身都可能正确，但不是每个项目里都值得做。

例如：

- 如果模型是 high bias 高偏差，再收集大量数据通常帮助不大。
- 如果模型是 high variance 高方差，收集更多数据可能非常有用。
- 如果模型欠拟合，删特征通常会让问题更糟。
- 如果模型过拟合，继续加复杂特征可能也会让问题更糟。

所以本周要学的是：

> 不要凭直觉盲目试，而是先诊断问题类型，再决定行动。

---

## 3. Diagnostic 诊断是什么

课程中给出的定义是：

> A diagnostic is a test that you run to gain insight into what is or is not working with a learning algorithm.

中文可以理解为：

> Diagnostic 诊断，就是为了弄清楚学习算法哪里出了问题而设计的测试。

这里的“诊断”不是医学上的诊断，而是机器学习开发中的分析方法。

例如：

- 计算 training error 训练误差。
- 计算 cross-validation error 验证误差。
- 画 learning curve 学习曲线。
- 做 error analysis 错误分析。
- 比较 baseline performance 基准表现。
- 用 precision / recall 评估偏斜分类任务。

诊断本身会花时间，但它的价值在于：

> 花一点时间诊断，可以避免你花几周甚至几个月做无效工作。

---

## 4. 先学会评估模型：为什么不能只看训练集

假设你用一个四阶多项式模型拟合房价：

$$
f(x)=w_1x+w_2x^2+w_3x^3+w_4x^4+b
$$

如果训练集只有几个点，四阶多项式可能把训练数据拟合得非常好。

但问题是：

> 训练集拟合得好，不代表新数据预测得好。

机器学习真正关心的是 **generalization 泛化能力**：

> 模型在没有见过的新样本上表现如何。

对于只有一个特征的问题，你也许还能画图看模型是不是“弯得太离谱”。

但现实中常常有很多特征：

```text
x1: 房屋面积
x2: 卧室数量
x3: 楼层数量
x4: 房屋年龄
...
```

这时你很难直接画出高维函数 `f(x)`。

所以需要更系统的方法：

> 把数据拆分成训练集和测试集，用测试集估计模型在新数据上的表现。

---

## 5. Training Set 和 Test Set

最简单的做法是把数据拆成两部分：

```text
training set: 用来训练参数 w, b
test set: 用来评估模型对新数据的表现
```

常见比例：

```text
70% training + 30% test
80% training + 20% test
```

记号上：

- `m_train`: 训练样本数量。
- `m_test`: 测试样本数量。
- `(x_train, y_train)`: 训练集。
- `(x_test, y_test)`: 测试集。

对于回归问题，训练完模型后，可以计算 test error：

$$
J_{test}(w,b)=
\frac{1}{2m_{test}}
\sum_{i=1}^{m_{test}}
\left(f_{w,b}(x_{test}^{(i)})-y_{test}^{(i)}\right)^2
$$

也可以计算 training error：

$$
J_{train}(w,b)=
\frac{1}{2m_{train}}
\sum_{i=1}^{m_{train}}
\left(f_{w,b}(x_{train}^{(i)})-y_{train}^{(i)}\right)^2
$$

注意一个重要细节：

> `J_train` 和 `J_test` 通常不包含 regularization term。

原因是它们是用来衡量预测误差，而不是训练时的优化目标。

训练时优化的是：

```text
training loss + regularization
```

评估时看的是：

```text
模型预测错了多少
```

---

## 6. 分类问题中的评估

如果是 classification 分类问题，比如识别手写数字 0 或 1，也可以类似计算训练误差和测试误差。

一种做法是用 logistic loss：

$$
J_{test}(w,b)=
\frac{1}{m_{test}}
\sum_{i=1}^{m_{test}}
L(f_{w,b}(x_{test}^{(i)}),y_{test}^{(i)})
$$

但对于分类任务，更常见的评估方式是 **classification error 分类错误率**：

$$
J_{test}
=
\frac{\text{number of misclassified test examples}}
{m_{test}}
$$

也就是：

```text
预测错的样本数 / 总样本数
```

例如测试集中 100 个样本，模型错了 8 个：

$$
J_{test}=0.08
$$

这意味着 test error 是 8%，accuracy 是 92%。

---

## 7. 为什么只用 Test Set 做模型选择是不够的

现在考虑 model selection 模型选择问题。

假设你要选择多项式 degree：

```text
d = 1: linear model
d = 2: quadratic model
d = 3: cubic model
...
d = 10
```

一种看似合理但其实有问题的做法是：

```text
1. 用 training set 训练每个 degree 的模型
2. 用 test set 计算每个模型的 test error
3. 选择 test error 最低的模型
4. 把这个 test error 当作泛化误差
```

问题在第 3 步。

你已经用 test set 来选择模型了，所以 test set 不再是完全“没参与决策”的数据。

这会导致：

> test error 变成对 generalization error 的 overly optimistic estimate 过于乐观的估计。

换句话说，你可能不小心让模型“适应”了 test set。

虽然不是直接用 test set 训练 `w,b`，但你用 test set 选择了超参数 `d`。

所以 test set 已经被污染了。

---

## 8. 正确的数据划分：Training / Cross-Validation / Test

更好的做法是把数据拆成三部分：

```text
training set
cross-validation set
test set
```

常见比例：

```text
60% training
20% cross-validation
20% test
```

这三个集合的职责不同：

| 数据集 | 英文 | 用途 |
|---|---|---|
| 训练集 | training set | 训练参数 `w,b` |
| 交叉验证集 | cross-validation set / validation set / dev set | 选择模型、超参数、神经网络架构 |
| 测试集 | test set | 最后一次评估泛化能力 |

三种误差：

$$
J_{train}(w,b)
$$

$$
J_{cv}(w,b)
$$

$$
J_{test}(w,b)
$$

在实践中，cross-validation set 也常叫：

- validation set
- development set
- dev set

它们在本课程语境中基本是同一个意思。

---

## 9. 用 Cross-Validation 做模型选择

以选择多项式 degree 为例，正确流程是：

```text
1. 选择候选模型 d = 1, 2, ..., 10
2. 对每个 d，用 training set 训练参数 w,b
3. 对每个 d，用 cross-validation set 计算 J_cv
4. 选择 J_cv 最低的模型
5. 最后只用 test set 评估这个最终模型
```

也就是说：

```text
training set: 学参数
cross-validation set: 选模型
test set: 最后报告性能
```

例如：

```text
d=1: J_cv = 0.52
d=2: J_cv = 0.31
d=3: J_cv = 0.18
d=4: J_cv = 0.14   <- 选择
d=5: J_cv = 0.20
```

那就选 `d=4`。

之后再计算：

$$
J_{test}(w^{(4)},b^{(4)})
$$

作为最终模型在新数据上的估计。

---

## 10. 神经网络架构选择也是同一个逻辑

模型选择不只适用于多项式回归，也适用于 neural network architecture 神经网络架构。

例如你可以尝试：

```text
模型 1: 小网络
模型 2: 中等网络
模型 3: 大网络
```

正确流程仍然是：

```text
1. 用 training set 分别训练三个模型
2. 用 cross-validation set 比较三个模型的 J_cv
3. 选择 J_cv 最低的模型
4. 用 test set 做最后泛化评估
```

实践 quiz 中也强调了这个点：

> 选择最佳神经网络架构时，用 cross-validation set，不要用 test set。

---

## 11. Bias 和 Variance 的直觉

接下来进入本周最重要的诊断工具：

```text
bias and variance 偏差与方差
```

用多项式拟合的例子理解：

```text
degree 太低:
    模型太简单
    连训练集都拟合不好
    high bias / underfitting

degree 太高:
    模型太复杂
    训练集拟合很好
    新数据表现很差
    high variance / overfitting

degree 适中:
    训练集和验证集表现都不错
    just right
```

中文常见翻译：

- high bias: 高偏差，欠拟合。
- high variance: 高方差，过拟合。
- underfitting: 欠拟合。
- overfitting: 过拟合。

---

## 12. 用 `J_train` 和 `J_cv` 诊断 Bias / Variance

如果只能记住一个判断表，就是这个：

| 情况 | `J_train` | `J_cv` | 诊断 |
|---|---:|---:|---|
| high bias | 高 | 高，通常和 `J_train` 接近 | 欠拟合 |
| high variance | 低 | 明显高于 `J_train` | 过拟合 |
| just right | 低 | 低，且接近 `J_train` | 泛化较好 |
| high bias + high variance | 高 | 比 `J_train` 还高很多 | 两种问题都有 |

更简洁地说：

```text
J_train 高:
    模型连训练集都学不好 -> high bias

J_cv >> J_train:
    模型在训练集好，在新数据差 -> high variance
```

其中 `>>` 表示 much greater than，远大于。

---

## 13. 从模型复杂度看 Bias / Variance

如果横轴是多项式 degree：

```text
degree 增大
    ↓
模型复杂度增大
    ↓
J_train 通常下降
```

因为模型越复杂，越容易贴合训练集。

但 `J_cv` 通常不是一直下降，而是：

```text
先下降，后上升
```

原因是：

```text
degree 太低:
    underfit，J_cv 高

degree 适中:
    泛化好，J_cv 低

degree 太高:
    overfit，J_cv 又变高
```

所以 `J_cv` 往往呈 U 形。

这也是为什么 cross-validation 能帮助选择合适复杂度：

> 选择 `J_cv` 最低的位置。

---

## 14. Regularization 和 Bias / Variance

正则化参数 `lambda` 也会影响 bias 和 variance。

假设你固定使用高阶多项式模型：

$$
f(x)=w_1x+w_2x^2+w_3x^3+w_4x^4+b
$$

训练目标中有正则化：

$$
\frac{\lambda}{2m}\sum_{j=1}^{n}w_j^2
$$

### `lambda` 很大

如果 `lambda` 非常大，比如 10000，模型会强烈压低 `w_j`：

```text
w1, w2, ..., wn 接近 0
```

模型变成近似常数：

$$
f(x)\approx b
$$

这会导致：

```text
模型太简单
J_train 高
high bias
underfitting
```

### `lambda` 很小

如果 `lambda=0`，几乎没有正则化。

高阶模型会尽力贴合训练集，可能出现：

```text
J_train 很低
J_cv 很高
high variance
overfitting
```

### `lambda` 适中

合适的 `lambda` 可以让模型既不过于弯曲，也不过于简单。

选择 `lambda` 的流程：

```text
1. 尝试多个 lambda
2. 每个 lambda 用 training set 训练
3. 用 cross-validation set 计算 J_cv
4. 选择 J_cv 最低的 lambda
5. 最后用 test set 做最终评估
```

---

## 15. Degree 和 Lambda 的方向是相反的

从直觉上：

```text
degree 越大:
    模型越复杂
    更容易 high variance

lambda 越大:
    正则化越强
    模型越简单
    更容易 high bias
```

所以：

| 操作 | 模型复杂度 | 风险 |
|---|---|---|
| 增大 degree | 增强 | high variance |
| 减小 degree | 减弱 | high bias |
| 增大 lambda | 减弱 | high bias |
| 减小 lambda | 增强 | high variance |

这也是为什么课程说 degree 曲线和 lambda 曲线有点像“镜像”。

---

## 16. 什么叫 “High” Error：需要 Baseline

只看 `J_train` 是不是“高”，有时会误判。

例如 speech recognition 语音识别：

```text
baseline / human-level error: 10.6%
training error:              10.8%
cross-validation error:      14.8%
```

如果不知道人类水平，你可能觉得：

```text
训练误差 10.8% 很高 -> high bias
```

但如果人类也只能做到 10.6%，说明数据本身很难，比如音频噪声很大。

此时模型在训练集上只比人类差 0.2%：

```text
training error - baseline = 0.2%
```

这不算严重 high bias。

但验证集误差比训练误差高 4.0%：

```text
cross-validation error - training error = 4.0%
```

这更像 high variance。

---

## 17. Baseline Performance 的作用

baseline level of performance 指的是：

> 你合理希望模型最终达到的误差水平。

常见 baseline 来源：

```text
1. human-level performance 人类水平
2. 旧系统或竞争算法的表现
3. 领域经验估计
4. 理论上能达到的最低错误率
```

诊断时要看两个 gap：

```text
training error - baseline performance
    ↓
判断 high bias

cross-validation error - training error
    ↓
判断 high variance
```

例如：

| Baseline | Training Error | CV Error | 诊断 |
|---:|---:|---:|---|
| 10.6% | 10.8% | 14.8% | high variance |
| 10.6% | 15.0% | 15.5% | high bias |
| 10.6% | 15.2% | 19.7% | high bias + high variance |

要点：

> 判断 high bias 时，不是问训练误差是否大，而是问训练误差是否明显高于可达到的基准水平。

---

## 18. Learning Curves 学习曲线

learning curve 学习曲线用来观察误差如何随训练样本数变化。

横轴：

```text
m_train 训练样本数量
```

纵轴：

```text
J_train 或 J_cv
```

一般规律：

```text
m_train 增加:
    J_cv 往往下降
    J_train 往往上升
```

为什么 `J_train` 会上升？

因为样本很少时，模型容易把训练样本拟合得很好。

例如：

```text
1 个点:
    很容易拟合，训练误差接近 0

2 个点:
    也容易拟合

越来越多点:
    同一个模型更难完美拟合所有点
    training error 增加
```

而 `J_cv` 通常下降，是因为训练数据更多，模型学到的规律更稳定。

---

## 19. High Bias 的 Learning Curve

如果模型 high bias，比如用直线拟合明显弯曲的数据：

```text
J_train 高
J_cv 高
二者逐渐接近并 plateau 平台化
```

关键结论：

> 对 high bias 模型，仅仅增加更多训练数据通常帮助不大。

原因是模型本身太简单。

你再给它更多数据，它仍然只能拟合一条直线。

所以 high bias 的主要解决方向不是“加数据”，而是：

```text
1. 增加模型复杂度
2. 添加有效特征
3. 添加 polynomial features
4. 减小 lambda
5. 对神经网络，使用更大的网络
```

---

## 20. High Variance 的 Learning Curve

如果模型 high variance：

```text
J_train 低
J_cv 高
J_cv 和 J_train 之间有明显 gap
```

此时增加训练数据可能很有效。

直觉是：

> 过拟合通常意味着模型太依赖少量训练样本的偶然细节，更多数据能削弱这种偶然性。

随着 `m_train` 增加：

```text
J_cv 下降
J_train 可能上升
二者 gap 缩小
```

所以 high variance 的主要解决方向是：

```text
1. 增加训练数据
2. 简化模型
3. 减少特征
4. 增大 lambda
5. 对神经网络，加入或增强 regularization
```

---

## 21. 回到最初问题：到底该尝试什么

课程把开头的 6 个想法重新分类：

| 尝试方向 | 主要解决 |
|---|---|
| Get more training examples | high variance |
| Try smaller sets of features | high variance |
| Try getting additional features | high bias |
| Try adding polynomial features | high bias |
| Try decreasing `lambda` | high bias |
| Try increasing `lambda` | high variance |

可以总结为：

### 如果是 high bias

模型太弱，连训练集都学不好。

应该让模型更强：

```text
1. 加特征
2. 加 polynomial features
3. 降低 lambda
4. 使用更复杂模型
5. 对神经网络，增加 hidden layers 或 hidden units
```

### 如果是 high variance

模型太容易记住训练集细节。

应该让模型更稳：

```text
1. 增加训练数据
2. 减少无用特征
3. 增大 lambda
4. 简化模型
5. 对神经网络，增强 regularization
```

一个易错点：

> 不要为了修 high bias 而随便减少训练集大小。

减少训练数据可能让 training error 看起来下降，但通常会让 cross-validation error 更差。

---

## 22. Neural Networks 中的 Bias / Variance

在传统机器学习中，经常说 bias-variance tradeoff：

```text
模型太简单 -> high bias
模型太复杂 -> high variance
```

因此需要在两者之间折中。

但 neural networks 改变了这个直觉。

课程中的说法是：

> Large neural networks, when trained on small to moderate sized datasets, are often low bias machines.

中文理解：

> 足够大的神经网络往往能很好拟合训练集，因此更容易先解决 bias 问题。

一个常用流程：

```text
1. 训练神经网络
2. 看 J_train 是否接近 baseline
3. 如果 J_train 高，说明 high bias，尝试更大的网络
4. 如果 J_train 低，再看 J_cv
5. 如果 J_cv 明显高于 J_train，说明 high variance，尝试更多数据或正则化
6. 重复迭代
```

---

## 23. 大神经网络一定会过拟合吗

直觉上，大网络更复杂，似乎更容易 high variance。

课程给出的实践经验是：

> A large neural network with well-chosen regularization will usually do as well or better than a smaller one.

中文理解：

> 如果正则化选得合适，大网络通常不会比小网络差，甚至常常更好。

主要代价不是性能变差，而是：

```text
1. 训练更慢
2. 推理更慢
3. 计算成本更高
```

神经网络中的 L2 regularization 形式类似：

$$
J(W,B)=
\frac{1}{m}\sum_{i=1}^{m}L(\hat{y}^{(i)},y^{(i)})
+
\frac{\lambda}{2m}\sum W^2
$$

TensorFlow 中可以这样写：

```python
Dense(
    units=120,
    activation="relu",
    kernel_regularizer=tf.keras.regularizers.l2(0.1)
)
```

其中 `kernel_regularizer` 正则化的是权重 `W`。

---

## 24. 机器学习开发的迭代循环

Week 3 还讲了 machine learning development process 机器学习开发流程。

典型循环是：

```text
1. Choose architecture
   选择模型、特征、数据、超参数

2. Train model
   实现并训练模型

3. Diagnostics
   做 bias/variance、error analysis 等诊断

4. Make changes
   根据诊断结果修改模型或数据

5. Repeat
   重复迭代
```

课程用 spam classifier 垃圾邮件分类器举例。

输入是一封 email，输出是：

```text
y = 1: spam
y = 0: non-spam
```

一种简单特征构造是取英语中最常见的 10000 个词：

```text
x1 = 是否出现单词 "a"
x2 = 是否出现单词 "Andrew"
x3 = 是否出现单词 "buy"
x4 = 是否出现单词 "deal"
...
```

也可以用词频：

```text
xi = 某个词出现的次数
```

如果初始模型效果不好，你可能想：

```text
1. 收集更多垃圾邮件
2. 根据 email routing 添加特征
3. 处理 email body 中的词形变化
4. 检测 deliberate misspellings 故意拼错
5. 针对 phishing 钓鱼邮件添加 URL 特征
```

但到底哪一个值得做，需要诊断。

---

## 25. Error Analysis 错误分析

除了 bias/variance，另一个重要诊断是：

```text
error analysis 错误分析
```

方法很朴素：

> 手动查看模型在 cross-validation set 上预测错的样本，按错误类型分类统计。

例如有 500 个 CV 样本，模型错了 100 个。

你可以手动查看这 100 个错误样本，统计：

| 错误类型 | 数量 |
|---|---:|
| pharmaceutical spam 药品垃圾邮件 | 21 |
| deliberate misspellings 故意拼错 | 3 |
| unusual email routing 异常路由 | 7 |
| phishing 钓鱼邮件 | 18 |
| embedded image spam 图片垃圾邮件 | 5 |

从这个结果可以看出：

```text
药品垃圾邮件和钓鱼邮件是大问题
故意拼写错误只有 3 个，优先级较低
```

这能指导下一步：

- 如果药品垃圾邮件错得多，就专门收集更多药品垃圾邮件。
- 如果 phishing 错得多，就设计 URL 相关特征。
- 如果 misspelling 错误少，就先不投入太多时间。

---

## 26. Error Analysis 的几个细节

### 1. 错误类别可以重叠

一封邮件可以同时是：

```text
pharmaceutical spam
deliberate misspelling
unusual routing
```

所以类别不一定 mutually exclusive 互斥。

### 2. 不一定要看所有错误

如果模型错了 1000 个样本，人工看完可能太慢。

可以随机抽样：

```text
100 个左右错误样本
```

通常已经能看出主要趋势。

### 3. Error analysis 更适合人类能判断的任务

例如：

```text
垃圾邮件分类
图像识别
语音识别
文本分类
```

人可以看样本并判断为什么错。

但如果任务是预测用户会点击哪个广告，人类自己也很难判断，error analysis 会更困难。

---

## 27. Adding Data：不要总是“加所有数据”

当诊断显示 high variance 时，加数据可能有效。

但课程强调：

> 不一定要收集所有类型的数据，应该优先收集 error analysis 显示模型最需要的数据。

例如错误分析发现药品垃圾邮件错得最多。

那就不必盲目扩大整个邮件数据集，而是更精准地收集：

```text
更多 pharmaceutical spam
```

这叫 targeted data collection 定向收集数据。

优点是：

```text
成本更低
对模型性能提升更直接
```

---

## 28. Data Augmentation 数据增强

Data augmentation 是指：

> 修改已有训练样本，生成新的训练样本，同时保持标签不变。

例如 OCR 字母识别中，原图是字母 A。

可以生成：

```text
1. 轻微旋转后的 A
2. 放大后的 A
3. 缩小后的 A
4. 改变对比度后的 A
5. 轻微扭曲后的 A
```

标签仍然是：

```text
y = A
```

语音识别中也可以做数据增强：

```text
原始语音:
    "What is today's weather?"

增强后:
    加入人群噪声
    加入车内噪声
    模拟差的电话连接
```

关键原则：

> 增强方式应该代表 test set 中可能出现的真实噪声或变化。

不是所有随机噪声都有用。

如果你给图片加完全不真实的像素噪声，而测试集从不会出现这种噪声，帮助可能很小。

---

## 29. Data Synthesis 数据合成

Data synthesis 是：

> 从零生成新的训练样本，而不是修改已有样本。

课程用 photo OCR 举例。

真实任务是识别照片中的文字。

你可以在电脑中用各种字体、颜色、背景、对比度生成大量文字图片：

```text
字体 1 + 颜色 1 + 背景 1
字体 2 + 颜色 2 + 背景 2
...
```

这样得到 synthetic data 合成数据。

数据合成可能很有用，但难点是：

> 合成数据必须足够接近真实测试数据。

如果合成得太假，模型学到的规律可能不能泛化。

---

## 30. Model-Centric 和 Data-Centric

课程区分了两种思维方式。

### Model-centric approach

传统机器学习研究中常见：

```text
固定数据集
不断改进模型、算法、代码
```

### Data-centric approach

更关注数据本身：

```text
改进数据质量
收集关键类别的数据
修正标签
做数据增强
做数据合成
让数据分布更贴近实际任务
```

Andrew 强调，现代很多算法已经很强。

在实际项目中，很多时候改进数据比改进模型更有效。

---

## 31. Transfer Learning 迁移学习

如果你的任务数据很少，可以考虑 transfer learning。

核心思想：

> 从一个相关但不完全相同的大任务中学到通用表示，再迁移到你的任务上。

例如你要识别手写数字 0-9，但数据很少。

你可以先找一个已经在 100 万张图片、1000 个类别上训练好的图像模型。

这个模型可能学会了：

```text
早期层: 边缘 edges
中间层: 角点 corners
更深层: 曲线、形状、局部结构
```

这些低层视觉特征对手写数字也有用。

迁移学习流程：

```text
1. 下载或训练一个 pre-trained model
2. 去掉原来的 output layer
3. 换成适合自己任务的新 output layer
4. 在自己的数据上 fine-tune
```

---

## 32. Transfer Learning 的两种训练方式

假设原模型有 5 层。

前 4 层参数来自预训练：

```text
W1, b1
W2, b2
W3, b3
W4, b4
```

最后一层换成你的任务的新输出层：

```text
W5, b5
```

有两种常见方式：

### Option 1: 只训练输出层

```text
冻结前面层参数
只更新最后一层 W5, b5
```

适合：

```text
你的数据非常少
```

### Option 2: 训练所有层

```text
用预训练参数初始化前面层
然后所有层一起继续训练
```

适合：

```text
你的数据稍微多一些
```

两个术语：

- supervised pre-training: 在大数据集上先训练。
- fine tuning: 在你的任务上进一步微调。

重要限制：

> pre-training 和 fine-tuning 的输入类型应该相同。

也就是说：

```text
图像任务 -> 用图像预训练模型
音频任务 -> 用音频预训练模型
文本任务 -> 用文本预训练模型
```

图像预训练模型通常不能直接帮你处理音频。

---

## 33. Full Cycle of a Machine Learning Project

课程还讲了一个完整机器学习项目的生命周期。

以 speech recognition 为例：

```text
1. Scope project
   明确项目目标，例如做 voice search 语音搜索

2. Collect data
   收集音频和 transcript 标签

3. Train model
   训练模型，做 bias/variance 和 error analysis

4. Improve data / model
   根据诊断结果补数据、调模型、加特征

5. Deploy in production
   部署到线上服务

6. Monitor and maintain
   监控表现，发现数据漂移，必要时重新训练
```

部署时常见结构：

```text
mobile app
    ↓ API call
inference server
    ↓
trained model
    ↓
prediction y_hat
```

例如用户在手机里说一句话，app 把音频传给 inference server，server 调用模型，返回转写文本。

---

## 34. MLOps 是什么

MLOps 是 Machine Learning Operations。

它关注：

```text
1. 如何部署模型
2. 如何让模型可靠运行
3. 如何监控输入和输出
4. 如何处理数据分布变化
5. 如何更新模型
6. 如何控制推理成本
```

模型上线后，不是项目结束。

原因是现实世界会变化：

- 新名人出现。
- 新政治人物出现。
- 用户搜索内容变化。
- 垃圾邮件策略变化。
- 欺诈行为变化。

这会导致：

```text
training data distribution != production data distribution
```

所以需要持续监控。

---

## 35. Fairness, Bias, and Ethics

课程最后强调：

> 机器学习系统会影响很多人，所以必须重视 fairness 公平性、bias 偏见和 ethics 伦理。

历史上出现过很多问题：

- 招聘系统歧视女性。
- 人脸识别系统对深色皮肤人群误判更严重。
- 贷款审批系统对某些群体不公平。
- deepfake 被用于误导。
- 社交媒体算法放大有害内容。
- 自动生成虚假评论或虚假政治内容。
- 机器学习被用于欺诈或恶意用途。

Andrew 的建议不是一个简单 checklist，而是一些实践原则：

```text
1. 在部署前组建多元团队，讨论可能伤害哪些群体
2. 查找行业标准、法规、已有指南
3. 针对识别出的风险维度审计模型
4. 制定 mitigation plan 缓解方案
5. 部署后持续监控潜在伤害
```

一个重要原则：

> 如果一个项目虽然赚钱，但会让世界变得更糟，就不应该做。

---

## 36. Skewed Datasets 偏斜数据集

optional 视频讨论 skewed datasets。

skewed dataset 指的是：

> 正类和负类比例严重不平衡。

例如罕见疾病检测：

```text
y = 1: 有病
y = 0: 没病
```

如果只有 0.5% 的人有病，那么一个非常简单的程序：

```python
print(0)
```

永远预测没病，也能达到：

```text
99.5% accuracy
0.5% error
```

所以在偏斜数据集中，accuracy 可能非常误导。

一个模型有 99% accuracy，看起来不错，但它可能比永远预测 0 的模型还差。

---

## 37. Confusion Matrix 混淆矩阵

对二分类问题，可以用 confusion matrix：

|             |       Actual 1 |       Actual 0 |
| ----------- | -------------: | -------------: |
| Predicted 1 |  True Positive | False Positive |
| Predicted 0 | False Negative |  True Negative |

四个术语：

```text
True Positive (TP):
    预测为 1，真实也是 1

False Positive (FP):
    预测为 1，真实是 0

False Negative (FN):
    预测为 0，真实是 1

True Negative (TN):
    预测为 0，真实也是 0
```

以疾病检测为例：

- TP: 模型说有病，实际有病。
- FP: 模型说有病，实际没病。
- FN: 模型说没病，实际有病。
- TN: 模型说没病，实际没病。

---

## 38. Precision 查准率

Precision 的问题是：

> 在所有预测为 positive 的样本中，有多少真的 positive？

公式：

$$
Precision=
\frac{TP}{TP+FP}
$$

疾病检测中：

> 在模型说“有病”的人里，有多少人真的有病？

如果：

```text
TP = 15
FP = 5
```

则：

$$
Precision=
\frac{15}{15+5}
=0.75
$$

也就是模型每次说“有病”时，有 75% 的概率说对。

---

## 39. Recall 召回率

Recall 的问题是：

> 在所有真实 positive 的样本中，有多少被模型找出来？

公式：

$$
Recall=
\frac{TP}{TP+FN}
$$

疾病检测中：

> 所有真正有病的人里，模型找出了多少？

如果：

```text
TP = 15
FN = 10
```

则：

$$
Recall=
\frac{15}{15+10}
=0.60
$$

也就是模型找出了 60% 的真实病人。

如果模型永远预测 0：

```text
TP = 0
Recall = 0
```

这能揭示 accuracy 看不出来的问题。

---

## 40. Precision 和 Recall 的权衡

假设 logistic regression 输出：

$$
f(x)\in[0,1]
$$

默认阈值是：

```text
f(x) >= 0.5 -> predict 1
f(x) < 0.5  -> predict 0
```

但阈值可以调整。

### 提高阈值

例如：

```text
f(x) >= 0.7 才预测 1
```

效果：

```text
precision 上升
recall 下降
```

直觉：

- 只有很确定时才说 positive，所以说 positive 更准。
- 但会漏掉更多真实 positive。

适合：

```text
false positive 代价很高
```

例如治疗很昂贵、侵入性强，不能轻易误诊。

### 降低阈值

例如：

```text
f(x) >= 0.3 就预测 1
```

效果：

```text
precision 下降
recall 上升
```

直觉：

- 更容易预测 positive，所以能抓到更多真实 positive。
- 但误报也会增加。

适合：

```text
false negative 代价很高
```

例如漏诊严重疾病代价很大。

---

## 41. F1 Score

当同时有 precision 和 recall 两个指标时，比较模型可能不方便。

例如：

| 模型 | Precision | Recall |
|---|---:|---:|
| Algorithm 1 | 0.40 | 0.50 |
| Algorithm 2 | 0.70 | 0.10 |
| Algorithm 3 | 0.02 | 1.00 |

不能简单取平均，因为一个模型可能 recall 很高但 precision 极低，实际没用。

F1 score 用来把 precision 和 recall 合成一个指标：

$$
F1=
\frac{2PR}{P+R}
$$

等价于：

$$
F1=
\frac{1}
{\frac{1}{2}\left(\frac{1}{P}+\frac{1}{R}\right)}
$$

它是 harmonic mean 调和平均。

特点：

> 更重视较小的那个值。

所以如果 precision 或 recall 有一个非常低，F1 也会低。

---

## 42. Practice Lab 1：`eval_mse`

实验中的第一个练习是实现 mean squared error。

公式：

$$
J=
\frac{1}{2m}
\sum_{i=0}^{m-1}
(\hat{y}^{(i)}-y^{(i)})^2
$$

代码逻辑：

```python
def eval_mse(y, yhat):
    m = len(y)
    err = 0.0
    for i in range(m):
        err_i = (yhat[i] - y[i]) ** 2
        err += err_i
    err = err / (2 * m)
    return err
```

要注意：

```text
1. 要平方
2. 要对所有样本求和
3. 要除以 2m
```

---

## 43. Practice Lab 2：用 Degree 选择模型复杂度

实验中会训练多个 polynomial regression 模型：

```python
max_degree = 9
err_train = np.zeros(max_degree)
err_cv = np.zeros(max_degree)

for degree in range(max_degree):
    lmodel = lin_model(degree + 1)
    lmodel.fit(X_train, y_train)

    yhat = lmodel.predict(X_train)
    err_train[degree] = lmodel.mse(y_train, yhat)

    yhat = lmodel.predict(X_cv)
    err_cv[degree] = lmodel.mse(y_cv, yhat)

optimal_degree = np.argmin(err_cv) + 1
```

这里的关键是：

```text
用 training set 训练
用 CV set 选择 degree
选择 err_cv 最小的 degree
```

这正好对应字幕中的 model selection。

---

## 44. Practice Lab 3：调 Regularization

实验中固定高阶多项式，然后尝试多个 `lambda`：

```python
lambda_range = np.array([
    0.0, 1e-6, 1e-5, 1e-4,
    1e-3, 1e-2, 1e-1, 1, 10, 100
])
```

每个 `lambda` 都训练一个模型：

```python
for i in range(num_steps):
    lambda_ = lambda_range[i]
    lmodel = lin_model(
        degree,
        regularization=True,
        lambda_=lambda_
    )
    lmodel.fit(X_train, y_train)
    err_train[i] = lmodel.mse(y_train, lmodel.predict(X_train))
    err_cv[i] = lmodel.mse(y_cv, lmodel.predict(X_cv))

optimal_reg_idx = np.argmin(err_cv)
```

实验现象：

```text
lambda 太小:
    high variance

lambda 太大:
    high bias

lambda 适中:
    J_cv 最低
```

---

## 45. Practice Lab 4：增加训练样本数

实验中用不同训练样本数量 `m` 训练模型，观察 learning curve。

结论：

```text
当模型 high variance 时:
    增加训练样本能让 CV error 降低
    train error 和 CV error 更接近

当模型 high bias 时:
    单纯增加训练样本帮助不大
```

这个实验对应字幕中的 learning curve 直觉。

---

## 46. Practice Lab 5：分类错误率 `eval_cat_err`

分类错误率公式：

$$
J_{cv}=
\frac{1}{m}
\sum_{i=0}^{m-1}
\mathbf{1}(\hat{y}^{(i)}\ne y^{(i)})
$$

代码：

```python
def eval_cat_err(y, yhat):
    m = len(y)
    incorrect = 0
    for i in range(m):
        if yhat[i] != y[i]:
            incorrect += 1
    cerr = incorrect / m
    return cerr
```

这里 `y` 不是 one-hot，而是类别编号：

```text
0, 1, 2, ..., classes-1
```

---

## 47. Practice Lab 6：复杂神经网络

实验中的复杂模型：

```python
model = Sequential(
    [
        Dense(120, activation="relu", name="L1"),
        Dense(40, activation="relu", name="L2"),
        Dense(classes, activation="linear", name="L3"),
    ],
    name="Complex"
)

model.compile(
    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
    optimizer=tf.keras.optimizers.Adam(0.01),
)
```

注意：

```text
输出层用 linear
loss 设置 from_logits=True
```

这延续 Week 2 的 softmax 推荐写法。

复杂模型可能把训练集中的 outliers 异常点也努力拟合进去。

结果常见是：

```text
training error 低
CV error 较高
high variance
```

---

## 48. Practice Lab 7：简单神经网络

简单模型：

```python
model_s = Sequential(
    [
        Dense(6, activation="relu", name="L1"),
        Dense(classes, activation="linear", name="L2"),
    ],
    name="Simple"
)

model_s.compile(
    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
    optimizer=tf.keras.optimizers.Adam(0.01),
)
```

简单模型参数少：

```text
Complex model: 5446 params
Simple model: 60 params
```

实验中简单模型 training error 可能略高，但 CV error 可能更好。

这说明：

> 不是训练集表现越好就越好，还要看泛化。

---

## 49. Practice Lab 8：正则化复杂神经网络

正则化后的复杂模型：

```python
model_r = Sequential(
    [
        Dense(
            120,
            activation="relu",
            kernel_regularizer=tf.keras.regularizers.l2(0.1),
            name="L1"
        ),
        Dense(
            40,
            activation="relu",
            kernel_regularizer=tf.keras.regularizers.l2(0.1),
            name="L2"
        ),
        Dense(classes, activation="linear", name="L3"),
    ],
    name="ComplexRegularized"
)

model_r.compile(
    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
    optimizer=tf.keras.optimizers.Adam(0.01),
)
```

实验最后会尝试多个 `lambda`：

```python
lambdas = [0.0, 0.001, 0.01, 0.05, 0.1, 0.2, 0.3]
```

观察不同正则化强度下的 train / CV 分类错误率。

结论：

> 正则化可以让复杂模型的训练表现和验证表现更接近，降低 overfitting。

---

## 50. Quiz 高频考点

本周 quiz 的考点可以整理为：

1. Diagnostic 是为了了解学习算法哪里有效、哪里无效的测试。

2. 训练集表现越好，不一定泛化越好，因为可能 overfit。

3. 选择模型架构时，用 cross-validation set，不用 test set。

4. 如果 `J_cv >> J_train`，说明 high variance。

5. 判断 high bias 时，应比较 training error 和 baseline performance。

6. high bias 的改进方向：

```text
decrease lambda
add features
add polynomial features
use bigger model
```

7. high variance 的改进方向：

```text
collect more training data
increase lambda
reduce feature set
regularize
```

8. Error analysis 是手动查看模型错分样本，找出共同模式。

9. Data augmentation 是修改已有样本生成新样本，标签保持不变。

10. Transfer learning 可以：

```text
只训练输出层，冻结前面层
或用预训练参数初始化，再训练所有层
```

---

## 51. Week 3 关键词表

| 英文 | 中文 | 解释 |
|---|---|---|
| diagnostic | 诊断 | 为了解模型哪里出问题而运行的测试 |
| generalization | 泛化 | 模型在新数据上的表现 |
| training error | 训练误差 | 模型在训练集上的错误 |
| test error | 测试误差 | 模型在测试集上的错误 |
| cross-validation error | 交叉验证误差 | 模型在验证集上的错误 |
| validation set / dev set | 验证集 / 开发集 | 用于选模型和超参数 |
| model selection | 模型选择 | 在候选模型中选择表现最好的 |
| high bias | 高偏差 | 欠拟合，训练集都学不好 |
| high variance | 高方差 | 过拟合，训练集好但验证集差 |
| baseline performance | 基准表现 | 合理希望达到的表现水平 |
| learning curve | 学习曲线 | 误差随训练样本数变化的曲线 |
| error analysis | 错误分析 | 手动检查错分样本并分类统计 |
| data augmentation | 数据增强 | 修改已有样本生成新样本 |
| data synthesis | 数据合成 | 从零生成合成训练样本 |
| transfer learning | 迁移学习 | 利用其他任务的预训练模型 |
| fine tuning | 微调 | 在目标任务上继续训练预训练模型 |
| MLOps | 机器学习运维 | 部署、监控、维护机器学习系统 |
| skewed dataset | 偏斜数据集 | 类别比例严重不平衡的数据集 |
| confusion matrix | 混淆矩阵 | TP、FP、FN、TN 的统计表 |
| precision | 查准率 | 预测为正的样本中有多少真为正 |
| recall | 召回率 | 真实为正的样本中有多少被找出 |
| F1 score | F1 分数 | precision 和 recall 的调和平均 |

---

## 52. 本周内容的逻辑闭环

Week 3 的逻辑不是孤立知识点，而是一条完整项目路线：

```text
模型效果不好
    ↓
先不要盲目试
    ↓
划分 training / CV / test
    ↓
计算 J_train 和 J_cv
    ↓
判断 high bias 还是 high variance
    ↓
根据问题类型选择行动
    ↓
用 error analysis 找具体错误类别
    ↓
有针对性地改数据或改模型
    ↓
必要时用 data augmentation / synthesis / transfer learning
    ↓
模型足够好后部署
    ↓
上线后持续监控和维护
```

本周最重要的思想是：

> 机器学习项目不是靠随机尝试推进的，而是靠诊断推动迭代。

---

## 53. 一张总表：诊断结果到行动

| 诊断结果 | 观察 | 应该尝试 | 不优先尝试 |
|---|---|---|---|
| high bias | `J_train` 明显高于 baseline | 更复杂模型、更多特征、减小 `lambda` | 只加更多数据 |
| high variance | `J_cv >> J_train` | 更多数据、减少特征、增大 `lambda`、正则化 | 继续增加复杂度 |
| 数据集中某类错误很多 | error analysis 中某类错误占比高 | 定向收集该类数据、设计相关特征 | 泛泛收集所有数据 |
| 类别极不平衡 | accuracy 看起来高但模型没用 | precision、recall、F1 | 只看 accuracy |
| 数据很少但有相关大模型 | 同类型输入有预训练模型 | transfer learning | 从零训练大模型 |
| 上线后表现下降 | 生产数据分布变化 | 监控、重训、模型更新 | 假设模型永远稳定 |

---

## 54. 最后一遍总括

第二课 Week 3 的核心是：当机器学习模型效果不好时，用 diagnostics 指导下一步，而不是靠直觉乱试。最基础的评估方法是把数据分成 training set、cross-validation set 和 test set。训练集用于学习参数，验证集用于选择模型和超参数，测试集只在最后评估泛化能力。

本周最重要的诊断工具是 bias and variance。`J_train` 明显高于 baseline，说明模型可能 high bias；`J_cv` 明显高于 `J_train`，说明模型可能 high variance。high bias 需要让模型更强，比如加特征、加多项式特征、降低正则化或增大神经网络；high variance 需要让模型更稳，比如加数据、减少特征、增加正则化。

在真实项目中，还需要 error analysis 来手动查看错分样本，找出错误集中在哪些类型上。添加数据时也不一定要盲目收集所有数据，可以定向收集模型最容易犯错的数据。对于图像、语音等任务，可以用 data augmentation 或 data synthesis 扩展数据；当目标任务数据很少时，可以用 transfer learning 从预训练模型开始。

最后，模型训练只是完整机器学习项目的一部分。一个真实系统还要经历 scoping、data collection、model training、deployment、monitoring 和 maintenance。上线系统还必须考虑 fairness、bias 和 ethics，因为机器学习系统可能真实影响人的机会、权益和生活。
