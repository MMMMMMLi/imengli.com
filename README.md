# imengli.com
主要是存储博客相关的文件，以及实现动态的部署博客文章功能。

### 目录列表

```shel
.
├── _config.butterfly.yml		# 博客的开发的模板库的配置文件，比较好看。
├── _config.yml				# 博客默认的配置文件。
├── package.json			# 博客系统是基于NodeJS来的，一些默认的包。
├── public				# 博客编译之后的目录文件，未上传。
├── README.md				# README
├── scaffolds				# 创建文章的模板文件。
├── source				# 系统所有的源文件。
│   ├── about				# 关于我
│   ├── categories			# 归档
│   ├── _data				# 一些动态文件目录
│   ├── Gallery				# 画板
│   ├── img				# 博客用到的一些照片，后续估计会去掉
│   ├── link				# 友情连接
│   ├── _posts				# 所有文章
│   └── tags				# 标签
├── themes				# 主题文件夹，未上传。
└── updateBlob.sh			# Github CI的执行脚本。
```

主要是利用`Hexo + Butterfly` 搭建的博客。

[ 详见 ](https://imengli.com/article/23840.html)

