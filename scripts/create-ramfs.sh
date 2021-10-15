#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Usage: $0 <rootfs-path> <out-initramfs-path>"
	exit 2
fi

MYROOTFS="$1"

# Workaround: On Alpine, realpath needs a file or directory
touch $2

MYFILE="$(realpath $2)"

pushd $MYROOTFS >/dev/null
find -depth -print | tac | cpio -ov --format newc > $MYFILE
popd &>/dev/null

