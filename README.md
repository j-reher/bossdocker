[![Lint](https://github.com/j-reher/bossdocker/actions/workflows/test-image-lintonly.yml/badge.svg)](https://github.com/j-reher/bossdocker/actions/workflows/test-image-lintonly.yml) [![Build and test](https://github.com/j-reher/bossdocker/actions/workflows/test-image.yml/badge.svg?branch=main&event=push)](https://github.com/j-reher/bossdocker/actions/workflows/test-image.yml) [![Deploy to Dockerhub](https://github.com/j-reher/bossdocker/actions/workflows/deploy-image.yml/badge.svg?branch=main)](https://github.com/j-reher/bossdocker/actions/workflows/deploy-image.yml)
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


# Old Versions on Dockerhub
Older versions are optimized for use in the EP1 infrastructure, but only offer BOSS 7.0.3. They are available using the tags `release-7.0.3`, `test-7.0.3`, `release-7.0.3-light` and `test-7.0.3-light`.

The code for these old versions can be found in the EP1 gitlab and requires an EP1 account to access.
## Boss Docker
This Docker Container provides a full installation is intended to provide fast and easy testing of boss analysis code on any system.
It is not (yet) intended or suited for use in a batch environment!
For proper function, you should mount two external directories: /workarea for your analysis code, and /data for both the example data to analyse and the output.

## Boss Docker Light
This Lightweight version of the BOSS Docker Container is intended to be run in an environment in which a full installation is provided in a central place, with many users accessing it.
To function properly, three external directories need to be mounted to /boss, /workarea and /data, and the directory mounted to /boss must contain an existing boss installation (as created by the full container).

Example Command in EP1 environment:
```tcsh
docker run -it \
    --replace \
    --restart unless-stopped \
    --user ${UID}:${GID} \
    --userns keep-id \
    --name boss-light \
    --log-opt max-size=50m \
    -v /BOSS/:/boss:ro \
    -v /home/${USER}/workarea:/workarea:Z \
    -v /home/${USER}/bossdata:/data:Z \
    --security-opt label=disable \
    jreher/boss:7.0.3-light /bin/bash
```