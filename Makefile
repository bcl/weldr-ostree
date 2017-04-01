VERSION = 0.1.0
LIBNAME=libweldr-ostree
VERSION_TAG=$(LIBNAME)-$(VERSION)



# libOSTree
OSTREE_CFLAGS = $(shell pkg-config --cflags ostree-1)
OSTREE_LDFLAGS = $(shell pkg-config --libs ostree-1)




CC = gcc
CFLAGS = -I./src/ $(OSTREE_CFLAGS) -g -Wall -fPIC
LDFLAGS = $(OSTREE_LDFLAGS)
SRCS = $(wildcard ./src/*.c)
HDRS = $(wildcard ./src/*.h)
OBJS = $(patsubst %.c, %.o,$(SRCS))


.c.o:
	${CC} -c ${CFLAGS} $< -o $@

all: $(OBJS) $(HDRS)
	$(CC) -shared -Wl,-soname,$(LIBNAME).so.1 $(LDFLAGS) -o $(LIBNAME).so.$(VERSION) $(OBJS)

release: tag archive

tag:
	git tag -a -s -m "Tag as $(LIBNAME)-$(VERSION)" -f $(LIBNAME)-$(VERSION)

archive:
	@git archive --format=tar --prefix=$(PKGNAME)-$(VERSION)/ $(TAG) > $(PKGNAME)-$(VERSION).tar
	@xz $(PKGNAME)-$(VERSION).tar
	@echo "The archive is in $(PKGNAME)-$(VERSION).tar.xz"


clean:
	@rm -f $(OBJS) $(LIBNAME).so.$(VERSION)

.PHONY: check clean install tag archive local test
