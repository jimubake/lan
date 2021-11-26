- macOS  centos 配置静态 ip

  ```shell
  # 查看mac 的网关和掩码
  cat /Library/Preferences/VMware\ Fusion/vmnet8/nat.conf
  # NAT gateway address
  ip = 172.16.216.1
  netmask = 255.255.255.0
  vim /etc/sysconfig/network-scripts/ifcfg-ens33
  ```

  ```properties
  #静态，动态: dhcp
  BOOTPROTO="static"
  DEVICE="ens33"
  ONBOOT="yes"
  IPADDR=172.16.216.102
  #掩码
  NETMASK=255.255.255.0
  #网关
  GATEWAY=172.16.216.1
  #网关
  DNS1=172.16.216.1
  ```



- Centos: /etc/profile 脚本

  ```shell
  for i in /etc/profile.d/*.sh /etc/profile.d/sh.local ; do
      if [ -r "$i" ]; then
          if [ "${-#*i}" != "$-" ]; then
              . "$i"
          else
              . "$i" >/dev/null
          fi
      fi
  done
  
  # $-记录着当前设置的shell选项，himBH是默认值，你可以通过 set 命令来设置或者取消一个选项配置。例如：
  set -x
  # ${-#*i}翻译过来是说，从左往右看，删除掉 $- 变量的值中第一个 i 字符以及之前的内容
  ```

  

- 集群文件分发脚本

  ```shell
  #!/bin/bash
  
  # 1. 判断参数个数
  if [ $# -lt 1 ]; then
  	echo Not Enough Arguement!
  	exit;
  fi
  # 2. 遍历集群所有机器
  for host in hadoop04 hadoop02 hadoop03
  do
  	echo $@
  	echo === $host ===
  	for file in $@
  	do
  		echo $file
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
  ```

  

> 集群启动/停止方式

1. 整体启动/停止

   ```shell
   start-dfs.sh / stop-dfs.sh
   start-yarn.sh / stop-yarn.sh
   ```

2. 单独启动

   ```shell
   (1)分别启动/停止 HDFS 组件
   hdfs --daemon start/stop namenode/datanode/secondarynamenode
   (2)启动/停止 YARN
   yarn --daemon start/stop resourcemanager/nodemanager
   (3)启动 history
   mapred --daemon start historyserver
   ```

> 启动脚本

```shell
#!/bin/bash

if [ $# -lt 1 ]
then
	echo "No Args Input..."
	exit;
fi

case $1 in 
"start")
	echo "=== 启动 hadoop 集群 ==="
	echo "--- 启动 hdfs ---"
	ssh hadoop02 "/opt/module/hadoop-3.3.1/sbin/start-dfs.sh"
	echo "--- 启动 yarn ---"
	ssh hadoop03 "/opt/module/hadoop-3.3.1/sbin/start-yarn.sh"	
	echo "--- 启动 historyserver ---"
	ssh hadoop02 "/opt/module/hadoop-3.3.1/bin/mapred --daemon start historyserver"
;;
"stop")
	echo "--- stop historyserver ---"
	ssh hadoop02 "/opt/module/hadoop-3.3.1/bin/mapred --daemon stop historyserver"
	echo "--- stop yarn ---"
	ssh hadoop03 "/opt/module/hadoop-3.3.1/sbin/stop-yarn.sh"
	echo "--- stop hdfs ---"
	ssh hadoop02 "/opt/module/hadoop-3.3.1/sbin/stop-dfs.sh"
;;
*)
	echo "Input Args Error..."
;;
esac
```



#### HDFS

> 为什么块的大小不能设置太小，也不能设置太大？
>
> - hdfs 的块设置太小，会增加块寻址时间
> - 如果块设置太大，从磁盘传输数据的时间会明显大于定位这个块所需要的时间。同时程序处理很大的数据量块，会非常慢
> - 寻址时间为传输时间的 1% 为最佳状态，假如寻址 10ms，传输时间 = 10 / 0.01 = 1000ms
> - HDFS 的块大小主要取决于磁盘的传输速率

- 命令大全