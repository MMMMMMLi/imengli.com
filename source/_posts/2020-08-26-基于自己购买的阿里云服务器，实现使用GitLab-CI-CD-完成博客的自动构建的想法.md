---
title: 基于自己购买的阿里云服务器，实现使用GitLab CI/CD 完成博客的自动构建的想法
tags:
  - Blob
  - GitLab
  - CI/CD
categories:
  - Blob
keywords:
  - 'GitLab,Blob,Hexo,CI/CDl'
cover: /img/post/cai.png
description: 现在写博客都要自己手动创建，测试，构建等工作，想着能不能基于GitLab的CI/CD来实现自动部署呢，分析一下可行性。现在
abbrlink: 30807
date: 2020-08-26 11:28:26
updated: 2020-09-18 10:10:44
---

{% note warning simple %}
经过实践和调研，这个方法蠢爆了，:broken_heart: 既要需要自己搭建Gitlab服务，还需要保证自己的服务器性能强大。:mask::mask:

研究了一下，发现GitHub也出了自己的CICD服务：Actions，:neutral_face: 所以决定使用Github Actions来实现此效果。

后续研究明白了之后，写一下Github Actions的使用过程。:muscle:
{% endnote %}


---

## 问题

不管是基于Github Pages构建博客，还是通过nginx代理自己的云服务器，现在每次写博客，都要一些重复性的操作。（或者说是我还没有发现什么比较省事的办法。。。）

创建博文；编辑博文；重新生成静态文件。

## 想法

既然每次写博客都是这些重复性的操作，那么能不能利用一些CI/CD的工作来实现这些重复性的工作呢？

大体的流程如下：

1. 创建一个Gitlab的仓库；
2. 服务器环境构建好GitLabRunner等组件；
3. 在本地编写一遍博文提交到远程仓库；
4. 仓库根据编写的好的CI文件来逐步实现博文的创建以及重新生成静态文件的操作。

## 实践

市场上CI/CD的工作有很多，但是在之前在学习Docker的时候，接触到了GitLab的CI/CD，想着基于这个来实现，不知道可行不可行。
