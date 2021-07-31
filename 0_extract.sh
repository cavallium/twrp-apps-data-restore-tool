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

for i in $(find "$backupdir" -name "data.*.win*" ! -name '*.sha2' ! -name '*.info' -type f); do
    echo "Extracting file \"$i\""
    pv $i | tar -x --overwrite -C "$bashdir/$outdir"
done

echo "Done."
