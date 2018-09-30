#!/bin/sh

set -e

cd ..

Rscript tools/build.R $1

cd -
