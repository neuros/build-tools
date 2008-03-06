#!/bin/bash
##############################################################################
#
# Description: helper script to clone Neuros repos
#
##############################################################################


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

# public readonly clone
#GIT_PATH_PUB=git://git.neurostechnology.com/git/osd20

# writable clone
GIT_PATH_PUB=ssh://git@git.neuros.com.cn/git/git-pub/osd20

## evil private stuff
GIT_PATH_PRIV=ssh://git@git.neuros.com.cn/git/git-priv/osd20


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
	echo ${repo}
    done
    echo ""
}

ls_priv()
{
    echo ""
    echo "Private repos:"
    echo ""
    for repo in "${PRIVATE_REPO[@]}" ; do
	echo ${repo}
    done
    echo ""
}

clone_pub()
{
    for repo in "${PUBLIC_REPO[@]}" ; do
	if [ -e ${REPO_ROOT}/${repo} ]
	then
	    echo
	    echo "${REPO_ROOT}/${repo} directory already exists, ignored."
	    echo
	    continue
	fi

	git clone ${GIT_PATH_PUB}/${repo} ${repo}
    done
}

clone_priv()
{
    for repo in "${PRIVATE_REPO[@]}" ; do
	if [ -e ${REPO_ROOT}/${repo} ]
	then
	    echo
	    echo "${REPO_ROOT}/${repo} directory already exists, ignored."
	    echo
	    continue
	fi

	git clone ${GIT_PATH_PRIV}/${repo} ${repo}
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
    echo "  l                    : list all repos"
    echo "  c [repo] [dst-path]  : clone [repo] to [dst-path]"
    echo "                       : clone all to current path if no options specified"
    echo ""
    echo "Examples:"
    echo ""
    echo "./`basename $0` c            --- clone all repos to current path"
    echo "./`basename $0` c repo path  --- clone repo to path [NOTWORKING]"
    echo ""
}


#####main
if [ "$#" -lt "1" ]; then
    help
else
    case $1 in
	"l")
	    ls_pub
	    ls_priv
	    ;;
	"c")
	    clone_pub
	    clone_priv
	    ;;
	*)
	    help
	    ;;
    esac
fi
exit 0

