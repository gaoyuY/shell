#!/bin/bash 
. /home/gaoyu/shell/Automatic_backup_project/.gaoyu_back.rc   #运行配置文件.gaoyu_back.rc  要写绝对路径，要不会出错

time_now=`date +"%Y-%m-%d %H:%M"`     #当前日期
time_file=`date +"%Y_%m_%d_%H_%M"`    #以分钟作为修改

if [[ ! -d $dest_dir  ]];then  #如果没有备份文件的目标文件，输出错误(要先在根目录建立一个dest_dir目录(名字根据.gaoyu_back.rc)，　否则会一直输出错误)
    echo -e "$ time_now \033[31;32m[Error]\033[0m The Dest dir $dest_dir not exists" >> $log
    exit
fi
echo "$time_now backup started!" >> $log   #输出提示信息开始备份，重定向到日志文件

for i in `echo $back_path | tr ":" "\n"`;do  #将.gaoyu_back.rc内输入的多个路径分离开(tr命令)，并遍历每个路径
    if [[ ! -d $i  ]];then  #路径为空，输出错误信息，并跳出本次循环，并遍历下一个路径
        echo -e "%time_now backup \033[31;32m[Error]\033[0m The dir $i not exist" >> $log
        continue
    fi
    echo "$i started"
    file_name=`echo $i | cut -d '/' -f "2-" | tr '/' '-'`   #将路径当做目录名（将路径的'/'变成'-')
    file_name=${file_name}_${time_file}.tar.gz        #压缩后的目录名
    tar -czPf ${dest_dir}/${file_name} $i         #压缩目录
    if [[ $? -eq 0  ]];then
        size=`du -h ${dest_dir}/${file_name} | cut -f 1`
        echo -e "$time_now backup $i --> $file_name \033[32;36m +${size}M\033[0m" >> $log
    else
        echo "$time_now \033[31;32m[Eorror]\033[0m " >> $log
    fi
done
Del_list=`find $dest_dir -name "*.tar.gz" -mmin +3`  #三分钟遍历一次备份文件

for i in $Del_list;do

    size=`du -h $i | cut -f 1`
    rm -f $i
    echo -e "$time_now delete \033[31;32m $i\033[0m --> remove -${size}" >> $log #删除备份文件，并记录到日志里

    done

##################
#需要手动建立日志文件back.log(自命名.log与.gaoyu_back.rc内一致)
######
