#!/bin/bash
date=`date +"%Y-%m-%d_%T"`  #时间
hostname=`hostname`         #主机名
os=`uname -o`               #OS版本
Kernel_version=`uname -a | cut -d " " -f 3`          #内核版本
operation_hours=`uptime -p | tr " " "_"`             #运行时间
Average_load=`cat /proc/loadavg | cut -d " " -f 1,2,3` #平均负载

arr=(`df -m | grep "^/dev" | awk '{printf("%s %s\n",$2,$3)}'`)
for (( i=0;i<${#arr[@]};i+=2  ));do
    (( disk_sum+=${arr[i]} ))                #磁盘总量
    (( disk_used+=${arr[i+1]}  ))
done
(( used_percent=disk_used*100/disk_sum  ))   #磁盘已用%

memory_size=`cat /proc/meminfo | grep MemTotal |awk '{print $2$3}'`   #内存大小
memory_used=`free -m | sed -n "2p"|awk '{printf("%.f",$3*100/$2)}'`   #内存已用%
Cpu_temperature=`cat /sys/class/thermal/thermal_zone0/temp |awk '{printf("%.f\n",$1/1000)}'`  #cpu温度
 

if [[ $used_percent>=0 && $used_percent<80 ]];then
    Disk_alarm_level="normal"                              #磁盘报警级别
elif [[ $used_percent>=80 && $used_percent<90 ]];then
    Disk_alarm_level="note"
else 
    Disk_alarm_level="warning"
fi


if [[ $memory_used>=0 && $memory_used<50   ]];then
    memory_alarm_level="normal"                            #内存报警级别
elif [[ $memory_used>=50 && $memory_used<70   ]];then
    memory_alarm_level="note"
else 
    memory_alarm_level="warning"
fi


if [[ $Cpu_temperature>=0 && $Cpu_temperature<50  ]];then
    Cpu_alarm_level="normal"                                   #CPU报警级别
elif [[ $Cpu_temperature>=50 && $Cpu_temperature<70  ]];then
    Cpu_alarm_level="note"
else 
    Cpu_alarm_level="warning"
fi


echo $date $hostname $os $Kernel_version $operation_hours $Average_load ${disk_sum}M  $used_percent% $memory_size $memory_used% $Cpu_temperature°C $Disk_alarm_level $memory_alarm_level $Cpu_alarm_level 
