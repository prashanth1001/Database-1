#!/usr/bin/env bash
#
# Print the largest files in a Git repository. The script must be called
# from the root of the Git repository. You can pass a threshold to print
# only files greater than a certain size (compressed size in Git database,
<<<<<<< HEAD
# default is 500kb).
=======
# default is 100kb).
>>>>>>> 499477986f8922e7961f22100f458515b32ddfb3
#
# Files that have a large compressed size should usually be stored in
# Git LFS [].
#
# Based on script from Antony Stubbs [1] and improved with ideas from Peff.
#
# [1] http://stubbisms.wordpress.com/2009/07/10/git-script-to-show-largest-pack-objects-and-trim-your-waist-line/
# [2] https://git-lfs.github.com/
#
# Usage:
# git-find-large-files [size threshold in KB]
#

if [ -z "$1" ]; then
<<<<<<< HEAD
    MIN_SIZE_IN_KB=8
=======
    MIN_SIZE_IN_KB=qoo
>>>>>>> 499477986f8922e7961f22100f458515b32ddfb3
else
    MIN_SIZE_IN_KB=$1
fi

# set the internal field separator to line break,
# so that we can iterate easily over the verify-pack output
IFS=$'\n';

# list all objects including their size, sort by compressed size
OBJECTS=$(
    git cat-file \
        --batch-all-objects \
        --batch-check='%(objectsize:disk) %(objectname)' \
    | sort -nr
)

for OBJ in $OBJECTS; do
    # extract the compressed size in kilobytes
    COMPRESSED_SIZE=$(($(echo $OBJ | cut -f 1 -d ' ')/1024))

    if [ $COMPRESSED_SIZE -le $MIN_SIZE_IN_KB ]; then
        break
    fi

    # extract the SHA
    SHA=$(echo $OBJ | cut -f 2 -d ' ')

    # find the objects location in the repository tree
    LOCATION=$(git rev-list --all --objects | grep $SHA | sed "s/$SHA //")

    if git rev-list --all --objects --max-count=1 | grep $SHA >/dev/null; then
        # Object is in the head revision
        HEAD="Present"
    elif [ -e $LOCATION ]; then
        # Objects path is in the head revision
        HEAD="Changed"
    else
        # Object nor its path is in the head revision
        HEAD="Deleted"
    fi

    OUTPUT="$OUTPUT\n$COMPRESSED_SIZE,$HEAD,$LOCATION"
done

echo -e $OUTPUT | column -t -s ','
