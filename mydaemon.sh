#!/bin/bash

for i in {1..60};do
date >> mydaemon.log
sleep 1
done

