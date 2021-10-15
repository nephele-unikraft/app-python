#!/bin/bash
set -e

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <directory>"
	exit -2
fi

DIR="$1"

LIBS=(\
	# "<libname>;<branch>
	"nephele-unikraft/lib-newlib;nephele-v01"
	"nephele-unikraft/lib-pthread-embedded;nephele-v01"
	"nephele-unikraft/lib-lwip;nephele-v01"
	"nephele-unikraft/lib-python3;nephele-v01"
	"unikraft/lib-intel-intrinsics;staging"
)
APPS=(\
	# "<appname>;<branch>
	"nephele-unikraft/app-python;nephele-v01"
)

entry_dir()    { pushd "$1" &>/dev/null; }
entry_newdir() { mkdir -p "$1" &>/dev/null; entry_dir "$1"; }
exit_dir()     { popd &>/dev/null; }

clone_and_checkout() {
	local repo="$1"
	local branch="$2"

	echo "*** Cloning '$repo' branch:$branch"

	local name="$(basename $repo)"
	name=${name#"unikraft-lib-"}
	name=${name#"lib-"}

	# clone only if it doesn't exist
	[ ! -d $name ] && git clone "git@github.com:$repo.git" $name

	entry_dir $name
	git checkout $branch
	exit_dir
}

# same routine for apps & libs
clone_externals() {
	local al="$1" # apps/libs
	shift 1
	local entries=($@)

	echo
	echo "*** $al ***"

	entry_newdir "$al"

	for entry in "${entries[@]}"; do
		IFS=";" read repo branch <<< "$entry"
		clone_and_checkout "$repo" $branch
	done

	exit_dir
}


entry_newdir $DIR

# Clone kernel
clone_and_checkout "nephele-unikraft/unikraft" "nephele-v01"

# Clone libs
clone_externals "libs" ${LIBS[@]}

# Clone apps
clone_externals "apps" ${APPS[@]}

exit_dir
