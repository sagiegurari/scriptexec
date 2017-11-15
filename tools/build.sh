#!/bin/sh

cd ..

find . -type f -print0 | xargs -0 dos2unix --

Rscript tools/build.R

cd -
