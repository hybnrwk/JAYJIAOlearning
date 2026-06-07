# Week 2 讲解讲义：神经网络训练、激活函数与多分类

> 这份讲义主要依据 `英文字幕/` 中 Week 2 的讲课顺序来写，同时结合 `work/` 中的 optional labs、practice quizzes 和 `9.Practice Lab Neural network training/` 中的编程作业。整体以中文讲解为主，关键术语保留中英双语，方便你阅读英文字幕、TensorFlow 文档和深度学习资料。

---

## 1. 第二课 Week 2 在解决什么问题

第二课 Week 1 讲的是 **inference / prediction 推理和预测**。

也就是：给定已经训练好的 neural network 参数，如何用 forward propagation 前向传播从输入 `x` 算出输出 `f(x)`。

Week 2 开始讲：

```text
如何训练 neural network 的参数
    ↓
如何选择 loss function
    ↓
如何使用 model.compile 和 model.fit
    ↓
为什么隐藏层常用 ReLU
    ↓
如何处理 multiclass classification
    ↓
如何使用 softmax 和交叉熵损失
    ↓
为什么推荐 linear output + from_logits=True
    ↓
如何用 Adam 加快训练
    ↓
除了 Dense layer，还有哪些 layer type
```

一句话概括：

> Week 1 学会“用神经网络做预测”，Week 2 学会“训练神经网络，并让它能处理更复杂的分类任务”。

---

## 2. 训练神经网络的三步

课程把 neural network training 和第一课里的 logistic regression training 对齐起来讲。

训练一个模型，本质上都包含三步：

```text
Step 1: 定义模型如何从 x 计算出 f(x)
Step 2: 定义 loss function / cost function
Step 3: 最小化 cost function，更新参数 W,b
```

这三步在 logistic regression 和 neural network 中完全对应。

### 2.1 Logistic Regression 中的三步

第一步，定义输出：

$$
z = \mathbf{w}\cdot\mathbf{x}+b
$$

$$
f_{\mathbf{w},b}(\mathbf{x})=g(z)=\frac{1}{1+e^{-z}}
$$

第二步，定义 binary cross-entropy loss：

$$
L(f(\mathbf{x}),y)
=-y\log(f(\mathbf{x}))-(1-y)\log(1-f(\mathbf{x}))
$$

再对所有训练样本求平均，得到 cost function：

$$
J(\mathbf{w},b)=
\frac{1}{m}\sum_{i=1}^{m}
L(f(\mathbf{x}^{(i)}),y^{(i)})
$$

第三步，用 gradient descent 最小化：

$$
w_j := w_j - \alpha \frac{\partial J}{\partial w_j}
$$

$$
b := b - \alpha \frac{\partial J}{\partial b}
$$

### 2.2 Neural Network 中的三步

神经网络中也一样。

第一步，定义网络结构：

```python
model = Sequential([
    tf.keras.Input(shape=(400,)),
    Dense(25, activation="sigmoid"),
    Dense(15, activation="sigmoid"),
    Dense(1, activation="sigmoid")
])
```

这一步告诉 TensorFlow：

```text
输入有多少特征
每一层有多少 units
每一层用什么 activation function
如何从 x 通过 forward propagation 计算出 f(x)
```

第二步，指定 loss function：

```python
model.compile(
    loss=tf.keras.losses.BinaryCrossentropy()
)
```

第三步，训练参数：

```python
model.fit(X, y, epochs=100)
```

这里 `fit` 会让 TensorFlow 调整神经网络中的所有 `W,b`，让 loss / cost 变小。

---

## 3. Loss 和 Cost 再区分一次

课程反复强调：

| 术语 | 英文 | 含义 |
|---|---|---|
| loss | 损失 | 单个训练样本上的误差 |
| cost | 代价 | 整个训练集 loss 的平均 |

在数学上：

$$
L(f(\mathbf{x}^{(i)}),y^{(i)})
$$

表示第 `i` 个样本的 loss。

整个训练集上的 cost 是：

$$
J(\mathbf{W},\mathbf{b})
=
\frac{1}{m}
\sum_{i=1}^{m}
L(f(\mathbf{x}^{(i)}),y^{(i)})
$$

神经网络有很多层，所以这里用大写的：

$$
\mathbf{W}, \mathbf{b}
$$

表示所有层的参数。

例如：

```text
W = {W^[1], W^[2], W^[3], ...}
b = {b^[1], b^[2], b^[3], ...}
```

TensorFlow 在训练时打印出来的 `loss`，很多时候指的是整个 batch 或 epoch 上的平均 loss。你可以把它理解为训练过程中监控的 cost 近似值。

---

## 4. `model.compile` 做什么

`model.compile` 的作用是告诉 TensorFlow：

```text
训练时用什么 loss function
训练时用什么 optimizer
还要不要额外记录 metrics
```

例如二分类：

```python
model.compile(
    loss=tf.keras.losses.BinaryCrossentropy(),
    optimizer=tf.keras.optimizers.Adam(learning_rate=0.001)
)
```

这里：

- `BinaryCrossentropy` 用于 binary classification 二分类。
- `Adam` 是 optimizer 优化器，用来更新参数。
- `learning_rate=0.001` 是 Adam 的初始学习率。

### 4.1 不同任务对应不同 loss

| 任务 | 输出 | 常用 loss |
|---|---|---|
| binary classification 二分类 | `y=0/1` | `BinaryCrossentropy` |
| multiclass classification 多分类 | `y` 是多个类别之一 | `SparseCategoricalCrossentropy` |
| regression 回归 | `y` 是连续数值 | `MeanSquaredError` |

例如回归任务可以写：

```python
model.compile(
    loss=tf.keras.losses.MeanSquaredError(),
    optimizer=tf.keras.optimizers.Adam(learning_rate=0.001)
)
```

---

## 5. `model.fit` 做什么

`model.fit(X, y, epochs=...)` 是真正训练模型的地方。

practice quiz 中有一道题问：

> 哪一行代码会更新神经网络参数，从而降低 cost？

答案是：

```python
model.fit(X, y, epochs=100)
```

不是：

```python
model = Sequential([...])
```

也不是：

```python
model.compile(...)
```

因为：

- `Sequential` 只是定义模型结构。
- `compile` 只是指定训练配置。
- `fit` 才会用数据真正更新参数。

### 5.1 Epoch 是什么

**epoch** 通常表示训练数据被完整用过一遍。

如果：

```python
model.fit(X, y, epochs=40)
```

表示训练过程会把训练集反复使用 40 轮。

在每个 epoch 中，TensorFlow 会做 forward propagation、计算 loss、通过 backpropagation 计算梯度，再由 optimizer 更新参数。

---

## 6. Backpropagation 反向传播

第一课我们手写过 gradient descent 的梯度公式。神经网络参数很多，如果人工推导每一层每个参数的导数，会非常麻烦。

TensorFlow 内部使用 **backpropagation 反向传播** 来计算梯度。

直觉上：

```text
forward propagation:
    x -> a^[1] -> a^[2] -> output -> loss

backpropagation:
    loss -> 反向计算每个 W,b 对 loss 的影响
```

反向传播的目的不是直接给出预测，而是计算：

$$
\frac{\partial J}{\partial W^{[l]}}
$$

$$
\frac{\partial J}{\partial b^{[l]}}
$$

然后 optimizer 用这些梯度更新参数。

本课程没有要求你手写 backpropagation 的完整推导，但你需要知道：

> TensorFlow 的 `model.fit` 内部会调用 backpropagation 来训练所有层的参数。

---

## 7. 为什么需要新的 Activation Functions

Week 1 中我们几乎一直用 sigmoid activation，因为它自然连接到 logistic regression。

但 Week 2 课程强调：

> 如果所有 hidden layers 都用 sigmoid，训练可能比较慢；实际神经网络中 hidden layers 更常用 ReLU。

本周主要介绍三种 activation functions：

| Activation | 公式 | 常见用途 |
|---|---|---|
| linear | `g(z)=z` | 回归输出层、logits 输出 |
| sigmoid | `g(z)=1/(1+e^{-z})` | 二分类输出层 |
| ReLU | `g(z)=max(0,z)` | 隐藏层默认选择 |

### 7.1 Linear Activation

linear activation function 是：

$$
g(z)=z
$$

也就是没有真正改变 `z`。

所以很多人会把 linear activation 称为：

```text
no activation function
```

课程中为了表述清楚，仍然称它为 linear activation。

### 7.2 Sigmoid Activation

sigmoid 是：

$$
g(z)=\frac{1}{1+e^{-z}}
$$

输出范围：

$$
0<g(z)<1
$$

因此适合二分类输出层，用来表示：

$$
P(y=1|\mathbf{x})
$$

### 7.3 ReLU Activation

ReLU 全称是 **Rectified Linear Unit 修正线性单元**。

公式：

$$
g(z)=\max(0,z)
$$

也就是：

$$
g(z)=
\begin{cases}
0, & z<0 \\
z, & z\ge 0
\end{cases}
$$

它的输出是非负数，可以是 0，也可以是任意正数。

---

## 8. ReLU 的直觉

课程用 demand prediction 里的 awareness 知晓度解释 ReLU。

如果一个中间特征是“用户是否知道这件 T-shirt”，用 sigmoid 输出 0 到 1 似乎合理。

但如果 awareness 不是简单的“知道 / 不知道”，而是：

```text
一点点知道
比较知道
非常知道
已经爆火
```

那么它不一定适合被限制在 0 到 1 之间。它可能更像一个非负连续值。

这时 ReLU 更自然：

```text
z < 0  -> 输出 0，表示这个特征关闭
z >= 0 -> 输出 z，表示这个特征被激活且强度可增长
```

### 8.1 ReLU 的“开关”能力

optional lab 中 ReLU 被用来拟合 piecewise linear function 分段线性函数。

ReLU 的关键能力是：

> 在某些输入区域输出 0，让某个 unit 暂时不参与；在另一些区域输出正值，让它开始参与。

这就像给每个 neuron 加了一个开关。

多个 ReLU units 组合起来，可以拼接出复杂的非线性函数。

### 8.2 为什么隐藏层常用 ReLU

课程给出两个原因：

第一，ReLU 计算更快。

sigmoid 需要指数运算：

$$
\frac{1}{1+e^{-z}}
$$

ReLU 只需要：

$$
\max(0,z)
$$

第二，ReLU 更利于训练。

sigmoid 在左右两侧都会变平，导数接近 0，容易让 gradient descent 变慢。ReLU 只在左侧平，右侧保持线性增长，因此实践中常常训练更快。

所以 quiz 中问：

> hidden layers 最常用什么 activation function？

答案是：

```text
ReLU
```

---

## 9. 输出层 Activation 怎么选

输出层的 activation function 应该由目标 `y` 的含义决定。

### 9.1 二分类：Sigmoid

如果：

$$
y \in \{0,1\}
$$

这是 binary classification。

输出层使用：

```python
Dense(1, activation="sigmoid")
```

因为输出可以解释为：

$$
P(y=1|\mathbf{x})
$$

### 9.2 可正可负的回归：Linear

如果预测值可以为正，也可以为负，例如股票明天相对今天上涨或下跌的幅度，那么输出层可以用：

```python
Dense(1, activation="linear")
```

### 9.3 非负回归：Linear 或 ReLU

如果预测值一定非负，例如房价、销量、金额，那么输出层可以用：

```python
Dense(1, activation="relu")
```

因为 ReLU 输出非负。

也可以用：

```python
Dense(1, activation="linear")
```

quiz 中问预测房价时输出层可选什么，答案是：

```text
linear 或 ReLU
```

sigmoid 不适合房价，因为它把输出限制在 0 到 1。

---

## 10. 为什么隐藏层不能全用 Linear

这是 Week 2 的一个核心理论点。

假设一个非常简单的两层网络：

$$
a^{[1]}=g(w_1x+b_1)
$$

$$
a^{[2]}=g(w_2a^{[1]}+b_2)
$$

如果每一层都用 linear activation：

$$
g(z)=z
$$

那么：

$$
a^{[1]}=w_1x+b_1
$$

$$
a^{[2]}=w_2a^{[1]}+b_2
$$

代入：

$$
a^{[2]}=w_2(w_1x+b_1)+b_2
$$

整理：

$$
a^{[2]}=(w_2w_1)x+(w_2b_1+b_2)
$$

令：

$$
w=w_2w_1
$$

$$
b=w_2b_1+b_2
$$

则：

$$
a^{[2]}=wx+b
$$

这就是一个线性模型。

### 10.1 更深的网络也一样

线性函数套线性函数，结果仍然是线性函数。

所以如果 hidden layers 全部用 linear activation，那么再深的 neural network 也只能表达一个 linear regression 或 logistic regression 等价模型。

结论：

> Hidden layers 必须使用非线性 activation function，例如 ReLU，否则深层网络没有意义。

---

## 11. Multiclass Classification 多分类

第一课和第二课 week1 主要讨论 binary classification：

$$
y \in \{0,1\}
$$

Week 2 进一步讨论 **multiclass classification 多分类**。

多分类指的是：

$$
y \in \{1,2,\ldots,N\}
$$

或者在代码中常用：

$$
y \in \{0,1,\ldots,N-1\}
$$

例如：

- 手写数字识别：0 到 9，共 10 类。
- 医学诊断：多种疾病类别。
- 工厂质检：划痕、变色、缺角等缺陷类别。
- 图像分类：dog、cat、horse、other。

多分类仍然是 classification，因为 `y` 只能取有限个离散类别；只是类别数超过 2。

---

## 12. Softmax Regression

**Softmax regression** 是 logistic regression 在多分类场景下的推广。

在 logistic regression 中，我们输出一个概率：

$$
P(y=1|\mathbf{x})
$$

另一个类别的概率就是：

$$
P(y=0|\mathbf{x})=1-P(y=1|\mathbf{x})
$$

而在 multiclass classification 中，如果有 `N` 个类别，我们希望输出：

$$
P(y=1|\mathbf{x}),P(y=2|\mathbf{x}),\ldots,P(y=N|\mathbf{x})
$$

这些概率必须满足：

$$
a_1+a_2+\cdots+a_N=1
$$

### 12.1 Softmax 公式

对每个类别 `j`，先计算：

$$
z_j=\mathbf{w}_j\cdot\mathbf{x}+b_j
$$

然后 softmax 输出：

$$
a_j=
\frac{e^{z_j}}
{\sum_{k=1}^{N}e^{z_k}}
$$

这里：

$$
a_j=P(y=j|\mathbf{x})
$$

### 12.2 Softmax 输出为什么加起来等于 1

因为：

$$
\sum_{j=1}^{N}a_j
=
\sum_{j=1}^{N}
\frac{e^{z_j}}{\sum_{k=1}^{N}e^{z_k}}
$$

分母对每一项都一样，所以：

$$
\sum_{j=1}^{N}a_j
=
\frac{\sum_{j=1}^{N}e^{z_j}}
{\sum_{k=1}^{N}e^{z_k}}
=1
$$

quiz 中问：

> 如果有 3 个输出，softmax activations 的和是多少？

答案是：

```text
1
```

类别数是 3、4、10 或更多，都必须加起来等于 1。

### 12.3 Softmax 和 Sigmoid 的一个重要差别

sigmoid、ReLU、linear 都是逐元素作用：

```text
a1 只依赖 z1
a2 只依赖 z2
```

但 softmax 不一样。

softmax 中：

$$
a_j=
\frac{e^{z_j}}
{\sum_{k=1}^{N}e^{z_k}}
$$

所以每个 `a_j` 都依赖所有 `z_1,...,z_N`。

这也是为什么 softmax 是一个“跨输出”的 activation。

---

## 13. Softmax Loss / Cross-Entropy Loss

softmax 多分类使用 cross-entropy loss。

如果真实类别是 `j`，loss 是：

$$
L(\mathbf{a},y)=-\log(a_j)
$$

例如有 4 类，真实标签是：

$$
y=3
$$

那么 loss 就是：

$$
L=-\log(a_3)
$$

不是四个类别 loss 的平均。

quiz 中问：

> 如果 true class 是 3，cross entropy loss 简化成什么？

答案是：

$$
-\log(a_3)
$$

### 13.1 为什么这个 loss 合理

如果真实类别是 `j`，我们希望模型给真实类别的概率 `a_j` 尽可能大。

当：

$$
a_j \to 1
$$

则：

$$
-\log(a_j) \to 0
$$

loss 很小。

当：

$$
a_j \to 0
$$

则：

$$
-\log(a_j) \to +\infty
$$

loss 很大。

所以这个 loss 会惩罚“对真实类别给出很低概率”的模型。

---

## 14. Neural Network with Softmax Output

手写数字 0 到 9 识别是一个 10-class classification。

输入图片是 20x20，展开后是：

```text
400 input features
```

如果要识别 10 个数字，输出层需要 10 个 units。

直觉结构：

```text
400 inputs
 -> hidden layer: 25 units
 -> hidden layer: 15 units
 -> output layer: 10 units
```

每个输出 unit 对应一个类别：

```text
unit 0 -> digit 0
unit 1 -> digit 1
...
unit 9 -> digit 9
```

### 14.1 表面上可以这样写

你可能会写：

```python
model = Sequential([
    tf.keras.Input(shape=(400,)),
    Dense(25, activation="relu"),
    Dense(15, activation="relu"),
    Dense(10, activation="softmax")
])

model.compile(
    loss=tf.keras.losses.SparseCategoricalCrossentropy(),
    optimizer=tf.keras.optimizers.Adam(learning_rate=0.001)
)
```

这个写法概念上正确，也能运行。

但课程强调：**这不是 TensorFlow 中推荐的最佳写法**。

---

## 15. 推荐写法：Linear Output + `from_logits=True`

TensorFlow 中更推荐：

```python
model = Sequential([
    tf.keras.Input(shape=(400,)),
    Dense(25, activation="relu", name="L1"),
    Dense(15, activation="relu", name="L2"),
    Dense(10, activation="linear", name="L3")
])

model.compile(
    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
    optimizer=tf.keras.optimizers.Adam(learning_rate=0.001)
)
```

关键变化有两个：

第一，输出层不用 softmax，而用 linear：

```python
Dense(10, activation="linear")
```

第二，loss 中加入：

```python
from_logits=True
```

### 15.1 Logits 是什么

**logits** 指的是还没有经过 sigmoid 或 softmax 转换的原始输出。

在多分类中，输出层先给出：

$$
z_1,z_2,\ldots,z_{10}
$$

这些 `z` 就是 logits。

如果你想要概率，再对 logits 应用 softmax：

```python
prediction = model.predict(x_new)
probabilities = tf.nn.softmax(prediction)
```

### 15.2 为什么推荐 `from_logits=True`

如果你显式先算 softmax，再算 cross entropy，计算机会先得到：

$$
a_j=
\frac{e^{z_j}}{\sum_k e^{z_k}}
$$

再计算：

$$
-\log(a_j)
$$

当某些 `z_j` 很大或很小时，指数运算可能带来 numerical round-off error 数值舍入误差，甚至 overflow 溢出。

如果写：

```python
SparseCategoricalCrossentropy(from_logits=True)
```

TensorFlow 知道输入是 logits，于是可以把 softmax 和 cross entropy 合在一起，用更稳定的方式计算。

这就是课程说的：

```text
preferred implementation
```

### 15.3 预测时要注意

因为输出层是 linear，训练后的：

```python
prediction = model.predict(x_new)
```

不是概率。

它是 logits。

如果只需要类别：

```python
yhat = np.argmax(prediction)
```

因为最大 logit 对应最大 softmax 概率。

如果需要概率：

```python
prediction_p = tf.nn.softmax(prediction)
yhat = np.argmax(prediction_p)
```

---

## 16. Softmax 的数值稳定性

optional softmax lab 进一步解释为什么直接计算：

$$
e^{z_j}
$$

可能有问题。

如果 `z_j` 很大，例如 800：

```python
np.exp(800)
```

可能发生 overflow。

一个更稳定的 softmax 写法是先减去最大值：

$$
a_j=
\frac{e^{z_j-\max(z)}}
{\sum_k e^{z_k-\max(z)}}
$$

这不改变 softmax 的结果，因为分子分母都乘了同一个常数：

$$
e^{-\max(z)}
$$

NumPy 版本：

```python
def my_softmax_ns(z):
    bigz = np.max(z)
    ez = np.exp(z - bigz)
    return ez / np.sum(ez)
```

TensorFlow 的 `from_logits=True` 会在 loss 内部使用更稳定的实现，所以实战中通常不需要你手写这些细节。

---

## 17. SparseCategoricalCrossentropy 与 CategoricalCrossentropy

TensorFlow 有两种常见多分类交叉熵。

### 17.1 SparseCategoricalCrossentropy

如果标签是一个整数：

```text
y = 0, 1, 2, ..., 9
```

使用：

```python
tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True)
```

手写数字识别作业用的就是这个。

### 17.2 CategoricalCrossentropy

如果标签是 one-hot encoded 向量，例如类别 2 写成：

```text
[0, 0, 1, 0, 0, 0, 0, 0, 0, 0]
```

使用：

```python
tf.keras.losses.CategoricalCrossentropy(from_logits=True)
```

简单记忆：

```text
y 是整数 -> SparseCategoricalCrossentropy
y 是 one-hot 向量 -> CategoricalCrossentropy
```

---

## 18. Multiclass vs Multi-label

课程还区分了两个容易混淆的概念。

### 18.1 Multiclass Classification

**Multiclass classification 多分类** 是多个类别中选一个。

例如手写数字：

```text
一张图片只能是 0,1,2,...,9 中的一个
```

输出层通常用 `N` 个 units，再通过 softmax 得到总和为 1 的概率分布。

### 18.2 Multi-label Classification

**Multi-label classification 多标签分类** 是一个样本可以同时有多个标签。

例如自动驾驶图像：

```text
是否有 car
是否有 bus
是否有 pedestrian
```

同一张图可能同时有 car 和 pedestrian。

这时输出不是单个类别，而是一个向量：

$$
\mathbf{y}=
\begin{bmatrix}
y_{car}\\
y_{bus}\\
y_{pedestrian}
\end{bmatrix}
$$

每个位置都是一个 binary classification。

输出层可以有多个 sigmoid units：

```python
Dense(3, activation="sigmoid")
```

每个输出单独表示一个标签是否存在。

### 18.3 关键区别

| 类型 | 输出含义 | 输出层 |
|---|---|---|
| multiclass | 多选一 | softmax / logits + softmax |
| multi-label | 多个标签可同时为真 | 多个 sigmoid |

---

## 19. Adam Optimizer

第一课主要讲 gradient descent。

Week 2 介绍更常用的 optimizer：

```text
Adam
```

Adam 全称是 **Adaptive Moment Estimation**。

### 19.1 Adam 的直觉

gradient descent 使用一个全局 learning rate：

$$
\alpha
$$

但训练神经网络时，不同参数可能需要不同步长。

如果某个参数一直朝相似方向更新，说明步子可能太小，可以加大学习率。

如果某个参数来回震荡，说明步子可能太大，应该减小学习率。

Adam 会为不同参数自适应调整学习率。

### 19.2 TensorFlow 中使用 Adam

quiz 中问：

> 如何在 TensorFlow 中使用 Adam optimizer？

答案是：

```python
model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=1e-3),
    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True)
)
```

不是 TensorFlow 自动选择，也不是只有 softmax 才能用 Adam。

Adam 是目前训练神经网络的常用默认选择。

### 19.3 学习率仍然需要尝试

虽然 Adam 比普通 gradient descent 更鲁棒，但初始 learning rate 仍然重要。

常见起点：

```python
learning_rate=0.001
```

如果训练太慢或 loss 不稳定，可以尝试更大或更小的值。

---

## 20. Additional Layer Types

到目前为止，我们主要使用：

```text
Dense layer / fully connected layer
```

Dense layer 的特点是：

> 当前层每个 neuron 都连接上一层所有 activation。

但神经网络还有其他 layer types。

课程简单介绍了 **convolutional layer 卷积层**。

### 20.1 Convolutional Layer

在 convolutional layer 中，一个 neuron 不一定看上一层的所有输入，而可能只看一个局部区域。

例如图像中：

```text
某个 neuron 只看图片左上角一小块像素
另一个 neuron 只看图片中间一小块像素
另一个 neuron 只看图片右下角一小块像素
```

这叫 local receptive field 局部感受野。

quiz 中问：

> 每个 neuron 只看输入向量的一部分，这是什么 layer？

答案是：

```text
convolutional layer
```

### 20.2 为什么卷积层有用

课程提到两个直觉好处：

第一，计算更快。

因为每个 neuron 不需要连接所有输入。

第二，可能需要更少训练数据，也更不容易 overfitting。

因为模型结构利用了图像、时间序列等数据的局部性。

### 20.3 EKG 例子

课程用 EKG / ECG 心电图举例。

心电图可以看成一个 1D time series：

```text
x1, x2, ..., x100
```

第一个 convolutional neuron 只看：

```text
x1 到 x20
```

第二个看：

```text
x11 到 x30
```

第三个看：

```text
x21 到 x40
```

这样每个 neuron 只捕捉局部片段中的模式，再把这些模式交给后续层判断是否存在心脏问题。

### 20.4 本课程不深入 CNN

这周只是让你知道：

> Dense layer 不是神经网络唯一的 layer type。

更高级的模型，例如 convolutional neural network、transformer、LSTM、attention model，本质上都可以理解为研究者设计出的不同 layer / block，再组合成更强的网络。

---

## 21. Practice Lab：手写数字 0-9 识别

本周编程作业是：

```text
Neural Networks for Handwritten Digit Recognition, Multiclass
```

也就是用神经网络识别数字 0 到 9。

### 21.1 数据集

数据来自 MNIST 的一个子集。

每张图片是：

```text
20 x 20 grayscale image
```

展开成：

```text
400-dimensional vector
```

所以：

```text
X.shape = (5000, 400)
y.shape = (5000, 1)
```

`y` 是整数标签：

```text
y = 0 表示数字 0
y = 1 表示数字 1
...
y = 9 表示数字 9
```

这是 multiclass classification，不是 binary classification。

---

## 22. Practice Lab Exercise 1：`my_softmax`

作业第一题要求实现 softmax。

公式：

$$
a_j=
\frac{e^{z_j}}
{\sum_{k=0}^{N-1}e^{z_k}}
$$

### 22.1 循环版本

```python
def my_softmax(z):
    N = len(z)
    a = np.zeros(N)
    ez_sum = 0
    for k in range(N):
        ez_sum += np.exp(z[k])
    for j in range(N):
        a[j] = np.exp(z[j]) / ez_sum
    return a
```

### 22.2 向量化版本

```python
def my_softmax(z):
    ez = np.exp(z)
    a = ez / np.sum(ez)
    return a
```

理解重点：

- softmax 输入是一个向量 `z`。
- 输出也是一个向量 `a`。
- 每个 `a_j` 在 0 到 1 之间。
- 所有 `a_j` 加起来等于 1。
- 最大的 `z_j` 通常对应最大的 `a_j`。

---

## 23. Practice Lab Exercise 2：搭建多分类神经网络

作业第二题要求搭建 3 层网络：

```text
400 -> 25 -> 15 -> 10
```

推荐代码：

```python
tf.random.set_seed(1234)
model = Sequential(
    [
        tf.keras.Input(shape=(400,)),
        Dense(25, activation="relu", name="L1"),
        Dense(15, activation="relu", name="L2"),
        Dense(10, activation="linear", name="L3")
    ],
    name="my_model"
)
```

注意最后一层是：

```python
activation="linear"
```

不是：

```python
activation="softmax"
```

因为训练时会用：

```python
from_logits=True
```

### 23.1 参数个数

第一层：

```text
400 inputs * 25 units + 25 biases = 10025
```

第二层：

```text
25 inputs * 15 units + 15 biases = 390
```

第三层：

```text
15 inputs * 10 units + 10 biases = 160
```

总参数：

```text
10025 + 390 + 160 = 10575
```

### 23.2 编译与训练

```python
model.compile(
    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
    optimizer=tf.keras.optimizers.Adam(learning_rate=0.001),
)

history = model.fit(
    X, y,
    epochs=40
)
```

这里：

- `SparseCategoricalCrossentropy` 对应整数标签 0 到 9。
- `from_logits=True` 表示模型输出是 logits。
- `Adam(learning_rate=0.001)` 用 Adam 更新参数。

### 23.3 预测

对某张图片预测：

```python
image_of_two = X[1015]
prediction = model.predict(image_of_two.reshape(1, 400))
```

这时 `prediction` 是 logits，不是概率。

如果只要类别：

```python
yhat = np.argmax(prediction)
```

如果要概率：

```python
prediction_p = tf.nn.softmax(prediction)
yhat = np.argmax(prediction_p)
```

---

## 24. Optional Lab：Multiclass TensorFlow

`C2_W2_Multiclass_TF.ipynb` 用一个二维 toy dataset 演示 4 类分类。

数据由 `make_blobs` 生成：

```python
classes = 4
X_train, y_train = make_blobs(...)
```

模型：

```python
model = Sequential([
    Dense(2, activation="relu", name="L1"),
    Dense(4, activation="linear", name="L2")
])
```

编译：

```python
model.compile(
    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
    optimizer=tf.keras.optimizers.Adam(0.01),
)
```

### 24.1 这个 lab 的直觉

第一层 ReLU units 会把原始二维输入转换成新的 feature space。

第二层 linear outputs 会给 4 个类别分别打分。

softmax 和 cross entropy 的组合会推动模型让正确类别的 score 更高。

这说明神经网络不只是“直接画边界”，而是：

```text
先通过 hidden layer 变换特征
再在新特征空间中分类
```

---

## 25. Optional Lab：ReLU

`C2_W2_Relu.ipynb` 展示了 ReLU 为什么能表达非线性。

核心观察：

```text
ReLU 可以让某些 unit 在某些区域输出 0
也可以让它在另一些区域线性增长
```

多个 ReLU units 的组合可以拼出 piecewise linear functions。

这解释了为什么：

```text
hidden layer 使用 ReLU
```

比：

```text
hidden layer 使用 linear
```

更有表达能力。

---

## 26. Optional Lab：Softmax

`C2_W2_SoftMax.ipynb` 重点有三件事。

第一，softmax 把 logits 转成概率分布：

```python
def my_softmax(z):
    ez = np.exp(z)
    return ez / np.sum(ez)
```

第二，softmax 是跨输出的：

```text
改变 z0 会影响 a0, a1, a2, ...
```

第三，TensorFlow 推荐写法是：

```python
Dense(N, activation="linear")
```

配合：

```python
SparseCategoricalCrossentropy(from_logits=True)
```

预测概率时再做：

```python
tf.nn.softmax(logits)
```

---

## 27. Week 2 关键词表

| English | 中文 | 解释 |
|---|---|---|
| training | 训练 | 用数据学习模型参数 |
| inference | 推理 | 用训练好的模型做预测 |
| forward propagation | 前向传播 | 从输入算到输出 |
| backpropagation | 反向传播 | 从 loss 反向计算梯度 |
| loss function | 损失函数 | 单个样本上的误差 |
| cost function | 代价函数 | 全训练集平均 loss |
| optimizer | 优化器 | 根据梯度更新参数的算法 |
| gradient descent | 梯度下降 | 基础优化算法 |
| Adam | Adam 优化器 | 自适应调整学习率的优化器 |
| epoch | 训练轮次 | 通常表示完整遍历训练集一次 |
| activation function | 激活函数 | 把 `z` 转换成 activation |
| linear activation | 线性激活 | `g(z)=z` |
| sigmoid activation | sigmoid 激活 | 二分类输出常用 |
| ReLU | 修正线性单元 | `max(0,z)`，隐藏层常用 |
| multiclass classification | 多分类 | 多个类别中选一个 |
| multi-label classification | 多标签分类 | 一个样本可同时有多个标签 |
| softmax | softmax 函数 | 把多个 logits 转成概率分布 |
| logits | 原始分数 | softmax / sigmoid 前的输出 |
| cross-entropy loss | 交叉熵损失 | 分类任务常用 loss |
| SparseCategoricalCrossentropy | 稀疏类别交叉熵 | 标签是整数类别时使用 |
| CategoricalCrossentropy | 类别交叉熵 | 标签是 one-hot 时使用 |
| one-hot encoding | 独热编码 | 正确类别为 1，其余为 0 |
| numerical stability | 数值稳定性 | 避免舍入误差、上溢等问题 |
| from_logits | 从 logits 计算 | TensorFlow loss 的稳定计算选项 |
| Dense layer | 稠密层 | 每个 neuron 连接上一层全部输出 |
| convolutional layer | 卷积层 | 每个 neuron 只看局部输入区域 |

---

## 28. Quiz 考点整理

### 28.1 Neural Network Training

`BinaryCrossentropy` 用于 binary classification，也就是正好两个类别。

真正更新参数的代码是：

```python
model.fit(X, y, epochs=...)
```

`Sequential` 定义模型，`compile` 设置 loss / optimizer，`fit` 才训练。

### 28.2 Activation Functions

hidden layers 最常用 ReLU。

预测房价这类非负回归任务，输出层可以用：

```text
linear 或 ReLU
```

隐藏层如果没有 activation function 或全用 linear activation，深层网络会退化成线性模型，所以这个做法无效。

### 28.3 Multiclass Classification

softmax 输出的所有 activations 之和等于 1。

如果真实类别是第 `j` 类，cross-entropy loss 是：

$$
-\log(a_j)
$$

推荐的 TensorFlow 写法是：

```python
Dense(N, activation="linear")
loss=SparseCategoricalCrossentropy(from_logits=True)
```

不要在推荐写法里把输出层写成 softmax。

### 28.4 Additional Neural Network Concepts

Adam optimizer 要在 `model.compile` 中指定：

```python
optimizer=tf.keras.optimizers.Adam(learning_rate=1e-3)
```

convolutional layer 的特点是：每个 neuron 只看输入的一部分，而不是上一层的全部输入。

---

## 29. Week 2 的逻辑闭环

第一步，训练神经网络仍然遵循三件事：

```text
定义模型 -> 定义 loss -> 最小化 loss
```

第二步，TensorFlow 中对应：

```python
model = Sequential([...])
model.compile(...)
model.fit(...)
```

第三步，隐藏层通常使用 ReLU，因为它训练快、表达能力强。

第四步，输出层根据任务选 activation：

```text
二分类 -> sigmoid
回归可正可负 -> linear
非负回归 -> linear 或 ReLU
多分类 -> linear logits + softmax loss
```

第五步，多分类用 softmax 把多个 logits 转成概率：

$$
a_j=
\frac{e^{z_j}}
{\sum_k e^{z_k}}
$$

第六步，训练多分类神经网络时推荐：

```python
Dense(N, activation="linear")
SparseCategoricalCrossentropy(from_logits=True)
```

第七步，预测时如果只要类别，用：

```python
np.argmax(logits)
```

如果要概率，再用：

```python
tf.nn.softmax(logits)
```

第八步，Adam 是训练神经网络的常用优化器，比普通 gradient descent 更常用。

---

## 30. 最后一遍总括

第二课 Week 2 的核心是把 Week 1 的 forward propagation 推进到完整的 neural network training。训练神经网络仍然是三步：定义模型、定义 loss、最小化 cost。TensorFlow 中分别对应 `Sequential`、`compile` 和 `fit`，其中 `fit` 会通过 backpropagation 和 optimizer 更新参数。

本周最重要的结构变化是：hidden layers 通常不用 sigmoid，而用 ReLU。ReLU 的 `max(0,z)` 既能提供非线性，又能让某些 unit 在某些区域关闭，从而帮助网络组合出更复杂的函数。如果隐藏层全用 linear activation，深层网络会退化成普通线性模型。

本周另一个核心是 multiclass classification。softmax 把多个 logits 转成总和为 1 的概率分布，cross-entropy loss 只惩罚真实类别对应的概率。TensorFlow 中推荐把输出层设成 linear，并在 `SparseCategoricalCrossentropy(from_logits=True)` 中合并 softmax 和 loss，从而获得更好的数值稳定性。最后，Adam optimizer 是训练神经网络时的常用默认选择；而 convolutional layer 说明神经网络不只有 Dense layer，还可以通过不同 layer type 适应不同数据结构。
