set -e

if [ -z "${PRJROOT}" ] ; then 
   echo "Please source neuros-env from your project root before running this script."
   exit 1
fi

install_vlc()
{
 echo "####### INSTALLING VLC AND CLEANING CRUFT ########"

 make DESTDIR=`pwd`/staging install
 find staging -name *.so -exec arm-linux-strip --strip-unneeded \{\} \;
 find staging -name *.a | xargs rm -f;
 arm-linux-strip --strip-unneeded staging/usr/bin/vlc
 rm -rf staging/usr/share

 cp -a staging/* ${INSTALL_MOD_PATH}/
}

clean_vlc()
{
 make clean
}


# If requested, just do the installation to rootfs from previously built code.
# This fails if we didn't build previously.
if [ "$1" == "install" ] ; then
   if [ ! -d vlc/vlc-build-davinci ] ; then
      echo "You need fist to build to be able to install."
      echo "Run this script with no arguments to build and install."
      exit 1
   fi
   cd vlc/vlc-build-davinci
   install_vlc
   exit 0
fi
# If requested, just do the cleanup and exit.
if [ "$1" == "clean" ] ; then
   echo "####### CLEANING VLC BUILD ########"
   rm -rf vlc/vlc-build-davinci
   exit 0
fi

# Otherwise build and install

# Build all the contrib libraries. This will download a lot of stuff the first time,
# so be patient.

echo "####### BUILDING VLC DEPENDENCIES ########"

cd vlc/extras/contrib
if [ ! -f Makefile ] ; then
   echo "++++++++++++++++++++++++++ NO CONFIGURE +++++++++++++++++++++++"
   ./bootstrap arm-linux davinci
   exit 0
fi
make
cd ../..

# Prepare build environment, temp dirst for build, etc.

echo "####### PREPARING VLC BUILD ENV ########"

if [ ! -f configure ] ; then
   ./bootstrap
   exit 0
fi

echo "####### BUILDING VLC ########"

mkdir -p vlc-build-davinci/staging
cd vlc-build-davinci
if [ ! -f Makefile ] ; then
   ../configure-neuros.sh
fi
make
install_vlc

