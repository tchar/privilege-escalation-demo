#include <stdlib.h>
#include <unistd.h>

int main()
{
    setuid(0);
    setgid(0);
    system("/usr/bin/whoami");
    return 0;
}