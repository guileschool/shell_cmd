#!/bin/bash

for name in *.$1
do
 mv $name ${name%$1}$2
done

