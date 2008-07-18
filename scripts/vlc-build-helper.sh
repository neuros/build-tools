if [ -z "${PRJROOT}" ] ; then 
   echo "Please source neuros-env from your project root before running this script."
   exit 1
fi

# Build all the contrib libraries. This will download a lot of stuff the first time,
# so be patient.

echo "####### BUILDING VLC DEPENDENCIES ########"

 cd vlc/extras/contrib
./bootstrap arm-linux davinci
make
 cd ../..

# Prepare build environment, temp dirst for build, etc.

echo "####### PREPARING VLC BUILD ENV ########"

./bootstrap
 mkdir -p vlc-build-davinci/staging
 cd vlc-build-davinci

echo "####### BUILDING VLC ########"

# All this stuff is curbed from vlc/build-vlc.sh, but we don't want to use that since it 
# install in the rootfs with a lot of cruft, so for now we copy this, install into a staging area,
# clean the cruft and then install to rootfs.

# Please notice that the CFLAGS and CXXFLAGS are changed so that they point to <kernel>/include instead
# of <kernel>/usr/include. This was done so we don't need to run headers_install during the build, which
# is useless since the headers are there already anyway, just in a different dir.
CFLAGS="-I$KNL_INSTALL_DIR/include -I$TOOLCHAIN/target/usr/include -msoft-float" \
CXXLAGS="-I$KNL_INSTALL_DIR/include -I$TOOLCHAIN/target/usr/include -msoft-float" \
LDFLAGS="-Wl,-z,defs" \
PKG_CONFIG_LIBDIR=${PRJROOT}/vlc/extras/contrib/lib/pkgconfig \
../configure \
	--prefix=/usr \
	--enable-debug --enable-maintainer-mode \
	--host=arm-linux \
	--with-contrib \
	--disable-dvdread \
	--disable-wxwidgets --disable-skins2 \
	--disable-libmpeg2 --disable-dvdnav \
	--disable-x11 --disable-xvideo --disable-opengl --disable-glx \
	--disable-screen --disable-caca \
	--disable-httpd --disable-vlm \
	--disable-fb \
	--disable-freetype --disable-sdl --enable-png \
	--enable-live555 --enable-tremor \
	--disable-mod --disable-fb \
	--enable-davinci --enable-davincifb --enable-davinciresizer \
	--enable-v4l2 --enable-aa --enable-wma --enable-faad \
	--disable-dbus \
	$*

echo "####### BUILDING VLC ########"

../compile

echo "####### INSTALLING VLC AND CLEANING CRUFT ########"

make DESTDIR=`pwd`/staging install
find staging -name *.so -exec arm-linux-strip --strip-unneeded \{\} \;
arm-linux-strip --strip-unneeded staging/usr/bin/vlc
rm -rf staging/usr/share

cp -a staging/* ${INSTALL_MOD_PATH}/