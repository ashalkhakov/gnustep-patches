#!/bin/sh
# Apply this repository's patches for one upstream project to a checkout of
# it.
#
#   Scripts/apply-patches.sh libs-base /path/to/libs-base
#
# Every patch is applied with no fuzz, so a hunk that no longer matches is an
# error rather than a guess.  A patch that reverse-applies is skipped with a
# note instead: that is what a fix looks like after it has been merged
# upstream but before the patch has been deleted here, and it must not break
# the build of whoever is consuming this.
#
# Exit status is non-zero if any patch failed to apply for any other reason.
set -eu

if [ $# -ne 2 ]; then
    echo "usage: $0 <upstream-project> <checkout-directory>" >&2
    exit 2
fi

project=$1
checkout=$2
here=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

if [ ! -d "$here/$project" ]; then
    echo "apply-patches: no patches for $project"
    exit 0
fi
if [ ! -d "$checkout" ]; then
    echo "apply-patches: $checkout is not a directory" >&2
    exit 2
fi

failed=0

for patch_file in "$here/$project"/*/0001-*.patch; do
    [ -e "$patch_file" ] || continue
    name=$(basename "$(dirname "$patch_file")")

    if patch -p1 -F0 -R --dry-run -f -d "$checkout" < "$patch_file" >/dev/null 2>&1; then
        echo "apply-patches: $project/$name is already in this checkout, skipping"
        continue
    fi

    if patch -p1 -F0 --forward -d "$checkout" < "$patch_file" >/dev/null 2>&1; then
        echo "apply-patches: $project/$name applied"
    else
        echo "apply-patches: $project/$name FAILED to apply to $checkout" >&2
        patch -p1 -F0 --forward --dry-run -d "$checkout" < "$patch_file" >&2 || true
        failed=1
    fi
done

exit $failed
