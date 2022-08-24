#!/bin/bash

TestReleaseName="$(find /root/TestRelease/TestRelease-* -maxdepth 0 -type d)"
if [ ! -d "/root/workarea/TestRelease/$TestReleaseName" ]; then
  echo "$TestReleaseName not found in workarea! Copying from Template..."
  mkdir -p /root/workarea/TestRelease
  cp -r /root/TestRelease/* /root/workarea/TestRelease/
fi
source /root/mount.sh
source /root/setup.sh
bash -i