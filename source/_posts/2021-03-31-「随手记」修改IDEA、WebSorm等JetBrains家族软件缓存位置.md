---
title: 「随手记」修改JetBrains家族软件（IDEA、WebStorm等）缓存位置
tags:
  - 随手记
categories:
  - 随手记
cover: /img/post/ssj.jpg
abbrlink: 41533
date: 2021-03-31 15:16:09
updated: 2021-03-31 15:16:13
---

{% note simple %}

前几天闲着没事，看了一眼Windows系统存储。

好家伙，100多G的C盘马上就满了，赶快清理一下，结果清理了一圈没怎么清掉。

然后查看了一下文件夹存储，发现IDEA和WebStorm的缓存占了10个多G，所以就想着迁移一下。

{% endnote %}

# 问题原因

由于这些软件在使用过程中会产生一些缓存文件，或者是安装的插件等，这些文件都是默认安装在了C盘下面。

路径：C:\Users\UserName\.IntelliJIdea2020.3 ... 等等

# 问题解决

## 打开对应软件的安装目录，找到bin文件夹

![路径](/img/post/path.png)

## 修改`idea.propertie`文件

使用notepad++或者vscode等软件打开，修改config和system的配置项。

![配置文件](/img/post/ideaproperties.png)

## 移动文件

修改完成之后，把C盘对应的数据剪切到目标文件夹就行。

# 迁移之后的问题

## 重新激活

迁移之后，我再重新打开的时候，所有的软件都需要重新激活一下。emmmm，麻烦。

所以在安装的时候，一定要提前考虑配置好。
