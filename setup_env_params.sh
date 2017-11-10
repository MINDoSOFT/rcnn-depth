#!/bin/bash
# Required for MATLAB to work correctly
export LD_PRELOAD=/usr/lib/gcc/x86_64-linux-gnu/4.8.5/libgomp.so
export LD_LIBRARY_PATH=/usr/local/cuda-7.0/lib64/
MESSAGE="LD_PRELOAD and LD_LIBRARY_PATH set."
echo $MESSAGE
