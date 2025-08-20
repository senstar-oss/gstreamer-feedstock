#!/bin/bash
set -ex

pushd rtsp_server

mkdir build
pushd build

# Ensure pkg-config and introspection paths
export XDG_DATA_DIRS=${XDG_DATA_DIRS}:$PREFIX/share:$BUILD_PREFIX/share
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig
EXTRA_FLAGS="-Dintrospection=enabled"
if [[ $CONDA_BUILD_CROSS_COMPILATION == "1" ]]; then
  EXTRA_FLAGS="--cross-file $BUILD_PREFIX/meson_cross_file.txt -Dintrospection=disabled"
fi

export PKG_CONFIG=$(which pkg-config)

meson ${MESON_ARGS} \
      $EXTRA_FLAGS \
      -Dexamples=disabled \
      -Dtests=disabled \
      --wrap-mode=nofallback \
      ..
ninja -j${CPU_COUNT}
ninja install
