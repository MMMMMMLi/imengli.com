---
title: 使用GitHub的Actions实现博客的远程更新及部署
tags:
  - Blob
  - CI/CD
  - Github
categories:
  - Blob
keywords:
  - Blob
cover: /img/post/onepiece.png
description: 使用GitHub的Actions实现博客的远程更新及部署。
date: 2020-11-02 17:54:00
updated: 2020-11-02 17:54:05
---

{% note success  %}
之前的时候，想着使用自己的服务器，然后借用Gitlab来实现这个骚操作，可是验证了一下，感觉自己不大行。

随后在一次偶然的机会中，发现了GitHub也出了自己的CI/CD，研究了一下，有了此文。

写文之前已经在别的项目中已经运用了两三个月了，觉着还行。

这篇博文是为什么来的问题以及想法，详情看

[基于自己购买的阿里云服务器，实现使用GitLab CI/CD 完成博客的自动构建的想法](https://imengli.com/article/30807.html)

{% endnote %}

---

## GitHub Actions 是什么？

大家知道，持续集成由很多操作组成，比如抓取代码、运行测试、登录远程服务器，发布到第三方服务等等。GitHub 把这些操作就称为 actions。

很多操作在不同项目里面是类似的，完全可以共享。GitHub 注意到了这一点，想出了一个很妙的点子，允许开发者把每个操作写成独立的脚本文件，存放到代码仓库，使得其他开发者可以引用。

如果你需要某个 action，不必自己写复杂的脚本，直接引用他人写好的 action 即可，整个持续集成过程，就变成了一个 actions 的组合。这就是 GitHub Actions 最特别的地方。

GitHub 做了一个[官方市场](https://github.com/marketplace?type=actions)，可以搜索到他人提交的 actions。另外，还有一个 [awesome actions](https://github.com/sdras/awesome-actions) 的仓库，也可以找到不少 action。

上面说了，每个 action 就是一个独立脚本，因此可以做成代码仓库，使用`userName/repoName`的语法引用 action。比如，`actions/setup-node`就表示`github.com/actions/setup-node`这个[仓库](https://github.com/actions/setup-node)，它代表一个 action，作用是安装 Node.js。事实上，GitHub 官方的 actions 都放在 [github.com/actions](https://github.com/actions) 里面。

既然 actions 是代码仓库，当然就有版本的概念，用户可以引用某个具体版本的 action。下面都是合法的 action 引用，用的就是 Git 的指针概念，详见[官方文档](https://help.github.com/en/articles/about-actions#versioning-your-action)。

```shell
actions/setup-node@74bc508 # 指向一个 commit
actions/setup-node@v1.0    # 指向一个标签
actions/setup-node@master  # 指向一个分支
```

## 基本概念

GitHub Actions 有一些自己的术语。

（1）**workflow** （工作流程）：持续集成一次运行的过程，就是一个 workflow。

（2）**job** （任务）：一个 workflow 由一个或多个 jobs 构成，含义是一次持续集成的运行，可以完成多个任务。

（3）**step**（步骤）：每个 job 由多个 step 构成，一步步完成。

（4）**action** （动作）：每个 step 可以依次执行一个或多个命令（action）。

## workflow 文件

GitHub Actions 的配置文件叫做 workflow 文件，存放在代码仓库的`.github/workflows`目录。

workflow 文件采用 [YAML 格式](http://www.ruanyifeng.com/blog/2016/07/yaml.html)，文件名可以任意取，但是后缀名统一为`.yml`，比如`foo.yml`。一个库可以有多个 workflow 文件。GitHub 只要发现`.github/workflows`目录里面有`.yml`文件，就会自动运行该文件。

workflow 文件的配置字段非常多，详见[官方文档](https://help.github.com/en/articles/workflow-syntax-for-github-actions)。下面是一些基本字段。

**（1）`name`**

`name`字段是 workflow 的名称。如果省略该字段，默认为当前 workflow 的文件名。

```bash
name: GitHub Actions Demo
```

**（2）`on`**

`on`字段指定触发 workflow 的条件，通常是某些事件。

```bash
on: push
```

上面代码指定，`push`事件触发 workflow。

`on`字段也可以是事件的数组。

```bash
on: [push, pull_request]
```

上面代码指定，`push`事件或`pull_request`事件都可以触发 workflow。

完整的事件列表，请查看[官方文档](https://help.github.com/en/articles/events-that-trigger-workflows)。除了代码库事件，GitHub Actions 也支持外部事件触发，或者定时运行。

**（3）`on..`**

指定触发事件时，可以限定分支或标签。

```bash
on:
  push:
    branches:    
      - master
```

上面代码指定，只有`master`分支发生`push`事件时，才会触发 workflow。

**（4）`jobs..name`**

workflow 文件的主体是`jobs`字段，表示要执行的一项或多项任务。

`jobs`字段里面，需要写出每一项任务的`job_id`，具体名称自定义。`job_id`里面的`name`字段是任务的说明。

```javascript
jobs:
  my_first_job:
    name: My first job
  my_second_job:
    name: My second job
```

上面代码的`jobs`字段包含两项任务，`job_id`分别是`my_first_job`和`my_second_job`。

**（5）`jobs..needs`**

`needs`字段指定当前任务的依赖关系，即运行顺序。

```javascript
jobs:
  job1:
  job2:
    needs: job1
  job3:
    needs: [job1, job2]
```

上面代码中，`job1`必须先于`job2`完成，而`job3`等待`job1`和`job2`的完成才能运行。因此，这个 workflow 的运行顺序依次为：`job1`、`job2`、`job3`。

**（6）`jobs..runs-on`**

`runs-on`字段指定运行所需要的虚拟机环境。它是必填字段。目前可用的虚拟机如下。

- `ubuntu-latest`，`ubuntu-18.04`或`ubuntu-16.04`
- `windows-latest`，`windows-2019`或`windows-2016`
- `macOS-latest`或`macOS-10.14`

下面代码指定虚拟机环境为`ubuntu-18.04`。

```javascript
runs-on: ubuntu-18.04
```

**（7）`jobs..steps`**

`steps`字段指定每个 Job 的运行步骤，可以包含一个或多个步骤。每个步骤都可以指定以下三个字段。

- `jobs..steps.name`：步骤名称。
- `jobs..steps.run`：该步骤运行的命令或者 action。
- `jobs..steps.env`：该步骤所需的环境变量。

下面是一个完整的 workflow 文件的范例。

```javascript
name: Greeting from Mona
on: push

jobs:
  my-job:
    name: My Job
    runs-on: ubuntu-latest
    steps:
    - name: Print a greeting
      env:
        MY_VAR: Hi there! My name is
        FIRST_NAME: Mona
        MIDDLE_NAME: The
        LAST_NAME: Octocat
      run: |
        echo $MY_VAR $FIRST_NAME $MIDDLE_NAME $LAST_NAME.
```

上面代码中，`steps`字段只包括一个步骤。该步骤先注入四个环境变量，然后执行一条 Bash 命令。

## 我的Actions

上面那些都是一些术语的解释，由于最近事情较多，就没有去找专门的`Hexo` 的Action脚本，就利用SSH远程命令来实现脚本的运行。

### workflow文件

```shell
name: Blob Aliyun Project CICD

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: executing remote ssh
      uses: appleboy/ssh-action@master
      with:
        host: ${{ secrets.ALIYUN_HOST }}
        username: ${{ secrets.ALIYUN_USER }}
        password: ${{ secrets.ALIYUN_PASSWORD }}
        port: ${{ secrets.ALIYUN_PORT }}
        script: bash /root/blob/updateBlob.sh
```

具体的代码解释就不多解释了，就单独解释一下`${{  }}` 的意义吧。

这些内容是一些比较敏感的内容，像服务器的地址啊，服务器的端口号啊，这些都是一些敏感数据，GitHub想的非常全面，在当前项目中选择：`Settings --> Secrets --> New secret` 就可以添加一些敏感的数据了。就是一套键值对。

![图例](/img/post/githubSecret.png)



**此处有一个坑，就是workflow文件需要放到每个项目的`.github/workflows/` 文件夹下，要不然GitHub识别不到，不会执行。**



### 运行脚本

```shell
#!/bin/bash
source /etc/profile

if [ ! -d "/blob/public/" ];then
echo "文件夹不存在"
else

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 开始更新仓库。"
git pull origin main

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 仓库更新完毕，开始编译环境。"

hexo clean && hexo g

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> OK "
fi
```

具体的需要根据每个环境来修改。



----

Over。

未来可期。

加油！