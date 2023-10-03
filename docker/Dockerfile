FROM ubuntu:20.04

LABEL maintainer="Tilemachos Charalampous"
LABEL version="0.1"
LABEL description="Custom image for privilege escalation demo"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y sudo vim nano python3 tmux netcat-traditional ca-certificates cron dos2unix gcc strace ltrace make libcap2-bin gdb

RUN groupadd gudo
RUN useradd -G gudo -U -M -s /usr/bin/bash user
RUN echo "root:root" | chpasswd
RUN echo "user:user" | chpasswd

ADD files/sudoers /etc/sudoers
ADD files/crontab /etc/crontab
ADD files/bin /usr/local/bin
ADD files/entrypoint.sh /entrypoint.sh
ADD files/user /home/user

# Convert lines to unix format
RUN dos2unix /etc/sudoers /usr/local/bin/backup-cron /etc/crontab /usr/local/bin/check-processes.c /entrypoint.sh

# Capabilities
RUN cp /usr/bin/python3 /usr/local/bin/python
RUN setcap cap_setuid+ep /usr/local/bin/python

# Compile
RUN gcc -o /usr/local/bin/check-processes /usr/local/bin/check-processes.c
RUN chmod 4755 /usr/local/bin/check-processes

RUN gcc -o /usr/local/bin/crackme /home/user/6.binary-exploit/2/src/crackme.c
RUN chmod +x /usr/local/bin/crackme
RUN cd /home/user/6.binary-exploit/1 && make crackme && make crackme-static
RUN cd /home/user/6.binary-exploit/1 && make crackme

# Chmod
RUN cp /usr/bin/vim /usr/local/bin/vim-suid && chmod u+s /usr/local/bin/vim-suid
RUN chmod 0744 /usr/local/bin/backup-cron
RUN chmod 0755 /usr/local/bin/pspy64
RUN chmod 0700 /entrypoint.sh
RUN chmod +x /home/user/3.capabilities/exploit.py

# User
RUN find /home/user -type f -iname "*.sh" -exec chmod +x {} \;
RUN mkdir /home/user/backup
RUN find /home/user -type f -print0 | xargs -0 dos2unix
RUN chown -R user:user /home/user
RUN chown root:root /home/user/1.suid/python-with-suid.py
RUN chmod 4775 /home/user/1.suid/python-with-suid.py
RUN gcc -o /home/user/1.suid/c-with-suid /home/user/1.suid/src/c-with-suid.c
RUN gcc -o /home/user/1.suid/c-with-sgid /home/user/1.suid/src/c-with-sgid.c
RUN chown root:shadow /home/user/1.suid/c-with-sgid
RUN chmod u+s /home/user/1.suid/c-with-suid
RUN chmod g+s /home/user/1.suid/c-with-sgid

WORKDIR /home/user
CMD /usr/bin/sh /entrypoint.sh