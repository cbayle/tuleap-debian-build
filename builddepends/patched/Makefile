
BUILDDIR=$(HOME)/build
TBLESS=less.js-1.3.3_1.3.3.orig.tar.gz
LESSDIR=less.js-1.3.3
TBRECESS=twitter-recess_1.1.9.orig.tar.xz
RECESSDIR=twitter-recess

default: less recess

less: $(TBLESS) $(BUILDDIR)/src_builddeps/$(TBLESS)

recess: $(TBRECESS) $(BUILDDIR)/src_builddeps/$(TBRECESS)

tarballs: $(TBLESS) $(TBRECESS)

$(TBLESS):
	cd less.js-1.3.3 ; debian/rules get-orig-source
	mv tarballs/$(TBLESS) .
	rmdir tarballs

$(TBRECESS):
	wget http://cdn.debian.net/debian/pool/main/t/twitter-recess/$(TBRECESS)

$(BUILDDIR)/src_builddeps/$(TBLESS):
	cp $(TBLESS) $@
	cd $(BUILDDIR)/builddeps_src ; dpkg-source -b $(CURDIR)/$(LESSDIR)

$(BUILDDIR)/src_builddeps/$(TBRECESS):
	cp $(TBRECESS) $@
	cd $(BUILDDIR)/builddeps_src ; dpkg-source -b $(CURDIR)/$(RECESSDIR)


