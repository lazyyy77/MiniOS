#include <stdio.h>
#include <unistd.h>
int a;


int addfunc(int input){
    return input + a;
}

int main(){

    int b = 2;
    int c = addfunc(b);
//    printf("%d", c);
    while(1){
        printf("%d\n", c);
        sleep(5);
    }
    return 0;
}
