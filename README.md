# Boss in Docker

This repository contains my second run at creating a docker container to run the BesII Offline Software System (BOSS).
This software suite does not function well on modern operating systems, and is very difficult to configure even on older ones, so containerization is by far the best option for average users to run it on development machines.

The image is based on the one published by the BESIII collaboration as jemtchou/boss, and modified to make it easier to mount a workarea, work in a shell within the container, and compile Yapp code without error.

# Working with bossdocker
The Bossdocker container can function either as an interactive development environment. It is preconfigured for use with zsh and includes essential development tools.

Alternatively, the container can run in the background while still using the host system as development environment. Using the included scripts, the BOSS-essential commands `boss.exe` and `cmt` are run within the container environment without ever having to open a shell within the container.

## Container as interactive development environment
This approach is the easiest way to use the bossdocker container with minimal setup, especially if deep integration into the system is not possible.
The following command will start the container with an interactive zsh shell and mount the workarea stored in your $WORKAREA environment variable:
```
docker run --security-opt label=disable -it -v $WORKAREA:/root/workarea --privileged bossdocker zsh
```
After starting the container, you need mount the BOSS environment and configure it:
```
source ~/mount.sh
source ~/setup.sh
```

## Container runs only BOSS Software
I will include four scripts:
- `initboss.sh` and `killboss.sh` to start and stop the container.
- `runcmt.sh` to execute `cmt` commands in the container, needed to compile boss modules.
- `runboss.sh` to execute `boss.exe` in the container
