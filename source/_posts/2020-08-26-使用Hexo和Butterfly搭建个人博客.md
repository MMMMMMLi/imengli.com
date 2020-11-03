---
title: 使用Hexo和Butterfly搭建个人博客
tags:
  - Hexo
  - Blob
categories:
  - Hexo
keywords:
  - 'Hexo,搭建笔记'
description: 记录一下如何使用Hexo和Butterfly搭建的个人博客。
cover: /img/post/zhenhunjie.jpg
abbrlink: 23840
sticky: 2
date: 2020-08-25 10:33:47
updated: 2020-08-27 15:08:08
---

## 序言

一直想着能够有一天拥有自己的博客系统，最近梦想成真了。

年后疫情在家的时候，自己搞了一台阿里云服务器，用来学习大数据等相关组件，然后在前一阵学习`SpringCloud` 相关知识的时候，发现了一个个人博客，机缘巧合之下了解了一下博客的搭建过程，发现挺简单的，遂着手开始学习如何搭建。

耗时三天，利用`Hexo + Butterfly` 搭建出了现在这套博客，后续样式啥的，慢慢更新，先重新记录一下搭建以及修改过程，方便后续有跟我一样有想法的小白来实现自己的博客梦。

我的博客主要搭建在了自己的阿里云服务器上，没有使用`Github Pages` ，如果是使用`Github Pages` 的话，那这篇博文的意义不是很大。

## 安装准备

### 环境说明

以下这些组件以及配置是我在搭建的过程中使用的。时间为：`2020-08-21 10:07:22` 

| 环境属性 | 环境参数                                                     | 环境备注                 |
| -------- | ------------------------------------------------------------ | ------------------------ |
| 服务器   | `Centos 7.8` <br />`Cpu：2核`<br />`内存：4G`<br />`存储：50G` | 低配                     |
| `Node`   | `v12.18.3`                                                   | `Hexo`需要依赖node运行。 |
| `Git`    | `git version 1.8.3.1`                                        | 样式库需要从`git`获取。  |

### 环境安装

这些组件的安装比较简单，可以直接通过`yum` 方式安装。

```shell
yum install -y git nodejs
```

`Git` 的安装我是使用`yum` 安装的，`nodejs` 我是直接从官网下载的二进制包直接解压使用的。

### 名词说明

> Hexo

[官方文档解释](https://hexo.io/zh-cn/docs/) ： Hexo 是一个快速、简洁且高效的博客框架。Hexo 使用 [Markdown](http://daringfireball.net/projects/markdown/)（或其他渲染引擎）解析文章，在几秒内，即可利用靓丽的主题生成静态网页。

个人理解的话，没有。

> Butterfly

是一个基于Hexo开发的模板库，可以让自己的博客更加好看。

[GitHub仓库地址。](https://github.com/jerryc127/hexo-theme-butterfly)

[Demo以及文档地址。](https://demo.jerryc.me/)

## Hexo安装

环境准备完毕之后，就开始着手安装Hexo，当然，也可以参考上面贴出的Hexo官方文档。

1. 安装淘宝镜像，其实安装不安装都可以，就是心里因素加加速。

   ```shell
   npm install -g cnpm --registry=https://registry.npm.taobao.org
   ```

2. 安装Hexo。

   ```shell
   cnpm install -g hexo
   # 安装完毕之后，测试，会展示出好多信息。
   hexo -v
   # 我当前的版本是：5.0.2
   ```

3. 初始化一个博客系统，并安装相关依赖。

   ```shell
   # init后面跟啥名，就创建一个啥名的目录，也可以自己创建，然后进入目录之后执行hexo init即可。
   hexo init blob
   cd blob
   hexo install
   ```

4. 安装完毕之后，目录树如下：

   ```shell
   # linux目录树命令：tree -L 1
   .
   ├── _config.yml		# 主要的配置文件
   ├── package.json	# 当前项目的package信息
   ├── scaffolds		# 模板文件夹
   ├── source			# 资源文件夹
   └── themes			# 主题文件夹
   ```

5. 启动。

   ```shell
   hexo server # 或者 hexo s
   ```

6. 测试。

   直接访问当前启动服务器的4000端口即可。

## ~~编写博文~~

~~Hexo提供了比较好的命令操作，需要更多了解的话，还是看上面的官方博客吧。~~

```shell
原来想着是先写如何编写博文以及Hexo的使用，但是突然想到集成了Butterfly之后，还会添加一些别的博文参数，所以就将集成Butterfly提到前面编写。
By: 2020-08-25 17:31:46
```

## 集成Butterfly，让博客更美丽

### 安装Butterfly

Butterfly的安装官方Demo里面推荐有两个办法，一个是Git一个是npm，我这边使用的是Git安装的方法。

```shell
# 运行这条指令的时候，需要在当前博客空间的根目录下执行。
# 当然也可以换位置，就是需要将下面的themes/butterfly换成正确路径即可。
git clone -b master https://github.com/jerryc127/hexo-theme-butterfly.git themes/butterfly
```

### 应用主题

修改站点配置文件`_config.yml`，把主题改为 butterfly。

```yaml
# 在倒数的位置
theme: butterfly
```

配置完毕之后，将`themes/butterfly` 目录下的配置文件，复制到博客的根目录。

```shell
cp themes/butterfly/_config.yml _config.butterfly.yml
```

Hexo会自动合并这两个配置文件，自定义的配置文件优先级高。

### 安装插件

```shell
npm install hexo-renderer-pug hexo-renderer-stylus --save
```

### 测试

关闭刚才开启的Hexo Server，重新运行。

发现新的博客界面就是已经集成了Butterfly之后的。

## 配置博客参数

安装完Butterfly之后，Hexo的配置文件主要是有两个，一个关于Hexo博客的基本配置，一个是关于Butterfly的页面优化配置。

下面记录以下一些比较重要的参数配置。

###  _config.yml

- 网站基本信息

  ```yaml
  # Site
  title: ❤ MengLi #博客标题
  subtitle: 记录成长与爱 ❤ #博客副标题
  description: 一个热爱技术却很菜的大龄程序员，记录今后的每一点点进步和生活。 #博客的描述
  keywords: mengli,java,blob,
  author: Weijia Jiang #你的名字
  language: zh-CN #网站使用的语言，使用 ISO-639-1，默认 en （这个选项貌似跟主题是否国际化了有关）
  timezone: Asia/Shanghai #网站时区 像 America/New_York, Japan, UTC 这种
  email: 
  ```

- 连接相关

  ```yaml
  # URL
  url: http://imengli.com	# 其实就这个重要，就是在文章版权信息那显示的。
  root: /
  permalink: :year/:month/:day/:title/
  permalink_defaults:
  pretty_urls:
    trailing_index: true 
    trailing_html: true 
  ```

- 文件夹相关

  ```yaml
  # Directory
  source_dir: source #资源文件夹
  public_dir: public #公共文件夹
  tag_dir: tags #标签文件夹
  archive_dir: archives #归档文件夹
  category_dir: categories #分类文件夹
  code_dir: downloads/code #Include code 文件夹
  i18n_dir: :lang #国际化（i18n）文件夹
  skip_render: #跳过指定文件的渲染，您可使用 glob 来配置路径。
  ```

- 写作相关

  ```yaml
  # Writing
  new_post_name: :year-:month-:day-:title.md # 新文章的文件名称
  default_layout: post #预设布局
  titlecase: false # 把标题转换为单词首字母大写
  external_link:
    enable: true # 在新标签中打开链接
    field: site # Apply to the whole site
    exclude: ''
  filename_case: 0 #把文件名称转换为 (1) 小写或 (2) 大写
  render_drafts: false #显示草稿
  post_asset_folder: false #启动 Asset 文件夹，为 true 时，每次建立文件时，Hexo 会自动建立一个与文章同名的文件夹
  relative_link: false #把链接改为与根目录的相对位址
  future: true #显示未来的文章
  highlight: #代码块的设置
    enable: true
    line_number: true
    auto_detect: true
    tab_replace:
  prismjs:
    enable: false
    preprocess: true
    line_number: true
    tab_replace: ''
  ```

- 其余的配置基本就是取默认就行。

###  _config.butterfly.yml

这一块的配置比较多也比较复杂，作者的[Demo博客](https://demo.jerryc.me/)中有详细的配置教程博文，详细参考那个来就行。

想要我的配置文件，直接留言留邮箱就行。

## 编写博文

### 页面配置项

| 写法             | 解释                                                         |
| ---------------- | ------------------------------------------------------------ |
| title            | 【必需】页面标题                                             |
| date             | 【必需】页面创建日期                                         |
| type             | 【必需】标籤、分类和友情链接三个页面需要配置                 |
| updated          | 【可选】页面更新日期                                         |
| description      | 【可选】页面描述                                             |
| keywords         | 【可选】页面关键字                                           |
| comments         | 【可选】显示页面评论模块 (默认 true)                         |
| top_img          | 【可选】页面顶部图片                                         |
| mathjax          | 【可选】显示 mathjax (当设置 mathjax 的 per_page: false 时，才需要配置，默认 false) |
| katex            | 【可选】显示 katex (当设置 katex 的 per_page: false 时，才需要配置，默认 false) |
| aside            | 【可选】显示侧边栏 (默认 true)                               |
| aplayer          | 【可选】在需要的页面加载 aplayer 的 js 和 css, 请参考文章下面的音乐 配置 |
| highlight_shrink | 【可选】配置代码框是否展开 (true/false)(默认为设置中 highlight_shrink 的配置) |

### 文章配置项

| 写法                  | 解释                                                         |
| --------------------- | ------------------------------------------------------------ |
| title                 | 【必需】文章标题                                             |
| date                  | 【必需】文章创建日期                                         |
| updated               | 【可选】文章更新日期                                         |
| tags                  | 【可选】文章标籤                                             |
| categories            | 【可选】文章分类                                             |
| keywords              | 【可选】文章关键字                                           |
| description           | 【可选】文章描述                                             |
| top_img               | 【可选】文章顶部图片                                         |
| cover                 | 【可选】文章缩略图 (如果没有设置 top_img, 文章页顶部将显示缩略图，可设为 false / 图片地址 / 留空) |
| comments              | 【可选】显示文章评论模块 (默认 true)                         |
| toc                   | 【可选】显示文章 TOC (默认为设置中 toc 的 enable 配置)       |
| toc_number            | 【可选】显示 toc_number (默认为设置中 toc 的 number 配置)    |
| auto_open             | 【可选】是否自动打开 TOC (默认为设置中 toc 的 auto_open 配置) |
| copyright             | 【可选】显示文章版权模块 (默认为设置中 post_copyright 的 enable 配置) |
| copyright_author      | 【可选】文章版权模块的文章作者                               |
| copyright_author_href | 【可选】文章版权模块的文章作者链接                           |
| copyright_url         | 【可选】文章版权模块的文章连结链接                           |
| copyright_info        | 【可选】文章版权模块的版权声明文字                           |
| mathjax               | 【可选】显示 mathjax (当设置 mathjax 的 per_page: false 时，才需要配置，默认 false) |
| katex                 | 【可选】显示 katex (当设置 katex 的 per_page: false 时，才需要配置，默认 false) |
| aplayer               | 【可选】在需要的页面加载 aplayer 的 js 和 css, 请参考文章下面的音乐 配置 |
| highlight_shrink      | 【可选】配置代码框是否展开 (true/false)(默认为设置中 highlight_shrink 的配置) |

### 修改几个页面

- 生成页面

```shell
# 生成tag页面
hexo new page tag
# 生成categorie页面
hexo new page categorie
# 生成友情链接页面
hexo new page link
```

- 修改页面样式

```markdown
# 进入每个页面的文件夹：source/{pagename}/index.md
# 修改配置
---
title: tags
date: 2020-08-25 14:13:13
type: "{type}"	# 添加这个参数
aside: false	# 这个参数是不显示评论
comments: false	# 这个参数不显示侧边栏
---

# 其中友情链接页面，还需要在：source/_data 目录下创建一个link.yml配置文件，具体配置如下：
- class_name: 链接的栏目
  class_desc: 连接的说明
  link_list:	# 具体的地址
    - name: JerryC	# 名字
      link: https://jerryc.me/	# 连接地址
      avatar: https://jerryc.me/image/avatar.png # 头像
      descr: 今日事,今日毕	# 说明
```

### 编写博文

- 新建博文

  博文的模板是根据`scaffolds/post.md` 来生成的，可以自己修改。

```shell
hexo new {title}
```

- 编写博文

  新建的博文默认是根据配置文件中声明的`{new_post_name}` 来命名的，到`source/_post`目录中找到博文的md文件，开始写作吧。
  
- 常用的参数

```markdown
title: 
date: 
updated: 
tags:
- 
categories:
- 
keywords:
- 
description: 
cover: 
```

## 常用命令

### hexo init

`hexo init` 命令用于初始化本地文件夹为网站的根目录

```shell
hexo init [folder]
```

- `folder` 可选参数，用以指定初始化目录的路径，若无指定则默认为当前目录

### hexo new

```shell
# hexo new` 命令用于新建文章，一般可以简写为 `hexo n
hexo new [layout] <title>
```

- `layout` 可选参数，用以指定文章类型，若无指定则默认由配置文件中的 default_layout 选项决定
- `title` 必填参数，用以指定文章标题，如果参数值中含有空格，则需要使用双引号包围

### hexo generate

```shell
# hexo generate` 命令用于生成静态文件，一般可以简写为 `hexo g
hexo generate
```

- `-d` 选项，指定生成后部署，与 `hexo d -g` 等价

### hexo server

```shell
# hexo server` 命令用于启动本地服务器，一般可以简写为 `hexo s
hexo server
# 一般server只是用来本地测试，正式部署的时候不建议使用这个方式
```

- `-p` 选项，指定服务器端口，默认为 4000
- `-i` 选项，指定服务器 IP 地址，默认为 0.0.0.0
- `-s` 选项，静态模式 ，仅提供 public 文件夹中的文件并禁用文件监视

###  hexo clean

`hexo clean` 命令用于清理缓存文件，是一个比较常用的命令

```shell
hexo clean
```

**网站显示异常时可尝试此操作**



-----

**图文无关。**



![镇魂街](/img/post/zhenhunjie.jpg)

文章首页图为许辰的[镇魂街](https://www.u17.com/comic/3166.html)最新话的插图，强吹一波，喜欢的可以去支持下。