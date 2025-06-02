#!/usr/bin/env bash
docker build --platform linux/amd64 -t looney /docker/*

docker run  --tty --rm \
           -it looney /bin/bash

# docker run --tty -it --rm --platform linux/amd64 looney 
