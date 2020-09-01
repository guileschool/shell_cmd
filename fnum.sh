#!/bin/bash

for i in $( seq 1 10 ); do
    printf "%03d\\t" "$i"
done
echo

