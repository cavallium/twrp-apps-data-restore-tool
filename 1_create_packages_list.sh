#!/bin/bash -e


basedir="$PWD"

cd work/data/user

for USERID in *; do
    if [ -d "${USERID}" ]; then
        echo "${USERID}"   # your processing here
				ls "$basedir/work/data/user/$USERID/" --format single-column --indicator-style none > "$basedir/work/packages_list_${USERID}.txt"
    fi
		ls "$basedir/work/data/data/" --format single-column --indicator-style none > "$basedir/work/packages_list_0.txt"
done
