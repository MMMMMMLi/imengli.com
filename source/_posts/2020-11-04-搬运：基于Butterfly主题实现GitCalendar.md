---
title: 搬运：基于Butterfly主题实现GitCalendar
tags:
  - Blob
  - 搬运
categories:
  - Blob
keywords:
  - Blob
cover: /img/post/girl.jpg
date: 2020-11-04 17:09:01
updated: 2020-11-04 17:09:04
---

{% note success simple %}
之前就在别人的博客中看到过类似的样式，就想着弄一个，搜索了一圈，没有啥结果，就不了了之了。

今天偶尔在群里看到了一个老哥的博客，也有这个样式。

并且还有一个教程，就照着弄了一下，也在这搬运一下教程，方便后续修改。

[教程：基于Butterfly主题的gitcalendar2.0](https://zfe.space/2020/10/28/2020-10-31/)

{% endnote %}

---

## 步骤1：修改pug代码

### 下载文件

{% btn 'https://github.com/Zfour/Butterfly-gitcalendar', 资源包下载 %}

### 增加、替换代码

前往"根目录\themes\butterfly\layout"文件夹

将资源包中的"gitcalendar.pug"复制到文件夹中。

将"index.pug"复制并重命名为"index-re.pug"作为备份。

将资源包pug文件夹的Original中的"index.pug"覆盖进行替换，如果你使用磁贴请使用Magnet Plus文件夹的"index.pug"。

或者打开"index.pug"按照以下代码进行修改。修改的起始点为"#recent-posts.recent-posts"。

```properties
extends includes/layout.pug

block content
  include ./includes/mixins/post-ui.pug
  #recent-posts.recent-posts
    .recent-post-item(style='width:100%')
       include gitcalendar.pug
    .recent-post-item(style='height:0px;clear:both;margin-top: 0px;')
    +postUI
    include includes/pagination.pug
```

## 步骤2：添加引入js、css代码

### 放置资源包

将下载包中的gitcalendar文件夹放入根目录的"source"文件夹下。

### 引入js和css

打开"\themes\butterfly\"路径下的"_config.yml"

搜索到"inject:"设置处

添加以下代码：

若已有vue引入，请确保vue的版本为2.6以上。

```yaml
inject:
  head:
  - <link rel="stylesheet" href="/gitcalendar/css/gitcalendar.css"/>

  bottom:
  - <script src="https://cdn.jsdelivr.net/npm/vue@2.6.11"></script>
  - <script src="/gitcalendar/js/gitcalendar.js"></script>
```

## 步骤3：填写自定义属性的js配置

本磁贴通过gitcalendar.js的配置项实现以下自定义属性。

### 配置用户信息

填写github用户名，配置用户信息。

```js
data: {
        user:'MMMMMMLi' //用户名称
}
```

### 配置颜色主题

这个位置修改了一下，觉着不是很理想，就使用默认吧。

## 步骤4：运行

`hexo clean && hexo g`

----
