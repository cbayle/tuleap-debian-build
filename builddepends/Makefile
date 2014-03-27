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

$(RESULDIR)/%.dsc:
	sudo pbuilder --build $(shell basename $@) --debbuildopts -sa

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
