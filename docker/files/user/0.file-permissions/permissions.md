# Permissions

How to view?
```sh
ls -l /some/path/some/file
```

## Theory

### Basic Permissions

```sh
ls -l /some/path/some/file
```

#### Permissions and numeric representation
```
USER    GROUP   OTHER
rwx     rwx     rwx
111     111     111     =   777
```

##### Example 1

User can read write, group can read write, other can do nothing
```
rw-     rw-     ---     =   660
```

###### Example 2

User can read write execute, group can read write, other can read
```
rwx     rw-     r--     =   764
```


### SUID & SGID

#### SUID

If `SUID` is set then binary runs with permissions of the user who owns the binary.
Numericaly all permissions are padded with `0`.


##### Example

User can read write execute, group can read write, other can read.
```
rwx     rw-     r--     =   0764
                       -----^----- 0 = no SUID/SGID, 2 = SUID, 4 = SGID.
```

If we set `SUID` permission to the file, it will look like this
```
rws     rw-     r--     =   2764
--^-----               -----^----- 2 = SUID
```

If the file did not have run permissions it would be a capital `S`.
```
rwS     rw-     r--     =   2664
--^-----                -----^----- Note the 6 stands for not executable.
```

#### SGID

Same as `SUID` but file runs with the group that owns the file.
Same concepts apply as above, but for the group permissions.


##### Example

User can read write execute, group can read write, other can read.
```
rwx     rwx     r--     =   0774
                       -----^----- 0 = no SUID/SGID, 2 = SUID, 4 = SGID.
```

If we set `SGID` permission to the file, it will look like this.
```
rwx     rws     r--     =   4774
      ----^-----       -----^----- 4 = SGID
```

If the file did not have run permissions it would be a capital S
```
rwx     rwS     r--     =   4764
        --^-----         -----^----- Note the 6 stands for not executable.
```
