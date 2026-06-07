# Week 1 讲解讲义：神经网络直觉、模型结构与前向传播

> 这份讲义主要依据 `英文字幕/` 中的 Week 1 视频顺序来写，同时结合 `work/` 中的 optional labs 和 `9.Practice Lab Neural networks/` 中的编程作业。整体以中文讲解为主，关键术语保留中英双语，方便你后续阅读 TensorFlow 文档、英文课件和深度学习相关资料。

---

## 1. 第二课 Week 1 在讲什么

第一课 `Supervised Machine Learning Regression and Classification` 已经建立了三个基本工具：

- linear regression 线性回归：预测连续数值。
- logistic regression 逻辑回归：做二分类。
- gradient descent 梯度下降：通过迭代更新参数来最小化 cost function。

第二课 `Advanced Learning Algorithms` 开始进入更强的模型。Week 1 的核心是：

```text
从 logistic regression 的一个神经元出发
    ↓
把多个神经元组成一层 layer
    ↓
把多层 layer 串起来形成 neural network
    ↓
在给定参数 w,b 的情况下做 inference / prediction
    ↓
用 forward propagation 从输入一路算到输出
    ↓
用 TensorFlow 和 NumPy 分别实现这个过程
    ↓
理解为什么 matrix multiplication / vectorization 可以让神经网络高效运行
```

这一周要特别注意：**Week 1 主要讲 inference 推理，也就是“如何用已经有的神经网络参数做预测”。**

训练神经网络的细节，例如如何通过 back propagation 反向传播和梯度下降学到参数，会在 Week 2 重点展开。

所以本周的主线不是“怎么训练”，而是：

```text
给定 x、W、b
神经网络如何一层一层算出预测结果？
```

---

## 2. Neural Networks / Deep Learning 是什么

**Neural network 神经网络**，也常被称为 **artificial neural network 人工神经网络**。现代语境下，很多人也会用 **deep learning 深度学习** 来指代使用多层神经网络的方法。

早期神经网络的灵感来自生物大脑中的神经元。生物神经元接收来自其他神经元的电信号，进行某种处理，再把信号传给其他神经元。人工神经网络借用了这个想法：一个人工神经元接收一些数字作为输入，经过计算，输出另一个数字。

但课程也强调一点：

> 现代神经网络并不是对人脑的精确模拟。

人工神经元通常只是非常简单的数学函数，远远不能代表真实生物神经元的复杂性。今天的神经网络更应该被理解为一种强大的工程算法，而不是“人脑复制品”。

### 2.1 为什么神经网络近年变得重要

神经网络在 1950s 就有雏形，中间经历过几次兴起和低潮。近十多年重新爆发，主要有两个原因：

第一，**data 数据量变大**。

互联网、移动设备、数字化记录让很多行业有了大量训练数据。传统算法，例如 linear regression 和 logistic regression，在数据量增加后性能提升有限；而足够大的 neural network 往往可以继续从更多数据中受益。

第二，**computation 计算能力变强**。

GPU 等硬件非常擅长做大规模矩阵运算，而神经网络正好可以用 matrix multiplication 矩阵乘法高效实现。这让训练大型神经网络成为可能。

可以把这个直觉记成：

```text
更多数据 + 更大模型 + 更强计算能力
    -> deep learning 在语音、图像、文本、推荐、广告、医疗影像等领域快速发展
```

---

## 3. 从 Logistic Regression 到一个神经元

理解神经网络最好的入口，是把第一课的 logistic regression 看成一个简单的神经元。

在逻辑回归中，我们先计算：

$$
z = \mathbf{w}\cdot \mathbf{x} + b
$$

再经过 sigmoid function：

$$
g(z)=\frac{1}{1+e^{-z}}
$$

输出：

$$
f_{\mathbf{w},b}(\mathbf{x}) = g(z)
$$

在神经网络语言中，课程把这个输出改写成：

$$
a = g(\mathbf{w}\cdot \mathbf{x}+b)
$$

这里的 `a` 叫 **activation 激活值**。

### 3.1 Activation 为什么叫激活值

`activation` 这个词来自神经科学。它大致表示一个神经元“激活到什么程度”，也就是它向后续神经元输出多强的信号。

在人工神经网络里，activation 就是一个神经元输出的数字。

如果输出层用 sigmoid，那么 activation 可以解释为概率：

$$
a = P(y=1|\mathbf{x})
$$

例如咖啡烘焙例子里，如果输出 `a=0.8`，可以理解为模型认为这组温度和时间烘焙出好咖啡的概率约为 0.8。

### 3.2 一个神经元可以看成一个小模型

课程中有一个很重要的直觉：

> 一个神经元就是一个很小的计算单元。它输入一个或多个数字，输出一个数字。

如果这个神经元没有 activation，输出就是：

$$
a = \mathbf{w}\cdot \mathbf{x}+b
$$

这和 linear regression 线性回归一样。

如果这个神经元使用 sigmoid activation，输出就是：

$$
a = sigmoid(\mathbf{w}\cdot \mathbf{x}+b)
$$

这和 logistic regression 逻辑回归一样。

所以本周不是从完全陌生的东西开始，而是在第一课基础上做扩展：

```text
linear regression / logistic regression
    -> 一个 neuron
    -> 一层 neurons
    -> 多层 neural network
```

---

## 4. Demand Prediction：用需求预测理解神经网络

课程用 T-shirt 是否会成为 top seller 来解释神经网络。

假设我们要预测一件 T-shirt 会不会成为畅销品。输入特征可能包括：

| 特征 | 英文 | 含义 |
|---|---|---|
| price | 价格 | 衣服售价 |
| shipping cost | 运费 | 用户最终承担的配送成本 |
| marketing | 营销投入 | 曝光、广告、推荐力度 |
| material quality | 材料质量 | 棉料、厚度、舒适度等 |

输出是：

$$
y \in \{0,1\}
$$

其中 `1` 表示 top seller，`0` 表示 not top seller。

### 4.1 Hidden Layer 隐藏层的直觉

为了判断一件 T-shirt 会不会畅销，人可能会先判断一些中间因素：

- affordability 可负担性：价格和运费是否让人觉得划算。
- awareness 知晓度：用户是否知道这件商品。
- perceived quality 感知质量：用户是否觉得它质量高。

这些中间因素不是原始数据里直接给出的标签。数据集中只有输入特征 `x` 和最终标签 `y`，并没有告诉我们“可负担性是多少”“知晓度是多少”。

因此这些中间量叫 **hidden features 隐藏特征**，产生它们的层叫 **hidden layer 隐藏层**。

### 4.2 神经网络会自己学习特征

第一课里，我们有时会手动构造特征。例如用房屋 `frontage` 和 `depth` 相乘得到 `lot size`。

这叫 **manual feature engineering 手工特征工程**。

神经网络强大的地方是：

> 它可以在 hidden layer 中自己学习更有用的特征表示。

在 T-shirt 例子中，模型不一定真的学出了人类命名的 affordability、awareness、perceived quality，但它会学习某些中间表示，使最终预测更容易。

这就是 **feature learning 特征学习**。

### 4.3 Dense / Fully Connected Layer

一开始我们可能会想：affordability 只应该看 price 和 shipping cost，awareness 只应该看 marketing。

但在实际神经网络中，通常让某一层的每个神经元都能看到上一层的所有输出。这样模型可以自己决定哪些输入重要，哪些输入可以忽略。

这种层叫：

- **dense layer 稠密层**
- **fully connected layer 全连接层**

意思是：当前层每个 neuron 都连接到上一层的所有 activation。

---

## 5. 神经网络的基本结构

一个典型的 neural network 包含：

| 结构 | 英文 | 作用 |
|---|---|---|
| input layer | 输入层 | 放输入特征 `x` |
| hidden layer | 隐藏层 | 学习中间特征表示 |
| output layer | 输出层 | 给出最终预测 |

例如：

```text
x
 -> hidden layer 1
 -> hidden layer 2
 -> output layer
 -> prediction
```

### 5.1 Layer 层

**Layer 层** 是一组神经元。

一个 layer 输入一个向量，输出另一个向量。

例如，某个隐藏层有 3 个神经元，那么它会输出 3 个 activation：

$$
\mathbf{a}^{[1]} =
\begin{bmatrix}
a_1^{[1]} \\
a_2^{[1]} \\
a_3^{[1]}
\end{bmatrix}
$$

这里的上标 `[1]` 表示第 1 层，下面的下标 `1,2,3` 表示这一层中的第几个神经元。

### 5.2 Unit / Neuron

课程中 **unit 单元** 和 **neuron 神经元** 基本可以互换使用。

如果第 `l` 层有 `j` 个神经元，就说这一层有 `j` 个 units。

### 5.3 Layer 的编号

按照神经网络常见约定：

- input layer 输入层也可以叫 layer 0。
- hidden layer 和 output layer 才算神经网络的层数。

例如：

```text
input layer: layer 0
hidden layer 1: layer 1
hidden layer 2: layer 2
output layer: layer 3
```

这个网络通常说是 **3-layer neural network**，因为不把 input layer 计入层数。

### 5.4 Architecture 架构

**Architecture 神经网络架构** 指的是网络的结构设计，主要包括：

- 有多少 hidden layers。
- 每个 hidden layer 有多少 neurons / units。
- 每层使用什么 activation function。

例如手写数字识别作业中的网络是：

```text
400 input features
 -> Dense(25, sigmoid)
 -> Dense(15, sigmoid)
 -> Dense(1, sigmoid)
```

这表示输入是 20x20 图片展开后的 400 个像素特征，第一层 25 个神经元，第二层 15 个神经元，输出层 1 个神经元。

---

## 6. 神经网络中的符号

课程使用一套很重要的 notation 符号。刚开始看会觉得复杂，但记住规律后很自然。

### 6.1 Activation 的写法

$$
a_j^{[l]}
$$

含义是：

- `a`：activation 激活值。
- 上标 `[l]`：第 `l` 层。
- 下标 `j`：这一层的第 `j` 个神经元。

例如：

$$
a_2^{[3]}
$$

表示第 3 层第 2 个神经元的 activation。

### 6.2 参数的写法

第 `l` 层第 `j` 个神经元有自己的参数：

$$
\mathbf{w}_j^{[l]}, b_j^{[l]}
$$

它接收上一层的输出：

$$
\mathbf{a}^{[l-1]}
$$

然后计算：

$$
z_j^{[l]} = \mathbf{w}_j^{[l]}\cdot \mathbf{a}^{[l-1]} + b_j^{[l]}
$$

再通过 activation function：

$$
a_j^{[l]} = g(z_j^{[l]})
$$

合起来就是：

$$
a_j^{[l]} =
g\left(\mathbf{w}_j^{[l]}\cdot \mathbf{a}^{[l-1]} + b_j^{[l]}\right)
$$

### 6.3 输入层也可以写成 activation

为了让公式统一，课程把输入 `x` 也写成：

$$
\mathbf{a}^{[0]} = \mathbf{x}
$$

这样第一层的公式也可以写成：

$$
a_j^{[1]} =
g\left(\mathbf{w}_j^{[1]}\cdot \mathbf{a}^{[0]} + b_j^{[1]}\right)
$$

也就是：

$$
a_j^{[1]} =
g\left(\mathbf{w}_j^{[1]}\cdot \mathbf{x} + b_j^{[1]}\right)
$$

---

## 7. Activation Function 激活函数

**Activation function 激活函数** 就是神经元计算完 `z` 后应用的函数：

$$
a = g(z)
$$

本周主要使用 sigmoid：

$$
g(z)=\frac{1}{1+e^{-z}}
$$

sigmoid 的输出范围是：

$$
0 < g(z) < 1
$$

所以它很适合二分类输出层，因为可以解释为概率。

### 7.1 本周为什么大量使用 sigmoid

第一课刚学完 logistic regression，而 sigmoid neuron 正好和 logistic regression 对应。

因此本周用 sigmoid 做过渡：

```text
logistic regression
    -> sigmoid neuron
    -> 多个 sigmoid neurons
    -> neural network
```

后续课程会介绍其他 activation function，例如 ReLU。实际深度学习中，hidden layers 不一定都用 sigmoid。

---

## 8. 图像识别例子：神经网络如何学习层级特征

课程用 face recognition 人脸识别解释为什么多层网络有意义。

一张 1000x1000 的灰度图，可以看成 1000x1000 个 pixel intensity 像素亮度值。如果把它展开成一个向量，就是 1,000,000 个输入特征。

神经网络可以把这些像素输入逐层处理：

```text
原始像素
 -> 第一层：检测短边缘、线段
 -> 第二层：组合边缘，检测眼睛、鼻子等局部结构
 -> 第三层：组合局部结构，检测更大的脸部形状
 -> 输出层：判断身份或类别
```

这个例子的重要点不是具体哪一层一定检测什么，而是：

> 神经网络可以从数据中自动学习 feature detectors 特征检测器。

如果换成汽车图片，第一层可能仍然学边缘，但后面会学车轮、车窗、车身轮廓等特征。相同算法输入不同数据，就会学出不同的特征。

---

## 9. Inference 与 Forward Propagation

**Inference 推理** 指的是：给定一个已经训练好的模型，用它对新样本做预测。

例如你从网上下载别人训练好的神经网络参数 `W,b`，然后输入一张图片，让它预测是 0 还是 1，这就是 inference。

### 9.1 Forward Propagation 前向传播

**Forward propagation 前向传播** 是神经网络做 inference 的计算过程。

它从输入层开始，一层一层向右计算：

```text
x -> a^[1] -> a^[2] -> a^[3] -> prediction
```

对于手写数字 0/1 二分类，课程中的示意网络是：

```text
image pixels
 -> layer 1: 25 units
 -> layer 2: 15 units
 -> layer 3: 1 unit
 -> probability that image is digit 1
```

数学上：

$$
\mathbf{a}^{[1]} = g(\mathbf{W}^{[1]}, \mathbf{b}^{[1]}, \mathbf{x})
$$

$$
\mathbf{a}^{[2]} = g(\mathbf{W}^{[2]}, \mathbf{b}^{[2]}, \mathbf{a}^{[1]})
$$

$$
\mathbf{a}^{[3]} = g(\mathbf{W}^{[3]}, \mathbf{b}^{[3]}, \mathbf{a}^{[2]})
$$

最后：

$$
f(\mathbf{x}) = a^{[3]}
$$

如果输出层是 sigmoid，那么 `a^[3]` 是预测为 `1` 的概率。

### 9.2 从概率到类别

和 logistic regression 一样，二分类时可以使用 0.5 threshold 阈值：

```text
if a >= 0.5:
    yhat = 1
else:
    yhat = 0
```

也可以写成：

$$
\hat{y} =
\begin{cases}
1, & a \ge 0.5 \\
0, & a < 0.5
\end{cases}
$$

### 9.3 Forward Propagation 和 Back Propagation 的区别

本周讲的是 forward propagation。

下一周会讲 **back propagation 反向传播**。

区别是：

| 算法 | 英文 | 作用 |
|---|---|---|
| forward propagation | 前向传播 | 用已有参数从输入算到输出 |
| back propagation | 反向传播 | 训练时计算梯度，更新参数 |

可以先记住：

```text
forward propagation: prediction
back propagation: learning
```

---

## 10. TensorFlow 中如何表示一层

TensorFlow 是深度学习框架。课程重点使用 TensorFlow 中的 Keras 接口。

最基本的层是：

```python
from tensorflow.keras.layers import Dense

layer_1 = Dense(units=3, activation="sigmoid")
```

这里：

- `Dense` 表示 dense layer / fully connected layer。
- `units=3` 表示这一层有 3 个神经元。
- `activation="sigmoid"` 表示每个神经元的输出经过 sigmoid。

如果输入 `x` 是咖啡烘焙的两个特征：

```python
x = np.array([[200, 17]])
a1 = layer_1(x)
```

则 `a1` 是这一层输出的 activation，形状是 `(1, 3)`，表示 1 个样本、3 个神经元输出。

### 10.1 咖啡烘焙例子

课程用 coffee roasting 咖啡烘焙说明 inference。

输入特征：

| 特征 | 英文 | 含义 |
|---|---|---|
| temperature | 温度 | 烘焙温度 |
| duration | 时长 | 烘焙时间 |

输出：

```text
y = 1: good coffee
y = 0: bad coffee
```

好咖啡不是温度越高越好，也不是时间越长越好。温度太低或时间太短会 undercooked，温度太高或时间太长会 overcooked。好咖啡对应的是特征空间中的一个合适区域。

一个简单网络可以写成：

```text
temperature, duration
 -> Dense(3, sigmoid)
 -> Dense(1, sigmoid)
 -> probability of good roast
```

TensorFlow 代码：

```python
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense

model = Sequential([
    tf.keras.Input(shape=(2,)),
    Dense(3, activation="sigmoid", name="layer1"),
    Dense(1, activation="sigmoid", name="layer2")
])
```

这表示输入有 2 个特征，第一层输出 3 个 activation，第二层输出 1 个概率。

---

## 11. TensorFlow 中的数据形状

本周一个容易出错的地方是 shape 形状。

第一课里，我们经常把一个样本写成 1D array：

```python
x = np.array([200, 17])
```

它的形状是：

```text
(2,)
```

但 TensorFlow 更常用 2D matrix 表示数据，即使只有一个样本，也写成一行：

```python
x = np.array([[200, 17]])
```

它的形状是：

```text
(1, 2)
```

这里的含义是：

```text
1 row    -> 1 training example
2 columns -> 2 features
```

### 11.1 样本放在行里

TensorFlow / Keras 中常见约定：

$$
X \in \mathbb{R}^{m \times n}
$$

其中：

- `m` 是样本数 number of examples。
- `n` 是特征数 number of features。

所以：

```text
X.shape = (m, n)
```

例如：

```python
X = np.array([
    [200, 17],
    [120, 15],
    [250, 12],
    [180, 14]
])
```

这是 4 个样本，每个样本 2 个特征，所以：

```text
X.shape = (4, 2)
```

### 11.2 Tensor 与 NumPy Array

TensorFlow 内部使用的数据类型叫 **tensor 张量**。

在本课范围内，你可以先把 tensor 理解成 TensorFlow 版本的 matrix / array。

如果 `a1` 是 TensorFlow tensor，可以用：

```python
a1.numpy()
```

把它转换回 NumPy array。

### 11.3 为什么 `reshape(1,400)` 很常见

手写数字识别作业中，一张 20x20 图片展开后是 400 个特征。

如果取一个样本：

```python
X[0]
```

它的形状通常是：

```text
(400,)
```

但 `model.predict` 期望输入是二维的 `(m,n)`，所以要写：

```python
prediction = model.predict(X[0].reshape(1, 400))
```

这表示：

```text
1 example, 400 features
```

---

## 12. 用 Sequential 构建神经网络

前面可以手动一层层写：

```python
layer_1 = Dense(3, activation="sigmoid")
a1 = layer_1(x)

layer_2 = Dense(1, activation="sigmoid")
a2 = layer_2(a1)
```

但 TensorFlow 更常见的写法是用 `Sequential` 把 layers 串起来：

```python
model = Sequential([
    Dense(3, activation="sigmoid"),
    Dense(1, activation="sigmoid")
])
```

`Sequential` 的意思是：按照列表顺序依次执行这些层。

```text
input -> first Dense layer -> second Dense layer -> output
```

### 12.1 model.predict

如果模型已经有参数，可以用：

```python
predictions = model.predict(X_new)
```

这会自动完成 forward propagation。

也就是说：

```text
model.predict(X_new)
```

本质上就是：

```text
把 X_new 输入第一层
计算 a^[1]
把 a^[1] 输入第二层
计算 a^[2]
...
得到最终输出
```

### 12.2 compile 和 fit 先知道作用即可

optional lab 和 practice lab 会出现：

```python
model.compile(
    loss=tf.keras.losses.BinaryCrossentropy(),
    optimizer=tf.keras.optimizers.Adam(0.001),
)

model.fit(X, y, epochs=20)
```

本周先知道：

- `compile`：指定 loss function 和 optimizer。
- `fit`：训练模型参数。

训练细节 Week 2 会系统讲。Week 1 的重点仍然是理解训练好以后 `predict` 如何做 inference。

---

## 13. 手写数字识别 Practice Lab

本周编程作业是用 neural network 识别手写数字 0 和 1。

这是一个 binary classification 二分类任务。

### 13.1 数据

每张图片是 20x20 的灰度图，展开后得到 400 个像素特征。

所以：

```text
X.shape = (m, 400)
```

标签是：

```text
y = 0: digit zero
y = 1: digit one
```

### 13.2 网络结构

作业要求使用 Keras `Sequential` 和 `Dense` 构造：

```python
model = Sequential(
    [
        tf.keras.Input(shape=(400,)),
        Dense(25, activation="sigmoid"),
        Dense(15, activation="sigmoid"),
        Dense(1, activation="sigmoid")
    ],
    name="my_model"
)
```

这对应：

```text
400 input features
 -> 25 hidden units
 -> 15 hidden units
 -> 1 output unit
```

输出层的 1 个 sigmoid unit 表示：

```text
P(y = 1 | image)
```

也就是“这张图是数字 1 的概率”。

### 13.3 参数个数如何理解

`model.summary()` 会显示每层参数数量。

对于 Dense layer：

```text
参数个数 = input_features * units + units
```

因为每个 unit 有一组 weights 和一个 bias。

例如第一层输入 400 个特征，输出 25 个 units：

```text
400 * 25 + 25 = 10025
```

第二层输入 25，输出 15：

```text
25 * 15 + 15 = 390
```

第三层输入 15，输出 1：

```text
15 * 1 + 1 = 16
```

这和作业中的 summary 对应。

### 13.4 预测与阈值

训练后预测：

```python
prediction = model.predict(X[0].reshape(1, 400))
```

如果：

```python
prediction >= 0.5
```

则预测为 `1`，否则预测为 `0`。

---

## 14. 用 NumPy 手写一层 Dense Layer

课程不希望你只会调用 TensorFlow 的五行代码，而不知道里面发生了什么。因此 Week 1 还要求用 NumPy 手写 forward propagation。

### 14.1 单个 Dense Layer 的计算

假设输入来自上一层：

$$
\mathbf{a}_{in}
$$

当前层有 `j` 个 units。权重矩阵：

$$
W \in \mathbb{R}^{n \times j}
$$

其中每一列是某个 unit 的 weights：

```text
W[:, 0] -> unit 0 的 w
W[:, 1] -> unit 1 的 w
...
W[:, j-1] -> unit j-1 的 w
```

偏置：

$$
\mathbf{b} \in \mathbb{R}^{j}
$$

第 `j` 个 unit 的计算是：

$$
z_j = \mathbf{w}_j \cdot \mathbf{a}_{in} + b_j
$$

$$
a_j = g(z_j)
$$

### 14.2 作业中的 `my_dense`

作业练习 2 要写：

```python
def my_dense(a_in, W, b, g):
    """
    Computes dense layer
    Args:
      a_in (ndarray (n, )) : Data, 1 example
      W    (ndarray (n,j)) : Weight matrix, n features per unit, j units
      b    (ndarray (j, )) : bias vector, j units
      g    activation function
    Returns:
      a_out (ndarray (j,)) : j units
    """
    units = W.shape[1]
    a_out = np.zeros(units)
    for j in range(units):
        w = W[:, j]
        z = np.dot(w, a_in) + b[j]
        a_out[j] = g(z)
    return a_out
```

这段代码的关键是：

```python
units = W.shape[1]
```

因为 `W` 的列数等于当前层神经元个数。

然后对每个 unit 做：

```python
w = W[:, j]
z = np.dot(w, a_in) + b[j]
a_out[j] = g(z)
```

这就是一个 Dense layer 的 forward propagation。

### 14.3 多层网络 `my_sequential`

有了 `my_dense`，就能把多层串起来：

```python
def my_sequential(x, W1, b1, W2, b2, W3, b3):
    a1 = my_dense(x,  W1, b1, sigmoid)
    a2 = my_dense(a1, W2, b2, sigmoid)
    a3 = my_dense(a2, W3, b3, sigmoid)
    return a3
```

这和 TensorFlow 的 `Sequential` 思想一样：

```text
x -> layer 1 -> layer 2 -> layer 3 -> output
```

区别只是：

- TensorFlow 自动帮你做。
- NumPy 版本让你手动看清每一步。

---

## 15. 对多个样本做预测

如果只有一个样本，可以直接：

```python
prediction = my_sequential(X[0], W1, b1, W2, b2, W3, b3)
```

如果有 `m` 个样本，最直接的方式是循环：

```python
def my_predict(X, W1, b1, W2, b2, W3, b3):
    m = X.shape[0]
    p = np.zeros((m, 1))
    for i in range(m):
        p[i, 0] = my_sequential(X[i], W1, b1, W2, b2, W3, b3)
    return p
```

这里：

- `X.shape[0]` 是样本数。
- 每次取 `X[i]`，对第 `i` 个样本做 forward propagation。
- 最后得到每个样本的 prediction。

这种写法容易理解，但当数据量很大时会慢。

这就引出 vectorization 向量化。

---

## 16. Vectorization 向量化

**Vectorization 向量化** 是把很多个循环计算改写成矩阵运算。

神经网络能够在 GPU 上高效运行，很大原因是：

> dense layer 的计算可以写成 matrix multiplication 矩阵乘法。

### 16.1 Dot Product 点积

两个向量点积：

$$
\mathbf{a}\cdot\mathbf{w}
= a_1w_1+a_2w_2+\cdots+a_nw_n
$$

一个神经元的线性部分就是点积：

$$
z = \mathbf{w}\cdot\mathbf{a}_{in}+b
$$

### 16.2 Matrix Multiplication 矩阵乘法

如果有很多样本、很多神经元，可以把所有点积一次性写成：

$$
Z = A_{in}W + b
$$

其中：

| 符号 | shape | 含义 |
|---|---|---|
| `A_in` | `(m, n)` | `m` 个样本，每个 `n` 个输入 |
| `W` | `(n, j)` | 当前层 `j` 个 units 的权重 |
| `b` | `(j,)` 或 `(1,j)` | 每个 unit 一个 bias |
| `Z` | `(m, j)` | 每个样本、每个 unit 的线性输出 |
| `A_out` | `(m, j)` | 激活后的输出 |

矩阵维度能相乘的条件是：

```text
(m, n) @ (n, j) -> (m, j)
```

中间的 `n` 必须相等。

### 16.3 向量化 Dense Layer

作业练习 3 要写：

```python
def my_dense_v(A_in, W, b, g):
    """
    Computes dense layer
    Args:
      A_in (ndarray (m,n)) : Data, m examples, n features each
      W    (ndarray (n,j)) : Weight matrix, n features per unit, j units
      b    (ndarray (j,1)) : bias vector, j units
      g    activation function
    Returns:
      A_out (ndarray (m,j)) : m examples, j units
    """
    Z = np.matmul(A_in, W) + b
    A_out = g(Z)
    return A_out
```

核心只有两行：

```python
Z = np.matmul(A_in, W) + b
A_out = g(Z)
```

这两行等价于对每个样本、每个 unit 都做一次：

```python
z = np.dot(w, a_in) + b
a = g(z)
```

区别是矩阵乘法一次性算完。

### 16.4 为什么向量化更快

如果你用 Python `for` loop 一个样本一个样本、一个神经元一个神经元地算，速度会受 Python 解释器开销影响。

如果改用 `np.matmul`，底层会调用高度优化的线性代数库，GPU / CPU 都很擅长这种运算。

所以实际深度学习系统中，神经网络训练和推理的核心都是大规模矩阵运算。

---

## 17. Broadcasting 广播

向量化代码里有一行：

```python
Z = np.matmul(A_in, W) + b
```

如果：

```text
np.matmul(A_in, W).shape = (m, j)
b.shape = (j,)
```

NumPy 会自动把 `b` 加到每一行上。

这叫 **broadcasting 广播**。

例如：

```text
Z = [
  [z11, z12, z13],
  [z21, z22, z23],
  ...
]

b = [b1, b2, b3]
```

则：

```text
Z + b =
[
  [z11+b1, z12+b2, z13+b3],
  [z21+b1, z22+b2, z23+b3],
  ...
]
```

这正好符合 dense layer：每个 unit 的 bias 加到所有样本对应的那个 unit 输出上。

---

## 18. Optional Lab 1：Neurons and Layers

`C2_W1_Lab01_Neurons_and_Layers.ipynb` 的作用是把第一课知识和神经网络连接起来。

### 18.1 没有 activation 的 neuron

如果一个 Dense layer 只有 1 个 unit，activation 是 linear：

```python
linear_layer = tf.keras.layers.Dense(units=1, activation="linear")
```

它计算：

$$
a = wx+b
$$

这就是线性回归。

### 18.2 有 sigmoid activation 的 neuron

如果 activation 是 sigmoid：

```python
model = Sequential([
    tf.keras.layers.Dense(1, input_dim=1, activation="sigmoid", name="L1")
])
```

它计算：

$$
a = sigmoid(wx+b)
$$

这就是逻辑回归。

这个 lab 的核心结论是：

```text
linear neuron -> linear regression
sigmoid neuron -> logistic regression
multiple neurons and layers -> neural network
```

---

## 19. Optional Lab 2：Coffee Roasting with TensorFlow

`C2_W1_Lab02_CoffeeRoasting_TF.ipynb` 用 TensorFlow 做咖啡烘焙分类。

### 19.1 数据归一化

lab 中会先做 normalization：

```python
norm_l = tf.keras.layers.Normalization(axis=-1)
norm_l.adapt(X)
Xn = norm_l(X)
```

原因和第一课 feature scaling 类似：不同特征量纲差异大时，训练会更慢或更不稳定。

这里温度范围大约是 150 到 285，时间范围大约是 11 到 15。归一化后，各特征范围更接近。

重要提醒：

> 训练时用了 normalization，以后对新样本预测时也必须使用同一个 normalization。

例如：

```python
X_testn = norm_l(X_test)
predictions = model.predict(X_testn)
```

### 19.2 模型

咖啡烘焙网络：

```python
model = Sequential([
    tf.keras.Input(shape=(2,)),
    Dense(3, activation="sigmoid", name="layer1"),
    Dense(1, activation="sigmoid", name="layer2")
])
```

参数数量：

第一层：

```text
2 input features * 3 units + 3 biases = 9
```

第二层：

```text
3 inputs * 1 unit + 1 bias = 4
```

### 19.3 训练与预测

lab 中会出现：

```python
model.compile(
    loss=tf.keras.losses.BinaryCrossentropy(),
    optimizer=tf.keras.optimizers.Adam(learning_rate=0.01),
)

model.fit(Xn, Y, epochs=10)
```

本周先把它理解成：

```text
compile: 告诉 TensorFlow 用什么 loss 和 optimizer
fit: 让 TensorFlow 学习 W 和 b
```

训练后：

```python
predictions = model.predict(X_testn)
yhat = (predictions >= 0.5).astype(int)
```

这里 `predictions` 是概率，`yhat` 是二分类决策。

---

## 20. Optional Lab 3：Coffee Roasting with NumPy

`C2_W1_Lab03_CoffeeRoasting_Numpy.ipynb` 用 NumPy 手写同一个咖啡烘焙网络。

模型结构：

```text
2 input features
 -> 3 hidden units
 -> 1 output unit
```

手写 dense layer：

```python
def my_dense(a_in, W, b, g):
    units = W.shape[1]
    a_out = np.zeros(units)
    for j in range(units):
        w = W[:, j]
        z = np.dot(w, a_in) + b[j]
        a_out[j] = g(z)
    return a_out
```

手写 sequential：

```python
def my_sequential(x, W1, b1, W2, b2):
    a1 = my_dense(x,  W1, b1, sigmoid)
    a2 = my_dense(a1, W2, b2, sigmoid)
    return a2
```

对多个样本预测：

```python
def my_predict(X, W1, b1, W2, b2):
    m = X.shape[0]
    p = np.zeros((m, 1))
    for i in range(m):
        p[i, 0] = my_sequential(X[i], W1, b1, W2, b2)
    return p
```

这个 lab 的意义是让你把 TensorFlow 的高级 API 和底层数学对上。

---

## 21. Matrix Multiplication：理解高效实现

Week 1 后面的 optional videos 专门讲矩阵乘法，因为向量化神经网络离不开它。

### 21.1 Dot product 是矩阵乘法的基础

向量：

$$
\mathbf{a} =
\begin{bmatrix}
1 \\
2
\end{bmatrix},
\quad
\mathbf{w} =
\begin{bmatrix}
3 \\
4
\end{bmatrix}
$$

点积：

$$
\mathbf{a}\cdot\mathbf{w}
= 1\cdot 3 + 2\cdot 4
= 11
$$

也可以写成：

$$
\mathbf{a}^T\mathbf{w}
$$

### 21.2 矩阵乘法的规则

如果：

$$
A \in \mathbb{R}^{r \times s}
$$

$$
B \in \mathbb{R}^{s \times t}
$$

那么：

$$
AB \in \mathbb{R}^{r \times t}
$$

条件是：

```text
A 的列数 = B 的行数
```

输出形状是：

```text
A 的行数 x B 的列数
```

例如：

```text
(m, n) @ (n, j) = (m, j)
```

这正是 dense layer 的形状。

### 21.3 `np.matmul` 和 `@`

NumPy 中矩阵乘法可以写：

```python
Z = np.matmul(A, W)
```

也可以写：

```python
Z = A @ W
```

课程中更偏向写 `np.matmul`，因为它更直观地说明正在做 matrix multiplication。

---

## 22. AGI 视频的要点

Week 1 还有一个关于 AGI 的讨论视频。它不是编程重点，但有助于理解课程对 neural networks 的态度。

### 22.1 ANI 与 AGI

**ANI: Artificial Narrow Intelligence，人工狭义智能**

指擅长某个具体任务的 AI 系统。例如：

- 语音识别。
- 图像识别。
- 推荐系统。
- 自动驾驶中的某些模块。
- 工厂、农业、医疗中的具体预测系统。

**AGI: Artificial General Intelligence，人工通用智能**

指能够像人类一样广泛处理各种任务的系统。

课程的态度比较谨慎：

> 近年 AI / ANI 进步很快，但这不等于 AGI 也已经接近解决。

### 22.2 不要把神经网络过度等同于人脑

神经网络借用了神经元这个名字，但人工神经元通常只是简单函数。

真实大脑如何工作，人类仍然了解很有限。因此，“只要模拟足够多神经元就能得到人类智能”这个想法过于简单。

本课程的重点不是讨论 AGI，而是把 neural networks 当作解决实际机器学习问题的强大工具。

---

## 23. Week 1 关键词表

| English | 中文 | 解释 |
|---|---|---|
| neural network | 神经网络 | 由多层神经元组成的模型 |
| artificial neural network | 人工神经网络 | 用数学函数模拟神经元组合的模型 |
| deep learning | 深度学习 | 通常指使用多层神经网络的方法 |
| neuron / unit | 神经元 / 单元 | 接收输入并输出一个 activation 的计算单元 |
| activation | 激活值 | 神经元输出的数值 |
| activation function | 激活函数 | 把 `z` 转换为 activation 的函数 |
| sigmoid function | sigmoid 函数 | 输出 0 到 1，适合二分类概率 |
| layer | 层 | 一组神经元 |
| input layer | 输入层 | 存放输入特征 |
| hidden layer | 隐藏层 | 学习中间表示，不直接由标签给出 |
| output layer | 输出层 | 产生最终预测 |
| dense layer | 稠密层 | 当前层每个神经元连接上一层所有输出 |
| fully connected layer | 全连接层 | dense layer 的另一个常见说法 |
| architecture | 架构 | 层数、每层 units 数、activation 等设计 |
| inference | 推理 | 用训练好的模型做预测 |
| prediction | 预测 | 模型输出结果 |
| forward propagation | 前向传播 | 从输入层一路向输出层计算 |
| back propagation | 反向传播 | 训练时计算梯度的算法，下周重点 |
| TensorFlow | TensorFlow | 深度学习框架 |
| Keras | Keras | TensorFlow 中常用的高层接口 |
| Sequential | 顺序模型 | 按顺序串联 layers 的模型 |
| Dense | 稠密层 | Keras 中的全连接层 |
| tensor | 张量 | TensorFlow 内部使用的数据结构 |
| NumPy array | NumPy 数组 | Python 科学计算中常用数组 |
| matrix multiplication | 矩阵乘法 | 神经网络高效实现的核心运算 |
| vectorization | 向量化 | 用矩阵运算替代显式循环 |
| broadcasting | 广播 | NumPy 自动扩展数组形状进行运算 |
| dot product | 点积 | 向量元素逐项相乘再求和 |
| feature learning | 特征学习 | 模型自动学习有用中间特征 |
| manual feature engineering | 手工特征工程 | 人为设计特征 |
| ANI | 人工狭义智能 | 擅长特定任务的 AI |
| AGI | 人工通用智能 | 类似人类的通用智能目标 |

---

## 24. Quiz 考点整理

### 24.1 Neural Networks Intuition

神经网络最初受到生物神经元启发，但现代神经网络不应被理解为真实大脑的精确复制。

神经网络兴起的重要原因：

- 数据量变大。
- 模型规模变大。
- GPU 等硬件让矩阵运算更快。

一个 logistic regression unit 可以看成一个 sigmoid neuron。

hidden layer 的重要作用是学习中间特征，而这些特征通常不会直接出现在训练标签中。

### 24.2 Neural Network Model

一个 layer 输入上一层 activation，输出当前层 activation。

通用公式：

$$
a_j^{[l]} =
g\left(\mathbf{w}_j^{[l]}\cdot \mathbf{a}^{[l-1]} + b_j^{[l]}\right)
$$

输入层可以写作：

$$
\mathbf{a}^{[0]}=\mathbf{x}
$$

如果输出是 sigmoid 概率，二分类可用 0.5 threshold 得到类别。

### 24.3 TensorFlow Implementation

`Dense(units=..., activation=...)` 中：

- `units` 决定当前层输出 activation 的数量。
- `activation` 决定每个 unit 的非线性函数。

`Sequential([...])` 用来把多层按顺序连接。

`model.predict(X_new)` 用来对新样本做 inference / forward propagation。

TensorFlow 中输入通常是二维：

```text
(number of examples, number of features)
```

所以单个样本也常要 reshape 成：

```text
(1, n)
```

### 24.4 Python / NumPy Implementation

手写 dense layer 时，`W[:, j]` 表示第 `j` 个 unit 的权重。

非向量化版本：

```python
for j in range(units):
    w = W[:, j]
    z = np.dot(w, a_in) + b[j]
    a_out[j] = g(z)
```

向量化版本：

```python
Z = np.matmul(A_in, W) + b
A_out = g(Z)
```

矩阵乘法维度规则：

```text
(m, n) @ (n, j) = (m, j)
```

---

## 25. 本周编程作业的完成思路

### 25.1 Exercise 1：构建 TensorFlow 模型

目标是搭出：

```text
400 -> 25 -> 15 -> 1
```

代码：

```python
model = Sequential(
    [
        tf.keras.Input(shape=(400,)),
        Dense(25, activation="sigmoid"),
        Dense(15, activation="sigmoid"),
        Dense(1, activation="sigmoid")
    ],
    name="my_model"
)
```

理解重点：

- `shape=(400,)` 表示每个样本有 400 个特征。
- `Dense(25)` 表示第一层输出 25 个 activation。
- 最后一层 `Dense(1)` 输出一个概率。

### 25.2 Exercise 2：手写 `my_dense`

目标是计算单个样本通过一层的输出。

核心三步：

```text
取出第 j 个 unit 的权重 w = W[:,j]
计算 z = dot(w, a_in) + b[j]
计算 a_out[j] = g(z)
```

完整代码：

```python
def my_dense(a_in, W, b, g):
    units = W.shape[1]
    a_out = np.zeros(units)
    for j in range(units):
        w = W[:, j]
        z = np.dot(w, a_in) + b[j]
        a_out[j] = g(z)
    return a_out
```

### 25.3 Exercise 3：手写向量化 `my_dense_v`

目标是让一整批样本一次通过一层。

核心代码：

```python
def my_dense_v(A_in, W, b, g):
    Z = np.matmul(A_in, W) + b
    A_out = g(Z)
    return A_out
```

理解重点：

```text
A_in: (m, n)
W:    (n, j)
b:    (j,) 或 (1, j)
Z:    (m, j)
```

向量化版本和循环版本数学上等价，但速度通常更快。

---

## 26. Week 1 的逻辑闭环

第一步，把第一课的 logistic regression 看成一个 sigmoid neuron：

$$
a = sigmoid(\mathbf{w}\cdot\mathbf{x}+b)
$$

第二步，把多个 neurons 放在一起，形成一个 layer：

$$
\mathbf{a}^{[1]} =
\begin{bmatrix}
a_1^{[1]} \\
a_2^{[1]} \\
\cdots
\end{bmatrix}
$$

第三步，把多个 layers 串起来，形成 neural network：

```text
x -> a^[1] -> a^[2] -> ... -> output
```

第四步，用 forward propagation 做 inference：

$$
a_j^{[l]} =
g\left(\mathbf{w}_j^{[l]}\cdot \mathbf{a}^{[l-1]} + b_j^{[l]}\right)
$$

第五步，用 TensorFlow 实现：

```python
model = Sequential([
    Dense(..., activation="sigmoid"),
    Dense(..., activation="sigmoid")
])

prediction = model.predict(X_new)
```

第六步，用 NumPy 手写理解底层：

```python
z = np.dot(w, a_in) + b
a = g(z)
```

第七步，用 matrix multiplication 向量化：

```python
Z = np.matmul(A_in, W) + b
A_out = g(Z)
```

到这里，你应该能把神经网络理解为：

> 多层 logistic / linear units 组成的函数。给定参数后，它通过 forward propagation 把输入特征逐层转换成更有用的表示，最后输出预测概率或预测值。

---

## 27. 最后一遍总括

第二课 Week 1 的核心不是训练神经网络，而是理解神经网络如何做 prediction / inference。

一个 neuron 接收输入，计算 `z=w·x+b`，再通过 activation function 得到 activation。多个 neurons 组成 layer，多个 layers 串联成 neural network。隐藏层 hidden layers 可以自动学习中间特征，这使得神经网络比单纯手工特征工程更灵活。

在实现上，TensorFlow 的 `Dense` 和 `Sequential` 可以快速搭建网络，`model.predict` 会自动执行 forward propagation。为了真正理解底层，本周又用 NumPy 手写 `my_dense` 和 `my_dense_v`：前者用循环逐个 unit 计算，后者用 `np.matmul` 一次性完成向量化计算。矩阵乘法和广播机制是神经网络高效运行的关键。

学完本周后，你应该能够读懂一个简单神经网络的结构、看懂每层参数和 activation 的含义、知道输入输出 shape 为什么重要，并能解释 TensorFlow 代码背后的数学计算。下一周会在这个基础上学习如何训练神经网络的参数。
