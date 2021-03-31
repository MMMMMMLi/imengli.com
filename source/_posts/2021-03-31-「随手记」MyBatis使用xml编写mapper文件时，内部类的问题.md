---
title: 「随手记」MyBatis使用xml编写mapper文件时，内部类的问题
tags:
  - 随手记
  - MyBatis
  - Java
categories:
  - 随手记
cover: /img/post/mybatis.jpg
date: 2021-03-31 16:00:33
updated: 2021-03-31 16:00:37
---

{% note simple %}

重构的时候，有一个业务场景，只需要给返回个Map对象就行，可是写完之后，发现Swagger里面没有对应的字段说明，不太友好。

但是这个结果集就这个地方用，所以就搞了一个内部类扔到对应的返回结果集中。

然后呢，在mapper里面标记返回值的时候，一直有问题，上网查了一番之后，才知道写错了，就记录一下吧。

{% endnote %}

# 第一个问题说明

在mapper里面声明返回值的时候，使用平常那种包名点的方式指定的。

```xml
<select id="getMaterialInfoByCodeOrName"
            resultType="com.mengli.InfoDTO.TestInfo">
        SELECT * 
        FROM
        material material
</select>
```

结果修改完之后，启动项目，报错：

```properties
Caused by: java.lang.ClassNotFoundException: Cannot find class: com.mengli.InfoDTO.TestInfo
	at org.apache.ibatis.io.ClassLoaderWrapper.classForName(ClassLoaderWrapper.java:200)
	at org.apache.ibatis.io.ClassLoaderWrapper.classForName(ClassLoaderWrapper.java:89)
	at org.apache.ibatis.io.Resources.classForName(Resources.java:261)
	at org.apache.ibatis.type.TypeAliasRegistry.resolveAlias(TypeAliasRegistry.java:116)
	... 83 common frames omitted
```

# 第一个问题原因

在MyBatis的mapper文件中使用内部类的方式为：类`$`内部类，而不是平常使用的那样使用`.`来获取。

所以上面的xml需要改成：

```xml
<select id="getMaterialInfoByCodeOrName"
            resultType="com.mengli.InfoDTO$TestInfo">
        SELECT * 
        FROM
        material material
</select>
```

# 第二个问题

在改完之后呢，执行查询的时候，还是报错，只不过这个错不是上面那个错了，而是：`java.lang.NoSuchMethodException：`

具体的异常信息就不贴了，大概的意思是这个类没有默认的构造方法，可是类的声明如下：

```java
@Data
public class InfoDTO {
    
    @Data
    public class TestInfo {
        
    }
}
```

按理说不会有问题啊。

# 第二个问题原因

mybatis在构建返回的时候，用的是反射，既然反射新建对象时会报错，那直接new对象的时候会不会也报错。

然后我就去new了一下，然后IDEA提示说缺少静态变量修饰不能直接创建。

所以。。。。

摘了一个大佬调研的解释：

```properties
创建非静态内部类对象时，一定要先创建起相应的外部类对象，不能直接创建。

要想在外部能直接创建，就用静态的内部类。
```

# 问题解决

在使用内部类作为返回对象的时候，需要有两个要点：

1. 内部类必须有无参构造函数；
2. 内部类必须为静态类。
