#!/bin/bash

# the default node number is 3
N=${1:-3}


# start hadoop master container
sudo docker rm -f hadoop-master-mine &> /dev/null
echo "start hadoop-master-mine container..."
sudo docker run -itd \
		--net=hadoop \
		-v /Users/wangchanghao/Documents/hadoop-master-mine:/usr/local/hadoop/etc/hadoop \
                --name hadoop-master-mine \
                --hostname hadoop-master-mine \
                kiwenlau/hadoop:1.0 &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i-mine &> /dev/null
	echo "start hadoop-slave$i-mine container..."
	sudo docker run -itd \
			-v /Users/wangchanghao/Documents/hadoop-slave$i-mine:/usr/local/hadoop/etc/hadoop \
	                --net=hadoop \
	                --name hadoop-slave$i-mine \
	                --hostname hadoop-slave$i-mine \
	                kiwenlau/hadoop:1.0 &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master-mine bash
