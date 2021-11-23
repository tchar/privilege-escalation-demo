#include <unistd.h>
#include <stdlib.h>

int main()
{
    setuid(0);
    setgid(0);
    system("ps");
    return 0;
}
