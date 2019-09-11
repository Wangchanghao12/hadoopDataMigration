#!/bin/sh

function log_info () {
    if [ -d /var/log ]
     then mkdir -p /var/log
    fi
    DATE_N=`date "+%Y-%m-%d %H:%M:%S"`
    USER_N=`whoami`
    echo "${DATE_N} ${USER_N} execute $0 [INFO] $@" >>/var/log/distcp-success-log
    #执行成功日志打印路径
    }
function log_error () {
     if [ -d /var/log ]
     then mkdir -p /var/log
     fi
     DATE_N=`date "+%Y-%m-%d %H:%M:%S"`
     USER_N=`whoami`
     echo -e "\033[41;37m ${DATE_N} ${USER_N} execute $0 [ERROR] $@ \033[0m" >>/var/log/distcp-error-log
     #执行失败日志打印路径
     }

#read first
first=`date -d"2018-12-09" +"%Y-%m-%d"`

#read last

last=`date -d"2018-12-10" +"%Y-%m-%d"`
#localIp='192.168.0.64:8020'
localIp='172.18.0.5:9000'
remoteIp='172.18.0.2:9000'

t1=`date -d "$first" +%s`
t2=`date -d "$last" +%s`

while [ $t1 -lt $t2 ]
do

  #var=$(hadoop distcp -update hdfs://192.168.200.64:8020/mytest/$first hdfs://192.168.200.65:8020/mytest/$first )
  var=$(hadoop distcp -update hdfs://$localIp/mytest/$first hdfs://$remoteIp/mytest/$first )

    #localSize=`hadoop fs -du -s hdfs://192.168.0.64:8020/mytest/ |grep $first`
    
    localSize=`hadoop fs -du -s hdfs://$localIp/mytest/$first`
    localSize=`echo $localSize | cut -d \  -f 1`
    echo $localSize
    
    #remoteSize=`hadoop fs -du -s hdfs://192.168.0.65:8020/mytest/ |grep $first`

    remoteSize=`hadoop fs -du -s hdfs://$remoteIp/mytest/$first`
    remoteSize=`echo $remoteSize | cut -d \  -f 1`
    echo $remoteSize

    if [[ $localSize -eq $remoteSize && ! -z "$localSize" ]];then
            echo "validate OK! fileis: '$localSize' "
            log_info "validate OK! fileName: '$first' fileSize: '$remoteSize' "
    elif [[ -z "$localSize" ]];then
            echo "No such file or directory  fileName: '$first'"
            log_info "No such file or directory fileName: '$first' fileSize: '$remoteSize' remoteIp: '$remoteIp'"
    else
        echo "copy error! $localSize "
        log_error "copy error! fileName: $first "
    fi
  first=`date -d "+1 day $first" +"%Y-%m-%d"`
  t1=`date -d "$first" +%s`

done
