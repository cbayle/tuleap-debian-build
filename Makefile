# List of package to build
PKGLIST=tuleap forgeupgrade php-mail-mbox jpgraph-tuleap mailman-tuleap viewvc-tuleap openfire-tuleap-plugins openfire
# You can use the following as a make argument make BUILDDIR=/some/place
BUILDDIR=$(HOME)/build
# This will make a list of build/tuleap build/...
PKGBUILDDIR=$(patsubst %,$(BUILDDIR)/%,$(PKGLIST))

PBUILDERRESULTDIR=$(HOME)/pbuilder_result
REPODIR=/var/www/localrepo
DISTRO=debian
DISTRIB=wheezy
ARCH:=$(shell dpkg-architecture -qDEB_BUILD_ARCH 2>/dev/null)
ASKPASS=--ask-passphrase
ASKPASS=

default: depends $(PKGLIST) buildsrc buildbin fillrepo

buildsrc: $(BUILDDIR) $(BUILDDIR)/src $(PKGBUILDDIR)

buildbin: $(PBUILDERRESULTDIR)
	@for dscfile in $(shell ls $(BUILDDIR)/src/*.dsc); do \
	[ -f $(PBUILDERRESULTDIR)/`basename $$dscfile` ] || \
	sudo pbuilder --build --buildresult $(PBUILDERRESULTDIR) $$dscfile; \
	done

fillrepo: preparerepo $(REPODIR)
	@for changefile in $(shell ls $(PBUILDERRESULTDIR)/*.changes); do \
	[ -f $(REPODIR)/$(DISTRO)/pool/main/*/*/`basename $$changefile|sed 's/$(ARCH)/*/'` ] || \
	reprepro --ignore=wrongdistribution $(ASKPASS) \
		-Vb $(REPODIR)/$(DISTRO) include $(DISTRIB) $$changefile; \
	done

#
# What to do for each package
#
# This can be used to export
#[ -d $@ ] || git archive --format=tar --remote=$(PKG) master | (mkdir $@ && cd $@ && tar xf -)
# Submodules are added like this :
#[ -d $@ ] || git submodule add $(PKG)
#
# Submodules are :
# TULEAP=https://github.com/Enalean/tuleap.git
# FORGEUPG=https://github.com/vaceletm/ForgeUpgrade.git
# JPGRAPH=https://github.com/cbayle/jpgraph-tuleap.git
#  cloned from gitolite@tuleap.net:tuleap/deps/tuleap/jpgraph-tuleap.git
# MAILMAN=https://github.com/cbayle/mailman-tuleap.git
#  cloned from gitolite@tuleap.net:tuleap/deps/tuleap/mailman-tuleap.git
# VIEWVC=https://github.com/cbayle/viewvc-tuleap.git
#  cloned from gitolite@tuleap.net:tuleap/deps/tuleap/viewvc-tuleap.git 
# OPENFIREPLUGIN=https://github.com/cbayle/openfire-tuleap-plugins.git
#  cloned from gitolite@tuleap.net:tuleap/deps/tuleap/openfire-tuleap-plugins.git
# MAILMBOX=https://alioth.debian.org/anonscm/git/pkg-php/php-mail-mbox.git

#TODO should find a way to build this too
openfire:

#
# Now each target will build debian src package
#
$(BUILDDIR)/tuleap: tuleap/debian/changelog
	(cd $(BUILDDIR)/src ; dpkg-source -b $(CURDIR)/tuleap && touch $@)

$(BUILDDIR)/forgeupgrade:
	(cd $(BUILDDIR)/src ; dpkg-source -b $(CURDIR)/forgeupgrade && touch $@)

MMBOX_VERSION=0.6.3
$(BUILDDIR)/php-mail-mbox: php-mail-mbox/.git
	cp -a php-mail-mbox $(BUILDDIR)/
	(cd $@ ; tar czf $(BUILDDIR)/src/php-mail-mbox_$(MMBOX_VERSION).orig.tar.gz Mail_Mbox-* package.xml)
	(cd $(BUILDDIR)/src ; dpkg-source -b $@)

JPGRAPH_VERSION=2.3.4
$(BUILDDIR)/jpgraph-tuleap: jpgraph-tuleap/.git
	cp jpgraph-tuleap/jpgraph-$(JPGRAPH_VERSION).tar.gz $(BUILDDIR)/jpgraph-tuleap_$(JPGRAPH_VERSION).orig.tar.gz
	(cd $(BUILDDIR) ; tar xzf jpgraph-tuleap_$(JPGRAPH_VERSION).orig.tar.gz ; mv jpgraph-$(JPGRAPH_VERSION) jpgraph-tuleap)
	cp -a jpgraph-tuleap/debian $@
	mv $(BUILDDIR)/jpgraph-tuleap_$(JPGRAPH_VERSION).orig.tar.gz $(BUILDDIR)/src/
	(cd $(BUILDDIR)/src ; dpkg-source -b $@)

$(BUILDDIR)/mailman-tuleap: mailman-tuleap/.git
	cp -a mailman-tuleap/mailman-tuleap $(BUILDDIR)/
	(cd $(BUILDDIR)/src ; dpkg-source -b $@)

VIEWVC_VERSION=1.0.7
$(BUILDDIR)/viewvc-tuleap: viewvc-tuleap/.git
	cp viewvc-tuleap/viewvc-$(VIEWVC_VERSION).tar.gz $(BUILDDIR)/viewvc-tuleap_$(VIEWVC_VERSION).orig.tar.gz
	(cd $(BUILDDIR) ; tar xzf viewvc-tuleap_$(VIEWVC_VERSION).orig.tar.gz ; mv viewvc-$(VIEWVC_VERSION) viewvc-tuleap)
	cp -a viewvc-tuleap/debian $@
	mv $(BUILDDIR)/viewvc-tuleap_$(VIEWVC_VERSION).orig.tar.gz $(BUILDDIR)/src/
	(cd $(BUILDDIR)/src ; dpkg-source -b $@)

$(BUILDDIR)/openfire-tuleap-plugins: openfire-tuleap-plugins/.git
	(cd $(BUILDDIR)/src ; dpkg-source -b $(CURDIR)/openfire-tuleap-plugins && touch $@)

$(BUILDDIR)/openfire: $(BUILDDIR)/deb
	@(cd $(BUILDDIR)/deb ; [ -f openfire_3.7.1_all.deb ] || wget http://pkg.tuleap.net/debian/pool/main/o/openfire/openfire_3.7.1_all.deb)

#
# Some directories
#
$(BUILDDIR):
	[ -d $@ ] || mkdir $@

$(BUILDDIR)/src:
	[ -d $@ ] || mkdir $@

$(BUILDDIR)/deb:
	[ -d $@ ] || mkdir $@

$(PBUILDERRESULTDIR):
	[ -d $@ ] || mkdir $@

#
# Prepare repository
#
preparerepo:
	@[ -d $(REPODIR)/$(DISTRO)/pool ] || make -C repo

%/.git:
	git submodule init
	git submodule update

depends: /usr/share/build-essential /usr/sbin/pbuilder

/usr/share/build-essential:
	sudo apt-get -y install build-essential pbuilder
