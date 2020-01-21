#!/bin/sh
#
# Convert source testimage to testdata in various formats
#

which -s xxd || { echo "xxd tool needed"; exit 1; }
which -s convert || { echo "convert tool needed"; exit 1; }

for f in png tiff ; do 

    rm -rf $f > /dev/null
    mkdir -p $f > /dev/null

    for i in source/jpg/*.jpg; do
        for s in 100 50 25 12 ; do
            o=$f/$(basename $i .jpg)-x$s.$f
            convert $i -resize "$s%" $o
            
            xxd -i $o $(dirname $o)/$(basename $o .$f).h

            identify $o
        done
    done
done
