#!/bin/bash

export PS4='+$LINENO:$FUNCNAME: '

### Used for TRACE
trap '(read -p "[$LINENO] $BASH_COMMAND?")' DEBUG

set -x

function sub() {
  echo 'my subroutine()'
}

echo hello world1
echo hello world2
echo hello world3
sub 1 2
echo hello world4
echo hello world5
echo hello world6
echo hello world7
echo hello world9


