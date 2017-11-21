#!/bin/sh

set -e

cd ..

echo "Deleting generated files."
echo "=========================================================="
rm -Rf ./man
rm -Rf ./NAMESPACE

echo "Running build script."
echo "=========================================================="
Rscript tools/build.R

#echo "Fixing LF."
#echo "=========================================================="
#find . -not -path "./.git/*" -type f -print0 | xargs -0 dos2unix --

cd -
