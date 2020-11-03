#!/bin/bash
source /etc/profile

cd /root/blob/

echo "----------------------------------开始更新仓库------------------------------------"
git pull origin main

echo "-------------------------------仓库更新完毕开始编译环境---------------------------------"

hexo clean && hexo g

echo "-----------------------------------编译完毕-------------------------------------"

modifiedNum=`git status | grep modified | wc -l`

if [ $modifiedNum -gt 0 ]
then
  echo "------------------------------文章生成自动标识提交----------------------------------"
  git commit -a -m '[auto] 文章生成唯一标识'
  git push origin main
  echo "---------------------------------提交完成-------------------------------------"
fi

