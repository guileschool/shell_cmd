#!/bin/bash
name=$1
email=$2
all=$*

if [ $# -eq 0 ] 
then
 echo "No arguments supplied"
fi

echo "your name is $name"
echo "your email is $email"
echo "* is $all"

