#!/bin/bash -e
bashdir="$PWD"
outdir="work"

if [ -z "$1" ]
  then
    echo "You must supply the path of the .ab file"
    exit 1
fi

abfile=$(readlink -f "$1")

if [ -z "$abfile" ]
  then
    echo "You must supply the path of the .ab file"
    exit 1
fi

mkdir -p "$outdir"
outdir=$(readlink -f "$outdir")
mkdir -p "$outdir/ab_backup"

cd "$outdir/ab_backup"
"$bashdir/twrpabx" "$abfile" > /dev/null
cd $bashdir

#Extract
for i in $(find "$outdir/ab_backup" -name "data.*.win*" ! -name '*.sha2' ! -name '*.info' -type f); do
    echo "Extracting file \"$i\""
    ( pv $i | tar -x --overwrite -C "$outdir" ) || true
done

#Delete extracted backup directory
rm -rf "$outdir/ab_backup"

#Fix directory structure
if [ -d "$outdir/user/0" ]
  then
    rmdir "$outdir/user/0"
fi
mv "$outdir/data" "$outdir/data_tmp"
mkdir -p "$outdir/data"
mv "$outdir/data_tmp" "$outdir/data/data"
mv "$outdir/user" "$outdir/data/user"
mv "$outdir/app" "$outdir/data/app"
