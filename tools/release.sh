#!/bin/sh

./build.sh

cd ..

Rscript tools/release.R

cd -
