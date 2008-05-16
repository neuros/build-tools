#!/bin/bash
##############################################################################
#
# Description: Script to create Target Device Nodes.
#
##############################################################################

##FIXME: not all of the nodes are needed, in fact, majority of the nodes
##       are not needed because udev.

DEVICES=( \
    "#Block Devices" \
    "ram0            b   1   0" \
    "ram1            b   1   1" \
    "fd0             b   2   0" \
    "hda             b   3   0" \
    "hda1            b   3   1" \
    "hda2            b   3   2" \
    "hda3            b   3   3" \
    "hda4            b   3   4" \
    "hdb             b   3  64" \
    "hdb1            b   3  65" \
    "hdb2            b   3  66" \
    "hdb3            b   3  67" \
    "hdb4            b   3  68" \
    "sda             b   8   0" \
    "sda1            b   8   1" \
    "sda2            b   8   2" \
    "sda3            b   8   3" \
    "sda4            b   8   4" \
    "sda5            b   8   5" \
    "sda6            b   8   6" \
    "sda7            b   8   7" \
    "sda8            b   8   8" \
    "sdb             b   8  16" \
    "sdb1            b   8  17" \
    "sdb2            b   8  18" \
    "sdb3            b   8  19" \
    "sdb4            b   8  20" \
    "sdb5            b   8  21" \
    "sdb6            b   8  22" \
    "sdb7            b   8  23" \
    "sdb8            b   8  24" \
    "hdc             b  22   0" \
    "hdc1            b  22   1" \
    "hdc2            b  22   2" \
    "hdc3            b  22   3" \
    "hdc4            b  22   4" \
    "hdd             b  22  64" \
    "hdd1            b  22  65" \
    "hdd2            b  22  66" \
    "hdd3            b  22  67" \
    "hdd4            b  22  68" \
    "mmca            b  28   0" \
    "mmca1           b  28   1" \
    "mtd0            c  90   0" \
    "mtd0r           c  90   1" \
    "mtd1            c  90   2" \
    "mtd1r           c  90   3" \
    "mtd2            c  90   4" \
    "mtd2r           c  90   5" \
    "mtd3            c  90   6" \
    "mtd3r           c  90   7" \
    "mtdblock0       b  31   0" \
    "mtdblock1       b  31   1" \
    "mtdblock2       b  31   2" \
    "mtdblock3       b  31   3" \
    "mtdblock4       b  31   4" \
    "mtdblock5       b  31   5" \
    "mtdblock6       b  31   6" \
    "mtdblock7       b  31   7" \
    "mtd4            b  31   4" \
    "mtd5            b  31   5" \
    "mtd6            b  31   6" \
    "mtd7            b  31   7" \
    "" \
    "mmcblk0	     b 32   0" \
    "mmcblk0p1       b 32   1" \
    "mmcblk0p2       b 32   2" \
    "mmcblk0p3       b 32   3" \
    "mmcblk1	     b 32   8" \
    "mmcblk1p1	     b 32   9" \
    "mmcblk1p2	     b 32  10" \
    "mmcblk1p3	     b 32  11" \
    "mem_stkblk0     b 33   0" \
    "mem_stkblk0p1   b 33   1" \
    "mem_stkblk0p2   b 33   2" \
    "mem_stkblk0p3   b 33   3" \
    "mem_stkblk1     b 33   8" \
    "mem_stkblk1p1   b 33   9" \
    "mem_stkblk1p2   b 33  10" \
    "mem_stkblk1p3   b 33  11" \

    "#Character Devices" \
    "mem             c   1   1" \
    "null            c   1   3" \
    "zero            c   1   5" \
    "tty0            c   4   0" \
    "tty1            c   4   1" \
    "tty2            c   4   2" \
    "tty3            c   4   3" \
    "tty4            c   4   4" \
    "tty5            c   4   5" \
    "tty6            c   4   6" \
    "tty7            c   4   7" \
    "ttyS0           c   4  64" \
    "ttyS1           c   4  65" \
    "ttyS2           c   4  66" \
    "ttyS3           c   4  67" \
    "tty             c   5   0" \
    "console         c   5   1" \
    "ptmx            c   5   2" \
    "vcs0            c   7   0" \
    "vcs1            c   7   1" \
    "vcs2            c   7   2" \
    "vcs3            c   7   3" \
    "vcs4            c   7   4" \
    "vcs5            c   7   5" \
    "vcs6            c   7   6" \
    "vcs7            c   7   7" \
    "vcs8            c   7   8" \
    "vcs9            c   7   9" \
    ""\
    "softdog         c  10 130" \
    "" \
    "fb0             c  29   0" \
    "" \
    "imanage         c  76   0" \
    "" \
    "iencode         c  77   0" \
    "vencode0        c  77   1" \
    "vencode1        c  77   2" \
    "vencode2        c  77   3" \
    "vencode3        c  77   4" \
    "vencode4        c  77   5" \
    "vencode5        c  77   6" \
    "vencode6        c  77   7" \
    "vencode7        c  77   8" \
    "aencode0        c  77   9" \
    "aencode1        c  77  10" \
    "aencode2        c  77  11" \
    "aencode3        c  77  12" \
    "aencode4        c  77  13" \
    "aencode5        c  77  14" \
    "aencode6        c  77  15" \
    "aencode7        c  77  16" \
    "imgenc          c  77  32" \
    "" \
    "idecode         c  78   0" \
    "vdecode0        c  78   1" \
    "vdecode1        c  78   2" \
    "vdecode2        c  78   3" \
    "vdecode3        c  78   4" \
    "vdecode4        c  78   5" \
    "vdecode5        c  78   6" \
    "vdecode6        c  78   7" \
    "vdecode7        c  78   8" \
    "adecode0        c  78   9" \
    "adecode1        c  78  10" \
    "adecode2        c  78  11" \
    "adecode3        c  78  12" \
    "adecode4        c  78  13" \
    "adecode5        c  78  14" \
    "adecode6        c  78  15" \
    "adecode7        c  78  16" \
    "imgd0           c  78  32" \
    "dtmfdecode      c  78 100" \
    "subtldecode     c  78 105" \
    "" \
    "icap            c  81   0" \
    "icapture        c  81   0" \
    "windisp         c  81 119" \
    "irender         c  81 121" \
    "" \
    "it_led            c 100   0" \
    "" \
    "aic23		c 101 0" \
    "" \
    "tvp5150           c 102   0" \
    "" \
    "xlock             c 103   0" \
    "" \
    "neuros_generic    c 104   0" \
    "" \
    "neuros_ir         c 110   0" \
    "" \
    "neuros_ir_blaster c 111   0" \
    "" \
    "neuros_rtc        c 112   0" \
    "" \
    "itwdog            c 123   0" \
    "" \
    "itlanc            c 125   0" \
    "" \
    "gio0              c 125   0" \
    "gio1              c 125   1" \
    "gio2              c 125   2" \
    "gio3              c 125   3" \
    "gio4              c 125   4" \
    "gio5              c 125   5" \
    "gio6              c 125   6" \
    "gio7              c 125   7" \
    "gio8              c 125   8" \
    "gio9              c 125   9" \
    "gio10             c 125  10" \
    "gio11             c 125  11" \
    "gio12             c 125  12" \
    "gio13             c 125  13" \
    "gio14             c 125  14" \
    "gio15             c 125  15" \
    "gio16             c 125  16" \
    "gio17             c 125  17" \
    "gio18             c 125  18" \
    "gio19             c 125  19" \
    "gio20             c 125  20" \
    "gio21             c 125  21" \
    "gio22             c 125  22" \
    "gio23             c 125  23" \
    "gio24             c 125  24" \
    "gio25             c 125  25" \
    "gio26             c 125  26" \
    "gio27             c 125  27" \
    "gio28             c 125  28" \
    "gio29             c 125  29" \
    "gio30             c 125  30" \
    "gio31             c 125  31" \
    "" \
    "ccdc              c 126   0" \
    "" \
    "i2c0              c 127   0" \
    "i2c1              c 127   1" \
    "i2c2              c 127   2" \
    "i2c3              c 127   3" \
    "i2c4              c 127   4" \
    "i2c5              c 127   5" \
    "i2c6              c 127   6" \
    "i2c7              c 127   7" \
    "i2c8              c 127   8" \
    "i2c9              c 127   9" \
    "i2c10             c 127  10" \
    "i2c11             c 127  11" \
    "i2c12             c 127  12" \
    "i2c13             c 127  13" \
    "i2c14             c 127  14" \
    "i2c15             c 127  15" \
    "i2c16             c 127  16" \
    "i2c17             c 127  17" \
    "i2c18             c 127  18" \
    "i2c19             c 127  19" \
    "i2c20             c 127  20" \
    "i2c21             c 127  21" \
    "i2c22             c 127  22" \
    "i2c23             c 127  23" \
    "i2c24             c 127  24" \
    "i2c25             c 127  25" \
    "i2c26             c 127  26" \
    "i2c27             c 127  27" \
    "i2c28             c 127  28" \
    "i2c29             c 127  29" \
    "i2c30             c 127  30" \
    "i2c31             c 127  31" \
    "" \
    "itnav             c 139   0" \
    "itnavsw           c 139   0" \
    "" \
    "watchdog          c 240   0" \
    "" \
    "pflash            c 244   0" \
    "" \
    "memory            c 254   0" \
    "fuse              c 10  229" \
    "random            c 1     8" \
    "urandom           c 1     9" \
)

if [ "$(whoami)" != "root" ]
then
    echo "You must be root to run this script."
    exit 1
fi

function show_usage
{
    echo
    echo "${0} Creates Target Device Nodes."
    echo
    echo "USAGE:"
    echo -e "\t${0} --devdir=<devdir>"
    echo
    echo "--devdir=<devdir>"
    echo
    echo -e "\tLocation of Target device directory. This directory must exist"
    echo -e "\tprior to running this script."
    echo
}

#Process Command Line Options.
CMD_LINE="${*}"
DEVDIR=
for OPT in ${CMD_LINE} ; do
    case ${OPT} in
        --devdir=*)
            DEVDIR=$(echo ${OPT} | sed -n -e '1s/--devdir=//p')
            continue
            ;;
        *)
            echo "Invalid Command Line Option '${OPT}'."
            show_usage
            exit 1
            ;;
    esac
done

if [ "${DEVDIR}x" = "x" ]
then
    show_usage
    exit 1
fi

if [ ! -d ${DEVDIR}/ ]
then
    mkdir -p ${DEVDIR}/
    chmod 0755 ${DEVDIR}/
fi

if [ ! -d ${DEVDIR}/ ]
then
    echo
    echo "ERROR Creating '${DEVDIR}'."
    echo
    exit 1
fi

echo
echo "Creating Target Device Nodes in '${DEVDIR}'."
echo

DEV_NONSPACE=
DEV_COMMENT=
DEV_FNAME=
DEV_TYPE=
DEV_MAJ=
DEV_MIN=

for DEV in "${DEVICES[@]}" ; do
    DEV_COMMENT=$(echo ${DEV} | sed -n -e '/^\s*#/p')
    if [ "${DEV_COMMENT}x" != "x" ]
    then
        continue
    fi
    if [ "${DEV}x" = "x" ]
    then
        continue
    fi
    set $DEV
    DEV_FNAME=$1
    DEV_TYPE=$2
    DEV_MAJ=$3
    DEV_MIN=$4

    if [ "${DEV_FNAME}x" = "x" -o "${DEV_TYPE}x" = "x" -o \
        "${DEV_MAJ}x" = "x" -o "${DEV_MIN}x" = "x" ]
    then
        echo "ERROR '${DEV}' is not a valid Device Definition. Skipping."
        continue
    fi
    if [ -e ${DEVDIR}/${DEV_FNAME} ]
    then
        rm -f ${DEVDIR}/${DEV_FNAME}
    fi
    mknod ${DEVDIR}/${DEV_FNAME} ${DEV_TYPE} ${DEV_MAJ} ${DEV_MIN}
done

ln -sf ../proc/self/fd ${DEVDIR}/fd
ln -sf fd/0 ${DEVDIR}/stdin
ln -sf fd/1 ${DEVDIR}/stdout
ln -sf fd/2 ${DEVDIR}/stderr
chmod 0666 ${DEVDIR}/tty*
