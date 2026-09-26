#!/usr/bin/env sh
# Build a patched GNUstep stack from source into a prefix.
#
#   Scripts/build-gnustep.sh                       # everything, into $PREFIX
#   COMPONENTS="libobjc2 libdispatch tools-make libs-base" Scripts/build-gnustep.sh
#   Scripts/build-gnustep.sh --verify-only         # check a prefix that is already there
#   Scripts/build-gnustep.sh --print-recipe-hash   # for a CI cache key
#
# This replaces the near-identical dependencies.sh that several projects were
# each carrying.  What genuinely differs between them is expressed as input:
# which components to build, which patches to apply, where to put the result.
# What was only accidentally different - build order, configure flags, whether
# a workaround was remembered - is decided here, once.
#
# Inputs, all optional except PREFIX:
#
#   PREFIX           where the stack is installed (also accepted: INSTALL_PATH)
#   SOURCES          where the checkouts live (also accepted: DEPS_PATH)
#   COMPONENTS       build these, in this order (default: the full stack)
#   PATCHES          "all" (default), "none", or a list of <project>/<topic>
#   CC, CXX          default clang / clang++
#   LIBRARY_COMBO    default ng-gnu-gnu
#   RUNTIME_VERSION  default gnustep-2.0
#   JOBS             default $(nproc)
#   CLEAN            1 empties the prefix's contents first (never the prefix)
#   <COMPONENT>_REF  build that component at a commit instead of master,
#                    e.g. LIBS_BASE_REF=4579c681f
set -eu

PATCHES_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

PREFIX=${PREFIX:-${INSTALL_PATH:-}}
SOURCES=${SOURCES:-${DEPS_PATH:-}}
COMPONENTS=${COMPONENTS:-"libobjc2 libdispatch tools-make libs-base libs-gui libs-back eau tools-xctest"}
PATCHES=${PATCHES:-all}
CC=${CC:-clang}
CXX=${CXX:-clang++}
LIBRARY_COMBO=${LIBRARY_COMBO:-ng-gnu-gnu}
RUNTIME_VERSION=${RUNTIME_VERSION:-gnustep-2.0}
JOBS=${JOBS:-$(nproc 2>/dev/null || echo 4)}
CLEAN=${CLEAN:-0}

export CC CXX LIBRARY_COMBO RUNTIME_VERSION

# ------------------------------------------------------------------ #
# The recipe hash: script + selected components + the patches that
# will be applied + any pins.  A CI cache key made from this changes
# exactly when the resulting prefix would.
# ------------------------------------------------------------------ #
recipe_hash() {
    {
        cat "$0"
        echo "components=$COMPONENTS"
        echo "patches=$PATCHES"
        echo "combo=$LIBRARY_COMBO abi=$RUNTIME_VERSION cc=$CC"
        for component in $COMPONENTS; do
            eval "echo \"ref:$component=\${$(printf %s "$component" | tr 'a-z-' 'A-Z_')_REF:-master}\""
        done
        for project in "$PATCHES_ROOT"/*/; do
            [ -d "$project" ] || continue
            for patch_file in "$project"*/0001-*.patch; do
                [ -e "$patch_file" ] || continue
                cat "$patch_file"
            done
        done
    } | (sha256sum 2>/dev/null || shasum -a 256) | cut -d' ' -f1
}

case "${1:-}" in
    --print-recipe-hash) recipe_hash; exit 0 ;;
esac

[ -n "$PREFIX" ] || { echo "build-gnustep: set PREFIX (or INSTALL_PATH)" >&2; exit 2; }
SOURCES=${SOURCES:-$PREFIX/../gnustep-sources}

# ------------------------------------------------------------------ #
# Helpers
# ------------------------------------------------------------------ #
say() { echo "=== $*"; }

# cmake and configure put libobjc2 and libdispatch in $PREFIX/lib, which is
# not one of the GNUstep library roots - those live under
# System/Library/Libraries - so nothing would add it to the loader path, and
# configure would decide the runtime is missing.
export LD_LIBRARY_PATH="$PREFIX/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export C_INCLUDE_PATH="$PREFIX/include${C_INCLUDE_PATH:+:$C_INCLUDE_PATH}"
export CPLUS_INCLUDE_PATH="$PREFIX/include${CPLUS_INCLUDE_PATH:+:$CPLUS_INCLUDE_PATH}"

ref_for() {
    eval "echo \"\${$(printf %s "$1" | tr 'a-z-' 'A-Z_')_REF:-}\""
}

# Clone at master, or fetch exactly one pinned commit: a server will serve
# any reachable commit, and that neither depends on a branch name nor
# downloads the history.
fetch() {
    name=$1 url=$2
    ref=$(ref_for "$name")
    dir="$SOURCES/$name"

    if [ -d "$dir/.git" ]; then
        say "$name: reusing $dir"
        return 0
    fi

    if [ -n "$ref" ]; then
        mkdir -p "$dir"
        (cd "$dir" && git init -q && git remote add origin "$url" \
            && git fetch -q --depth 1 origin "$ref" && git checkout -q FETCH_HEAD)
    else
        git clone -q --depth 1 --recursive "$url" "$dir"
    fi
}

apply_patches_for() {
    project=$1 dir=$2
    case "$PATCHES" in
        none) return 0 ;;
        all)  "$PATCHES_ROOT/Scripts/apply-patches.sh" "$project" "$dir" ;;
        *)
            for topic in $PATCHES; do
                case "$topic" in
                    "$project"/*)
                        patch_file=$PATCHES_ROOT/$topic/0001-*.patch
                        # shellcheck disable=SC2086
                        patch -p1 -F0 --forward -d "$dir" < $patch_file
                        say "$topic applied"
                        ;;
                esac
            done
            ;;
    esac
}

configure_in() {
    dir=$1; shift
    (cd "$dir" && ./configure "$@" || { cat config.log; exit 1; })
}

# GNUstep.sh reads $ZSH_VERSION and friends without guarding them, which is
# an error under set -u, so it is sourced with that relaxed.
gnustep_sh() {
    set +u
    . "$PREFIX/System/Library/Makefiles/GNUstep.sh"
    set -u
}

# ------------------------------------------------------------------ #
# Components
# ------------------------------------------------------------------ #
build_libobjc2() {
    fetch libobjc2 https://github.com/gnustep/libobjc2.git
    apply_patches_for libobjc2 "$SOURCES/libobjc2"
    mkdir -p "$SOURCES/libobjc2/build"
    (cd "$SOURCES/libobjc2/build" && cmake .. \
        -DTESTS=off \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DGNUSTEP_INSTALL_TYPE=NONE \
        -DCMAKE_INSTALL_PREFIX:PATH="$PREFIX" \
        -DCMAKE_C_COMPILER="$CC" -DCMAKE_CXX_COMPILER="$CXX" \
        && make -j"$JOBS" && make install)
}

# Built before gnustep-base on purpose, and with its private headers:
# base's configure probes for _dispatch_main_queue_callback_4CF and
# _dispatch_get_main_queue_handle_4CF and only then builds an NSRunLoop that
# drains the main dispatch queue.  Build it afterwards and a main-queue
# context's -performBlock: never runs in a run-loop application, with nothing
# failing loudly.  BlocksRuntime comes from libobjc rather than libdispatch's
# own copy.
build_libdispatch() {
    fetch libdispatch https://github.com/swiftlang/swift-corelibs-libdispatch.git
    mkdir -p "$SOURCES/libdispatch/build"
    (cd "$SOURCES/libdispatch/build" && cmake .. \
        -DBUILD_TESTING=off \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DCMAKE_INSTALL_PREFIX:PATH="$PREFIX" \
        -DCMAKE_C_COMPILER="$CC" -DCMAKE_CXX_COMPILER="$CXX" \
        -DCMAKE_C_FLAGS="-Wno-error=void-pointer-to-int-cast" \
        -DINSTALL_PRIVATE_HEADERS=1 \
        -DBlocksRuntime_INCLUDE_DIR="$PREFIX/include" \
        -DBlocksRuntime_LIBRARIES="$PREFIX/lib/libobjc.so" \
        && make -j"$JOBS" && make install)
}

build_tools_make() {
    fetch tools-make https://github.com/gnustep/tools-make.git
    configure_in "$SOURCES/tools-make" \
        --prefix="$PREFIX" \
        --with-layout=gnustep \
        --with-library-combo="$LIBRARY_COMBO" \
        --with-runtime-abi="$RUNTIME_VERSION" \
        --enable-objc-arc \
        CPPFLAGS="-I$PREFIX/include" \
        LDFLAGS="-L$PREFIX/lib -Wl,-rpath,$PREFIX/lib" \
        CC="$CC" CXX="$CXX"
    (cd "$SOURCES/tools-make" && make -j"$JOBS" && make install)
    gnustep_sh
    gnustep-config --objc-flags >/dev/null
}

# --with-config-file is asked of gnustep-make rather than guessed: this
# layout writes it to $PREFIX/etc/GNUstep/GNUstep.conf, and when the named
# file does not exist libs-base silently falls back to standalone.conf's
# built-in defaults, which put every root at ./ relative to it - so
# gnustep-gui then looks for the backend beside etc/ and reports
# "Did not find correct version of backend (libgnustep-back-032.bundle)"
# while the bundle sits in Local/Library/Bundles.
build_libs_base() {
    fetch libs-base https://github.com/gnustep/libs-base.git
    apply_patches_for libs-base "$SOURCES/libs-base"
    gnustep_sh
    configure_in "$SOURCES/libs-base" \
        --prefix="$PREFIX" \
        --with-config-file="$(gnustep-config --variable=GNUSTEP_CONFIG_FILE)" \
        --with-default-config=standalone.conf
    (cd "$SOURCES/libs-base" && make -j"$JOBS" && make install)
}

build_libs_gui() {
    fetch libs-gui https://github.com/gnustep/libs-gui.git
    apply_patches_for libs-gui "$SOURCES/libs-gui"
    gnustep_sh
    configure_in "$SOURCES/libs-gui" --prefix="$PREFIX"
    (cd "$SOURCES/libs-gui" && make -j"$JOBS" && make install)
}

# Cairo rather than the X11 backend: it is the one that uses fontconfig, and
# so the one that draws text headlessly and prints.  The symlinks are because
# gui asks for the backend by version and master's gui and back do not always
# agree on the number.
build_libs_back() {
    fetch libs-back https://github.com/gnustep/libs-back.git
    apply_patches_for libs-back "$SOURCES/libs-back"
    gnustep_sh
    configure_in "$SOURCES/libs-back" --prefix="$PREFIX" --enable-graphics=cairo
    (cd "$SOURCES/libs-back" && make -j"$JOBS" && make install)

    bundle=$(find "$PREFIX" -name 'libgnustep-back-*.bundle' | head -n 1)
    if [ -n "$bundle" ]; then
        ln -sfn "$(basename "$bundle")" "$(dirname "$bundle")/libgnustep-back.bundle"
        ln -sfn "$(basename "$bundle")" "$(dirname "$bundle")/back.bundle"
    fi
}

# corebase's toll-free bridge probe is AC_CHECK_HEADERS(objc/runtime.h)
# followed by AC_SEARCH_LIBS(objc_getClass, [objc objc2]).  C_INCLUDE_PATH
# covers the header, but the link test needs a -L: LD_LIBRARY_PATH is a
# runtime path, not a link one.  Without these it fails with "Objective-C
# library not found!".
build_libs_corebase() {
    fetch libs-corebase https://github.com/gnustep/libs-corebase.git
    apply_patches_for libs-corebase "$SOURCES/libs-corebase"
    gnustep_sh
    configure_in "$SOURCES/libs-corebase" \
        --prefix="$PREFIX" \
        CPPFLAGS="-I$PREFIX/include" \
        LDFLAGS="-L$PREFIX/lib -Wl,-rpath,$PREFIX/lib"
    (cd "$SOURCES/libs-corebase" && make -j"$JOBS" && make install)
}

# Source only: the aggregate also builds Tests, a set of example tools this
# has no use for.  The mkdir is for OpalGraphics/GNUmakefile.postamble, which
# copies the ImageIO headers into GNUSTEP_SYSTEM_HEADERS with a bare cp -r,
# no mkdir and regardless of the installation domain - the directory does not
# exist in a fresh prefix, and the failed copy takes the install down with it.
build_libs_opal() {
    fetch libs-opal https://github.com/gnustep/libs-opal.git
    apply_patches_for libs-opal "$SOURCES/libs-opal"
    gnustep_sh
    mkdir -p "$(gnustep-config --variable=GNUSTEP_SYSTEM_HEADERS)"
    (cd "$SOURCES/libs-opal" && make -j"$JOBS" -C Source && make -C Source install)
}

# The theme uses blocks, and nothing in a theme bundle's link line pulls the
# runtime in by itself.  BlocksRuntime is a separate library only when
# libdispatch built its own; ours is told to use libobjc's, so ask for it
# only when it is there.
build_eau() {
    fetch eau https://github.com/gershwin-desktop/gershwin-eau-theme.git
    apply_patches_for gershwin-eau-theme "$SOURCES/eau"
    gnustep_sh
    ldflags="-L$PREFIX/lib -Wl,-rpath,$PREFIX/lib -ldispatch"
    [ -e "$PREFIX/lib/libBlocksRuntime.so" ] && ldflags="$ldflags -lBlocksRuntime"
    (cd "$SOURCES/eau" && make -j"$JOBS" ADDITIONAL_LDFLAGS="$ldflags" && make install)
}

build_tools_xctest() {
    fetch tools-xctest https://github.com/gnustep/tools-xctest.git
    gnustep_sh
    (cd "$SOURCES/tools-xctest" && make -j"$JOBS" && make install)
}

# ------------------------------------------------------------------ #
# Verification - run after a build and after a cache restore, because a
# prefix that came out of a cache can be wrong in exactly the same ways.
# ------------------------------------------------------------------ #
verify() {
    failed=0
    gnustep_sh

    base=$(ls "$PREFIX"/*/Library/Libraries/libgnustep-base.so.* 2>/dev/null | head -1 || true)
    if [ -z "$base" ]; then
        echo "verify: no libgnustep-base in $PREFIX" >&2
        return 1
    fi

    for hook in _dispatch_main_queue_callback_4CF _dispatch_get_main_queue_handle_4CF; do
        if ! nm -D "$base" | grep -q " $hook\$"; then
            echo "verify: $base was built without libdispatch main-queue support ($hook)" >&2
            echo "verify: libdispatch must be built, with its private headers, BEFORE libs-base" >&2
            failed=1
        fi
    done

    # gnustep-base picks ICU up on its own when libicu-dev is present, and
    # says nothing at all when it is not.
    if ! ldd "$base" | grep -q libicu; then
        echo "verify: $base is not linked against ICU (is libicu-dev installed?)" >&2
        failed=1
    fi

    case " $COMPONENTS " in
        *" libs-back "*)
            if ! find "$PREFIX" -name 'libgnustep-back*.bundle' | grep -q .; then
                echo "verify: no backend bundle in $PREFIX" >&2
                failed=1
            fi
            ;;
    esac

    [ "$failed" -eq 0 ] && say "verify: $PREFIX looks sound"
    return "$failed"
}

# ------------------------------------------------------------------ #
case "${1:-}" in
    --verify-only) verify; exit $? ;;
esac

if [ "$CLEAN" = 1 ] && [ -d "$PREFIX" ]; then
    say "emptying $PREFIX"
    find "$PREFIX" -mindepth 1 -delete
fi

mkdir -p "$PREFIX" "$SOURCES"

for component in $COMPONENTS; do
    say "$component"
    case "$component" in
        libobjc2)       build_libobjc2 ;;
        libdispatch)    build_libdispatch ;;
        tools-make)     build_tools_make ;;
        libs-base)      build_libs_base ;;
        libs-gui)       build_libs_gui ;;
        libs-back)      build_libs_back ;;
        libs-corebase)  build_libs_corebase ;;
        libs-opal)      build_libs_opal ;;
        eau)            build_eau ;;
        tools-xctest)   build_tools_xctest ;;
        *) echo "build-gnustep: unknown component $component" >&2; exit 2 ;;
    esac
done

verify            # set -e: a prefix that fails verification fails the build

say "the prefix"
find "$PREFIX" -maxdepth 3 -type d | sort
