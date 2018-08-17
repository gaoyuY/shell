#!/bin/bashi
##########################################################
#查询某目录下的目录个数和文件个数（包括隐藏文件或隐藏目录）
##########################################################
dir_num=0
file_num=0
find_dir() {
    for i in `ls -a $1`;do   #遍历所有包括隐藏
        if [[ $i == "." || $i == ".." ]];then
            continue
        elif [[ -d $1/$i ]];then
            ((dir_num++))
            find_dir "$1/$i"
        else 
            ((file_num++))  
        fi
    done
}

find_dir "/home/gaoyu/luogu/"
echo 目录的个数：$dir_num
echo 文件的个数：$file_num

