#!/bin/bash
#######################################
安全的rm命令
#######################################


trash_dir="/home/gaoyu/.rub/"

rnum=0      #记录rm参数　-r 是否存在
fnum=0      #记录rm参数　-f 是否存在

is_file(){
    if [[ $1 == -clear_trash ]];then   #定时清理垃圾桶
        rm -rf $trash_dir*
    fi
    for i in $*;do
        if [[ "-r" == $i  ]];then      #如果参数-r存在
            rnum=1
        elif [[ "-f" == $i   ]];then     #如果参数-f存在
            fnum=1
        elif [[ "/" == $i ]];then          #如果参数含根目录/，直接提示并退出
            echo "危险操作"　&& break
        elif [[ -d $i && $rnum == 1 ]];then        #如果参数是目录且含有参数-r,则将目录移动到＇垃圾桶＇
            mv $i $trash_dir && echo "success"
        elif [[ -d $i && $rnum -eq 0  ]];then  
            name=$i
           echo $i && echo "do not remove,it is directory"
        elif [[ ! -d $i  ]];then           #判断参数是文件
            if [[ $fnum == 1 ]];then    
                mv $i $trash_dir && echo "success"
            else                          
                echo "remove,ture? [y/n]" 
                    read confirm 
                    if [ $confirm == 'y' -o $confirm == 'Y' ] ;then 
                        mv $i $trash_dir && echo "success"
                    elif [ $confirm == 'n'  -o $confirm == 'N' ];then
                        echo "fail" && break
                fi 
            fi
        fi
    done
}
is_file $@   #传入参数
