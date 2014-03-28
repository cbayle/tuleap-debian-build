# List of package to build
NPM_DEPS=node-ansi node-ansi-color-table node-archy node-block-stream node-fstream node-fstream-ignore node-github-url-from-git node-graceful-fs node-ini node-lockfile node-mkdirp node-gyp node-npmlog node-once node-osenv node-read node-read-package-json node-request node-retry node-rimraf 
NPMGYP_DEPS=node-request node-tar node-which
NPMREQ_DEPS=node-node-uuid node-mime node-forever-agent node-tunnel-agent node-json-stringify-safe node-qs node-cookie-jar node-form-data node-combined-stream node-async node-delayed-stream node-mute-stream node-read-package-json node-normalize-package-data node-sha node-slide
PKGLIST=less.js node-lru-cache node-sigmund node-minimatch node-inherits node-glob uglifyjs twitter-recess node-nopt node-abbrev $(NPM_DEPS) $(NPMGYP_DEPS) $(NPMREQ_DEPS)

# 2nd list of packages who requires first list to be built
PKGLIST2=npm colors.js underscore node-semver
# You can use the following as a make argument make BUILDDIR=/some/place
BUILDDIR=$(HOME)/build
# This will make a list of build/<pkg1> build/...
PKGBUILDDIR=$(patsubst %,$(BUILDDIR)/src_builddeps/%,$(PKGLIST))

PBUILDERRESULTDIR=$(BUILDDIR)/result_builddeps
REPODIR=/var/www/localrepo
DISTRO=debian
DISTRIB=wheezy
SRCDISTRIB=sid
ARCH:=$(shell dpkg-architecture -qDEB_BUILD_ARCH 2>/dev/null)
ASKPASS=--ask-passphrase
ASKPASS=
PBUILDEROPS=--distribution $(DISTRIB)
PBUILDEROPS2=--distribution $(DISTRIB) --othermirror 'deb http://127.0.0.1/localrepo/debian $(DISTRIB) main|deb http://cdn.debian.net/debian $(DISTRIB)-backports main' --keyring $(REPODIR)/botkey.gpg --override-config

default: depends getsource buildbin fillrepo buildbin2

default2: getsource buildbin fillrepo

$(PBUILDERRESULTDIR)/preparebuildbin2: $(PBUILDERRESULTDIR)
	sudo pbuilder --update $(PBUILDEROPS2) 
	touch $@

buildbin2: $(PBUILDERRESULTDIR)/preparebuildbin2
	make PKGLIST="$(PKGLIST2)" PBUILDEROPS="$(PBUILDEROPS2)" default2

getsource: $(BUILDDIR) $(BUILDDIR)/src_builddeps $(BUILDDIR)/apt
	@[ -f $(BUILDDIR)/src_builddeps/done ] || apt-get \
		-o Dir=$(BUILDDIR)/apt \
		-o Debug::NoLocking=1 \
		-o Dir::Etc::SourceList="$(CURDIR)/sources.list" \
		update
	@cd $(BUILDDIR)/src_builddeps ; \
	[ -f $(BUILDDIR)/src_builddeps/done ] || apt-get \
		-o Dir=$(BUILDDIR)/apt \
		-o Debug::NoLocking=1 \
		-o Dir::Etc::SourceList="$(CURDIR)/sources.list" \
		source --download-only $(PKGLIST)
	#@touch $(BUILDDIR)/src_builddeps/done

$(PBUILDERRESULTDIR)/preparebuildbin: $(PBUILDERRESULTDIR)
	sudo pbuilder --create $(PBUILDEROPS)
	touch $@

buildbin: $(PBUILDERRESULTDIR)/preparebuildbin $(PBUILDERRESULTDIR)
	@for dscfile in $(shell ls $(BUILDDIR)/src_builddeps/*.dsc); do \
	[ -f $(PBUILDERRESULTDIR)/`basename $$dscfile` ] || \
	( \
	echo "===== Building $$dscfile =====" ;\
	sudo pbuilder --build $(PBUILDEROPS) --buildresult $(PBUILDERRESULTDIR) $$dscfile; \
	) \
	done

fillrepo: preparerepo $(REPODIR)
	@for changefile in $(shell ls $(PBUILDERRESULTDIR)/*.changes); do \
	[ -f $(REPODIR)/$(DISTRO)/pool/main/*/*/`basename $$changefile|sed 's/$(ARCH)/*/'` ] || \
	reprepro --ignore=wrongdistribution --ignore=missingfile $(ASKPASS) \
		-Vb $(REPODIR)/$(DISTRO) include $(DISTRIB) $$changefile; \
	done

list:
	for pkg in $(PKGBUILDDIR); do \
		ls $${pkg}*.dsc ;\
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
	[ -d $@ ] || mkdir -p $@

depends:
