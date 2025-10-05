# Privilege Escalation Demo

This repository contains a docker image to demonstrate common privilege escalation techniques for *nix systems

## Run

### Automatically

Run the script
- Windows: `./scripts/windows/start.bat`
- Linux/Mac: `./scripts/nix/start.sh`

For example in Linux/Mac
```bash
cat ./scripts/nix/start.sh | sh # or ./scripts/nix/start.sh if it is executable
```

### Manually

```bash
# Remove old image (if any)
docker rmi privesc:latest
# Build the image
docker build -t privesc:latest ./docker
# Remove previous container (if any)
docker rm privesc
# Run the container
docker run --rm --name privesc -it privesc:latest
```
