#!/bin/sh

set -e

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    exit 1
fi

cd ..

git add . && git status && git commit -m "$1" && git push && git status

cd -
