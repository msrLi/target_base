#!/bin/sh

BASH=`pwd`
LIBPATH=${BASH}:${BASH}/release/lib
MY_PATH=${BASH}/release/bin
export LD_LIBRARY_PATH=${LIBPATH}:${LD_LIBRARY_PATH}
export PATH=${MY_PATH}:${PATH}
