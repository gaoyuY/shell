/*************************************************************************
> File Name: 3.my_print.c
> Author:gaoyu
> Mail:2282940822 
> Created Time: 2018年09月20日 星期四 20时27分33秒
************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include<inttypes.h>
#include<math.h>

int my_printf(const char *frm, ...) {
    int cnt = 0;
    va_list arg;
    va_start(arg, frm);
    for (int i = 0, cnt = 0; frm[i]; i++, cnt++) {
        switch (frm[i]) {
            case '%' : {
                i++;
                switch(frm[i]) {
                    case 'd' : {
                        long int temp = va_arg(arg, int);
                        int a = 0, b = 0, num = 0, flag = 0;
                        long int x = 0;
                        while (temp) {  
                            if (temp < 0) {
                                flag++;
                                temp = fabs(temp);
                            }
                            num++;
                            x = x * 10 + temp % 10;
                            temp /= 10;
                        }
                        int sum = 0;
                        while (x) {
                            if (flag == 1) {
                                putchar('-');
                                flag--;
                            }
                            sum++;
                            putchar(x % 10 + '0');
                            x /= 10;
                        } 
                        if (num > sum) {
                            for (int i = 0; i < num - sum; i++)
                                putchar('0');
                        }
                    } break;
                    default : 
                        fprintf(stderr, "error : unknow %%%c\n", frm[i]); 
                        exit(1);
                }
            } break;
            default:
            putchar(frm[i]);
        }
    }
    return cnt;
}

int main() {
    int n = 123;
    my_printf("hello world\n");
    my_printf("n = %d\n", n);
    my_printf("n = %d\n", 12000);
    my_printf("n = %d\n", -567);
    my_printf("n = %d\n", INT32_MIN);
    my_printf("n = %d\n", INT32_MAX);
    return 0;
}
