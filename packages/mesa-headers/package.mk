################################################################################
#      This file is part of LibreELEC - http://www.libreelec.tv
#      Copyright (C) 2016-present Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_MK="$ROOT/packages/graphics/mesa/package.mk"

PKG_NAME="mesa-headers"
PKG_VERSION="$(grep ^PKG_VERSION $PKG_MK | awk -F '=' '{print $2}' | sed 's/["]//g' )"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.mesa3d.org/"
PKG_URL=$(grep ^PKG_URL $PKG_MK | awk -F '=' '{print $2}' | sed 's/["]//g' )
  # convert string with literal $PKG_NAME-$PKG_VERSION into expanded variables
  PKG_URL="${PKG_URL/\$PKG_NAME/mesa}"
  PKG_URL="${PKG_URL/\$PKG_VERSION/$PKG_VERSION}"
PKG_DEPENDS_TARGET="$(grep ^PKG_DEPENDS_TARGET $PKG_MK | awk -F '=' '{print $2}' | sed 's/["]//g' )"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="Mesa headers for Mali"
PKG_LONGDESC="Mesa headers for Mali"
PKG_SOURCE_DIR="mesa-$PKG_VERSION"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_host() {
  : # nothing
}
make_host() {
  : # nothing
}

makeinstall_host() {
  mkdir -p $SYSROOT_PREFIX/usr/include
    cp -PvR $PKG_BUILD/include/EGL $SYSROOT_PREFIX/usr/include
    cp -PvR $PKG_BUILD/include/GLES2 $SYSROOT_PREFIX/usr/include
    cp -PvR $PKG_BUILD/include/KHR $SYSROOT_PREFIX/usr/include
  mkdir -p $SYSROOT_PREFIX/usr/lib/pkgconfig
    cat > $SYSROOT_PREFIX/usr/lib/pkgconfig/egl.pc <<\ \ \ \ EoF
prefix=/usr
exec_prefix=${prefix}
libdir=${prefix}/lib/
includedir=${prefix}/include

Name: EGL
Description: EGL
Version: @PKG_VERSION@
Requires:
Libs: -L${libdir} -lEGL
Cflags: -I${includedir}/EGL
    EoF
    sed -i "s/@PKG_VERSION@/$PKG_VERSION/" $SYSROOT_PREFIX/usr/lib/pkgconfig/egl.pc
}
