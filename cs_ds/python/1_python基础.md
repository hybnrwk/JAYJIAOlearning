这两个 PPT 可以看成一条连续的路线：

> **第二章解决“Python 的基本语句怎么写” → 第三章解决“这些语句怎样组成程序逻辑”。**

第二章覆盖常量、变量、字符串、运算符、类型转换、`math`、注释和 PEP 8；第三章进一步进入 `if / elif / else`、`match / case`、`for / while`、`break / continue` 和海象运算符 `:=`。

你已经有其他语言基础，所以我不重点解释“变量是什么、循环是什么”，而重点讲 **Python 到底怎么写，以及哪些地方最容易因为沿用 C/C++/Java 的习惯而写错。**

---

# 一、先建立 Python 的“语法骨架”

学完这两章，你真正需要形成的是这个结构：

```python
# 1. 数据
x = 10
name = "Alice"

# 2. 表达式
y = x * 2 + 5

# 3. 判断
if y > 20:
    print("large")
elif y == 20:
    print("equal")
else:
    print("small")

# 4. 循环
for i in range(5):
    print(i)

while x > 0:
    x -= 1
```

和很多其他语言相比，Python 最核心的语法差异只有一句话：

> **Python 用 `:` + 缩进表示代码块，而不是 `{}`。**

比如 C++：

```cpp
if (x > 0) {
    cout << x;
}
```

Python：

```python
if x > 0:
    print(x)
```

注意四件事：

```python
if x > 0:
    print(x)
```

- `if` 后面通常不用括号；
    
- 条件后面必须有 `:`
    
- 下一行必须缩进；
    
- 通常缩进 **4 个空格**。
    

PPT 的 PEP 8 部分也明确要求每级缩进使用 4 个空格。

以后写 Python 出现：

```text
SyntaxError
IndentationError
```

第一时间检查的通常就是：

```text
冒号 :
括号 ()
引号 ""
缩进
```

---

# 二、第二章：Python 基础语法

## 1. Python 不需要先声明变量类型

C++：

```cpp
int age = 20;
double score = 95.5;
```

Python：

```python
age = 20
score = 95.5
```

Python 是**动态类型语言（dynamically typed language）**，变量在第一次赋值时出现，不需要提前写类型。一个变量甚至可以重新绑定到不同类型的对象。PPT 用 `age = 10` 再变为 `age = 10.5` 来说明这一点。

例如：

```python
x = 10
x = 3.14
x = "hello"
```

语法完全合法。

但实际写程序时不要故意这样乱改类型：

```python
score = 95
score = "hello"
```

虽然 Python 允许，但很容易造成后续错误。

---

# 三、变量名怎么写

合法：

```python
age = 20
student_name = "Tom"
_score = 95
x1 = 100
```

不合法：

```python
1x = 10
student-name = "Tom"
class = 1
```

原因分别是：

```text
不能数字开头
- 会被理解为减号
class 是 Python 关键字
```

PPT 给出的规则是：首字符只能是字母或下划线，之后可以包含字母、数字、下划线，并且大小写敏感。

所以：

```python
age = 20
Age = 30
```

是两个变量。

### 推荐写法

Python 一般用：

```python
student_name
total_score
interest_rate
```

这种叫 **snake_case（蛇形命名）**。

而不是：

```python
studentName
```

后者不算语法错误，只是不太符合 Python 风格。

---

# 四、赋值：这里和很多语言差别不大，但 Python 很灵活

## 4.1 普通赋值

```python
x = 10
y = x + 5
```

注意：

```python
=
```

是赋值。

而：

```python
==
```

才是比较相等。

这是之后 `if` 中最容易写错的地方。

PPT 也专门强调了这一点。

---

## 4.2 多变量赋值

Python 可以直接：

```python
x, y = 10, 20
```

等价于大致：

```python
x = 10
y = 20
```

PPT 给出的通用形式是：

```python
variable_1, ..., variable_N = expression_1, ..., expression_N
```

右边的值依次赋给左边。

这个特性特别重要，因为以后 Python 代码经常这么写。

例如交换变量：

```python
a, b = b, a
```

不需要：

```python
temp = a
a = b
b = temp
```

---

## 4.3 连续赋相同值

PPT 没重点展开，但你需要知道：

```python
a = b = c = 0
```

是合法的。

---

# 五、数字类型

PPT 主要讲三种：

```python
int
float
complex
```

例如：

```python
a = 10
b = 3.14
c = 2 + 3j
```

Python 的复数虚部写：

```python
j
```

不是：

```python
i
```

PPT 对整数、浮点数和复数的形式进行了说明。

---

# 六、Python 的除法一定要分清

这是非常容易从 C/C++ 带错习惯的地方。

## 6.1 `/`：普通除法

```python
5 / 2
```

结果：

```python
2.5
```

即使两个操作数都是 `int`，结果仍然可以是浮点数。

---

## 6.2 `//`：整除 / floor division

```python
5 // 2
```

得到：

```python
2
```

PPT 将 `//` 定义为向下取整的整除。

注意负数：

```python
-5 // 2
```

得到：

```python
-3
```

因为它是：

> 向负无穷取整

而不是单纯“砍掉小数”。

---

## 6.3 `%`：取模

```python
8 % 5
```

结果：

```python
3
```

非常常用于：

```python
if year % 4 == 0:
```

以及：

```python
if n % 2 == 0:
```

---

## 6.4 `**`：乘方

Python：

```python
2 ** 3
```

结果：

```python
8
```

不要写：

```python
2 ^ 3
```

因为：

```python
^
```

在 Python 里是**按位异或 XOR**。

这是非常常见的错误。

---

# 七、自增没有 `++`

如果你来自 C/C++/Java，尤其注意：

```python
i++
```

❌ Python 不支持。

应该：

```python
i += 1
```

同理：

```python
x -= 1
x *= 2
x /= 2
```

都可以。

---

# 八、字符串是 Python 初学语法的一个重点

PPT 把字符串定义为不可变的字符序列，并介绍了单引号、双引号和三引号。

## 8.1 单引号和双引号都可以

```python
name = 'Alice'
name = "Alice"
```

两者基本没有区别。

例如字符串内部有 `'`：

```python
text = "I'm Tom"
```

就比较方便。

如果一定要：

```python
text = 'I\'m Tom'
```

也可以。

---

# 九、三引号

```python
text = """hello
world
python"""
```

或者：

```python
text = '''hello
world'''
```

适合多行字符串。

---

# 十、转义字符

最常用的三个：

```python
\n
\t
\\
```

例如：

```python
print("Hello\nWorld")
```

输出：

```text
Hello
World
```

而：

```python
print("A\tB")
```

表示 Tab。

PPT 还特别介绍了 **raw string（原始字符串）**。

例如：

```python
path = r"C:\new\test"
```

其中：

```python
r"..."
```

告诉 Python：

> 尽量把反斜杠当普通字符。

这对 Windows 路径特别有用。

否则：

```python
"C:\new\test"
```

里面的：

```text
\n
\t
```

可能会被当成换行和 Tab。

---

# 十一、字符串格式化：至少会两种

PPT 重点讲：

```python
str.format()
```

例如：

```python
name = "Alice"
age = 20

print("My name is {}, and I am {}.".format(name, age))
```

占位符：

```python
{}
```

按顺序接收参数。

---

## 11.1 指定位置

```python
print("{0} + {1} = {2}".format(10, 20, 30))
```

输出：

```text
10 + 20 = 30
```

---

# 十二、格式控制必须看懂

例如：

```python
"{:.2f}".format(3.1415926)
```

得到：

```text
3.14
```

拆开：

```text
:
.2
f
```

含义：

```text
:     开始格式控制
.2    保留 2 位小数
f     浮点形式
```

PPT 还给出了左右/居中对齐、填充、千位分隔符和百分比。

你现阶段最需要熟悉：

```python
"{:.2f}".format(x)
```

和：

```python
"{:.2%}".format(x)
```

例如：

```python
x = 0.756
print("{:.2%}".format(x))
```

输出：

```text
75.60%
```

---

# 十三、实际编程更推荐掌握 f-string

虽然 PPT 主要讲 `.format()`，第三章例子里其实已经用了：

```python
print(f"你输入了：{n}")
```

现代 Python 中经常写：

```python
name = "Alice"
age = 20

print(f"My name is {name}, age = {age}")
```

保留两位小数：

```python
pi = 3.1415926

print(f"{pi:.2f}")
```

这个建议你直接熟练。

---

# 十四、数据类型转换：`input()` 是最大坑之一

PPT 介绍：

```python
int(x)
float(x)
complex(re, im)
```

但这里最重要的一条是：

> **`input()` 返回的一定是字符串 `str`。**

比如：

```python
age = input("请输入年龄：")
```

即使输入：

```text
20
```

此时：

```python
age
```

仍是：

```python
"20"
```

而不是：

```python
20
```

所以数学运算前需要：

```python
age = int(input("请输入年龄："))
```

或者：

```python
score = float(input("请输入成绩："))
```

PPT 的汇率案例也是这样处理：

```python
usd_amount = float(input(...))
```

### 一个非常典型的错误

```python
x = input()
print(x + 1)
```

会报：

```text
TypeError
```

应该：

```python
x = int(input())
print(x + 1)
```

---

# 十五、布尔值必须大写

Python 写：

```python
True
False
None
```

不是：

```python
true
false
null
```

PPT 的保留字表中也明确列出了 `True`、`False` 和 `None`。

---

# 十六、比较运算

基本形式：

```python
<
>
<=
>=
==
!=
```

例如：

```python
age >= 18
score == 100
x != 0
```

PPT 对这些关系运算符进行了完整列举。

---

# 十七、逻辑运算不是 `&& || !`

如果你以前写：

```cpp
x > 0 && x < 10
```

Python 写：

```python
x > 0 and x < 10
```

对应关系：

| C/C++/Java | Python |
| ---------- | ------ |
| `&&`       | `and`  |
| `          |        |
| `!`        | `not`  |

例如：

```python
if age >= 18 and age <= 60:
    print("working age")
```

也可以写成 Python 很有特色的：

```python
if 18 <= age <= 60:
    print("working age")
```

后者很常见。

---

# 十八、`is` 和 `==` 千万不要混

这是 PPT 专门用了两页讲的内容。

## `==`

比较：

> 值是否相等。

```python
a = [1, 2]
b = [1, 2]

print(a == b)
```

结果：

```python
True
```

---

## `is`

比较：

> 是不是同一个对象。

```python
print(a is b)
```

通常：

```python
False
```

因此正常业务代码里：

```python
if x == 10:
```

用 `==`。

而判断 `None` 通常：

```python
if x is None:
```

不要写成：

```python
if x == None:
```

虽然很多情况下也能工作，但标准写法是：

```python
x is None
```

---

# 十九、数学函数

Python 有一些直接可用的 built-in functions：

```python
abs(-10)
round(3.1415, 2)
max(1, 5, 3)
min(1, 5, 3)
pow(2, 3)
divmod(21, 5)
```

PPT 给出的 `divmod(21, 5)` 返回：

```python
(4, 1)
```

即：

```text
商 = 4
余数 = 1
```

---

# 二十、模块导入：必须理解两种写法

PPT 使用：

```python
from math import sqrt
```

然后：

```python
sqrt(25)
```

还有另一种非常常见：

```python
import math
```

这时必须写：

```python
math.sqrt(25)
math.pi
math.sin(x)
```

区别：

### 写法 1

```python
import math

x = math.sqrt(25)
```

### 写法 2

```python
from math import sqrt

x = sqrt(25)
```

不要混：

```python
from math import sqrt
math.sqrt(25)
```

这里没有导入名字 `math`，所以会报错。

---

# 二十一、注释

单行：

```python
# 这是注释
x = 10  # 这里也可以
```

PPT 还把三引号形式介绍为多行注释。

严格来说：

```python
"""
hello
world
"""
```

本质是一个**字符串字面量**，并不是专门的“注释语法”。

如果放在函数、类、模块开头，还可能成为 **docstring（文档字符串）**。

所以真正写普通注释时，推荐：

```python
# 第一行说明
# 第二行说明
```

---

# 二十二、现在进入第三章：最关键的是“代码块”

第三章把程序逻辑总结为：

```text
顺序
分支
循环
```

Python 在这三个结构中最大的统一规则就是：

```text
冒号 + 缩进
```

---

# 二十三、`if` 的完整语法

```python
if condition1:
    statement1
elif condition2:
    statement2
else:
    statement3
```

PPT 给出的结构也是这一形式。

注意：

```python
elif
```

是一个单词。

不是：

```python
else if
```

---

# 二十四、`if` 最常见的 5 种语法错误

### 错误 1：忘记冒号

```python
if x > 0
    print(x)
```

❌

正确：

```python
if x > 0:
    print(x)
```

---

### 错误 2：用 `=`

```python
if x = 10:
```

❌

正确：

```python
if x == 10:
```

---

### 错误 3：没有缩进

```python
if x > 0:
print(x)
```

❌

应该：

```python
if x > 0:
    print(x)
```

---

### 错误 4：写 `else if`

```python
else if x > 10:
```

❌

正确：

```python
elif x > 10:
```

---

### 错误 5：给 `else` 加条件

```python
else x < 0:
```

❌

`else` 后没有条件：

```python
else:
```

---

# 二十五、多分支的判断顺序非常重要

PPT 的朝代例子：

```python
if year < 581:
    dynasty = "隋之前朝代"
elif year < 618:
    dynasty = "隋朝"
elif year < 907:
    dynasty = "唐朝"
elif year < 960:
    dynasty = "五代十国"
else:
    dynasty = "五代十国之后朝代"
```

为什么第二个只写：

```python
year < 618
```

不用：

```python
581 <= year < 618
```

因为进入：

```python
elif
```

意味着前面的：

```python
year < 581
```

已经是 False。

所以自然得到：

```text
year >= 581
```

这说明 `if → elif → elif → else` 是：

> **从上到下判断，第一个满足条件的分支执行后，其余全部跳过。**

---

# 二十六、Python 的 truth value

条件不一定非得写：

```python
x == True
```

通常直接：

```python
if x:
```

一些常见假值：

```python
False
None
0
0.0
""
[]
{}
set()
```

例如：

```python
name = ""

if name:
    print("有名字")
else:
    print("空字符串")
```

---

# 二十七、`match-case`

Python 3.10 开始支持 **structural pattern matching（结构化模式匹配）**。PPT 将其类比为其他语言中的 `switch-case`。

最简单：

```python
code = 404

match code:
    case 200:
        print("OK")
    case 404:
        print("Not Found")
    case 500:
        print("Server Error")
    case _:
        print("Unknown")
```

其中：

```python
case _:
```

相当于：

```text
default
```

---

## 多个候选值

PPT 示例：

```python
match color:
    case "red" | "yellow" | "blue":
        print("这是三原色之一")
```

注意这里用：

```python
|
```

不是：

```python
or
```

---

# 二十八、`for`：Python 的 for 本质不是传统 C-style for

C/C++：

```cpp
for (int i = 0; i < 5; i++)
```

Python：

```python
for i in range(5):
    print(i)
```

Python 的 `for` 本质是：

> **从一个 iterable（可迭代对象）里依次取元素。**

PPT 说明它可以遍历列表、元组、字符串、生成器等。

例如：

```python
for x in [10, 20, 30]:
    print(x)
```

或者：

```python
for ch in "Python":
    print(ch)
```

---

# 二十九、`range()` 必须彻底掌握

## `range(stop)`

```python
range(5)
```

表示：

```text
0 1 2 3 4
```

不是：

```text
0 1 2 3 4 5
```

因为：

> `stop` 不包含。

---

## `range(start, stop)`

```python
range(1, 5)
```

得到：

```text
1 2 3 4
```

---

## `range(start, stop, step)`

```python
range(1, 10, 2)
```

得到：

```text
1 3 5 7 9
```

PPT 对这三个参数的含义也进行了明确说明。

---

# 三十、倒序 range

你也需要知道：

```python
for i in range(5, 0, -1):
    print(i)
```

得到：

```text
5
4
3
2
1
```

如果你写：

```python
range(5, 0)
```

什么都不会执行，因为默认步长是 `+1`。

---

# 三十一、`while`

基本结构：

```python
while condition:
    statements
```

PPT 强调：

> 条件为 `True` 时继续执行，为 `False` 时停止。

例如：

```python
i = 0

while i < 5:
    print(i)
    i += 1
```

---

# 三十二、死循环

最典型：

```python
i = 0

while i < 5:
    print(i)
```

因为：

```python
i
```

永远没有变化。

正确：

```python
while i < 5:
    print(i)
    i += 1
```

或者有时故意：

```python
while True:
```

再通过：

```python
break
```

退出。

---

# 三十三、`break`

PPT 的定义非常准确：

> 一旦执行 `break`，立即跳出当前循环。

例如：

```python
while True:
    text = input("请输入：")

    if text == "exit":
        break

    print(text)
```

执行：

```python
break
```

以后，整个：

```python
while
```

结束。

---

# 三十四、`continue`

`continue` 是：

> 本轮剩余代码不执行，直接进入下一轮。

PPT 用输入英文字符串的例子展示了这一点。

例如：

```python
for i in range(5):
    if i == 2:
        continue

    print(i)
```

结果：

```text
0
1
3
4
```

---

# 三十五、`break` 和 `continue` 的区别

把这两个牢记：

```text
break
↓
整个循环结束

continue
↓
只结束当前这一轮
```

例如：

```python
for i in range(10):
    if i == 3:
        continue
    if i == 7:
        break
    print(i)
```

执行过程：

```text
0 → 打印
1 → 打印
2 → 打印
3 → continue
4 → 打印
5 → 打印
6 → 打印
7 → break
```

最终：

```text
0
1
2
4
5
6
```

---

# 三十六、Python 特有的 `for-else`

PPT 介绍了：

```python
for ...:
    ...
else:
    ...
```

以及：

```python
while ...:
    ...
else:
    ...
```

它和 `if-else` 完全不是一回事。

核心规则：

> **循环如果没有因为 `break` 而退出，就执行 `else`。**

例如：

```python
for i in range(5):
    print(i)
else:
    print("正常结束")
```

会打印：

```text
正常结束
```

但是：

```python
for i in range(5):
    if i == 3:
        break
else:
    print("正常结束")
```

这里：

```python
else
```

不会执行。

---

# 三十七、这个语法最常用在哪？——找东西

```python
for x in numbers:
    if x == target:
        print("找到了")
        break
else:
    print("没找到")
```

逻辑：

```text
找到
→ break
→ 不执行 else

始终没找到
→ 循环正常结束
→ 执行 else
```

---

# 三十八、海象运算符 `:=`

PPT 专门介绍了 **Walrus Operator（海象运算符）**。

普通赋值：

```python
n = 10
```

使用：

```python
=
```

赋值表达式：

```python
(n := 10)
```

不仅赋值，而且整个表达式还有值。

典型：

```python
while (n := int(input("输入数字："))) > 0:
    print(n)
```

相当于：

```python
n = int(input("输入数字："))

while n > 0:
    print(n)
    n = int(input("输入数字："))
```

现在知道即可，不建议为了“高级”而到处用 `:=`。

---

# 三十九、一个非常重要的 Python 细节：`if/for/while` 不创建局部作用域

PPT 中有一些“代码块作用域”的表述，需要你在真正写 Python 时区分清楚。

Python：

```python
if True:
    x = 10

print(x)
```

是合法的：

```text
10
```

同样：

```python
for i in range(5):
    x = i

print(x)
```

也可以访问 `x`。

真正典型的局部作用域来自：

```python
def
class
```

尤其是函数。

所以不要套用 C++：

```cpp
{
    int x;
}
```

那种 block scope 思维。

PPT 后面将作用域分成局部和全局两类。

---

# 四十、Fibonacci 案例里有一个非常 Pythonic 的语法

PPT：

```python
x1, x2 = 0, 1

while x2 < 100:
    print(x2)
    x1, x2 = x2, x1 + x2
```

最值得你学的是：

```python
x1, x2 = x2, x1 + x2
```

右边先整体求值，再赋值。

假设原来：

```text
x1 = 3
x2 = 5
```

右侧首先得到：

```python
5, 8
```

然后：

```python
x1 = 5
x2 = 8
```

不是先把 `x1` 改成 5 再计算第二项。

---

# 四十一、Monte Carlo 案例可以把前两章语法串起来

PPT 的代码：

```python
from random import random
from math import sqrt

n = 10000
count_in_circle = 0

for i in range(0, n):
    x, y = random(), random()
    dist = sqrt(x**2 + y**2)

    if dist <= 1:
        count_in_circle += 1

pi = 4 * count_in_circle / n

print("Pi's value is", pi)
```

你可以把它当成这两个 PPT 的综合语法模板：

```text
from ... import ...
        ↓
导入函数

变量 = 值
        ↓
变量与赋值

for ... in range(...):
        ↓
循环

x, y = ...
        ↓
多变量赋值

x ** 2
        ↓
乘方

if dist <= 1:
        ↓
分支

+=
        ↓
增量赋值

/
        ↓
普通除法
```

---

# 四十二、现在给你一张“其他语言 → Python”语法转换表

|你可能熟悉的写法|Python|
|---|---|
|`{ ... }`|缩进|
|`;`|通常不写|
|`else if`|`elif`|
|`&&`|`and`|
|`||
|`!x`|`not x`|
|`true`|`True`|
|`false`|`False`|
|`null`|`None`|
|`x++`|`x += 1`|
|`x--`|`x -= 1`|
|`^` 表示乘方|❌|
|`x ** y`|乘方|
|`switch`|`match`|
|`default`|`case _`|
|`for(i=0;i<n;i++)`|`for i in range(n)`|
|字符/字符串明显区分|Python 都主要用 `str`|
|`scanf/cin` 得到数字|`input()` 默认得到 `str`|
|`int x = 1`|`x = 1`|

---

# 四十三、考试/作业最容易出现的语法错误，我建议你逐条检查

以后写完代码，用下面这张 checklist。

### ① `if / elif / else`

必须：

```python
if condition:
    ...
elif condition:
    ...
else:
    ...
```

检查：

```text
有没有 :
有没有正确缩进
elif 有没有写成 else if
== 有没有写成 =
```

---

### ② `for`

模板：

```python
for variable in iterable:
    ...
```

最常见：

```python
for i in range(n):
```

检查：

```text
有没有 in
有没有 :
range(n) 是 0 ~ n-1
```

---

### ③ `while`

模板：

```python
while condition:
    ...
```

检查：

```text
有没有 :
循环条件是否可能变成 False
否则可能死循环
```

---

### ④ 输入数字

不要：

```python
x = input()
x + 1
```

应该：

```python
x = int(input())
```

或：

```python
x = float(input())
```

---

### ⑤ 判断相等

```python
x == 10
```

而不是：

```python
x = 10
```

---

### ⑥ 判断 None

推荐：

```python
x is None
```

---

### ⑦ 乘方

```python
x ** 2
```

不是：

```python
x ^ 2
```

---

### ⑧ 自增

```python
i += 1
```

没有：

```python
i++
```

---

### ⑨ 模块

如果：

```python
import math
```

写：

```python
math.sqrt(4)
```

如果：

```python
from math import sqrt
```

写：

```python
sqrt(4)
```

---

### ⑩ 缩进

正确：

```python
if x > 0:
    print(x)
    x += 1

print("end")
```

这里：

```python
print("end")
```

已经退出 `if`。

Python **缩进本身就是程序结构的一部分**。

---

# 四十四、这两个 PPT 你真正应该掌握到什么程度

如果目标是“到时候自己写代码基本不犯 Python 基础语法错误”，这两章不用平均用力。我建议你的掌握优先级是：

### 第一层：必须写得非常熟

```python
变量赋值
int / float / str
input / print
+ - * / // % **
== != < <= > >=
and / or / not
if / elif / else
for
range
while
break
continue
import
缩进
```

这些最好做到不用查。

### 第二层：看得懂并会写

```python
多变量赋值
.format()
f-string
is / is not
math
for-else
match-case
```

### 第三层：目前知道即可

```python
complex
位运算
walrus :=
.pyc / PVM
较复杂的 format 对齐
```

---

# 四十五、最后把这两章压缩成一个完整程序

下面这个程序基本把你这两个 PPT 的核心语法全部串起来：

```python
from math import sqrt

count = 0

while True:
    text = input("请输入一个非负整数，输入 exit 退出：")

    if text == "exit":
        break

    n = int(text)

    if n < 0:
        print("请输入非负整数")
        continue

    count += 1

    if n == 0:
        print("数字为 0")

    elif n % 2 == 0:
        print(f"{n} 是偶数")
        print(f"平方根为 {sqrt(n):.2f}")

    else:
        print(f"{n} 是奇数")

print(f"一共成功处理了 {count} 个数字")
```

你现在应该能够直接读懂：

```python
from math import sqrt
```

导入函数。

```python
count = 0
```

变量赋值。

```python
while True:
```

无限循环。

```python
text = input(...)
```

输入字符串。

```python
if text == "exit":
    break
```

满足条件退出整个循环。

```python
n = int(text)
```

字符串转整数。

```python
if n < 0:
    continue
```

负数直接跳过当前这一轮。

```python
count += 1
```

自增。

```python
n % 2 == 0
```

判断偶数。

```python
sqrt(n)
```

调用导入的函数。

```python
f"{sqrt(n):.2f}"
```

f-string，并保留两位小数。

---

## 这两章最核心的一句话

你已有其他语言基础，所以 Python 基础真正需要重新建立的不是“什么叫循环”，而是这一套**Python-specific syntax**：

```text
不写类型声明
不写 {}
代码块靠 :
代码块靠缩进
elif 而不是 else if
and/or/not 而不是 &&/||/!
True/False/None 首字母大写
input() 返回 str
for 遍历 iterable
range 的右端点不包含
没有 ++
** 才是乘方
== 比值，is 比对象身份
break 退出循环
continue 跳过本轮
```

把这一套形成肌肉记忆之后，这两个 PPT 中真正容易造成 **SyntaxError / IndentationError 或基础逻辑错误** 的部分基本就覆盖完整了。