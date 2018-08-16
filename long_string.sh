#!/bin/bash 
#####################################################################################
寻找某一路径下的所有文件中的最长字符串，以及最长字符串所在的位置，以及最长字符串长度
#####################################################################################


max=0              #最大值标记
max_char=''        #最大的字符串
max_file=''        #最大字符串所在文件


find_max_file() {       
    word=`cat $1 | tr -s -c "a-zA-Z" "\n"`   #计算当前找到的文件中字符串的个数
    for i in $word;do
        length_char=${#i}                  #字符串含有的字符数量
        if [[ $length_char -gt $max ]];then
            max=$length_char      
            max_file=$1
            max_char=$i
        fi
    done
}


find_max_dir() {     
    for i in `ls $1`;do
        if [[ -d $1/$i ]];then   #如果是目录，继续递归向下找
            find_max_dir "$1/$i" 
        else 
            find_max_file "$1/$i"    #如果是文件，就调用find_max_file()
        fi
    done
}
find_max_dir "/home/gaoyu"      #传入路径
echo 字符个数:$max
echo 最大字符串:$max_char
echo 最大字符串所在文件:$max_file
