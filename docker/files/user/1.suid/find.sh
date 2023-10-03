#!/usr/bin/sh

# Find SUID
printf "\n################### Find SUID ###################\n\n"
find / -perm /4000 -exec ls -l {} \; 2>/dev/null

# Find SGID
printf "\n################### Find SGID ###################\n\n"
find / -perm /2000 -exec ls -l {} \; 2>/dev/null
