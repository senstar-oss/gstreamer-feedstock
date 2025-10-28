#!/bin/bash
set -ex

pushd plugins_ugly

rm -rf build
mkdir build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig
EXTRA_FLAGS=""
if [[ $CONDA_BUILD_CROSS_COMPILATION == "1" ]]; then
  # Use Meson cross-file flag to enable cross compilation when building LGPL-only plugins.
  EXTRA_FLAGS="--cross-file $BUILD_PREFIX/meson_cross_file.txt"
fi

export PKG_CONFIG=$(which pkg-config)

# Build only the LGPL-compatible subset of GStreamer ugly plugins.
meson_options=(
      -Dgpl=disabled
      -Dnls=enabled
      -Dtests=disabled
      -Ddoc=disabled
)

meson setup ${MESON_ARGS} \
      $EXTRA_FLAGS \
      --wrap-mode=nofallback \
      "${meson_options[@]}" \
      ..
ninja -j${CPU_COUNT}
ninja install

