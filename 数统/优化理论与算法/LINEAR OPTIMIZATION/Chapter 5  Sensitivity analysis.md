下面我按照课本的结构，把 **Chapter 5：敏感性分析（Sensitivity analysis）** 再往下掰开讲一层。  
这次我会更强调三件事：

1. **每个结论是怎么从“可行性 + 最优性”这两个条件推出来的**；
    
2. **这些公式在单纯形表（simplex tableau）里到底怎么看**；
    
3. **这些结论背后的几何直觉（geometric intuition）和经济解释（economic interpretation）是什么**。
    

我仍然坚持用中文为主，并在关键术语后面加英文。公式都尽量写成 Obsidian 能直接渲染的行内格式。

---

# 一、这一章的主问题到底是什么

前面几章你学的是：

- 一个线性规划（linear program）怎么求最优解；
    
- 单纯形法（simplex method）如何换基（pivot）；
    
- 对偶（duality）怎样解释最优值和约束。
    

但在实际问题里，数据通常不是死的。比如：

- 资源量（requirement vector）$b$可能会变；
    
- 单位成本（cost vector）$c$可能会变；
    
- 技术系数（coefficient matrix）$A$可能会变；
    
- 还可能新增变量（new variable）或新增约束（new constraint）。
    

所以这一章问的是：

> 当问题数据发生变化时，原来的最优基（optimal basis）、最优解（optimal solution）、最优值（optimal cost）会怎样变化？

这就是**敏感性分析（sensitivity analysis）**。

---

# 二、全章的标准模型与基本符号

课本一直基于标准形（standard form）：

原问题（primal problem）是  
$\min c'x$，s.t.$Ax=b,\ x\geq 0$。

对偶问题（dual problem）是  
$\max p'b$，s.t.$p'A\leq c'$。

并且全章都假设：

- $A$是一个$m\times n$矩阵；
    
- $A$的各行线性无关（rows linearly independent），即$\operatorname{rank}(A)=m$。
    

这个假设很重要，因为它保证：

- 可以从$A$的列中选出$m$列构成一个可逆的基矩阵（basis matrix）$B$；
    
- 对偶空间维数就是$m$；
    
- 很多关于极点（extreme point）、基（basis）的讨论都能顺利成立。
    

---

# 三、全章的总钥匙：最优基的两个条件

假设我们已经有了原问题的一个最优基（optimal basis）$B$，对应的基变量向量是$x_B$，对应最优解是$x^*$。

那么这个基之所以最优，本质上依赖于两个条件：

## 1. 可行性（feasibility）

$B^{-1}b \ge 0$

这表示当前基变量都非负，因此当前基本解（basic solution）是**基本可行解（basic feasible solution, BFS）**。

---

## 2. 最优性（optimality）

$c' - c_B'B^{-1}A \ge 0'$

这里$c_B$是基变量对应的成本向量。

把$p'=c_B'B^{-1}$记作与当前基对应的对偶向量（dual vector），那么这个条件等价于：

$c' - p'A \ge 0'$

也就是所有**检验数 / 简化成本（reduced costs）**都非负。

对于最小化问题（minimization problem）来说：

- reduced cost 非负$\Rightarrow$没有哪个非基变量值得进基去继续降低目标值；
    
- 所以当前 BFS 就是最优的。
    

---

## 3. 这两个条件为何是全章的“统一模板”

敏感性分析的核心不是重新从零算，而是：

> 数据变了以后，先看原来的基$B$是否还同时满足  
> 可行性$B^{-1}b\ge 0$和最优性$c' - c_B'B^{-1}A\ge 0'$。

如果这两个条件在新问题下仍成立，那么：

- 老基不变；
    
- 最优解结构不变；
    
- 许多量可以直接算出来。
    

如果某个条件坏了，就看坏的是哪一个：

- **原始可行性（primal feasibility）坏了，但对偶可行性（dual feasibility）还在**：用**对偶单纯形法（dual simplex method）**；
    
- **对偶可行性坏了，但原始可行性还在**：用**原始单纯形法（primal simplex method）**。
    

这一点你一定要建立成“反射”。

---

# 四、5.1 局部敏感性分析（Local sensitivity analysis）

这一节研究的是“小范围变化（local change）”下，原基是否还能保持最优。

它的主线可以概括成一句话：

> 改了数据后，不急着换基，先检查老基。

---

# 五、新增一个变量（A new variable is added）

现在原问题里增加一个新变量$x_{n+1}$，它对应一列新列向量$A_{n+1}$，目标系数是$c_{n+1}$。

新问题变成  
$\min c'x + c_{n+1}x_{n+1}$，s.t.$Ax + A_{n+1}x_{n+1}=b,\ x\ge 0,\ x_{n+1}\ge 0$。

---

## 5.1 为什么原解自动仍然可行

因为你可以先取$x_{n+1}=0$。

这时$(x^*,0)$仍满足  
$Ax=b$，而且非负，所以它是新问题中的一个基本可行解。

因此，新增变量时：

- **可行性不需要重新检查**
    
- 只要检查**最优性**
    

这和后面“新增约束”形成鲜明对比。

---

## 5.2 只需检查新变量的检验数（reduced cost）

原基$B$在新问题中仍最优，当且仅当新变量的 reduced cost 非负：

$\bar c_{n+1} = c_{n+1} - c_B'B^{-1}A_{n+1} \ge 0$

为什么只看这一个？

因为原来所有旧变量的 reduced costs 已经是非负的，它们没变；  
新增加的只有这个变量，所以只新增了一条最优性不等式要检查。

---

## 5.3 这个公式的直观意义

$\bar c_{n+1}$描述的是：

> 在当前基不变的局部方向上，让$x_{n+1}$从 0 开始增加时，目标值会先以什么速度变化。

对最小化问题：

- 若$\bar c_{n+1} > 0$，增大它只会让目标变差；
    
- 若$\bar c_{n+1} = 0$，增大它局部上不改变目标；
    
- 若$\bar c_{n+1} < 0$，增大它会让目标下降，因此它“值得进基（eligible to enter the basis）”。
    

---

## 5.4 若$\bar c_{n+1}<0$，为什么用原始单纯形法（primal simplex）

因为这时当前解$(x^*,0)$：

- 仍然是原始可行（primal feasible）的；
    
- 但不再满足最优性（有负检验数）。
    

这正是原始单纯形法的起点：

> 从一个可行但不最优的 BFS 出发，选一个负 reduced cost 变量进基。

---

## 5.5 Example 5.1 详细解释

原问题是  
$\min -5x_1 - x_2 + 12x_3$
s.t.$3x_1 + 2x_2 + x_3 = 10$，$5x_1 + 3x_2 + x_4 = 16$，$x\ge 0$。

课本给出的最优解是  
$x=(2,2,0,0)$。

也就是说：

- 基变量（basic variables）是$x_1,x_2$；
    
- 非基变量（nonbasic variables）是$x_3,x_4$；
    
- 所以基矩阵是由$A_1,A_2$组成的$B$。
    

课本给出$B^{-1}$可以从最终单纯形表中读出来。这里得到  
$B^{-1} = \begin{bmatrix} -3 & 2 \ 5 & -3 \end{bmatrix}$。

现在加入新变量$x_5$，其列向量是  
$A_5 = \begin{bmatrix}1\1\end{bmatrix}$，

成本系数是$c_5=-1$。

于是新变量的 reduced cost 为  
$\bar c_5 = c_5 - c_B'B^{-1}A_5$。

因为$c_B = (-5,-1)'$，所以  
$c_B'B^{-1} = (-5,-1)\begin{bmatrix}-3&2\5&-3\end{bmatrix} = (10,-7)$。

于是  
$c_B'B^{-1}A_5 = (10,-7)\begin{bmatrix}1\1\end{bmatrix}=3$，

因此  
$\bar c_5 = -1 - 3 = -4 < 0$。

所以老基不再最优。

---

## 5.6 为什么$x_2$离基（leave the basis）

课本算出  
$B^{-1}A_5 = (-1,2)'$。

如果让$x_5=t$进入，那么基变量变成  
$x_B(t) = B^{-1}(b - A_5 t) = x_B - B^{-1}A_5, t$。

因为原来$x_B=(2,2)'$，所以  
$x_B(t) = (2,2)' - (-1,2)'t = (2+t,\ 2-2t)'$。

要保持非负，需要

- $2+t\ge 0$，总成立；
    
- $2-2t\ge 0$，即$t\le 1$。
    

因此$t$最多取到 1，此时第二个基变量先变成 0，也就是对应的$x_2$离基。

这就是原始单纯形中的**最小比值检验（minimum ratio test）**本质。

最后得到新最优解  
$x=(3,0,0,0,1)$。

---

# 六、新增一个不等式约束（A new inequality constraint is added）

现在往原问题中再加一个约束  
$a_{m+1}'x \ge b_{m+1}$。

---

## 6.1 如果原最优解已经满足新约束，会怎样

如果原解$x^*$满足  
$a_{m+1}'x^* \ge b_{m+1}$，

那么$x^*$仍然属于新问题的可行域。

而新问题只是把可行域缩小了，没有改变目标函数，因此：

- $x^*$在原来更大的集合中已经最优；
    
- 它又属于新的更小集合；
    
- 所以它在新集合中仍然最优。
    

这一步非常简单，但要会自己说出来。

---

## 6.2 如果原最优解违反了新约束

若  
$a_{m+1}'x^* < b_{m+1}$，

则原解在新问题中不可行。  
此时把新约束改写成标准形：

$a_{m+1}'x - x_{n+1} = b_{m+1}, \quad x_{n+1}\ge 0$

这里$x_{n+1}$是一个新的松弛变量（slack/surplus variable）。

注意因为原约束是“$\ge$”，所以这里是减去$x_{n+1}$，而不是加上。

---

## 6.3 新基怎么构造

课本取：

- 原来的基变量继续作为基变量；
    
- 再把新变量$x_{n+1}$加进基。
    

于是新基矩阵为  
$\bar B = \begin{bmatrix} B & 0 \ a' & -1 \end{bmatrix}$，

其中$a'$是新约束中对应原基变量的系数行。

为什么这是个合法基？

因为  
$\det(\bar B) = -\det(B) \neq 0$。

所以$\bar B$可逆，的确是一个 basis matrix。

---

## 6.4 新基对应的基本解是什么

对应的基本解是  
$(x^*,\ a_{m+1}'x^* - b_{m+1})$。

但因为我们假设$a_{m+1}'x^* < b_{m+1}$，所以  
$a_{m+1}'x^* - b_{m+1} < 0$。

也就是说，这个新基本解是**原始不可行（primal infeasible）**的。

---

## 6.5 为什么这个基却是对偶可行（dual feasible）的

课本给出  
$\bar B^{-1} = \begin{bmatrix} B^{-1} & 0 \ a'B^{-1} & -1 \end{bmatrix}$。

你可以直接乘一下验证：  
$\bar B^{-1}\bar B = I$。

然后计算新问题的 reduced costs：

$[c' \quad 0] - [c_B' \quad 0]\bar B^{-1}\begin{bmatrix}A&0\a_{m+1}'&-1\end{bmatrix}$

整理之后恰好得到  
$[,c' - c_B'B^{-1}A \quad 0,]$。

这非常关键，意思是：

- 原来的 reduced costs 一点没坏；
    
- 新松弛变量对应的 reduced cost 是 0。
    

因此新的基满足：

- 对偶可行（reduced costs 非负）；
    
- 但原始不可行（有负基变量）。
    

这正好是**对偶单纯形法（dual simplex）**的天然起点。

---

## 6.6 为什么新增约束通常自然导向对偶单纯形

你可以把这件事理解为：

- 原来的最优解“价格体系（pricing structure）”还没坏；
    
- 但因为规则更严格了，原来的方案本身不再满足约束。
    

也就是说，优化结构没坏，可行结构坏了。

这就是对偶单纯形擅长修复的情形。

---

## 6.7 Example 5.2 详细解释

在 Example 5.1 的问题基础上，增加约束  
$x_1 + x_2 \ge 5$。

原最优解是$(2,2,0,0)$，代入得到  
$2+2=4 < 5$，

所以原解违反新约束。

改写成标准形：

$x_1 + x_2 - x_5 = 5,\quad x_5\ge 0$

这里新变量是$x_5$。

原基变量仍然是$x_1,x_2$，所以$a=(1,1)$。

课本利用  
$a'B^{-1}A - a_{m+1}'$

来构造新表的最后一行。因为  
$B^{-1}A$是原最终表里已经给出的，所以不必重算全部内容。

计算得到  
$a'B^{-1}A - a_{m+1}' = [0,0,2,-1]$。

同时新基变量$x_5$的值为  
$a_{m+1}'x^* - b_{m+1} = 4 - 5 = -1$。

所以新表最后一行右端项是$-1$，这显示出当前基是原始不可行的。

但 reduced costs 仍非负，因此直接使用**对偶单纯形法**。

---

# 七、新增一个等式约束（A new equality constraint is added）

现在新约束不是“$\ge$”，而是  
$a_{m+1}'x = b_{m+1}$。

---

## 7.1 为什么这里不直接照搬“不等式约束”的方法

如果考虑新问题的对偶，会新增一个对偶变量$p_{m+1}$。  
原对偶最优解$p^*$扩展成$(p^*,0)$后，确实是一个对偶可行解（dual feasible solution），但它**未必是一个对偶基本可行解（dual basic feasible solution）**。

而对偶单纯形法通常需要一个比较方便的“对偶基”起点。  
这里没有像前一种情形那样自然出现。

因此课本不走“直接 dual simplex”的路线，而采用一个更稳妥的办法：**构造辅助原问题（auxiliary primal problem）**。

---

## 7.2 构造带大$M$的辅助问题（big-M auxiliary problem）

假设原解违反新等式，而且不妨设  
$a_{m+1}'x^* > b_{m+1}$。

引入变量$x_{n+1}\ge 0$，构造：

$\min c'x + Mx_{n+1}$

s.t.  
$Ax=b$，  
$a_{m+1}'x - x_{n+1} = b_{m+1}$，  
$x\ge 0,\ x_{n+1}\ge 0$。

这里$M$是一个很大的正数（large positive constant）。

---

## 7.3 这个辅助问题的思想是什么

因为原解使$a_{m+1}'x^*>b_{m+1}$，所以你可以让  
$x_{n+1} = a_{m+1}'x^* - b_{m+1} > 0$，

从而让新等式成立。

也就是说，$x_{n+1}$充当“违反新等式的补偿变量”。

但由于它在目标函数里被乘上一个很大的惩罚系数$M$，所以优化时会极力把它压小。

于是：

- 如果新问题本身可行，那么当$M$足够大时，最优解最终会让$x_{n+1}=0$；
    
- 一旦$x_{n+1}=0$，就说明新等式真的被满足了；
    
- 此时辅助问题的最优解就是原新问题的最优解。
    

---

## 7.4 为什么这里用原始单纯形法（primal simplex）

因为用原来的基本变量加上$x_{n+1}$所构成的基，对辅助问题是**原始可行的**：

- 原约束仍满足；
    
- 新等式通过$x_{n+1}$被补上；
    
- 所有变量非负。
    

所以当前基是 primal feasible 的，只是不一定 optimal。

因此自然用**原始单纯形法**。

---

## 7.5 这一节和“Phase I / artificial variable”关系很近

其实你可以把这里看作“两阶段法（two-phase method）”或“大$M$法（big-M method）”在敏感性分析中的一个局部应用：

- 我们不是从零找可行解；
    
- 而是利用老解，快速构造一个新的辅助可行基；
    
- 再用 simplex 修复到真正最优。
    

---

# 八、改变右端项向量$b$（Changes in the requirement vector$b$）

这是实际中最常见的一类敏感性分析。  
solver 输出里的 shadow price、allowable increase、allowable decrease，本质上都来自这里。

---

## 8.1 为什么改$b$只影响可行性，不影响最优性

因为 reduced costs 是  
$\bar c' = c' - c_B'B^{-1}A$。

这里面没有$b$。

所以当$b$变时：

- 基矩阵$B$不变；
    
- 成本向量$c$不变；
    
- 所有 reduced costs 不变。
    

因此唯一会受影响的是  
$x_B = B^{-1}b$。

也就是说：

> 改$b$只会动当前 BFS 的位置，不会直接动“价格系统”。

---

## 8.2 把某个$b_i$改成$b_i+\delta$

等价于把  
$b$改成$b+\delta e_i$，

其中$e_i$是第$i$个单位向量（unit vector）。

此时新基变量值为  
$x_B(\delta) = B^{-1}(b+\delta e_i) = B^{-1}b + \delta B^{-1}e_i$。

设$g$是$B^{-1}$的第$i$列：  
$g=(\beta_{1i},\beta_{2i},\dots,\beta_{mi})'$。

于是  
$x_B(\delta) = x_B + \delta g$。

分量写开就是  
$x_B(j) + \delta \beta_{ji} \ge 0,\quad j=1,\dots,m$。

---

## 8.3 允许区间（allowable interval）怎么来

对每个$j$，都有一个线性不等式：

- 若$\beta_{ji}>0$，则$\delta \ge -x_B(j)/\beta_{ji}$；
    
- 若$\beta_{ji}<0$，则$\delta \le -x_B(j)/\beta_{ji}$；
    
- 若$\beta_{ji}=0$，则这一项不施加额外限制。
    

把所有不等式合并起来，得到：

$\max_{{j\mid \beta_{ji}>0}}\left(-\frac{x_B(j)}{\beta_{ji}}\right) \le \delta \le \min_{{j\mid \beta_{ji}<0}}\left(-\frac{x_B(j)}{\beta_{ji}}\right)$

这就是老基仍可行、从而仍最优的$\delta$范围。

若某一侧没有对应的约束，那么那一侧范围是无界的。

---

## 8.4 为什么最优值在这个区间里是线性的

只要基不变，最优值就是  
$c_B' x_B(\delta) = c_B'B^{-1}(b+\delta e_i)$。

令  
$p' = c_B'B^{-1}$，

则  
$c_B'B^{-1}(b+\delta e_i) = p'b + \delta p_i$。

所以在这个允许区间内：

- 最优值对$\delta$是线性的；
    
- 斜率就是对偶变量$p_i$。
    

---

## 8.5 对偶变量（dual variable）在这里的经济解释

$p_i$被称为：

- 影子价格（shadow price）
    
- 边际价值（marginal value）
    
- 边际成本（marginal cost）
    

意思是：

> 在当前基不变的局部范围内，把第$i$个右端资源增加 1 单位，最优目标值会变化$p_i$个单位。

对于最小化问题：

- 若$p_i>0$，说明这个资源越多，目标值越大；
    
- 若从“资源约束”角度理解，常见模型里也可以解释成约束更紧的代价；
    
- 具体正负要结合原问题经济含义看。
    

---

## 8.6 超出区间后为什么用对偶单纯形法

因为一旦$\delta$超过允许范围：

- reduced costs 仍然没变，仍然非负；
    
- 但某个基变量变成负数，原始可行性丢失。
    

于是当前基是：

- dual feasible；
    
- primal infeasible。
    

所以用**对偶单纯形法**。

---

## 8.7 Example 5.3 详细解释

教材考虑往$b_1$增加$\delta$。

从$B^{-1}$的第一列读到  
$g = (-3,5)'$。

原基变量值是$(2,2)'$，所以新基变量值变成  
$x_B(\delta) = (2,2)' + \delta(-3,5)' = (2-3\delta,\ 2+5\delta)'$。

要保持可行，需要：

- $2-3\delta \ge 0$，即$\delta \le 2/3$；
    
- $2+5\delta \ge 0$，即$\delta \ge -2/5$。
    

所以允许区间是  
$-2/5 \le \delta \le 2/3$。

同时目标值斜率是  
$c_B'B^{-1}e_1 = (-5,-1)(-3,5)' = 10$。

也就是说，在这个范围内：

$F(\delta) = F(0) + 10\delta$

所以每增加 1 单位$b_1$，最优值增加 10。

若$\delta > 2/3$，则第一个基变量变负，这时要用对偶单纯形法换基修复。

---

# 九、改变成本向量$c$（Changes in the cost vector$c$）

这一部分和改$b$正好互补。

---

## 9.1 为什么改$c$只影响最优性，不影响可行性

因为当前基变量值是  
$x_B = B^{-1}b$，

它和$c$无关。

所以原始可行性不变；  
但 reduced cost 会变，因为  
$\bar c' = c' - c_B'B^{-1}A$。

---

# 十、非基变量成本变化（Changing the cost of a nonbasic variable）

设$x_j$是一个非基变量，其成本从$c_j$改成$c_j+\delta$。

---

## 10.1 为什么只有一个 reduced cost 受影响

因为$x_j$是非基变量，所以它不在$c_B$里面。  
因此$c_B$不变，$p'=c_B'B^{-1}$不变。

于是所有别的 reduced costs 都不变，只有第$j$个 reduced cost 变成：

$\bar c_j(\delta) = c_j + \delta - c_B'B^{-1}A_j = \bar c_j + \delta$

为了保持最优性，需要  
$\bar c_j + \delta \ge 0$，

即  
$\delta \ge -\bar c_j$。

---

## 10.2 为什么若不满足，就用原始单纯形法

因为当前基变量值没变，所以原始可行性还在。  
只是某个 reduced cost 变负了，不再最优。

所以从当前 BFS 出发，使用**原始单纯形法**。

---

# 十一、基变量成本变化（Changing the cost of a basic variable）

这比前一种更复杂，因为它会改动整个$c_B$，从而改动整个对偶向量$p$，于是所有 reduced costs 可能一起变。

设$x_j$是第$\ell$个基变量，即$j=B(\ell)$。  
把它的成本从$c_j$改成$c_j+\delta$，等价于把

$c_B$改成$c_B + \delta e_\ell$。

---

## 11.1 新 reduced cost 的推导

新对偶向量为  
$p'(\delta) = (c_B+\delta e_\ell)'B^{-1} = c_B'B^{-1} + \delta e_\ell'B^{-1} = p' + \delta e_\ell'B^{-1}$

于是对任意非基变量$x_i$，

$\bar c_i(\delta) = c_i - p'(\delta)A_i$

$= c_i - p'A_i - \delta e_\ell'B^{-1}A_i$

$= \bar c_i - \delta q_{\ell i}$

其中  
$q_{\ell i}$是$B^{-1}A_i$的第$\ell$个分量。

于是最优性条件变成：

$\bar c_i - \delta q_{\ell i} \ge 0,\quad \forall i\neq j$

等价写成：

$\delta q_{\ell i} \le \bar c_i,\quad \forall i\neq j$

---

## 11.2 为什么这里会“联动全部 reduced costs”

因为改变一个基变量的成本，不只是改变这个变量本身的价格，而是改变整个“对偶价格系统”：

$p' = c_B'B^{-1}$

而所有 reduced costs 都通过$p'$来定义。  
所以它会整体联动。

---

## 11.3 如何从单纯形表读出$q_{\ell i}$

在最终单纯形表里，非基列对应的列，就是$B^{-1}A_i$。  
因此其第$\ell$个分量，就是表中：

- 第$\ell$行；
    
- 第$i$列
    

的那个数。

---

## 11.4 Example 5.4 详细解释

在 Example 5.1 中：

- $x_3,x_4$是非基变量；
    
- 它们的 reduced costs 分别是$\bar c_3=2,\ \bar c_4=7$。
    

所以若改变非基变量成本：

- $c_3\mapsto c_3+\delta_3$，要求$\delta_3 \ge -2$；
    
- $c_4\mapsto c_4+\delta_4$，要求$\delta_4 \ge -7$。
    

现在考虑改变基变量$x_1$的成本，即$c_1\mapsto c_1+\delta_1$。

因为$x_1$是第一个基变量，所以$\ell=1$。  
从表中读取：

- $q_{13}=-3$
    
- $q_{14}=2$
    

于是要满足：

$\delta_1(-3)\le \bar c_3=2 \Rightarrow \delta_1 \ge -2/3$

$\delta_1(2)\le \bar c_4=7 \Rightarrow \delta_1 \le 7/2$

因此允许范围是  
$-2/3 \le \delta_1 \le 7/2$。

也就是说，在这个区间内，即使$c_1$改动，原基仍保持最优。

---

# 十二、改变一个非基列的$A$（Changes in a nonbasic column of$A$）

现在考虑矩阵$A$的一个元素变化。  
若变化发生在非基列$A_j$上，例如：

$A_j \mapsto A_j + \delta e_i$

也就是第$j$列的第$i$个元素变化了$\delta$。

---

## 12.1 为什么只影响这一个变量的 reduced cost

因为$A_j$不在基中，所以基矩阵$B$不变。  
于是：

- 原始可行性不变；
    
- 对偶向量$p'=c_B'B^{-1}$不变；
    
- 只有第$j$列的 reduced cost 改变。
    

新 reduced cost 为：

$\bar c_j(\delta) = c_j - p'(A_j+\delta e_i) = \bar c_j - \delta p_i$

因此保持最优性要求

$\bar c_j - \delta p_i \ge 0$

---

## 12.2 这个公式的经济直觉

$p_i$是第$i$个约束的影子价格（shadow price）。

若$a_{ij}$增加$\delta$，等于说：

> 单位变量$x_j$对第$i$个约束的“技术贡献 / 消耗”改变了。

而这个改变在目标中的价值，正由$p_i$来衡量，所以对 reduced cost 的影响是$-\delta p_i$。

---

## 12.3 若条件被破坏怎么办

如果  
$\bar c_j - \delta p_i < 0$，

说明这个非基变量现在值得进入基。  
因为当前解仍然原始可行，所以继续用**原始单纯形法**。

---

# 十三、改变一个基列的$A$（Changes in a basic column of$A$）

这是 5.1 里最复杂的一种情形。

如果变化发生在基列$A_j$上，例如  
$A_j \mapsto A_j + \delta e_i$，

那么会发生什么？

- 基矩阵$B$自己变了；
    
- 所以$B^{-1}$变了；
    
- 因而基变量值$B^{-1}b$变了；
    
- 对偶向量$c_B'B^{-1}$也变了；
    
- 所以可行性和最优性都会一起变。
    

因此这个问题不再像前几类那样，只看一个条件就行。

---

## 13.1 课本给出的一阶近似（first-order approximation）

在原问题和对偶问题的最优解都唯一且非退化（unique and nondegenerate）的条件下，课本给出：

$c'x^*(\delta) = c'x^* - \delta x_j^* p_i + O(\delta^2)$

这告诉你：对很小的$\delta$，目标值变化的主导项是  
$-\delta x_j^* p_i$。

---

## 13.2 这个公式怎么理解

如果$x_j$是最优方案中真正用了的一个基变量，而且它的值是$x_j^*$，  
那么把技术系数$a_{ij}$增大$\delta$，就相当于：

- 每单位$x_j$多贡献了$\delta$个第$i$类资源；
    
- 一共多贡献了$\delta x_j^*$；
    
- 每单位第$i$类资源的边际价值是$p_i$；
    
- 所以你“白拿”了大约$\delta x_j^* p_i$的价值；
    
- 对最小化问题来说，成本就可以下降这么多。
    

因此出现  
$-\delta x_j^* p_i$。

---

## 13.3 这个一阶式从哪里来（稍微再深一点）

若$A_j$是基矩阵$B$的第$\ell$列，那么新基矩阵是

$B(\delta) = B + \delta e_i e_\ell'$

对小$\delta$，可以用矩阵逆的扰动展开（perturbation expansion）：

$B(\delta)^{-1} = B^{-1} - \delta B^{-1}e_i e_\ell' B^{-1} + O(\delta^2)$

于是

$x_B(\delta) = B(\delta)^{-1}b = x_B - \delta B^{-1}e_i e_\ell' x_B + O(\delta^2)$

由于$e_\ell' x_B = x_j^*$，所以

$x_B(\delta) = x_B - \delta x_j^* B^{-1}e_i + O(\delta^2)$

再左乘$c_B'$，就得到

$c_B'x_B(\delta) = c_B'x_B - \delta x_j^* c_B'B^{-1}e_i + O(\delta^2)$

而$c_B'B^{-1}e_i = p_i$，因此

$c'x^*(\delta) = c'x^* - \delta x_j^* p_i + O(\delta^2)$

这就是教材公式的来源。

---

# 十四、生产计划例子（Production planning revisited）的深层意义

这一段不是为了再教你新算法，而是为了说明：

> 求解器（solver）输出的 dual variables、ranges，不是边角料，而是决策支持中最有用的信息之一。

例如：

- 某种生产模式下，256K 板的对偶变量是 15；
    
- 允许增量上限是 0.2（千个）；
    
- 所以在这个局部范围里，多 0.2 千个板，可以提高收益$15\times 0.2 = 3$百万美元。
    

这说明：

- 对偶变量（dual variable）告诉你“哪种资源最值钱”；
    
- 允许区间（allowable range）告诉你“这种边际结论在哪个范围内成立”。
    

---

## 14.1 为什么有时对偶变量为 0

例如某个资源对应的对偶变量是 0，意味着：

> 在当前最优基附近，这项资源不是稀缺瓶颈（binding bottleneck）。

所以再增加一点它，不会改善目标值。  
这通常意味着该约束当前不是紧约束（nonbinding constraint）或者它虽然紧但在边际上没有价值。

---

## 14.2 为什么范围可能向上是无穷大

若某个资源对应的 allowable increase 是无穷大，说明：

> 即使继续增加这项资源，在当前讨论方向上，基也不会因为这项变化而立即失效。

当然，这不代表整个实际系统永远不会变，只是说在这个模型里，沿这个单参数方向，它不会先触发换基。

---

# 十五、5.2 最优值对右端项$b$的全局依赖（Global dependence on the right-hand side vector）

前面 5.1 是**局部**看：同一个基是否还能活下去。  
5.2 开始转向**全局**看：

> 不管基换不换，最优值作为$b$的函数，整体长什么样？

---

## 15.1 定义值函数（value function）

定义可行域  
$P(b) = {x \mid Ax=b,\ x\ge 0}$

再定义  
$S = { b \mid P(b)\neq \emptyset }$

也就是所有使原问题可行的右端项集合。

因为  
$S = {Ax \mid x\ge 0}$，

所以$S$是一个凸集（convex set）。更准确说，它是$A$的列所生成的凸锥（convex cone）的像。

定义最优值函数  
$F(b) = \min_{x\in P(b)} c'x$

这就是：

> 右端项是$b$时，原问题的最优成本。

---

## 15.2 为什么先假设对偶可行集非空

教材假设  
${p \mid p'A\le c' } \neq \emptyset$

这样一来，只要$b\in S$（也就是 primal feasible），由对偶理论可知最优值不会掉到$-\infty$，因此$F(b)$是有限的。

否则，如果对偶不可行，primal 可能对某些$b$出现无界（unbounded below），那值函数分析会复杂很多。

---

## 15.3 局部上为什么$F(b)$是线性的

取某个$b^*$，并假设在$b^*$对应的问题里，有一个非退化的最优 BFS，基矩阵为$B$。

因为非退化，所以  
$x_B = B^{-1}b^* > 0$。

如果把$b^*$略微改成附近的$b$，那么$B^{-1}b$仍然保持正，因此老基仍可行。  
同时 reduced costs 不受$b$影响，因此仍最优。

于是局部上  
$F(b) = c_B'B^{-1}b = p'b$，

其中  
$p' = c_B'B^{-1}$。

所以：

- $F(b)$在局部是线性的；
    
- 它的梯度（gradient）是对偶最优解$p$。
    

这就是“对偶变量是边际成本（marginal costs）”的严格数学来源。

---

# 十六、定理 5.1：$F(b)$是凸函数（convex function）

教材给了两种理解方式：  
一种是直接用 primal 可行解证明；  
另一种是从 dual 的极点表示出发。

---

## 16.1 直接证明为什么凸

取两组右端项$b^1,b^2\in S$，各自的最优解为$x^1,x^2$。

对任意$\lambda\in[0,1]$，令  
$y=\lambda x^1 + (1-\lambda)x^2$。

由于$x^1,x^2\ge 0$，所以$y\ge 0$；  
同时  
$Ay = \lambda b^1 + (1-\lambda)b^2$。

所以$y$是右端项$\lambda b^1 + (1-\lambda)b^2$的一个可行解。  
因此：

$F(\lambda b^1 + (1-\lambda)b^2) \le c'y = \lambda c'x^1 + (1-\lambda)c'x^2 = \lambda F(b^1) + (1-\lambda)F(b^2)$

这正是凸性的定义。

---

## 16.2 这个凸性该怎样直觉理解

把两个需求场景（requirement scenarios）混合起来，混合场景下的最优成本不会比“各自最优成本的平均”更高。

这就是一种“最优值不向下弯”的性质。

---

# 十七、$F(b)$为什么还是分段线性（piecewise linear）

从对偶看：

对任意$b\in S$，对偶问题是  
$\max p'b$，s.t.$p'A\le c'$。

关键点是：

- 当$b$变时，对偶可行域并不变；
    
- 变的只有目标函数$p'b$。
    

设对偶可行域的极点（extreme points）是$p^1,\dots,p^N$，则最优值一定在某个极点上达到，所以

$F(b) = \max_{i=1,\dots,N} (p^i)'b$

这说明：

>$F(b)$是有限个线性函数的最大值（maximum of finitely many linear functions）。

所以它必然：

- 凸（convex）；
    
- 分段线性（piecewise linear）。
    

---

## 17.1 每一段线性片意味着什么

若在某片区域上  
$F(b) = (p^i)'b$，

说明在这一整片区域里，都是同一个对偶极点$p^i$在主导最优值。

也就是说：

- 这一片区域里影子价格不变；
    
- 这一片区域里最优基也通常不变（更准确地说，在非退化情形下如此）。
    

---

## 17.2 为什么折点（breakpoint）处会不可微

如果在某个点$b^*$有

$F(b^*) = (p^1)'b^* = (p^2)'b^*$

并且附近不同方向上由不同的线性片主导，那么在这个点上就没有唯一梯度。  
这说明 dual optimal solution 不唯一。

教材进一步说明：

> 在这种不可微点，每个 primal optimal BFS 都必须是退化的（degenerate）。

原因是：如果存在一个非退化最优 BFS，那么根据前面的局部分析，$F$在该点附近应该是线性的，从而可微。与折点矛盾。

注意这个结论是：

- “存在非退化最优 BFS$\Rightarrow$局部线性”；
    
- 因此“非局部线性（折点）$\Rightarrow$所有最优 BFS 退化”。
    

这是很漂亮的一条逻辑链。

---

# 十八、沿着一个参数方向看$b$：$b=b^*+\theta d$

令  
$f(\theta)=F(b^*+\theta d)$

那么由极点表示有

$f(\theta)=\max_i (p^i)'(b^*+\theta d)$

也就是

$f(\theta)=\max_i \big( (p^i)'b^* + \theta (p^i)'d \big)$

所以$f(\theta)$是若干条直线的最大值，因此是一个**分段线性凸函数（piecewise linear convex function）**。

每段的斜率就是  
$(p^i)'d$

因此：

- 不同区间对应不同最优对偶解；
    
- 折点对应对偶最优解切换。
    

---

# 十九、5.3 所有对偶最优解的集合（The set of all dual optimal solutions）

5.2 告诉你，在可微点，对偶最优解就是梯度。  
但在折点，不可微，梯度不唯一，怎么办？

课本引入**次梯度（subgradient）**。

---

## 19.1 次梯度（subgradient）的定义

设$F$是定义在凸集$S$上的凸函数。  
若向量$p$满足

$F(b^*) + p'(b-b^*) \le F(b),\quad \forall b\in S$

则称$p$是$F$在$b^*$处的一个次梯度（subgradient）。

---

## 19.2 这个定义的几何意义

$F(b^*) + p'(b-b^*)$是一条通过点$(b^*,F(b^*))$的线性函数。

如果它对所有$b$都不超过$F(b)$，那说明它是一条“从下方托住”函数图像的支撑平面（supporting hyperplane）。

所以：

- 光滑点：只有一个次梯度，就是普通梯度；
    
- 折点：可能有很多个次梯度，对应很多条不同的支撑线。
    

---

## 19.3 定理 5.2：对偶最优解当且仅当是次梯度

这是这一章最漂亮的结构性定理之一。

它说：

> 向量$p$是$b^*$对应 dual problem 的最优解  
> 当且仅当  
>$p$是值函数$F$在$b^*$处的一个次梯度。

---

## 19.4 证明的“正向”为什么成立

若$p$是 dual optimal solution，则强对偶给出  
$p'b^* = F(b^*)$

对任意$b\in S$，任取一个可行解$x\in P(b)$，由弱对偶得  
$p'b \le c'x$

对所有可行$x$取最小，得到  
$p'b \le F(b)$

于是  
$p'b - p'b^* \le F(b) - F(b^*)$

即  
$F(b^*) + p'(b-b^*) \le F(b)$

所以$p$是次梯度。

---

## 19.5 证明的“反向”为什么成立

若$p$是次梯度，则  
$F(b^*) + p'(b-b^*) \le F(b),\quad \forall b\in S$

现在对任意$x\ge 0$，令$b=Ax$。则$x\in P(b)$，所以  
$F(b)\le c'x$

代入得  
$p'Ax \le c'x - F(b^*) + p'b^*$

因为这对所有$x\ge 0$都成立，如果某一列$A_k$满足$p'A_k > c_k$，那么取$x=t e_k$、$t\to\infty$就会矛盾。  
因此必须有  
$p'A \le c'$

这说明$p$是 dual feasible。

再令$x=0$，则$b=0$，由上式可推出  
$F(b^*) \le p'b^*$

而对任意 dual feasible 向量$q$，弱对偶给出  
$q'b^* \le F(b^*)$

因此  
$p'b^* \ge F(b^*) \ge q'b^*$

说明$p$达到了 dual optimum，所以它是 dual optimal solution。

---

## 19.6 这个定理的意义

它告诉你：

- 在可微点，对偶最优解是“真正的梯度（gradient）”；
    
- 在折点，对偶最优解是“广义梯度（generalized gradient）”，也就是次梯度（subgradient）。
    

所以“影子价格（shadow price）”的概念在折点并没有失效，只是从唯一值变成了一个集合。

---

# 二十、5.4 最优值对成本向量$c$的全局依赖（Global dependence on the cost vector）

这一节和 5.2 是镜像结构。

5.2 固定$A,c$，研究$b$变。  
5.4 固定$A,b$，研究$c$变。

---

## 20.1 此时什么是不变的

当$A,b$固定时，原问题可行域  
${x\mid Ax=b,\ x\ge 0}$

是不变的。

因此：

- 所有基本可行解（basic feasible solutions）$x^1,\dots,x^N$是固定的；
    
- 变的只是目标函数$c'x$。
    

这和 5.2 完全对偶。

---

## 20.2 定义$T$和$G(c)$

定义 dual feasible set  
$Q(c) = { p \mid p'A \le c' }$

再定义  
$T = { c \mid Q(c)\neq \emptyset }$

即：那些使得 dual feasible 的成本向量集合。

然后定义最优值函数  
$G(c)$

它表示：在给定成本向量$c$时，原问题的最优值。

当$c\notin T$时，dual infeasible，原问题最优值为$-\infty$；  
当$c\in T$时，最优值有限。

---

## 20.3 为什么$T$是凸集（convex set）

若$c^1,c^2\in T$，分别有 dual feasible solutions$p^1,p^2$，则对任意$\lambda\in[0,1]$，

$(\lambda p^1 + (1-\lambda)p^2)'A \le \lambda c^1 + (1-\lambda)c^2$

所以  
$\lambda c^1 + (1-\lambda)c^2 \in T$

因此$T$是凸集。

---

## 20.4 为什么$G(c)$是分段线性凹函数（piecewise linear concave function）

因为 primal feasible set 不变，所以所有极点$x^1,\dots,x^N$不变。  
最优值总在某个极点取得，因此

$G(c) = \min_{i=1,\dots,N} c'x^i$

这说明：

>$G(c)$是有限个线性函数的最小值（minimum of finitely many linear functions）。

因此：

- $G(c)$是凹函数（concave）；
    
- $G(c)$是分段线性（piecewise linear）。
    

---

## 20.5 为什么若最优解唯一，则局部上$G(c)$是线性的

若在某个$c^*$下，唯一最优解是$x^i$，则  
$(c^*)'x^i < (c^*)'x^j,\ \forall j\neq i$

因为不等式是严格的，所以在$c^*$附近小扰动下，这个不等式仍成立，于是同一个极点$x^i$继续最优。

于是局部上  
$G(c)=c'x^i$

因此：

- $G$在该点附近线性；
    
- 梯度就是$x^i=x^*$。
    

这和 5.2 中“$\nabla F(b)=p^*$”正好形成对偶对称：

- 对$b$的梯度是对偶解；
    
- 对$c$的梯度是原最优解。
    

---

## 20.6 一个很值得记住的对称关系

你可以把 5.2 和 5.4 放在一起记：

- $F(b)$：固定$A,c$，改变$b$，是**凸**的，梯度是$p^*$；
    
- $G(c)$：固定$A,b$，改变$c$，是**凹**的，梯度是$x^*$。
    

这就是 primal-dual symmetry 在值函数（value function）层面的体现。

---

# 二十一、5.5 参数规划（Parametric programming）

这一节把“局部灵敏度”推进成“全局沿单参数追踪最优基”。

它研究的是：

> 当问题只依赖一个标量参数$\theta$时，能否用 simplex 连续追踪所有断点（breakpoints）和所有线性片段？

---

## 21.1 成本参数化的模型

考虑  
$\min (c+\theta d)'x$，s.t.$Ax=b,\ x\ge 0$

令最优值为  
$g(\theta)$

只要最优值有限，就有  
$g(\theta)=\min_i (c+\theta d)'x^i$

因此$g(\theta)$是若干条直线的下包络（lower envelope），所以是**分段线性凹函数（piecewise linear concave function）**。

---

## 21.2 Example 5.5 的初始区间为什么是$[3/2,3]$

例子中原问题是  
$\min (-3+2\theta)x_1 + (3-\theta)x_2 + x_3$

加上松弛变量$x_4,x_5$后，最初选$x_4,x_5$为基变量。  
因为它们成本为 0，所以此时非基变量$x_1,x_2,x_3$的 reduced costs 就是它们自己的目标系数：

- $x_1$的 reduced cost 是$-3+2\theta$
    
- $x_2$的 reduced cost 是$3-\theta$
    
- $x_3$的 reduced cost 是$1$
    

为了让当前基最优，需要它们都非负：

- $-3+2\theta \ge 0 \Rightarrow \theta \ge 3/2$
    
- $3-\theta \ge 0 \Rightarrow \theta \le 3$
    
- $1\ge 0$自动成立
    

因此初始基在  
$3/2 \le \theta \le 3$
上最优，而且目标值为 0。

---

## 21.3 为什么过了$\theta=3$要让$x_2$进基

当$\theta>3$，  
$3-\theta<0$

所以$x_2$的 reduced cost 变负，它应该进基。  
接着用原始单纯形法做一次 pivot。

做完后得到新的基，并算出新的区间与线性公式  
$g(\theta)=7.5-2.5\theta$

这个公式只在新的 reduced costs 全部非负的区间内有效。

---

## 21.4 为什么再往右会变成无界（unbounded）

继续增大$\theta$，会出现另一个变量$x_3$的 reduced cost 变负。  
如果此时它对应列没有正的主元（positive pivot element），那么说明：

- 增大这个变量时，不会有任何基变量先降到 0；
    
- 目标值却能一直下降。
    

因此问题在这一区间上无界，$g(\theta)=-\infty$。

---

## 21.5 左边区间是怎么来的

同理，当$\theta<3/2$时，  
$-3+2\theta<0$

所以$x_1$变成 entering variable。  
做 pivot 后得到另一个基，并在一个左侧区间上得到线性公式  
$g(\theta) = -10.5 + 7\theta$

继续往左再变，就又出现无界。

---

# 二十二、参数规划的一般算法逻辑

现在不只看例子，而看普遍规律。

假设某个基$B$在区间  
$[\theta_1,\theta_2]$
上最优。

---

## 22.1 reduced costs 都是$\theta$的仿射函数（affine functions）

因为目标是$(c+\theta d)'x$，所以基成本$c_B+\theta d_B$也是线性的，  
于是

$\bar c_j(\theta) = c_j+\theta d_j - (c_B+\theta d_B)'B^{-1}A_j$

也是关于$\theta$的一次函数。

所以只要盯住这些 reduced costs 什么时候从非负变成负，就能知道当前基的最优区间什么时候结束。

---

## 22.2 当某个 reduced cost 在$\theta_2$处变成 0

设变量$x_j$满足：

- 在$[\theta_1,\theta_2]$内其 reduced cost 非负；
    
- 到$\theta_2$恰好等于 0；
    
- 再往右就变负。
    

那么$x_j$就是下一步要进基的候选变量。

---

## 22.3 两种可能

### 情况一：第$j$列没有正主元

那说明一旦$\theta>\theta_2$，让$x_j$增加就能不断降低目标而不破坏非负性，于是问题无界。

---

### 情况二：第$j$列有正主元

那就做 pivot，得到新基$\bar B$。  
课本说明新基将在形如  
$[\theta_2,\theta_3]$
的区间上最优。

而且旧基不可能在更右边重新回来成为最优基（在无退化、区间真正推进的情形下）。

于是一路做下去，就能把整条参数轴分成若干连续区间，每个区间对应一个最优基和一段线性公式。

---

## 22.4 为什么最终可以在有限步内追踪完整条曲线

因为线性规划只有有限个基（finitely many bases）。  
若每次区间端点严格推进，即$\theta_{i+1}>\theta_i$，那么不可能无限次遇到同一个基。

所以整个参数追踪会在有限次 pivot 后结束。

---

## 22.5 为什么退化（degeneracy）会导致 cycling

如果某些相邻区间满足  
$\theta_i = \theta_{i+1}$，

说明你做了一次 pivot，但只是从一个退化基跳到另一个退化基，两者都只在同一个单点上最优。  
这时就可能在若干个基之间打转，出现循环（cycling）。

因此参数规划也需要**防循环规则（anticycling rule）**。

---

# 二十三、右端项参数化：$b+\theta d$

教材最后提到另一种参数规划：

固定$c$，把$b$改成  
$b+\theta d$

此时：

- reduced costs 不变；
    
- 变化的是右端列（RHS column / zeroth column）。
    

所以当$\theta$增大到某个基变量变负时：

- 当前基变成 primal infeasible；
    
- 但 reduced costs 还保持非负；
    

因此使用**对偶单纯形法（dual simplex method）**来追踪新的区间。

这和 5.1 中“改$b$的局部分析”完全一致，只不过现在把它做成了全局的参数追踪过程。

---

# 二十四、把 5.1 到 5.5 统一起来看

现在你应该把这一章压缩成一个统一图景。

---

## 24.1 局部层面（local level）

核心问题：**同一个基是否还能保持最优？**

只检查两件事：

- $B^{-1}b\ge 0$；
    
- $c' - c_B'B^{-1}A\ge 0'$。
    

不同变化类型只是影响这两个条件的方式不同。

---

## 24.2 全局层面（global level）

核心问题：**最优值函数本身长什么样？**

- 对$b$：$F(b)$是分段线性凸函数；
    
- 对$c$：$G(c)$是分段线性凹函数。
    

并且：

- $F(b)$的线性片由 dual extreme points 决定；
    
- $G(c)$的线性片由 primal extreme points 决定。
    

---

## 24.3 单参数层面（parametric level）

核心问题：**沿着一条参数路径，最优基如何一个区间接一个区间地切换？**

- 若目标参数化：用 primal simplex 跟踪 reduced costs 变号；
    
- 若 RHS 参数化：用 dual simplex 跟踪基变量变负。
    

---

# 二十五、这一章最核心的结论，请你一定要真正记牢

下面这些是你做题和复习时最该背熟的骨架。

---

## 1. 最优基的两个条件

$B^{-1}b\ge 0$，  
$c' - c_B'B^{-1}A \ge 0'$。

---

## 2. 新增变量时看它的 reduced cost

$\bar c_{n+1} = c_{n+1} - c_B'B^{-1}A_{n+1}$

若非负，老基不变；若负，用 primal simplex。

---

## 3. 新增被违反的不等式约束时

构造新基后：

- primal infeasible；
    
- dual feasible；
    

所以用 dual simplex。

---

## 4. 改右端项$b_i\mapsto b_i+\delta$时

$x_B(\delta)=x_B+\delta g$，其中$g$是$B^{-1}$第$i$列。  
由各分量非负求允许区间。  
在区间内最优值是  
$p'b + \delta p_i$。

---

## 5. 改非基成本时

只影响一个 reduced cost，条件是  
$\delta \ge -\bar c_j$。

---

## 6. 改基成本时

新 reduced costs 为  
$\bar c_i - \delta q_{\ell i}$

从而得到允许区间。

---

## 7. 改非基列$A_j$时

条件是  
$\bar c_j - \delta p_i \ge 0$

---

## 8. 改基列时

一阶近似为  
$c'x^*(\delta) = c'x^* - \delta x_j^* p_i + O(\delta^2)$

---

## 9.$F(b)$的全局结构

$F(b)=\max_i (p^i)'b$

所以它是：

- convex；
    
- piecewise linear。
    

---

## 10. dual optimal solutions = subgradients of$F$

这给了折点处 shadow prices 的广义解释。

---

## 11.$G(c)$的全局结构

$G(c)=\min_i c'x^i$

所以它是：

- concave；
    
- piecewise linear。
    

若最优解唯一，则  
$\nabla G(c)=x^*$。

---

## 12. parametric programming

- $c+\theta d$：得到 piecewise linear concave 的$g(\theta)$；
    
- $b+\theta d$：得到 piecewise linear convex 的值函数切片。
    

---

# 二十六、你学习这一章时最容易掉进去的几个坑

---

## 坑 1：影子价格不是“永远有效”

对偶变量$p_i$只在**允许范围（allowable range）**内，才真正等于最优值对$b_i$的局部变化率。  
超出区间后基会变，斜率也会变。

---

## 坑 2：对$b$是凸，对$c$是凹

很多人会记混。

- $F(b)$是若干线性函数的最大值$\Rightarrow$convex；
    
- $G(c)$是若干线性函数的最小值$\Rightarrow$concave。
    

---

## 坑 3：新增约束通常用 dual simplex，不是 primal simplex

因为约束变严后，老解通常先变成不可行，而 reduced costs 往往还保持非负。

---

## 坑 4：新增变量通常用 primal simplex

因为老解还是可行的，只是新的 reduced cost 可能变负。

---

## 坑 5：折点不等于“有问题”，而是“多种最优影子价格共存”

在折点：

- dual optimum 不唯一；
    
- primal optimal BFS 退化；
    
- 值函数不可微。
    

这是正常几何现象，不是算法错了。

---

# 二十七、最后给你一个适合复习时直接背的章节总纲

你可以把 Chapter 5 总结成下面四句话：

1. **局部敏感性（local sensitivity）**：改了数据后，先看老基是否仍满足可行性和最优性。
    
2. **右端项的全局依赖（global dependence on$b$）**：最优值函数$F(b)$是分段线性凸函数，其次梯度就是 dual optimal solutions。
    
3. **成本向量的全局依赖（global dependence on$c$）**：最优值函数$G(c)$是分段线性凹函数，局部梯度等于 primal optimal solution。
    
4. **参数规划（parametric programming）**：当数据只依赖一个标量参数时，可以用 simplex 逐段追踪全部 breakpoints 和线性公式。
    

---



可以把这个**运输问题（transportation problem）**分成两层来直观理解：

1. **表层：怎么发货最省钱**
    
2. **深层：对偶（dual）其实是在找一套“内部价格体系（price system）”**
    

我按这两层给你讲。

---

# 一、原问题（primal）到底在干什么

你的课件里原问题是：

$\min \sum_{i=1}^m \sum_{j=1}^n c_{ij}x_{ij}$

s.t.  
$\sum_{j=1}^n x_{ij} \le s_i,\ \forall i$ 
$\sum_{i=1}^m x_{ij} \ge d_j,\ \forall j$ 
$x_{ij}\ge 0,\ \forall i,j$

这里：

- $s_i$是第$i$个供应商（supplier）的供应量
    
- $d_j$是第$j$个需求方（demand node）的需求量
    
- $c_{ij}$是从供应商$i$运到需求方$j$的单位运输成本（unit transportation cost）
    
- $x_{ij}$是决策变量（decision variable），表示从$i$运到$j$的货量
    

---

## 1. 这其实就是一个“物流分配”问题

你可以把它想成：

- 左边有很多仓库 / 工厂
    
- 右边有很多门店 / 客户
    
- 每一条“供应商$\to$需求方”的连线都有一个运费$c_{ij}$
    
- 你要决定每条线送多少货$x_{ij}$
    

目标是：

> 在满足所有需求的前提下，总运费最小。

---

## 2. 约束为什么这样写

### 供应约束（supply constraints）

$\sum_{j=1}^n x_{ij} \le s_i$

意思是：  
供应商$i$发出去的总货量不能超过自己库存 / 产能$s_i$。

所以这是一种“上限（upper bound）”。

---

### 需求约束（demand constraints）

$\sum_{i=1}^m x_{ij} \ge d_j$

意思是：  
需求方$j$收到的总货量至少要达到需求量$d_j$。

所以这是一种“下限（lower bound）”。

很多教材会写成等式，那通常是“总供给 = 总需求”的平衡运输问题（balanced transportation problem）。  
你这页课件写成$\le$和$\ge$，表示它允许：

- 某些供应商有货没发完；
    
- 某些需求点理论上可以收到超过需求的量，但由于目标是“最小成本”，一般不会无意义超送。
    

---

## 3. 为什么它直观上很像“水流”问题

你可以把供应商看成“水源”，需求方看成“水池”：

- 每个水源最多放出$s_i$
    
- 每个水池至少要接到$d_j$
    
- 每条管道的单位流量成本是$c_{ij}$
    
- $x_{ij}$就是这条管道上的流量
    

于是这个模型就是：

> 怎么让水流过去，既满足每个池子的最低需要，又让总费用最低。

这就是运输问题最朴素的图像。

---

# 二、为什么这个模型会天然出现“便宜路多运、贵路少运”

虽然模型里没有明写“优先走便宜路线”，但目标函数会自动逼出这个结构。

因为总成本是  
$\sum_{i,j} c_{ij}x_{ij}$

所以如果有两条路：

- 一条单位成本低
    
- 一条单位成本高
    

只要约束允许，最优解一定倾向于先把低成本路线用足，再去考虑高成本路线。

所以运输问题本质上就是：

> 在一个带权二部图（weighted bipartite graph）上做最便宜的流量分配。

---

# 三、对偶（dual）到底在说什么

你课件中的对偶是：

$\max \sum_{i=1}^m s_i u_i + \sum_{j=1}^n d_j v_j$

s.t.  
$u_i + v_j \le c_{ij},\ \forall i,j$ 
$u_i \le 0,\ v_j \ge 0$

这个式子一眼看上去会比较抽象，因为$u_i,v_j$好像不像“货量”，而像一些奇怪的系数。

其实它的直观意义是：

> 对偶不是在决定“运多少货”，而是在决定“一套内部价格（internal prices）”。

---

# 四、先别管公式，先讲“中间商”故事

课件已经给了一个非常好的经济解释。  
你可以把对偶想成有一个“中间商（middleman）”或者“平台（platform）”：

- 它从供应商$i$那里“收货”
    
- 再卖给需求方$j$
    

设：

- 它从供应商$i$采购时，每单位支付价格是$-u_i$
    
- 它卖给需求方$j$时，每单位收取价格是$v_j$
    

注意这里为什么写成$-u_i$而不是$u_i$：

因为对偶里$u_i\le 0$，所以$-u_i\ge 0$，这才像正常的采购价。

---

## 1. 中间商的利润怎么写

如果中间商把全部供应都按这个内部价格体系买入 / 卖出，那么：

- 总销售收入大约是$\sum_{j=1}^n d_j v_j$
    
- 总采购支出大约是$\sum_{i=1}^m s_i(-u_i)$
    

因此利润是：

$\sum_{j=1}^n d_j v_j - \sum_{i=1}^m s_i(-u_i) = \sum_{i=1}^m s_i u_i + \sum_{j=1}^n d_j v_j$

这正好就是对偶目标函数。

所以对偶目标其实是在说：

> 找一套采购价和销售价，使得中间商的总利润最大。

---

# 五、那为什么要满足$u_i+v_j\le c_{ij}$

这是对偶里最核心、也最值得直观理解的一条约束。

把它改写一下：

$v_j - (-u_i) \le c_{ij}$

左边的意思是：

- 卖价$v_j$
    
- 减去进价$-u_i$
    

也就是中间商在“供应商$i$买入，再卖给需求方$j$”这条链路上的**每单位毛利（unit gross margin）**。

右边是：

- 真实运输成本$c_{ij}$
    

所以这个约束是在说：

> 中间商每单位赚的钱，不能超过真实运输成本。

或者更准确地说：

> 若从$i$买、卖到$j$，那么“采购价 + 运输成本”至少要覆盖“销售价”，否则这套价格体系不现实。

---

## 1. 如果违反了会怎样

假如某一对$(i,j)$满足

$u_i + v_j > c_{ij}$

等价于

$v_j - (-u_i) > c_{ij}$

这意味着：

- 中间商从$i$买入的价格很低
    
- 卖给$j$的价格很高
    
- 中间差价竟然超过了真实运输成本
    

那就会出现套利（arbitrage-like opportunity）：

> 你完全可以绕开这套限制，直接走$i\to j$这条运输路径，然后获得“无风险超额利润”。

所以为了让这套价格体系是“可支持的（supportable）”，必须要求对所有路径都有：

$u_i + v_j \le c_{ij}$

---

# 六、为什么$u_i\le 0,\ v_j\ge 0$

这个其实和原问题约束方向有关，也和经济意义一致。

---

## 1. 从对偶符号规则看

原问题是最小化（minimization）问题：

- 对于“$\le$”型约束，双变量应满足“$\le 0$”
    
- 对于“$\ge$”型约束，双变量应满足“$\ge 0$”
    

所以：

- 供应约束$\sum_j x_{ij}\le s_i$对应$u_i\le 0$
    
- 需求约束$\sum_i x_{ij}\ge d_j$对应$v_j\ge 0$
    

这是标准对偶规则。

---

## 2. 从经济含义看

### 为什么$v_j\ge 0$

$v_j$可以看成需求点$j$的“边际价值（marginal value）”或“愿意支付价格（willingness to pay）”。

需求多 1 单位，一般不会让系统价值下降，所以它自然是非负的。

---

### 为什么$u_i\le 0$

$u_i$本身是带符号的对偶变量。  
真正更好理解的是$-u_i\ge 0$。

$-u_i$可以理解成供应点$i$的“采购价（purchase price）”或“资源价格（resource price）”。

因此：

- $u_i$本身非正
    
- 但$-u_i$非负
    

这和“买货总得花钱”是吻合的。

---

# 七、对偶的更深一层理解：它在给每个点标“势能 / 价格”

除了“中间商故事”，还有一个非常漂亮的数学直觉：

- 每个供应点$i$有一个势（potential）$u_i$
    
- 每个需求点$j$有一个势（potential）$v_j$
    

约束$u_i+v_j\le c_{ij}$的意思是：

> 任意一条边$(i,j)$上，这两个点的“价格和”不能超过这条边的真实运输成本。

所以对偶是在找一套尽量高的“节点价格（node prices）”，但又不能超过每条边的运输成本限制。

然后对偶目标  
$\sum_i s_i u_i + \sum_j d_j v_j$

是在用供给量$s_i$和需求量$d_j$对这些节点价格做加权，想把总价值尽量抬高。

所以从图论角度看：

> 原问题是在边上选流量（flows on edges）；  
> 对偶问题是在点上选价格（prices on nodes）。

这是运输问题 primal-dual 最经典的直观结构。

---

# 八、互补松弛（complementary slackness）如何直观理解

真正把原问题和对偶问题连起来的，是**互补松弛（complementary slackness）**。

在运输问题里，它最直观的那部分是：

如果$x_{ij}>0$，也就是路线$i\to j$真正被使用了，那么通常必须有

$u_i + v_j = c_{ij}$

为什么？

因为如果某条实际使用的路还满足严格不等式

$u_i + v_j < c_{ij}$

那就表示：

- 这条路的真实运输成本比“价格和”还高
    
- 这条路没有把这套价格体系“顶紧（tight）”
    

那么它往往不是当前最值得使用的路，或者说这套价格对它还有“松弛（slack）”。

所以：

> 真正被用到的运输路线，通常对应对偶约束取等号。  
> 没被用到的路线，则可以保留严格不等式。

这和你在线性规划里学过的一般互补松弛条件是完全一致的。

---

# 九、一个非常小的例子帮助你建立感觉

假设有两个供应商、两个需求方：

- 供应：$s_1=5,\ s_2=5$
    
- 需求：$d_1=4,\ d_2=6$
    

运输成本：

- $c_{11}=2,\ c_{12}=5$
    
- $c_{21}=4,\ c_{22}=1$
    

直观一看就知道：

- 从$s_1$到$d_1$很便宜，成本 2
    
- 从$s_2$到$d_2$很便宜，成本 1
    
- 另外两条路比较贵
    

所以最优运输会倾向于：

- 先让$s_1$尽量去满足$d_1$
    
- 先让$s_2$尽量去满足$d_2$
    
- 不够的再走贵路线
    

这就是原问题的直觉。

---

## 对偶怎么理解这个例子

对偶会尝试给出一组价格：

- 给$s_1,s_2$一个采购价
    
- 给$d_1,d_2$一个销售价
    

并且要求任意路径都满足：

$\text{销售价} - \text{采购价} \le \text{运费}$

例如，如果你想把$d_2$的售价定得特别高，那为了不违反  
$u_2+v_2\le c_{22}=1$，你就必须把供应商 2 那边的采购价也相应抬高或压低利润空间。

因此：

> 对偶是在所有运输边的成本限制下，找一套最“紧”的价格。

最终最优对偶解会让那些真正使用的便宜路线变成“紧边（tight edges）”，即满足等号。

---

# 十、为什么原问题最小化、对偶问题最大化，但最优值会相等

这正是对偶理论（duality theory）的核心。

原问题是在问：

> 真实地把货运过去，最少要花多少钱？

对偶问题是在问：

> 在不制造套利的前提下，最多能支撑起多大的内部价格总值？

如果一套价格体系能被真实运输网络支撑，那么它的总价值一定不能超过真实最低运输成本。  
所以总有：

$\sum_i s_i u_i + \sum_j d_j v_j \le \sum_{i,j} c_{ij}x_{ij}$

左边是对偶值，右边是原问题值。

当达到最优时，二者相等，这就是**强对偶（strong duality）**。

直观上就是：

> 最低真实运输成本  
> = 这张网络所能支撑的最高内部价格总额

---

# 十一、你可以怎样一句话记住这个运输问题

你可以把它压缩成两句话：

**原问题（primal）**：  
在满足供需的前提下，决定每条运输边运多少货，使总运费最小。

**对偶问题（dual）**：  
给每个供应点和需求点设一套内部价格，使任意一条运输边都不存在套利空间，并让这套价格体系的总价值最大。

---

# 十二、最后再给你一个“最直观”的图像版本

把整件事想成一个市场网络：

- 左边供应商手里有货
    
- 右边需求方愿意买货
    
- 中间每条边都有运输成本
    
- 原问题是在边上安排物流
    
- 对偶问题是在点上安排价格
    

并且：

- **边上的物流量**是$x_{ij}$
    
- **点上的价格势能**是$u_i,v_j$
    
- **边的成本上界**是$c_{ij}$
    
- **真正走的边**满足“价格和 = 成本”
    
- **没走的边**满足“价格和 < 成本”
    

这就是运输问题 primal-dual 结构最核心的直观图景。

---

如果你愿意，我下一条可以继续给你讲：

**“为什么运输问题的对偶变量能被理解为仓库价和客户价，以及互补松弛在图上怎么画出来”**。