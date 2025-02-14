// 1. soru a
#include <stdio.h>

int main(void)
{
    int a,b;
    for(a=6;a>1;a-=4)
    {
        b=2;
        while(b<=2)
        {
            printf("%d%3d\n",b,a);
            b=b+2;
        }
        a++;
        printf("%2d%d\n",a,b);
    }
    return 0;
}


//1. soru b

# include <stdio.h>

int main(void){
    
    int ali=5 , veli=3 , mehmet=6;
    if(ali!=5 && veli >=3){
        switch(mehmet){
            case 3: mehmet = mehmet *3;
                break;
            case 5: if(ali%2!=0)
                        printf("%3d\n",mehmet);
                    else{
                        mehmet = mehmet - 4;
                        printf("%3d\n",mehmet);
                        printf("%4d\n",mehmet+veli);
                    }
                break;
        }
        printf("%3d%3d%3d",mehmet+2,ali,veli-2);
        
    }
    else{
        printf("%3d\n%3d%7d",mehmet+2,ali,veli-2);
        printf("\n%7d",mehmet);
    }
    return 0;
}


//1. soru c

#include<stdio.h>

int main(void){
    int a,b;
    a=4;
    do{
        b=1;
        do{
            printf("%3d%2d\n",b,a);
            b=b+1;
            
        }while(b<=4);
        a=a+3;
        printf("%3d%2d\n",b,a);
    }while(a!=7);
    return 0;
}


// 2. soru a

#include<stdio.h>

double f1 (double a);
double f2 (double a);

int f3 (double a);

int main(void){
    printf("%7d\n", f3(f2(f1(6.8))));
    return 0;
}

double f1 (double a){
    return (a+4);
}

double f2 (double a){
    return (2.7*a);
}

int f3 (double a){
    return(0.6*a);
}

// 2. soru b

#include<stdio.h>

int main(void){
    int x;
    scanf("%d",&x);
    int sum = 0;
    for(int i =1; i<=x;i++){
        sum += i + x;
    }
    printf("%d",sum);
    return 0;
}


// 3. soru

#include<stdio.h>

int main(void){
    int a, top;
    scanf("%d",&a);
    top = 0;
    while(a){
        top -= a;
        scanf("%d",&a);
    }
    printf("%d",top);
    return 0;
}

// 4. soru

#include<stdio.h>

int main(void){
    int n;
    int girdi;
    int PozitifToplam = 0;
    int NegatifToplam = 0;
    int SıfırToplam = 0;
    printf("kaç tane sayı giriceksiniz: ");
    scanf("%d",&n);
    for(int i=1; i<=n; i++){
        printf("%d. sayı: ",i);
        scanf("%d",&girdi);
        if(girdi > 0){
            PozitifToplam++;
        }
        else if (girdi < 0){
            NegatifToplam++;
        }
        else{
            SıfırToplam++;
        }
    }
    printf("%d adet pozitif sayi.\n",PozitifToplam);
    printf("%d adet negatif sayi.\n",NegatifToplam);
    printf("%d adet sıfır sayi.\n",SıfırToplam);
}

