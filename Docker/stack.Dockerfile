# The patched GNUstep stack, published: what every app builds and tests on,
# instead of each building its own. A v* tag of this repository (its version
# is the date, v2026.10.13) publishes it as
#
#   ghcr.io/<owner>/gnustep:<version> and :latest     (linux/amd64, linux/arm64)
#
# Ubuntu 22.04, the oldest LTS in support: an AppImage built on it runs on
# anything as new. Every component any app uses, the patches applied, in
# /opt/gnustep; the packages building on it needs (Scripts/packages-ubuntu.txt);
# and in /opt/gnustep/share/gnustep-patches what it is: VERSION, MANIFEST (the
# commit of each component) and the package list.
#
#   docker build -f Docker/stack.Dockerfile --build-arg VERSION=2026.10.13 .
#
# (Docker/Dockerfile is the other image: unpatched, with its sources, for
# trying a patch.)
ARG UBUNTU=22.04

FROM ubuntu:${UBUNTU} AS base
ARG DEBIAN_FRONTEND=noninteractive
COPY Scripts/packages-ubuntu.txt /tmp/packages-ubuntu.txt
# A mirror or a caching proxy between it and here hands out a stale index
# or file now and then (a hash mismatch): no pipelining, no proxy caches,
# and tried again (as TopoText's and ODataKit's images do).
RUN printf 'Acquire::http::No-Cache "true";\nAcquire::BrokenProxy "true";\nAcquire::http::Pipeline-Depth "0";\nAcquire::Retries "3";\n' \
      > /etc/apt/apt.conf.d/99-gnustep
RUN set -e; apt="apt-get -q"; \
    for i in 1 2 3 4 5; do \
      if $apt update && grep -v '^#' /tmp/packages-ubuntu.txt | xargs $apt install -y --no-install-recommends; then break; fi; \
      [ "$i" != 5 ] || exit 1; rm -rf /var/lib/apt/lists/*; sleep 10; \
    done; \
    rm -rf /var/lib/apt/lists/*; \
    # The gnustep-2.0 runtime needs ld.gold or lld; 22.04's binutils has gold.
    update-alternatives --install /usr/bin/ld ld /usr/bin/ld.gold 10
ENV CC=clang CXX=clang++ LIBRARY_COMBO=ng-gnu-gnu RUNTIME_VERSION=gnustep-2.0 \
    PREFIX=/opt/gnustep LD_LIBRARY_PATH=/opt/gnustep/lib

FROM base AS build
# libdispatch wants CMake 3.26 or newer; 22.04's is 3.22.
RUN python3 -m pip install --quiet 'cmake>=3.26'
COPY . /gnustep-patches
ARG COMPONENTS="libobjc2 libdispatch tools-make libs-base libs-gui libs-back libs-corebase libs-opal eau tools-xctest"
RUN COMPONENTS="$COMPONENTS" SOURCES=/tmp/gnustep-sources /gnustep-patches/Scripts/build-gnustep.sh
ARG VERSION=0.0.0
ARG REVISION=unknown
RUN set -e; d=/opt/gnustep/share/gnustep-patches; mkdir -p "$d"; \
    echo "$VERSION" > "$d/VERSION"; \
    { echo "gnustep-patches $REVISION"; \
      for s in /tmp/gnustep-sources/*/; do echo "$(basename "$s") $(git -C "$s" rev-parse HEAD)"; done; \
    } > "$d/MANIFEST"; \
    cp /gnustep-patches/Scripts/packages-ubuntu.txt /gnustep-patches/Scripts/build-gnustep.sh "$d/"; \
    cat "$d/MANIFEST"

FROM base AS stack
COPY --from=build /opt/gnustep /opt/gnustep
ARG VERSION=0.0.0
LABEL org.opencontainers.image.title="gnustep" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.description="GNUstep with gnustep-patches' fixes, on Ubuntu 22.04, in /opt/gnustep"
# Checked as it is shipped: libdispatch's main-queue hooks in gnustep-base,
# ICU, the backend bundle.
RUN /opt/gnustep/share/gnustep-patches/build-gnustep.sh --verify-only
CMD ["bash"]
