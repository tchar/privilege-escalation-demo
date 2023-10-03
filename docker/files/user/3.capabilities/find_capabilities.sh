#!/usr/bin/sh

printf "\n################### Find capabilities ###################\n\n"
getcap -r / 2>/dev/null
