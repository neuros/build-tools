set -e

echo "### OpenEmbedded bootstrap tool for Neuros OSD2 development."

if [ -z "$1" ] ; then
	echo ""
	echo "This tool will set up OpenEmbedded in a way that allows you to rebuild entire OSD2 software stack." \
	     "Please select one of the following scenarios and pass it as command line option to this script:"
	echo ""
	echo "* distribution: just create packages for redistribution."
	echo "- core-developer: rebuild from your own souces on which you hack."
	echo "- app-developer: setup to build applications but not to hack the base system."
	echo "- toolchiain: you just want to regenerate the pre-built toolchain(s)."
	echo ""
	echo "(please note that at the moment scenarios marked with - are not yet supported yet)"
	exit 0
else
	if [ "$1" != "distribution" ] ; then
		echo "Sorry, this scenario (\"$1\") is not supported yet."
		exit 0
	fi
fi


echo -n -e "\n# Checking necessary tools"

[ -n "$SVNPATH" ] || which svn > /dev/null  || NOSVN=1
[ -n "$GITPATH" ] || which git > /dev/null || NOGIT=1
[ -n "$PYTHONPATH" ] || which python > /dev/null || NOPYTHON=1

if [ "$NOSVN" = "1" -o "$NOGIT" = "1" -o "$NOPYTHON" = "1" ] ; then
	echo "\nYou are missing the following tools on your host:"
	[ -z "$NOSVN" ] || echo "* subversion (also known as svn) [override with SVNPATH]"
	[ -z "$NOGIT" ] || echo "* git (also known as git-core) [override with GITPATH]"
	[ -z "$NOPYTHON" ] || echo "* python [override with PYTHONPATH]"
	echo "Please install them on your host and then try again."
	echo "If you are sure you have them installed, you can set the environment" \
	     "variables listed in square brackets above to the full path of the tool" \
	     "before you try again."
	exit 1
else
	echo ": ok"
fi

THISDIR=$(dirname $0 | xargs -- readlink -f)

if [ -z "$OEBASE" ] ; then
	if [ -z "$PRJROOT" ] ; then
		OEBASE=$(pwd)
	else
		OEBASE=$PRJROOT/oe
		mkdir -p $OEBASE
	fi
fi
echo -e "\n# Using the following base directory [override with OEBASE or PRJROOT]:"
echo $OEBASE


if [ -z "$BITBAKE" ] ; then
	echo -e "\n# Fetching bitbake from bitbake's SVN. [override with BITBAKE]:"
	if [ -d $OEBASE/bitbake ] ; then
		echo "# Already fetched, trying to simply update:"
		svn up $OEBASE/bitbake
	else
		svn co svn://svn.berlios.de/bitbake/branches/bitbake-1.8/ $OEBASE/bitbake
	fi
	BITBAKE=$OEBASE/bitbake/bin/bitbake
else
	echo -e "\n# Using user-defined bitbake in:"
	echo $BITBAKE
fi


OEDIR="org.openembedded.dev"
if [ -z "$OEPATH" ] ; then
	echo -e "\n# Fetching OpenEmbedded metadata from OE's git. [override with OEPATH]."
	if [ -d $OEBASE/$OEDIR ] ; then
		echo "# Already fetched, trying to simply update:"
		pushd $OEBASE/$OEDIR > /dev/null && git pull && popd > /dev/null
	else
		echo "# (this may take some time, and should display a progress meter):"
		git clone git://git.openembedded.net/org.openembedded.dev.git $OEBASE/$OEDIR
	fi
	OEPATH=$OEBASE/$OEDIR
else
	echo -e "\n# Using user-defined OpenEmbedded metadata in:"
	echo $OEPATH
fi


echo -e "\n# Preparing OE local config, build dirs, recipes overlay:"
mkdir -p $OEBASE/build/conf/

sed \
-e "s^##oepath##^$OEPATH^" \
-e "s^##oebase##^$OEBASE^" \
-e "s^##localpackages##^$THISDIR^" \
    $(dirname $0)/local.conf.base > $(dirname $0)/local.conf.base.tmp

UPDCONF="1"
if [ -f $OEBASE/build/conf/local.conf ] ; then
	diff $(dirname $0)/local.conf.base.tmp $OEBASE/build/conf/local.conf > /dev/null
	if [ $? = 0 ] ; then
		rm `dirname $0`/local.conf.base.tmp
		UPDCONF="0"
		echo "New file is same, not updating to preserve bbitbake cache."
	fi
fi

if [ "$UPDCONF" = "1" ] ; then
	mv `dirname $0`/local.conf.base.tmp $OEBASE/build/conf/local.conf
	echo "Ok. Generated file:"
	echo $OEBASE/build/conf/local.conf
fi

echo -e "\n# Preparing source environment:"
sed \
-e "s^##oepath##^$OEPATH^" \
-e "s^##oebase##^$OEBASE^" \
-e "s^##bitbake##^$BITBAKE^" \
    $THISDIR/env.base > $OEBASE/oe-env
echo "Ok."

echo " "
echo -e "\n# Bootstrap complete."
echo -e "Before being able to work with OE you will need to run:\n"
echo "   source $OEBASE/oe-env"
echo -e "\nYou need to do this every time you open" \
     "a new shell where you want to work with OE for the Neuros OSD2."






