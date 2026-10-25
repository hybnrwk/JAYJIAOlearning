# 高维数据分析第二次作业：答案与编程学习包

本包对应上传的 `hw2-2026.pdf`，共 9 题、130 分。所有数值使用原始 CSV 数据计算，保留原始行顺序和给定的训练/测试划分。

## 建议先打开什么

1. `HW2_逐题讲解与代码教学.md`：从解题思路到公式、代码、结果解释，适合学习。
2. `HW2_答案整理.md`：压缩后的逐题答案，配上本包源代码及对应图表使用。
3. `hw2_solution.R`：完整、带中文注释的 R 源代码；按题号分段，可以逐段运行。
4. `figures/`：题目要求的全部拟合曲线及交叉验证曲线。
5. `results/`：各题结果表、模型选择路径、预测结果及软件版本。

讲解和答案使用相对路径引用图像。使用 Obsidian 时，建议将整个解压后的文件夹放进仓库，保留原文件夹关系。

## 怎样运行

题目第 8 题明确要求 R 包 `glmnet`，因此以 R 为主语言；第 9 题使用 `gglasso`。无需安装 Python。R 的安装下载地址为 https://cran.r-project.org/ ，可以配合 RStudio 使用。

第一次先运行：

```r
install.packages(c("glmnet", "gglasso"))
```

在 RStudio 打开 `hw2_solution.R`，选择菜单 **Session → Set Working Directory → To Source File Location**，把工作目录设为源代码所在文件夹，再运行：

```r
source("hw2_solution.R", encoding = "UTF-8")
```

也可以在这个文件夹内打开终端，执行：

```bash
Rscript hw2_solution.R
```

学习时不要一开始就整份执行。先选中“读取数据”和“第 1 题”，按 Ctrl+Enter，依次观察变量与输出。所有结果都会写入 `results/`，图像写入 `figures/`。

## 数据与复现约定

- `data/` 中保留上传的 6 个 CSV；本次 9 题实际使用 `salary.csv`、`wblake.csv`、`ais.csv`、`ais_split.csv`。
- `lakemary.csv` 和 `turkey.csv` 在这份 PDF 的 9 道题中没有用到。
- PDF 前言提到“第 10 题”，但实际正文只有第 1–9 题，合计正好 130 分；本包按实际题目作答。
- 第 2 题采用原始幂多项式；第 3 题结点分位数使用 R 默认的 type=7；平滑样条用 `smooth.spline(cv=FALSE)` 的 GCV。
- 第 4 题和第 9 题使用样本标准差（分母 n−1）；第 8 题直接遵循 `glmnet(standardize=TRUE)` 的内部约定。
- 第 8 题使用软件默认 lambda 网格，固定给定 foldid；软件版本与数值算法可能造成末位数值或网格差异。实际执行版本见 `results/sessionInfo.txt`。
- 第 9 题同时手工计算折外 MSE，核对 `pred.loss="L2"` 的实际含义。
- 所有作业 MSE 均为平均平方预测误差，不是残差标准误或 RSS/(n−q)。

## 学习目标

读完后，应当能自己完成“读数据 → 明确变量和编码 → 构建设计矩阵/特征 → 拟合 → 评价 → 解释”，并能修改自变量、参考类别、多项式阶数、样条结点、正则化方法及交叉验证配置。
