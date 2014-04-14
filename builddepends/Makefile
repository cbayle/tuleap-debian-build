# List of package to build
NPM_DEPS=node-ansi node-ansi-color-table node-archy node-block-stream node-fstream node-fstream-ignore node-github-url-from-git node-graceful-fs node-ini node-lockfile node-mkdirp node-gyp node-npmlog node-once node-osenv node-read node-read-package-json node-request node-retry node-rimraf 
NPMGYP_DEPS=node-request node-tar node-which
NPMREQ_DEPS=node-uuid node-mime node-forever-agent node-tunnel-agent node-json-stringify-safe node-qs node-cookie-jar node-form-data node-combined-stream node-async node-delayed-stream node-mute-stream node-read-package-json node-normalize-package-data node-sha node-slide
PKGLIST=php-mail-mbox node-lru-cache node-sigmund node-minimatch node-inherits node-glob uglifyjs node-nopt node-abbrev $(NPM_DEPS) $(NPMGYP_DEPS) $(NPMREQ_DEPS)
PKGPATCHED=twitter-recess less.js-1.3.3 mediawiki

# 2nd list of packages who requires first list to be built
PKGLIST2=npm colors.js underscore node-semver
# You can use the following as a make argument make BUILDDIR=/some/place
BUILDDIR=$(HOME)/build
# This will make a list of build/src_builddeps/<pkg1> build/...
PKGBUILDDIR=$(patsubst %,$(BUILDDIR)/src_builddeps/%,$(PKGLIST))
PKGBUILDDIR2=$(patsubst %,$(BUILDDIR)/src_builddeps/%,$(PKGLIST2))

PBUILDERRESULTDIR=$(BUILDDIR)/result_builddeps
REPODIR=/var/www/localrepo
DISTRO=debian
DISTRIB=wheezy
SRCDISTRIB=sid
DEBREPO=http://cdn.debian.net/debian
LOCALREPO=http://127.0.0.1/localrepo/$(DISTRO)
ARCH:=$(shell dpkg-architecture -qDEB_BUILD_ARCH 2>/dev/null)
ASKPASS=--ask-passphrase
ASKPASS=
PBUILDEROPS=--distribution $(DISTRIB) --othermirror 'deb $(DEBREPO) $(DISTRIB)-backports main'
PBUILDEROPS2=--distribution $(DISTRIB) --othermirror 'deb $(LOCALREPO) $(DISTRIB) main|deb $(DEBREPO) $(DISTRIB)-backports main' --keyring $(REPODIR)/botkey.gpg --override-config
PHASE=1
GREEN=[01;32m
RED=[01;31m
NORMAL=[00m


default: depends getsource buildbin fillrepo buildbin2 buildpatched

default2: getsource buildbin fillrepo

default3: buildbin fillrepo

$(PBUILDERRESULTDIR)/preparebuildbin2: $(PBUILDERRESULTDIR)
	[ -f $@ ] || sudo pbuilder --update $(PBUILDEROPS2) 
	[ -f $@ ] || sudo pbuilder --update $(PBUILDEROPS2) 
	touch $@

buildpatched:
	make -C patched
	make PKGLIST="$(PKGPATCHED)" PBUILDEROPS="$(PBUILDEROPS2)" PHASE=3 default3

buildbin2: $(PBUILDERRESULTDIR)/preparebuildbin2
	@make PKGLIST="$(PKGLIST2)" PBUILDEROPS="$(PBUILDEROPS2)" PHASE=2 default2

getsource: $(BUILDDIR) $(BUILDDIR)/src_builddeps $(BUILDDIR)/apt
	@echo "Get Source"
	@[ -f $(BUILDDIR)/src_builddeps/done ] || apt-get -qq \
		-o Dir=$(BUILDDIR)/apt \
		-o Debug::NoLocking=1 \
		-o Dir::Etc::SourceList="$(CURDIR)/sources.list" \
		update
	@cd $(BUILDDIR)/src_builddeps ; \
	[ -f $(BUILDDIR)/src_builddeps/done ] || apt-get -qq \
		-o Dir=$(BUILDDIR)/apt \
		-o Debug::NoLocking=1 \
		-o Dir::Etc::SourceList="$(CURDIR)/sources.list" \
		source --download-only $(PKGLIST)
	@#touch $(BUILDDIR)/src_builddeps/done

cleanpbuilder:
	rm $(PBUILDERRESULTDIR)/preparebuildbin

cleanpbuilder2:
	rm $(PBUILDERRESULTDIR)/preparebuildbin2

$(PBUILDERRESULTDIR)/preparebuildbin: $(PBUILDERRESULTDIR)
	[ -f $@ ] || sudo pbuilder --create $(PBUILDEROPS)
	touch $@

buildbin: $(PBUILDERRESULTDIR)/preparebuildbin $(PBUILDERRESULTDIR)
	@echo "Build phase $(PHASE)"
	@for pkg in $(PKGBUILDDIR); do \
		filename=`expr "$${pkg}_*.dsc"`; \
		basename=`basename $$filename`; \
		if [ -f $$filename ]; then \
			if [ ! -f $(PBUILDERRESULTDIR)/$$basename ]; then\
				( \
				echo "===== Building $$basename =====" ;\
				sudo pbuilder --build $(PBUILDEROPS) --buildresult $(PBUILDERRESULTDIR) $$filename; \
				) \
			else \
				echo "===== Already build $$basename =====" ;\
			fi \
		else \
			echo "===== Could not find source for $$pkg =====" ;\
		fi; \
	done

fillrepo: preparerepo $(REPODIR)
	@for changefile in $(shell ls $(PBUILDERRESULTDIR)/*.changes); do \
	[ -f $(REPODIR)/$(DISTRO)/pool/main/*/*/`basename $$changefile|sed 's/$(ARCH)/*/'` ] || \
	reprepro --ignore=wrongdistribution --ignore=missingfile $(ASKPASS) \
		-Vb $(REPODIR)/$(DISTRO) include $(DISTRIB) $$changefile; \
	done

list:
	@for pkg in $(PKGBUILDDIR) $(PKGBUILDDIR2); do \
		filename=`expr "$${pkg}_*.dsc"`; \
		if [ -f $$filename ]; then \
			basename=`basename $$filename`; \
			basepkg=`echo $$basename|cut -d"_" -f1`; \
			baseletter=`echo $$basepkg|cut -c1`; \
			poolname="$(REPODIR)/$(DISTRO)/pool/main/$$baseletter/$$basepkg/$$basename"; \
			if [ -f "$$poolname" ]; then \
				echo "$(GREEN)[OK]$(NORMAL) $$basename" ; \
			else \
				echo "$(RED)[K0]$(NORMAL) $$basename" ; \
			fi;\
		else \
			echo "$$pkg not found";\
		fi; \
	done

$(RESULDIR)/%.dsc:
	sudo pbuilder --build $(shell basename $@) --debbuildopts -sa

#
# Prepare repository
#
preparerepo:
	@[ -d $(REPODIR)/$(DISTRO)/pool ] || make -C ../repo

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

depends: /usr/lib/cdbs

/usr/lib/cdbs:
	sudo apt-get install cdbs
