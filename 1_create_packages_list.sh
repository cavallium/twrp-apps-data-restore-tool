#!/bin/bash -e


basedir="$PWD"

echo "Found main user"
ls "$basedir/work/data/data/" --format single-column --indicator-style none > "$basedir/work/packages_list_0.txt"

cd work/data/user

for USERID in *; do
	if [ -d "${USERID}" ]; then
		echo "Found user ${USERID}"
		ls "$basedir/work/data/user/$USERID/" --format single-column --indicator-style none > "$basedir/work/packages_list_${USERID}.txt"
	fi
done
