# SQL 数据分析面试系统笔记

> 适用目标：数据分析、商业分析、数据运营、数据产品、增长分析等岗位的 SQL 面试准备。  
> 学习目标：不仅会写语法，还要能把业务问题拆成“数据表、粒度、筛选、聚合、关联、窗口、指标口径”的查询方案。

> 使用建议：这份笔记不要按“背语法”的方式读，而要按“业务题拆解”的方式读。看到一道题，先判断结果要按什么粒度输出，再决定从哪张表开始查、要不要去重、要不要保留没有行为的人、最后再写 SQL。这样比单纯记函数更接近真实面试。

---

## 一、数分岗位为什么重视 SQL

SQL 是数据分析岗位最基础、最常被考察的硬技能。原因很直接：真实公司的业务数据通常存放在数据库、数仓或数据湖表中，分析师每天要做的事情，往往不是先建复杂模型，而是先把数据取对、算准、解释清楚。

在面试中，SQL 考察通常有三层：

第一层是基础语法。包括 `SELECT`、`FROM`、`WHERE`、`GROUP BY`、`HAVING`、`ORDER BY`、`LIMIT`、`JOIN`、子查询、窗口函数等。

第二层是数据分析思维。包括指标口径、统计粒度、去重逻辑、时间范围、分母分子、用户生命周期、留存、转化、复购、连续活跃、TopN、分层对比等。

第三层是工程意识。包括 NULL 处理、重复数据处理、日期函数差异、类型转换、查询性能、索引意识、数仓分区、避免笛卡尔积、避免错误聚合等。

很多候选人会背语法，但一到业务题就卡住。根本原因是没有把 SQL 当成“业务问题到数据结果的翻译器”。面试时你要先明确：问题问的对象是谁，时间范围是什么，统计粒度是什么，分母和分子分别是什么，是否需要去重，是否需要多表关联，最后结果按什么维度展示。

补充理解：数分岗位考 SQL，本质上不是考你能不能写出很复杂的语法，而是考你能不能把一个模糊的业务问题变成清楚的数据口径。例如“用户转化率下降了”这句话本身不能直接写 SQL，你需要先拆成：转化率指哪一步到哪一步，分母是曝光用户还是访问用户，分子是点击用户还是支付用户，时间范围是当天还是一周，用户是否去重，是否按渠道、城市、版本拆分。只有这些想清楚，SQL 才有意义。

面试中建议形成一个固定回答习惯：先说口径，再写 SQL，最后补充风险点。这样可以让面试官看到你的分析意识，而不是只看到代码能力。

---

## 二、数据库与 SQL 的基础概念

数据库是按一定结构组织起来的数据集合。日常说的 MySQL、PostgreSQL、SQL Server、Oracle，严格说是 DBMS，也就是数据库管理系统。数据库负责存储数据，DBMS 负责管理数据，SQL 是我们和 DBMS 沟通的语言。

关系型数据库把数据组织成一张张表。表由行和列组成：

- 表：结构化的数据文件，例如 `users`、`orders`、`events`。
- 行：一条记录，例如一个用户、一笔订单、一次点击。
- 列：字段，例如 `user_id`、`order_date`、`amount`。
- 数据类型：限制列中能存什么，例如整数、字符串、日期、小数。
- 主键：唯一标识一行数据的字段，例如用户表中的 `user_id`。
- 外键：用于连接两张表的字段，例如订单表中的 `user_id` 对应用户表中的 `user_id`。
- NULL：缺失值，不等于 0，不等于空字符串，也不能用 `= NULL` 判断。

一个典型业务库可能有这些表：

```text
users(user_id, name, gender, city, register_date)
orders(order_id, user_id, product_id, amount, order_date, status)
products(product_id, category, price)
events(user_id, event_type, event_time, device_id)
```

在数分面试里，最常见的不是让你创建复杂数据库，而是给你几张业务表，让你写 SQL 算指标。

补充理解：看到表结构时，第一反应不要是“我要用什么函数”，而是先判断每张表的粒度。比如 `users` 通常是一行一个用户，`orders` 通常是一行一笔订单，`events` 通常是一行一次行为。粒度决定了后续能不能直接 `COUNT(*)`、能不能直接 `SUM(amount)`、JOIN 后会不会重复。如果粒度判断错，即使 SQL 能跑，结果也可能是错的。

还要注意，真实公司里的表经常分为事实表和维度表。事实表记录行为，例如订单、点击、播放、支付；维度表记录属性，例如用户城市、商品品类、渠道、版本。数分 SQL 最常见的模式就是“事实表负责算行为，维度表负责补属性”。

---

补充讲解：在真实大厂 SQL 面试里，表名经常不是简单的 `users`、`orders`，而是类似 `dwd_user_action_di`、`dws_user_pay_1d`、`ads_growth_dashboard` 这种数仓表名。看到这类表名时，可以先大致判断它的层级和粒度：

```text
ods：原始层，接近业务库原表，字段可能脏、重复多
 dwd：明细层，一般是一行一条业务事实，例如一笔订单、一次点击
 dws：汇总层，一般已经按用户、商品、日期等粒度聚合
 ads：应用层，通常服务某个报表或业务专题
```

其中后缀也很重要：

```text
_di：增量表，通常表示当天新增或当天发生的数据
_df：全量快照表，通常表示截至某天的全量状态
_1d：按天汇总
_nd：近 N 天汇总
_td：截至当天累计
```

例如：

```text
dwd_order_detail_di：订单明细增量表，一行可能是一条订单明细
dws_user_pay_1d：用户支付日汇总表，一行可能是一个用户一天的支付汇总
ads_user_retention_dashboard：给留存看板使用的应用层结果表
```

这部分不一定要求你背数仓规范，但面试时要有意识：**先判断表的粒度，再决定能不能直接聚合**。如果表已经是用户日粒度，再按用户和日期重复 `COUNT(*)` 可能就不等价于行为次数；如果表是订单明细粒度，直接 `COUNT(order_id)` 可能会把一个订单的多条商品明细算成多单。

---

## 三、SQL 查询的基本结构与执行顺序

一条典型查询长这样：

```sql
SELECT
    字段或表达式
FROM 表名
WHERE 行级筛选条件
GROUP BY 分组字段
HAVING 分组后的筛选条件
ORDER BY 排序字段
LIMIT 返回行数;
```

书写顺序和逻辑执行顺序不完全一样。通常可以这样理解：

```text
FROM / JOIN
WHERE
GROUP BY
HAVING
SELECT
ORDER BY
LIMIT
```

这个顺序非常关键。比如 `WHERE` 发生在分组前，所以不能在 `WHERE` 里直接写 `COUNT(*) > 10`。分组后的条件要写在 `HAVING` 中。

示例：

```sql
SELECT
    city,
    COUNT(*) AS user_cnt
FROM users
WHERE register_date >= '2026-01-01'
GROUP BY city
HAVING COUNT(*) >= 100
ORDER BY user_cnt DESC;
```

含义是：先从用户表中筛选 2026 年以来注册的用户，再按城市分组，统计每个城市用户数，保留用户数至少 100 的城市，最后按用户数降序排序。

补充理解：执行顺序最容易影响三类写法。第一，`WHERE` 里不能直接使用聚合结果，因为聚合还没有发生。第二，`WHERE` 里很多时候不能直接使用 `SELECT` 里起的别名，因为别名在逻辑上通常是在 `SELECT` 阶段才产生。第三，`ORDER BY` 往往可以使用别名，因为排序发生在 `SELECT` 之后。

所以遇到报错不要只看语法，要回到执行顺序判断：这个字段或指标在当前阶段是否已经存在。复杂 SQL 建议用 CTE 把中间结果先算出来，再在外层筛选，这样更清晰，也更适合面试展示。

---

## 四、基础查询：SELECT、FROM、别名、去重、计算字段

`SELECT` 决定最终展示什么字段，`FROM` 决定数据来自哪张表。

```sql
SELECT user_id, name, city
FROM users;
```

查询全部字段可以写：

```sql
SELECT *
FROM users;
```

但真实工作中不建议随便使用 `*`。原因是字段太多会影响可读性和性能，表结构变化也可能让结果不可控。

别名用 `AS`：

```sql
SELECT
    user_id AS 用户ID,
    name AS 用户名
FROM users;
```

SQL 关键词一般不区分大小写，但建议关键词大写、表名字段名小写，这样面试时更清晰。

去重用 `DISTINCT`：

```sql
SELECT DISTINCT city
FROM users;
```

注意：

```sql
SELECT DISTINCT city, gender
FROM users;
```

这里去重的是 `(city, gender)` 组合，不是只对 `city` 去重。

计算字段是数分 SQL 高频用法。例如订单表有订单金额和成本，想算利润：

```sql
SELECT
    order_id,
    amount,
    cost,
    amount - cost AS profit
FROM orders;
```

如果要算客单价、转化率、留存率，本质上也是构造计算字段。

补充理解：`SELECT` 后面写什么，代表你最终想展示什么。真实分析中不建议一上来 `SELECT *`，因为这样容易把问题做散。更好的习惯是先想清楚结果表应该长什么样：比如“每天一行，包含日期、活跃用户数、下单用户数、转化率”；或者“每个城市一行，包含城市、用户数、GMV、客单价”。结果表结构想清楚后，SQL 的方向会稳定很多。

`DISTINCT` 也不要滥用。它能去重，但也可能掩盖 JOIN 膨胀或数据重复的问题。面试里如果你用了 `DISTINCT`，最好说明你去重的对象是什么，例如“这里按 `user_id, date` 去重，是因为同一用户一天可能有多次活跃记录，但留存分母要求用户天粒度”。

---

## 五、WHERE 条件筛选

`WHERE` 用于筛选行。常见条件包括比较、范围、集合、模糊匹配、空值判断。

```sql
SELECT *
FROM orders
WHERE amount > 100;
```

多个条件：

```sql
SELECT *
FROM orders
WHERE amount > 100
  AND status = 'paid';
```

范围筛选：

```sql
SELECT *
FROM orders
WHERE order_date BETWEEN '2026-01-01' AND '2026-01-31';
```

集合筛选：

```sql
SELECT *
FROM users
WHERE city IN ('上海', '北京', '深圳');
```

模糊匹配：

```sql
SELECT *
FROM products
WHERE product_name LIKE '%会员%';
```

NULL 判断必须用：

```sql
SELECT *
FROM users
WHERE gender IS NULL;
```

不能写：

```sql
WHERE gender = NULL
```

这是 SQL 初学者高频错误。NULL 代表未知，任何值和未知比较都不是普通的真或假。

面试里 `WHERE` 最重要的是时间范围和口径筛选。比如“统计 8 月复旦用户练题情况”，你要先筛选学校、月份，再统计题目数、答题次数、正确次数等。

补充理解：`WHERE` 决定的是“哪些明细行有资格进入计算”。很多指标错误不是聚合函数写错，而是 `WHERE` 口径没筛对。例如 GMV 通常要排除取消订单、退款订单、测试订单；活跃用户可能要排除爬虫、异常设备、内部账号；练题情况可能要排除无效提交。面试题不一定把这些都说出来，但你可以主动补充“这里默认只统计有效状态，如果业务表里有取消、退款或测试数据，需要在 `WHERE` 中排除”。

时间范围建议优先使用左闭右开：`>= 开始日期` 且 `< 下一个周期开始日期`。这样对日期字段和时间戳字段都更稳，不容易漏掉当天 23:59:59 之后的小数秒记录。

---

## 六、排序、限制行数与 TopN 基础

排序用 `ORDER BY`：

```sql
SELECT *
FROM orders
ORDER BY amount DESC;
```

`ASC` 是升序，`DESC` 是降序。默认通常是升序。

限制返回条数：

```sql
SELECT *
FROM orders
ORDER BY amount DESC
LIMIT 10;
```

这可以查订单金额最高的 10 笔订单。

但注意：如果题目要求“每个城市订单金额最高的 3 个用户”，不能只用全局 `ORDER BY ... LIMIT 3`。这类题需要窗口函数，后面会讲。

补充理解：`ORDER BY ... LIMIT` 解决的是全局 TopN，例如全站 GMV 最高的 10 个商品。如果题目出现“每个”“各个”“分组内”“每月”“每个城市”这类词，通常就是分组 TopN，需要先按分组字段聚合，再用窗口函数在每个组内排名。判断方法很简单：如果最后希望每个组都各自有前 N 名，就不能只用一个全局 `LIMIT`。

---

## 七、聚合函数与 GROUP BY

聚合函数用于把多行数据汇总成一个结果。

常见聚合函数：

```sql
COUNT(*)          -- 统计行数
COUNT(col)        -- 统计 col 非 NULL 的行数
COUNT(DISTINCT x) -- 去重计数
SUM(amount)       -- 求和
AVG(amount)       -- 平均值
MAX(amount)       -- 最大值
MIN(amount)       -- 最小值
```

示例：统计订单总数和 GMV：

```sql
SELECT
    COUNT(*) AS order_cnt,
    SUM(amount) AS gmv
FROM orders
WHERE status = 'paid';
```

分组统计：

```sql
SELECT
    city,
    COUNT(*) AS user_cnt
FROM users
GROUP BY city;
```

分组后筛选：

```sql
SELECT
    user_id,
    COUNT(*) AS order_cnt
FROM orders
GROUP BY user_id
HAVING COUNT(*) >= 3;
```

`WHERE` 和 `HAVING` 的区别：

- `WHERE`：分组前过滤明细行。
- `HAVING`：分组后过滤聚合结果。

常见错误：

```sql
SELECT city, name, COUNT(*)
FROM users
GROUP BY city;
```

如果 `name` 既没有聚合，也不在 `GROUP BY` 中，标准 SQL 下是不合法或语义不清的。分组查询里，`SELECT` 后面只能放分组字段或聚合表达式。

补充理解：`GROUP BY` 的核心不是“按字段分类”这么简单，而是把明细表压缩成某个粒度的汇总表。比如 `GROUP BY city` 之后，结果粒度就是“一行一个城市”；`GROUP BY user_id, date` 之后，结果粒度就是“一行一个用户一天”。只要发生了分组，所有没有被分组的明细字段都会失去唯一含义，所以不能随便放在 `SELECT` 中。

写分组题前建议先用一句话确认粒度：最终结果是一行一个什么？如果这句话说不清，SQL 很容易写乱。

---

补充讲解：`GROUP BY` 题真正要训练的是“结果粒度”意识。面试题如果问“每个城市的 GMV”，最后结果粒度就是一行一个城市；如果问“每个城市每天的 GMV”，结果粒度就是一行一个城市加一天；如果问“每个用户每月消费金额”，结果粒度就是一行一个用户加一个月份。

建议你写分组题时先在草稿里写一句：

```text
最终粒度 = 维度字段组合
```

例如：

```text
每月每品类 GMV：最终粒度 = month + category
每个学校 GPA 最低学生：最终粒度 = school + student，且要先在 school 内排名
每个用户的首单时间：最终粒度 = user_id
```

很多 SQL 错误不是函数不会用，而是 `GROUP BY` 粒度写错。例如题目要“用户平均消费”，应该先算每个用户总消费，再对用户求平均；如果直接对订单金额 `AVG(amount)`，算出来的是“订单平均金额”，不是“用户平均消费”。

错误口径：

```sql
SELECT
    city,
    AVG(amount) AS avg_amount
FROM users u
JOIN orders o
    ON u.user_id = o.user_id
GROUP BY city;
```

这算的是城市内订单平均金额。

更接近“人均消费”的写法：

```sql
WITH user_amount AS (
    SELECT
        u.city,
        u.user_id,
        SUM(o.amount) AS total_amount
    FROM users u
    LEFT JOIN orders o
        ON u.user_id = o.user_id
       AND o.status = 'paid'
    GROUP BY u.city, u.user_id
)
SELECT
    city,
    AVG(COALESCE(total_amount, 0)) AS avg_user_amount
FROM user_amount
GROUP BY city;
```

这里先把粒度聚合到“用户”，再对用户求平均。这种“先到正确粒度，再算指标”的意识是数分 SQL 的关键。

---

## 八、多表 JOIN：数分 SQL 的核心

真实业务数据通常分散在多张表里。用户属性在用户表，订单在订单表，商品信息在商品表，行为日志在事件表。要回答业务问题，就需要把表关联起来。

常见 JOIN 类型：

- `INNER JOIN`：只保留两边都匹配的数据。
- `LEFT JOIN`：保留左表全部数据，右表匹配不到则为 NULL。
- `RIGHT JOIN`：保留右表全部数据，较少使用。
- `FULL JOIN`：保留两边全部数据，MySQL 不直接支持。
- `CROSS JOIN`：笛卡尔积，面试中要谨慎。

示例：查询每个订单对应的用户城市：

```sql
SELECT
    o.order_id,
    o.amount,
    u.city
FROM orders o
LEFT JOIN users u
    ON o.user_id = u.user_id;
```

为什么数分里常用 `LEFT JOIN`？因为很多分析要保留主表口径。例如“统计所有新用户后续是否下单”，左表应该是新用户，右表是订单。如果用 `INNER JOIN`，没有下单的新用户会被直接过滤掉，留存率、转化率都会被高估。

多表关联示例：统计每个品类的 GMV：

```sql
SELECT
    p.category,
    SUM(o.amount) AS gmv
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
WHERE o.status = 'paid'
GROUP BY p.category
ORDER BY gmv DESC;
```

JOIN 面试重点：

1. 关联字段是否唯一。用户表 `user_id` 通常唯一，订单表 `user_id` 不唯一。
2. 是否会一对多导致数据膨胀。
3. 是否需要先聚合再关联。
4. 是否需要保留未匹配数据。
5. 关联字段类型是否一致，例如一个表是 bigint，另一个表是字符串，需要显式转换。

典型错误是直接把两个明细表 JOIN，然后再聚合，导致指标被重复计算。例如订单表和点击表都按用户多行记录，直接按 `user_id` JOIN 会产生多对多膨胀。正确做法通常是先在各自表内按用户聚合，再按用户关联。

补充理解：JOIN 前一定要问两个问题。第一，主表是谁？也就是结果要保留谁。比如分析新用户转化，就应该以新用户表为主表；分析订单 GMV，就应该以订单表为主表。第二，关联关系是一对一、一对多，还是多对多。如果是多对多，通常不能直接 JOIN 后聚合，否则数据会被放大。

`LEFT JOIN` 还有一个高频坑：右表条件放在 `WHERE` 里，可能会把没有匹配的左表记录过滤掉，使 `LEFT JOIN` 变成类似 `INNER JOIN`。如果你想保留左表全部用户，但只匹配右表中的有效订单，右表条件更适合写在 `ON` 后面。

---

补充讲解：JOIN 题最容易错在“表之间的关系”没有想清楚。可以在写 SQL 前先判断：左表一行对应右表几行？右表一行又对应左表几行？

```text
一对一：JOIN 后行数通常不变
一对多：一边的信息会被复制多次
多对多：JOIN 后可能严重膨胀，指标很容易算错
```

典型场景：订单表和订单明细表。

```text
orders：一行 = 一笔订单
order_items：一行 = 一个订单中的一个商品
```

如果一笔订单有 3 个商品，订单表 JOIN 订单明细表后，这笔订单会变成 3 行。这个时候如果再 `SUM(orders.amount)`，就会把订单金额重复计算。

所以多表题可以遵循一个原则：

```text
先判断目标指标在哪张表最自然；如果两张明细表都是多行，优先先各自聚合到同一粒度，再 JOIN。
```

例如要分析“每个用户的订单数和点击数”，不要直接把订单明细和点击明细按用户 JOIN，因为一个用户 10 笔订单、100 次点击，JOIN 后可能变成 1000 行。更稳的做法是：

```sql
WITH user_order AS (
    SELECT
        user_id,
        COUNT(DISTINCT order_id) AS order_cnt
    FROM orders
    WHERE status = 'paid'
    GROUP BY user_id
),
user_click AS (
    SELECT
        user_id,
        COUNT(*) AS click_cnt
    FROM events
    WHERE event_type = 'click'
    GROUP BY user_id
)
SELECT
    u.user_id,
    COALESCE(o.order_cnt, 0) AS order_cnt,
    COALESCE(c.click_cnt, 0) AS click_cnt
FROM users u
LEFT JOIN user_order o
    ON u.user_id = o.user_id
LEFT JOIN user_click c
    ON u.user_id = c.user_id;
```

这个写法的优势是，每个中间表都已经是一行一个用户，最后 JOIN 不会发生明细膨胀。

---

## 九、子查询与 CTE：把复杂问题拆开

子查询可以放在 `FROM`、`WHERE`、`SELECT` 中。数分刷题中，最常用的是把中间结果作为临时表。

```sql
SELECT
    user_id,
    order_cnt
FROM (
    SELECT
        user_id,
        COUNT(*) AS order_cnt
    FROM orders
    GROUP BY user_id
) t
WHERE order_cnt >= 3;
```

CTE 用 `WITH`，可读性更好：

```sql
WITH user_orders AS (
    SELECT
        user_id,
        COUNT(*) AS order_cnt
    FROM orders
    GROUP BY user_id
)
SELECT *
FROM user_orders
WHERE order_cnt >= 3;
```

CTE 的价值不是性能一定更好，而是让逻辑清晰。面试时你可以把复杂题拆成几个步骤：

1. 找目标用户。
2. 取目标行为。
3. 按粒度聚合。
4. 计算指标。
5. 排序或筛选。

例如留存题经常先用 CTE 找新增用户，再关联后续活跃行为。

补充理解：CTE 的好处是把复杂题拆成几个有名字的中间表。面试时不需要追求一条 SQL 写到底，反而应该追求步骤清楚。比如留存题可以拆成 `new_users`、`user_active_day`、`retention_calc`；漏斗题可以拆成 `base_events`、`user_steps`、`funnel_result`。每个 CTE 的名字最好能反映业务含义，这样面试官很容易跟上你的思路。

一个实用习惯是：每个 CTE 只解决一个问题。不要在同一个 CTE 里同时做筛选、去重、JOIN、聚合、排名，否则调试和解释都会变难。

---

## 十、窗口函数：TopN、排名、连续问题的核心

窗口函数是数据分析 SQL 面试中非常重要的一类。它的特点是：既能在一组数据内计算，又不会像 `GROUP BY` 那样把明细行压缩成一行。

基本结构：

```sql
函数名() OVER (
    PARTITION BY 分组字段
    ORDER BY 排序字段
)
```

常见窗口函数：

```sql
ROW_NUMBER() -- 组内连续编号，不处理并列
RANK()       -- 并列同名次，会跳号
DENSE_RANK() -- 并列同名次，不跳号
LAG()        -- 取上一行
LEAD()       -- 取下一行
SUM() OVER() -- 窗口内累计求和
AVG() OVER() -- 窗口内平均
```

每个部门薪资最高的员工：

```sql
WITH t AS (
    SELECT
        emp_id,
        emp_name,
        dept_id,
        salary,
        ROW_NUMBER() OVER (
            PARTITION BY dept_id
            ORDER BY salary DESC
        ) AS rn
    FROM employees
)
SELECT *
FROM t
WHERE rn = 1;
```

如果题目要求并列第一都保留，应使用 `RANK()` 或 `DENSE_RANK()`：

```sql
WITH t AS (
    SELECT
        emp_id,
        emp_name,
        dept_id,
        salary,
        RANK() OVER (
            PARTITION BY dept_id
            ORDER BY salary DESC
        ) AS rnk
    FROM employees
)
SELECT *
FROM t
WHERE rnk = 1;
```

每个月播放量 Top3 歌曲：

```sql
WITH song_month AS (
    SELECT
        DATE_FORMAT(play_time, '%Y-%m') AS month,
        song_id,
        COUNT(*) AS play_cnt
    FROM song_play_log
    GROUP BY DATE_FORMAT(play_time, '%Y-%m'), song_id
),
ranked AS (
    SELECT
        month,
        song_id,
        play_cnt,
        ROW_NUMBER() OVER (
            PARTITION BY month
            ORDER BY play_cnt DESC
        ) AS rn
    FROM song_month
)
SELECT *
FROM ranked
WHERE rn <= 3;
```

窗口函数题的关键是先确认“分组排名的组是谁”。每个月 Top3，`PARTITION BY month`；每个学校 GPA 最低，`PARTITION BY school`；每个省份消息量第一，`PARTITION BY province`。

补充理解：选择 `ROW_NUMBER()`、`RANK()`、`DENSE_RANK()` 时，要看题目是否保留并列。`ROW_NUMBER()` 会强行给每行一个不同序号，适合“每组只取一个”；`RANK()` 会保留并列，但名次会跳号；`DENSE_RANK()` 也保留并列，但名次不跳号。比如第一名有两个人，`RANK()` 的下一名是第 3，`DENSE_RANK()` 的下一名是第 2。

面试中如果题目没有说明并列怎么处理，可以主动说：“如果并列都保留，我用 `RANK()`；如果只要一个结果，我用 `ROW_NUMBER()` 并补充一个次级排序字段保证结果稳定。”

---

补充讲解：窗口函数可以分成三类来记，比单独背函数更清楚。

第一类是排名类：

```text
ROW_NUMBER / RANK / DENSE_RANK
```

适合解决每组 TopN、每组最大最小、每组保留最新记录。

第二类是错位比较类：

```text
LAG / LEAD
```

适合解决上一天、下一天、上一次登录、下一次购买、前后行为间隔。

第三类是累计统计类：

```text
SUM() OVER / COUNT() OVER / AVG() OVER
```

适合解决累计 GMV、累计用户数、滚动 7 日指标、组内均值对比。

例如计算每日 GMV 环比：

```sql
WITH daily AS (
    SELECT
        DATE(order_time) AS dt,
        SUM(amount) AS gmv
    FROM orders
    WHERE status = 'paid'
    GROUP BY DATE(order_time)
),
with_lag AS (
    SELECT
        dt,
        gmv,
        LAG(gmv, 1) OVER (ORDER BY dt) AS prev_gmv
    FROM daily
)
SELECT
    dt,
    gmv,
    prev_gmv,
    (gmv - prev_gmv) * 1.0 / NULLIF(prev_gmv, 0) AS mom_rate
FROM with_lag;
```

这类题的思路是：先按天聚合，再用 `LAG` 取前一天，再计算变化率。注意不要直接在订单明细上做 `LAG(amount)`，因为明细粒度是一笔订单，不是一天。

---

## 十一、日期处理与时间序列

数据分析 SQL 大量涉及日期。常见任务包括按天、按月统计，计算间隔，找次日留存，找连续登录，计算近 7 天、近 30 天指标。

MySQL 常见日期函数：

```sql
DATE(time_col)                       -- 取日期
DATE_FORMAT(time_col, '%Y-%m')       -- 按月
DATEDIFF(date1, date2)               -- 日期差
DATE_ADD(date_col, INTERVAL 1 DAY)   -- 日期加一天
DATE_SUB(date_col, INTERVAL 7 DAY)   -- 日期减七天
```

按天统计订单：

```sql
SELECT
    DATE(order_time) AS dt,
    COUNT(*) AS order_cnt,
    SUM(amount) AS gmv
FROM orders
WHERE status = 'paid'
GROUP BY DATE(order_time)
ORDER BY dt;
```

按月统计：

```sql
SELECT
    DATE_FORMAT(order_time, '%Y-%m') AS month,
    COUNT(*) AS order_cnt,
    SUM(amount) AS gmv
FROM orders
WHERE status = 'paid'
GROUP BY DATE_FORMAT(order_time, '%Y-%m');
```

时间题常见坑：

1. `2026-01-31 23:59:59` 这类边界容易漏数，推荐用左闭右开：

```sql
WHERE order_time >= '2026-01-01'
  AND order_time < '2026-02-01'
```

2. 时间字段可能是字符串，需要转换。
3. 日期粒度和时间戳粒度不同，JOIN 前要统一。
4. 同一用户一天多次行为时，要先按用户和日期去重。

补充理解：日期题的重点不是记住所有日期函数，而是统一时间粒度。比如订单表是时间戳，活跃表是日期，JOIN 前就要把时间戳转成日期；如果按月统计，就要把所有记录统一到月份粒度。粒度不统一会导致同一天或同一月的数据匹配不上。

同时要注意，不同 SQL 方言的日期函数不完全一样。MySQL 常用 `DATE_FORMAT`，Hive 常用 `date_format` 或 `substr`，PostgreSQL 常用 `DATE_TRUNC`。面试时如果不知道具体数据库，可以先说明“以 MySQL 写法为例”。

---

## 十二、留存率：数分 SQL 高频中的高频

留存率题本质上是在问：某一天或某一批用户，在后续某一天是否再次发生目标行为。

次日留存率公式：

```text
次日留存率 = 某日活跃用户中，第二天仍活跃的用户数 / 某日活跃用户数
```

如果题目是“用户某天刷题后第二天还会再来刷题的留存率”，表是：

```text
question_practice_detail(id, device_id, question_id, result, date)
```

思路：

1. 先按 `device_id, date` 去重，得到用户每天是否刷题。
2. 用当天记录 `a` 左连接第二天记录 `b`。
3. 分母是当天去重用户数，分子是第二天仍出现的用户数。

SQL 模板：

```sql
WITH user_day AS (
    SELECT DISTINCT
        device_id,
        date
    FROM question_practice_detail
),
retention AS (
    SELECT
        a.date AS dt,
        COUNT(DISTINCT a.device_id) AS active_users,
        COUNT(DISTINCT b.device_id) AS retained_users
    FROM user_day a
    LEFT JOIN user_day b
        ON a.device_id = b.device_id
       AND b.date = DATE_ADD(a.date, INTERVAL 1 DAY)
    GROUP BY a.date
)
SELECT
    dt,
    active_users,
    retained_users,
    retained_users / active_users AS next_day_retention
FROM retention
ORDER BY dt;
```

如果要求平均次日留存率，要看题意。有的题是每天留存率再平均：

```sql
SELECT AVG(retained_users / active_users) AS avg_retention
FROM retention;
```

有的题是全周期分子分母合并后相除：

```sql
SELECT SUM(retained_users) / SUM(active_users) AS overall_retention
FROM retention;
```

这两个口径不同，面试时要主动说明。

N 日留存模板：

```sql
WITH new_users AS (
    SELECT DISTINCT
        device_id,
        date AS first_dt
    FROM table1
    WHERE is_new = 1
      AND date = '2022-09-01'
),
retained AS (
    SELECT
        n.device_id,
        DATEDIFF(a.date, n.first_dt) AS r_day
    FROM new_users n
    LEFT JOIN table1 a
        ON n.device_id = a.device_id
       AND a.date > n.first_dt
       AND DATEDIFF(a.date, n.first_dt) <= 30
)
SELECT
    '2022-09-01' AS new_date,
    r_day,
    COUNT(DISTINCT device_id) AS retained_devices,
    COUNT(DISTINCT device_id) / (SELECT COUNT(*) FROM new_users) AS retention_rate
FROM retained
GROUP BY r_day
ORDER BY r_day;
```

留存题面试要点：

- 分母是否是新增用户、活跃用户、付费用户。
- 分子是否要求“第 N 天正好活跃”还是“第 N 天内有活跃”。
- 是否要去重到用户天粒度。
- 是否保留 0 留存的日期。
- 是否按渠道、城市、版本分组。

补充理解：留存题最重要的是分母不能变。比如 6 月 1 日新增 1000 人，那么算 D1、D3、D7 留存时，分母都应该是这 1000 人，而不是每天活跃用户数。分子才是这些新增用户在后续某一天是否回来。

还要区分“精确第 N 日留存”和“N 日内留存”。精确第 N 日留存要求用户刚好在第 N 天活跃；N 日内留存只要在第 1 到第 N 天之间回来过就算。SQL 中前者通常写 `DATEDIFF(active_date, first_date) = N`，后者通常写 `BETWEEN 1 AND N`。面试时最好主动说明你采用的是哪一种口径。

---

补充讲解：留存题建议永远先拆成三步，而不是直接写复杂 SQL。

```text
第一步：确定分母人群，例如某天新增用户、某天活跃用户、某天付费用户
第二步：确定分子行为，例如次日活跃、第 7 日活跃、7 日内任意活跃、再次付费
第三步：确定关联方式，通常用分母人群 LEFT JOIN 后续行为
```

最容易混淆的是“第 N 日留存”和“N 日内留存”。

```text
第 N 日留存：只看第 N 天当天是否回来
N 日内留存：第 1 天到第 N 天之间任意一天回来都算
```

对应 SQL 条件分别是：

```sql
DATEDIFF(b.dt, a.dt) = 7
```

和：

```sql
DATEDIFF(b.dt, a.dt) BETWEEN 1 AND 7
```

这两个口径差异很大，面试时最好主动说明。如果题目没说清楚，可以说：“我先按精确第 N 日留存写，如果业务要看 N 日内回访，把等号改成区间即可。”

---

## 十三、连续登录与连续活跃

最长连续登录天数是经典窗口函数题。核心技巧是“日期减排名”。

假设表：

```text
login_log(user_id, login_date)
```

先按用户和日期去重：

```sql
WITH user_day AS (
    SELECT DISTINCT
        user_id,
        login_date
    FROM login_log
),
ranked AS (
    SELECT
        user_id,
        login_date,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY login_date
        ) AS rn
    FROM user_day
),
grouped AS (
    SELECT
        user_id,
        login_date,
        DATE_SUB(login_date, INTERVAL rn DAY) AS grp
    FROM ranked
)
SELECT
    user_id,
    MAX(days) AS max_continue_days
FROM (
    SELECT
        user_id,
        grp,
        COUNT(*) AS days
    FROM grouped
    GROUP BY user_id, grp
) t
GROUP BY user_id;
```

为什么 `login_date - rn` 能分组？如果用户连续登录，日期每天加 1，排名也每天加 1，两者差值不变。断开后差值改变，于是自然形成连续段。

补充理解：连续登录题的难点在于“连续”不是简单计数，而是要识别日期是否相邻。`日期 - 排名` 这个技巧的本质是把连续日期映射到同一个分组标识。只要中间断了一天，日期增加的幅度大于排名增加的幅度，差值就会变化，于是新的连续段开始。

做这类题前必须先按 `user_id, login_date` 去重。否则同一用户一天登录多次，会导致排名增加多次，连续段判断被破坏。

面试中也可能要求“连续 3 天登录用户”。只要在连续段统计后筛选：

```sql
HAVING COUNT(*) >= 3
```

---

## 十四、转化率、漏斗与路径分析

转化率公式一般是：

```text
转化率 = 完成目标行为的用户数 / 进入前置环节的用户数
```

例如曝光到点击：

```sql
SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'click' THEN user_id END) /
    COUNT(DISTINCT CASE WHEN event_type = 'exposure' THEN user_id END) AS ctr
FROM events
WHERE event_date = '2026-06-01';
```

漏斗题常见写法是条件聚合：

```sql
SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_id END) AS view_users,
    COUNT(DISTINCT CASE WHEN event_type = 'cart' THEN user_id END) AS cart_users,
    COUNT(DISTINCT CASE WHEN event_type = 'pay' THEN user_id END) AS pay_users,
    COUNT(DISTINCT CASE WHEN event_type = 'pay' THEN user_id END) /
    COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_id END) AS pay_rate
FROM events
WHERE event_date BETWEEN '2026-06-01' AND '2026-06-07';
```

如果题目要求严格路径，例如必须先曝光再点击再支付，就不能只做条件聚合，需要比较时间顺序：

```sql
WITH user_steps AS (
    SELECT
        user_id,
        MIN(CASE WHEN event_type = 'view' THEN event_time END) AS view_time,
        MIN(CASE WHEN event_type = 'click' THEN event_time END) AS click_time,
        MIN(CASE WHEN event_type = 'pay' THEN event_time END) AS pay_time
    FROM events
    GROUP BY user_id
)
SELECT
    COUNT(*) AS view_users,
    COUNT(CASE WHEN click_time > view_time THEN 1 END) AS click_users,
    COUNT(CASE WHEN pay_time > click_time THEN 1 END) AS pay_users
FROM user_steps
WHERE view_time IS NOT NULL;
```

漏斗题关键是问清楚是否要求顺序、是否限制时间窗口、是否按用户去重。

补充理解：漏斗题可以分成宽松漏斗和严格漏斗。宽松漏斗只看用户是否发生过每一步，不一定要求顺序；严格漏斗要求用户先发生 A，再发生 B，再发生 C。真实业务中更常用严格漏斗，因为路径顺序会影响解释。

比如曝光、点击、支付三个步骤，如果只做条件聚合，用户只要在周期内出现过点击和支付就会被算入，即使点击发生在支付之后也可能被算进去。如果题目强调“从曝光到点击到支付”，就应该比较每一步的最早发生时间，并确保 `view_time < click_time < pay_time`。

---

## 十五、复购率、客单价、ARPU、ARPPU

电商、内容、会员、游戏类岗位经常考业务指标。

GMV：

```sql
SELECT SUM(amount) AS gmv
FROM orders
WHERE status = 'paid';
```

客单价：

```sql
SELECT
    SUM(amount) / COUNT(DISTINCT order_id) AS avg_order_value
FROM orders
WHERE status = 'paid';
```

ARPU：

```sql
SELECT
    SUM(amount) / COUNT(DISTINCT u.user_id) AS arpu
FROM users u
LEFT JOIN orders o
    ON u.user_id = o.user_id
   AND o.status = 'paid';
```

ARPPU：

```sql
SELECT
    SUM(amount) / COUNT(DISTINCT user_id) AS arppu
FROM orders
WHERE status = 'paid';
```

复购率常见口径：

```text
复购率 = 购买次数 >= 2 的用户数 / 购买用户数
```

```sql
WITH user_buy AS (
    SELECT
        user_id,
        COUNT(DISTINCT order_id) AS order_cnt
    FROM orders
    WHERE status = 'paid'
    GROUP BY user_id
)
SELECT
    COUNT(CASE WHEN order_cnt >= 2 THEN user_id END) /
    COUNT(*) AS repurchase_rate
FROM user_buy;
```

注意：复购率口径可能是订单次数，也可能是不同日期购买，也可能是不同月份购买，要根据题目确定。

补充理解：复购率不要机械理解成“订单数大于 1”。有些业务要求同一用户在不同自然日购买才算复购，有些业务要求跨月购买才算复购，还有些业务会排除退款订单、赠品订单或测试订单。面试时可以先说明默认口径：有效支付订单数不少于 2 的用户 / 有效支付用户。如果题目强调周期，就改成“本期购买用户中，上期或后续再次购买的比例”。

ARPU 和 ARPPU 也要注意分母不同。ARPU 的分母是全部用户，哪怕没有付费也算；ARPPU 的分母是付费用户。二者差距越大，通常说明付费渗透率越低。

---

补充讲解：复购、客单价、ARPU、ARPPU 这些指标的难点不在 SQL 函数，而在“分母是谁”。

```text
客单价：分母是订单数
ARPU：分母是总用户数，包含没有付费的人
ARPPU：分母是付费用户数，只看付费人群
复购率：分母通常是购买用户，分子是购买次数 >= 2 的用户
回购率：分母通常是上一周期购买用户，分子是下一周期继续购买的用户
```

例如 ARPU 一定要小心主表。如果从订单表出发：

```sql
SELECT SUM(amount) / COUNT(DISTINCT user_id) AS arppu
FROM orders
WHERE status = 'paid';
```

这其实更接近 ARPPU，因为没有付费的人根本不在订单表中。要算 ARPU，通常应该从用户表出发：

```sql
SELECT
    SUM(COALESCE(o.amount, 0)) * 1.0 / COUNT(DISTINCT u.user_id) AS arpu
FROM users u
LEFT JOIN orders o
    ON u.user_id = o.user_id
   AND o.status = 'paid';
```

这类题面试时可以直接说：ARPU 和 ARPPU 最大区别是分母，ARPU 包含未付费用户，ARPPU 只包含付费用户。

---

## 十六、分层、CASE WHEN 与条件聚合

`CASE WHEN` 用于把连续变量或复杂条件转成分类字段。

```sql
SELECT
    user_id,
    CASE
        WHEN age < 18 THEN '未成年'
        WHEN age BETWEEN 18 AND 30 THEN '青年'
        WHEN age BETWEEN 31 AND 50 THEN '中年'
        ELSE '其他'
    END AS age_group
FROM users;
```

条件聚合是数分 SQL 的常用技巧：

补充理解：`CASE WHEN` 的本质是把业务规则翻译成字段。比如把年龄转成年龄段，把消息数转成高低活跃，把订单金额转成消费层级。数分面试里，很多看起来复杂的分类统计题，其实就是先用 `CASE WHEN` 打标签，再按标签分组统计。

写条件聚合时要注意两点：第一，条件之间是否互斥，避免同一条记录被分到多个组；第二，是否需要 `ELSE`，如果不写 `ELSE`，不满足条件的结果通常是 NULL，后续聚合时可能被忽略。

```sql
SELECT
    city,
    COUNT(DISTINCT user_id) AS user_cnt,
    COUNT(DISTINCT CASE WHEN gender = 'female' THEN user_id END) AS female_users,
    COUNT(DISTINCT CASE WHEN gender = 'male' THEN user_id END) AS male_users
FROM users
GROUP BY city;
```

题集中的“每天不同性别的 QQ 号个数、总消息数量、平均在线时长”就是典型的多表关联加条件清洗加分组聚合题。解法思路是：

1. 先关联用户属性表和行为表。
2. 统一 QQ 字段类型。
3. 过滤性别为空的数据。
4. 按日期和性别分组。
5. 分别统计去重 QQ 数、消息总数、平均在线时长。

模板：

```sql
SELECT
    a.dt,
    u.gender,
    COUNT(DISTINCT u.qq) AS qq_cnt,
    SUM(a.msg_cnt) AS total_msg_cnt,
    AVG(a.online_duration) AS avg_online_duration
FROM table_act a
JOIN table_user u
    ON CAST(u.qq AS CHAR) = TRIM(a.qq)
WHERE u.gender IS NOT NULL
GROUP BY a.dt, u.gender;
```

---

## 十七、数据清洗类 SQL：类型、空值、重复、文本

面试题经常故意设置脏数据：

- 一个表字段是 bigint，另一个表是字符串。
- 地域有“广东”和“广东省”两种写法。
- 性别为空要排除。
- 同一用户同一天多条行为要去重。
- 时间字段是字符串。

类型转换：

```sql
CAST(user_id AS CHAR)
CAST(date_str AS DATE)
```

文本处理：

```sql
TRIM(col)       -- 去掉首尾空格
LOWER(col)      -- 转小写
REPLACE(col, '广东', '广东省')
```

地域归一：

```sql
CASE
    WHEN province IN ('广东', '广东省') THEN '广东省'
    ELSE province
END AS province_std
```

去重：

```sql
SELECT DISTINCT user_id, dt
FROM events;
```

或用窗口函数保留最新一条：

```sql
WITH ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY update_time DESC
        ) AS rn
    FROM users
)
SELECT *
FROM ranked
WHERE rn = 1;
```

数据清洗题的核心不是函数背得多，而是先明确“分析口径需要干净到什么程度”。

补充理解：数据清洗在面试里常体现为几个小陷阱：字段类型不一致、字符串有空格、日期是文本、同义字段未统一、无效状态未排除、重复记录未处理。你不一定要记住所有函数，但要能识别这些问题会怎样影响结果。

比如两个表用 QQ 号关联，一个表是数值型，一个表是字符串型且带空格，如果直接 JOIN，可能匹配不到。正确思路是先 `TRIM` 去空格，再统一类型。再比如“广东”和“广东省”如果不归一，按省份统计时会被拆成两组。

---

## 十八、DDL 与数据库操作基础

虽然数分岗位主要考查询，但基础 DDL 也可能出现。

创建数据库：

```sql
CREATE DATABASE haina_data;
```

使用数据库：

```sql
USE haina_data;
```

创建表：

```sql
CREATE TABLE customer (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    company VARCHAR(100),
    sales INT
);
```

增加字段：

```sql
ALTER TABLE customer
ADD address VARCHAR(100);
```

删除表：

```sql
DROP TABLE customer;
```

插入数据：

```sql
INSERT INTO customer (id, name, company, sales)
VALUES (1, '张三', 'A公司', 1001);
```

更新数据：

```sql
UPDATE customer
SET sales = 1002
WHERE id = 1;
```

删除数据：

```sql
DELETE FROM customer
WHERE id = 1;
```

注意：`UPDATE` 和 `DELETE` 面试可能会问，但真实工作中一定要带 `WHERE` 并先 `SELECT` 检查影响范围。

补充理解：数分岗位日常更多是查数，而不是直接改线上数据。但理解 DDL、DML 有助于你看懂数据表是怎么来的。尤其是 `DELETE`、`TRUNCATE`、`DROP` 的区别要清楚：`DELETE` 删除数据且可以加条件，`TRUNCATE` 清空整张表，`DROP` 直接删除表结构。真实工作中涉及修改或删除数据，一定要非常谨慎，通常需要权限、审批和备份。

---

## 十九、索引、性能与查询优化意识

数据分析岗位不一定要求你像 DBA 一样精通索引，但要有基本优化意识。

索引可以加快查询，尤其是用于筛选、连接、排序的字段，例如 `user_id`、`order_date`、`product_id`。但索引不是越多越好，写入和维护也有成本。

常见优化原则：

1. 只取需要字段，不滥用 `SELECT *`。
2. 先过滤再关联，减少 JOIN 数据量。
3. 大表 JOIN 前先聚合到需要粒度。
4. 避免无条件 JOIN 导致笛卡尔积。
5. 时间筛选尽量使用分区字段。
6. 避免在索引列上套函数导致索引失效，例如 `DATE(order_time)` 可能影响索引使用。
7. 明确去重字段，避免 `COUNT(DISTINCT *)` 这类不可控写法。

例如：

```sql
WHERE order_time >= '2026-06-01'
  AND order_time < '2026-07-01'
```

通常比下面这种更利于利用时间索引：

```sql
WHERE DATE_FORMAT(order_time, '%Y-%m') = '2026-06'
```

数仓场景下，还要关注分区字段。例如表按 `dt` 分区，查询必须带上：

```sql
WHERE dt = '2026-06-01'
```

否则容易全表扫描。

补充理解：面试中的性能优化不用讲得像 DBA 一样深，但要体现基本意识。大表查询时，最重要的是减少扫描数据量。常见做法是：先用分区字段限制日期范围，只取需要字段，大表 JOIN 前先聚合到目标粒度，避免对索引字段或分区字段套函数。

另外，`COUNT(DISTINCT user_id)` 在大数据场景下成本可能很高。如果只是面试 SQL 题，可以正常写；如果是真实数仓任务，可能要考虑是否有预聚合表、近似去重函数或指标宽表。

---

## 二十、数分 SQL 面试解题框架

遇到 SQL 业务题，不要急着写。建议按下面步骤：

第一步：读懂业务问题。  
题目是要统计用户数、订单数、金额、留存率、转化率，还是找排名、找连续天数？

第二步：确定结果粒度。  
结果是一行、每天一行、每个城市一行、每个用户一行，还是每月每品类一行？

第三步：确定分母和分子。  
留存、转化、复购、点击率都要明确分母分子。

第四步：确定主表。  
如果要保留未转化用户，主表应是用户表或曝光表，用 `LEFT JOIN`。

第五步：处理明细重复。  
是否需要 `DISTINCT user_id, date`？是否同一订单有多条明细？是否多表 JOIN 会膨胀？

第六步：拆中间表。  
复杂题优先写 CTE，把每一步命名清楚。

第七步：检查边界。  
NULL、时间范围、并列排名、除零、字段类型、是否保留 0 值。

补充理解：这个框架可以在面试时直接口述。比如题目是“统计每个渠道的新用户次日留存率”，你可以这样拆：结果粒度是渠道；分母是某日各渠道新增用户；分子是这些新增用户第二天仍活跃的人；主表是新增用户表；活跃表按用户和日期去重；用 `LEFT JOIN` 保留未留存用户；最后按渠道聚合并用 `NULLIF` 避免除零。

真正优秀的 SQL 面试回答，通常不是一开始就写代码，而是先把这七步说清楚。

---

## 二十一、高频题型模板汇总

### 1. 每个学校 GPA 最低的同学

```sql
WITH ranked AS (
    SELECT
        student_id,
        school,
        gpa,
        RANK() OVER (
            PARTITION BY school
            ORDER BY gpa ASC
        ) AS rnk
    FROM students
)
SELECT *
FROM ranked
WHERE rnk = 1;
```

如果只要一个人，用 `ROW_NUMBER()`；如果并列最低都要，用 `RANK()`。

### 2. 每个省份消息总量第一的 QQ

```sql
WITH qq_msg AS (
    SELECT
        u.province,
        u.qq,
        SUM(a.msg_cnt) AS total_msg
    FROM table_user u
    JOIN table_act a
        ON CAST(u.qq AS CHAR) = TRIM(a.qq)
    GROUP BY u.province, u.qq
),
ranked AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY province
            ORDER BY total_msg DESC
        ) AS rnk
    FROM qq_msg
)
SELECT *
FROM ranked
WHERE rnk = 1;
```

### 3. 每天广东省高低活跃度用户数

```sql
WITH base AS (
    SELECT
        a.dt,
        u.qq,
        CASE
            WHEN u.province IN ('广东', '广东省') THEN '广东省'
            ELSE u.province
        END AS province,
        a.msg_cnt
    FROM table_act a
    JOIN table_user u
        ON CAST(u.qq AS CHAR) = TRIM(a.qq)
),
labeled AS (
    SELECT
        dt,
        province,
        qq,
        CASE
            WHEN msg_cnt >= 200 THEN '高活跃度'
            ELSE '低活跃度'
        END AS active_level
    FROM base
    WHERE province = '广东省'
)
SELECT
    dt,
    province,
    active_level,
    COUNT(DISTINCT qq) AS qq_cnt
FROM labeled
GROUP BY dt, province, active_level;
```

### 4. 统计复旦用户 8 月练题情况

思路是用户表筛选学校，练题明细表筛选 8 月，然后按用户或学校聚合。

```sql
SELECT
    u.university,
    COUNT(q.question_id) AS question_cnt,
    COUNT(DISTINCT q.device_id) AS user_cnt,
    SUM(CASE WHEN q.result = 'right' THEN 1 ELSE 0 END) AS right_cnt
FROM user_profile u
JOIN question_practice_detail q
    ON u.device_id = q.device_id
WHERE u.university = '复旦大学'
  AND q.date >= '2021-08-01'
  AND q.date < '2021-09-01'
GROUP BY u.university;
```

### 5. 每月 Top3 歌曲

```sql
WITH song_month AS (
    SELECT
        DATE_FORMAT(play_time, '%Y-%m') AS month,
        song_name,
        COUNT(*) AS play_cnt
    FROM song_play_log
    WHERE singer = '周杰伦'
    GROUP BY DATE_FORMAT(play_time, '%Y-%m'), song_name
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY month
            ORDER BY play_cnt DESC
        ) AS rn
    FROM song_month
)
SELECT *
FROM ranked
WHERE rn <= 3;
```

---

## 二十二、常见易错点清单

1. 忘记 `GROUP BY` 粒度，导致结果不是题目要求的粒度。
2. `COUNT(*)` 和 `COUNT(col)` 混用，忽略 NULL。
3. 留存题没有先按用户和日期去重。
4. 用 `INNER JOIN` 导致未转化用户丢失。
5. 多对多 JOIN 导致金额、次数被放大。
6. TopN 题误用全局 `LIMIT`。
7. 并列排名时没有区分 `ROW_NUMBER`、`RANK`、`DENSE_RANK`。
8. 日期范围使用 `BETWEEN` 时漏掉时间戳边界。
9. `WHERE col = NULL` 写法错误。
10. 计算比例时整数除法导致结果为 0，可乘 `1.0` 或显式转换。
11. 字符串和数字字段直接 JOIN，导致匹配异常。
12. 忘记排除无效状态，例如取消订单、退款订单。
13. 指标口径没有说明，例如留存率是日均留存还是整体留存。
14. 没处理分母为 0 的情况。

比例计算建议：

```sql
retained_users * 1.0 / NULLIF(active_users, 0)
```

`NULLIF(active_users, 0)` 可以避免除零错误。

补充理解：易错点清单适合每次写完 SQL 后自查一遍。尤其是四个问题：第一，结果粒度对不对；第二，分母分子是否符合口径；第三，JOIN 后数据是否变多；第四，时间范围是否覆盖完整。这四个问题能排除大部分数分 SQL 错误。

还有一个常见问题是整数除法。很多数据库中，两个整数相除会得到整数，导致比例变成 0。所以建议分子乘 `1.0`，或者显式转换成小数类型。

---

## 二十三、面试表达方式

写 SQL 前可以先说：

> 我先确认一下口径：这道题的统计粒度是按天，分母是当天去重活跃用户数，分子是第二天仍然活跃的去重用户数。因为要保留没有留存的用户，所以我会用当天用户作为主表，再 LEFT JOIN 第二天行为。

这种表达比直接写代码更像真实分析师。

写完 SQL 后可以补充：

> 这里我先对用户和日期去重，避免同一用户一天多次行为导致留存分母膨胀。日期范围采用左闭右开，避免时间戳边界问题。如果要按渠道或城市看留存，可以在新增用户 CTE 中保留渠道或城市字段，再在最终结果中分组。

面试官通常关心的不只是 SQL 能不能跑，还关心你有没有指标意识和数据质量意识。

补充理解：面试表达要尽量像真实工作汇报，而不是像背题。可以采用三句话结构：第一句说明口径，第二句说明实现，第三句说明风险。例如：“我这里按用户去重计算转化率，分母是曝光用户，分子是点击用户。实现上先从曝光表取当天曝光用户作为主表，再左连接点击行为。需要注意同一用户多次曝光是否只算一次，以及点击是否要求发生在曝光之后。”

这种表达不长，但能体现你知道 SQL 背后的业务含义。

---

## 二十四、学习与刷题路线

建议按下面顺序刷：

1. 基础查询：`SELECT`、别名、去重、计算字段。
2. 条件筛选：`WHERE`、`IN`、`BETWEEN`、`LIKE`、`IS NULL`。
3. 聚合分组：`COUNT`、`SUM`、`AVG`、`GROUP BY`、`HAVING`。
4. 多表关联：`INNER JOIN`、`LEFT JOIN`、一对多和多对多。
5. 子查询和 CTE：把复杂业务拆成中间表。
6. 窗口函数：排名、TopN、连续登录、累计值。
7. 日期处理：日周月统计、次日/N 日留存、滚动窗口。
8. 业务题：留存、转化、复购、漏斗、活跃度分层、异动定位。
9. 优化和易错点：NULL、重复、分区、索引、类型转换。

第一轮刷题不要追求写得最短，而要追求逻辑正确。第二轮再优化成更清晰的 CTE 写法。第三轮训练口述能力：看到题目后先讲口径，再写 SQL，再解释风险点。

---

## 二十五、数分 SQL 最小能力闭环

准备到可以面试的程度，至少要能做到：

- 看懂表结构，判断主键、外键、粒度。
- 能写单表查询、筛选、排序、分组聚合。
- 能正确使用 `LEFT JOIN` 和 `INNER JOIN`。
- 能用 CTE 拆复杂题。
- 能用窗口函数解决组内 TopN、排名和连续问题。
- 能写留存、转化、复购、漏斗、活跃分层等业务 SQL。
- 能解释指标口径，而不是只给代码。
- 能识别数据重复、NULL、时间边界、JOIN 膨胀这些风险。

SQL 面试的核心不是背更多函数，而是形成稳定的分析套路：

```text
业务问题 -> 指标口径 -> 数据粒度 -> 表关系 -> SQL 分步实现 -> 结果校验
```

只要这个链条稳定，遇到新题也能拆。

---

## 二十六、大厂还会考的专题一：DAU、WAU、MAU 与活跃口径

大厂数分岗位非常喜欢考活跃指标，因为活跃是用户增长、内容生态、产品健康度分析的基础。

### 1. DAU、WAU、MAU 是什么

```text
DAU：Daily Active Users，日活跃用户数
WAU：Weekly Active Users，周活跃用户数
MAU：Monthly Active Users，月活跃用户数
```

它们的共同点是都要对用户去重。区别是时间窗口不同。

日活：

```sql
SELECT
    DATE(event_time) AS dt,
    COUNT(DISTINCT user_id) AS dau
FROM events
WHERE event_type IN ('open_app', 'login', 'view', 'click')
GROUP BY DATE(event_time)
ORDER BY dt;
```

月活：

```sql
SELECT
    DATE_FORMAT(event_time, '%Y-%m') AS month,
    COUNT(DISTINCT user_id) AS mau
FROM events
WHERE event_type IN ('open_app', 'login', 'view', 'click')
GROUP BY DATE_FORMAT(event_time, '%Y-%m')
ORDER BY month;
```

### 2. 活跃定义要先说清楚

“活跃”不是天然概念，必须由业务定义。不同产品可能口径不同：

```text
打开 App 算活跃
登录算活跃
浏览内容算活跃
发消息算活跃
完成一次有效学习算活跃
停留超过 10 秒算活跃
```

所以面试时可以这样表达：

> 我这里默认用户在当天发生过任意有效行为就算活跃，例如登录、浏览、点击。如果业务只把登录算活跃，则需要把 `event_type` 条件改成登录事件。

### 3. DAU/MAU 粘性

常见派生指标：

```text
DAU / MAU：用户活跃粘性，越高说明月活用户中每天回来的比例越高
```

简化写法：

```sql
WITH dau AS (
    SELECT
        DATE(event_time) AS dt,
        DATE_FORMAT(event_time, '%Y-%m') AS month,
        COUNT(DISTINCT user_id) AS dau
    FROM events
    GROUP BY DATE(event_time), DATE_FORMAT(event_time, '%Y-%m')
),
mau AS (
    SELECT
        DATE_FORMAT(event_time, '%Y-%m') AS month,
        COUNT(DISTINCT user_id) AS mau
    FROM events
    GROUP BY DATE_FORMAT(event_time, '%Y-%m')
)
SELECT
    d.dt,
    d.dau,
    m.mau,
    d.dau * 1.0 / NULLIF(m.mau, 0) AS dau_mau_ratio
FROM dau d
JOIN mau m
    ON d.month = m.month;
```

注意：这个指标不是严格的日均粘性，只是某天 DAU 占当月 MAU 的比例。如果要算月均 DAU/MAU，应先对当月每日 DAU 求平均，再除以 MAU。

---

## 二十七、大厂还会考的专题二：新增、流失、召回、沉默用户

用户生命周期题也是增长分析和用户运营岗位常考内容。

### 1. 新增用户

新增用户通常指首次出现或首次注册的用户。

如果有注册表：

```sql
SELECT
    register_date AS dt,
    COUNT(DISTINCT user_id) AS new_users
FROM users
GROUP BY register_date;
```

如果没有注册表，只有行为表，可以用首次行为时间近似：

```sql
WITH first_active AS (
    SELECT
        user_id,
        MIN(DATE(event_time)) AS first_dt
    FROM events
    GROUP BY user_id
)
SELECT
    first_dt AS dt,
    COUNT(*) AS new_users
FROM first_active
GROUP BY first_dt;
```

这里要说明：用首次行为近似新增，和真实注册新增不完全一样。

### 2. 流失用户

流失一般指过去活跃过，但最近一段时间没有活跃。

例如定义：过去 30 天没有活跃，但 30 天前活跃过的用户。

```sql
WITH history_user AS (
    SELECT DISTINCT user_id
    FROM events
    WHERE event_time < '2026-06-01'
),
recent_user AS (
    SELECT DISTINCT user_id
    FROM events
    WHERE event_time >= '2026-06-01'
      AND event_time < '2026-07-01'
)
SELECT
    COUNT(DISTINCT h.user_id) AS lost_users
FROM history_user h
LEFT JOIN recent_user r
    ON h.user_id = r.user_id
WHERE r.user_id IS NULL;
```

这类题的重点是流失窗口要说清楚，比如“连续 30 天未活跃”还是“本月未活跃”。

### 3. 召回用户

召回用户通常指曾经沉默、后来又回来活跃的用户。

思路：

```text
先找历史活跃用户
再找上一周期未活跃用户
最后找本周期重新活跃用户
```

示例：5 月未活跃但 6 月活跃，且 5 月前曾经活跃：

```sql
WITH before_may AS (
    SELECT DISTINCT user_id
    FROM events
    WHERE event_time < '2026-05-01'
),
may_active AS (
    SELECT DISTINCT user_id
    FROM events
    WHERE event_time >= '2026-05-01'
      AND event_time < '2026-06-01'
),
jun_active AS (
    SELECT DISTINCT user_id
    FROM events
    WHERE event_time >= '2026-06-01'
      AND event_time < '2026-07-01'
)
SELECT
    COUNT(DISTINCT j.user_id) AS recall_users
FROM jun_active j
JOIN before_may b
    ON j.user_id = b.user_id
LEFT JOIN may_active m
    ON j.user_id = m.user_id
WHERE m.user_id IS NULL;
```

面试时可以补充：召回用户的定义依赖业务窗口，短视频、电商、游戏、教育产品的沉默周期可能不同。

---

## 二十八、大厂还会考的专题三：同比、环比、移动平均与异动分析

很多业务分析题会问：“某指标下降了，怎么分析？”SQL 层面常见操作是先做趋势，再做同比、环比和分维度拆解。

### 1. 环比

环比是和上一个相邻周期比较。

```text
日环比：今天 vs 昨天
月环比：本月 vs 上月
```

SQL 模板：

```sql
WITH daily AS (
    SELECT
        DATE(order_time) AS dt,
        SUM(amount) AS gmv
    FROM orders
    WHERE status = 'paid'
    GROUP BY DATE(order_time)
),
t AS (
    SELECT
        dt,
        gmv,
        LAG(gmv, 1) OVER (ORDER BY dt) AS prev_gmv
    FROM daily
)
SELECT
    dt,
    gmv,
    prev_gmv,
    (gmv - prev_gmv) * 1.0 / NULLIF(prev_gmv, 0) AS mom_rate
FROM t;
```

### 2. 同比

同比是和上一年同周期比较。

如果是按月同比，可以先按月份聚合，再和去年同月连接：

```sql
WITH monthly AS (
    SELECT
        DATE_FORMAT(order_time, '%Y-%m') AS month,
        SUM(amount) AS gmv
    FROM orders
    WHERE status = 'paid'
    GROUP BY DATE_FORMAT(order_time, '%Y-%m')
)
SELECT
    cur.month,
    cur.gmv,
    last.gmv AS last_year_gmv,
    (cur.gmv - last.gmv) * 1.0 / NULLIF(last.gmv, 0) AS yoy_rate
FROM monthly cur
LEFT JOIN monthly last
    ON last.month = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(cur.month, '-01'), '%Y-%m-%d'), INTERVAL 1 YEAR), '%Y-%m');
```

不同数据库日期函数写法不一样，面试中更重要的是讲清楚逻辑：当前周期左连接去年同周期。

### 3. 移动平均

移动平均用于平滑波动，例如近 7 日平均 DAU：

```sql
WITH daily AS (
    SELECT
        DATE(event_time) AS dt,
        COUNT(DISTINCT user_id) AS dau
    FROM events
    GROUP BY DATE(event_time)
)
SELECT
    dt,
    dau,
    AVG(dau) OVER (
        ORDER BY dt
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS dau_7d_avg
FROM daily;
```

如果日期中间缺失，需要先用日期维表补齐，否则“前 6 行”不一定等于“前 6 天”。

### 4. 异动分析 SQL 思路

遇到“GMV 下降怎么分析”的题，可以按这个思路拆：

```text
先确认下降是否真实：口径、数据延迟、埋点、分区是否完整
再拆公式：GMV = 支付用户数 × 人均支付金额
继续拆：支付用户数 = 访问用户数 × 转化率
再分维度：渠道、城市、品类、新老用户、版本、活动、人群
最后定位贡献最大的下降来源
```

SQL 上通常先做分维度对比：

```sql
SELECT
    channel,
    SUM(CASE WHEN dt = '2026-06-01' THEN gmv ELSE 0 END) AS gmv_before,
    SUM(CASE WHEN dt = '2026-06-02' THEN gmv ELSE 0 END) AS gmv_after,
    SUM(CASE WHEN dt = '2026-06-02' THEN gmv ELSE 0 END)
      - SUM(CASE WHEN dt = '2026-06-01' THEN gmv ELSE 0 END) AS diff
FROM ads_channel_gmv
WHERE dt IN ('2026-06-01', '2026-06-02')
GROUP BY channel
ORDER BY diff ASC;
```

这类题不一定要写很复杂的 SQL，关键是你要知道先从总量拆到结构，再找贡献度最大的维度。

---

## 二十九、大厂还会考的专题四：A/B 实验 SQL

A/B 实验是互联网数据分析常考专题，尤其是增长、推荐、搜索、商业化岗位。

### 1. 基础表结构

常见表：

```text
experiment_user(user_id, exp_id, group_name, enter_time)
events(user_id, event_type, event_time)
orders(user_id, order_id, amount, order_time, status)
```

### 2. 计算实验组和对照组转化率

例如统计进入实验后 7 天内支付转化率：

```sql
WITH exp_user AS (
    SELECT
        user_id,
        group_name,
        enter_time
    FROM experiment_user
    WHERE exp_id = 'exp_001'
),
pay_user AS (
    SELECT DISTINCT
        e.user_id,
        e.group_name
    FROM exp_user e
    JOIN orders o
        ON e.user_id = o.user_id
       AND o.status = 'paid'
       AND o.order_time >= e.enter_time
       AND o.order_time < e.enter_time + INTERVAL 7 DAY
)
SELECT
    e.group_name,
    COUNT(DISTINCT e.user_id) AS exp_users,
    COUNT(DISTINCT p.user_id) AS pay_users,
    COUNT(DISTINCT p.user_id) * 1.0 / NULLIF(COUNT(DISTINCT e.user_id), 0) AS pay_rate
FROM exp_user e
LEFT JOIN pay_user p
    ON e.user_id = p.user_id
GROUP BY e.group_name;
```

### 3. A/B 实验 SQL 注意点

```text
分母是进入实验的用户，不是发生行为的用户
行为必须发生在进入实验之后
要排除同时进入多个实验组的污染用户
要区分用户级指标和行为级指标
要注意实验开始和结束时间
```

面试表达可以这样说：

> 我会先用实验分组表确定实验用户和分组，这是分母；然后关联进入实验后的目标行为，不能把进入实验之前的行为算进去；最后按实验组和对照组分别计算转化率。如果存在一个用户命中多个组，需要先排除污染样本。

---

## 三十、大厂还会考的专题五：搜索、推荐、内容场景指标

不同业务线考 SQL 的题型会有差异。内容、搜索、推荐、电商、本地生活、商业化都会围绕自己的业务指标出题。

### 1. 搜索场景

常见指标：

```text
搜索 PV：搜索次数
搜索 UV：搜索用户数
点击率 CTR：点击用户数或点击次数 / 搜索曝光数
无结果率：无结果搜索次数 / 搜索次数
搜索后转化率：搜索后点击、收藏、购买、下单的比例
```

例：统计每天搜索点击率：

```sql
SELECT
    dt,
    COUNT(CASE WHEN event_type = 'search' THEN 1 END) AS search_pv,
    COUNT(CASE WHEN event_type = 'click_result' THEN 1 END) AS click_pv,
    COUNT(CASE WHEN event_type = 'click_result' THEN 1 END) * 1.0
        / NULLIF(COUNT(CASE WHEN event_type = 'search' THEN 1 END), 0) AS ctr
FROM search_events
GROUP BY dt;
```

如果是用户级 CTR，要改成 `COUNT(DISTINCT user_id)`。

### 2. 推荐/内容场景

常见指标：

```text
曝光量 impression
点击量 click
播放量 play
完播率 finish_rate
点赞率 like_rate
收藏率 collect_rate
互动率 interaction_rate
人均消费内容数
```

例：计算视频完播率：

```sql
SELECT
    video_id,
    COUNT(CASE WHEN play_duration >= video_duration THEN user_id END) * 1.0
        / NULLIF(COUNT(*), 0) AS finish_rate
FROM video_play_log
GROUP BY video_id;
```

更严谨时，要处理异常播放时长：

```sql
WHERE play_duration >= 0
  AND video_duration > 0
```

### 3. 商业化广告场景

常见指标：

```text
曝光量
点击量
CTR = 点击量 / 曝光量
消耗 cost
转化数 conversion
CVR = 转化数 / 点击量
CPA = 消耗 / 转化数
ROI = 收入 / 消耗
```

例：广告计划 ROI：

```sql
SELECT
    campaign_id,
    SUM(cost) AS cost,
    SUM(revenue) AS revenue,
    SUM(revenue) * 1.0 / NULLIF(SUM(cost), 0) AS roi
FROM ad_report
GROUP BY campaign_id;
```

这类题要特别注意分母：CTR 的分母是曝光，CVR 的分母通常是点击，ROI 的分母是消耗。

---

## 三十一、大厂还会考的专题六：新老用户、用户分层与 RFM

用户分层题经常和 `CASE WHEN`、聚合、窗口函数结合。

### 1. 新老用户识别

一种常见定义：首次下单日期等于当前日期的是新客，否则是老客。

```sql
WITH first_order AS (
    SELECT
        user_id,
        MIN(DATE(order_time)) AS first_order_dt
    FROM orders
    WHERE status = 'paid'
    GROUP BY user_id
),
order_base AS (
    SELECT
        o.user_id,
        DATE(o.order_time) AS dt,
        o.order_id,
        o.amount,
        CASE
            WHEN f.first_order_dt = DATE(o.order_time) THEN '新客'
            ELSE '老客'
        END AS user_type
    FROM orders o
    JOIN first_order f
        ON o.user_id = f.user_id
    WHERE o.status = 'paid'
)
SELECT
    dt,
    user_type,
    COUNT(DISTINCT user_id) AS pay_users,
    COUNT(DISTINCT order_id) AS orders,
    SUM(amount) AS gmv
FROM order_base
GROUP BY dt, user_type;
```

### 2. RFM 分层

RFM 是用户价值分析常见方法：

```text
R：Recency，最近一次消费距今天数
F：Frequency，消费频次
M：Monetary，消费金额
```

简化 SQL：

```sql
WITH user_rfm AS (
    SELECT
        user_id,
        DATEDIFF('2026-06-30', MAX(DATE(order_time))) AS recency,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(amount) AS monetary
    FROM orders
    WHERE status = 'paid'
    GROUP BY user_id
)
SELECT
    user_id,
    recency,
    frequency,
    monetary,
    CASE
        WHEN recency <= 30 AND frequency >= 5 AND monetary >= 1000 THEN '高价值用户'
        WHEN recency <= 60 AND frequency >= 2 THEN '潜力用户'
        WHEN recency > 90 THEN '流失风险用户'
        ELSE '普通用户'
    END AS user_level
FROM user_rfm;
```

面试中不用把 RFM 讲得特别复杂，但要能说清楚：这是用最近消费、消费频次、消费金额对用户分层。

---

## 三十二、大厂还会考的专题七：连续、间隔与序列类题型

你前面已经有连续登录题，这里再补充几类相近题。

### 1. 两次行为间隔

例如计算用户相邻两次下单间隔：

```sql
WITH t AS (
    SELECT
        user_id,
        order_id,
        order_time,
        LAG(order_time, 1) OVER (
            PARTITION BY user_id
            ORDER BY order_time
        ) AS prev_order_time
    FROM orders
    WHERE status = 'paid'
)
SELECT
    user_id,
    order_id,
    order_time,
    prev_order_time,
    TIMESTAMPDIFF(DAY, prev_order_time, order_time) AS gap_days
FROM t
WHERE prev_order_time IS NOT NULL;
```

适合分析复购周期、学习间隔、内容消费频率。

### 2. 首次行为后多久转化

例如用户注册后多久首单：

```sql
WITH first_pay AS (
    SELECT
        user_id,
        MIN(order_time) AS first_pay_time
    FROM orders
    WHERE status = 'paid'
    GROUP BY user_id
)
SELECT
    u.user_id,
    u.register_time,
    f.first_pay_time,
    TIMESTAMPDIFF(DAY, u.register_time, f.first_pay_time) AS days_to_pay
FROM users u
LEFT JOIN first_pay f
    ON u.user_id = f.user_id;
```

这里用 `LEFT JOIN` 是为了保留没有支付的用户，否则转化周期会被高估。

### 3. 连续 N 天但允许中断一次

这类题更难，面试中偶尔出现。思路通常不是直接套固定模板，而是先按用户日期去重，再找日期序列、窗口范围内的活跃天数。例如“7 天内活跃不少于 6 天”：

```sql
WITH user_day AS (
    SELECT DISTINCT
        user_id,
        DATE(event_time) AS dt
    FROM events
),
win AS (
    SELECT
        a.user_id,
        a.dt AS start_dt,
        COUNT(DISTINCT b.dt) AS active_days_7d
    FROM user_day a
    JOIN user_day b
        ON a.user_id = b.user_id
       AND b.dt >= a.dt
       AND b.dt < DATE_ADD(a.dt, INTERVAL 7 DAY)
    GROUP BY a.user_id, a.dt
)
SELECT DISTINCT user_id
FROM win
WHERE active_days_7d >= 6;
```

这类题重点是转化为“窗口内计数”，不要只盯着连续登录的 `date - rn` 技巧。

---

## 三十三、大厂还会考的专题八：结果校验与反查思路

很多候选人写完 SQL 就结束了，但真实工作中一定要校验。面试中主动说校验思路很加分。

### 1. 总量校验

例如分渠道 GMV 之和应该等于总 GMV，或者接近总 GMV。

```sql
-- 总 GMV
SELECT SUM(amount) AS total_gmv
FROM orders
WHERE status = 'paid';

-- 分渠道 GMV
SELECT channel, SUM(amount) AS gmv
FROM orders
WHERE status = 'paid'
GROUP BY channel;
```

如果分渠道加总明显大于总量，可能是 JOIN 膨胀或渠道映射重复。

### 2. 去重校验

检查一张维表的主键是否唯一：

```sql
SELECT
    user_id,
    COUNT(*) AS cnt
FROM dim_user
GROUP BY user_id
HAVING COUNT(*) > 1;
```

如果维表 `user_id` 不唯一，JOIN 事实表后会放大事实表。

### 3. NULL 校验

```sql
SELECT
    COUNT(*) AS total_rows,
    COUNT(user_id) AS non_null_user_id,
    COUNT(*) - COUNT(user_id) AS null_user_id_rows
FROM events;
```

如果关键字段 NULL 很多，指标可能不可信。

### 4. 分母校验

比例类指标最怕分母错。比如转化率突然升高，可能不是分子变多，而是分母因为筛选条件少算了。

建议写完比例后，把分子和分母都输出出来：

```sql
SELECT
    dt,
    exposure_users,
    click_users,
    click_users * 1.0 / NULLIF(exposure_users, 0) AS ctr
FROM result;
```

不要只输出一个比例，否则很难判断问题来自哪里。

---

## 三十四、大厂 SQL 面试题型分类总表

最后可以把常见题型按“考察点”归类，这样刷题更有方向。

| 题型 | 常见问法 | 核心 SQL 能力 | 关键风险 |
|---|---|---|---|
| 基础统计 | 每日订单数、每月 GMV | `GROUP BY`、聚合 | 时间范围、订单状态 |
| 分组 TopN | 每个城市 GMV 前 3 商品 | 窗口函数 | 全局 `LIMIT` 误用、并列排名 |
| 留存 | 次日留存、7 日留存 | 自连接、日期差、去重 | 分母口径、精确 N 日 vs N 日内 |
| 转化漏斗 | 曝光-点击-支付 | 条件聚合、时间顺序 | 是否严格顺序、是否去重 |
| 复购回购 | 复购率、老客回购率 | 用户级聚合、自连接 | 周期口径、分母选择 |
| 连续活跃 | 连续 3 天登录 | 窗口函数、日期减排名 | 同一天多次行为要去重 |
| 生命周期 | 新增、流失、召回 | 反连接、周期对比 | 窗口定义不清 |
| 异动分析 | GMV 为什么下降 | 分维度聚合、同比环比 | 数据延迟、维度归因 |
| A/B 实验 | 实验组转化率 | 分组聚合、时间窗口 | 实验污染、行为先后 |
| 数据清洗 | 字段类型不一致、缺失 | `CAST`、`TRIM`、`CASE WHEN` | 清洗规则影响结果 |
| 性能优化 | 查询慢怎么办 | 分区、索引、先过滤 | 全表扫描、大表明细 JOIN |

真正复习时，可以每类准备 2 到 3 道题，不需要无限刷。重点是每类题都能说清楚：

```text
这类题的分母是谁？
最终结果粒度是什么？
是否需要保留未发生行为的人？
是否需要先去重或先聚合？
JOIN 会不会导致膨胀？
```

如果这些问题能稳定回答，SQL 面试就不会只停留在“背模板”的层面。
