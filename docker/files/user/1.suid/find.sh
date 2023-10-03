#!/usr/bin/sh

# Find suid
echo "################### Find suid ###################"
find / -perm /4000 -exec ls -l {} \; 2>/dev/null

# Find guid
echo "################### Find sgid ###################"
find / -perm /2000 -exec ls -l {} \; 2>/dev/null
