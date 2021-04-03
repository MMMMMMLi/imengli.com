---
title: 「随手记」MyBatis编写mapper.xml时，静态常量或者静态方法的使用
tags:
  - 随手记
  - MyBatis
  - Java
categories:
  - 随手记
cover: /img/post/mybatis.jpg
date: 2021-04-03 15:03:43
updated: 2021-04-03 15:03:48
---

# 场景说明

使用MyBatis技术，书写mapper.xml时，如果在其中的ognl表达式或者sql中直接使用一些数字或者字符串的话，会造成难以维护的问题。

在Java编码中，我们通常会把这些数字或者字符串定义在常量类或者接口中，如果在mapper.xml中也可以使用这些常量就比较好了。

还好MybBatis是支持这样的需求的。

# 具体使用

比如我有一个工具类com.wts.test.DateUtil，其中有一个方法isLeapYear(int year)，用于判断某年是否闰年。而在mapper的某个select中要根据是否闰年执行不同的查询。可以类似这样：

```sql
<if test="@com.wts.test.DateUtil@isLeapYear(year)==true">
  select * from tableA
</if>
<if test="@com.wts.test.DateUtil@isLeapYear(year)==false">
  select * from tableB
</if>
```

如果要使用常量的话，假设有常量类和常量Constant.CURRENT_YEAR：

```sql
<if test=year==@com.wts.test.Consant@CURRENT_YEAR>
select * from tableC
</if>
```

# 总结

sql中：

- 使用静态方法：
```sql
<select id='testSelectA' .....>
select * from tableA where year=${@com.wts.test.DateUtil@getYear()}
</select>
```

- 使用静态常量：
```sql
<select id='testSelectB' .....>
select * from tableA where year=${@com.wts.test.Constant@CURRENT_YEAR}
</select>
```

[转载自：天胜's Blog](https://my.oschina.net/wtslh/blog/682704)