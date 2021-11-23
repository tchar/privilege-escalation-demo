# Privilege Escalation Demo

This repository contains a docker image to demonstrate common privilege escalation techniques for *nix systems

## Run

### Automatically

Run the script inside the `docker directory`
- Windows: `start.bat`
- Linux: `start.sh`

You need to be in the `docker` directory to run the script. For example in Linux
```bash
cd docker
cat start.sh | sh # or ./start.sh if it is executable
```

### Manually

```bash
cd docker
# Build the image
docker build -t privesc .
# Remove previous container
docker rm privesc
# Run the container
docker run --name privesc -it privesc
```