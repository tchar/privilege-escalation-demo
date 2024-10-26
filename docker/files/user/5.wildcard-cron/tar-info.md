## tar

[https://www.gnu.org/software/tar/manual/html_section/checkpoints.html](https://www.gnu.org/software/tar/manual/html_section/checkpoints.html)

### 3.8 Checkpoints

A checkpoint is a moment of time before writing nth record to the archive (a write checkpoint), or before reading nth record from the archive (a read checkpoint). Checkpoints allow to periodically execute arbitrary actions.

The checkpoint facility is enabled using the following option:

`--checkpoint[=n]`
Schedule checkpoints before writing or reading each nth record. The default value for n is 10.

A list of arbitrary actions can be executed at each checkpoint. These actions include: pausing, displaying textual messages, and executing arbitrary external programs. Actions are defined using the `--checkpoint-action` option.

`--checkpoint-action=action`
Execute an action at each checkpoint.
