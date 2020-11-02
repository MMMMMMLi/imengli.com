if [ ! -d "/root/blob/public/" ];then
echo "文件夹不存在"
else
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 开始更新仓库。"
git pull origin main

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 仓库更新完毕，开始编译环境。"

hexo clean && hexo g

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> OK "
fi
