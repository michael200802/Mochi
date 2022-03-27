#include <stdio.h>
#include "Chemistry/types/substance/substance.h"

int main(int argc, char * argv[])
{
    argc--;
    argv++;

    if(*argv == NULL)
    {
        puts("Pon al menos un compuesto/sustancia, imbecil.");
    }

    for(size_t i = 0; i < argc; i++)
    {
        substance_t sub;
        if(init_substance(argv[i],&sub))
        {
            char buffer[100] = {};
            print_substance(&sub,buffer,100);
            printf("%s: %s %f\n",argv[i],buffer,sub.molar_mass);
            destroy_substance(&sub);
        }
        else
        {
            printf("%s no es un compuesto/sustancia\n",argv[i]);
        }
    }

    return 0;
}