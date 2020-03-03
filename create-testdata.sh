#!/bin/bash
#
# Convert source testimage to testdata in various formats
#

which xxd > /dev/null || { echo "xxd tool needed"; exit 1; }
which convert > /dev/null || { echo "convert tool needed"; exit 1; }
which boxer > /dev/null
box=$?

for f in png tiff ; do 

    rm -rf $f > /dev/null
    mkdir -p $f > /dev/null

    for i in source/jpg/*.jpg; do
        for s in 100 50 25 12 ; do
            o=$f/$(basename $i .jpg)-x$s.$f
            convert $i -resize "$s%" $o

            b="$(dirname $o)/$(basename $o .$f)"
            xxd -i $o $b.h

            identify $o

            if [ "$box" == "0" ] ; then
                boxer -i $o -f 4k-controlframe-v7 $b.raw
                xxd -i ${b}_0000.raw | sed -e 's/ 0x0//g' > ${b}_0000.h
	    fi
        done
    done
done
