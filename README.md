[![Lint](https://github.com/j-reher/bossdocker/actions/workflows/test-image-lintonly.yml/badge.svg)](https://github.com/j-reher/bossdocker/actions/workflows/test-image-lintonly.yml) [![Build and test](https://github.com/j-reher/bossdocker/actions/workflows/test-image.yml/badge.svg?branch=main&event=push)](https://github.com/j-reher/bossdocker/actions/workflows/test-image.yml) [![Deploy to Dockerhub](https://github.com/j-reher/bossdocker/actions/workflows/deploy-image.yml/badge.svg?branch=main)](https://github.com/j-reher/bossdocker/actions/workflows/deploy-image.yml)
# Boss in Docker

This repository contains my second run at creating a docker container to run the BesII Offline Software System (BOSS).
This software suite does not function well on modern operating systems, and is very difficult to configure even on older ones, so containerization is by far the best option for average users to run it on development machines.

The image is based on the one published by the BESIII collaboration as jemtchou/boss, and modified to make it easier to mount a workarea, work in a shell within the container, and compile Yapp code without error.

# Working with bossdocker
The bossdockercontainer container runs in the background while still using the host system as development environment. Using the included scripts, the essential BOSS commands `boss.exe` and `cmt` are run within the container environment without ever having to open a container shell.

Alternatively, the container can function as an interactive development environment with a bash shell and essential development tools.

## Work with BOSS in container
Five scripts are included that, when placed in your `$PATH`, allow you to work with the boss container almost as if boss was installed on your host system.
For them to work, your working directory must be structured as `*/workarea/Yapp/*`. The `Yapp` folder assumes you are using an [EP1 Yapp-package](https://gitlab.ep1.rub.de/Bes3/Yapp) for your analysis code. If that is not the case, create an empty dummy folder inside the workarea for running `initboss.sh`, everything will work as long as your code is somewhere inside the `workarea`.
Starting the container is only possible inside tye `/workarea/Yapp` folder for now, all other commands function anywhere inside `/workarea`.

- `initboss.sh` and `stopboss.sh` to start and stop the container.
- `cmt.sh` to runs `cmt` commands in the container.
- `boss.sh` to execute `boss.exe` in the container.
- `boss_shell.sh` to get an interactive shell inside the container.

Support is planned for arbitrary folder structures that just require a folder with a name beginning with `workarea`, to simplify use of multiple workareas for different versions.

## Container as interactive development environment
If deep proper integration into the system is not possible because the above scripts can't be placed conveniently, the container can still be run interactively.
The script `interactiveboss.sh` will start the container with an interactive bash shell and detect your workarea from your current working directory, assuming it is inside a Yapp package.

Alternatively, the following docker command can be used (make sure to replace your workarea path):
```
docker run --security-opt label=disable -it --rm -v /absolute/path/to/workarea:/root/workarea --privileged jreher/boss
```
The BOSS environment should be mounted and configured automatically. Should that fail, the following commands can help:
```
source /root/mount.sh
source /root/setup.sh
```


# Old Versions on Dockerhub
Older versions using a completely different approach to offer BOSS 7.0.3 either as a huge image or in EP1 infrastructure, are still available using the tags `release-7.0.3`, `test-7.0.3`, `release-7.0.3-light` and `test-7.0.3-light` on dockerhub. The code for these old versions is located in the EP1 gitlab and requires an EP1 LDAP account to access.