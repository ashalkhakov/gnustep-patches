# A GNUstep stack to test patches against, built by this repository's own
# script so that the container is a recipe rather than a pet.
#
#   docker build -f Docker/Dockerfile -t gnustep-patches:latest .
#   docker run -d --name gs -v "$PWD:/patches:ro" gnustep-patches:latest sleep infinity
#   docker exec gs bash -lc '. /w/build/System/Library/Makefiles/GNUstep.sh && gnustep-tests /w/src/libs-base/Tests/base/NSPredicate'
#
# The stack lands in /w/build and the checkouts stay in /w/src, so a patch
# can be applied to one of them and the affected library rebuilt
# incrementally - which is what makes it cheap to see a test fail without a
# fix and pass with it.
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    CC=clang \
    CXX=clang++ \
    LIBRARY_COMBO=ng-gnu-gnu \
    RUNTIME_VERSION=gnustep-2.0 \
    PREFIX=/w/build \
    SOURCES=/w/src \
    LD_LIBRARY_PATH=/w/build/lib

# Packages over HTTPS: on some networks plain HTTP from ports.ubuntu.com
# arrives altered ("Hash Sum mismatch", "File has unexpected size"), which
# retries do not cure. The image has no CA certificates to check the mirror's
# with until it installs them, so that one install does not check the peer;
# apt still checks every index against Ubuntu's signing key and every package
# against the indexes, so nothing unsigned gets in.
RUN sed -i 's#http://\(ports\|archive\|security\)\.ubuntu\.com#https://\1.ubuntu.com#' \
        /etc/apt/sources.list.d/ubuntu.sources \
    && printf 'Acquire::Retries "5";\n' > /etc/apt/apt.conf.d/99-retries \
    && apt-get -o Acquire::https::Verify-Peer=false update \
    && apt-get -o Acquire::https::Verify-Peer=false install -y --no-install-recommends \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential clang cmake git pkg-config ca-certificates \
        libgnutls28-dev libffi-dev libicu-dev libxml2-dev libxslt1-dev \
        libssl-dev libavahi-client-dev zlib1g-dev gnutls-bin libcurl4-gnutls-dev \
        libgmp-dev libcairo2-dev libjpeg-dev libtiff-dev libpng-dev libicns-dev \
        libpthread-workqueue-dev libsqlite3-dev libsndfile1-dev libao-dev \
        libfreetype-dev libfontconfig1-dev libxrender-dev liblcms2-dev \
        libxt-dev libxmu-dev libxft-dev libxrandr-dev libxfixes-dev libxcursor-dev \
        libgl-dev libgl1-mesa-dri \
        xvfb valgrind \
    && rm -rf /var/lib/apt/lists/*

# The gnustep-2.0 runtime needs ld.gold or lld, and ld.gold is gone from
# binutils on 24.04.
RUN apt-get update && apt-get install -y --no-install-recommends lld \
    && update-alternatives --install /usr/bin/ld ld /usr/bin/ld.lld 10 \
    && rm -rf /var/lib/apt/lists/*

COPY Scripts /build-scripts/Scripts
COPY libs-base /build-scripts/libs-base
COPY libs-gui /build-scripts/libs-gui
COPY libs-opal /build-scripts/libs-opal
COPY libs-corebase /build-scripts/libs-corebase
COPY gershwin-eau-theme /build-scripts/gershwin-eau-theme

# Built unpatched on purpose: a container that already has the fixes cannot
# show a test failing without them.  Apply what you are testing with
# Scripts/apply-patches.sh and rebuild that library.
RUN PATCHES=none /build-scripts/Scripts/build-gnustep.sh

# valgrind is here because the faults that have no test - a use-after-free
# the allocator hides - are the ones that need it.
CMD ["sleep", "infinity"]
