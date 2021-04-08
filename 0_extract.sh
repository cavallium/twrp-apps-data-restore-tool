#!/bin/bash -e

bashdir="$PWD"
backupdir="$1"
outdir="work"
if [ -z "$backupdir" ]
  then
    echo "You must supply the path of the backup directory"
    exit 1
fi

mkdir -p "$outdir"

find "$backupdir" -name "data.*.win*" ! -name '*.sha2' ! -name '*.info' -type f -exec tar -xvf {} --directory="$bashdir/$outdir" \;

echo "Done."
