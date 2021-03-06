#!/bin/bash
##############################################################################
#
# Description: helper script to manage Neuros repos
#
##############################################################################

## If you know what you are doing, you can uncomment the following
## and manually set access permission, or set the ACCESS env variable,
## otherwise system will automatically test and set access permission for you.
## Valid access values are "read-only" or "read-write", default "read-only".
#ACCESS=read-write

## recommended directory tree (showing public repos only)
##
##    osd-repo ----- build-tools
##             |---- linux-davinci-2.6
##             |---- toolchains
##             |---- u-boot
##             |---- rootfs
##             |---- ...
##

# Force exit on errors. Let's avoid wasting time if something goes wrong.
set -e

########################################################################
## if you follow the recommended diretory tree, you don't need to modify
## anything below.
##
PUBLIC_REPO=( \
    "linux-davinci-2.6" \
    "rootfs" \
    "busybox" \
    "ti-uart-boot" \
    "toolchains" \
    "u-boot" \
    "upk" \
    "external-components" \
    "binary-components" \
    "qt-plugins" \
)

PUBLIC_APP_REPO=( \
    "app-demos" \
    "app-nwm" \
    "app-photoalbum" \
    "app-scheduler" \
    "app-vplayer" \
    "app-mainmenu" \
    "app-filemanager" \
)

PUBLIC_LIB_REPO=( \
    "lib-widgets" \
    "lib-nativeutils" \
    "lib-gui" \
)

APP_DIR=applications
LIB_DIR=libraries
VLC_REPO=git://git.videolan.org/vlc.git
VLC_NEUROS_BRANCH=0.8.6-neuros

PRIVATE_REPO=( \
    "tievms" \
    "msp430" \
    "mspflash" \
    "neuros-rtc" \
    "production" \
    "ticel"
)

ls_pub()
{
    echo ""
    echo "Public repos:"
    echo ""
    for repo in "${PUBLIC_REPO[@]}" ; do
	echo "  ${repo}"
    done
    for repo in "${PUBLIC_APP_REPO[@]}" ; do
	echo "  ${APP_DIR}/${repo}"
    done
    for repo in "${PUBLIC_LIB_REPO[@]}" ; do
	echo "  ${LIB_DIR}/${repo}"
    done
    echo "Additional code from VLC repo:"
    echo ${VLC_REPO} " branch " ${VLC_NEUROS_BRANCH}
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
	git clone ${GIT_PATH_PUB}/${repo}.git ${DST_PATH}/${repo}
    done

    if [ ! -e ${APP_DIR} ]
    then
	mkdir ${APP_DIR}
    fi
    for repo in "${PUBLIC_APP_REPO[@]}" ; do
	if [ -e ${APP_DST_PATH}/${repo} ]
	then
	    echo "${APP_DST_PATH}/${repo} directory already exists, ignored."
	    continue
	fi
	echo
	echo "cloning ${DST_PATH}/${repo} ..."
	git clone ${GIT_PATH_PUB}/${repo}.git ${APP_DST_PATH}/${repo}
    done

    if [ ! -e ${LIB_DIR} ]
    then
	mkdir ${LIB_DIR}
    fi
    for repo in "${PUBLIC_LIB_REPO[@]}" ; do
	if [ -e ${LIB_DST_PATH}/${repo} ]
	then
	    echo "${LIB_DST_PATH}/${repo} directory already exists, ignored."
	    continue
	fi
	echo
	echo "cloning ${DST_PATH}/${repo} ..."
	git clone ${GIT_PATH_PUB}/${repo}.git ${LIB_DST_PATH}/${repo}
    done
    
    for repo in "${PUBLIC_REPO[@]}" ; do
	if [ -e ${DST_PATH}/${repo} ]
	then
	    echo "${DST_PATH}/${repo} directory already exists, ignored."
	    continue
	fi
	echo
	echo "cloning ${DST_PATH}/${repo} ..."
	git clone ${GIT_PATH_PUB}/${repo}.git ${DST_PATH}/${repo}
    done

    repo=vlc
    if [ -e ${DST_PATH}/${repo} ] ; then
       echo "${DST_PATH}/${repo} directory already exists, ignored."
    else
        echo "cloning " ${VLC_REPO} " and checking out branch " ${VLC_NEUROS_BRANCH} "..."
	git clone ${VLC_REPO} ${DST_PATH}/${repo}
	cd ${repo} && git checkout -b ${VLC_NEUROS_BRANCH} origin/${VLC_NEUROS_BRANCH} && git config branch.${VLC_NEUROS_BRANCH}.rebase true && cd ..
    fi
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
	git clone ${GIT_PATH_PRIV}/${repo}.git ${DST_PATH}/${repo}
    done
}

pull_repo()
{
    set +e
    cd ${REPO_PATH}
    for repo in "${PUBLIC_REPO[@]}" ; do
	if [ -e ${repo} ]
	then
	    echo
	    echo "pulling ${REPO_PATH}/${repo} ..."
	    cd ${repo} && git pull --rebase
	    cd ..
	fi
    done

    for repo in "${PRIVATE_REPO[@]}" ; do
	if [ -e ${repo} ]
	then
	    echo
	    echo "pulling ${REPO_PATH}/${repo} ..."
	    cd ${repo} && git pull --rebase
	    cd ..
	fi
    done
    if [ -e ${APP_REPO_PATH} ]
    then
	cd ${APP_REPO_PATH}
	for repo in "${PUBLIC_APP_REPO[@]}" ; do
	    if [ -e ${repo} ]
	    then
		echo
		echo "pulling ${APP_REPO_PATH}/${repo} ..."
		cd ${repo} && git pull --rebase
		cd ..
	    fi
	done
	cd ..
    fi
    if [ -e ${LIB_REPO_PATH} ]
    then
	cd ${LIB_REPO_PATH}
	for repo in "${PUBLIC_LIB_REPO[@]}" ; do
	    if [ -e ${repo} ]
	    then
		echo
		echo "pulling ${LIB_REPO_PATH}/${repo} ..."
		cd ${repo} && git pull --rebase
		cd ..
	    fi
	done
	cd ..
    fi

    echo
    echo "pulling ${LIB_REPO_PATH}/vlc ..."
    cd vlc && git pull --rebase

    set -e
}

status_repo()
{
    set +e
    cd ${REPO_PATH}
    for repo in "${PUBLIC_REPO[@]}" ; do
	if [ -e ${repo} ]
	then
	    echo
	    echo "status of ${REPO_PATH}/${repo} ..."
	    cd ${repo} && git status
	    cd ..
	fi
    done
    for repo in "${PRIVATE_REPO[@]}" ; do
	if [ -e ${repo} ]
	then
	    echo
	    echo "status of ${REPO_PATH}/${repo} ..."
	    cd ${repo} && git status
	    cd ..
	fi
    done
    if [ -e ${APP_REPO_PATH} ]
    then
	cd ${APP_REPO_PATH}
	for repo in "${PUBLIC_APP_REPO[@]}" ; do
	    if [ -e ${repo} ]
	    then
		echo
		echo "status of ${APP_REPO_PATH}/${repo} ..."
		cd ${repo} && git status
		cd ..
	    fi
	done
	cd ..
    fi
    
    echo
    echo "status of ${APP_REPO_PATH}/vlc ..."
    cd vlc && git status
    
    set -e
}

pristine_repo()
{
    set +e
    cd ${REPO_PATH}
    for repo in "${PUBLIC_REPO[@]}" ; do
	if [ -e ${repo} ]
	then
	    echo
	    echo "cleansing ${REPO_PATH}/${repo} ..."
	    cd ${repo} && git clean -dfx && git reset --hard HEAD
	    cd ..
	fi
    done

    for repo in "${PRIVATE_REPO[@]}" ; do
	if [ -e ${repo} ]
	then
	    echo
	    echo "cleansing ${REPO_PATH}/${repo} ..."
	    cd ${repo} && git clean -dfx && git reset --hard HEAD
	    cd ..
	fi
    done
    if [ -e ${APP_REPO_PATH} ]
    then
	cd ${APP_REPO_PATH}
	for repo in "${PUBLIC_APP_REPO[@]}" ; do
	    if [ -e ${repo} ]
	    then
		echo
		echo "cleansing ${REPO_PATH}/${repo} ..."
	    	cd ${repo} && git clean -dfx && git reset --hard HEAD
		cd ..
	    fi
	done
	cd ..
    fi
    if [ -e ${LIB_REPO_PATH} ]
    then
	cd ${LIB_REPO_PATH}
	for repo in "${PUBLIC_LIB_REPO[@]}" ; do
	    if [ -e ${repo} ]
	    then
		echo
		echo "cleansing ${REPO_PATH}/${repo} ..."
	    	cd ${repo} && git clean -dfx && git reset --hard HEAD
		cd ..
	    fi
	done
	cd ..
    fi

    echo
    echo "cleansing ${LIB_REPO_PATH}/vlc ..."
    cd vlc && git clean -fxd && git reset --hard HEAD

    set -e
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
    echo "  status [repo-path]: check all repos status under [repo-path]"
    echo "                    : under current path if [repo-path] is not"
    echo "                    : specified"
    echo "  pristine [repo-path] : clean everything from [repo-path] that was"
    echo "                    : not originally in git, then revert all files"
    echo "                    : that are not committed to git HEAD."
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
    echo "./`basename $0` status          --- status of all repos under current path"
    echo "./`basename $0` status .        --- status of all repos under current path"
    echo "./`basename $0` status repo-path--- status of all repos under repo-path"
    echo ""
}

#####main
if [ "$#" -lt "1" ]; then
    help
else
	# Set up repositories based on the value of env.
	# It is set only on the boxes of developers with commit access.
	ACCESS="read-only"
	if [ "${NEUROS_GIT_ACCESS}" == "rw" ] ; then
		ACCESS="read-write"
	fi

	if [ "${ACCESS}" = "read-write" ] ; then
		GIT_PATH_PUB=git@github.com:neuros ;
		GIT_PATH_PRIV=git@github.com:neuros ;
	else
		GIT_PATH_PUB=git://github.com/neuros ;
	fi
	echo "Accessing reposiories as: ${ACCESS}"

	case $1 in
	"list")
	    ls_pub
	    [ ${ACCESS} = read-write ] && ls_priv
	    ;;
	"clone")
	    if [ -z $2 ] ; then
		DST_PATH=.
		APP_DST_PATH=./${APP_DIR}
		LIB_DST_PATH=./${LIB_DIR}
	    else
		DST_PATH=$2	
	    fi
	    clone_pub
	    [ ${ACCESS} = read-write ] && clone_priv
	    ;;
	"pull")
	    if [ -z $2 ] ; then
		REPO_PATH=.
		APP_REPO_PATH=./${APP_DIR}
		LIB_REPO_PATH=./${LIB_DIR}
	    else
		REPO_PATH=$2
	    fi
	    pull_repo
	    ;;
	"status")
	    if [ -z $2 ] ; then
		REPO_PATH=.
		APP_REPO_PATH=./${APP_DIR}
		LIB_REPO_PATH=./${LIB_DIR}
	    else
		REPO_PATH=$2
	    fi
	    status_repo
	    ;;
	"pristine")
	    if [ -z $2 ] ; then
		REPO_PATH=.
		APP_REPO_PATH=./${APP_DIR}
		LIB_REPO_PATH=./${LIB_DIR}
	    else
		REPO_PATH=$2
	    fi
	    pristine_repo
	    ;;
	*)
	    help
	    ;;
    esac
fi
exit 0

