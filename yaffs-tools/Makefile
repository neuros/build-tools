##########################################################################
# Description: Makefile for yaffs2image utils
# version: 1.0
##########################################################################
CFLAGS=-O2 -DCONFIG_YAFFS_UTIL
CC=gcc

MKYAFFS2OBJS=mkyaffs2image.o yaffs_packedtags2.o \
           yaffs_tagsvalidity.o yaffs_ecc.o

all: mkyaffs2image

mkyaffs2image: $(MKYAFFS2OBJS)
	$(CC) -o $@ $(MKYAFFS2OBJS)

install:all
	@mkdir -p ${PRJROOT}/images/
	@cp -a mkyaffs2image ${PRJROOT}/images/

clean:
	@rm -f $(MKYAFFS2OBJS) mkyaffs2image
