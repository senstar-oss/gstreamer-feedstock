#!/bin/bash
set -ex

pushd plugins_ugly

rm -rf build
mkdir build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig
EXTRA_FLAGS=""
if [[ $CONDA_BUILD_CROSS_COMPILATION == "1" ]]; then
  # Use Meson cross-file flag to enable cross compilation when building GPL-dependent plugins.
  EXTRA_FLAGS="--cross-file $BUILD_PREFIX/meson_cross_file.txt"
fi

export PKG_CONFIG=$(which pkg-config)

# Enable GPL plugins, build in isolation, and install only GPL artifacts to avoid overlapping the LGPL package payload.
meson_options=(
      -Dgpl=enabled
      -Dasfdemux=disabled
      -Ddvdlpcmdec=disabled
      -Ddvdsub=disabled
      -Drealmedia=disabled
      -Dnls=disabled
      -Dtests=disabled
      -Ddoc=disabled
)

meson setup ${MESON_ARGS} \
      $EXTRA_FLAGS \
      --wrap-mode=nofallback \
      "${meson_options[@]}" \
      ..
ninja -j${CPU_COUNT}

# Stage the GPL artifacts, then copy only the GPL plugin and its preset into the final prefix.
STAGING_DIR=$PWD/_dest
rm -rf "${STAGING_DIR}"
DESTDIR="${STAGING_DIR}" ninja install

INSTALL_ROOT="${STAGING_DIR}${PREFIX}"

install -Dm755 "${INSTALL_ROOT}/lib/gstreamer-1.0/libgstx264.so" \
  "${PREFIX}/lib/gstreamer-1.0/libgstx264.so"

if [[ -f "${INSTALL_ROOT}/share/gstreamer-1.0/presets/GstX264Enc.prs" ]]; then
  install -Dm644 "${INSTALL_ROOT}/share/gstreamer-1.0/presets/GstX264Enc.prs" \
    "${PREFIX}/share/gstreamer-1.0/presets/GstX264Enc.prs"
fi

rm -rf "${STAGING_DIR}"

