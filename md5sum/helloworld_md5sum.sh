#!/bin/bash
# Copyright (c) 2015 guileschool.com
# All rights reserved.
#
# NAME:  helloworld.sh
# VER:   1.0.0
# PLAT:  linux
# DESCR: tutorial of md5sum 
# BYTES: 222326344
# LINES: 48
# MD5:   60a9651bdc008b71c3571a0951305bfd
# NOTE: inspired by Anaconda2-2.4.1-MacOSX-x86_64.sh 

THIS_DIR=$(cd $(dirname $0); pwd)
THIS_FILE=$(basename $0)
THIS_PATH="$THIS_DIR/$THIS_FILE"
PREFIX=$THIS_DIR #$HOME/anaconda2
BATCH=0
FORCE=0

# verify the MD5 sum of the tarball appended to this header
MD5=$(tail -n +48 "$THIS_PATH" | md5sum)
echo $MD5 | grep 60a9651bdc008b71c3571a0951305bfd >/dev/null
if (( $? )); then
    echo "WARNING: md5sum mismatch of tar archive
expected: 60a9651bdc008b71c3571a0951305bfd
     got: $MD5" >&2
fi

# extract the tarball appended to this header, this creates the *.tar.bz2 files
# for all the packages which get installed below
# NOTE:
#   When extracting as root, tar will by default restore ownership of
#   extracted files, unless --no-same-owner is used, which will give
#   ownership to root himself.
cd $PREFIX

tail -n +48 "$THIS_PATH" | tar xf - --no-same-owner
if (( $? )); then
    echo "ERROR: could not extract tar starting at line 48" >&2
    exit 1
fi

${THIS_DIR}/helloworld

exit 0

