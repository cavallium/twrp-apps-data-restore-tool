#!/bin/bash
bashdir="$PWD"
outdir="work"

abfile=$(readlink -f "$1")

mkdir -p "$outdir"
outdir=$(readlink -f "$outdir")
mkdir -p "$outdir/ab_backup"

#dd if="$1" bs=512 skip=3 | tar -x -C "$outdir/ab_backup"
#java -jar abe.jar unpack "$1" "$outdir/ab_backup.tar"
cd "$outdir/ab_backup"
"$bashdir/twrpabx" "$abfile"

#tar -xf "$outdir/ab_backup.tar" -C "$outdir/ab_backup"

echo "The backup has been extracted to: \"$outdir/ab_backup\""
echo "Please use that path for the next steps"
