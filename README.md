[![Build and test](https://github.com/j-reher/bossdocker/actions/workflows/test-image.yml/badge.svg?branch=main&event=push)](https://github.com/j-reher/bossdocker/actions/workflows/test-image.yml)
[![Deploy Image -- Latest](https://github.com/j-reher/bossdocker/actions/workflows/deploy-image.yml/badge.svg?branch=main)](https://github.com/j-reher/bossdocker/actions/workflows/deploy-image.yml)
[![Deploy .tar.gz files](https://github.com/j-reher/bossdocker/actions/workflows/deploy-tarfiles.yml/badge.svg?branch=main)](https://github.com/j-reher/bossdocker/actions/workflows/deploy-tarfiles.yml)
[![Deploy all versions](https://github.com/j-reher/bossdocker/actions/workflows/deploy-all-versions.yml/badge.svg?branch=main)](https://github.com/j-reher/bossdocker/actions/workflows/deploy-all-versions.yml)
# Boss in Docker

The [BesIII Offline Software System (BOSS)](http://english.ihep.cas.cn/bes/re/os/), used to process data and Monte Carlo simulations for the BESIII experiment, does not function well on modern operating systems. Even on a supported system, it is notoriously difficult to configure. At the same time, running BOSS on a local machine is helpful for many users since it disconnects their development environment from the IHEP computing cluster, avoids large latencies from ssh connections to Asia, and even allows integration with code editors and IDEs.

Containerization is the easiest solution for most users to run BOSS on development machines. This BOSS image is based on Centos 7 and mounts required data from the IHEP servers using the [CVMFS](https://cernvm.cern.ch/fs/) file system to ensure the image size remains manageable.

The image includes a CVMFS-Cache from commonly used operations, which significantly speeds up runtime and is enough to avoid delays significant enough to be noticed in comparison to running at the computing cluster. [Persisting the cache on the host machine](#persistant-cache) can allow it to grow as the container is used. If you wish to run CVMFS in your host environment, for example, because several users are running the container, [mounting it as an external volume through docker](#using-external-cvmfs) is also possible but not yet fully supported or tested.

# Working with bossdocker
The BOSS container is intended to run in the background while the user still uses their host system as the development environment. Essential BOSS software can be run within the container environment without having to open a container shell using the included shell scripts. Still, a bash shell can be opened within the container in case BOSS functions are needed that do not have a corresponding shell script. If you find yourself using this repeatedly, please consider opening an issue so the missing feature can be added to the shell scripts!

## Included shell scripts
Five scripts are included that allow you to work with the boss container almost as if BOSS was installed on your host system. Consider placing them in your `$PATH` so you can use boss as if it was installed on your host system.

### `initboss.sh` and `stopboss.sh`
When the BOSS container is initialized using `initboss.sh`, the container is started and your workarea is mounted. Usually, your workarea will be the folder that contains your analysis package, like for example an [EP1 Yapp-package](https://gitlab.ep1.rub.de/Bes3/Yapp). The shell script either uses a command line parameter to assign your workarea or determines it from the working directory it is called from. If `initboss.sh` is called without the `--workarea` parameter from somewhere within a folder called "Yapp" or "TestRelease" in your workarea, the latter is recognized automatically. Otherwise, the directory the script is called from is used as workarea. Use "initboss.sh -h" to see all available options.

You can shut down the container at any time by calling `stopboss.sh`.

### `cmt.sh` and `boss.exe.sh`
The most common operations to be performed on development machines should be compiling analysis code using `cmt` and running it using `boss.exe`. These scripts do just that.

Please note that `cmt.sh` and `boss.exe.sh` only function when called from a location that is mounted in your BOSS container (within your workarea).

### `boss_shell.sh`
If actions not supported by the above scripts are required, you can always use this script to enter a `bash` shell inside the container and continue from there.

Beware that to reduce container size, lots of software commonly used for interactive development is not installed, for example there is neither `vim`, not `emacs` or `git`. If you plan on using the interactive mode for development, you should consider modifying `bossdocker/Dockerfile` to install some of these essentials and rebuilding the image.

## Purely interactive use (`interactiveboss.sh`)
Similar to the result of using `boss_shell.sh` described above, the container can be run purely interactively, removing the need for `initboss.sh` and `stopboss.sh` in this scenario. The script `interactiveboss.sh` will start the container with an interactive bash shell and detect your workarea from your current working directory, similar to `initboss.sh`.

Purists may also use the following docker command (make sure to plug in your workarea path):
```
docker run --security-opt label=disable -it --rm -v /absolute/path/to/workarea:/root/workarea --privileged jreher/boss
```
The BOSS environment should be mounted and configured automatically. Should that fail, the following commands can help:
```
source /root/mount.sh
source /root/setup.sh
```

# Persistant Cache
The CVMFS file system used to mount BOSS executables within the container relies on a network connection, which can be inherently slow. This effect is mostly mitigated by a local cache that makes recently used data available offline. By default, this cache is prepopulated from the most common operations and stored within the docker container. As the BOSS container is used, the cache grows until the container is shut down.

By using the command line option `-p` on `initboss.sh`, the CVMFS cache can be mounted as a docker volume, which allows it to persist when the container is shut down as long as the volume is not explicitly deleted. So far this feature is still not fully tested. Once it is ready, this will become the default behavior of `initboss.sh`.

# Using external cvmfs
The cvmfs instance included in this container mounts a remote directory that contains BOSS itself and most of its dependencies. This directory is very large, meaning that it can't realistically be included with the image, and even hosting it locally is not advisable. The cache included with the image mitigates most delays incurred by CVMFS needing to access the remote repository, but of course not all of them.

If you plan on using the BOSS container in an environment in which several users have access to a shared file system, you should consider running CVMFS on one of your file servers to mount the remote directory there. In this case, you can extend the docker instructions in `initboss.sh` to mount your local copy into the container. CVMFS is automatically disabled within the container if the directory is populated in this way.

In this case, you could also modify `bossdocker/Dockerfile` to skip adding a prebuilt cvmfs-cache to the image by removing the following line, which significantly reduces the size of the image:
```
RUN mkdir -p /var/cvmfs && curl https://ep1.rub.de/~jreher/bossdocker-download/cache/cvmfs-cache-$BOSS_VERSION.tar.gz | tar xzf - -C /
``` 

Increased support for this feature is considered for the future and may include:
* A preconfigured CVMFS container that you can run as a system service to mount the required directories
* Modified versions of `initboss.sh` and `interactiveboss.sh` that mount an external cvmfs directory
* BOSS images without cvmfs installation or cache, to be used with a cvmfs directory mounted from the outside.

# Old Versions on Dockerhub
Older versions using a completely different approach to offer BOSS 7.0.3 either as a huge image or in EP1 infrastructure, are still available using the tags `release-7.0.3`, `test-7.0.3`, `release-7.0.3-light` and `test-7.0.3-light` on dockerhub. The code for these old versions is located in the EP1 gitlab and requires an EP1 LDAP account to access.