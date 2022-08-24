#!/bin/bash

if [ -z "$(ls -A /cvmfs/bes3.ihep.ac.cn 2>/dev/null)" ] ; then
  mount -a
fi