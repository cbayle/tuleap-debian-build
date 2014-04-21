
BUILDDIR=$(HOME)/build
TBLESS=less.js-1.3.3_1.3.3.orig.tar.gz
LESSDIR=less.js-1.3.3
TBRECESS=twitter-recess_1.1.9.orig.tar.xz
RECESSDIR=twitter-recess
TBMW=mediawiki_1.22.5+dfsg.orig.tar.xz
TBMWDEB=mediawiki_1.22.5+dfsg-1.debian.tar.gz
TBMWDSC=mediawiki_1.22.5+dfsg-1.dsc

default: depends less recess mediawiki
	@#debclean

less: $(TBLESS) $(BUILDDIR)/src_builddeps/$(TBLESS)

recess: $(TBRECESS) $(BUILDDIR)/src_builddeps/$(TBRECESS)

mediawiki: $(BUILDDIR)/src_builddeps/$(TBMW)

tarballs: $(TBLESS) $(TBRECESS)

$(TBLESS):
	cd $(LESSDIR) && debian/rules get-orig-source
	mv tarballs/$(TBLESS) .
	rmdir tarballs

$(TBRECESS):
	wget http://cdn.debian.net/debian/pool/main/t/twitter-recess/$(TBRECESS)

$(BUILDDIR)/src_builddeps/$(TBLESS):
	cp $(TBLESS) $@
	cd $(BUILDDIR)/src_builddeps && dpkg-source -b $(CURDIR)/$(LESSDIR)
	cd $(CURDIR)/$(LESSDIR) ; fakeroot debian/rules clean

$(BUILDDIR)/src_builddeps/$(TBRECESS):
	cp $(TBRECESS) $@
	cd $(BUILDDIR)/src_builddeps && dpkg-source -b $(CURDIR)/$(RECESSDIR)
	cd $(CURDIR)/$(RECESSDIR) ; fakeroot debian/rules clean

$(BUILDDIR)/src_builddeps/$(TBMW):
	cp $(TBMW) $(TBMWDEB) $(TBMWDSC) $(BUILDDIR)/src_builddeps/

depends: /usr/bin/dh_buildinfo /usr/bin/uglifyjs

/usr/bin/dh_buildinfo:
	sudo apt-get -y install dh-buildinfo

/usr/bin/uglifyjs:
	sudo apt-get -y install node-uglify
