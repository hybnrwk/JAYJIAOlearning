# Week 3 讲解讲义：分类、逻辑回归、过拟合与正则化

> 这份讲义主要按照 `英文字幕/` 中 Week 3 的讲课逻辑展开。整体以中文讲解为主，同时保留关键术语的中英双语写法，方便你后续阅读英文字幕、英文文档、论文或 scikit-learn 文档。

---

## 1. Week 3 在解决什么问题

Week 1 和 Week 2 主要讲的是 **regression 回归**。

回归问题的输出是一个连续数值，例如：

- 房价是多少。
- 餐厅利润是多少。
- 温度是多少。
- 销量是多少。

模型输出可以是很多不同数字。

Week 3 转向另一个核心任务：**classification 分类**。

分类问题的输出不是任意连续数值，而是少数几个类别。例如：

- 邮件是不是垃圾邮件。
- 交易是不是欺诈交易。
- 肿瘤是不是恶性。
- 学生是否被录取。
- 芯片是否通过质量检测。

这类任务通常不是问“数值是多少”，而是问“属于哪一类”。

Week 3 的主线可以概括为：

```text
为什么线性回归不适合分类
    ↓
逻辑回归 logistic regression
    ↓
sigmoid / logistic function
    ↓
概率解释与 0.5 阈值
    ↓
decision boundary 决策边界
    ↓
logistic loss / cross-entropy loss
    ↓
用梯度下降训练逻辑回归
    ↓
过拟合 overfitting 与欠拟合 underfitting
    ↓
regularization 正则化
    ↓
regularized logistic regression
```

本周学完后，你会完成 Course 1 的核心闭环：线性回归用于预测数值，逻辑回归用于二分类，正则化用于控制过拟合。

---

## 2. 分类问题 Classification

**Classification 分类** 指的是预测一个有限类别。

本周重点是 **binary classification 二分类**，也就是输出只有两个可能类别。

例如：

| 任务 | 输入 `x` | 输出 `y` |
|---|---|---|
| 垃圾邮件检测 | 邮件内容 | spam / not spam |
| 欺诈交易检测 | 交易信息 | fraud / not fraud |
| 肿瘤诊断 | 肿瘤大小、年龄等 | malignant / benign |
| 录取预测 | 两门考试分数 | admitted / not admitted |
| 芯片质检 | 两项测试结果 | pass / fail |

二分类中，通常把输出记为：

$$
y \in \{0,1\}
$$

也可以说：

- `0`：negative class 负类。
- `1`：positive class 正类。

### 2.1 positive 和 negative 不代表好坏

课程中特别提醒：positive class 和 negative class 不是道德意义上的“好”和“坏”。

它们只是表示某个属性是否存在。

例如垃圾邮件分类：

- `y=1` 可以表示 spam 存在。
- `y=0` 可以表示 not spam。

肿瘤分类：

- `y=1` 可以表示 malignant 恶性。
- `y=0` 可以表示 benign 良性。

欺诈交易：

- `y=1` 可以表示 fraud 欺诈。
- `y=0` 可以表示 not fraud。

当然，你也可以反过来编码，但实际项目中要保持一致，并清楚说明 `1` 表示什么。

### 2.2 分类和回归的区别

判断一个任务是 classification 还是 regression，不要只看输出是不是数字，而要看这个数字的含义。

| 输出 | 含义 | 类型 |
|---|---|---|
| 0 / 1 | 是否恶性肿瘤 | 分类 |
| 0 / 1 | 是否垃圾邮件 | 分类 |
| 85.3 | 考试成绩 | 回归 |
| 120000 | 房价 | 回归 |
| 0.72 | 概率估计 | 分类模型中的概率输出 |

比如逻辑回归会输出 0 到 1 之间的数，但这个数表示正类概率，不是回归意义上的连续目标值。

---

## 3. 为什么线性回归不适合分类

一个自然想法是：既然 Week 1 和 Week 2 已经学了 linear regression，能不能直接用线性回归做分类？

例如肿瘤分类中：

- 横轴是 tumor size 肿瘤大小。
- 纵轴是标签 `y`，只能是 0 或 1。

可以拟合一条直线，然后设置阈值：

```text
如果 f(x) >= 0.5，预测 y=1
如果 f(x) < 0.5，预测 y=0
```

有时这看起来能工作。但问题是线性回归输出不受限制。

线性回归的输出可以：

- 小于 0。
- 大于 1。
- 被极端样本强烈拉动。

### 3.1 极端样本会改变分类边界

字幕中用肿瘤例子说明：一开始用线性回归拟合，阈值 0.5 对应的分界点看起来还可以。

但如果加入一个非常大的肿瘤样本，尽管这个新样本本身并不应该改变原本小肿瘤和大肿瘤之间的分界规律，线性回归的最佳拟合直线却会被它拉偏。

结果是 0.5 阈值对应的分界点向右移动，一些本来应该预测为恶性的样本被预测成良性。

这说明：

> Linear regression 线性回归不是为 classification 分类设计的。它输出的是连续数值，不适合直接表示类别概率。

因此需要新的模型：**logistic regression 逻辑回归**。

### 3.2 Logistic regression 名字容易误导

**Logistic regression 逻辑回归** 虽然名字里有 regression，但它主要用于 classification，尤其是 binary classification。

这是历史命名原因。学习时不要被名字误导。

---

## 4. 逻辑回归 Logistic Regression

逻辑回归的目标是：给定输入 `x`，输出样本属于正类 `y=1` 的概率。

也就是说：

$$
f_{\mathbf{w},b}(\mathbf{x})
=P(y=1 \mid \mathbf{x};\mathbf{w},b)
$$

直观解释：

如果模型输出：

$$
f_{\mathbf{w},b}(\mathbf{x})=0.7
$$

就表示模型认为：

```text
这个样本属于 y=1 的概率约为 70%
```

如果这是肿瘤诊断问题，`y=1` 表示 malignant 恶性，那么输出 0.7 可以理解为：模型估计该肿瘤有 70% 概率是恶性的。

由于二分类只有 0 和 1 两类：

$$
P(y=0 \mid \mathbf{x})=1-P(y=1 \mid \mathbf{x})
$$

如果 `P(y=1|x)=0.7`，那么 `P(y=0|x)=0.3`。

---

## 5. Sigmoid Function / Logistic Function

逻辑回归的关键是 **sigmoid function**，也叫 **logistic function**。

它的公式是：

$$
g(z)=\frac{1}{1+e^{-z}}
$$

其中 `e` 是自然常数，大约等于 2.718。

### 5.1 Sigmoid 的形状

sigmoid 函数有几个重要性质：

1. 输入 `z` 可以是任意实数。
2. 输出 `g(z)` 一定在 0 到 1 之间。
3. 当 `z` 很大且为正，`g(z)` 接近 1。
4. 当 `z` 很大且为负，`g(z)` 接近 0。
5. 当 `z=0`，`g(z)=0.5`。

因为：

$$
g(0)=\frac{1}{1+e^0}=\frac{1}{2}=0.5
$$

这正好适合二分类概率输出。

### 5.2 为什么 sigmoid 适合分类

线性模型：

$$
z=\mathbf{w}\cdot\mathbf{x}+b
$$

可以输出任意实数。

sigmoid 把这个任意实数压缩到 0 到 1：

$$
f_{\mathbf{w},b}(\mathbf{x})=g(z)
$$

也就是：

$$
f_{\mathbf{w},b}(\mathbf{x})
=
g(\mathbf{w}\cdot\mathbf{x}+b)
=
\frac{1}{1+e^{-(\mathbf{w}\cdot\mathbf{x}+b)}}
$$

这就是 logistic regression model。

### 5.3 代码实现 sigmoid

practice lab 和 optional lab 中的实现是：

```python
def sigmoid(z):
    g = 1 / (1 + np.exp(-z))
    return g
```

这个函数应该同时支持：

- 标量 scalar。
- 向量 vector。
- 矩阵 matrix。

因为 NumPy 的 `np.exp` 可以逐元素计算。

---

## 6. 从概率到类别：Threshold 阈值

逻辑回归输出的是概率，不是直接输出 0 或 1。

所以需要一个 threshold 阈值，把概率变成类别。

最常用阈值是 0.5：

```text
如果 f(x) >= 0.5，预测 y_hat = 1
如果 f(x) < 0.5，预测 y_hat = 0
```

用数学写：

$$
\hat{y}=
\begin{cases}
1, & f_{\mathbf{w},b}(\mathbf{x})\ge 0.5 \\
0, & f_{\mathbf{w},b}(\mathbf{x})<0.5
\end{cases}
$$

quiz 中猫图像分类的例子就是这个逻辑：如果模型输出 `g(z) >= 0.5`，就预测是 cat。

### 6.1 为什么 0.5 对应 `z=0`

因为：

$$
g(z)\ge 0.5
$$

等价于：

$$
z\ge 0
$$

而：

$$
z=\mathbf{w}\cdot\mathbf{x}+b
$$

所以：

```text
预测 y=1 ⇔ w·x + b >= 0
预测 y=0 ⇔ w·x + b < 0
```

这为 decision boundary 决策边界做准备。

---

## 7. Decision Boundary 决策边界

**Decision boundary 决策边界** 是模型从预测 0 切换到预测 1 的分界线或分界曲面。

当使用 0.5 阈值时，决策边界满足：

$$
f_{\mathbf{w},b}(\mathbf{x})=0.5
$$

等价于：

$$
\mathbf{w}\cdot\mathbf{x}+b=0
$$

### 7.1 两个特征时的线性边界

假设有两个特征：

$$
x_1,\quad x_2
$$

模型中的：

$$
z=w_1x_1+w_2x_2+b
$$

如果：

$$
w_1=1,\quad w_2=1,\quad b=-3
$$

那么：

$$
z=x_1+x_2-3
$$

决策边界是：

$$
x_1+x_2-3=0
$$

也就是：

$$
x_1+x_2=3
$$

这是一条直线。

边界一侧预测 `y=1`，另一侧预测 `y=0`。

### 7.2 多项式特征可以形成非线性边界

如果只使用原始特征 `x_1,x_2`，逻辑回归的决策边界是线性的。

但如果使用 polynomial features 多项式特征，决策边界可以是非线性的。

例如：

$$
z=w_1x_1^2+w_2x_2^2+b
$$

如果：

$$
w_1=1,\quad w_2=1,\quad b=-1
$$

那么：

$$
z=x_1^2+x_2^2-1
$$

决策边界是：

$$
x_1^2+x_2^2=1
$$

这是一条圆形边界。

所以 quiz 中“无论使用什么特征，logistic regression 的 decision boundary 都是线性的”是 False。

更准确的说法是：

> Logistic regression 对特征是线性组合；但如果特征本身是多项式或非线性变换，那么在原始输入空间里的 decision boundary 可以是非线性的。

---

## 8. Loss 和 Cost 的区别

Week 3 开始正式区分两个词：

- **Loss 损失**：单个训练样本上的误差度量。
- **Cost 代价**：整个训练集上 loss 的平均。

对第 `i` 个样本：

$$
L(f_{\mathbf{w},b}(\mathbf{x}^{(i)}),y^{(i)})
$$

是 loss。

整个训练集上的 cost 是：

$$
J(\mathbf{w},b)
=
\frac{1}{m}
\sum_{i=1}^{m}
L(f_{\mathbf{w},b}(\mathbf{x}^{(i)}),y^{(i)})
$$

quiz 中问单个训练样本用哪个词，答案是 loss。

---

## 9. 为什么逻辑回归不用平方误差

线性回归使用 squared error cost 平方误差代价函数：

$$
J(\mathbf{w},b)
=
\frac{1}{2m}
\sum_{i=1}^{m}
(f_{\mathbf{w},b}(\mathbf{x}^{(i)})-y^{(i)})^2
$$

这个函数配合线性回归时是 convex 凸函数，适合梯度下降。

但逻辑回归中：

$$
f_{\mathbf{w},b}(\mathbf{x})
=
sigmoid(\mathbf{w}\cdot\mathbf{x}+b)
$$

因为 sigmoid 是非线性的，如果直接套平方误差，代价函数可能变成 non-convex 非凸，有很多 local minima 局部最小值。

梯度下降可能卡在局部最小值，不能稳定找到全局最优。

所以逻辑回归要使用更合适的 loss function。

---

## 10. Logistic Loss / Cross-Entropy Loss

逻辑回归使用的 loss 是：

当 `y=1`：

$$
L(f,y)=-\log(f)
$$

当 `y=0`：

$$
L(f,y)=-\log(1-f)
$$

其中：

$$
f=f_{\mathbf{w},b}(\mathbf{x})
$$

这个 loss 也常叫：

- **logistic loss 逻辑损失**
- **cross-entropy loss 交叉熵损失**
- **binary cross-entropy 二元交叉熵**

### 10.1 当 `y=1` 时

真实标签是 1，模型应该输出接近 1。

如果：

$$
f\approx 1
$$

那么：

$$
-\log(f)\approx 0
$$

loss 很小。

如果模型输出很小，例如：

$$
f=0.1
$$

它其实是在说“我认为这个样本只有 10% 概率是正类”，但真实标签是 1，这就错得很严重。

此时：

$$
-\log(0.1)
$$

会比较大。

如果 `f` 接近 0，loss 会趋近无穷大。

### 10.2 当 `y=0` 时

真实标签是 0，模型应该输出接近 0。

如果：

$$
f\approx 0
$$

那么：

$$
-\log(1-f)\approx 0
$$

loss 很小。

如果模型输出接近 1，说明它非常自信地预测正类，但真实是负类，loss 会非常大。

### 10.3 统一写法

因为二分类中 `y` 只能是 0 或 1，可以把上面两个情况合并成一个公式：

$$
L(f,y)
=
-y\log(f)-(1-y)\log(1-f)
$$

验证一下：

如果 `y=1`：

$$
L(f,1)=-\log(f)
$$

如果 `y=0`：

$$
L(f,0)=-\log(1-f)
$$

注意：当 `y=0` 时是 `-log(1-f)`，负号不能丢。

---

## 11. Logistic Regression Cost Function

整个训练集上的 cost 是所有 loss 的平均：

$$
J(\mathbf{w},b)
=
\frac{1}{m}
\sum_{i=1}^{m}
\left[
-y^{(i)}\log(f_{\mathbf{w},b}(\mathbf{x}^{(i)}))
-(1-y^{(i)})\log(1-f_{\mathbf{w},b}(\mathbf{x}^{(i)}))
\right]
$$

这个 cost function 有重要性质：

- 适合二分类。
- 对 logistic regression 是 convex 的。
- 可以用 gradient descent 可靠优化。
- 可以从 maximum likelihood estimation 最大似然估计推导出来。

课程不要求你掌握最大似然细节，但如果以后读统计学习或机器学习论文，你会经常看到它。

### 11.1 代码实现 logistic cost

optional lab 中的实现：

```python
def compute_cost_logistic(X, y, w, b):
    m = X.shape[0]
    cost = 0.0
    for i in range(m):
        z_i = np.dot(X[i], w) + b
        f_wb_i = sigmoid(z_i)
        cost += -y[i] * np.log(f_wb_i) - (1-y[i]) * np.log(1-f_wb_i)
    cost = cost / m
    return cost
```

practice lab 中也可以用向量化写法：

```python
f_wb = sigmoid(np.dot(X, w) + b)
total_cost = (1/m) * np.sum(-y*np.log(f_wb) - (1-y)*np.log(1-f_wb))
```

两种写法算的是同一个公式。

---

## 12. Logistic Regression 的梯度下降

训练逻辑回归，就是寻找 `w,b`，使：

$$
J(\mathbf{w},b)
$$

尽可能小。

仍然使用 gradient descent 梯度下降：

$$
w_j := w_j - \alpha \frac{\partial J}{\partial w_j}
$$

$$
b := b - \alpha \frac{\partial J}{\partial b}
$$

### 12.1 梯度公式

逻辑回归的梯度公式是：

$$
\frac{\partial J}{\partial w_j}
=
\frac{1}{m}
\sum_{i=1}^{m}
(f_{\mathbf{w},b}(\mathbf{x}^{(i)})-y^{(i)})x_j^{(i)}
$$

$$
\frac{\partial J}{\partial b}
=
\frac{1}{m}
\sum_{i=1}^{m}
(f_{\mathbf{w},b}(\mathbf{x}^{(i)})-y^{(i)})
$$

这看起来和线性回归很像。

但它们不是同一个算法，因为 `f` 的定义不同：

线性回归：

$$
f_{\mathbf{w},b}(\mathbf{x})=\mathbf{w}\cdot\mathbf{x}+b
$$

逻辑回归：

$$
f_{\mathbf{w},b}(\mathbf{x})=sigmoid(\mathbf{w}\cdot\mathbf{x}+b)
$$

quiz 中也强调：更新形式看起来像线性回归，但 `f` 的定义不同。

### 12.2 代码实现 logistic gradient

optional lab 中：

```python
def compute_gradient_logistic(X, y, w, b):
    m, n = X.shape
    dj_dw = np.zeros((n,))
    dj_db = 0.

    for i in range(m):
        f_wb_i = sigmoid(np.dot(X[i], w) + b)
        err_i = f_wb_i - y[i]
        for j in range(n):
            dj_dw[j] = dj_dw[j] + err_i * X[i, j]
        dj_db = dj_db + err_i

    dj_dw = dj_dw / m
    dj_db = dj_db / m
    return dj_db, dj_dw
```

向量化版本：

```python
f_wb = sigmoid(np.dot(X, w) + b)
err = f_wb - y
dj_dw = (1/m) * np.dot(X.T, err)
dj_db = (1/m) * np.sum(err)
```

### 12.3 预测函数 predict

训练完后，模型输出概率。要变成类别：

```python
def predict(X, w, b):
    m, n = X.shape
    p = np.zeros(m)
    for i in range(m):
        z_wb = np.dot(X[i], w) + b
        f_wb = sigmoid(z_wb)
        p[i] = 1 if f_wb >= 0.5 else 0
    return p
```

训练集准确率可以用：

```python
np.mean(p == y_train) * 100
```

---

## 13. scikit-learn 中的 Logistic Regression

optional lab 也展示了用 scikit-learn 训练逻辑回归：

```python
from sklearn.linear_model import LogisticRegression

lr_model = LogisticRegression()
lr_model.fit(X, y)
y_pred = lr_model.predict(X)
```

这说明真实工作中不一定每次都手写梯度下降。

但课程仍然要求你理解底层公式，因为：

- 你需要知道模型在优化什么。
- 你需要判断过拟合、欠拟合。
- 你需要理解正则化参数。
- 后面神经网络仍然依赖 cost function 和 gradient descent。

---

## 14. 过拟合 Overfitting 与欠拟合 Underfitting

学完 linear regression 和 logistic regression 后，一个更实际的问题出现了：模型可能在训练集上表现很好，但在新样本上表现很差。

这就是 **generalization 泛化** 问题。

泛化好，表示模型能在没见过的新样本上也预测得好。

泛化不好，通常可能有两类问题：

- **underfitting 欠拟合 / high bias 高偏差**
- **overfitting 过拟合 / high variance 高方差**

### 14.1 Underfitting / High Bias

欠拟合指模型太简单，连训练数据的基本模式都抓不住。

房价例子中，如果数据明显有弯曲趋势，但你只用一条直线拟合，模型可能就 underfit。

表现：

- 训练集拟合差。
- 新样本预测通常也差。
- 模型太简单，表达能力不够。

在机器学习技术语境中，这叫 high bias 高偏差。

注意：这里的 bias 是技术术语，不是社会公平语境中的偏见。两者都重要，但含义不同。

### 14.2 Just Right

如果使用二次特征：

$$
x,\quad x^2
$$

模型可能能很好捕捉房价随面积增长后逐渐变平的趋势。

它不一定完美穿过每个训练点，但整体趋势合理，也可能泛化得好。

这种状态可以叫 just right。

### 14.3 Overfitting / High Variance

过拟合指模型太复杂，过度贴合训练集细节甚至噪声。

例如使用四次多项式：

$$
x,\quad x^2,\quad x^3,\quad x^4
$$

模型可能穿过所有训练点，使训练误差为 0，但曲线非常弯曲，不符合真实规律。

表现：

- 训练集误差很小。
- 新样本表现差。
- 模型对训练数据的小变化非常敏感。
- 决策边界或曲线过于复杂。

这也叫 high variance 高方差。

### 14.4 分类中的过拟合

逻辑回归也会过拟合。

如果只用 `x_1,x_2`，decision boundary 是直线，可能 underfit。

如果加入合理的二次特征，边界可能是椭圆或曲线，可能 just right。

如果加入很多高阶多项式特征，模型可能形成非常扭曲的边界，几乎把每个训练点都分对，但泛化能力差。

quiz 中那个弯弯绕绕包住训练点的边界就是 high variance / overfit。

---

## 15. 如何处理 Overfitting

字幕给出三种常见方法。

### 15.1 Collect more training data 收集更多训练数据

更多训练数据通常能帮助模型看清真正规律，而不是被少数样本牵着走。

如果能收集更多数据，这是对抗过拟合的强工具。

但现实中不一定总能做到，因为数据可能昂贵、稀缺或难以标注。

### 15.2 Feature selection 特征选择

如果模型有太多特征，而训练样本不够多，容易过拟合。

可以只保留更相关的特征。例如房价预测里，从 100 个特征中挑出：

- 面积。
- 卧室数。
- 房龄。

这样模型可能不再那么复杂。

缺点是：丢弃特征也可能丢掉有用信息。

### 15.3 Regularization 正则化

正则化不是直接删除特征，而是让模型不要过度依赖某些特征。

它通过惩罚过大的参数 `w_j`，让模型倾向于选择较小的参数。

直观理解：

> 大参数容易让模型曲线或决策边界非常扭曲；正则化让参数变小，从而让模型更平滑、更简单、更不容易过拟合。

课程强调：通常只正则化 `w_1,...,w_n`，不正则化 `b`。

---

## 16. Regularized Cost Function

正则化的做法是在原来的 cost function 后面加一个 regularization term 正则化项。

### 16.1 Regularized Linear Regression

线性回归原来的 cost 是：

$$
\frac{1}{2m}
\sum_{i=1}^{m}
(f_{\mathbf{w},b}(\mathbf{x}^{(i)})-y^{(i)})^2
$$

加入正则化后：

$$
J(\mathbf{w},b)
=
\frac{1}{2m}
\sum_{i=1}^{m}
(f_{\mathbf{w},b}(\mathbf{x}^{(i)})-y^{(i)})^2
+
\frac{\lambda}{2m}
\sum_{j=1}^{n}w_j^2
$$

其中：

- `\lambda` 是 regularization parameter 正则化参数。
- `\sum w_j^2` 惩罚较大的参数。
- 不包含 `b^2`，因为通常不正则化 `b`。

### 16.2 Regularized Logistic Regression

逻辑回归原来的 cost 是：

$$
\frac{1}{m}
\sum_{i=1}^{m}
\left[
-y^{(i)}\log(f^{(i)})
-(1-y^{(i)})\log(1-f^{(i)})
\right]
$$

加入正则化后：

$$
J(\mathbf{w},b)
=
\frac{1}{m}
\sum_{i=1}^{m}
\left[
-y^{(i)}\log(f_{\mathbf{w},b}(\mathbf{x}^{(i)}))
-(1-y^{(i)})\log(1-f_{\mathbf{w},b}(\mathbf{x}^{(i)}))
\right]
+
\frac{\lambda}{2m}
\sum_{j=1}^{n}w_j^2
$$

可以看到，线性回归和逻辑回归的第一部分不同，但正则化项相同。

### 16.3 Lambda 的作用

`\lambda` 控制正则化强度。

如果：

$$
\lambda=0
$$

就没有正则化，模型可能 overfit。

如果 `\lambda` 非常大，模型会强烈压缩 `w`，使很多参数接近 0，模型可能太简单，导致 underfit。

所以需要选择合适的 `\lambda`。

---

## 17. Regularized Gradient Descent

加入正则化后，梯度下降整体形式不变：

$$
w_j := w_j - \alpha \frac{\partial J}{\partial w_j}
$$

$$
b := b - \alpha \frac{\partial J}{\partial b}
$$

变化在于 `w_j` 的梯度多了正则化项。

### 17.1 Regularized Linear Regression Gradient

线性回归中：

$$
\frac{\partial J}{\partial w_j}
=
\frac{1}{m}
\sum_{i=1}^{m}
(f_{\mathbf{w},b}(\mathbf{x}^{(i)})-y^{(i)})x_j^{(i)}
+
\frac{\lambda}{m}w_j
$$

$$
\frac{\partial J}{\partial b}
=
\frac{1}{m}
\sum_{i=1}^{m}
(f_{\mathbf{w},b}(\mathbf{x}^{(i)})-y^{(i)})
$$

`b` 的梯度不加正则化项。

### 17.2 Regularized Logistic Regression Gradient

逻辑回归中公式几乎一样：

$$
\frac{\partial J}{\partial w_j}
=
\frac{1}{m}
\sum_{i=1}^{m}
(f_{\mathbf{w},b}(\mathbf{x}^{(i)})-y^{(i)})x_j^{(i)}
+
\frac{\lambda}{m}w_j
$$

$$
\frac{\partial J}{\partial b}
=
\frac{1}{m}
\sum_{i=1}^{m}
(f_{\mathbf{w},b}(\mathbf{x}^{(i)})-y^{(i)})
$$

区别仍然是 `f`：

- 线性回归中 `f=w·x+b`。
- 逻辑回归中 `f=sigmoid(w·x+b)`。

### 17.3 正则化为什么会 shrink weights

把更新公式展开，可以看到：

$$
w_j :=
w_j
-
\alpha
\left(
原来的梯度
+
\frac{\lambda}{m}w_j
\right)
$$

等价于：

$$
w_j :=
w_j\left(1-\alpha\frac{\lambda}{m}\right)
-
\alpha(原来的梯度)
$$

因为：

$$
1-\alpha\frac{\lambda}{m}
$$

通常是略小于 1 的数，所以每次更新都会让 `w_j` 有一点点缩小趋势。

这就是 regularization 会 shrink weights 的直觉。

### 17.4 代码实现 regularized logistic cost

practice lab 中的结构：

```python
def compute_cost_reg(X, y, w, b, lambda_=1):
    m, n = X.shape
    cost_without_reg = compute_cost(X, y, w, b)

    reg_cost = 0.
    for j in range(n):
        reg_cost += w[j]**2

    total_cost = cost_without_reg + (lambda_/(2*m)) * reg_cost
    return total_cost
```

### 17.5 代码实现 regularized logistic gradient

```python
def compute_gradient_reg(X, y, w, b, lambda_=1):
    m, n = X.shape

    dj_db, dj_dw = compute_gradient(X, y, w, b)

    for j in range(n):
        dj_dw[j] = dj_dw[j] + (lambda_ / m) * w[j]

    return dj_db, dj_dw
```

注意：只改 `dj_dw`，不改 `dj_db`。

---

## 18. Practice Lab：Logistic Regression

Week 3 的 practice lab 有两个主要任务。

### 18.1 任务一：大学录取预测

问题：根据学生两门考试成绩，预测是否被大学录取。

数据文件：

```text
ex2data1.txt
```

每行：

```text
exam1 score, exam2 score, admitted label
```

标签：

- `1`：admitted。
- `0`：not admitted。

你需要实现：

1. `sigmoid`
2. `compute_cost`
3. `compute_gradient`
4. `predict`

模型是标准 logistic regression：

$$
f_{\mathbf{w},b}(\mathbf{x})=sigmoid(\mathbf{w}\cdot\mathbf{x}+b)
$$

训练完成后，用 0.5 阈值预测类别，并计算训练集准确率。

### 18.2 任务二：芯片 QA 质量检测

问题：根据芯片两项测试结果，预测芯片是否通过质量检测。

数据文件：

```text
ex2data2.txt
```

每行：

```text
test1 result, test2 result, pass/fail label
```

这组数据不能用一条直线很好分开，所以需要 feature mapping 特征映射。

### 18.3 Feature Mapping

`utils.py` 中的 `map_feature` 会把两个原始特征扩展为最高 6 次的多项式特征。

例如原始特征：

$$
x_1,\quad x_2
$$

会生成类似：

$$
x_1,\ x_2,\ x_1^2,\ x_1x_2,\ x_2^2,\ \ldots
$$

一直到 6 次项。

代码结构：

```python
def map_feature(X1, X2):
    degree = 6
    out = []
    for i in range(1, degree+1):
        for j in range(i + 1):
            out.append((X1**(i-j) * (X2**j)))
    return np.stack(out, axis=1)
```

特征映射能让 logistic regression 学到非线性 decision boundary。

但它也会增加过拟合风险，所以 practice lab 接着要求实现 regularized logistic regression。

### 18.4 Regularized Logistic Regression in Practice

你需要实现：

- `compute_cost_reg`
- `compute_gradient_reg`

训练设置中会使用：

```python
lambda_ = 0.01
iterations = 10000
alpha = 0.01
```

训练完后画出非线性 decision boundary，并计算训练准确率。

这个 lab 把 Week 3 的全部核心串起来了：

```text
sigmoid
  -> logistic cost
  -> logistic gradient
  -> decision boundary
  -> feature mapping
  -> regularization
  -> nonlinear classification
```

---

## 19. 中英关键词表

| English | 中文 | 解释 |
|---|---|---|
| classification | 分类 | 预测有限类别 |
| binary classification | 二分类 | 输出只有 0/1 两类 |
| positive class | 正类 | 通常编码为 1 |
| negative class | 负类 | 通常编码为 0 |
| logistic regression | 逻辑回归 | 用于分类的模型，名字里有 regression 但不是回归任务 |
| sigmoid function | sigmoid 函数 | 把任意实数映射到 0 到 1 |
| logistic function | logistic 函数 | sigmoid function 的另一个名字 |
| probability | 概率 | 逻辑回归输出可解释为 `P(y=1|x)` |
| threshold | 阈值 | 把概率转换成类别的分界值，常用 0.5 |
| decision boundary | 决策边界 | 从预测 0 切换到预测 1 的边界 |
| loss | 损失 | 单个样本上的误差 |
| cost | 代价 | 整个训练集上的平均损失 |
| logistic loss | 逻辑损失 | 逻辑回归使用的损失函数 |
| cross-entropy loss | 交叉熵损失 | logistic loss 的常见名称 |
| gradient descent | 梯度下降 | 最小化 cost 的迭代优化方法 |
| overfitting | 过拟合 | 训练集拟合太好但泛化差 |
| underfitting | 欠拟合 | 模型太简单，训练集也拟合不好 |
| high bias | 高偏差 | 欠拟合的技术说法 |
| high variance | 高方差 | 过拟合的技术说法 |
| generalization | 泛化 | 对没见过的新样本也表现好 |
| feature selection | 特征选择 | 只使用更相关的一部分特征 |
| feature mapping | 特征映射 | 把原始特征变成更高维或多项式特征 |
| polynomial features | 多项式特征 | 如 `x^2`, `x_1x_2`, `x^3` |
| regularization | 正则化 | 惩罚大参数，减少过拟合 |
| regularization parameter | 正则化参数 | `lambda`，控制正则化强度 |
| lambda | λ | 正则化强度参数 |
| maximum likelihood estimation | 最大似然估计 | logistic cost 的统计学来源 |

---

## 20. Quiz 考点整理

### 20.1 Classification

如果任务是判断肿瘤是否恶性，这是 classification，因为输出是两个类别。

如果任务是预测药物剂量多少毫克，这是 regression，因为输出是连续数值。

### 20.2 Sigmoid

$$
g(z)=\frac{1}{1+e^{-z}}
$$

当 `z` 是很大的正数时，`g(z)` 接近 1。

当 `z=0` 时，`g(z)=0.5`。

当 `z` 是很大的负数时，`g(z)` 接近 0。

### 20.3 Threshold

如果用 0.5 作为阈值：

```text
g(z) >= 0.5 -> predict 1
g(z) < 0.5 -> predict 0
```

### 20.4 Decision boundary

如果只用原始线性特征，decision boundary 是线性的。

如果加入 polynomial features，decision boundary 可以是非线性的。

### 20.5 Loss vs Cost

单个样本上叫 loss。

整个训练集平均叫 cost。

### 20.6 Logistic loss

当 `y=1`：

$$
L=-\log(f)
$$

当 `y=0`：

$$
L=-\log(1-f)
$$

统一写法：

$$
L=-y\log(f)-(1-y)\log(1-f)
$$

### 20.7 Logistic gradient descent

逻辑回归的更新形式看起来和线性回归相似，但 `f` 不同。

逻辑回归的：

$$
f=sigmoid(w\cdot x+b)
$$

### 20.8 Addressing overfitting

处理 overfitting 的方法包括：

- collect more training data。
- select a subset of relevant features。
- apply regularization。

不要随机删除训练样本。

### 20.9 Lambda

增大 `lambda` 会让参数 `w_1,...,w_n` 变小。

`lambda=0` 没有正则化，可能 overfit。

`lambda` 太大可能 underfit。

---

## 21. Week 3 的逻辑闭环

现在把本周内容完整串起来。

第一步，分类任务输出类别，而不是连续数值。二分类中：

$$
y\in\{0,1\}
$$

第二步，线性回归不适合分类，因为输出不限制在 0 到 1，且容易受极端样本影响。

第三步，引入逻辑回归：

$$
f_{\mathbf{w},b}(\mathbf{x})
=
sigmoid(\mathbf{w}\cdot\mathbf{x}+b)
$$

第四步，把输出解释为正类概率：

$$
f_{\mathbf{w},b}(\mathbf{x})=P(y=1|\mathbf{x};\mathbf{w},b)
$$

第五步，用 0.5 阈值把概率变成类别：

$$
\mathbf{w}\cdot\mathbf{x}+b\ge 0 \Rightarrow \hat{y}=1
$$

第六步，决策边界是：

$$
\mathbf{w}\cdot\mathbf{x}+b=0
$$

如果使用多项式特征，边界可以变成曲线。

第七步，逻辑回归不用平方误差，而用 logistic loss：

$$
L=-y\log(f)-(1-y)\log(1-f)
$$

第八步，整个训练集上的 cost 是：

$$
J(\mathbf{w},b)=\frac{1}{m}\sum_{i=1}^{m}L(f^{(i)},y^{(i)})
$$

第九步，用梯度下降训练：

$$
w_j := w_j-\alpha
\frac{1}{m}\sum_{i=1}^{m}
(f^{(i)}-y^{(i)})x_j^{(i)}
$$

$$
b := b-\alpha
\frac{1}{m}\sum_{i=1}^{m}
(f^{(i)}-y^{(i)})
$$

第十步，复杂模型可能过拟合。处理过拟合的关键方法是 regularization：

$$
J_{reg}=J+\frac{\lambda}{2m}\sum_{j=1}^{n}w_j^2
$$

它让模型倾向于较小的 `w`，从而减少过拟合。

---

## 22. 最后一遍总括

Week 3 的核心是从 regression 进入 classification。

逻辑回归用线性函数：

$$
z=\mathbf{w}\cdot\mathbf{x}+b
$$

再经过 sigmoid：

$$
g(z)=\frac{1}{1+e^{-z}}
$$

得到 0 到 1 之间的概率输出。通过 0.5 阈值，模型可以做二分类预测。训练时，逻辑回归不用平方误差，而使用 logistic loss / cross-entropy loss，使 cost function 更适合分类并保持良好的优化性质。

本周后半部分进一步说明：模型太简单会 underfit / high bias，模型太复杂会 overfit / high variance。正则化 regularization 通过惩罚较大的 `w`，让模型不至于过度扭曲训练数据，从而更可能 generalize well 泛化到新样本。

到这里，Course 1 的主要工具已经形成：linear regression 解决数值预测，logistic regression 解决二分类，regularization 帮助控制过拟合，gradient descent 是训练这些模型的统一优化方法。
