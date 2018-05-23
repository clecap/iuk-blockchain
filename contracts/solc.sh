#!/bin/bash

image=mysolc
docker images | grep -q $image
if [ $? -ne 0 ]; then
    echo "Failure: Could not find docker container \"$image\"!"
    echo -e "\nUse the Makefile to build it:"
    echo " > make solc"
    exit 1
fi

params="$@"
if [ "$#" -eq 0 ]; then
    params="--help"
fi

exec docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v "$PWD":/data $image solc $params
