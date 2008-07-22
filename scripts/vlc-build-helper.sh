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

../build-vlc.sh

echo "####### INSTALLING VLC AND CLEANING CRUFT ########"

make DESTDIR=`pwd`/staging install
find staging -name *.so -exec arm-linux-strip --strip-unneeded \{\} \;
find staging -name *.a | xargs rm -f;
arm-linux-strip --strip-unneeded staging/usr/bin/vlc
rm -rf staging/usr/share

cp -a staging/* ${INSTALL_MOD_PATH}/

