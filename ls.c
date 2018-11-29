/*************************************************************************
> File Name: ls.c
> Author:gaoyu
> Mail:2282940822 
> Created Time: 2018年09月22日 星期六 17时19分02秒
************************************************************************/

#include<stdio.h>
#include<dirent.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<string.h>
#include<time.h>
#include<grp.h>
#include<pwd.h>

void gid (gid_t st_gid) {
    struct group *data;
    data = getgrgid(st_gid);
    printf ("%8s ", data->gr_name);
}

void uid (uid_t st_uid) {
    struct passwd *data;
    data = getpwuid(st_uid);
    printf("%8s ", data->pw_name);
}

char *mode_permission (int st_mode, char str[]) {
    strcpy(str, "----------");
    if (S_ISDIR(st_mode)) str[0] = 'd';
    if (S_ISCHR(st_mode)) str[0] = 'c';
    if (S_ISBLK(st_mode)) str[0] = 'b';

    if (st_mode & S_IRUSR) str[1] = 'r';
    if (st_mode & S_IWUSR) str[2] = 'w';
    if (st_mode & S_IXUSR) str[3] = 'x';

    if (st_mode & S_IRGRP) str[4] = 'r';
    if (st_mode & S_IWGRP) str[5] = 'w';
    if (st_mode & S_IXGRP) str[6] = 'x';

    if (st_mode & S_IROTH) str[7] = 'r';
    if (st_mode & S_IWOTH) str[8] = 'w';
    if (st_mode & S_IXOTH) str[9] = 'x';
    return str;
}

void file_info (char *filename, struct stat *info) {
    char per_str[11];//文件属性
    char *str = mode_permission(info->st_mode, per_str); //文件类型和文件权限
    printf ("%s ", per_str);
    printf ("%4d ", (int)info->st_nlink);
    uid(info->st_uid);
    gid(info->st_gid);
    printf ("%8ld ", info->st_size);
    printf ("%.12s ", 4+ctime(&info->st_atime));
    if (str[0] == 'd') {
        printf ("\033[;34m %s \033[0m \n", filename);
    }else if((str[0] != 'd') && (per_str[3] == 'x' || per_str[6] == 'x' || per_str[9] == 'x')) {
       printf ("\033[;32m %s \033[0m \n", filename);
    } else {
        printf ("%s\n", filename);    
    } 
}
void do_stat (char *filename) {
    struct stat info;
    if (stat(filename, &info) != -1) {
        file_info(filename, &info);
    }
}


int main (int arg, char *argv[]) {
    DIR *dir_ptr;
    struct dirent *dir_tp;
    if (arg == 1) {
        dir_ptr = opendir(".");
        if (dir_ptr != NULL) {
            while ((dir_tp = readdir(dir_ptr)) != NULL) {
                do_stat(dir_tp->d_name);
            }
            closedir(dir_ptr);
        }
    } 
}
