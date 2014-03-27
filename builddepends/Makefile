# List of package to build
PKGLIST=node-lru-cache node-sigmund node-minimatch node-inherits node-glob npm twitter-recess colors.js node-nopt underscore node-abbrev
# You can use the following as a make argument make BUILDDIR=/some/place
BUILDDIR=$(HOME)/build
# This will make a list of build/<pkg1> build/...
PKGBUILDDIR=$(patsubst %,$(BUILDDIR)/%,$(PKGLIST))

PBUILDERRESULTDIR=$(HOME)/pbuilder_result_builddeps
REPODIR=/var/www/localrepo
DISTRO=debian
DISTRIB=wheezy
SRCDISTRIB=sid
ARCH:=$(shell dpkg-architecture -qDEB_BUILD_ARCH 2>/dev/null)
ASKPASS=--ask-passphrase
ASKPASS=

default: depends getsource buildbin

getsource: $(BUILDDIR) $(BUILDDIR)/src_builddeps $(BUILDDIR)/apt
	[ -f $(BUILDDIR)/src_builddeps/done ] || apt-get \
		-o Dir=$(BUILDDIR)/apt \
		-o Debug::NoLocking=1 \
		-o Dir::Etc::SourceList="$(CURDIR)/sources.list" \
		update
	cd $(BUILDDIR)/src_builddeps ; \
	[ -f $(BUILDDIR)/src_builddeps/done ] || apt-get \
		-o Dir=$(BUILDDIR)/apt \
		-o Debug::NoLocking=1 \
		-o Dir::Etc::SourceList="$(CURDIR)/sources.list" \
		source --download-only $(PKGLIST)
	touch $(BUILDDIR)/src_builddeps/done

buildbin: $(PBUILDERRESULTDIR)
	@for dscfile in $(shell ls $(BUILDDIR)//src_builddeps/*.dsc); do \
	[ -f $(PBUILDERRESULTDIR)/`basename $$dscfile` ] || \
	sudo pbuilder --build --buildresult $(PBUILDERRESULTDIR) $$dscfile; \
	done

fillrepo: preparerepo $(REPODIR)
	@for changefile in $(shell ls $(PBUILDERRESULTDIR)/*.changes); do \
	[ -f $(REPODIR)/$(DISTRO)/pool/main/*/*/`basename $$changefile|sed 's/$(ARCH)/*/'` ] || \
	reprepro --ignore=wrongdistribution $(ASKPASS) \
		-Vb $(REPODIR)/$(DISTRO) include $(DISTRIB) $$changefile; \
	done

default2:	$(RESULTDIR)/node-lru-cache_2.3.1-1.dsc \
		$(RESULTDIR)/node-sigmund_1.0.0-1.dsc \
		$(RESULTDIR)/node-minimatch_0.2.12-1.dsc \
		$(RESULTDIR)/node-inherits_2.0.0-1.dsc \
		$(RESULTDIR)/node-glob_3.2.6-1.dsc \
		$(RESULTDIR)/npm_1.4.4+ds-1.dsc \
		$(RESULTDIR)/twitter-recess_1.1.9-1.dsc \
		$(RESULTDIR)/colors.js_0.6.2-1.dsc \
		$(RESULTDIR)/node-nopt_2.1.2-1.dsc \
		$(RESULTDIR)/underscore_1.4.4-2.dsc \
		$(RESULTDIR)/node-abbrev_1.0.4-2.dsc


$(RESULDIR)/%.dsc:
	sudo pbuilder --build $(shell basename $@) --debbuildopts -sa

repoadd:
	cd $(RESULTDIR); reprepro --ignore=wrongdistribution $(ASKPASS) -Vb $(REPODIR)/debian include $(DISTRIB) node-glob_3.2.6-1_i386.changes
	cd $(RESULTDIR); reprepro --ignore=wrongdistribution $(ASKPASS) -Vb $(REPODIR)/debian include $(DISTRIB) node-minimatch_0.2.12-1_i386.changes
	cd $(RESULTDIR); reprepro --ignore=wrongdistribution $(ASKPASS) -Vb $(REPODIR)/debian include $(DISTRIB) node-inherits_2.0.0-1_i386.changes
	cd $(RESULTDIR); reprepro --ignore=wrongdistribution $(ASKPASS) -Vb $(REPODIR)/debian include $(DISTRIB) node-lru-cache_2.3.1-1_i386.changes
	cd $(RESULTDIR); reprepro --ignore=wrongdistribution $(ASKPASS) -Vb $(REPODIR)/debian include $(DISTRIB) node-sigmund_1.0.0-1_i386.changes
	cd $(RESULTDIR); reprepro --ignore=wrongdistribution $(ASKPASS) -Vb $(REPODIR)/debian include $(DISTRIB) npm_1.4.4+ds-1_i386.changes
	cd $(RESULTDIR); reprepro --ignore=wrongdistribution $(ASKPASS) -Vb $(REPODIR)/debian include $(DISTRIB) twitter-recess_1.1.9-1_i386.changes
	cd $(RESULTDIR); reprepro --ignore=wrongdistribution $(ASKPASS) -Vb $(REPODIR)/debian include $(DISTRIB) colors.js_0.6.2-1_i386.changes
	cd $(RESULTDIR); reprepro --ignore=wrongdistribution $(ASKPASS) -Vb $(REPODIR)/debian include $(DISTRIB) node-nopt_2.1.2-1_i386.changes
	cd $(RESULTDIR); reprepro --ignore=missingfile --ignore=wrongdistribution $(ASKPASS) -Vb $(REPODIR)/debian include $(DISTRIB) underscore_1.4.4-2_i386.changes
	cd $(RESULTDIR); reprepro --ignore=missingfile --ignore=wrongdistribution $(ASKPASS) -Vb $(REPODIR)/debian include $(DISTRIB) node-abbrev_1.0.4-2_i386.changes

get:
	dget http://ftp.de.debian.org/debian/pool/main/n/npm/npm_1.4.4+ds-1.dsc
	dget http://ftp.de.debian.org/debian/pool/main/t/twitter-recess/twitter-recess_1.1.9-1.dsc
	dget http://ftp.de.debian.org/debian/pool/main/n/node-glob/node-glob_3.2.6-1.dsc
	#dget http://ftp.de.debian.org/debian/pool/main/n/nodejs/nodejs_0.10.26~dfsg1-1.dsc
	dget http://ftp.de.debian.org/debian/pool/main/n/node-minimatch/node-minimatch_0.2.12-1.dsc
	dget http://ftp.de.debian.org/debian/pool/main/n/node-inherits/node-inherits_2.0.0-1.dsc
	dget http://ftp.de.debian.org/debian/pool/main/n/node-lru-cache/node-lru-cache_2.3.1-1.dsc
	dget http://ftp.de.debian.org/debian/pool/main/n/node-sigmund/node-sigmund_1.0.0-1.dsc
	dget http://ftp.de.debian.org/debian/pool/main/c/colors.js/colors.js_0.6.2-1.dsc
	dget http://ftp.de.debian.org/debian/pool/main/n/node-nopt/node-nopt_2.1.2-1.dsc
	dget http://ftp.de.debian.org/debian/pool/main/u/underscore/underscore_1.4.4-2.dsc
	dget http://ftp.de.debian.org/debian/pool/main/n/node-abbrev/node-abbrev_1.0.4-2.dsc

#
# Prepare repository
#
preparerepo:
	@[ -d $(REPODIR)/$(DISTRO)/pool ] || make -C repo

#
# Some directories
#
$(BUILDDIR):
	[ -d $@ ] || mkdir $@

$(BUILDDIR)/apt:
	[ -d $@ ] || mkdir $@
	[ -d $@/etc/apt/sources.list.d ] || mkdir -p $@/etc/apt/sources.list.d
	[ -d $@/var/lib/apt/lists/partial ] || mkdir -p $@/var/lib/apt/lists/partial
	[ -d $@/var/cache/apt/lists/partial ] || mkdir -p $@/var/cache/apt/lists/partial
	[ -d $@/etc/apt/preferences.d ] || mkdir -p $@/etc/apt/preferences.d

$(BUILDDIR)/src_builddeps:
	[ -d $@ ] || mkdir $@

$(PBUILDERRESULTDIR):
	[ -d $@ ] || mkdir $@

depends:
