FROM ubuntu:20.04

LABEL maintainer="Tilemachos Charalampous"
LABEL version="0.1"
LABEL description="Custom image for privilege escalation demo"

ARG DEBIAN_FRONTEND=noninteractive


USER root
RUN apt-get update
RUN apt-get install -y sudo vim nano python3 tmux netcat-traditional ca-certificates cron dos2unix gcc strace ltrace make libcap2-bin gdb wget less
RUN wget -O pandoc.deb https://github.com/jgm/pandoc/releases/download/3.5/pandoc-3.5-1-amd64.deb && dpkg -i pandoc.deb && rm pandoc.deb || exit 0

RUN groupadd gudo
RUN useradd -G gudo -U -M -s /usr/bin/bash user
RUN echo "root:root" | chpasswd
RUN echo "user:user" | chpasswd

ADD files/sudoers /etc/sudoers
ADD files/crontab /etc/crontab
ADD files/entrypoint.sh /entrypoint.sh
ADD files/bin /root/docker-bin
ADD files/user /home/user

# Convert lines to unix format
RUN dos2unix /etc/sudoers /etc/crontab /entrypoint.sh /root/docker-bin/backup-cron /root/docker-bin/src/check-processes.c

# # Capabilities
RUN cp /usr/bin/python3 /usr/local/bin/python && setcap cap_setuid+ep /usr/local/bin/python

# Bin & Compile
RUN gcc -Wall -o /usr/local/bin/check-processes /root/docker-bin/src/check-processes.c
RUN cp /root/docker-bin/backup-cron /usr/local/bin/backup-cron
RUN tar -xzf /root/docker-bin/bin.tar.gz --directory /root/docker-bin/ && cp /root/docker-bin/pspy64 /usr/local/bin/pspy64

RUN gcc -Wall -o /home/user/1.suid-sgid/c-with-suid /home/user/1.suid-sgid/src/c-with-suid.c
RUN gcc -Wall -o /home/user/1.suid-sgid/c-with-sgid /home/user/1.suid-sgid/src/c-with-sgid.c
RUN cd /home/user/6.binary-exploit/0 && make crackme
RUN cd /home/user/6.binary-exploit/1 && make crackme && make crackme-static
RUN cd /home/user/6.binary-exploit/2 && make crackme && cp crackme /usr/local/bin/check-license

# Cleanup bin
RUN rm -rf /root/docker-bin

# User
## Fix permissions
RUN find /home/user -type d -print0 | xargs -0 chmod 0775
RUN find /home/user -type f -print0 | xargs -0 chmod 0664
RUN find /home/user -type f -iname "*.sh" -exec chmod 0755 {} \;

RUN mkdir /home/user/backup
RUN find /home/user -type f -print0 | xargs -0 dos2unix

RUN chown -R user:user /home/user

RUN chown root:root /home/user/1.suid-sgid/python-with-suid.py /home/user/1.suid-sgid/c-with-suid
RUN chown root:shadow /home/user/1.suid-sgid/c-with-sgid
RUN chmod 4775 /home/user/1.suid-sgid/python-with-suid.py
RUN chmod 4775 /home/user/1.suid-sgid/c-with-suid
RUN chmod 2755 /home/user/1.suid-sgid/c-with-sgid
RUN chmod 0755 /home/user/4.path-injection/check.sh
RUN chmod 0755 /home/user/6.binary-exploit/0/crackme
RUN chmod 0755 /home/user/6.binary-exploit/0/check.sh
RUN chmod 0755 /home/user/6.binary-exploit/1/crackme /home/user/6.binary-exploit/1/crackme-static
RUN chmod 0755 /home/user/6.binary-exploit/1/check.sh
RUN chmod 0755 /home/user/6.binary-exploit/2/crackme

# Root chmod
RUN cp /usr/bin/vim /usr/local/bin/vim-suid && chmod 4755 /usr/local/bin/vim-suid
RUN chmod 0755 /usr/local/bin/backup-cron
RUN chmod 0755 /usr/local/bin/pspy64
RUN chmod 4755 /usr/local/bin/check-processes
RUN chmod 0440 /etc/sudoers
RUN chmod 0644 /etc/crontab
RUN chmod 0700 /entrypoint.sh

USER user
RUN printf '\nmd() { pandoc -t ansi "$1"; }\nmdl() { pandoc -t ansi "$1" | less -R; }\n' >> ~/.bashrc

USER root

WORKDIR /home/user
CMD ["/usr/bin/sh", "/entrypoint.sh"]