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