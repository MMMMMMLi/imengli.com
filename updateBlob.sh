#!/bin/bash
source /etc/profile

if [ ! -d "/root/blob/public/" ];then
echo "文件夹不存在"
else

cd /root/blob/

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 开始更新仓库。"
git pull origin main

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 仓库更新完毕，开始编译环境。"

hexo clean && hexo g

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 编译完毕"

modifiedNum=`git status | grep modified | wc -l`

if [ $modifiedNum -gt 0 ]
then
  echo "hhhhhhhhhhhhhhhhhh"
fi
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> OK "
fi
