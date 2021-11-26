
#! /bin/bash

# 1. 判断参数个数
if [ $# -lt 1 ]; then
	echo Not Enough Arguement!
	exit;
fi

# 2. 遍历集群所有机器
for host in hadoop01 hadoop02 hadoop03
do
	echo ===> $host <===
	for file in $@
	do	
		if [ -e $file ]; then

			# 获取父目录
			pdir=$(cd -P $(dirname $file); pwd)

			# 获取当前文件的名称
			fname=$(basename $file)

			ssh $host "mkdir -p $pdir"
			rsync -av $pdir/$fname $host:$pdir
		else
			echo $file does not exists!
		fi
	done
done