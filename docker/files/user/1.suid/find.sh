#!/usr/bin/sh

# Find suid
echo "################### SUID ###################"
find / -perm /4000 -exec ls -l {} \; 2>/dev/null

# Find guid
echo "################### GUID ###################"
find / -perm /2000 -exec ls -l {} \; 2>/dev/null
