#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main()
{
    printf("\n#### SUID privilege escalation ####\n\n");
    setuid(0);
    printf("whoami = ");
    fflush(stdout);
    system("/usr/bin/whoami");
    return 0;
}