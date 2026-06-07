# SQL 数据分析面试系统笔记

> 适用目标：数据分析、商业分析、数据运营、数据产品、增长分析等岗位的 SQL 面试准备。  
> 学习目标：不仅会写语法，还要能把业务问题拆成“数据表、粒度、筛选、聚合、关联、窗口、指标口径”的查询方案。

---

## 一、数分岗位为什么重视 SQL

SQL 是数据分析岗位最基础、最常被考察的硬技能。原因很直接：真实公司的业务数据通常存放在数据库、数仓或数据湖表中，分析师每天要做的事情，往往不是先建复杂模型，而是先把数据取对、算准、解释清楚。

在面试中，SQL 考察通常有三层：

第一层是基础语法。包括 `SELECT`、`FROM`、`WHERE`、`GROUP BY`、`HAVING`、`ORDER BY`、`LIMIT`、`JOIN`、子查询、窗口函数等。

第二层是数据分析思维。包括指标口径、统计粒度、去重逻辑、时间范围、分母分子、用户生命周期、留存、转化、复购、连续活跃、TopN、分层对比等。

第三层是工程意识。包括 NULL 处理、重复数据处理、日期函数差异、类型转换、查询性能、索引意识、数仓分区、避免笛卡尔积、避免错误聚合等。

很多候选人会背语法，但一到业务题就卡住。根本原因是没有把 SQL 当成“业务问题到数据结果的翻译器”。面试时你要先明确：问题问的对象是谁，时间范围是什么，统计粒度是什么，分母和分子分别是什么，是否需要去重，是否需要多表关联，最后结果按什么维度展示。

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

---

## 二十三、面试表达方式

写 SQL 前可以先说：

> 我先确认一下口径：这道题的统计粒度是按天，分母是当天去重活跃用户数，分子是第二天仍然活跃的去重用户数。因为要保留没有留存的用户，所以我会用当天用户作为主表，再 LEFT JOIN 第二天行为。

这种表达比直接写代码更像真实分析师。

写完 SQL 后可以补充：

> 这里我先对用户和日期去重，避免同一用户一天多次行为导致留存分母膨胀。日期范围采用左闭右开，避免时间戳边界问题。如果要按渠道或城市看留存，可以在新增用户 CTE 中保留渠道或城市字段，再在最终结果中分组。

面试官通常关心的不只是 SQL 能不能跑，还关心你有没有指标意识和数据质量意识。

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

