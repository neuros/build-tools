#!/bin/bash
##############################################################################
#
# Description: helper script to manage Neuros repos
#
##############################################################################

## if you know what you are doing, you can uncomment the following
## and manually set access permission, otherwise system will automatically
## test and set your access permission for you.
#ACCESS=[read-only | read-write]

## cheap ssh access test.
if [ -z ${ACCESS} ] ; then
    echo "checking access permission ..."
    ii=1
    ACCESS=x
    while [ $ii -le 60 -a $ACCESS != read-write ]
    do
	ssh git.neuros.com.cn 'uname -a' >/tmp/neuros-git-access.txt 2>/dev/null &
	sleep 1
	if [ ! -s /tmp/neuros-git-access.txt ] ; then
	    ACCESS=read-only
	else
	    ACCESS=read-write
	fi
	ii=`expr $ii + 1`
    done
fi
echo "Accessing repository in ${ACCESS} mode ..."

## recommended directory tree (showing public repos only)
##
##    osd-repo ----- build-tools
##             |---- kernels
##             |---- toolchains
##             |---- u-boot
##             |---- rootfs
##             |---- ...
##

# Force exit on errors. Let's avoid wasting time if something goes wrong.
set -e

if [ ${ACCESS} = read-only ] ; then
    GIT_PATH_PUB=git://git.neurostechnology.com/git ;
else
    GIT_PATH_PUB=ssh://git@git.neuros.com.cn/git/git-pub/osd20 ;
    GIT_PATH_PRIV=ssh://git@git.neuros.com.cn/git/git-priv/osd20 ;
fi

########################################################################
## if you follow the recommended diretory tree, you don't need to modify
## anything below.
##
PUBLIC_REPO=( \
    "kernels"
    "rootfs" \
    "toolchains" \
    "u-boot"
)

PRIVATE_REPO=( \
    "tievms"
)

ls_pub()
{
    echo ""
    echo "Public repos:"
    echo ""
    for repo in "${PUBLIC_REPO[@]}" ; do
	echo "  ${repo}"
    done
    echo ""
}

ls_priv()
{
    echo ""
    echo "Private repos:"
    echo ""
    for repo in "${PRIVATE_REPO[@]}" ; do
	echo "  ${repo} "
    done
    echo ""
}

clone_pub()
{
    for repo in "${PUBLIC_REPO[@]}" ; do
	if [ -e ${DST_PATH}/${repo} ]
	then
	    echo "${DST_PATH}/${repo} directory already exists, ignored."
	    continue
	fi
	echo
	echo "cloning ${DST_PATH}/${repo} ..."
	git clone ${GIT_PATH_PUB}/${repo} ${DST_PATH}/${repo}
    done
}

clone_priv()
{
    for repo in "${PRIVATE_REPO[@]}" ; do
	if [ -e ${DST_PATH}/${repo} ]
	then
	    echo "${DSP_PATH}/${repo} directory already exists, ignored."
	    continue
	fi
	echo
	echo "cloning ${DST_PATH}/${repo} ..."
	git clone ${GIT_PATH_PRIV}/${repo} ${DST_PATH}/${repo}
    done
}

pull_repo()
{
    cd ${REPO_PATH}
    for repo in "${PUBLIC_REPO[@]}" ; do
	if [ -e ${REPO_PATH}/${repo} ]
	then
	    echo
	    echo "pulling ${REPO_PATH}/${repo} ..."
	    cd ${repo} && git pull && cd ..
	fi
    done

    for repo in "${PRIVATE_REPO[@]}" ; do
	if [ -e ${REPO_PATH}/${repo} ]
	then
	    echo
	    echo "pulling ${REPO_PATH}/${repo} ..."
	    cd ${repo} && git pull && cd ..
	fi
    done
}


help()
{
    echo ""
    echo "Usage:"
    echo ""
    echo "  `basename $0` <cmd> [options]"
    echo ""
    echo "Available commands:"
    echo ""
    echo "  list              : list all repos"
    echo "  clone [dst-path]  : clone all repos to [dst-path]"
    echo "                    : to current path if [dst-path] is not specified"
    echo "  pull [repo-path]  : pull all repos under [repo-path]"
    echo "                    : under current path if [repo-path] is not"
    echo "                    : specified"
    echo ""
    echo "Examples:"
    echo ""
    echo "./`basename $0` list            --- list all available repos"
    echo "./`basename $0` clone           --- clone all repos to current path"
    echo "./`basename $0` clone .         --- clone all repos to current path"
    echo "./`basename $0` clone dst-path  --- clone all repos to dsp-path"
    echo "./`basename $0` pull            --- pull all repos under current path"
    echo "./`basename $0` pull .          --- pull all repos under current path"
    echo "./`basename $0` pull repo-path  --- pull all repos under repo-path"
    echo ""
}


#####main
if [ "$#" -lt "1" ]; then
    help
else
    case $1 in
	"list")
	    ls_pub
	    [ ${ACCESS} = read-write ] && ls_priv
	    ;;
	"clone")
	    if [ -z $2 ] ; then
		DST_PATH=.
	    else
		DST_PATH=$2
	    fi
	    clone_pub
	    [ ${ACCESS} = read-write ] && clone_priv
	    ;;
	"pull")
	    if [ -z $2 ] ; then
		REPO_PATH=.
	    else
		REPO_PATH=$2
	    fi
	    pull_repo
	    ;;
	*)
	    help
	    ;;
    esac
fi
exit 0

