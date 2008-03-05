#!/bin/sh
##############################################################################
# script to set up build environment. ------------------------- 03-04-2008 MG
#

if [ `dirname $0` != "./build-tools" ] && [ `dirname $0` != "build-tools" ];
then
    echo
    echo "WHOOPS, you must run me from within parent directory of 'build-tools',"
    echo "thus something like './build-tools/`basename $0`' will work."
    echo
    exit 1
fi

if [ "$#" -gt "0" ]; then
    echo "`basename $0`: No options allowed"
    exit 1
fi

current_dir=${PWD}

bsp_path=${current_dir}
toolchain_path=${bsp_path}/toolchains/default
mkcramfsbin=$(which mkcramfs 2>/dev/null)
[ -z "${mkcramfsbin}" -a -x /sbin/mkcramfs ] && mkcramfsbin=/sbin/mkcramfs
[ -z "${mkcramfsbin}" -a -x /sbin/mkfs.cramfs ] && mkcramfsbin=/sbin/mkfs.cramfs

( cd ${bsp_path} ; \
sed \
    -e "s^PROJECT_NAME^`basename ${bsp_path}`^" \
    -e "s^PROJECT_DIR^$(echo "`dirname ${bsp_path}`" | sed 's^/^\/^g')/^" \
    -e "s^TOOLCHAIN_DIR^$(echo "${toolchain_path}" | sed 's^/^\/^g')^" \
    -e "s^MKCRAMFSBIN^$(echo "${mkcramfsbin}" | sed 's^/^\/^g')^" \
build-tools/scripts/project-env > neuros-env )

cp ${bsp_path}/build-tools/scripts/top-makefile ${bsp_path}/Makefile

echo ''
echo 'Neuros build system environment is now successfully setup'
echo 'as "neuros-env", please source the environment by'
echo '"source neuros-env"'
echo ''

exit 0

