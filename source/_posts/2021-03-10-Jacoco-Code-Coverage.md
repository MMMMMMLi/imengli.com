---
title: Jacoco Code Coverage
tags:
    - 测试
    - Jacoco
categories:
    - Jacoco
cover: /img/post/Jacoco.jpg
date: 2021-03-10 17:02:36
updated: 2021-03-10 18:11:50
---

{% note simple %}

最近公司项目在重构，在搞单元测试的时候，发现这样一个代码覆盖率的工具；

由于之前没有使用过，就边学习边记录一下吧。

{% endnote %}

---

# 代码覆盖率工具介绍

市场上主要代码覆盖率工具：
- Emma
- Cobertura
- Jacoco
- Clover(商用)

主要的对比如下：

| 工具         | Jacoco                                                       | Emma                                                         | Cobertura                                                    |
| ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 原理         | 使用 ASM 修改字节码                                          | 修改 jar 文件，class 文件字节码文件                          | 基于 jcoverage,基于 asm 框架对 class 文件插桩                |
| 覆盖粒度     | 行，类，方法，指令，分支                                     | 行，类，方法，基本块，指令，无分支覆盖                       | 项目，包，类，方法的语句覆盖/分支覆盖                        |
| 插桩         | on the fly、offline                                          | on the fly、offline                                          | offline，把统计代码插入编译好的class文件中                   |
| 生成结果     | 在 Tomcat 的 catalina.sh 配置 javaangent 参数，指出需要收集覆盖率的文件，shutdown 时才收集，只能使用  kill 命令关闭 Tomcat，不要使用 kill -9 | html、xml、txt，二进制格式报表                               | html，xml                                                    |
| 缺点         | 需要源代码                                                   | 1、需要 debug 版本，并打来 build.xml 中的 debug 编译项； 2、需要源代码，且必须与插桩的代码完全一致 | 1、不能捕获测试用例中未考虑的异常； 2、关闭服务器才能输出覆盖率信息（已有修改源代码的解决方案，定时输出结果；输出结果之前设置了  hook，会与某些服务器的 hook 冲突，web 测试中需要将 cobertura.ser 文件来回 copy |
| 性能         | 快                                                           | 小巧                                                         | 插入的字节码信息更多                                         |
| 执行方式     | maven，ant，命令行                                           | 命令行                                                       | maven，ant                                                   |
| Jenkins 集成 | 生成 html 报告，直接与 hudson 集成，展示报告，无趋势图       | 无法与 hudson 集成                                           | 有集成的插件，美观的报告，有趋势图                           |
| 报告实时性   | 默认关闭，可以动态从 jvm dump 出数据                         | 可以不关闭服务器                                             | 默认是在关闭服务器时才写结果                                 |
| 维护状态     | 持续更新中                                                   | 停止维护                                                     | 停止维护                                                     |

# Jacoco介绍

Jacoco是一个开源的覆盖率工具，它针对的开发语言是java，其使用方法很灵活，可以嵌入到Ant、Maven中；可以作为Eclipse插件，可以使用其JavaAgent技术监控Java程序等等。

很多第三方的工具提供了对Jacoco的集成，如sonar、Jenkins等。

Jacoco包含了多种尺度的覆盖率计数器，包含指令级覆盖(Instructions,C0coverage)，分支（Branches,C1coverage）、圈复杂度(CyclomaticComplexity)、行覆盖(Lines)、方法覆盖(non-abstract methods)、类覆盖(classes)

- Instructions：`Jacoco 计算的最小单位就是字节码指令。指令覆盖率表明了在所有的指令中，哪些被执行过以及哪些没有被执行。这项指数完全独立于源码格式并且在任何情况下有效，不需要类文件的调试信息。`

- Branches：`Jacoco 对所有的 if 和 switch 指令计算了分支覆盖率。这项指标会统计所有的分支数量，并同时支出哪些分支被执行，哪些分支没有被执行。这项指标也在任何情况都有效。异常处理不考虑在分支范围内。`

```undefined
      在有调试信息的情况下，分支点可以被映射到源码中的每一行，并且被高亮表示。
      红色钻石：无覆盖，没有分支被执行。
      黄色钻石：部分覆盖，部分分支被执行。
      绿色钻石：全覆盖，所有分支被执行。
```

- Cyclomatic Complexity：`Jacoco 为每个非抽象方法计算圈复杂度，并也会计算每个类、包、组的复杂度。根据 McCabe 1996 的定义，圈复杂度可以理解为覆盖所有的可能情况最少使用的测试用例数。这项参数也在任何情况下有效。`

- Lines：`该项指数在有调试信息的情况下计算。`

```undefined
      因为每一行代码可能会产生若干条字节码指令，所以我们用三种不同状态表示行覆盖率
      红色背景：无覆盖，该行的所有指令均无执行。
      黄色背景：部分覆盖，该行部分指令被执行。
      绿色背景：全覆盖，该行所有指令被执行。
```

- Methods：`每一个非抽象方法都至少有一条指令。若一个方法至少被执行了一条指令，就认为它被执行过。因为 Jacoco 直接对字节码进行操作，所以有些方法没有在源码显示（比如某些构造方法和由编译器自动生成的方法）也会被计入在内。`

- Classes：`每个类中只要有一个方法被执行，这个类就被认定为被执行。同 5 一样，有些没有在源码声明的方法被执行，也认定该类被执行。`

上面这段介绍摘自：[简书-纳爱斯](https://www.jianshu.com/p/16a8ce689d60)

# Jacoco原理

Jacoco使用插桩的方式来记录覆盖率数据，是通过一个probe探针来注入。

插桩模式有两种：

1. on-the-fly模式

> JVM通过 -javaagent参数指定jar文件启动代理程序，代理程序在ClassLoader装载一个class前判断是否修改class文件，并将探针插入class文件，探针不改变原有方法的行为，只是记录是否已经执行。

2. offline模式

> 在测试之前先对文件进行插桩，生成插过桩的class或jar包，测试插过桩的class和jar包，生成覆盖率信息到文件，最后统一处理，生成报告。

on-the-fly和offline对比：

on-the-fly更方便简单，无需提前插桩，无需考虑classpath设置问题。

**以下情况不适合使用on-the-fly模式：**

```shell
1. 不支持javaagent
2. 无法设置JVM参数
3. 字节码需要被转换成其他虚拟机
4. 动态修改字节码过程和其他agent冲突
5. 无法自定义用户加载类
```

3. Java方法的控制流分析

官方文档在这里：[https://www.jacoco.org/jacoco/trunk/doc/flow.html](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.jacoco.org%2Fjacoco%2Ftrunk%2Fdoc%2Fflow.html)

# Jacoco使用

官网的官方文档中，列了很多使用方式，主要有：

- [Apache Ant](https://www.eclemma.org/jacoco/trunk/doc/ant.html)
- [命令行](https://www.eclemma.org/jacoco/trunk/doc/agent.html)
- [Maven](https://www.eclemma.org/jacoco/trunk/doc/maven.html)
- [等等等等等等等等等等](https://www.eclemma.org/jacoco/trunk/doc/index.html)

别的都不详细去说明了，就列一下Maven的使用方式。

## Maven

jacoco支持生成单元测试的覆盖率和接口测试的覆盖率，本节详细描述如何用jacoco生成单元测试覆盖率。

想要在单元测试时统计单元测试的覆盖率，有两种方式，大家可以各取

###  mvn命令增加参数

在执行mvn命令时，加上`org.jacoco:jacoco-maven-plugin:prepare-agent`参数即可。

 示例：

```
mvn clean test org.jacoco:jacoco-maven-plugin:0.8.2:prepare-agent install -Dmaven.test.failure.ignore=true

其中，jacoco-maven-plugin后面跟的是jacoco的版本； 
-Dmaven.test.failure.ignore=true 是指如果单元测试失败，就会直接中断，不会产生.exec文件
```

执行以上命令后，会在当前目录下的target目录产生一个jacoco.exec文件，该文件就是覆盖率的文件：

总体说来，这种方式比较简单，在与jekins集成时也非常方便。

### 在pom文件中添加jacoco插件

具体的配置方法如下：

1. 添加maven依赖

```properties
<properties>
	<jacoco.version>0.8.2</jacoco.version>
</properties>

<dependency>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>${jacoco.version}</version>
</dependency>
```

2. 配置plugins

```properties
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>${jacoco.version}</version>
    <configuration>
    	<!-- 扫描哪些包 -->
        <includes>
          <include>com/**/*</include>
        </includes>
        <!-- 忽略哪些包 -->
        <excludes>
           <exclude>org/**</exclude>
         </excludes>
         <!-- rules覆盖規則 -->
          <rules>
            <rule implementation="org.jacoco.maven.RuleConfiguration">
              <element>BUNDLE</element>
              <limits>　　
                <!-- 指定方法覆盖率50% -->
                <limit implementation="org.jacoco.report.check.Limit">
                  <counter>METHOD</counter>
                  <value>COVEREDRATIO</value>
                  <minimum>0.50</minimum>
                </limit>
                <!-- 指定分支覆盖率50% -->
                <limit implementation="org.jacoco.report.check.Limit">
                  <counter>BRANCH</counter>
                  <value>COVEREDRATIO</value>
                  <minimum>0.50</minimum>
                </limit>
                <!-- 指定类覆盖率100% -->
                <limit implementation="org.jacoco.report.check.Limit">
                  <counter>CLASS</counter>
                  <value>MISSEDCOUNT</value>
                  <maximum>0</maximum>
                </limit>
              </limits>
            </rule>
          </rules>
    </configuration>
    <executions>
        <execution>
            <id>post-unit-test</id>
            <phase>test</phase>
            <goals>
                <goal>report</goal>
            </goals>
            <!-- 修改输出路径 -->
            <configuration>
                <dataFile>target/jacoco.exec</dataFile>
                <outputDirectory>target/jacoco-ut</outputDirectory>
            </configuration>
        </execution>
    </executions>
</plugin>
```

# 使用过程中的问题

## 多模块环境下，测试文件与源文件不在同一模块下，覆盖率无法生成

> 场景

就按照我们现在重构的项目来说，针对于不同的业务，拆分了需要模块，但是方便测试，就将所有的测试类都写到了一个模块下，但是生成覆盖率报告的时候，只有当前模块的报告，别的模块的都无法正确显示。

> 还原

有三个模块，modelA、modelB、modelC，其中A、B为业务模块，C为测试模块。

```properties
# 主Pom
<modules>
       <module>modelA</module>
       <module>modelB</module>
       <module>modelC</module>
</modules>
# modelC
<dependencies>
        <dependency>
            <groupId>com.demo</groupId>
            <artifactId>modelA</artifactId>
        </dependency>
        <dependency>
            <groupId>com.demo</groupId>
            <artifactId>modelB</artifactId>
        </dependency>
 </dependencies>
```

这样在直接打包测试的时候，生成的覆盖率报告只有modelC的覆盖率。

> 解决

1. 将主工程pom中的插件`executions`部分修改如下：

```properties
   <plugin>
     <groupId>org.jacoco</groupId>
     <artifactId>jacoco-maven-plugin</artifactId>
     <version>${jacoco-version}</version>
     <executions>
         <execution>
             <id>prepare-agent</id>
             <goals>
   			  <!-- 这是关键 -->
                 <goal>prepare-agent</goal>
             </goals>
         </execution>
    </executions>
   </plugin>
```

2. 将modelC pom中插件做如下修改：

```properties
   <plugin>
       <groupId>org.jacoco</groupId>
       <artifactId>jacoco-maven-plugin</artifactId>
       <version>${jacoco-version}</version>
       <executions>
           <execution>
               <id>report-aggregate</id>
               <phase>test</phase>
               <goals>
               	<!-- 这是关键 -->
                   <goal>report-aggregate</goal>
               </goals>
           </execution>
       </executions>
   </plugin>

   report-aggregate 是jacoco 0.7.7版本以后，专门为多模块覆盖率显示所设置，可以统计该模块所依赖的所有其他模块的覆盖率
```

3. 参考：[博客](https://www.cnblogs.com/tuzhenxian/p/11228261.html) 、[官网](https://www.eclemma.org/jacoco/trunk/doc/prepare-agent-mojo.html)