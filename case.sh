#!/bin/bash

read -s -n 1 -p "You really want to exit? " response
case "$response" in
    Y|y)echo YES;;
    N|n)echo NO;;
    *)kill -SIGKILL $$;;
esac

